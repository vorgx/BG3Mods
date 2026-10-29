"""Compare installed paks against cached Nexus / mod.io data and write report.json."""
import json, os, re, sys
from collections import Counter, defaultdict
from datetime import datetime, timezone

HERE = os.path.dirname(os.path.abspath(__file__))
S = os.environ.get("BG3MC_WORK") or os.path.join(HERE, "work")  # caches and intermediate JSON
CONF = os.path.join(HERE, "config")  # hand-checked matches and rules
rows = json.load(open(os.path.join(S, "installed.json"), encoding="utf-8"))
nexus = json.load(open(os.path.join(S, "nexus_cache.json"), encoding="utf-8"))
modio = json.load(open(os.path.join(S, "modio_cache.json"), encoding="utf-8"))["mods"]
extra = json.load(open(os.path.join(CONF, "extra_matches.json"), encoding="utf-8"))

DAY = 86400
SAME_RELEASE = 3 * DAY  # a pak's timestamp is usually its build time, a day or two before the upload
TRANSLATION = re.compile(r"\b(chs|cht|rus?|russian|chinese|korean|japanese|ptbr|pt-br|polish|french|german|spanish|"
                         r"ukrainian|italian|turkish|vietnamese|translation|traduction|traducao)\b", re.I)
ACTIVE = {"MAIN", "UPDATE", "OPTIONAL", "MISCELLANEOUS"}
PLACEHOLDER = {"", "0", "1"}  # meta versions authors never bump (1.0.0.0, 0.0.0.0)
STOP = {"pak", "zip", "rar", "7z", "the", "of", "and", "by", "for", "a", "mod", "bg3", "version", "ver", "fix", "patch"}


def nums(v):
    if not v:
        return None
    v = str(v).strip().lower().lstrip("v")
    parts = re.split(r"[.\-_ ]+", v)
    if not parts or not all(p.isdigit() for p in parts):
        return None
    out = [int(p) for p in parts]
    while len(out) > 1 and out[-1] == 0:
        out.pop()
    return out


def norm(v):
    n = nums(v)
    return ".".join(map(str, n)) if n else (v or "").strip().lower()


# an author who stamps the same version on 3+ different mods (Xara's 1.0.9.88) never bumps it
_by_author = defaultdict(lambda: defaultdict(set))
for _r in rows:
    if _r.get("author") and _r.get("version"):
        _by_author[_r["author"]][norm(_r["version"])].add(_r.get("name"))
PLACEHOLDER = PLACEHOLDER | {v for vs in _by_author.values() for v, names in vs.items() if len(names) >= 3 and v.count(".") >= 2}


def vcmp(installed, latest):
    """-1 installed older, 0 same, 1 newer, None when the two schemes can't be compared."""
    a, b = nums(installed), nums(latest)
    if not a or not b or a[0] != b[0] or norm(installed) in PLACEHOLDER:
        return None
    n = max(len(a), len(b))
    a, b = a + [0] * (n - len(a)), b + [0] * (n - len(b))
    if a == b:
        return 0
    # "4.8.4" on Nexus vs "4.8.4.123" in the pak: same release, extra build number
    k = min(len(nums(installed)), len(nums(latest)))
    if a[:k] == b[:k]:
        return 0 if len(nums(installed)) > len(nums(latest)) else -1
    return -1 if a < b else 1


def tokens(s):
    s = re.sub(r"[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}", " ", (s or "").lower())
    s = re.sub(r"([a-z])([A-Z])", r"\1 \2", s)
    return {t for t in re.findall(r"[a-z]+|\d+", s) if t not in STOP and len(t) > 1 and not t.isdigit()}


def sim(r, name):
    a = tokens(r["pak"]) | tokens(r.get("name")) | tokens(r.get("folder"))
    b = tokens(name)
    return len(a & b) / len(b) if b else 0


def ts(iso):
    return datetime.fromisoformat(iso).timestamp()


def decide(r, target, replaced, mtime):
    """Status from version comparison first, then dates."""
    c = vcmp(r.get("version"), target.get("version"))
    up = target["uploaded_timestamp"]
    if c is not None and c >= 0:
        return "current", "exact", "Installed version matches the newest file." if c == 0 else "Installed version is newer than the listed file.", "version"
    if c == -1:
        if up > mtime + SAME_RELEASE:
            return "update", "exact", "Newer version on Nexus.", "version"
        a, b = nums(r.get("version")), nums(target.get("version"))
        if mtime > up + DAY and len(a) >= 3 and len(b) >= 3:
            return "check", "heuristic", (f"Nexus says {target.get('version')}, your pak says {r.get('version')}, but your pak was "
                                          "installed after that upload (perhaps from mod.io, which can lag). Check manually."), "version"
        return "current", "heuristic", ("Nexus shows a higher version label, but its file isn't newer than your pak "
                                        "(authors often don't bump the version inside the pak)."), "date"
    if replaced:
        if mtime > up + DAY:
            return "current", "heuristic", "Your pak is newer than the replacement file, so you probably updated already.", "replaced"
        return "update", "exact", f"Nexus lists '{target['name']}' as the replacement for your file.", "replaced"
    return None


