"""Sandbox for the ModUpdateCheck tests: live-path guard, synthetic paks, a CRLF modsettings.lsx and a script runner.

Every test works in its own folder under work/test-sandbox/. The tools are pointed there with BG3MC_MODS,
BG3MC_MODSETTINGS, BG3MC_BACKUPS, BG3MC_WORK and BG3MC_CONF, and run_tool.py refuses to start a tool when any of
those is unset or resolves outside the sandbox (in particular to the live game).
"""
import hashlib, io, json, os, shutil, struct, subprocess, sys, zipfile
from datetime import datetime

TESTS = os.path.dirname(os.path.abspath(__file__))
TOOL = os.path.dirname(TESTS)
PROJECT = os.path.normpath(os.path.join(TOOL, "..", ".."))
SANDBOX_ROOT = os.path.join(TOOL, "work", "test-sandbox")
PY = sys.executable

LIVE_BG3 = os.path.join(os.environ.get("LOCALAPPDATA", ""), "Larian Studios", "Baldur's Gate 3")
LIVE_MODS = os.path.join(LIVE_BG3, "Mods")
LIVE_MODSETTINGS = os.path.join(LIVE_BG3, "PlayerProfiles", "Public", "modsettings.lsx")
LIVE_GAME = r"F:\SteamLibrary\steamapps\common\Baldurs Gate 3"
REAL_BACKUPS = os.path.join(PROJECT, "Backups", "ModCheck")
GUARDED = ("BG3MC_MODS", "BG3MC_MODSETTINGS", "BG3MC_BACKUPS", "BG3MC_WORK", "BG3MC_CONF")


def _real(p):
    return os.path.normcase(os.path.realpath(p))


def _inside(p, root, strict=False):
    p, root = _real(p), _real(root)
    return (p == root and not strict) or p.startswith(root.rstrip("\\/") + os.sep)


def guard_problems(env):
    """Reasons the environment isn't a safe sandbox (empty list = safe)."""
    out = []
    for k in GUARDED:
        v = env.get(k)
        if not v:
            out.append(f"{k} is not set")
            continue
        for live in (LIVE_BG3, LIVE_GAME, REAL_BACKUPS):
            if _inside(v, live) or _inside(live, v):
                out.append(f"{k} resolves to a live path ({live})")
        if not _inside(v, SANDBOX_ROOT, strict=True):
            out.append(f"{k} is outside {SANDBOX_ROOT}")
    if not _inside(SANDBOX_ROOT, os.path.join(TOOL, "work"), strict=True):
        out.append("the sandbox folder is a link out of work/")
    return out


# ---------- synthetic paks (LSPK v18, stored uncompressed, which the tool's reader and the game both accept)
def v64(a, b=0, c=0, d=0):
    return str((a << 55) | (b << 47) | (c << 31) | d)


def meta_lsx(folder, name, uuid, version, deps=()):
    dep_xml = "".join(
        f'\n          <node id="ModuleShortDesc">\n            <attribute id="Folder" type="LSString" value="{d["folder"]}" />'
        f'\n            <attribute id="MD5" type="LSString" value="" />\n            <attribute id="Name" type="LSString" value="{d["name"]}" />'
        f'\n            <attribute id="UUID" type="guid" value="{d["uuid"]}" />'
        f'\n            <attribute id="Version64" type="int64" value="0" />\n          </node>' for d in deps)
    return f'''<?xml version="1.0" encoding="utf-8"?>
<save>
  <version major="4" minor="0" revision="9" build="331" />
  <region id="Config">
    <node id="root">
      <children>
        <node id="Dependencies">
          <children>{dep_xml}
          </children>
        </node>
        <node id="ModuleInfo">
          <attribute id="Author" type="LSWString" value="test" />
          <attribute id="Folder" type="LSWString" value="{folder}" />
          <attribute id="Name" type="FixedString" value="{name}" />
          <attribute id="UUID" type="FixedString" value="{uuid}" />
          <attribute id="Version64" type="int64" value="{version}" />
        </node>
      </children>
    </node>
  </region>
</save>
'''.encode("utf-8")


def write_pak(path, files):
    """files: {path inside pak: bytes}."""
    import lz4.block
    header_size = 40
    body, entries = io.BytesIO(), []
    for name, data in files.items():
        off = header_size + body.tell()
        body.write(data)
        n = name.encode("utf-8")[:255].ljust(256, b"\0")
        entries.append(n + struct.pack("<IHBBII", off & 0xFFFFFFFF, off >> 32, 0, 0, len(data), len(data)))
    raw = b"".join(entries)
    comp = lz4.block.compress(raw, store_size=False)
    list_off = header_size + body.tell()
    filelist = struct.pack("<II", len(entries), len(comp)) + comp
    header = b"LSPK" + struct.pack("<IQIBB", 18, list_off, len(filelist), 0, 0) + b"\0" * 16 + struct.pack("<H", 1)
    assert len(header) == header_size
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "wb") as f:
        f.write(header + body.getvalue() + filelist)
    return path


def mod_pak(path, folder, name, uuid, version, deps=(), files=None, meta=True):
    content = {}
    if meta:
        content[f"Mods/{folder}/meta.lsx"] = meta_lsx(folder, name, uuid, version, deps)
    content.update(files if files is not None else {f"Public/{folder}/Stats/Generated/Data/{folder}.txt": b'new entry "X"\ntype "Armor"\n'})
    return write_pak(path, content)


def treasure(*tables):
    """tables: (name, [(subtable header, [item ids])], can_merge)."""
    out = []
    for name, subs, merge in tables:
        out.append(f'new treasuretable "{name}"')
        if merge:
            out.append("CanMerge 1")
        for head, items in subs:
            out.append(f'new subtable "{head}"')
            out += [f'object category "{i}",1,0,0,0,0,0,0,0' for i in items]
    return ("\n".join(out) + "\n").encode("utf-8")


