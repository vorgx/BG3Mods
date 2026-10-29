"""Deep impact of a downloaded new mod (from newmod.py --download): what it replaces, duplicates and breaks.

Compares the mod's class, subclass, progression, feat, race, background and list definitions (LSX) with every
installed pak and with the base game. Binary .lsf files are converted with LSLib's Divine.exe.

  python impact.py <slug>        e.g. nexus12727   (reads work/newmods/<slug>, writes work/impact_<slug>.json)
"""
import json, os, re, shutil, struct, subprocess, sys
from collections import defaultdict
import xml.etree.ElementTree as ET
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import bg3lib as L

slug = sys.argv[1]
GAME_DATA = os.environ.get("BG3_DATA") or "F:/SteamLibrary/steamapps/common/Baldurs Gate 3/Data"
DIVINE = os.path.join(L.PROJECT, "LsLib", "Tools", "Divine.exe")
ROOT = os.path.join(L.WORK, "impact", slug)
WANT = re.compile(r"^Public/[^/]+/(ClassDescriptions|Progressions|Feats|Races|Lists|Backgrounds|Origins)/[^/]+\.(lsx|lsf)$", re.I)
LOCA = re.compile(r"^(Mods/[^/]+/)?Localization/English/[^/]+\.(loca|xml)$", re.I)
lo = L.load("lo_report.json")
pos = {m["pak"]: m["cur"] for m in lo["current"]}
newmod = L.load(f"newmod_{slug}.json")


def extract(pak_path, dest, want=WANT, loca=True):
    """Pull definition (and English localization) files out of one pak; .lsf is converted to .lsx."""
    texts = {}
    with open(pak_path, "rb") as f:
        for e in L.pak_entries(f):
            is_def, is_loc = want.match(e[0]), loca and LOCA.match(e[0])
            if not (is_def or is_loc):
                continue
            d = L.pak_read(f, e)
            if d is None:
                continue
            if is_loc:
                texts.update(parse_loca(d, e[0]))
                continue
            out = os.path.join(dest, e[0].split("/", 1)[1])  # keep the module folder: Shared and SharedDev both have ClassDescriptions.lsx
            os.makedirs(os.path.dirname(out), exist_ok=True)
            open(out, "wb").write(d)
            if out.lower().endswith(".lsf"):
                lsx = out[:-4] + ".lsx"
                subprocess.run([DIVINE, "-g", "bg3", "-a", "convert-resource", "-s", os.path.abspath(out), "-d", os.path.abspath(lsx)],
                               capture_output=True)
                os.remove(out)
    return texts


def parse_loca(data, name):
    if name.lower().endswith(".xml"):
        return dict(re.findall(rb'contentuid="([^"]+)"[^>]*>(.*?)</content>', data, re.S) and
                    [(k.decode(), v.decode("utf-8", "replace")) for k, v in re.findall(rb'contentuid="([^"]+)"[^>]*>(.*?)</content>', data, re.S)])
    if data[:4] != b"LOCA":
        return {}
    n, toff = struct.unpack("<II", data[4:12])
    out, p, t = {}, 12, toff
    for _ in range(n):
        key = data[p:p + 64].split(b"\0", 1)[0].decode("ascii", "replace")
        _ver, ln = struct.unpack("<HI", data[p + 64:p + 70])
        out[key] = data[t:t + ln].rstrip(b"\0").decode("utf-8", "replace")
        p += 70
        t += ln
    return out


def parse_defs(folder):
    """Every node with a UUID in the definition files: type, name, parent, table, level, subclasses, spells, display handle."""
    defs = {}
    for dp, _, files in os.walk(folder):
        for fn in files:
            if not fn.lower().endswith(".lsx"):
                continue
            try:
                root = ET.parse(os.path.join(dp, fn)).getroot()
            except ET.ParseError:
                continue
            for node in root.iter("node"):
                a = {x.get("id"): (x.get("value") if x.get("value") is not None else x.get("handle")) for x in node.findall("attribute")}
                if "UUID" not in a:
                    continue
                kind = node.get("id")
                rec = {"kind": kind, "file": fn, "name": a.get("Name"), "parent": (a.get("ParentGuid") or "").lower(),
                       "table": (a.get("TableUUID") or a.get("ProgressionTableUUID") or "").lower(), "level": a.get("Level"),
                       "ptype": a.get("ProgressionType"), "handle": a.get("DisplayName"),
                       "spells": [s for s in (a.get("Spells") or "").split(";") if s],
                       "subclasses": [x.get("value").lower() for n2 in node.iter("node") if n2.get("id") == "SubClass"
                                      for x in n2.findall("attribute") if x.get("id") == "Object"],
                       "featid": (a.get("FeatId") or "").lower(), "sig": ET.tostring(node)}
                defs[a["UUID"].lower()] = rec
    # a feat's display name lives in its FeatDescription
    for r in defs.values():
        if r["kind"] == "FeatDescription" and r["featid"] in defs and r["handle"]:
            defs[r["featid"]]["handle"] = r["handle"]
    return defs


# ---------- gather: new mod, base game, installed paks
if os.path.isdir(ROOT):
    shutil.rmtree(ROOT)
