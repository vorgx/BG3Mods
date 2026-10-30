"""Find add-ons you may be missing: unmet requirements, and compatibility patches between mods you already have.

Sources: Nexus requirements (GraphQL, with the author's notes), mod.io dependencies, optional files on each installed
mod's Nexus page, and patch/compat mods linked from installed mods' descriptions. Writes work/addons.json.
"""
import html, json, os, re, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import bg3lib as L

report = L.load("report.json")
nexus = L.load("nexus_cache.json", {})
modio = (L.load("modio_cache.json") or {}).get("mods", {})
lo = L.load("lo_report.json")
MDIR = os.path.join(L.WORK, "manifests")
active = {m["pak"] for m in lo["current"]}
mods = [m for m in report["mods"]]
installed_paks = {m["pak"].lower() for m in mods}
nexus_ids = {}
for m in mods:
    for s in m["sources"]:
        if s["source"] == "nexus":
            nexus_ids.setdefault(int(s["id"]), []).append(m)
modio_ids = {int(s["id"]) for m in mods for s in m["sources"] if s["source"] == "modio"}

PATCHY_RE = re.compile(r"\b(patch(es)?|compat(ibility)? (patch|fix)|support|integration|add-?on|bridge|submod)\b", re.I)
GAME_PATCH = re.compile(r"\bpatch\s*\d+\b|\bp\d\b|hotfix\s*\d+", re.I)  # "Patch 8 ready" is about the game, not a mod
TOOLS = re.compile(r"mod ?manager|bg3mm|script extender|bg3se|ability to read|vortex|lslib|multitool", re.I)
FRAMEWORK = re.compile(r"compatibility ?framework|community ?library|configuration ?menu|impui|volition ?cabinet|goon.?s library", re.I)


class _Patchy:
    def search(self, s):
        return PATCHY_RE.search(GAME_PATCH.sub(" ", s or ""))


PATCHY = _Patchy()
TRANSLATION = re.compile(r"\b(chs|cht|rus?|russian|chinese|korean|japanese|ptbr|pt-br|polish|french|german|spanish|ukrainian|"
                         r"italian|turkish|vietnamese|translation|traduction|traducao|translated)\b", re.I)
STOP = {"the", "and", "for", "mod", "mods", "with", "of", "by", "a", "an", "to", "in", "bg3", "baldur", "baldurs", "gate", "version",
        "patch", "all", "more", "new", "main", "file", "files", "fix", "fixes", "class", "subclass", "subclasses", "set", "pack",
        "compatibility", "compat", "addon", "add", "on", "support", "lite", "full", "level", "edition", "overhaul", "better", "plus"}


def words(s):
    s = re.sub(r"([a-z])([A-Z])", r"\1 \2", s or "")
    return re.findall(r"[a-z0-9]+", s.lower().replace("'s", ""))


def clean(d):
    t = re.sub(r"<br\s*/?>", "\n", d or "")
    t = re.sub(r"\[/?[a-z*]+(?:=[^\]]*)?\]", " ", t, flags=re.I)
    return re.sub(r"[ \t ﻿]+", " ", html.unescape(re.sub(r"<[^>]+>", " ", t)))


# aliases for each installed mod: its page name, pak name, meta name, plus known short names
aliases = []  # (phrase words tuple, installed mod row)
for m in mods:
    if FRAMEWORK.search(f"{m['pak']} {m.get('name')}"):
        continue  # frameworks are mentioned on half of all mod pages; that says nothing about compatibility
    names = {m.get("name") or "", re.sub(r"\.pak$", "", m["pak"], flags=re.I)}
    names |= {s.get("name") or "" for s in m["sources"]}
    for n in names:
        n = re.sub(r"[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}", "", n, flags=re.I)
        n = re.sub(r"\(.*?\)|\s-\s.*$", "", n)
        w = tuple(x for x in words(n) if x not in STOP)
        if len(w) >= 2 or (len(w) == 1 and len(w[0]) >= 7):
            aliases.append((w, m))
