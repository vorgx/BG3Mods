"""Undo a fix or update: restore modsettings.lsx and move replaced paks back from a ModCheck backup.

  python restore.py            list backups
  python restore.py latest     restore the newest backup
  python restore.py <folder>   restore a specific backup (folder name or full path)
"""
import json, os, shutil, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import bg3lib as L

backups = sorted(d for d in os.listdir(L.BACKUPS)) if os.path.isdir(L.BACKUPS) else []
if len(sys.argv) < 2:
    if not backups:
        print("[INFO] No backups yet.")
    for d in backups:
        j = json.load(open(os.path.join(L.BACKUPS, d, "backup.json"), encoding="utf-8"))
        print(f"  {d}   ({len(j['moved_paks'])} paks replaced)")
    sys.exit(0)

arg = sys.argv[1]
d = os.path.join(L.BACKUPS, backups[-1]) if arg == "latest" and backups else arg if os.path.isabs(arg) else os.path.join(L.BACKUPS, arg)
if not os.path.exists(os.path.join(d, "backup.json")):
    sys.exit(f"[FAIL] Not a ModCheck backup: {d}")
if L.bg3_running():
    sys.exit("[FAIL] Baldur's Gate 3 is running. Close it first.")

j = json.load(open(os.path.join(d, "backup.json"), encoding="utf-8"))
rolled = os.path.join(d, "_rolled_back")
for added in j.get("added_paks", []):
    if os.path.exists(added):
        os.makedirs(rolled, exist_ok=True)
        shutil.move(added, os.path.join(rolled, os.path.basename(added)))
        print(f"[INFO] Removed newly installed {os.path.basename(added)}")
for m in reversed(j["moved_paks"]):
    if m.get("replaced_by") and os.path.exists(m["replaced_by"]):
        os.makedirs(rolled, exist_ok=True)
        shutil.move(m["replaced_by"], os.path.join(rolled, os.path.basename(m["replaced_by"])))
        print(f"[INFO] Moved out {os.path.basename(m['replaced_by'])}")
    if os.path.exists(m["backup"]):
        shutil.move(m["backup"], m["original"])
        print(f"[INFO] Restored {os.path.basename(m['original'])}")
shutil.copy2(os.path.join(d, "modsettings.lsx"), j["modsettings"])
print(f"[PASS] Restored modsettings.lsx from {os.path.basename(d)}")
