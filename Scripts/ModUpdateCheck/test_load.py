"""Check that Baldur's Gate 3 accepts the current load order, and find the mod if it doesn't.

At startup the game runs basic checks on modsettings.lsx and, if any mod fails them, quietly resets the whole list
to the base game a few seconds in. This launches the game, waits for that, and closes it again (it never gets past
the main menu, so saves are untouched). modsettings.lsx is always put back the way it was.

  python test_load.py              one launch: does the game keep the current order?
  python test_load.py --find       if it resets, bisect over recently changed mods to find the culprit
  python test_load.py --find --days 30     look at mods changed in the last 30 days (default: since the last passing test)
"""
import argparse, json, os, subprocess, sys, time
from datetime import datetime
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import bg3lib as L

ap = argparse.ArgumentParser()
ap.add_argument("--find", action="store_true")
ap.add_argument("--days", type=float)
ap.add_argument("--wait", type=int, default=45, help="seconds to wait for a reset before calling it a pass")
args = ap.parse_args()

LAST_GOOD = os.path.join(L.WORK, "last_good_load.json")


def game_bin():
    for p in (os.path.join("C:/temp/bg3mm/Data/settings.json"),):
        try:
            exe = json.load(open(p, encoding="utf-8-sig")).get("GameExecutablePath")
            if exe and os.path.exists(exe):
                return os.path.dirname(exe)
        except (OSError, ValueError):
            pass
    p = os.environ.get("BG3_BIN") or "F:/SteamLibrary/steamapps/common/Baldurs Gate 3/bin"
    if not os.path.exists(os.path.join(p, "bg3.exe")):
        sys.exit("[FAIL] Can't find bg3.exe. Set BG3_BIN to the game's bin folder.")
    return p


BIN = game_bin()
text, match, nodes = L.read_modsettings()
original = open(L.MODSETTINGS, "rb").read()
uuids = [n["uuid"] for n in nodes]
raw = {n["uuid"]: n["raw"] for n in nodes}
builtin = [n["uuid"] for n in nodes if L.BUILTIN.match(n["name"] or "") or L.BUILTIN.match(n["folder"] or "")]
pak_of, deps_of = {}, {}
for fn in os.listdir(L.MODS):
    if fn.lower().endswith(".pak"):
        try:
            s = L.scan_pak(os.path.join(L.MODS, fn), want_stats=False)
        except Exception:
            continue
        if s.get("uuid"):
            pak_of[s["uuid"]] = fn
            deps_of[s["uuid"]] = {d["uuid"] for d in s["deps"]}
name = {n["uuid"]: n["name"] for n in nodes}


def closure(drop):
    drop = set(drop)
    changed = True
    while changed:
        changed = False
        for u in uuids:
            if u not in drop and deps_of.get(u, set()) & drop:
                drop.add(u)
                changed = True
    return drop


def stop_game():
    for exe in ("bg3.exe", "bg3_dx11.exe"):
        subprocess.run(["taskkill", "/IM", exe, "/F"], capture_output=True)
    while L.bg3_running():
        time.sleep(1)
    time.sleep(2)


def launch_ok(drop=frozenset(), label="current order"):
    keep = [raw[u] for u in uuids if u not in drop]
    L.write_modsettings(text, match, keep)
    before = os.path.getmtime(L.MODSETTINGS)
    subprocess.Popen([os.path.join(BIN, "bg3.exe")], cwd=BIN)
    reset, t0 = False, time.time()
    while time.time() - t0 < args.wait:
        time.sleep(1)
        if os.path.getmtime(L.MODSETTINGS) != before:
            time.sleep(1)
            reset = len(L.read_modsettings()[2]) < len(keep)
            break
    stop_game()
    print(f"[TEST] {label}: {len(keep)} entries -> {'RESET by the game' if reset else 'kept'} ({time.time() - t0:.0f}s)", flush=True)
    return not reset


if L.bg3_running():
    sys.exit("[FAIL] Close Baldur's Gate 3 first.")
try:
    ok = launch_ok()
    if ok:
        json.dump({"time": time.time(), "when": datetime.now().isoformat(timespec="seconds"), "entries": len(uuids)},
                  open(LAST_GOOD, "w"), indent=1)
        print("[PASS] The game keeps this load order.")
    elif not args.find:
        print("[FAIL] The game resets this load order at startup. Run with --find to locate the mod causing it.")
    else:
        since = time.time() - args.days * 86400 if args.days else \
            (json.load(open(LAST_GOOD))["time"] if os.path.exists(LAST_GOOD) else time.time() - 7 * 86400)
        suspects = [u for u in uuids if u not in builtin and u in pak_of
                    and os.path.getmtime(os.path.join(L.MODS, pak_of[u])) > since]
        print(f"[INFO] {len(suspects)} mods changed since {datetime.fromtimestamp(since):%Y-%m-%d %H:%M}")
        if not suspects or not launch_ok(frozenset(closure(suspects)), f"without all {len(suspects)} changed mods"):
            print("[FAIL] The order still resets without the recently changed mods; try --days with a larger number.")
        else:
            while len(suspects) > 1:
                half = suspects[:len(suspects) // 2]
                if launch_ok(frozenset(closure(half)), f"without {len(half)} of {len(suspects)} suspects"):
                    suspects = half
                else:
                    suspects = suspects[len(suspects) // 2:]
            u = suspects[0]
            dependents = closure({u}) - {u}
            # removing u also removed the mods that depend on it; keep u and drop only those to tell them apart
            if dependents and launch_ok(frozenset(dependents), f"without only the {len(dependents)} mods that need {name.get(u)}"):
                print(f"[RESULT] The game rejects one of the mods that depend on {name.get(u)}: "
                      f"{', '.join(sorted(name.get(x, x) for x in dependents))}")
            else:
                print(f"[RESULT] The game rejects: {name.get(u)} ({pak_of.get(u)})")
finally:
    if L.bg3_running():
        stop_game()
    open(L.MODSETTINGS, "wb").write(original)
    print("[INFO] modsettings.lsx restored to how it was before the test.")
