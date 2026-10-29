"""Shared helpers for the fixer, updater, add-on scan and new-mod check: paths, pak reading, modsettings, APIs."""
import hashlib, json, os, re, shutil, struct, subprocess, sys, zipfile, zlib
from datetime import datetime
import xml.etree.ElementTree as ET
import lz4.block, lz4.frame, zstandard, requests

HERE = os.path.dirname(os.path.abspath(__file__))
WORK = os.environ.get("BG3MC_WORK") or os.path.join(HERE, "work")
CONF = os.path.join(HERE, "config")
PROJECT = os.path.normpath(os.path.join(HERE, "..", ".."))
BACKUPS = os.environ.get("BG3MC_BACKUPS") or os.path.join(PROJECT, "Backups", "ModCheck")
LOCAL = os.environ["LOCALAPPDATA"]
BG3 = os.path.join(LOCAL, "Larian Studios", "Baldur's Gate 3")
MODS = os.environ.get("BG3MC_MODS") or os.path.join(BG3, "Mods")  # overrides are for testing
MODSETTINGS = os.environ.get("BG3MC_MODSETTINGS") or os.path.join(BG3, "PlayerProfiles", "Public", "modsettings.lsx")
HELPER = os.path.join(LOCAL, "BG3ModHelper")
NEXUS_GAME_ID = 3474
MODIO_GAME_ID = 6715
NX = "https://api.nexusmods.com/v1/games/baldursgate3"
MODIO = f"https://g-{MODIO_GAME_ID}.modapi.io/v1/games/{MODIO_GAME_ID}"
ACTIVE = {"MAIN", "UPDATE", "OPTIONAL", "MISCELLANEOUS"}
BUILTIN = re.compile(r"^(Gustav|GustavDev|GustavX|Shared|SharedDev|Honour|HonourX|MainUI|ModBrowser|PhotoMode|CrossplayUI|Engine|Game|DiceSet_\d+)$", re.I)
# files inside the base game's own module folders: the game applies them from any pak in Mods, load order or not
OVERRIDE = re.compile(r"^(Public|Mods|Generated/Public)/(Game|Shared|SharedDev|Gustav|GustavDev|GustavX|Honour|HonourX|Engine|MainUI|"
                      r"ModBrowser|PhotoMode|CrossplayUI|DiceSet_\d+)/", re.I)
UUID_RE = re.compile(r"[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}", re.I)

if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8")


def load(name, default=None):
    p = os.path.join(WORK, name)
    return json.load(open(p, encoding="utf-8")) if os.path.exists(p) else default


def save(name, data):
    os.makedirs(WORK, exist_ok=True)
    json.dump(data, open(os.path.join(WORK, name), "w", encoding="utf-8"), indent=1, ensure_ascii=False)


# ---------- API sessions (keys come from BG3ModHelper, never stored here)
_cfg = None


def keys():
    global _cfg
    if _cfg is None:
        _cfg = json.load(open(os.path.join(HELPER, "settings.json"), encoding="utf-8-sig"))
    return _cfg.get("nexusAPIKey"), _cfg.get("modioAPIKey")


def nexus_get(path, **kw):
    nkey, _ = keys()
    h = {"apikey": nkey, "Application-Name": "TenoModUpdateCheck", "Application-Version": "1.1", "Accept": "application/json"}
    r = requests.get(path if path.startswith("http") else NX + path, headers=h, timeout=60, **kw)
    r.raise_for_status()
    return r.json()


def nexus_graphql(query, variables=None):
    r = requests.post("https://api.nexusmods.com/v2/graphql", json={"query": query, "variables": variables or {}}, timeout=60)
    r.raise_for_status()
    j = r.json()
    if j.get("errors"):
        raise RuntimeError(j["errors"][0].get("message"))
    return j["data"]


def modio_get(path, **params):
    _, mkey = keys()
    r = requests.get(MODIO + path, params={"api_key": mkey, **params}, timeout=60)
    r.raise_for_status()
    return r.json()


# ---------- pak reading (LSPK v15/v16/v18)
def _decompress(data, flags, usize):
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


def pak_entries(f):
    f.seek(0)
    if f.read(4) != b"LSPK":
        raise ValueError("not an LSPK pak")
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


def pak_read(f, e):
    name, foff, sod, us, fl, part = e
    if part != 0:
        return None
    f.seek(foff)
    return _decompress(f.read(sod), fl, us)


def _desc(node):
    a = {x.get("id"): x.get("value") for x in node.findall("attribute")}
    return {"uuid": (a.get("UUID") or "").lower(), "name": a.get("Name"), "folder": a.get("Folder"),
            "v64": a.get("Version64"), "author": a.get("Author"), "publish": a.get("PublishHandle")}


