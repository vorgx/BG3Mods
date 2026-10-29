"""Hash every installed pak and match it against the per-file SHA1s in Nexus download manifests."""
import hashlib, json, os, sys
from concurrent.futures import ThreadPoolExecutor
import requests

sys.stdout.reconfigure(encoding="utf-8")
HERE = os.path.dirname(os.path.abspath(__file__))
S = os.environ.get("BG3MC_WORK") or os.path.join(HERE, "work")  # caches and intermediate JSON
CONF = os.path.join(HERE, "config")  # hand-checked matches and rules
MODS = os.path.join(os.environ["LOCALAPPDATA"], "Larian Studios", "Baldur's Gate 3", "Mods")
nexus = json.load(open(os.path.join(S, "nexus_cache.json"), encoding="utf-8"))
rep = json.load(open(os.path.join(S, "report.json"), encoding="utf-8"))["mods"]
MDIR = os.path.join(S, "manifests")
os.makedirs(MDIR, exist_ok=True)
ACTIVE = {"MAIN", "UPDATE", "OPTIONAL", "MISCELLANEOUS"}

targets = {}  # pak -> nexus mod id
for m in rep:
    for s in m["sources"]:
        if s["source"] == "nexus":
            targets[m["pak"]] = s["id"]

files = []  # (mod id, file dict) for every active file on the pages we care about
for mid in set(targets.values()):
    for f in nexus[str(mid)]["files"]["files"]:
        if f.get("category_name") in ACTIVE and f.get("content_preview_link"):
            files.append((mid, f))


def manifest(item):
    mid, f = item
    p = os.path.join(MDIR, f"{f['file_id']}.json")
    if os.path.exists(p):
        return
    try:
        r = requests.get(f["content_preview_link"], timeout=30)
        json.dump(r.json() if r.ok else {"error": r.status_code}, open(p, "w", encoding="utf-8"))
    except Exception as ex:
        json.dump({"error": str(ex)}, open(p, "w", encoding="utf-8"))


with ThreadPoolExecutor(8) as ex:
    list(ex.map(manifest, files))
print("manifests", len(files))


def sha1(pak):
    h = hashlib.sha1()
    with open(os.path.join(MODS, pak), "rb") as f:
        for chunk in iter(lambda: f.read(1 << 22), b""):
            h.update(chunk)
    return h.hexdigest()


with ThreadPoolExecutor(4) as ex:
    hashes = dict(zip(targets, ex.map(sha1, targets)))
print("hashed", len(hashes))

# index: per mod page, every pak inside every active file
UNITS = {"b": 1, "kb": 1000, "mb": 1000 ** 2, "gb": 1000 ** 3}


def walk(children):
    for ch in children or []:
        if ch.get("type") == "directory":
            yield from walk(ch.get("children"))
        else:
            yield ch


def size_matches(actual, text):
    """Old manifests give sizes like '21.2 kB' (rounded to 0.1 of the unit); accept 1000- or 1024-based units."""
    try:
        num, unit = text.split()
        num = float(num)
    except Exception:
        return None
    u = unit.lower()
    if u not in UNITS:
        return None
    for base in (1000, 1024):
        mult = {"b": 1, "kb": base, "mb": base ** 2, "gb": base ** 3}[u]
        if abs(actual - num * mult) <= 0.05 * mult + 1:
            return True
    return False


index = {}
for mid, f in files:
    j = json.load(open(os.path.join(MDIR, f"{f['file_id']}.json"), encoding="utf-8"))
    meta = {"file": f["name"], "file_id": f["file_id"], "version": f.get("version"),
            "uploaded": f["uploaded_timestamp"], "category": f.get("category_name")}
    for e in j.get("files", []):
        name = os.path.basename(e["file_path"].replace("\\", "/")).lower()
        if name.endswith(".pak"):
            index.setdefault(mid, []).append({**meta, "pak": name, "sha1": (e.get("file_hashes") or {}).get("SHA1", "").lower(),
                                              "size": e.get("file_size")})
    for e in walk(j.get("children")):
        name = (e.get("name") or "").lower()
        if name.endswith(".pak"):
            index.setdefault(mid, []).append({**meta, "pak": name, "sha1": "", "size_text": e.get("size")})

out = {}
for pak, mid in targets.items():
    entries = index.get(mid, [])
    mine = hashes[pak]
    size = os.path.getsize(os.path.join(MODS, pak))
    exact = [e for e in entries if e["sha1"] and e["sha1"] == mine]
    same_name = [e for e in entries if e["pak"] == pak.lower()]
    newest_same = max(same_name, key=lambda e: e["uploaded"]) if same_name else None
    if exact:
        hit = max(exact, key=lambda e: e["uploaded"])
        # a newer upload of the same file series (same file title) replaces yours; a different title is just another variant
        newer = [e for e in same_name if e["file"] == hit["file"] and e["uploaded"] > hit["uploaded"] and e.get("sha1") != mine]
        if newer:
            newest_same = max(newer, key=lambda e: e["uploaded"])
            out[pak] = {"result": "outdated", "have": hit, "latest": newest_same}
        else:
            out[pak] = {"result": "identical", "have": hit, "latest": hit}
    elif newest_same and newest_same["sha1"]:
        out[pak] = {"result": "differs", "latest": newest_same}
    elif newest_same:
        checks = [(e, size_matches(size, e.get("size_text") or "")) for e in same_name]
        match = [e for e, m in checks if m]
        if match:
            out[pak] = {"result": "size-match", "latest": max(match, key=lambda e: e["uploaded"]), "size": size}
        elif any(m is False for _, m in checks):
            out[pak] = {"result": "size-differs", "latest": newest_same, "size": size}
        else:
            out[pak] = {"result": "not-listed"}
    else:
        # renamed inside the download: accept a single pak on the page with a matching size
        match = [e for e in entries if e.get("size_text") and size_matches(size, e["size_text"])]
        if len({e["pak"] for e in match}) == 1:
            out[pak] = {"result": "size-match", "latest": max(match, key=lambda e: e["uploaded"]), "size": size, "renamed": True}
        else:
            out[pak] = {"result": "not-listed"}
json.dump(out, open(os.path.join(S, "verify.json"), "w", encoding="utf-8"), indent=1)
from collections import Counter
print(Counter(v["result"] for v in out.values()))
