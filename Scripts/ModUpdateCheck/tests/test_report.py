"""Report fixes from the 30 Oct audit: gone mods counted apart from "Need attention", notes in their own row, one page title,
conditional requirements, and patch suggestions only when every mod they name is installed."""
import json, os, re, shutil, subprocess, unittest
import sandbox as S

NODE = shutil.which("node")


def src(nid, name, status="current", note=None):
    return {"source": "nexus", "id": nid, "name": name, "url": f"https://www.nexusmods.com/baldursgate3/mods/{nid}",
            "status": status, "note": note}


def row(pak, name, nid=None, page=None, status="current", manual=None, note=None):
    return {"pak": pak, "name": name, "author": "t", "version": "1.0.0.0", "mtime": 1790000000, "enabled": True, "status": status,
            "manual_note": manual, "sources": [src(nid, page or name, status, note)] if nid else []}


@unittest.skipUnless(NODE, "Node.js is needed to run the report's script")
class ReportPageTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        sb = S.Sandbox("report_page")
        rows = [row("Upd.pak", "Upd", 1, status="update"), row("Cur.pak", "Cur", 2),
                row("Gone1.pak", "Gone One", 3, status="gone", manual="Removed from Nexus by its author in 2025; keep your copy."),
                row("Gone2.pak", "Gone Two", 4, status="gone"),
                row("Chk.pak", "Chk", 5, status="check", note="A long note " + "about load order and versions " * 8)]
        for r in rows:
            sb.add_mod(r["pak"], r["pak"][:-4], r["name"], f"0000{r['sources'][0]['id']:04x}-0000-4000-c000-000000000000")
        sb.write_modsettings()
        sb.analyse(rows)
        rep = sb.work_json("report.json")
        rep["generated"] = "2026-10-31T00:00:00+00:00"
        sb.work_json("report.json", rep)
        cls.html = os.path.join(sb.root, "report.html")
        sb.run("build.py", cls.html)

    def render(self, *filter_):
        r = subprocess.run([NODE, os.path.join(S.TESTS, "render_report.js"), self.html, *filter_], capture_output=True,
                           text=True, encoding="utf-8", timeout=60)
        self.assertEqual(r.returncode, 0, r.stderr)
        return json.loads(r.stdout)

    def card(self, stats, label):
        m = re.search(rf"<b>(\d+)</b><span>{re.escape(label)}</span>", stats)
        return int(m.group(1)) if m else None

    def test_gone_not_in_need_attention(self):
        page = self.render()
        self.assertEqual(self.card(page["stats"], "Need attention"), 2)  # Upd + Chk
        self.assertEqual(self.card(page["stats"], "No longer hosted, keep"), 2)
        self.assertNotIn("Gone One", page["list"])
        self.assertIn("Gone One", self.render("gone")["list"])

    def test_notes_have_their_own_row(self):
        page = self.render("all")
        for cell in re.findall(r'<div class="c-st" role="cell">(.*?)</div>\s*(?=<div class="c-note"|\s*</div>)', page["list"], re.S):
            self.assertNotIn('class="note"', cell)
            self.assertNotIn('class="manual"', cell)
        self.assertRegex(page["list"], r'<div class="c-note" role="cell"[^>]*><div class="note">A long note')
        self.assertRegex(page["list"], r'<div class="c-note" role="cell"[^>]*><div class="manual">Removed from Nexus')

    def test_one_title(self):
        page = self.render()
        self.assertEqual(page["title"], "BG3 Mod Check")
        self.assertIn("<h1>BG3 Mod Check</h1>", open(self.html, encoding="utf-8").read())


class AddonTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        sb = S.Sandbox("addons")
        mods = [row("Undead Race.pak", "Ghastly Ghouls: Playable Undead Race - Trips Shaders", 5895, "Ghastly Ghouls - Playable Undead Race"),
                row("Ghouls_KazstraTav.pak", "Ghouls Kazstra Tav", 7000),
                row("SGT_Darling face 1.1.pak", "SGT_Darling face", 21891, "SweetGenerous' Darling face - New heads"),
                row("JAX_MakeupAndTattoos.pak", "More Makeup and Tattoos", 14424),
                row("Hair Pack.pak", "Hair Pack", 8000),
                row("EotB Main - EyesOfTheBeholder.pak", "EotB Main - EyesOfTheBeholder", 9000, "Eyes of the Beholder"),
                row("CHAR_Barbie.pak", "CHAR_Barbie", 20129, "CHAR's Barbie Head"),
                row("XyzCore.pak", "Xyz Arsenal", 11000),
                row("ModConfigMenu.pak", "Mod Configuration Menu", 12000),
                row("CombatExtender.pak", "Combat Extender", 13000)]
        sb.work_json("report.json", {"mods": mods})
        sb.work_json("lo_report.json", {"current": [{"pak": m["pak"]} for m in mods]})
        cache, fid = {}, 50000
        for m in mods:
            s = m["sources"][0]
            cache[str(s["id"])] = {"mod": {"name": s["name"], "description": ""}, "files": {"files": []}}

        def optional_file(nid, title, desc, pak):
            nonlocal fid
            fid += 1
            cache[str(nid)]["files"]["files"].append({"file_id": fid, "name": title, "file_name": f"{fid}.zip",
                                                      "category_name": "OPTIONAL", "description": desc})
            sb.work_json(os.path.join("manifests", f"{fid}.json"), {"files": [{"file_path": f"x/{pak}"}]})

        optional_file(20129, "CHAR's Barbie Head - CCO Patch", "Patch for Character Creation Overhaul. Can be stacked with the EOTB patch",
                      "barbie_cco.pak")
        optional_file(20129, "CHAR's Barbie Head - UTAV - KAVT Patch", "Patch for UTAV/KAVT. Can be stacked with the EOTB patch",
                      "barbie_kavt.pak")
        optional_file(11000, "Xyz Arsenal - EOTB Patch", "Compatibility with Eyes of the Beholder", "xyz_eotb.pak")
        optional_file(20129, "CHAR's Barbie Head - UTAV - KAVT Patch (Optional)", "Patch for UTAV/KAVT and EOTB", "barbie_kavt2.pak")
        optional_file(11000, "Xyz Arsenal - Combat Extender and EOTB Patches", "Makes Combat Extender and EOTB work together",
                      "xyz_cx.pak")
        cache["11000"]["mod"]["description"] = ("See https://www.nexusmods.com/baldursgate3/mods/30001 and "
                                                "https://www.nexusmods.com/baldursgate3/mods/30002")
        sb.work_json("nexus_cache.json", cache)

        def req(mid, name, notes):
            return {"modId": mid, "modName": name, "url": f"https://www.nexusmods.com/baldursgate3/mods/{mid}", "notes": notes,
                    "externalRequirement": False}

        graphql = [
            {"modId": 5895, "modRequirements": {"nexusRequirements": {"nodes": [
                req(16325, "KAVT - Kazstra's Virtual Tav", "ONLY REQUIRED FOR THE KAZSTRA TAV VERSION")]}}},
            {"modId": 7000, "modRequirements": {"nexusRequirements": {"nodes": [
                req(16325, "KAVT - Kazstra's Virtual Tav", "ONLY REQUIRED FOR THE KAZSTRA TAV VERSION")]}}},
            {"modId": 21891, "modRequirements": {"nexusRequirements": {"nodes": [
                req(20629, "UT - KAVT - Universal Automatic Patcher (UAP)", "For UT/KAVT users")]}}},
            {"modId": 14424, "modRequirements": {"nexusRequirements": {"nodes": [
                req(2754, "Unique Tav Custom Appearance", "Required for the Unique Tav and Unique Tav + EOTB versions")]}}},
            {"modId": 8000, "modRequirements": {"nexusRequirements": {"nodes": [
                req(8100, "Strand Shader Lib", "For Eyes of the Beholder users"), req(8200, "Base Hair Library", ""),
                req(8300, "Strand Physics Core", "Required for all versions"), req(8400, "Fiber Shaders", "For all users"),
                req(8500, "Hair Menu Lib", "Only needed if you use Mod Configuration Menu"),
                req(8600, "Braid Icons", "Required. If you have issues, reinstall it"),
                req(8700, "Mane Complete Collection", "Not required for the Lite version")]}}},
            {"modId": 30001, "name": "Xyz CCO Patch", "summary": "Makes Xyz work with CCO and EOTB", "status": "published"},
            {"modId": 30002, "name": "Xyz EOTB Patch", "summary": "Makes Xyz work with EOTB", "status": "published"},
        ]
        path = os.path.join(sb.root, "graphql.json")
        sb.write_json(path, graphql)
        sb.run("addons.py", env=sb.env(BG3MC_TEST_GRAPHQL=path))
        out = sb.work_json("addons.json")
        cls.kinds = {k: [(r["title"], tuple(r["for"])) for r in out[k]] for k in out}
        cls.titles = {k: [t for t, _ in v] for k, v in cls.kinds.items()}

    def kind_of(self, title, owner=None):
        return [k for k, v in self.kinds.items() for t, f in v if t == title and (owner is None or owner in f)]

    def test_conditional_on_a_version_you_dont_have(self):
        self.assertEqual(self.kind_of("KAVT - Kazstra's Virtual Tav", "Ghastly Ghouls: Playable Undead Race - Trips Shaders"), ["optional"])
        self.assertEqual(self.kind_of("Unique Tav Custom Appearance"), ["optional"])

    def test_conditional_on_the_version_you_have(self):
        self.assertEqual(self.kind_of("KAVT - Kazstra's Virtual Tav", "Ghouls Kazstra Tav"), ["required"])

    def test_conditional_on_a_mod(self):
        self.assertEqual(self.kind_of("UT - KAVT - Universal Automatic Patcher (UAP)"), ["optional"])  # no UT/KAVT installed
        self.assertEqual(self.kind_of("Strand Shader Lib"), ["required"])  # Eyes of the Beholder is installed

    def test_plain_requirement_still_required(self):
        self.assertEqual(self.kind_of("Base Hair Library"), ["required"])

    def test_notes_that_set_no_condition_stay_required(self):
        for t in ("Strand Physics Core", "Fiber Shaders", "Braid Icons"):
            self.assertEqual(self.kind_of(t), ["required"], t)

    def test_negative_note_keeps_old_handling(self):
        self.assertEqual(self.kind_of("Mane Complete Collection"), ["suggested"])  # "not required" was always a suggestion

    def test_condition_on_a_framework(self):
        self.assertEqual(self.kind_of("Hair Menu Lib"), ["required"])  # Mod Configuration Menu is installed

    def test_patch_for_missing_mod_not_suggested(self):
        for t in ("CHAR's Barbie Head: CHAR's Barbie Head - CCO Patch", "CHAR's Barbie Head: CHAR's Barbie Head - UTAV - KAVT Patch",
                  "Xyz CCO Patch", "CHAR's Barbie Head: CHAR's Barbie Head - UTAV - KAVT Patch (Optional)"):
            self.assertNotIn(t, self.titles["suggested"])

    def test_patch_for_installed_mods_suggested(self):
        self.assertIn("Xyz Arsenal: Xyz Arsenal - EOTB Patch", self.titles["suggested"])
        self.assertIn("Xyz EOTB Patch", self.titles["suggested"])
        self.assertIn("Xyz Arsenal: Xyz Arsenal - Combat Extender and EOTB Patches", self.titles["suggested"])


if __name__ == "__main__":
    unittest.main()
