"""Due diligence on a mod you're thinking of adding: what it needs, what it overlaps with, what it might replace.

  python newmod.py <nexus or mod.io url>              page-level check (no download)
  python newmod.py <url> --download                   also download it (into work/newmods/) and compare its pak contents
                                                       with every installed pak: stat entries, action lists, loot tables, files

Writes work/newmod_<slug>.json and Reports/New_Mod_Check_<slug>_<date>.html. Never installs anything.
"""
import argparse, html, json, os, re, sys
from collections import defaultdict
from datetime import datetime
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import bg3lib as L

ap = argparse.ArgumentParser()
ap.add_argument("url")
ap.add_argument("--download", action="store_true")
ap.add_argument("--install", action="store_true", help="after the check, install it (needs --download and --yes)")
ap.add_argument("--yes", action="store_true")
ap.add_argument("--out", default=os.path.join(L.PROJECT, "Reports"))
args = ap.parse_args()

report = L.load("report.json")
lo = L.load("lo_report.json")
nexus_cache = L.load("nexus_cache.json", {})
modio_cache = (L.load("modio_cache.json") or {}).get("mods", {})
if not report or not lo:
    sys.exit("[FAIL] Run Run-ModCheck.ps1 first.")
pos = {m["pak"]: m["cur"] for m in lo["current"]}
installed = [m for m in report["mods"]]


def clean(d):
    t = re.sub(r"<br\s*/?>|</p>|</li>|</h\d>", "\n", d or "")
    t = re.sub(r"\[/?[a-z*]+(?:=[^\]]*)?\]", " ", t, flags=re.I)
    t = html.unescape(re.sub(r"<[^>]+>", " ", t))
    return re.sub(r"[ \t ﻿]+", " ", t)


# ---------- 1. fetch the page
m = re.search(r"nexusmods\.com/(?:games/)?baldursgate3/mods/(\d+)", args.url)
mm = re.search(r"mod\.io/g/baldursgate3/m/([^/#?]+)", args.url)
new = {"url": args.url, "requirements": []}
if m:
    nid = int(m.group(1))
    mod = L.nexus_get(f"/mods/{nid}.json")
    files = L.nexus_get(f"/mods/{nid}/files.json")["files"]
    mains = [f for f in files if f.get("category_name") == "MAIN"] or [f for f in files if f.get("category_name") in L.ACTIVE]
    main = max(mains, key=lambda f: f["uploaded_timestamp"]) if mains else None
    new.update(source="nexus", id=nid, name=mod["name"], author=mod.get("author"), version=mod.get("version"),
               summary=mod.get("summary") or "", description=clean(mod.get("description")), picture=mod.get("picture_url"),
               updated=mod.get("updated_timestamp"), slug=f"nexus{nid}",
               files=[{"name": f["name"], "category": f.get("category_name"), "version": f.get("version"),
                       "size": f.get("size_in_bytes"), "description": clean(f.get("description"))[:300]}
                      for f in files if f.get("category_name") in L.ACTIVE],
               download={"file_id": main["file_id"], "archive": main["file_name"], "size": main.get("size_in_bytes")} if main else None)
    q = """query($ids: [CompositeIdInput!]!) { legacyMods(ids: $ids) { nodes {
           modRequirements { nexusRequirements { nodes { modId modName notes } } } } } }"""
    node = L.nexus_graphql(q, {"ids": [{"gameId": L.NEXUS_GAME_ID, "modId": nid}]})["legacyMods"]["nodes"]
    for r in (node[0].get("modRequirements") or {}).get("nexusRequirements", {}).get("nodes", []) if node else []:
        new["requirements"].append({"name": r.get("modName"), "nexus_id": int(r["modId"]) if str(r.get("modId")).isdigit() else None,
                                    "notes": r.get("notes") or ""})
elif mm:
    mod = L.modio_get("/mods", name_id=mm.group(1))["data"][0]
    mf = mod.get("modfile") or {}
    new.update(source="modio", id=mod["id"], name=mod["name"], author=mod["submitted_by"]["username"], version=mf.get("version"),
               summary=mod.get("summary") or "", description=clean(mod.get("description")),
               picture=(mod.get("logo") or {}).get("thumb_320x180"), updated=mod.get("date_updated"), slug=f"modio{mod['id']}",
               tags=[t["name"] for t in mod.get("tags", [])], files=[],
               download={"url": mf["download"]["binary_url"], "archive": mf["filename"], "size": mf.get("filesize")} if mf.get("download") else None)
    for d in L.modio_get(f"/mods/{mod['id']}/dependencies").get("data", []):
        new["requirements"].append({"name": d.get("name"), "modio_id": d.get("mod_id"), "notes": ""})