KNOWN = {("5e", "spells"): r"5espells", ("eotb",): r"eyesofthebeholder", ("eyes", "beholder"): r"eyesofthebeholder",
         ("unlock", "curve"): r"unlocklevelcurve", ("ulc",): r"unlocklevelcurve", ("combat", "extender"): r"combatextender",
         ("cx",): r"combatextender", ("mmm",): r"manymoremonsters", ("encounters", "overhaul"): r"encountersoverhaul",
         ("amp",): r"ancient", ("dwso",): r"druidwildshapeoverhaul", ("wotd",): r"wotd", ("tav", "hair", "salon"): r"tav.?s?hair"}
for phrase, pat in KNOWN.items():
    for m in mods:
        if re.search(pat, (m["pak"] + (m.get("name") or "")).lower().replace(" ", "").replace("'", "")):
            aliases.append((phrase, m))


def mentions(text, exclude_pages=(), exclude_text=""):
    """Installed mods named in text (whole-word phrase match), minus mods on the given pages or named in exclude_text."""
    if exclude_text:
        skip = {m["pak"] for m in mentions(exclude_text)}
        return [m for m in mentions(text, exclude_pages) if m["pak"] not in skip]
    w = words(text)
    joined = " " + " ".join(w) + " "
    out = {}
    for phrase, m in aliases:
        if " " + " ".join(phrase) + " " in joined:
            if any(s["source"] == "nexus" and int(s["id"]) in exclude_pages for s in m["sources"]):
                continue
            out[m["pak"]] = m
    return list(out.values())


def label(m):
    return m.get("name") or m["pak"]


# every word of every installed mod's names (frameworks included), for checking what a patch's title names
installed_words = {w for phrase, _ in aliases for w in phrase}  # includes short names like "eotb"
for m in mods:
    text = " ".join([m["pak"], m.get("name") or ""] + [s.get("name") or "" for s in m["sources"]])
    installed_words |= set(words(text)) | set(words(text.lower()))  # "EotB" is split as "eot b"; keep "eotb" too
GENERIC = {"optional", "compatible", "version", "versions", "patched", "patches", "patchs", "update", "updated", "only", "required",
           "requires", "mod", "conversion", "ft", "integration", "bridge", "submod", "submods", "addons", "merged", "merge", "hotfix",
           "vanilla", "unofficial"}


def names_only_installed(title, page):
    """False when a patch's title names a mod you don't have ("Barbie Head - CCO Patch" needs Character Creation Overhaul).
    Looks only at patch titles, past the page's own name, a closing "by <author>" credit, and the patch's own name when the
    targets are in brackets; a word counts as a mod name you have when it appears in any installed mod's names."""
    if not PATCHY.search(title):
        return True
    t = re.sub(r"\bby\s+\S+\s*$", "", title, flags=re.I)
    m = re.match(r"(.+?)\((.+)\)\s*$", t)
    if m:
        # "Actual Green-Flame Blade (5e Spells and SCAG patch)": the targets are in the brackets;
        # "... KAVT Patch (Optional)": the brackets are only a label
        t = m.group(2) if PATCHY.search(m.group(2)) else m.group(1)
    left = {w for w in words(t) if w not in STOP | GENERIC and len(w) > 1 and not any(c.isdigit() for c in w)}
    return not (left - set(words(page)) - installed_words)


# installed mods as name phrases, frameworks included (aliases leaves them out), for "only needed if you use MCM"
everyone = list(aliases)
for m in mods:
    if FRAMEWORK.search(f"{m['pak']} {m.get('name')}"):
        for n in {m.get("name") or "", re.sub(r"\.pak$", "", m["pak"], flags=re.I)} | {s.get("name") or "" for s in m["sources"]}:
            w = tuple(x for x in words(re.sub(r"\(.*?\)|\s-\s.*$", "", n)) if x not in STOP)
            if w:
                everyone.append((w, m))