def version_str(v64):
    try:
        n = int(v64)
    except (TypeError, ValueError):
        return None
    return f"{n >> 55}.{(n >> 47) & 0xFF}.{(n >> 31) & 0xFFFF}.{n & 0x7FFFFFFF}"


STATS_RE = re.compile(r"^Public/[^/]+/Stats/Generated/.*\.txt$", re.I)


def scan_pak(path, want_stats=True):
    """meta (uuid, name, folder, version, deps), file list, stat entries with self-'using' flags, spellsets, treasure tables."""
    info = {"pak": os.path.basename(path), "size": os.path.getsize(path), "files": [], "stats": {}, "selfuse": [],
            "spellsets": [], "treasure": [], "deps": [], "se": False}
    with open(path, "rb") as f:
        for e in pak_entries(f):
            name = e[0]
            info["files"].append(name)
            if re.match(r"^Mods/[^/]+/meta\.lsx$", name, re.I) and "uuid" not in info:
                root = ET.fromstring(pak_read(f, e).decode("utf-8-sig", "replace"))
                for node in root.iter("node"):
                    if node.get("id") == "ModuleInfo" and "uuid" not in info:
                        d = _desc(node)
                        info.update(uuid=d["uuid"], name=d["name"], folder=d["folder"], v64=d["v64"],
                                    version=version_str(d["v64"]), author=d["author"])
                    elif node.get("id") == "Dependencies":
                        info["deps"] = [_desc(ch) for ch in node.iter("node") if ch.get("id") == "ModuleShortDesc"]
            elif re.match(r"^Mods/[^/]+/ScriptExtender/", name, re.I):
                info["se"] = True
            elif want_stats and STATS_RE.match(name):
                text = (pak_read(f, e) or b"").decode("utf-8", "replace")
                for part in re.split(r'(?m)^\s*new entry\s+', text)[1:]:
                    m = re.match(r'"([^"]+)"', part)
                    if not m:
                        continue
                    t = re.search(r'^\s*type\s+"([^"]+)"', part, re.M)
                    u = re.search(r'^\s*using\s+"([^"]+)"', part, re.M)
                    info["stats"][m.group(1)] = t.group(1) if t else "?"
                    if u and u.group(1) == m.group(1):
                        info["selfuse"].append(m.group(1))
                info["spellsets"] += re.findall(r'new spellset\s+"([^"]+)"', text)
                info["treasure"] += re.findall(r'new treasuretable\s+"([^"]+)"', text)
    return info


def version_tuple(v):
    parts = re.split(r"[.\-_ ]+", str(v or "").strip().lower().lstrip("v"))
    if not parts or not all(x.isdigit() for x in parts):
        return None
    out = [int(x) for x in parts]
    while len(out) > 1 and out[-1] == 0:
        out.pop()
    return out


def is_downgrade(installed, new):
    """True only when both versions are plain numbers with the same major and the new one is lower."""
    a, b = version_tuple(installed), version_tuple(new)
    if not a or not b or a[0] != b[0]:
        return False
    n = max(len(a), len(b))
    return b + [0] * (n - len(b)) < a + [0] * (n - len(a))


def file_md5(path):
    h = hashlib.md5()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(1 << 22), b""):
            h.update(chunk)
    return h.hexdigest()


# ---------- modsettings.lsx: edit the Mods list as raw text so everything else stays byte-identical
_MODS_BLOCK = re.compile(r'(<node id="Mods">\s*<children>)(.*?)(\s*</children>\s*</node>)', re.S)
_ENTRY = re.compile(r'[ \t]*<node id="ModuleShortDesc">.*?</node>', re.S)


def read_modsettings(path=None):
    path = path or MODSETTINGS
    with open(path, encoding="utf-8-sig", newline="") as f:  # keep the file's own line endings (CRLF)
        text = f.read()
    m = _MODS_BLOCK.search(text)
    if not m:
        raise ValueError("Mods list not found in modsettings.lsx")
    nodes = []
    for raw in _ENTRY.findall(m.group(2)):
        attrs = dict(re.findall(r'<attribute id="([^"]+)" type="[^"]+" value="([^"]*)"', raw))
        nodes.append({"raw": raw, "uuid": attrs.get("UUID", "").lower(), "name": attrs.get("Name"), "folder": attrs.get("Folder")})
    return text, m, nodes