else:
    sys.exit("[FAIL] Give a nexusmods.com/baldursgate3/mods/<id> or mod.io/g/baldursgate3/m/<name> link.")
text = f"{new['name']}\n{new['summary']}\n{new['description']}"
print(f"[INFO] {new['name']} by {new['author']} ({new['source']} {new['id']}), version {new['version']}")


# ---------- 2. requirements and "already installed?"
def src_ids(row, source):
    return {int(s["id"]) for s in row["sources"] if s["source"] == source}


def find_installed(name=None, nexus_id=None, modio_id=None):
    hits = []
    for row in installed:
        if nexus_id and nexus_id in src_ids(row, "nexus"):
            hits.append(row)
        elif modio_id and modio_id in src_ids(row, "modio"):
            hits.append(row)
    if not hits and name:
        w = [x for x in re.findall(r"[a-z0-9]+", name.lower()) if len(x) > 2 and x not in {"the", "and", "for", "mod"}]
        for row in installed:
            hay = " ".join(re.findall(r"[a-z0-9]+", f"{row['pak']} {row.get('name')} {' '.join(s.get('name') or '' for s in row['sources'])}".lower()))
            if w and all(x in hay for x in w):
                hits.append(row)
    return hits


new["already_installed"] = [r["pak"] for r in find_installed(None, new["id"] if new["source"] == "nexus" else None,
                                                            new["id"] if new["source"] == "modio" else None)]
for r in new["requirements"]:
    hits = find_installed(r["name"], r.get("nexus_id"), r.get("modio_id"))
    r["installed"] = [h["pak"] for h in hits]
    r["optional"] = bool(re.search(r"optional|recommend|only if|not required", r["notes"], re.I))
    r["tool"] = bool(re.search(r"script extender|mod ?manager|bg3se", r["name"] or "", re.I))

# ---------- 3. what kind of mod is it, and which installed mods do the same job
CATS = {
    "difficulty": r"difficult|harder|challeng|tactician|honou?r mode|enem\w+ (?:scal|grow|get stronger)|stronger (?:enem|boss)|scal\w* (?:enem|npc|boss)|affix",
    "boss changes": r"\bboss(?:es)?\b|mini-?boss|legendary action",
    "extra encounters": r"\bencounters?\b|additional enem|more enem|new enem|extra enem|ambush",
    "enemy AI": r"\bAI\b|smarter enem|enemy behaviou?r|combat ai",
    "NPC stat overhaul": r"npc stat|stat overhaul|stat block|rebalanc\w+ (?:enem|npc)",
    "loot and items": r"\bloot\b|artifact|unique items|new items|equipment|\bgear\b|runic|treasure",
    "randomized loot": r"random\w* loot|loot pool|randomi[sz]",
    "XP and levelling": r"\bxp\b|experience|level ?cap|level 1[3-9]|level 20",
    "economy and gold": r"\bgold\b|merchant|vendor|trader|econom|shop",
    "camp and resting": r"camp suppl|long rest|short rest|\bcamp\b",
    "quests": r"\bquests?\b|journal",
    "UI": r"\bUI\b|interface|hotbar|tooltip|inventory|container",
}
CAT_RE = {k: re.compile(v, re.I) for k, v in CATS.items()}


def summary_of(row):
    out = []
    for s in row["sources"]:
        if s["source"] == "nexus" and str(s["id"]) in nexus_cache:
            out.append(nexus_cache[str(s["id"])]["mod"].get("summary") or "")
        if s["source"] == "modio" and str(s["id"]) in modio_cache:
            out.append(modio_cache[str(s["id"])].get("summary") or "")
    return f"{row.get('name')} {' '.join(out)}"


new_cats = {k: len(r.findall(text)) for k, r in CAT_RE.items()}
new_cats = {k: n for k, n in new_cats.items() if n >= 2 or (n and CAT_RE[k].search(new["summary"] + " " + new["name"]))}
overlap = defaultdict(list)
for row in installed:
    if row["pak"] not in pos:
        continue
    s = summary_of(row)
    for k in new_cats:
        if CAT_RE[k].search(s):
            overlap[k].append({"pak": row["pak"], "name": row.get("name"), "pos": pos[row["pak"]], "summary": s[:220]})
new["categories"] = new_cats
new["overlap"] = {k: sorted(v, key=lambda x: x["pos"]) for k, v in overlap.items()}

