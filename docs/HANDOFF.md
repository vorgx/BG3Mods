# Handoff: BG3Mods

Session-to-session and Claude ↔ Codex continuity for the mod-check tool and the team. Roles: [SESSION-ROLES.md](SESSION-ROLES.md) · Layout: [PROJECT-LAYOUT.md](PROJECT-LAYOUT.md) · Dashboard: [team-status.html](team-status.html) · Live changes: [LIVE-LOG.md](LIVE-LOG.md).

The Warrior mod's older handover docs (`../HANDOVER_SOURCE_OF_TRUTH_REVIEW_OCT26.md`, `../STARTER_PROMPT_FOR_NEW_SESSION.md`) cover that mod only. Read them only when the Warrior mod resumes.

## Baton

| Holder | Since | Notes |
|---|---|---|
| **Claude** (Lead `local_dbd0f178-3091-47a9-b414-beef0c7dba1c`) | 2026-10-31 | Team set up. Nothing in flight on the live game. |

Claim the baton by updating this table and `activeTool` in `team-status.html`. Release it by writing an entry below and setting the holder to "nobody".

## Entries (newest first)

### 2026-10-31 · Claude · Lead (Toolsmith brief done)
- **Done:** Toolsmith finished `docs/briefs/2026-10-31-toolsmith-sandbox-tests.md`. That covers:
  - `Test-ModCheck.ps1` and `tests/`: 44 sandbox tests. Lead re-ran them: all OK, and live files unchanged.
  - Five report fixes in `build.py` and `addons.py`.
  - The README now has a Tests section, and its `-UseCache` line is corrected.
- **Not committed:** `Scripts/ModUpdateCheck/`, plus all of `docs/`, `CLAUDE.md` and `AGENTS.md`.
- **Waiting on Teno:**
  - whether to commit;
  - one read-only networked `Run-ModCheck.ps1`, to see fixes 4 and 5 against live data;
  - whether to add the Toolsmith's preview server to `.claude/launch.json`.
- **Toolsmith backlog (not briefed):**
  - make `-UseCache` fully offline;
  - in PowerShell 5.1, the tests' "[INFO] Path overrides" stderr line shows as a red NativeCommandError, though the run passes.

### 2026-10-31 · Claude · Lead
- **Done:**
  - Team set up with the `session-roles` skill: Lead, Toolsmith, Gatekeeper, and Forge (reserved).
  - Docs written: `docs/SESSION-ROLES.md`, `PROJECT-LAYOUT.md`, `LIVE-LOG.md` (with the 29–30 Oct live changes back-filled), this handoff doc and `team-status.html`.
  - Root `CLAUDE.md` and `AGENTS.md` added.
  - LSLib Divine, Script Extender and BG3ModHelper added to the toolchain inventory.
- **State of the live game:**
  - All mods are current, except the 4 that are no longer hosted.
  - The load order (404 entries) is verified in-game, and the Script Extender runtime log is clean up to the main menu.
- **In flight:** the Toolsmith's first brief (`docs/briefs/2026-10-31-toolsmith-sandbox-tests.md`).
- **Next (Toolsmith backlog):** the audit fixes listed in that brief.
- **Waiting on Teno:**
  - Commit the new docs when wanted (nothing is committed yet).
  - Check the next gameplay session's Script Extender log.

## Reports

Role reports land here when Lead is in the other tool or a role runs in Codex. Format: see SESSION-ROLES.md → Reporting to Lead.

_(none yet)_
