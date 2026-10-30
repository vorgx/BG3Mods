"""Run the ModUpdateCheck sandbox tests and prove the live game wasn't touched.

  python -I tests/run_tests.py [-k pattern] [-v]

Before and after the tests it records the modification time and size of the live modsettings.lsx, the Mods folder
and every pak in it, the real Backups/ModCheck folder and the real work/*.json files. Any difference fails the run.
"""
import argparse, glob, hashlib, os, shutil, sys, unittest

TESTS = os.path.dirname(os.path.abspath(__file__))
sys.path[:0] = [os.path.dirname(TESTS), TESTS]
import sandbox as S


def _stat(p):
    try:
        st = os.stat(p)
        return st.st_mtime_ns, st.st_size
    except FileNotFoundError:
        return None


def snapshot():
    # a folder's reported size is its index allocation, which Windows can change without any write, so folders use mtime only
    dir_mtime = lambda p: (_stat(p) or (None,))[0]
    snap = {"modsettings": _stat(S.LIVE_MODSETTINGS), "mods_dir": dir_mtime(S.LIVE_MODS), "backups_dir": dir_mtime(S.REAL_BACKUPS)}
    if os.path.isdir(S.LIVE_MODS):
        snap["paks"] = {f: _stat(os.path.join(S.LIVE_MODS, f)) for f in os.listdir(S.LIVE_MODS)}
    if os.path.isfile(S.LIVE_MODSETTINGS):  # copy2 keeps mtime, and a reordered file has the same size
        snap["modsettings_md5"] = hashlib.md5(open(S.LIVE_MODSETTINGS, "rb").read()).hexdigest()
    if os.path.isdir(S.REAL_BACKUPS):
        snap["backups"] = {os.path.relpath(os.path.join(dp, n), S.REAL_BACKUPS): f(os.path.join(dp, n))
                           for dp, ds, fs in os.walk(S.REAL_BACKUPS) for f, names in ((dir_mtime, ds), (_stat, fs)) for n in names}
    snap["work"] = {f: _stat(f) for f in glob.glob(os.path.join(S.TOOL, "work", "*.json"))}
    snap["lootpatch"] = {f: _stat(f) for f in glob.glob(os.path.join(S.TOOL, "work", "lootpatch", "*"))}
    return snap


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("-k", default=None, help="only run tests whose id contains this text")
    ap.add_argument("-v", action="store_true")
    ap.add_argument("--keep", action="store_true", help="keep earlier sandbox runs (default: only the newest is kept)")
    args = ap.parse_args()

    if not args.keep and os.path.isdir(S.SANDBOX_ROOT):
        assert S._inside(S.SANDBOX_ROOT, os.path.join(S.TOOL, "work"), strict=True)
        shutil.rmtree(S.SANDBOX_ROOT)

    before = snapshot()
    suite = unittest.defaultTestLoader.discover(TESTS, pattern="test_*.py", top_level_dir=TESTS)
    if args.k:
        def flat(s):
            for t in s:
                yield from (flat(t) if isinstance(t, unittest.TestSuite) else [t])
        suite = unittest.TestSuite(t for t in flat(suite) if args.k.lower() in t.id().lower())
    result = unittest.TextTestRunner(verbosity=2 if args.v else 1).run(suite)
    after = snapshot()

    if before["modsettings"] is None:
        print("[WARN] Live modsettings.lsx not found on this machine; the live-unchanged check only covers what exists.")
    changed = [k for k in before if before[k] != after[k]]
    if changed:
        print(f"[FAIL] Live or real files changed during the tests: {', '.join(changed)}")
        for k in changed:
            if isinstance(before[k], dict):
                diff = sorted(set(before[k].items()) ^ set(after[k].items()))
                print(f"       {k}: {diff[:6]}")
            else:
                print(f"       {k}: {before[k]} -> {after[k]}")
        return 2
    print(f"[PASS] Live modsettings.lsx (MD5, mtime, size), Mods folder ({len(before.get('paks', {}))} files), "
          f"Backups/ModCheck ({len(before.get('backups', {}))} entries) and work/*.json unchanged.")
    print(f"[INFO] Sandbox: {S.Sandbox._run_dir or S.SANDBOX_ROOT}")
    return 0 if result.wasSuccessful() else 1


if __name__ == "__main__":
    sys.exit(main())