# sentences in the description that name a mod you have
named = []
for sent in re.split(r"(?<=[.!?])\s+|\n+", new["description"]):
    sl = sent.lower()
    if len(sent) > 400:
        continue
    for row in installed:
        n = (row.get("name") or "").strip()
        if len(n) >= 6 and n.lower() in sl and row["pak"] not in new["already_installed"]:
            kind = ("incompatible" if re.search(r"incompatib|not compatible|conflict|don.?t use|do not use|won.?t work", sl) else
                    "requires" if re.search(r"requires?|needs?|depends", sl) else
                    "patch" if re.search(r"patch|compat", sl) else
                    "replaces" if re.search(r"replac|instead of|includes|already contains|built in", sl) else "mentions")
            named.append({"pak": row["pak"], "name": n, "kind": kind, "sentence": sent.strip()[:300]})
new["named"] = named

# ---------- 4. optional: download and compare pak contents
if args.download:
    dl = new.get("download")
    if not dl:
        sys.exit("[FAIL] No downloadable file found on that page.")
    import shutil
    folder = os.path.join(L.WORK, "newmods", new["slug"])
    archive = os.path.join(folder, re.sub(r'[<>:"/\\|?*]', "_", dl["archive"]))
    if os.path.exists(archive) and (not dl.get("size") or abs(os.path.getsize(archive) - dl["size"]) <= max(1024, dl["size"] * 0.01)):
        print(f"[INFO] Using the copy of {dl['archive']} downloaded earlier")
        shutil.rmtree(os.path.join(folder, "x"), ignore_errors=True)
    else:
        shutil.rmtree(folder, ignore_errors=True)
        os.makedirs(folder)
        url = dl.get("url") or L.nexus_get(f"/mods/{new['id']}/files/{dl['file_id']}/download_link.json")[0]["URI"]
        print(f"[INFO] Downloading {dl['archive']} ({(dl.get('size') or 0) / 1e6:.1f} MB) for inspection only ...")
        L.download(url, archive, dl.get("size"))
    L.extract(archive, os.path.join(folder, "x"))
    newpaks = [L.scan_pak(p) | {"path": p} for p in L.find_paks(os.path.join(folder, "x"))]
    print(f"[INFO] Scanning {len(newpaks)} pak(s) and every installed pak ...")
    inst = {}
    for row in installed:
        if row["pak"] in pos:
            try:
                inst[row["pak"]] = L.scan_pak(os.path.join(L.MODS, row["pak"]))
            except Exception:
                pass
    by_uuid = {v.get("uuid"): k for k, v in inst.items()}
    deep = []
    for np in newpaks:
        d = {"pak": np["pak"], "uuid": np.get("uuid"), "name": np.get("name"), "version": np.get("version"), "se": np["se"],
             "stats": len(np["stats"]), "deps": [], "replaces_installed": by_uuid.get(np.get("uuid")), "conflicts": []}
        for dep in np["deps"]:
            if L.BUILTIN.match(dep.get("name") or "") or L.BUILTIN.match(dep.get("folder") or ""):
                continue
            d["deps"].append({"name": dep.get("name"), "installed": by_uuid.get(dep["uuid"])})
        nself = set(np["selfuse"])
        folder_l = (np.get("folder") or "").lower()
        for pak, ip in inst.items():
            if pak == d["replaces_installed"]:
                continue
            common = set(np["stats"]) & set(ip["stats"])
            sets = set(np["spellsets"]) & set(ip["spellsets"])
            tt = set(np["treasure"]) & set(ip["treasure"])
            files = {f.lower() for f in np["files"] if not f.lower().endswith("meta.lsx") and f"/{folder_l}/" not in f.lower()} & \
                    {f.lower() for f in ip["files"]}
            if not (common or sets or tt or files):
                continue
            iself = set(ip["selfuse"])
            d["conflicts"].append({
                "pak": pak, "name": ip.get("name"), "pos": pos.get(pak),
                "stats": len(common), "stats_new_merges": len(common & nself), "stats_installed_merges": len(common & iself),
                "examples": sorted(common)[:8], "spellsets": sorted(sets), "treasure": sorted(tt)[:10], "files": sorted(files)[:8],
                "file_count": len(files)})
        d["conflicts"].sort(key=lambda c: -(c["stats"] + 5 * len(c["spellsets"]) + 3 * len(c["treasure"]) + c["file_count"]))
        dep_pos = [pos[x["installed"]] for x in d["deps"] if x["installed"] in pos]
        d["load_after"] = max(dep_pos) if dep_pos else None
        deep.append(d)
    new["deep"] = deep

