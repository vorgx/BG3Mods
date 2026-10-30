# Live log: BG3Mods

One line per change to the live game: the Mods folder, `modsettings.lsx`, the game install or its Script Extender settings. The Gatekeeper appends a line after each change and never edits old lines; corrections are new lines. Backups are in `Backups/ModCheck/<folder>/`. Paths and rules: [PROJECT-LAYOUT.md](PROJECT-LAYOUT.md).

| When | What | Command | Backup folder | Result | Approved by Teno |
|---|---|---|---|---|---|
| 2026-10-30 00:53 | Load order fix | `Fix-LoadOrder.ps1 -Apply` | `20261030_005307_load-order` | applied | "Fix load order" |
| 2026-10-30 01:39 | AMP Plus installed, conflicting mods disabled | `Check-NewMod.ps1 -Install` / `Fix-LoadOrder.ps1 -Apply -Disable` | `20261030_013914_install`, `20261030_014007_load-order` | applied | "ok lets add … and disable the mods that conflicts with it." |
| 2026-10-30 01:55 | Script Extender logging on (`EnableLogging`) | hand edit | `20261030_015538_se-settings` | applied | 30 Oct fix round (exact words not recorded) |
| 2026-10-30 01:55–01:59 | Updates installed, load order re-applied, loot merge patch installed | `Update-Mods.ps1`, `Fix-LoadOrder.ps1 -Apply`, `build_lootpatch.py --install` | `20261030_015550_update` … `20261030_015928_load-order` | applied; the game later reset the load order at startup (the patch's dependency list) | "1-10" |
| 2026-10-30 02:18 | Loot patch rebuilt without dependencies, order restored, verified with a test launch | `build_lootpatch.py --install`, `Test-GameLoad.ps1` | `20261030_021855_lootpatch` | game kept all entries | "i still want 1-10 and the patch fixed. and the load order" |
| 2026-10-30 09:39 | StrongerBosses pak moved out of Mods | hand move | `20261030_093911_parked` | applied | "Yes, move it out" |
| 2026-10-30 09:52 | Script Extender `LogRuntime` and `LogFailedCompile` on; test launch | hand edit, `Test-GameLoad.ps1` | `20261030_095232_se-settings` | game kept 404 entries; clean runtime log | "also can you see the logs now from the last run?" |
| 2026-10-31 01:35 | 3 mod updates (AMSE 1.1.5, B52's Finesse Weaponry 3.1.1.3, Skynet 7.5) | `Update-Mods.ps1 -Only AutomaticMagicalSecretsExtender,"B52's Finesse Weaponry",Skynet -Yes -SkipLoadOrderFix`; `Test-GameLoad.ps1` | `20261031_013530_update` | applied; Fix-LoadOrder preview: nothing to change; test launch kept 404 entries; runtime log clean (no errors/warnings; Skynet and AMSE load as SE mods) | "Install the updates" |

The 29–30 Oct lines were made by the Lead session before the team was set up (transition). From 31 Oct 2026 every live change goes through the Gatekeeper.