def entry_xml(folder, name, uuid, v64, md5="", publish="0", indent="            "):
    esc = lambda s: (s or "").replace("&", "&amp;").replace('"', "&quot;").replace("<", "&lt;").replace(">", "&gt;")
    i2 = indent + "  "
    return (f'{indent}<node id="ModuleShortDesc">\n'
            f'{i2}<attribute id="Folder" type="LSString" value="{esc(folder)}" />\n'
            f'{i2}<attribute id="MD5" type="LSString" value="{esc(md5)}" />\n'
            f'{i2}<attribute id="Name" type="LSString" value="{esc(name)}" />\n'
            f'{i2}<attribute id="PublishHandle" type="uint64" value="{publish}" />\n'
            f'{i2}<attribute id="UUID" type="guid" value="{uuid}" />\n'
            f'{i2}<attribute id="Version64" type="int64" value="{v64}" />\n'
            f'{indent}</node>')


def set_attr(raw, attr, value):
    return re.sub(rf'(<attribute id="{attr}" type="[^"]+" value=")[^"]*(")', lambda m: m.group(1) + value + m.group(2), raw, count=1)


def write_modsettings(text, match, raws, path=None):
    path = path or MODSETTINGS
    nl = "\r\n" if "\r\n" in text else "\n"
    raws = [r.replace("\r\n", "\n").replace("\n", nl) for r in raws]
    body = nl + nl.join(raws)
    new = text[:match.start(2)] + body + text[match.end(2):]
    ET.fromstring(new)  # refuse to write anything that isn't valid XML
    with open(path, "w", encoding="utf-8", newline="") as f:
        f.write(new)


# ---------- safety
def bg3_running():
    out = subprocess.run(["tasklist", "/FO", "CSV", "/NH"], capture_output=True, text=True).stdout.lower()
    return any(n in out for n in ('"bg3.exe"', '"bg3_dx11.exe"'))


def new_backup_dir(label):
    d = os.path.join(BACKUPS, datetime.now().strftime("%Y%m%d_%H%M%S") + "_" + label)
    os.makedirs(d, exist_ok=True)
    return d


def backup_modsettings(d):
    shutil.copy2(MODSETTINGS, os.path.join(d, "modsettings.lsx"))
    json.dump({"modsettings": MODSETTINGS, "mods_folder": MODS, "created": datetime.now().isoformat(), "moved_paks": []},
              open(os.path.join(d, "backup.json"), "w", encoding="utf-8"), indent=1)


def record_added_pak(d, path):
    p = os.path.join(d, "backup.json")
    j = json.load(open(p, encoding="utf-8"))
    j.setdefault("added_paks", []).append(path)
    json.dump(j, open(p, "w", encoding="utf-8"), indent=1)


def record_moved_pak(d, original_path, backup_path, replaced_by=None):
    p = os.path.join(d, "backup.json")
    j = json.load(open(p, encoding="utf-8"))
    j["moved_paks"].append({"original": original_path, "backup": backup_path, "replaced_by": replaced_by})
    json.dump(j, open(p, "w", encoding="utf-8"), indent=1)


# ---------- archives
def extract(archive, dest):
    """Extract a downloaded archive into an empty folder; zip via zipfile, 7z/rar via Windows' bsdtar."""
    os.makedirs(dest, exist_ok=True)
    root = os.path.realpath(dest)
    if archive.lower().endswith(".pak"):
        shutil.copy2(archive, dest)
        return
    if zipfile.is_zipfile(archive):
        with zipfile.ZipFile(archive) as z:
            for n in z.namelist():
                target = os.path.realpath(os.path.join(dest, n))
                if not target.startswith(root + os.sep) and target != root:
                    raise ValueError(f"unsafe path in archive: {n}")
            z.extractall(dest)
    else:
        r = subprocess.run(["tar", "-xf", archive, "-C", dest], capture_output=True, text=True)
        if r.returncode:
            raise RuntimeError(f"could not extract {os.path.basename(archive)}: {r.stderr.strip()[:200]}")
    for dirpath, _, files in os.walk(dest):
        for fn in files:
            if not os.path.realpath(os.path.join(dirpath, fn)).startswith(root):
                raise ValueError("archive wrote outside its folder")


def find_paks(folder):
    return [os.path.join(dp, fn) for dp, _, fs in os.walk(folder) for fn in fs if fn.lower().endswith(".pak")]


def download(url, dest, expected=None):
    with requests.get(url, stream=True, timeout=120) as r:
        r.raise_for_status()
        with open(dest, "wb") as f:
            for chunk in r.iter_content(1 << 20):
                f.write(chunk)
    size = os.path.getsize(dest)
    if expected and abs(size - expected) > max(1024, expected * 0.01):
        raise RuntimeError(f"size mismatch for {os.path.basename(dest)}: got {size}, expected about {expected}")
    return size