loc = {}
newpaks = L.find_paks(os.path.join(L.WORK, "newmods", slug, "x"))
for p in newpaks:
    loc.update(extract(p, os.path.join(ROOT, "new")))
new = parse_defs(os.path.join(ROOT, "new"))
vanilla = {}
for gp in ("Shared.pak", "Gustav.pak", "GustavX.pak"):
    p = os.path.join(GAME_DATA, gp)
    if os.path.exists(p):
        extract(p, os.path.join(ROOT, "vanilla", gp[:-4]), loca=False)
for sub in sorted(os.listdir(os.path.join(ROOT, "vanilla"))) if os.path.isdir(os.path.join(ROOT, "vanilla")) else []:
    vanilla.update(parse_defs(os.path.join(ROOT, "vanilla", sub)))
eng = os.path.join(GAME_DATA, "Localization", "English.pak")
if os.path.exists(eng):
    with open(eng, "rb") as f:
        for e in L.pak_entries(f):
            if e[0].lower().endswith(".loca"):
                d = L.pak_read(f, e)
                if d:
                    loc.update({k: v for k, v in parse_loca(d, e[0]).items() if k not in loc})
inst = {}
for i, pk in enumerate(pos):
    dest = os.path.join(ROOT, "installed", str(i))  # short names: some pak names hit the Windows path limit
    try:
        loc.update({k: v for k, v in extract(os.path.join(L.MODS, pk), dest).items() if k not in loc})
    except Exception as ex:
        print(f"[WARN] {pk}: {ex}")
        continue
    if os.path.isdir(dest):
        d = parse_defs(dest)
        if d:
            inst[pk] = d
print(f"[INFO] {len(new)} definitions in the new mod, {len(vanilla)} in the base game, {sum(map(len, inst.values()))} across {len(inst)} installed paks")


def label(rec, uuid=None):
    t = loc.get(rec["handle"], "") if rec.get("handle") else ""
    t = re.sub(r"<[^>]+>", "", t).strip()
    return t or rec.get("name") or uuid


FILLER = re.compile(r"\b(circle|college|oath|path|way|school|domain|patron|sorcery|sorcerer|subclass|archetype|tradition|"
                    r"conclave|order|the|of|a|an|5e|2024|phb)\b")


def norm(s):
    """'Divine Soul Sorcerer' and 'Divine Soul', 'Circle of Spores' and 'Spores' compare equal."""
    s = re.sub(r"\(.*?\)", " ", (s or "").lower())
    return re.sub(r"[^a-z0-9]", "", FILLER.sub(" ", s))


all_parents = {}
for src in [vanilla, new] + list(inst.values()):
    for u, r in src.items():
        if r["kind"] == "ClassDescription" and not r["parent"]:
            all_parents.setdefault(u, label(r, u))

# ---------- 1. what the new mod adds and replaces in the base game
classes, subclasses = [], []
for u, r in new.items():
    if r["kind"] != "ClassDescription":
        continue
    item = {"uuid": u, "name": label(r, u), "internal": r["name"], "replaces_vanilla": u in vanilla,
            "parent": all_parents.get(r["parent"]) if r["parent"] else None}
    (subclasses if r["parent"] else classes).append(item)
vanilla_replaced = defaultdict(list)
for u, r in new.items():
    if u in vanilla and new[u]["sig"] != vanilla[u]["sig"]:
        vanilla_replaced[r["kind"]].append(label(vanilla[u], u))

# ---------- 2. replaced: installed mods defining the same IDs
replaced = []
for pk, d in inst.items():
    common = [u for u in d if u in new and d[u]["sig"] != new[u]["sig"]]
    if not common:
        continue
    kinds = defaultdict(list)
    for u in common:
        kinds[d[u]["kind"]].append(label(new[u], u))
    # spells this mod puts in shared spell lists that the new mod's version drops
    lost_spells = []
    for u in common:
        if d[u]["kind"] == "SpellList":
            gone = sorted(set(d[u]["spells"]) - set(new[u]["spells"]) - set((vanilla.get(u) or {}).get("spells", [])))
            if gone:
                lost_spells.append({"list": label(new[u], u), "spells": gone})
    replaced.append({"pak": pk, "pos": pos.get(pk), "count": len(common), "kinds": {k: sorted(set(v))[:12] for k, v in kinds.items()},
                     "kind_counts": {k: len(v) for k, v in kinds.items()}, "lost_spells": lost_spells})
replaced.sort(key=lambda x: -x["count"])

# ---------- 3. duplicated: different IDs, same display name, same kind (and same parent class for subclasses)
dupes = []
new_by_key = defaultdict(list)
for u, r in new.items():
    if r["kind"] in ("ClassDescription", "Feat", "Race", "Background") and u not in vanilla:
        parent = all_parents.get(r["parent"], "") if r["kind"] == "ClassDescription" else ""
        new_by_key[(r["kind"], norm(parent), norm(label(r, u)))].append(u)