# ---------- modsettings.lsx, as the game writes it (CRLF)
GUSTAVX = {"folder": "GustavX", "name": "GustavX", "uuid": "cb555efe-2d9e-131f-8195-a89329d218ea", "v64": "145241946983300916"}


def entry(m):
    return (f'            <node id="ModuleShortDesc">\n'
            f'              <attribute id="Folder" type="LSString" value="{m["folder"]}" />\n'
            f'              <attribute id="MD5" type="LSString" value="{m.get("md5", "")}" />\n'
            f'              <attribute id="Name" type="LSString" value="{m["name"]}" />\n'
            f'              <attribute id="PublishHandle" type="uint64" value="{m.get("publish", "0")}" />\n'
            f'              <attribute id="UUID" type="guid" value="{m["uuid"]}" />\n'
            f'              <attribute id="Version64" type="int64" value="{m["v64"]}" />\n'
            f'            </node>')


def modsettings_text(mods):
    body = "\n".join(entry(m) for m in [GUSTAVX] + list(mods))
    text = ('<?xml version="1.0" encoding="UTF-8"?>\n<save>\n  <version major="4" minor="8" revision="0" build="100" />\n'
            '  <region id="ModuleSettings">\n    <node id="root">\n      <children>\n        <node id="Mods">\n          <children>\n'
            f'{body}\n          </children>\n        </node>\n      </children>\n    </node>\n  </region>\n</save>\n')
    return text.replace("\n", "\r\n").encode("utf-8")


def md5(path):
    return hashlib.md5(open(path, "rb").read()).hexdigest()


# ---------- one sandbox per test
class Sandbox:
    _run_dir = None

    def __init__(self, label):
        if Sandbox._run_dir is None:
            Sandbox._run_dir = os.path.join(SANDBOX_ROOT, datetime.now().strftime("%Y%m%d_%H%M%S_%f"))
        self.root = os.path.join(Sandbox._run_dir, label)
        assert _inside(self.root, SANDBOX_ROOT, strict=True)
        self.mods = os.path.join(self.root, "Mods")
        self.modsettings = os.path.join(self.root, "PlayerProfiles", "Public", "modsettings.lsx")
        self.backups = os.path.join(self.root, "Backups")
        self.work = os.path.join(self.root, "work")
        self.conf = os.path.join(self.root, "config")
        self.downloads = os.path.join(self.root, "remote")
        for d in (self.mods, os.path.dirname(self.modsettings), self.work, self.conf, self.downloads):
            os.makedirs(d, exist_ok=True)
        for f in ("incompat_verified.json", "manual_rules.json", "extra_matches.json", "known_issues.json"):
            self.write_json(os.path.join(self.conf, f), [] if f in ("incompat_verified.json", "manual_rules.json") else {})
        self.mods_list = []

    # fixtures
    def add_mod(self, pak, folder, name, uuid, version=None, deps=(), files=None, in_order=True, meta=True):
        version = version or v64(1)
        mod_pak(os.path.join(self.mods, pak), folder, name, uuid, version, deps, files, meta)
        m = {"pak": pak, "folder": folder, "name": name, "uuid": uuid, "v64": version}
        if in_order:
            self.mods_list.append(m)
        return m

    def write_modsettings(self, mods=None):
        open(self.modsettings, "wb").write(modsettings_text(self.mods_list if mods is None else mods))
        return self.read_modsettings()

    def read_modsettings(self):
        return open(self.modsettings, "rb").read()

    @staticmethod
    def write_json(path, data):
        os.makedirs(os.path.dirname(path), exist_ok=True)
        json.dump(data, open(path, "w", encoding="utf-8"), indent=1)

    def work_json(self, name, data=None):
        p = os.path.join(self.work, name)
        if data is None:
            return json.load(open(p, encoding="utf-8"))
        self.write_json(p, data)

    def backup_dirs(self):
        return sorted(os.listdir(self.backups)) if os.path.isdir(self.backups) else []

    # running the tools
    def env(self, **extra):
        e = dict(os.environ)
        e.update(BG3MC_MODS=self.mods, BG3MC_MODSETTINGS=self.modsettings, BG3MC_BACKUPS=self.backups,
                 BG3MC_WORK=self.work, BG3MC_CONF=self.conf, BG3MC_TEST_DOWNLOADS=self.downloads,
                 PYTHONIOENCODING="utf-8")
        e.update(extra)
        return e

    def run(self, script, *args, bg3_running=False, expect=0, env=None):
        e = env or self.env()
        e["BG3MC_TEST_BG3_RUNNING"] = "1" if bg3_running else "0"
        r = subprocess.run([PY, "-I", os.path.join(TESTS, "run_tool.py"), script, *args], env=e,
                           capture_output=True, text=True, encoding="utf-8", timeout=300)
        out = r.stdout + r.stderr
        if expect is not None:
            ok = r.returncode == 0 if expect == 0 else r.returncode != 0
            assert ok, f"{script} {' '.join(args)} exited {r.returncode}:\n{out}"
        return out

    def analyse(self, report_mods=()):
        """Run lo_scan + lo_analyze on the sandbox, as Run-ModCheck.ps1 does (no network steps)."""
        self.work_json("report.json", {"mods": list(report_mods)})
        self.work_json("lo_notes.json", {})
        self.run("lo_scan.py", os.path.join(self.work, "lo_data.json"))
        self.run("lo_analyze.py")
        return self.work_json("lo_report.json")
