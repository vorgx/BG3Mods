"""restore.py: round trips after a load-order fix and after an update that moved a pak."""
import os, unittest
import sandbox as S
import test_fix_order, test_update


class RestoreTests(unittest.TestCase):
    def test_round_trip_after_fix(self):
        sb, original = test_fix_order.scenario("restore_fix")
        sb.run("fix_order.py", "--apply")
        self.assertNotEqual(sb.read_modsettings(), original)
        listing = sb.run("restore.py")
        self.assertIn("_load-order   (0 paks replaced)", listing)
        self.assertIn("[PASS] Restored modsettings.lsx", sb.run("restore.py", "latest"))
        self.assertEqual(sb.read_modsettings(), original)

    def test_round_trip_after_pak_move(self):
        sb, original = test_update.scenario("restore_update")
        before = test_update.pak_bytes(sb)
        sb.run("update.py", "--apply", "--yes")
        out = sb.run("restore.py", "latest")
        self.assertIn("Moved out Alpha.pak", out)
        self.assertIn("Restored Alpha.pak", out)
        self.assertEqual(sb.read_modsettings(), original)
        self.assertEqual(test_update.pak_bytes(sb), before)
        # the update's pak is kept in the backup, not deleted
        [bdir] = sb.backup_dirs()
        self.assertTrue(os.path.exists(os.path.join(sb.backups, bdir, "_rolled_back", "Alpha.pak")))

    def test_refuses_while_game_runs(self):
        sb, original = test_fix_order.scenario("restore_running")
        sb.run("fix_order.py", "--apply")
        changed = sb.read_modsettings()
        self.assertIn("Baldur's Gate 3 is running", sb.run("restore.py", "latest", bg3_running=True, expect=1))
        self.assertEqual(sb.read_modsettings(), changed)

    def test_rejects_non_backup(self):
        sb, _ = test_fix_order.scenario("restore_bad")
        self.assertIn("Not a ModCheck backup", sb.run("restore.py", "nonexistent", expect=1))


if __name__ == "__main__":
    unittest.main()