def named_mods(text):
    """Paks of installed mods (frameworks included) whose name appears in text. Alias phrases have no stop words, so neither
    does the text here ("Eyes of the Beholder" -> "eyes beholder")."""
    joined = " " + " ".join(w for w in words(text) if w not in STOP) + " "
    return {m["pak"] for phrase, m in everyone if " " + " ".join(phrase) + " " in joined}


# a requirement the author limits to one version of their mod, or to users of another mod
CONDITIONAL = re.compile(r"\bonly (?:required|needed|necessary)\b|\b(?:required|needed) (?:only )?(?:for|with)\b.*\bversions?\b|"
                         r"^\W*(?:only )?for\b.*\b(?:users?|versions?)\b|\bif you(?: are)? (?:use|using|run|play with)\b", re.I)
NOT_REQUIRED = re.compile(r"^\W*not (?:required|needed)\b", re.I)  # "Not required for the Lite version": a negative, not a condition
COND_WORDS = {"only", "required", "needed", "necessary", "for", "if", "you", "are", "use", "using", "play", "run", "users", "user",
              "version", "versions", "the", "this", "that", "when", "with", "and", "or", "all", "both", "any", "every", "each",
              "either", "latest", "newest", "current", "other"}


def conditional_applies(notes, owners):
    """None when the note sets no real condition ("Required for all versions", "For all users"). Otherwise whether it applies
    to you: your pak is the version it names ("ONLY REQUIRED FOR THE KAZSTRA TAV VERSION"), or for "For UT/KAVT users" and
    "Only needed if you use X", you have a mod it names."""
    if NOT_REQUIRED.search(notes) or not CONDITIONAL.search(notes):
        return None
    named = {w for w in words(notes) if w not in STOP | COND_WORDS and not any(c.isdigit() for c in w)}
    if not named:
        return None
    if named & set(words(" ".join(f"{o['pak']} {o.get('name') or ''}" for o in owners))):
        return True
    if re.search(r"\bversions?\b", notes, re.I):
        return False  # about a version of the mod, and yours isn't it
    return bool(named_mods(notes) - {o["pak"] for o in owners})


results = {"required": [], "suggested": [], "optional": []}
seen = set()


def add(kind, for_mods, title, url, reason, notes=""):
    key = (kind, title, url)
    if key in seen:
        return
    seen.add(key)
    results[kind].append({"for": sorted({label(x) for x in for_mods}), "title": title, "url": url, "reason": reason, "notes": notes})


# 1) Nexus requirements, batched through GraphQL
Q = """query($ids: [CompositeIdInput!]!) { legacyMods(ids: $ids) { nodes { modId name
      modRequirements { nexusRequirements { nodes { modId modName url notes externalRequirement } } } } } }"""