for pk, d in inst.items():
    for u, r in d.items():
        if r["kind"] not in ("ClassDescription", "Feat", "Race", "Background") or u in new or u in vanilla:
            continue
        parent = all_parents.get(r["parent"], "") if r["kind"] == "ClassDescription" else ""
        key = (r["kind"], norm(parent), norm(label(r, u)))
        if key[2] and key in new_by_key:
            dupes.append({"pak": pk, "pos": pos.get(pk), "kind": "Subclass" if r["parent"] and r["kind"] == "ClassDescription" else r["kind"],
                          "name": label(r, u), "parent": parent or None})
dupes.sort(key=lambda x: (x["kind"], x["name"]))

# ---------- 4. breaks: subclass level changes, level 13-20 add-ons, lost spells
def subclass_level(defs, class_uuid, table):
    lv = [int(r["level"]) for r in defs.values() if r["kind"] == "Progression" and r["table"] == table and r["subclasses"] and r["level"]]
    return min(lv) if lv else None


level_changes = []
for u, r in new.items():
    if r["kind"] == "ClassDescription" and not r["parent"] and u in vanilla:
        before = subclass_level(vanilla, u, vanilla[u]["table"])
        after = subclass_level(new, u, r["table"])
        if before and after and before != after:
            level_changes.append({"class": label(r, u), "uuid": u, "before": before, "after": after})
lc = {x["uuid"]: x for x in level_changes}
sub_breaks = []
for pk, d in inst.items():
    for u, r in d.items():
        if r["kind"] != "ClassDescription" or r["parent"] not in lc or u in new:
            continue
        lv = [int(x["level"]) for x in d.values() if x["kind"] == "Progression" and x["table"] == r["table"] and x["level"]]
        first = min(lv) if lv else None
        ch = lc[r["parent"]]
        if first is not None and first < ch["after"]:
            sub_breaks.append({"pak": pk, "pos": pos.get(pk), "subclass": label(r, u), "class": ch["class"],
                               "starts": first, "new_choice": ch["after"],
                               "note": f"its features start at level {first}, but the new mod lets you pick a {ch['class']} subclass at level {ch['after']}"})
new_tables = {r["table"]: label(r, u) for u, r in new.items() if r["kind"] == "ClassDescription" and r["table"]}
new_max = defaultdict(int)
for r in new.values():
    if r["kind"] == "Progression" and r["level"] and r["table"] in new_tables:
        new_max[r["table"]] = max(new_max[r["table"]], int(r["level"]))
high_levels = []
for pk, d in inst.items():
    hits = defaultdict(set)
    for u, r in d.items():
        if r["kind"] == "Progression" and r["level"] and int(r["level"]) > 12 and r["table"] in new_tables and u not in new:
            hits[new_tables[r["table"]]].add(int(r["level"]))
    if hits:
        high_levels.append({"pak": pk, "pos": pos.get(pk), "classes": {k: f"{min(v)}-{max(v)}" for k, v in hits.items()}})

result = {"slug": slug, "name": newmod["name"], "url": newmod["url"], "version": newmod.get("version"),
          "classes": sorted(classes, key=lambda x: x["name"]), "subclasses": sorted(subclasses, key=lambda x: (x["parent"] or "", x["name"])),
          "vanilla_replaced": {k: {"count": len(v), "names": sorted(set(v))} for k, v in vanilla_replaced.items()},
          "replaced": replaced, "duplicates": dupes, "level_changes": level_changes, "subclass_breaks": sub_breaks,
          "high_levels": high_levels, "stat_conflicts": [c for d in newmod.get("deep", []) for c in d["conflicts"]],
          "counts": {k: sum(1 for r in new.values() if r["kind"] == k) for k in ("ClassDescription", "Progression", "Feat", "Race", "Background", "SpellList", "PassiveList")},
          "installed_paks": len(pos)}
issues_path = os.path.join(L.CONF, "known_issues.json")
known = json.load(open(issues_path, encoding="utf-8")).get(slug, []) if os.path.exists(issues_path) else []
result["known_issues"] = [k for k in known if not k.get("if_installed") or k["if_installed"] in pos]
L.save(f"impact_{slug}.json", result)
out_dir = os.path.join(L.PROJECT, "Reports")
page = os.path.join(out_dir, f"Impact_{re.sub(r'[^A-Za-z0-9]+', '_', newmod['name']).strip('_')}_{__import__('datetime').date.today()}.html")
tpl = open(os.path.join(L.HERE, "impact_template.html"), encoding="utf-8").read()
open(page, "w", encoding="utf-8").write(tpl.replace("__DATA__", json.dumps(result, ensure_ascii=False).replace("</", "<\\/")))
print(f"[PASS] Impact report: {page}")
print(f"[INFO] classes {len(classes)} ({sum(c['replaces_vanilla'] for c in classes)} replace base-game ones), subclasses {len(subclasses)}")
print(f"[INFO] replaces base game: " + ", ".join(f"{k} {v['count']}" for k, v in result["vanilla_replaced"].items()))
print(f"[INFO] installed mods with replaced definitions: {len(replaced)}; duplicates: {len(dupes)}; subclass level changes: {level_changes}")
print(f"[INFO] subclasses that would lose early features: {len(sub_breaks)}; level 13-20 add-ons on changed classes: {len(high_levels)}")
