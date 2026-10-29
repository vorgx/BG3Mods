"""Scan BG3 Mods folder: read meta.lsx from every pak and map to Nexus / mod.io IDs."""
import json, os, re, struct, sys, zlib
from datetime import datetime, timezone
import lz4.block, lz4.frame, zstandard
import xml.etree.ElementTree as ET

LOCAL = os.environ["LOCALAPPDATA"]
MODS = os.path.join(LOCAL, "Larian Studios", "Baldur's Gate 3", "Mods")
MODSETTINGS = os.path.join(LOCAL, "Larian Studios", "Baldur's Gate 3", "PlayerProfiles", "Public", "modsettings.lsx")
HELPER = os.path.join(LOCAL, "BG3ModHelper")
OUT = sys.argv[1]


def decompress(data, flags, usize):
    m = flags & 0x0F
    if m == 0:
        return data
    if m == 1:
        return zlib.decompress(data)
    if m == 2:
        try:
            return lz4.block.decompress(data, uncompressed_size=usize)
        except Exception:
            return lz4.frame.decompress(data)
    if m == 3:
        return zstandard.ZstdDecompressor().decompress(data, max_output_size=usize)
    raise ValueError(f"compression {m}")


def read_meta(path):
    with open(path, "rb") as f:
        magic = f.read(4)
        if magic != b"LSPK":
            return None, "not LSPK"
        ver, = struct.unpack("<I", f.read(4))
        if ver < 15:
            return None, f"old pak v{ver}"
        off, = struct.unpack("<Q", f.read(8))
        f.seek(off)
        nfiles, csize = struct.unpack("<II", f.read(8))
        esize = 272 if ver >= 18 else 296
        raw = lz4.block.decompress(f.read(csize), uncompressed_size=nfiles * esize)
        for i in range(nfiles):
            e = raw[i * esize:(i + 1) * esize]
            name = e[:256].split(b"\0", 1)[0].decode("utf-8", "replace")
            if not re.match(r"^Mods/[^/]+/meta\.lsx$", name, re.I):
                continue
            if esize == 272:
                o1, o2, part, fl, sod, us = struct.unpack("<IHBBII", e[256:272])
                foff = o1 | (o2 << 32)
            else:
                foff, sod, us, part, fl = struct.unpack("<QQQII", e[256:288])
            if part != 0:
                return None, "multipart"
            f.seek(foff)
            return decompress(f.read(sod), fl, us), None
    return None, "no meta.lsx"


def parse_meta(xml):
    xml = xml.decode("utf-8-sig", "replace")
    root = ET.fromstring(xml)
    info = {}
    for node in root.iter("node"):
        if node.get("id") == "ModuleInfo":
            for a in node.findall("attribute"):
                info[a.get("id")] = a.get("value")
            break
    v = info.get("Version64") or info.get("Version")
    vs = None
    if v and v.lstrip("-").isdigit():
        n = int(v)
        if info.get("Version64"):
            vs = f"{n >> 55}.{(n >> 47) & 0xFF}.{(n >> 31) & 0xFFFF}.{n & 0x7FFFFFFF}"
        else:
            vs = f"{n >> 28}.{(n >> 24) & 0xF}.{(n >> 16) & 0xFF}.{n & 0xFFFF}"
    return {
        "name": info.get("Name"), "author": info.get("Author"), "uuid": info.get("UUID"),
        "folder": info.get("Folder"), "version": vs, "description": (info.get("Description") or "")[:300],
    }


def load(name):
    p = os.path.join(HELPER, name)
    return json.load(open(p, encoding="utf-8-sig")) if os.path.exists(p) else {}


installed = load("installedmods.json").get("mods", {})
fileids = load("mod_fileids.json")
links = load("user_mod_links.json")
modio = load("modiodata.json").get("mods", {})
nexdb = load("nexusid_db.json")

