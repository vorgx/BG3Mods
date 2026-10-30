"""Load-order scan: read modsettings order, and per pak its dependencies, file list, stats entries and SE use."""
import json, os, re, struct, sys, zlib
import xml.etree.ElementTree as ET
import lz4.block, lz4.frame, zstandard

LOCAL = os.environ["LOCALAPPDATA"]
BG3 = os.path.join(LOCAL, "Larian Studios", "Baldur's Gate 3")
MODS = os.environ.get("BG3MC_MODS") or os.path.join(BG3, "Mods")  # overrides are for testing
MODSETTINGS = os.environ.get("BG3MC_MODSETTINGS") or os.path.join(BG3, "PlayerProfiles", "Public", "modsettings.lsx")
OUT = sys.argv[1]
STATS_RE = re.compile(r"^Public/[^/]+/Stats/Generated/Data/[^/]+\.txt$", re.I)


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


def entries(f):
    f.seek(0)
    if f.read(4) != b"LSPK":
        raise ValueError("not LSPK")
    ver, = struct.unpack("<I", f.read(4))
    off, = struct.unpack("<Q", f.read(8))
    f.seek(off)
    nfiles, csize = struct.unpack("<II", f.read(8))
    esize = 272 if ver >= 18 else 296
    raw = lz4.block.decompress(f.read(csize), uncompressed_size=nfiles * esize)
    out = []
    for i in range(nfiles):
        e = raw[i * esize:(i + 1) * esize]
        name = e[:256].split(b"\0", 1)[0].decode("utf-8", "replace")
        if esize == 272:
            o1, o2, part, fl, sod, us = struct.unpack("<IHBBII", e[256:272])
            foff = o1 | (o2 << 32)
        else:
            foff, sod, us, part, fl = struct.unpack("<QQQII", e[256:288])
        out.append((name, foff, sod, us, fl, part))
    return out


def read(f, e):
    name, foff, sod, us, fl, part = e
    if part != 0:
        return None
    f.seek(foff)
    return decompress(f.read(sod), fl, us)


def module_desc(node):
    a = {x.get("id"): x.get("value") for x in node.findall("attribute")}
    return {"uuid": (a.get("UUID") or "").lower(), "name": a.get("Name"), "folder": a.get("Folder"), "v64": a.get("Version64")}


def parse_meta(xml):
    root = ET.fromstring(xml.decode("utf-8-sig", "replace"))
    info, deps, conflicts = {}, [], []
    for node in root.iter("node"):
        nid = node.get("id")
        if nid == "ModuleInfo" and not info:
            info = module_desc(node)
        elif nid in ("Dependencies", "Conflicts"):
            for ch in node.iter("node"):
                if ch.get("id") == "ModuleShortDesc":
                    (deps if nid == "Dependencies" else conflicts).append(module_desc(ch))
    return info, deps, conflicts


ENTRY = re.compile(r'^\s*new entry\s+"([^"]+)"', re.M)
TYPE = re.compile(r'^\s*type\s+"([^"]+)"', re.M)

paks = []
for fn in sorted(os.listdir(MODS), key=str.lower):
    if not fn.lower().endswith(".pak"):
        continue
    rec = {"pak": fn, "files": [], "stats": {}, "deps": [], "conflicts": [], "se": False}
    try:
        with open(os.path.join(MODS, fn), "rb") as f:
            es = entries(f)
            for e in es:
                name = e[0]
                rec["files"].append(name)
                if re.match(r"^Mods/[^/]+/meta\.lsx$", name, re.I) and "uuid" not in rec:
                    info, deps, conflicts = parse_meta(read(f, e))
                    rec.update(uuid=info.get("uuid"), name=info.get("name"), folder=info.get("folder"))
                    rec["deps"], rec["conflicts"] = deps, conflicts
                elif re.match(r"^Mods/[^/]+/ScriptExtender/", name, re.I):
                    rec["se"] = True
                elif STATS_RE.match(name):
                    data = read(f, e)
                    if data:
                        text = data.decode("utf-8", "replace")
                        # pair each entry with the type line that follows it
                        parts = re.split(r'(?m)^\s*new entry\s+', text)
                        for p in parts[1:]:
                            m = re.match(r'"([^"]+)"', p)
                            t = TYPE.search(p)
                            if m:
                                rec["stats"][m.group(1)] = t.group(1) if t else "?"
    except Exception as ex:
        rec["error"] = f"{type(ex).__name__}: {ex}"
    paks.append(rec)

order = []
root = ET.parse(MODSETTINGS).getroot()
for node in root.iter("node"):
    if node.get("id") == "Mods":
        children = node.find("children")
        for ch in (children if children is not None else []):
            if ch.get("id") == "ModuleShortDesc":
                order.append(module_desc(ch))
        break

json.dump({"order": order, "paks": paks}, open(OUT, "w", encoding="utf-8"))
print("order", len(order), "paks", len(paks), "errors", [p["pak"] for p in paks if p.get("error")],
      "se", sum(p["se"] for p in paks), "with deps", sum(1 for p in paks if p["deps"]),
      "stats entries", sum(len(p["stats"]) for p in paks), "files", sum(len(p["files"]) for p in paks))
