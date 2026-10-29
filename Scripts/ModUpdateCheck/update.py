"""Download and install mod updates found by the last Run-ModCheck.ps1 run.

  python update.py                          show the download plan (nothing is downloaded)
  python update.py --only Rebalance Goon    plan only mods whose pak or name contains one of these words
  python update.py --apply --yes [...]      download, back up the old paks, install the new ones
  python update.py --remove-obsolete ...    also move paks marked obsolete out of Mods and the load order

Old paks are moved (not deleted) into Backups/ModCheck/<time>_update/paks; restore.py undoes a run.
Mods installed through the in-game mod manager (mod.io) are updated from mod.io so the game keeps tracking them.
"""
import argparse, json, os, re, shutil, sys, time
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import bg3lib as L

ap = argparse.ArgumentParser()
ap.add_argument("--only", nargs="*", default=[])
ap.add_argument("--apply", action="store_true")
ap.add_argument("--yes", action="store_true", help="confirm downloading and installing")
ap.add_argument("--remove-obsolete", action="store_true")
args = ap.parse_args()

report = L.load("report.json")
verify = L.load("verify.json", {})
nexus = L.load("nexus_cache.json", {})
modio = (L.load("modio_cache.json") or {}).get("mods", {})
lo = L.load("lo_report.json")
if not report or not lo:
    sys.exit("[FAIL] Run Run-ModCheck.ps1 first.")
uuid_of = {m["pak"]: m["uuid"] for m in lo["current"]}
_, _, nodes = L.read_modsettings()
publish = {n["uuid"]: re.search(r'id="PublishHandle" type="[^"]+" value="(\d+)"', n["raw"]).group(1) for n in nodes}


def wanted(m):
    if not args.only:
        return True
    hay = f"{m['pak']} {m.get('name')}".lower()
    return any(w.lower() in hay for w in args.only)


def nexus_target(m, s):
    files = nexus.get(str(s["id"]), {}).get("files", {}).get("files", [])
    v = verify.get(m["pak"], {})
    fid = (v.get("latest") or {}).get("file_id") if v.get("result") in ("differs", "outdated", "size-differs") else None
    f = next((f for f in files if f["file_id"] == fid), None)
    if not f:
        cands = [f for f in files if f.get("category_name") in L.ACTIVE and f.get("name") == s.get("latest_file")]
        f = max(cands, key=lambda f: f["uploaded_timestamp"]) if cands else None
    if not f:
        return None
    return {"source": "nexus", "mod_id": s["id"], "file_id": f["file_id"], "archive": f["file_name"], "title": f["name"],
            "version": f.get("version"), "size": f.get("size_in_bytes") or (f.get("size_kb") or 0) * 1024,
            "page": f"https://www.nexusmods.com/baldursgate3/mods/{s['id']}?tab=files&file_id={f['file_id']}"}


def modio_target(m, s):
    mod = modio.get(str(s["id"]))
    mf = (mod or {}).get("modfile") or {}
    if not mf.get("download"):
        return None
    return {"source": "modio", "mod_id": s["id"], "file_id": mf["id"], "archive": mf["filename"], "title": mod["name"],
            "version": mf.get("version"), "size": mf.get("filesize"), "url": mf["download"]["binary_url"], "page": mod.get("profile_url")}


plan, skipped = {}, []
for m in report["mods"]:
    if m["status"] != "update" or not wanted(m):
        continue
    by = {s["source"]: s for s in m["sources"] if s["status"] == "update"} or {s["source"]: s for s in m["sources"]}
    via_game = publish.get(m.get("uuid") or uuid_of.get(m["pak"], ""), "0") not in ("0", None)
    t = None
    if via_game and "modio" in by:
        t = modio_target(m, by["modio"])
    if not t and "nexus" in by:
        t = nexus_target(m, by["nexus"])
    if not t and "modio" in by:
        t = modio_target(m, by["modio"])
    if not t:
        skipped.append((m["pak"], "no downloadable file found"))
        continue
    if L.is_downgrade(m.get("version"), t.get("version")):
        skipped.append((m["pak"], f"the download ({t.get('version')}) is older than yours ({m.get('version')})"))
        continue
    key = (t["source"], t["mod_id"], t["file_id"])
    plan.setdefault(key, {**t, "paks": []})["paks"].append({"pak": m["pak"], "name": m.get("name"), "uuid": m.get("uuid"),
                                                            "from": m.get("version"), "via_game": via_game})

obsolete = [m for m in report["mods"] if m["status"] == "obsolete" and wanted(m)] if args.remove_obsolete else []