def nexus_eval(r, mid, fid, shared):
    d = nexus.get(str(mid))
    if not d or "mod" not in d:
        return None
    mod, files = d["mod"], d["files"]["files"]
    byid = {f["file_id"]: f for f in files}
    pak_is_translation = bool(TRANSLATION.search(f"{r['pak']} {r.get('name')}"))
    active = [f for f in files if f.get("category_name") in ACTIVE
              and (pak_is_translation or not TRANSLATION.search(f.get("name") or ""))]
    mains = [f for f in active if f["category_name"] in ("MAIN", "UPDATE")] or active
    newest_main = max(mains, key=lambda f: f["uploaded_timestamp"], default=None)
    mtime = ts(r["mtime"])
    res = {"source": "nexus", "id": mid, "name": mod.get("name"), "author": mod.get("author"),
           "url": f"https://www.nexusmods.com/baldursgate3/mods/{mid}",
           "files_url": f"https://www.nexusmods.com/baldursgate3/mods/{mid}?tab=files",
           "picture": mod.get("picture_url"), "page_version": mod.get("version"),
           "available": mod.get("available", True)}

    def finish(target, status, conf, note, basis="other"):
        if target:
            res.update(latest_version=target.get("version") or target.get("mod_version"),
                       latest_file=target.get("name"), latest_date=target["uploaded_timestamp"],
                       latest_category=target.get("category_name"))
        res.update(status=status, confidence=conf, note=note, basis=basis)
        return res

    def newest_same_name(name):
        same = [f for f in active if f["name"] == name]
        return max(same, key=lambda f: f["uploaded_timestamp"]) if same else None

    if fid:
        upd = {u["old_file_id"]: u for u in d["files"].get("file_updates", [])}
        cur, seen = fid, set()
        while cur in upd and cur not in seen:
            seen.add(cur)
            cur = upd[cur]["new_file_id"]
        inst = byid.get(fid)
        res["installed_file"] = inst["name"] if inst else None
        target = byid.get(cur) if cur != fid else inst
        if target and target.get("category_name") not in ACTIVE:
            target = newest_same_name(target["name"]) or target
        if inst and target is inst:
            later = newest_same_name(inst["name"])
            if later and later["uploaded_timestamp"] > inst["uploaded_timestamp"]:
                target = later
        if not target:
            target = newest_main
            if not target:
                return finish(None, "unknown", "none", "No current files on the Nexus page.")
            dec = decide(r, target, True, mtime)
            return finish(target, *(dec or ("update", "exact", "Your installed file is no longer listed on Nexus.", "replaced")))
        replaced = inst is None or target["file_id"] != inst["file_id"]
        dec = decide(r, target, replaced, mtime)
        if dec:
            status, conf, note, basis = dec
            if status == "update" and shared and sim(r, target["name"]) == 0:
                note = f"This pak comes in the '{target['name']}' download, which was updated. The pak itself may not have changed."
            return finish(target, status, conf, note, basis)
        return finish(target, "current", "exact", "Your file is still the current one on Nexus.")

    # no file id: pick the file that looks like this pak
    if not active:
        return finish(None, "unknown", "none", "No current files on the Nexus page.")
    scored = sorted(active, key=lambda f: (sim(r, f["name"]), f["category_name"] in ("MAIN", "UPDATE"), f["uploaded_timestamp"]), reverse=True)
    best = scored[0]
    if sim(r, best["name"]) == 0:
        best = newest_main if len(mains) == 1 or not shared else None
    if best is None:
        res["note"] = "Several files on this page and none matches this pak's name."
        return finish(None, "check", "heuristic", f"This looks like an add-on or patch on the '{mod.get('name')}' page; couldn't tell which file it is.")
    res["installed_file"] = None
    dec = decide(r, best, False, mtime)
    if dec:
        return finish(best, *dec)
    if best["uploaded_timestamp"] > mtime + 2 * DAY:
        return finish(best, "likely", "heuristic", "A matching Nexus file was uploaded after your pak (versions can't be compared).")
    return finish(best, "current", "heuristic", "No matching Nexus file is newer than your pak.")


def modio_eval(r, mid):
    m = modio.get(str(mid))
    if not m:
        return None
    mf = m.get("modfile") or {}
    mtime = ts(r["mtime"])
    res = {"source": "modio", "id": mid, "name": m.get("name"), "author": (m.get("submitted_by") or {}).get("username"),
           "url": m.get("profile_url"), "files_url": m.get("profile_url"),
           "picture": (m.get("logo") or {}).get("thumb_320x180"),
           "latest_version": mf.get("version"), "latest_date": mf.get("date_added"), "latest_file": mf.get("filename"),
           "available": m.get("status") == 1 and m.get("visible") == 1}
    if not mf:
        res.update(status="unknown", confidence="none", note="No file on mod.io.")
        return res
    c = vcmp(r.get("version"), mf.get("version"))
    if c is None and norm(r.get("version")) == norm(mf.get("version")):
        c = 0
    if c is not None and c >= 0:
        res.update(status="current", confidence="exact", note="Installed version matches mod.io." if c == 0 else "Installed version is newer than mod.io.")
    elif c == -1:
        res.update(status="update", confidence="exact", note="Newer version on mod.io.")
    elif mf.get("date_added", 0) > mtime + DAY:
        res.update(status="likely", confidence="heuristic", note="mod.io has a file uploaded after your pak.")
    else:
        res.update(status="current", confidence="heuristic", note="Your pak is newer than the mod.io file.")
    return res


