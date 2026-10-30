"""fix_order.py: preview, --apply, --enable/--disable placement, byte-for-byte modsettings edits, backups, bg3.exe check."""
import json, os, re, unittest
import sandbox as S

U = {k: f"{i:08x}-0000-4000-8000-{i:012x}" for i, k in enumerate(["lib", "a", "b", "cf", "new"], start=1)}


def scenario(label):
    """Current order: CommunityLibrary, ModB, ModA, CompatibilityFramework. ModB depends on ModA, so ModA must move up.
    NewMod.pak is installed but not in the order."""
    sb = S.Sandbox(label)
    sb.add_mod("CommunityLibrary.pak", "CommunityLibrary", "CommunityLibrary", U["lib"])
    a = {"folder": "ModA", "name": "Mod A", "uuid": U["a"]}
    sb.add_mod("ModB.pak", "ModB", "Mod B", U["b"], deps=[a],
               files={"Public/ModB/Stats/Generated/Data/B.txt": b"", "Public/Gustav/Content/override.lsx": b"<x/>"})
    sb.add_mod("ModA.pak", "ModA", "Mod A", U["a"])
    sb.add_mod("CompatibilityFramework.pak", "CompatibilityFramework", "Compatibility Framework", U["cf"])
    sb.add_mod("NewMod.pak", "NewMod", "New Mod", U["new"], in_order=False)
    original = sb.write_modsettings()
    sb.analyse()
    return sb, original


def split(raw):
    """(text before the Mods entries, the entries, text after) of a modsettings file."""
    t = raw.decode("utf-8")
    m = re.search(r'(<node id="Mods">\s*<children>)(.*?)(\s*</children>\s*</node>)', t, re.S)
    return t[:m.end(1)], m.group(2), t[m.start(3):]


def uuids(raw):
    return re.findall(r'id="UUID" type="guid" value="([^"]+)"', raw.decode("utf-8"))


class FixOrderTests(unittest.TestCase):
    def assert_crlf(self, raw):
        self.assertEqual(raw.count(b"\n"), raw.count(b"\r\n"), "a line ending lost its CR")

    def test_preview_changes_nothing(self):
        sb, original = scenario("fix_preview")
        out = sb.run("fix_order.py")
        self.assertIn("Move  Mod A", out)
        self.assertIn("Dry run", out)
        self.assertEqual(sb.read_modsettings(), original)
        self.assertEqual(sb.backup_dirs(), [])

    def test_apply_writes_order_and_keeps_bytes(self):
        sb, original = scenario("fix_apply")
        out = sb.run("fix_order.py", "--apply")
        self.assertIn("[PASS] modsettings.lsx updated", out)
        new = sb.read_modsettings()
        self.assertEqual(uuids(new), [S.GUSTAVX["uuid"], U["lib"], U["a"], U["b"], U["cf"]])
        # only the Mods entries changed; everything around them is byte-identical and still CRLF
        pre0, body0, post0 = split(original)
        pre1, body1, post1 = split(new)
        self.assertEqual((pre1, post1), (pre0, post0))
        self.assert_crlf(new)
        entries = lambda b: sorted(re.findall(r'[ \t]*<node id="ModuleShortDesc">.*?</node>', b, re.S))
        self.assertEqual(entries(body1), entries(body0), "entries were rewritten instead of reordered")
        # backup of the original, recording sandbox paths
        [bdir] = sb.backup_dirs()
        self.assertTrue(bdir.endswith("_load-order"))
        self.assertEqual(open(os.path.join(sb.backups, bdir, "modsettings.lsx"), "rb").read(), original)
        meta = json.load(open(os.path.join(sb.backups, bdir, "backup.json"), encoding="utf-8"))
        self.assertEqual(meta["modsettings"], sb.modsettings)
        # a second run has nothing to do and makes no new backup
        self.assertIn("Nothing to change", sb.run("fix_order.py", "--apply"))
        self.assertEqual(len(sb.backup_dirs()), 1)

    def test_enable_goes_above_compatibility_framework(self):
        sb, original = scenario("fix_enable")
        out = sb.run("fix_order.py", "--apply", "--enable", "NewMod.pak")
        self.assertIn("Enable New Mod (placed above Compatibility Framework)", out)
        new = sb.read_modsettings()
        self.assertEqual(uuids(new), [S.GUSTAVX["uuid"], U["lib"], U["a"], U["b"], U["new"], U["cf"]])
        self.assertIn(S.md5(os.path.join(sb.mods, "NewMod.pak")), new.decode("utf-8"))
        self.assert_crlf(new)
        self.assertEqual((split(new)[0], split(new)[2]), (split(original)[0], split(original)[2]))

    def test_disable_removes_entry_keeps_pak(self):
        sb, _ = scenario("fix_disable")
        out = sb.run("fix_order.py", "--apply", "--disable", "ModB.pak")
        self.assertIn("Disable Mod B", out)
        self.assertIn("[WARN] ModB.pak has 1 file(s) that replace base-game files", out)
        self.assertEqual(uuids(sb.read_modsettings()), [S.GUSTAVX["uuid"], U["lib"], U["a"], U["cf"]])
        self.assertTrue(os.path.exists(os.path.join(sb.mods, "ModB.pak")))
        self.assert_crlf(sb.read_modsettings())

    def test_refuses_while_game_runs(self):
        sb, original = scenario("fix_running")
        out = sb.run("fix_order.py", "--apply", bg3_running=True, expect=1)
        self.assertIn("Baldur's Gate 3 is running", out)
        self.assertEqual(sb.read_modsettings(), original)
        self.assertEqual(sb.backup_dirs(), [])


if __name__ == "__main__":
    unittest.main()