ids = sorted(nexus_ids)
inst_names = " | ".join(words(" ".join(f"{m['pak']} {m.get('name')}" for m in mods)))
for i in range(0, len(ids), 40):
    try:
        data = L.nexus_graphql(Q, {"ids": [{"gameId": L.NEXUS_GAME_ID, "modId": x} for x in ids[i:i + 40]]})
    except Exception as ex:
        print(f"[WARN] Nexus requirements batch failed: {ex}")
        continue
    for node in data["legacyMods"]["nodes"]:
        owner = nexus_ids.get(int(node["modId"]), [])
        for req in (node.get("modRequirements") or {}).get("nexusRequirements", {}).get("nodes", []):
            rid = int(req["modId"]) if str(req.get("modId") or "").isdigit() else None
            name = req.get("modName") or req.get("url") or "?"
            if rid in nexus_ids:
                continue
            if rid == 2172 or TOOLS.search(name):
                continue  # tools (BG3SE, mod managers) are not paks
            # satisfied by a pak installed from elsewhere (mod.io, manual) under the same name?
            w = [x for x in words(name) if x not in STOP]
            if (w and all(x in inst_names for x in w)) or mentions(name):
                continue
            notes = (req.get("notes") or "").strip()
            url = req.get("url") or (f"https://www.nexusmods.com/baldursgate3/mods/{rid}" if rid else "")
            page = f"{owner[0]['sources'][0].get('name')}'s" if owner else "its"
            applies = conditional_applies(notes, owner)
            if applies is True:
                add("required", owner, name, url, f"Listed as a requirement on {page} Nexus page, for the version or mod you have", notes)
            elif applies is False:
                add("optional", owner, name, url, f"Listed on {page} Nexus page, but only for a version or mod you don't have", notes)
            if applies is not None:
                continue
            optional = re.search(r"optional|recommend|not required|only (?:if|for|needed)|if you (?:want|use)|works? (?:fine )?without", notes, re.I)
            add("suggested" if optional else "required", owner, name, url,
                f"Listed as a requirement on {owner[0]['sources'][0].get('name') if owner else 'its'} Nexus page"
                + (" (marked optional)" if optional else ""), notes)

# 2) mod.io dependencies (only for mods that declare any)
for mid in sorted(modio_ids):
    mod = modio.get(str(mid))
    if not mod or not mod.get("dependencies"):
        continue
    try:
        deps = L.modio_get(f"/mods/{mid}/dependencies").get("data", [])
    except Exception as ex:
        print(f"[WARN] mod.io dependencies for {mid}: {ex}")
        continue
    owner = [m for m in mods if any(s["source"] == "modio" and int(s["id"]) == mid for s in m["sources"])]
    for d in deps:
        if int(d.get("mod_id", 0)) in modio_ids:
            continue
        w = [x for x in words(d.get("name")) if x not in STOP]
        if w and all(x in inst_names for x in w):
            continue
        add("required", owner, d.get("name"), d.get("profile_url") or "", "mod.io dependency of " + mod["name"])

# paks we already recommend disabling or removing: no point suggesting add-ons for them
dropping = {m["pak"] for m in mods if m["status"] == "obsolete"}
dropping |= {x["a"] for x in json.load(open(os.path.join(L.CONF, "incompat_verified.json"), encoding="utf-8"))}


# 3) optional files on installed mods' own Nexus pages that bridge to another installed mod
def manifest_paks(fid):
    p = os.path.join(MDIR, f"{fid}.json")
    if not os.path.exists(p):
        return None
    j = json.load(open(p, encoding="utf-8"))
    names = [x.get("file_path") for x in j.get("files", [])]

    def walk(ch):
        for x in ch or []:
            if x.get("type") == "directory":
                yield from walk(x.get("children"))
            else:
                yield x.get("name")
    names += list(walk(j.get("children")))
    return [os.path.basename(str(n).replace("\\", "/")).lower() for n in names if str(n).lower().endswith(".pak")]