total = sum(p["size"] or 0 for p in plan.values())
print(f"[INFO] {len(plan)} downloads ({total / 1e6:.0f} MB) for {sum(len(p['paks']) for p in plan.values())} paks:")
for p in sorted(plan.values(), key=lambda p: p["paks"][0]["name"] or ""):
    names = ", ".join(f"{x['name']} {x['from']}" for x in p["paks"])
    print(f"  - {names} -> {p['version']}  [{p['source']}: {p['archive']}, {(p['size'] or 0) / 1e6:.1f} MB]")
for pak, why in skipped:
    print(f"[WARN] {pak}: {why}")
for m in obsolete:
    print(f"[INFO] Remove obsolete {m['pak']}")
if not args.apply:
    print("[INFO] Plan only. Add --apply --yes to download and install (old paks are backed up first).")
    sys.exit(0)
if not args.yes:
    sys.exit("[FAIL] --apply needs --yes to confirm the downloads.")
if L.bg3_running():
    sys.exit("[FAIL] Baldur's Gate 3 is running. Close it first.")

bdir = L.new_backup_dir("update")
L.backup_modsettings(bdir)
os.makedirs(os.path.join(bdir, "paks"), exist_ok=True)
dl_root = os.path.join(L.WORK, "downloads", os.path.basename(bdir))
text, match, nodes = L.read_modsettings()
raws = [n["raw"] for n in nodes]
idx = {n["uuid"]: i for i, n in enumerate(nodes)}
done, failed = [], []


def move_out(pak, replaced_by=None):
    src = os.path.join(L.MODS, pak)
    dst = os.path.join(bdir, "paks", pak)
    shutil.move(src, dst)
    L.record_moved_pak(bdir, src, dst, replaced_by)


for key, p in plan.items():
    folder = os.path.join(dl_root, f"{p['source']}_{p['mod_id']}_{p['file_id']}")
    os.makedirs(folder, exist_ok=True)
    try:
        url = p.get("url") or L.nexus_get(f"/mods/{p['mod_id']}/files/{p['file_id']}/download_link.json")[0]["URI"]
        archive = os.path.join(folder, re.sub(r'[<>:"/\\|?*]', "_", p["archive"]))
        print(f"[INFO] Downloading {p['archive']} ...")
        L.download(url, archive, p.get("size"))
        L.extract(archive, os.path.join(folder, "x"))
        new = [L.scan_pak(x, want_stats=False) | {"path": x} for x in L.find_paks(os.path.join(folder, "x"))]
        for target in p["paks"]:
            hit = [n for n in new if n.get("uuid") == target["uuid"]] or [n for n in new if n["pak"].lower() == target["pak"].lower()]
            if not hit:
                failed.append((target["pak"], "no pak with the same mod UUID in the download (author may have changed it); install by hand"))
                continue
            n = hit[0]
            if L.is_downgrade(target["from"], n.get("version")):
                failed.append((target["pak"], f"downloaded pak is older ({n.get('version')}) than yours ({target['from']}); kept yours"))
                continue
            if n.get("uuid") != target["uuid"]:
                failed.append((target["pak"], "the matching pak has a different mod UUID; install by hand"))
                continue
            dest = os.path.join(L.MODS, n["pak"])
            if n["pak"].lower() != target["pak"].lower() and os.path.exists(dest):
                failed.append((target["pak"], f"new file name {n['pak']} is already taken in Mods"))
                continue
            move_out(target["pak"], replaced_by=dest)
            shutil.copy2(n["path"], dest)
            i = idx.get(target["uuid"])
            if i is not None:
                raws[i] = L.set_attr(L.set_attr(raws[i], "Version64", n["v64"]), "MD5", L.file_md5(dest))
            done.append((target["name"], target["from"], n.get("version"), n["pak"]))
        time.sleep(0.5)
    except Exception as ex:
        for target in p["paks"]:
            failed.append((target["pak"], f"{type(ex).__name__}: {ex}"))

drop = set()
for m in obsolete:
    move_out(m["pak"])
    if m.get("uuid") in idx:
        drop.add(idx[m["uuid"]])
    done.append((m.get("name"), m.get("version"), "removed", m["pak"]))
L.write_modsettings(text, match, [r for i, r in enumerate(raws) if i not in drop])

L.save("last_update.json", {"backup": bdir, "done": done, "failed": failed})
for name, a, b, pak in done:
    print(f"[PASS] {name}: {a} -> {b}  ({pak})")
for pak, why in failed:
    print(f"[FAIL] {pak}: {why}")
print(f"[INFO] Backup (old paks + modsettings.lsx): {bdir}")
print("[INFO] Undo with: python restore.py latest")
sys.exit(1 if failed and not done else 0)
