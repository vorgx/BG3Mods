"""Apply the recommended load order to modsettings.lsx (dry run unless --apply). Always backs up first.

  python fix_order.py                         show what would change
  python fix_order.py --apply                 write the recommended order
  python fix_order.py --apply --disable X.pak take X out of the load order (the pak stays in the Mods folder)
  python fix_order.py --apply --enable X.pak  add an installed but inactive pak (placed above Compatibility Framework)
"""
import argparse, json, os, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import bg3lib as L

ap = argparse.ArgumentParser()
ap.add_argument("--apply", action="store_true")
ap.add_argument("--disable", nargs="*", default=[], help="pak file names to take out of the load order")
ap.add_argument("--enable", nargs="*", default=[], help="installed pak file names to add to the load order")
ap.add_argument("--order", default=os.path.join(L.WORK, "recommended_order.json"))
args = ap.parse_args()

rec = json.load(open(args.order, encoding="utf-8")) if os.path.exists(args.order) else None
lo = L.load("lo_report.json")
if not rec or not lo:
    sys.exit("[FAIL] Run Run-ModCheck.ps1 first: no recommended order found.")

text, match, nodes = L.read_modsettings()
by_uuid = {n["uuid"]: n for n in nodes}
uuid_of_pak = {m["pak"].lower(): m["uuid"] for m in lo["current"]}


def pak_uuid(name):
    u = uuid_of_pak.get(name.lower())
    if u:
        return u
    p = os.path.join(L.MODS, name)
    if os.path.exists(p):
        return L.scan_pak(p, want_stats=False).get("uuid")
    sys.exit(f"[FAIL] {name} isn't in the Mods folder.")


disable = {pak_uuid(p) for p in args.disable}
builtins = [n for n in nodes if L.BUILTIN.match(n["name"] or "") or L.BUILTIN.match(n["folder"] or "")]
want = [o["UUID"].lower() for o in rec["Order"] if o["UUID"].lower() not in disable]
missing = [u for u in want if u not in by_uuid]
if missing:
    sys.exit(f"[FAIL] The recommended order has {len(missing)} mods that aren't in modsettings.lsx. Re-run Run-ModCheck.ps1.")
leftover = [n for n in nodes if n not in builtins and n["uuid"] not in want and n["uuid"] not in disable]

new_nodes = builtins + [by_uuid[u] for u in want] + leftover
raws = [n["raw"] for n in new_nodes]

# newly enabled paks go just above Compatibility Framework, which must stay last
added = []
for name in args.enable:
    info = L.scan_pak(os.path.join(L.MODS, name), want_stats=False)
    if info["uuid"] in by_uuid:
        print(f"[INFO] {name} is already in the load order.")
        continue
    raw = L.entry_xml(info["folder"], info["name"], info["uuid"], info["v64"], L.file_md5(os.path.join(L.MODS, name)))
    cf = next((i for i, n in enumerate(new_nodes) if "compatibilityframework" in (n["folder"] or "").lower().replace(" ", "")), None)
    pos = cf if cf is not None else len(raws)
    raws.insert(pos, raw)
    new_nodes.insert(pos, {"raw": raw, "uuid": info["uuid"], "name": info["name"], "folder": info["folder"]})
    added.append(info["name"])

old_pos = {n["uuid"]: i for i, n in enumerate(nodes)}
moved = [m for m in lo["recommended"] if m["moved"] and m["uuid"] not in disable]
removed = [n["name"] for n in nodes if n["uuid"] in disable]
print(f"[INFO] Load order: {len(nodes)} entries now, {len(raws)} after the change.")
for m in moved:
    print(f"[INFO] Move  {m['name']}: {m['cur']} -> {m['rec']}  ({m['why']})")
for n in removed:
    print(f"[INFO] Disable {n} (the pak stays in the Mods folder; re-enable with --enable)")
for n in added:
    print(f"[INFO] Enable {n} (placed above Compatibility Framework)")
for n in leftover:
    print(f"[WARN] {n['name']} has no pak installed; kept at the end of the list.")
if raws == [n["raw"] for n in nodes]:
    print("[PASS] Nothing to change: modsettings.lsx already matches.")
    sys.exit(0)
if not args.apply:
    print("[INFO] Dry run. Add --apply to write these changes (a backup is made first).")
    sys.exit(0)
if L.bg3_running():
    sys.exit("[FAIL] Baldur's Gate 3 is running. Close it first; the game rewrites modsettings.lsx on exit.")

bdir = L.new_backup_dir("load-order")
L.backup_modsettings(bdir)
L.write_modsettings(text, match, raws)
_, _, check = L.read_modsettings()
assert [n["uuid"] for n in check] == [n["uuid"] for n in new_nodes], "write verification failed"
print(f"[PASS] modsettings.lsx updated ({len(check)} entries). Backup: {bdir}")
print("[INFO] If you use BG3 Mod Manager, import the same order there (File > Import Order from File) "
      "or its next Export will overwrite this.")
