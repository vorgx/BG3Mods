"""Run one ModUpdateCheck script inside a test sandbox, with the network and the bg3.exe check stubbed.

  python -I tests/run_tool.py <script.py> [args...]

Refuses (exit 3) before loading any tool code when a BG3MC_* path is unset or points outside work/test-sandbox.
Downloads are served from BG3MC_TEST_DOWNLOADS/<archive name> and Nexus GraphQL from BG3MC_TEST_GRAPHQL; every other
HTTP call raises.
"""
import json, os, runpy, shutil, sys

TESTS = os.path.dirname(os.path.abspath(__file__))
TOOL = os.path.dirname(TESTS)
sys.path[:0] = [TOOL, TESTS]
from sandbox import guard_problems

problems = guard_problems(os.environ)
if problems:
    print("[REFUSED] Not a sandbox run: " + "; ".join(problems), file=sys.stderr)
    sys.exit(3)

import requests


def _no_network(*a, **kw):
    raise RuntimeError("network access is blocked in the test sandbox")


requests.get = requests.post = requests.request = _no_network
requests.Session.request = _no_network

# only the scripts the tests cover: test_load.py starts the real game, and scan.py / verify.py ignore the overrides
ALLOWED = {"fix_order.py", "restore.py", "update.py", "build_lootpatch.py", "lo_scan.py", "lo_analyze.py", "addons.py", "build.py"}
script = sys.argv[1]
if script != "--probe" and script not in ALLOWED:
    print(f"[REFUSED] {script} is not on the sandbox allow-list", file=sys.stderr)
    sys.exit(3)
if script == "--probe":  # used by the guard tests: show what a tool would see, do nothing
    print("[PROBE] sandbox ok")
    sys.exit(0)

import bg3lib as L

L.bg3_running = lambda: os.environ.get("BG3MC_TEST_BG3_RUNNING") == "1"


def _nexus_get(path, **kw):
    if path.endswith("/download_link.json"):
        return [{"URI": "stub://nexus" + path}]
    _no_network()


def _download(url, dest, expected=None):
    src = os.path.join(os.environ["BG3MC_TEST_DOWNLOADS"], os.path.basename(dest))
    if not url.startswith("stub://") or not os.path.exists(src):
        raise RuntimeError(f"no stub download for {os.path.basename(dest)}")
    shutil.copy2(src, dest)
    return os.path.getsize(dest)


def _graphql(query, variables=None):
    """Canned Nexus GraphQL: the legacyMods nodes in BG3MC_TEST_GRAPHQL whose ids were asked for."""
    path = os.environ.get("BG3MC_TEST_GRAPHQL")
    if not path:
        _no_network()
    asked = {x["modId"] for x in (variables or {}).get("ids", [])}
    nodes = json.load(open(path, encoding="utf-8"))
    return {"legacyMods": {"nodes": [n for n in nodes if int(n["modId"]) in asked]}}


L.nexus_get, L.download, L.nexus_graphql = _nexus_get, _download, _graphql
L.modio_get = _no_network

sys.argv = [os.path.join(TOOL, script)] + sys.argv[2:]
runpy.run_path(sys.argv[0], run_name="__main__")
