# Brief: Toolsmith · sandbox tests, then report fixes (31 Oct 2026)

**Role:** Toolsmith ([SESSION-ROLES.md](../SESSION-ROLES.md)). **Lead:** `local_dbd0f178-3091-47a9-b414-beef0c7dba1c`. **Loop:** Tested + review. **Approved by Teno:** "Apply all" (31 Oct 2026). That covers item 16 of the team proposal: start the Toolsmith with a test suite first, then the audit fixes.

Read first: `CLAUDE.md`, `docs/SESSION-ROLES.md`, `docs/PROJECT-LAYOUT.md`, `Scripts/ModUpdateCheck/README.md`, then the code you touch (`bg3lib.py` holds the shared helpers).

## Files

All your work is inside `Scripts/ModUpdateCheck/` (code, `tests/`, `work/`, README). Don't touch:
- the live game: the Mods folder, `modsettings.lsx`, the game install, Script Extender settings;
- `docs/`;
- anything outside `Scripts/ModUpdateCheck/`.

Never `git add -A`, and don't commit. Teno decides commits.

## Part A: sandbox test suite (do this first, then report)

The tool has no automated tests. Every change so far was checked by hand runs against the live game. Build a suite that exercises the commands that write, against copies only.

- **Where and how:** put it in `Scripts/ModUpdateCheck/tests/`, run by one command (e.g. `.\Test-ModCheck.ps1`, or pytest in `work\venv`), and add `pytest` to the venv setup if you use it.
- **Copies only:** the suite must set `BG3MC_MODS`, `BG3MC_MODSETTINGS` and `BG3MC_BACKUPS` to a temp folder under `work\` and **refuse to run if any path resolves to the live game**. Prove that by checking that the live `modsettings.lsx` and the Mods folder's modification times are unchanged after a run.
- **No network:** stub the API calls.
- **Fixtures:**
  - Small synthetic paks, built at test time (LSLib `Divine.exe create-package`, or a minimal LSPK writer), with their `meta.lsx`.
  - A small `modsettings.lsx` with CRLF line endings.
  - Don't copy real mods into the repo.
- **Cover at least:**
  - `fix_order.py`:
    - preview vs `--apply`
    - `--disable` / `--enable` placement (above Compatibility Framework)
    - only the Mods block changes, byte for byte (CRLF kept)
    - a backup is made
    - refuses while `bg3.exe` runs (mock `bg3_running`)
  - `restore.py`: round trip after a fix and after a pak move.
  - `update.py`: refuses a downgrade, a changed mod UUID, or a taken file name; moves the old pak to the backup and never deletes it.
  - `build_lootpatch.py`: the built meta has **no dependencies** (the 30 Oct load-order reset), and `sources.json` is written.
  - `lo_analyze.py`: the `sources.json` edges keep the patch after its sources; override and partial-override classification.
- **README:** add a "Tests" section to `Scripts/ModUpdateCheck/README.md`.

**Done when:** the suite passes, a fresh read-only critic subagent (same tier or higher) has reviewed the diff and its findings are fixed, and you've reported to Lead in the SESSION-ROLES format.

## Part B: report fixes from the 30 Oct audit (after Part A is reported)

Fix each one with a test where it's logic. Check the HTML in the browser pane with `Run-ModCheck.ps1 -UseCache`. That run is read-only, but **it calls Nexus without `-UseCache`, so stay on the cache**.

1. "Need attention" counts mods that are gone (no longer hosted, status `gone` in `config/extra_matches.json`). Count them separately.
2. Long notes are squeezed into the narrow status column. Give notes their own row or column.
3. The page title doesn't match ("BG3 Mod Updates" vs "BG3 Mod Check"). Use one name.
4. Conditional requirements, such as notes like "ONLY REQUIRED FOR …", are flagged as missing. Treat them as conditional, only missing when the named mod is installed.
5. Patches are suggested for mods Teno doesn't have (UTAV/KAVT, CCO). Only suggest a patch when every mod it names is installed.

Out of scope until Teno picks them (listed for Lead): a save-game mod check, a Script Extender log reader, an interactive order editor, profiles, scheduled checks, a hash cache, and loot-table analysis on the new-mod page.

**Done when:** each fix has its test passing and has been reviewed and checked in the browser, the README is updated where behaviour changed, and you've reported to Lead.