# ---------- 5. write results
new.pop("description_full", None)
L.save(f"newmod_{new['slug']}.json", new)
os.makedirs(args.out, exist_ok=True)
out = os.path.join(args.out, f"New_Mod_Check_{re.sub(r'[^A-Za-z0-9]+', '_', new['name']).strip('_')}_{datetime.now():%Y-%m-%d}.html")
tpl = open(os.path.join(L.HERE, "newmod_template.html"), encoding="utf-8").read()
data = json.dumps(new, ensure_ascii=False).replace("</", "<\\/")
open(out, "w", encoding="utf-8").write(tpl.replace("__DATA__", data).replace("__TITLE__", html.escape(new["name"])))
print(f"[PASS] Report: {out}")
print(f"[INFO] Requirements: " + ("; ".join(f"{r['name']} ({'installed' if r['installed'] else 'missing'})" for r in new["requirements"]) or "none listed"))
print(f"[INFO] Categories: {', '.join(new_cats) or 'none'}")
for k, v in new["overlap"].items():
    if k in ("difficulty", "extra encounters", "enemy AI", "NPC stat overhaul", "randomized loot", "boss changes", "XP and levelling"):
        print(f"  {k}: {', '.join(x['name'] for x in v[:12])}{' ...' if len(v) > 12 else ''}")
for d in new.get("deep", []):
    print(f"[INFO] {d['pak']}: {d['stats']} stat entries, deps {[x['name'] for x in d['deps']]}, replaces installed: {d['replaces_installed']}")
    for c in d["conflicts"][:15]:
        print(f"    vs {c['name']} (#{c['pos']}): {c['stats']} stats (new merges {c['stats_new_merges']}), "
              f"spellsets {c['spellsets'][:3]}, loot tables {len(c['treasure'])}, files {c['file_count']}")

# ---------- 5b. with the download: class/subclass/feat/race/spell-list impact report
if args.download and not args.install:
    import subprocess
    subprocess.run([sys.executable, "-I", os.path.join(L.HERE, "impact.py"), new["slug"]], check=False)

# ---------- 6. optional install: copy the pak(s) in and add them right after their dependencies
if args.install:
    if not args.download:
        sys.exit("[FAIL] --install needs --download.")
    missing = [x["name"] for d in new["deep"] for x in d["deps"] if not x["installed"]]
    if missing:
        sys.exit(f"[FAIL] Not installing: missing dependencies {missing}.")
    if not args.yes:
        sys.exit("[FAIL] --install needs --yes to confirm.")
    if L.bg3_running():
        sys.exit("[FAIL] Baldur's Gate 3 is running. Close it first.")
    import shutil
    bdir = L.new_backup_dir("install")
    L.backup_modsettings(bdir)
    text, match, nodes = L.read_modsettings()
    raws = [n["raw"] for n in nodes]
    uuids = [n["uuid"] for n in nodes]
    for np, d in zip(newpaks, new["deep"]):
        dest = os.path.join(L.MODS, np["pak"])
        if d["replaces_installed"]:
            old = os.path.join(L.MODS, d["replaces_installed"])
            os.makedirs(os.path.join(bdir, "paks"), exist_ok=True)
            shutil.move(old, os.path.join(bdir, "paks", d["replaces_installed"]))
            L.record_moved_pak(bdir, old, os.path.join(bdir, "paks", d["replaces_installed"]), dest)
        elif os.path.exists(dest):
            print(f"[FAIL] {np['pak']} already exists in Mods; skipped.")
            continue
        shutil.copy2(np["path"], dest)
        if not d["replaces_installed"]:
            L.record_added_pak(bdir, dest)
        raw = L.entry_xml(np["folder"], np["name"], np["uuid"], np["v64"], L.file_md5(dest))
        if np["uuid"] in uuids:
            i = uuids.index(np["uuid"])
            raws[i] = L.set_attr(L.set_attr(raws[i], "Version64", np["v64"]), "MD5", L.file_md5(dest))
        else:
            dep_idx = [uuids.index(x["uuid"]) for x in np["deps"] if x.get("uuid") in uuids and not L.BUILTIN.match(x.get("name") or "")]
            cf = next((i for i, n in enumerate(nodes) if "compatibilityframework" in (n["folder"] or "").lower()), len(raws))
            at = max(dep_idx) + 1 if dep_idx else cf
            raws.insert(at, raw)
            uuids.insert(at, np["uuid"])
            nodes.insert(at, {"folder": np["folder"]})
        print(f"[PASS] Installed {np['pak']} ({np.get('name')} {np.get('version')}) at load order position {uuids.index(np['uuid'])}")
    L.write_modsettings(text, match, raws)
    print(f"[INFO] Backup: {bdir}. Undo with Restore-ModCheck.ps1 latest. Re-run Run-ModCheck.ps1 to re-check the order.")