by_pakname, by_uuid_db = {}, {}
for k, m in nexdb.items():
    if k == "_meta":
        continue
    for p in m.get("paks", []):
        if p.get("pakFileName"):
            by_pakname.setdefault(p["pakFileName"].lower(), set()).add(m["nexusModId"])
        if p.get("metaUuid"):
            by_uuid_db.setdefault(p["metaUuid"].lower(), set()).add(m["nexusModId"])

inst_by_name = {os.path.basename(k).lower(): v.get("modData", {}) for k, v in installed.items()}
links_nexus = {k.lower(): v for k, v in links.get("nexus", {}).items()}
links_modio = {k.lower(): v for k, v in links.get("modio", {}).items()} if isinstance(links.get("modio"), dict) else {}

# enabled mods from modsettings
enabled = set()
try:
    t = ET.parse(MODSETTINGS).getroot()
    for node in t.iter("node"):
        if node.get("id") in ("ModuleShortDesc",):
            for a in node.findall("attribute"):
                if a.get("id") == "UUID":
                    enabled.add(a.get("value").lower())
except Exception as ex:
    print("modsettings parse failed", ex)

rows = []
for fn in sorted(os.listdir(MODS), key=str.lower):
    if not fn.lower().endswith(".pak"):
        continue
    path = os.path.join(MODS, fn)
    st = os.stat(path)
    row = {"pak": fn, "size": st.st_size,
           "mtime": datetime.fromtimestamp(st.st_mtime, timezone.utc).isoformat()}
    try:
        data, err = read_meta(path)
        if data:
            row.update(parse_meta(data))
        else:
            row["meta_error"] = err
    except Exception as ex:
        row["meta_error"] = f"{type(ex).__name__}: {ex}"
    uuid = (row.get("uuid") or "").lower()
    low = fn.lower()
    nexus_id = file_id = None
    src = None
    if low in links_nexus:
        nexus_id, file_id, src = links_nexus[low].get("modId"), links_nexus[low].get("fileId"), "user link"
    elif uuid and uuid in fileids:
        nexus_id, file_id, src = fileids[uuid].get("nexusModId"), fileids[uuid].get("nexusFileId"), "file id"
    elif inst_by_name.get(low, {}).get("nexusModId"):
        nexus_id, src = inst_by_name[low]["nexusModId"], "helper"
    elif uuid and uuid in by_uuid_db and len(by_uuid_db[uuid]) == 1:
        nexus_id, src = next(iter(by_uuid_db[uuid])), "uuid db"
    elif low in by_pakname and len(by_pakname[low]) == 1:
        nexus_id, src = next(iter(by_pakname[low])), "pak name db"
    row["nexus_candidates"] = sorted((by_pakname.get(low, set()) | by_uuid_db.get(uuid, set())) - {nexus_id})[:6]
    row["nexus_id"], row["nexus_file_id"], row["nexus_src"] = nexus_id, file_id, src
    mi = modio.get(uuid)
    if not mi and low in links_modio:
        mi = links_modio[low]
    row["modio_id"] = mi.get("modioModId") if mi else None
    row["modio_url"] = mi.get("modioProfileUrl") if mi else None
    row["enabled"] = uuid in enabled if uuid else None
    rows.append(row)

json.dump(rows, open(OUT, "w", encoding="utf-8"), indent=1)
n = len(rows)
print("paks", n, "meta ok", sum(1 for r in rows if r.get("uuid")),
      "nexus", sum(1 for r in rows if r["nexus_id"]), "fileid", sum(1 for r in rows if r["nexus_file_id"]),
      "modio", sum(1 for r in rows if r["modio_id"]), "neither", sum(1 for r in rows if not r["nexus_id"] and not r["modio_id"]),
      "enabled", sum(1 for r in rows if r["enabled"]))
from collections import Counter
print(Counter(r.get("meta_error") for r in rows if r.get("meta_error")))
print(Counter(r["nexus_src"] for r in rows))
