"""Fetch latest mod info from Nexus (v1 API) and mod.io for the scanned paks."""
import json, os, sys, time
from concurrent.futures import ThreadPoolExecutor
import requests

HERE = os.path.dirname(os.path.abspath(__file__))
S = os.environ.get("BG3MC_WORK") or os.path.join(HERE, "work")  # caches and intermediate JSON
CONF = os.path.join(HERE, "config")  # hand-checked matches and rules
rows = json.load(open(os.path.join(S, "installed.json"), encoding="utf-8"))
cfg = json.load(open(os.path.join(os.environ["LOCALAPPDATA"], "BG3ModHelper", "settings.json"), encoding="utf-8-sig"))
NKEY, MKEY = cfg.get("nexusAPIKey"), cfg.get("modioAPIKey")
H = {"apikey": NKEY, "Application-Name": "TenoModUpdateCheck", "Application-Version": "1.0", "Accept": "application/json"}
NX = "https://api.nexusmods.com/v1/games/baldursgate3/mods"
cache_path = os.path.join(S, "nexus_cache.json")
cache = json.load(open(cache_path, encoding="utf-8")) if os.path.exists(cache_path) else {}
limit = {}


def get(url, **kw):
    for attempt in range(4):
        r = requests.get(url, timeout=30, **kw)
        for h in ("x-rl-hourly-remaining", "x-rl-daily-remaining"):
            if h in r.headers:
                limit[h] = r.headers[h]
        if r.status_code == 429:
            time.sleep(5 * (attempt + 1))
            continue
        return r
    return r


def nexus(mid):
    key = str(mid)
    if key in cache and "files" in cache[key]:
        return
    out = {}
    r = get(f"{NX}/{mid}.json", headers=H)
    out["mod_status"] = r.status_code
    if r.ok:
        out["mod"] = r.json()
    r = get(f"{NX}/{mid}/files.json", headers=H)
    out["files_status"] = r.status_code
    if r.ok:
        out["files"] = r.json()
    cache[key] = out


extra = json.load(open(os.path.join(CONF, "extra_matches.json"), encoding="utf-8"))
ids = sorted({r["nexus_id"] for r in rows if r["nexus_id"]} | {e["nexus_id"] for e in extra.values() if e.get("nexus_id")})
if "--test" in sys.argv:
    ids = ids[:2]
with ThreadPoolExecutor(6) as ex:
    list(ex.map(nexus, ids))
json.dump(cache, open(cache_path, "w", encoding="utf-8"))
print("nexus fetched", len(ids), "ok", sum(1 for i in ids if cache[str(i)].get("mod_status") == 200), "limits", limit)
print("statuses", sorted({(v.get("mod_status"), v.get("files_status")) for v in cache.values()}))

# mod.io: find BG3 game id, then batch mods
r = get("https://api.mod.io/v1/games", params={"api_key": MKEY, "name_id": "baldursgate3"})
print("modio games", r.status_code)
gid = r.json()["data"][0]["id"]
mids = sorted({r["modio_id"] for r in rows if r["modio_id"]} | {e["modio_id"] for e in extra.values() if e.get("modio_id")})
modio = {}
for i in range(0, len(mids), 100):
    chunk = mids[i:i + 100]
    r = get(f"https://g-{gid}.modapi.io/v1/games/{gid}/mods",
            params={"api_key": MKEY, "id-in": ",".join(map(str, chunk)), "_limit": 100})
    print("modio batch", r.status_code, len(r.json().get("data", [])))
    for m in r.json().get("data", []):
        modio[str(m["id"])] = m
json.dump({"game_id": gid, "mods": modio}, open(os.path.join(S, "modio_cache.json"), "w", encoding="utf-8"))
print("modio fetched", len(modio), "of", len(mids))
