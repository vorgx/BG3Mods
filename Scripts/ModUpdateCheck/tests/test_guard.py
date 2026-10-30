"""The runner refuses to start a tool unless every BG3MC_* path is inside work/test-sandbox."""
import os, unittest
import sandbox as S


class GuardTests(unittest.TestCase):
    def setUp(self):
        self.sb = S.Sandbox("guard")

    def probe(self, **override):
        env = self.sb.env(**override)
        for k, v in override.items():
            if v is None:
                env.pop(k)
        return self.sb.run("--probe", env=env, expect=None)

    def test_sandbox_paths_pass(self):
        self.assertIn("[PROBE] sandbox ok", self.probe())

    def test_live_mods_refused(self):
        out = self.probe(BG3MC_MODS=S.LIVE_MODS)
        self.assertIn("[REFUSED]", out)
        self.assertIn("BG3MC_MODS resolves to a live path", out)

    def test_live_modsettings_refused(self):
        self.assertIn("BG3MC_MODSETTINGS resolves to a live path", self.probe(BG3MC_MODSETTINGS=S.LIVE_MODSETTINGS))

    def test_real_backups_refused(self):
        self.assertIn("BG3MC_BACKUPS resolves to a live path", self.probe(BG3MC_BACKUPS=S.REAL_BACKUPS))

    def test_unset_refused(self):
        # without the override the tools fall back to the live paths, so a missing variable is a refusal too
        self.assertIn("BG3MC_MODSETTINGS is not set", self.probe(BG3MC_MODSETTINGS=None))

    def test_escape_with_dotdot_refused(self):
        sneaky = os.path.join(self.sb.root, "..", "..", "..", "..", "..", "..")
        self.assertIn("[REFUSED]", self.probe(BG3MC_WORK=sneaky))

    def test_sandbox_root_itself_refused(self):
        self.assertIn("[REFUSED]", self.probe(BG3MC_MODS=S.SANDBOX_ROOT))

    def test_script_not_on_allow_list_refused(self):
        out = self.sb.run("test_load.py", expect=None)
        self.assertIn("test_load.py is not on the sandbox allow-list", out)

    def test_real_work_refused(self):
        self.assertIn("BG3MC_WORK is outside", self.probe(BG3MC_WORK=os.path.join(S.TOOL, "work")))


if __name__ == "__main__":
    unittest.main()
