"""build_lootpatch.py: the built pak declares no dependencies (30 Oct 2026 load-order reset) and sources.json is written."""
import json, os, re, sys, unittest
import sandbox as S

sys.path.insert(0, S.TOOL)
# this process only reads paks, but give bg3lib sandbox paths so no in-process call can reach the live files
os.environ.update({k: v for k, v in S.Sandbox("inprocess").env().items() if k.startswith("BG3MC_")})
assert not S.guard_problems(os.environ)
import bg3lib as L

U = {k: f"{i:08x}-0000-4000-a000-{i:012x}" for i, k in enumerate(["orig", "base", "add", "repl", "other"], start=1)}
TT = lambda folder: f"Public/{folder}/Stats/Generated/TreasureTable.txt"


def scenario(label):
    """Orig defines the pool T_Pool and the table T_Boss. Base rewrites T_Pool, Add adds its own items to Orig's T_Pool,
    and Repl replaces T_Boss outright (no CanMerge)."""
    sb = S.Sandbox(label)
    sb.add_mod("Orig.pak", "Orig", "Orig", U["orig"], files={TT("Orig"): S.treasure(
        ("T_Pool", [("1,1", ["I_Orig1"])], False), ("T_Boss", [("1,1", ["I_BossOrig"])], False))})
    sb.add_mod("Base.pak", "Base", "Base", U["base"], files={TT("Base"): S.treasure(("T_Pool", [("1,1", ["I_Orig1", "I_Base1"])], False))})
    sb.add_mod("Add.pak", "Add", "Add", U["add"], files={TT("Add"): S.treasure(("T_Pool", [("1,1", ["I_Orig1", "I_Add1"])], False))})
    sb.add_mod("Repl.pak", "Repl", "Repl", U["repl"], files={TT("Repl"): S.treasure(("T_Boss", [("1,1", ["I_Repl1"])], False))})
    sb.add_mod("Other.pak", "Other", "Other", U["other"])
    sb.write_modsettings()
    sb.write_json(os.path.join(sb.conf, "loot_merge.json"), {
        "pools": [{"base": "Base.pak", "add_from": "Add.pak", "minus_base": "Orig.pak", "tables": "shared"}],
        "subtables": [{"table": "T_Boss", "base": "Orig.pak", "treat_as_merge": ["Repl.pak"]}]})
    sb.analyse()
    return sb


def read_pak(path):
    with open(path, "rb") as f:
        return {e[0]: L.pak_read(f, e) for e in L.pak_entries(f)}


class LootPatchTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.sb = scenario("lootpatch")
        cls.out = cls.sb.run("build_lootpatch.py")
        cls.pak = os.path.join(cls.sb.work, "lootpatch", "ModCheck_LootMerge.pak")

    def test_meta_declares_no_dependencies(self):
        info = L.scan_pak(self.pak, want_stats=False)
        self.assertEqual(info["uuid"], "6d0c8f3e-4b1a-4f5e-9c2d-8a7b3e1f0c55")
        self.assertEqual(info["deps"], [])
        meta = read_pak(self.pak)["Mods/ModCheck_LootMerge/meta.lsx"].decode("utf-8")
        deps = re.search(r'<node id="Dependencies">(.*?)</node>', meta, re.S).group(1)
        self.assertNotIn("ModuleShortDesc", deps)

    def test_sources_json_in_load_order(self):
        sources = json.load(open(os.path.join(self.sb.work, "lootpatch", "sources.json"), encoding="utf-8"))
        self.assertEqual(sources, ["Orig.pak", "Base.pak", "Add.pak", "Repl.pak"])

    def test_tables_merged(self):
        text = read_pak(self.pak)[TT("ModCheck_LootMerge")].decode("utf-8")
        pool = re.search(r'new treasuretable "T_Pool"(.*?)(?=new treasuretable|\Z)', text, re.S).group(1)
        self.assertEqual(re.findall(r'"(I_\w+)"', pool), ["I_Orig1", "I_Base1", "I_Add1"])
        boss = re.search(r'new treasuretable "T_Boss"(.*?)(?=new treasuretable|\Z)', text, re.S).group(1)
        self.assertEqual(re.findall(r'"(I_\w+)"', boss), ["I_BossOrig", "I_Repl1"])
        self.assertIn("[PASS] Built", self.out)

    def test_install_into_sandbox_and_restore(self):
        sb = scenario("lootpatch_install")
        sb.run("build_lootpatch.py", "--install")
        dest = os.path.join(sb.mods, "ModCheck_LootMerge.pak")
        self.assertTrue(os.path.exists(dest))
        [bdir] = sb.backup_dirs()
        self.assertEqual(json.load(open(os.path.join(sb.backups, bdir, "backup.json"), encoding="utf-8"))["added_paks"], [dest])
        self.assertIn("Removed newly installed ModCheck_LootMerge.pak", sb.run("restore.py", "latest"))
        self.assertFalse(os.path.exists(dest))


if __name__ == "__main__":
    unittest.main()
