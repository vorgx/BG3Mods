"""lo_analyze.py: sources.json keeps the loot patch after its sources; override, partial-override, inactive and no-meta paks."""
import json, os, unittest
import sandbox as S

U = {k: f"{i:08x}-0000-4000-b000-{i:012x}" for i, k in enumerate(["src1", "src2", "patch", "full", "part", "idle"], start=1)}


def order(rep):
    return [m["pak"] for m in rep["recommended"]]


class LootPatchOrderTests(unittest.TestCase):
    def scenario(self, label, with_sources):
        sb = S.Sandbox(label)
        sb.add_mod("ModCheck_LootMerge.pak", "ModCheck_LootMerge", "ModCheck Loot Merge", U["patch"])
        sb.add_mod("Src1.pak", "Src1", "Src1", U["src1"])
        sb.add_mod("Src2.pak", "Src2", "Src2", U["src2"])
        sb.write_modsettings()
        if with_sources:
            sb.write_json(os.path.join(sb.work, "lootpatch", "sources.json"), ["Src1.pak", "Src2.pak"])
        return sb.analyse()

    def test_patch_moves_after_sources(self):
        rep = self.scenario("lo_sources", True)
        self.assertEqual(order(rep), ["Src1.pak", "Src2.pak", "ModCheck_LootMerge.pak"])
        hard = [i for i in rep["issues"] if i["kind"] == "order" and i["sev"] == "high"]
        self.assertEqual(len(hard), 2)
        self.assertIn("ModCheck Loot Merge patch rebuilds loot tables", hard[0]["text"])

    def test_without_sources_nothing_moves(self):
        rep = self.scenario("lo_nosources", False)
        self.assertEqual(order(rep), ["ModCheck_LootMerge.pak", "Src1.pak", "Src2.pak"])
        self.assertEqual(rep["moved"], 0)


class OverrideTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        sb = S.Sandbox("lo_override")
        sb.add_mod("Src1.pak", "Src1", "Src1", U["src1"])
        sb.add_mod("FullOverride.pak", "FullOverride", "Full Override", U["full"], in_order=False,
                   files={"Public/Shared/Stats/Generated/Data/Armor.txt": b"", "Public/Gustav/Content/x.lsx": b"<x/>",
                          "Localization/English/full.loca": b""})
        sb.add_mod("PartOverride.pak", "PartOverride", "Part Override", U["part"], in_order=False,
                   files={"Public/PartOverride/Stats/Generated/Data/own.txt": b"", "Public/GustavX/Content/y.lsx": b"<y/>"})
        sb.add_mod("Idle.pak", "Idle", "Idle", U["idle"], in_order=False)
        sb.add_mod("Loose.pak", "Loose", "Loose", "", in_order=False, meta=False, files={"Public/Shared/Assets/z.dds": b"z"})
        sb.write_modsettings()
        cls.issues = {i["mods"][0]: i for i in sb.analyse()["issues"] if i["mods"]}

    def test_full_override(self):
        i = self.issues["FullOverride.pak"]
        self.assertEqual((i["kind"], i["sev"]), ("override", "info"))
        self.assertIn("all 2 of its files", i["text"])

    def test_partial_override(self):
        i = self.issues["PartOverride.pak"]
        self.assertEqual((i["kind"], i["sev"]), ("partial-override", "medium"))
        self.assertIn("1 of its files replaces a base-game file", i["text"])

    def test_inactive(self):
        self.assertEqual(self.issues["Idle.pak"]["kind"], "inactive")

    def test_no_meta(self):
        self.assertEqual(self.issues["Loose.pak"]["kind"], "nometa")


if __name__ == "__main__":
    unittest.main()
