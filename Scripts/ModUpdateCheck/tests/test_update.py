"""update.py: installs a good update, refuses a downgrade, a changed mod UUID and a taken file name, and never deletes a pak."""
import os, re, unittest, zipfile
import sandbox as S

U = {k: f"{i:08x}-0000-4000-9000-{i:012x}" for i, k in enumerate(["alpha", "beta", "gamma", "delta", "eps", "taken", "other"], start=1)}
OLD = S.v64(1, 2)


def scenario(label):
    """Five mods with Nexus updates, each served as a stub download:
    Alpha: a good update (1.2 -> 2.0).  Beta: the download holds an older pak (1.1).  Gamma: same file name, different UUID.
    Delta: the new pak's file name (Taken.pak) belongs to another installed mod.  Eps: Nexus lists an older version (1.1)."""
    sb = S.Sandbox(label)
    report, cache = [], {}
    listed = {"alpha": "2.0", "beta": "1.5", "gamma": "2.0", "delta": "2.0", "eps": "1.1"}
    for i, key in enumerate(["alpha", "beta", "gamma", "delta", "eps"]):
        name = key.capitalize()
        sb.add_mod(f"{name}.pak", name, name, U[key], OLD)
        nid, fid, archive = 101 + i, 1001 + i, f"{name}-{101 + i}-update.zip"
        report.append({"pak": f"{name}.pak", "name": name, "uuid": U[key], "version": "1.2.0.0", "status": "update",
                       "sources": [{"source": "nexus", "id": nid, "status": "update", "latest_file": "Main"}]})
        cache[str(nid)] = {"files": {"files": [{"file_id": fid, "category_name": "MAIN", "name": "Main", "uploaded_timestamp": 1,
                                                "file_name": archive, "version": listed[key], "size_in_bytes": 1}]}}
    sb.add_mod("Taken.pak", "Taken", "Taken", U["taken"])
    original = sb.write_modsettings()
    sb.work_json("nexus_cache.json", cache)
    sb.analyse(report)
    # the stub downloads
    tmp = os.path.join(sb.root, "built")
    downloads = {"Alpha": ("Alpha.pak", U["alpha"], S.v64(2)), "Beta": ("Beta.pak", U["beta"], S.v64(1, 1)),
                 "Gamma": ("Gamma.pak", U["other"], S.v64(2)), "Delta": ("Taken.pak", U["delta"], S.v64(2)),
                 "Eps": ("Eps.pak", U["eps"], S.v64(1, 1))}
    for i, (name, (pak, uuid, ver)) in enumerate(downloads.items()):
        p = S.mod_pak(os.path.join(tmp, name, pak), name, name, uuid, ver,
                      files={f"Public/{name}/Stats/Generated/Data/new.txt": b'new entry "New"\n'})
        with zipfile.ZipFile(os.path.join(sb.downloads, f"{name}-{101 + i}-update.zip"), "w") as z:
            z.write(p, f"{name}/{pak}")
    return sb, original


def pak_bytes(sb):
    return {f: open(os.path.join(sb.mods, f), "rb").read() for f in os.listdir(sb.mods)}


class UpdateTests(unittest.TestCase):
    def test_plan_only_changes_nothing(self):
        sb, original = scenario("upd_plan")
        before = pak_bytes(sb)
        out = sb.run("update.py")
        self.assertIn("4 downloads", out)
        self.assertIn("[WARN] Eps.pak: the download (1.1) is older than yours (1.2.0.0)", out)
        self.assertEqual(sb.read_modsettings(), original)
        self.assertEqual(pak_bytes(sb), before)
        self.assertEqual(sb.backup_dirs(), [])

    def test_apply_installs_good_and_refuses_bad(self):
        sb, original = scenario("upd_apply")
        before = pak_bytes(sb)
        out = sb.run("update.py", "--apply", "--yes")
        self.assertIn("[PASS] Alpha: 1.2.0.0 -> 2.0.0.0", out)
        self.assertRegex(out, r"\[FAIL\] Beta\.pak: downloaded pak is older \(1\.1\.0\.0\)")
        self.assertIn("[FAIL] Gamma.pak: the matching pak has a different mod UUID", out)
        self.assertIn("[FAIL] Delta.pak: new file name Taken.pak is already taken in Mods", out)
        self.assertNotIn("Downloading Eps-105-update.zip", out)  # refused at the plan, never downloaded

        after = pak_bytes(sb)
        for pak in ("Beta.pak", "Gamma.pak", "Delta.pak", "Eps.pak", "Taken.pak"):
            self.assertEqual(after[pak], before[pak], f"{pak} changed although its update was refused")
        self.assertNotEqual(after["Alpha.pak"], before["Alpha.pak"])
        # the old Alpha pak is moved into the backup, not deleted
        [bdir] = sb.backup_dirs()
        old = os.path.join(sb.backups, bdir, "paks", "Alpha.pak")
        self.assertEqual(open(old, "rb").read(), before["Alpha.pak"])
        # modsettings: only Alpha's Version64 and MD5 changed, CRLF kept
        new = sb.read_modsettings()
        self.assertEqual(new.count(b"\n"), new.count(b"\r\n"))
        text = new.decode("utf-8")
        alpha = re.search(rf'<node id="ModuleShortDesc">(?:(?!</node>).)*{U["alpha"]}.*?</node>', text, re.S).group(0)
        self.assertIn(f'value="{S.v64(2)}"', alpha)
        self.assertIn(S.md5(os.path.join(sb.mods, "Alpha.pak")), alpha)
        self.assertEqual(text.replace(alpha, ""), re.sub(rf'<node id="ModuleShortDesc">(?:(?!</node>).)*{U["alpha"]}.*?</node>', "",
                                                         original.decode("utf-8"), flags=re.S))

    def test_refuses_while_game_runs(self):
        sb, original = scenario("upd_running")
        before = pak_bytes(sb)
        self.assertIn("Baldur's Gate 3 is running", sb.run("update.py", "--apply", "--yes", bg3_running=True, expect=1))
        self.assertEqual(pak_bytes(sb), before)
        self.assertEqual(sb.read_modsettings(), original)

    def test_apply_needs_yes(self):
        sb, original = scenario("upd_noyes")
        self.assertIn("--apply needs --yes", sb.run("update.py", "--apply", expect=1))
        self.assertEqual(sb.backup_dirs(), [])


if __name__ == "__main__":
    unittest.main()