for mid, owners in nexus_ids.items():
    d = nexus.get(str(mid))
    if not d:
        continue
    for f in d["files"]["files"]:
        if f.get("category_name") not in ("OPTIONAL", "MISCELLANEOUS", "MAIN", "UPDATE"):
            continue
        text = f"{f.get('name')} {clean(f.get('description'))}"
        if TRANSLATION.search(f.get("name") or "") or TRANSLATION.search(f.get("file_name") or ""):
            continue
        paks = manifest_paks(f["file_id"])
        if paks and all(p in installed_paks for p in paks):
            continue  # already installed
        if paks is None or not paks:
            continue  # nothing installable, or unknown contents
        if any(o["pak"] in dropping for o in owners):
            continue
        page = d["mod"]["name"]
        # a bridge names another installed mod in its own title, or is a patch whose description does;
        # mods the page itself is built for ("Secret Scrolls for 5e Spells") don't count
        title_others = mentions(f.get("name") or "", exclude_pages={mid}, exclude_text=page)
        others = title_others or (mentions(text, exclude_pages={mid}, exclude_text=page) if PATCHY.search(f.get("name") or "") else [])
        # close variant of a pak you already have from this page ("..._Improvement" of the patch you run)?
        ft = set(words(f.get("name") or "")) | set(words(" ".join(paks)))
        variant = None
        for o in owners:
            w = set(words(re.sub(r"\.pak$", "", o["pak"], flags=re.I)))
            if w and len(w & ft) / len(w) >= 0.6:
                variant = o
                break
        url = f"https://www.nexusmods.com/baldursgate3/mods/{mid}?tab=files&file_id={f['file_id']}"
        if others and not variant and not names_only_installed(f.get("name") or "", page):
            if f.get("category_name") in ("OPTIONAL", "MISCELLANEOUS"):
                add("optional", owners, f"{page}: {f['name']}", url, "Patch that also names a mod you don't have",
                    clean(f.get("description"))[:200])
        elif others and not variant:
            add("suggested", owners + others, f"{page}: {f['name']}", url,
                f"Optional file on {page}'s page for {', '.join(label(o) for o in others[:3])}, which you also have",
                clean(f.get("description"))[:300])
        elif f.get("category_name") in ("OPTIONAL", "MISCELLANEOUS"):
            add("optional", owners, f"{page}: {f['name']}", url,
                f"Alternative to the {variant['pak']} you have" if variant else "Other optional file on the page",
                clean(f.get("description"))[:200])

# 4) patch / compatibility mods linked from installed mods' descriptions
linked = {}
for mid, owners in nexus_ids.items():
    d = nexus.get(str(mid))
    if not d:
        continue
    desc = d["mod"].get("description") or ""
    for m in re.finditer(r"nexusmods\.com/baldursgate3/mods/(\d+)", desc):
        lid = int(m.group(1))
        if lid in nexus_ids or lid == mid:
            continue
        ctx = clean(desc[max(0, m.start() - 400):m.end() + 200])
        linked.setdefault(lid, []).append((mid, ctx))
lids = sorted(linked)
QN = """query($ids: [CompositeIdInput!]!) { legacyMods(ids: $ids) { nodes { modId name summary status } } }"""
for i in range(0, len(lids), 50):
    try:
        data = L.nexus_graphql(QN, {"ids": [{"gameId": L.NEXUS_GAME_ID, "modId": x} for x in lids[i:i + 50]]})
    except Exception as ex:
        print(f"[WARN] linked mod lookup failed: {ex}")
        continue
    for node in data["legacyMods"]["nodes"]:
        name = node.get("name") or ""
        if not PATCHY.search(name) or TRANSLATION.search(name) or (node.get("status") or "").lower() not in ("published", ""):
            continue
        for src_mid, ctx in linked[int(node["modId"])]:
            others = mentions(f"{name} {node.get('summary') or ''}", exclude_pages={src_mid}, exclude_text=nexus[str(src_mid)]["mod"]["name"])
            owner = nexus_ids[src_mid]
            if others and names_only_installed(name, nexus[str(src_mid)]["mod"]["name"]):
                add("suggested", owner + others, name, f"https://www.nexusmods.com/baldursgate3/mods/{node['modId']}",
                    f"Linked from {nexus[str(src_mid)]['mod']['name']}'s page; it patches it with {', '.join(label(o) for o in others[:3])}, which you have",
                    (node.get("summary") or "")[:300])

L.save("addons.json", results)
print(f"[INFO] Add-ons: {len(results['required'])} missing requirements, {len(results['suggested'])} suggested patches, "
      f"{len(results['optional'])} other optional files")
for k in ("required", "suggested"):
    for r in results[k]:
        print(f"  [{k}] {r['title']}  <- for {', '.join(r['for'][:3])} | {r['reason'][:110]}")