verify = json.load(open(os.path.join(S, "verify.json"), encoding="utf-8")) if os.path.exists(os.path.join(S, "verify.json")) else {}


def apply_verify(pak, s, installed_version):
    """Overrule the version/date guess with the hash or size match against the files inside Nexus downloads."""
    v = verify.get(pak)
    if not v or s["source"] != "nexus":
        return s
    s["verify"] = v["result"]
    l = v.get("latest") or {}
    if l:
        s.update(latest_version=l.get("version"), latest_file=l.get("file"), latest_date=l.get("uploaded"))
    if v["result"] == "identical":
        s.update(status="current", confidence="verified", note=f"Verified: your pak is byte-for-byte identical to the one in '{l.get('file')}'.")
    elif v["result"] == "outdated":
        s.update(status="update", confidence="verified",
                 note=f"Verified: your pak matches an older upload of '{l.get('file')}'; a newer upload has a different pak.")
    elif v["result"] == "differs":
        s.update(status="update", confidence="verified",
                 note=f"Verified: your pak doesn't match any current download; the pak in '{l.get('file')}' is different.")
    elif v["result"] == "size-differs":
        s.update(status="update", confidence="exact",
                 note="Your pak's size doesn't match any current download on Nexus (older uploads only list sizes, not hashes).")
    elif v["result"] == "size-match":
        same_version = (vcmp(installed_version, l.get("version")) or 0) >= 0 and nums(l.get("version"))
        if s["status"] == "update" and s.get("basis") == "version" and not same_version:
            s.update(status="check", confidence="heuristic",
                     note=f"Nexus shows a higher version, but your pak is the same size as the one in '{l.get('file')}', "
                          "so it's probably the same file. Sizes are rounded, so check manually.")
        elif s["status"] != "current":
            s.update(status="current", confidence="size",
                     note=f"Your pak is the same size as the one in the newest '{l.get('file')}' download, so it hasn't changed.")
        else:
            s["note"] = (s.get("note") or "") + " Size matches the newest download."
    return s


# paks that share one Nexus page (add-ons, patches, multi-pak downloads)
page_paks = defaultdict(list)
for r in rows:
    nid = extra.get(r["pak"], {}).get("nexus_id") or r["nexus_id"]
    if nid:
        page_paks[nid].append(r["pak"])

out = []
for r in rows:
    srcs = []
    ex = extra.get(r["pak"], {})
    nid = ex.get("nexus_id") or r["nexus_id"]
    fid = None if ex.get("nexus_id") else r["nexus_file_id"]
    mio = ex.get("modio_id") or r["modio_id"]
    shared = [p for p in page_paks.get(nid, []) if p != r["pak"]]
    if nid:
        e = nexus_eval(r, nid, fid, shared)
        if e:
            srcs.append(apply_verify(r["pak"], e, r.get("version")))
    if mio:
        e = modio_eval(r, mio)
        if e:
            srcs.append(e)
    st = {(s["status"], s["confidence"]) for s in srcs}
    st = {(s, "exact" if c in ("verified", "size") else c) for s, c in st}
    if ("update", "exact") in st:
        overall = "update"
    elif ("current", "exact") in st:
        overall = "current"
    elif any(s == "check" for s, _ in st):
        overall = "check"
    elif any(s == "likely" for s, _ in st):
        overall = "likely"
    elif any(s == "current" for s, _ in st):
        overall = "current"
    else:
        overall = "unknown"
    if ex.get("status"):  # verdicts checked by hand
        overall = ex["status"]
    out.append({**{k: r.get(k) for k in ("pak", "size", "mtime", "name", "author", "uuid", "version", "enabled", "meta_error")},
                "match_note": ex.get("how"), "manual_note": ex.get("note"), "shared_with": shared, "status": overall, "sources": srcs})

json.dump({"generated": datetime.now(timezone.utc).isoformat(), "mods": out},
          open(os.path.join(S, "report.json"), "w", encoding="utf-8"), indent=1)
print(Counter(m["status"] for m in out))
if __name__ == "__main__" and "--details" in sys.argv:
    import sys
    sys.stdout.reconfigure(encoding="utf-8")
    f = lambda t: datetime.fromtimestamp(t).strftime("%Y-%m-%d") if t else "-"
    for m in out:
        if m["status"] in ("update", "check", "likely", "unknown"):
            for s in m["sources"] or [{}]:
                if s.get("status") != "current":
                    print(m["status"][:3], m["pak"][:38].ljust(38), m["mtime"][:10], (m["version"] or "")[:10].ljust(10), s.get("source", "--")[:2], "->",
                          (s.get("latest_file") or "")[:24].ljust(24), str(s.get("latest_version"))[:10].ljust(10), f(s.get("latest_date")), "|", (s.get("note") or "")[:60])
