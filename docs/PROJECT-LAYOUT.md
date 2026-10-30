# Project layout: BG3Mods

Where everything lives, who owns it, and what is live. Roles are defined in [SESSION-ROLES.md](SESSION-ROLES.md). Set up 31 Oct 2026.

This folder holds two separate kinds of work:
- **The mod-check tool** (`Scripts/ModUpdateCheck/`) checks and maintains Teno's installed BG3 mod list. It is active.
- **The BG3Wow / WoW Warrior class mod** (`Data/` and most other folders) has been paused since 26 Oct 2025. Its uncommitted edits stay uncommitted.

## Who owns what

| Path | What it is | Owner |
|---|---|---|
| `Scripts/ModUpdateCheck/*.py`, `*.ps1`, `*_template.html`, `README.md`, `.gitignore`, `tests/` | Mod-check tool code, docs and tests | Toolsmith |
| `Scripts/ModUpdateCheck/config/*.json` | Hand-checked rules: manual matches, load-order rules, known issues, loot merge | Toolsmith writes; Lead routes Teno's decisions into them |
| `Scripts/ModUpdateCheck/work/` | Caches, venv, downloads, intermediate JSON, the loot patch build (git-ignored, safe to delete) | Toolsmith; Gatekeeper reads |
| `Reports/BG3_Mod_Check_<date>.html`, `BG3_Recommended_Load_Order_<date>.json`, `New_Mod_Check_*`, `Impact_*` | Dated tool output (not committed) | Whoever runs the tool; write-once |
| `Backups/ModCheck/<time>_<what>/` | Backups taken before every live change (git-ignored) | Gatekeeper |
| `docs/LIVE-LOG.md` | One line per live change | Gatekeeper appends; nobody edits old lines |
| `docs/SESSION-ROLES.md`, `docs/PROJECT-LAYOUT.md`, `docs/HANDOFF.md`, `docs/team-status.html`, `docs/briefs/` | Team docs | Lead (any role adds to the HANDOFF Reports section) |
| `CLAUDE.md`, `AGENTS.md` | Instruction files for Claude Code and Codex | Lead |
| `LsLib/Tools/` | LSLib Divine.exe, shared by the tool and the Warrior mod build | Read-only for everyone; replacing it needs Teno's OK |
| `Data/`, `Transformation_Templates/`, `Tests/`, `Package/`, `Documentation/`, `Archive/`, `Temp/`, top-level `Scripts/*.ps1`, `*.py`, `*.csv`, `*.xml`, `.vscode/`, `.github/`, `Reports/01_*`–`03_*`, `Backups/01_*`–`06_*` | The Warrior mod | Forge (reserved; no session yet) |
| Root Warrior docs: `.agent.md`, `INDEX.md`, `README.md`, `HANDOVER_*.md`, `STARTER_PROMPT_FOR_NEW_SESSION.md`, `TROUBLESHOOTING_LOG.md`, `CLEANUP_*.ps1`, `settings.json` | Warrior mod instructions and utilities. **They describe only the Warrior mod**; their "read SOURCE_OF_TRUTH.md first" rules don't apply to the tool | Forge (reserved) |
| `.claude/` | Local Claude settings (`launch.json` is untracked; never commit it) | Lead |

## Live paths

Only the **Gatekeeper** writes to these, and only after Teno approves in Lead.

| Live path | What |
|---|---|
| `%LOCALAPPDATA%\Larian Studios\Baldur's Gate 3\Mods\` | Installed paks. Files in base-game folders apply from here even when the mod isn't in the load order |
| `%LOCALAPPDATA%\Larian Studios\Baldur's Gate 3\PlayerProfiles\Public\modsettings.lsx` | The load order (CRLF; only the Mods list is edited) |
| `F:\SteamLibrary\steamapps\common\Baldurs Gate 3\bin\` | Game install, incl. `ScriptExtenderSettings.json` and the Script Extender loader |
| `F:\SteamLibrary\steamapps\common\Baldurs Gate 3\Data\` | Game data |
| Save games | No tool touches them; the test launch stops at the main menu |

## Live writers and who may run them

| Writer | Writes | Who |
|---|---|---|
| `Fix-LoadOrder.ps1 -Apply` (incl. `-Disable`, `-Enable`) | modsettings | Gatekeeper |
| `Update-Mods.ps1` (after typing YES) | Mods paks, modsettings | Gatekeeper; downloads need Teno's OK |
| `Restore-ModCheck.ps1 latest` or a folder name | modsettings, moves paks back | Gatekeeper |
| `build_lootpatch.py --install` | the ModCheck Loot Merge pak in Mods | Gatekeeper (building without `--install` is Toolsmith's) |
| `Check-NewMod.ps1 -Install` | Mods paks, modsettings | Gatekeeper |
| `Test-GameLoad.ps1` (and `-Find`) | starts and closes `bg3.exe`, restores modsettings | Gatekeeper, only as part of a change Teno approved (that approval covers the launch) |
| Hand edits of `ScriptExtenderSettings.json` | game bin | Gatekeeper, backup first |
| VS Code task "Install Mod to BG3" | copies `Package\BG3Wow_Latest.pak` into Mods with no backup | **Teno only** |
| `Scripts/View_Logs.ps1` clear option | deletes Script Extender logs | **Teno only** |
| `Scripts/initialize_new_mod.py` | symlinks into the game's `Data\` | **Teno only** |
| BG3 Mod Manager Export | overwrites modsettings | **Teno only**. After each load-order change, the Gatekeeper reminds Teno to re-import the order there |

Anyone may run these read-only commands:
- `Run-ModCheck.ps1` (calls the Nexus and mod.io APIs with Teno's keys)
- `Fix-LoadOrder.ps1` and `Update-Mods.ps1` previews, without `-Apply` or YES
- `Check-NewMod.ps1 <url>` without `-Download` or `-Install` (`-Download` is a download, so it needs Teno's OK)
- `Restore-ModCheck.ps1` with no argument (it only lists backups)
- runs against copies, with `BG3MC_MODS`, `BG3MC_MODSETTINGS` and `BG3MC_BACKUPS` pointing into `work\`

Project-local deleters (not live, Forge-owned, run by Teno): `CLEANUP_ROOT_DIRECTORY.ps1`, `CLEANUP_SOURCE_OF_TRUTH.ps1`, `Package/ARCHIVE_PACKAGES.ps1`.

## Write-once rule

Dated reports, `Backups/ModCheck/*` folders and `docs/LIVE-LOG.md` lines are never edited. A new run makes a new dated report; a correction is a new log line. Deleting backups is Teno's job.

## Rebuilt from source

- **ModCheck Loot Merge pak:** rebuilt from `config/loot_merge.json` with `build_lootpatch.py`.
- **Replaced or parked paks:** kept in `Backups/ModCheck/*/paks/`.
- **The Script Extender settings change:** backed up in `Backups/ModCheck/*_se-settings/`.
- **The Warrior mod:** not installed. Its source has uncommitted edits (a known gap while it's paused).

## Git

There is one shared checkout, with git used for history, and only one role writes to a file at a time. Reports and backups record fixed paths, and the Warrior mod's uncommitted edits sit in the same tree. **Never `git add -A`**: stage only your own paths. Commit and push only when Teno asks. The Gatekeeper runs only tool code that is committed: `git status Scripts/ModUpdateCheck` must be clean.
