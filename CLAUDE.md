# BG3Mods: instructions for Claude Code

Teno's Baldur's Gate 3 workspace. It holds:
- **the mod-check tool** (`Scripts/ModUpdateCheck/`, active): update checks, load order, add-ons, new-mod checks, the loot merge patch and test launches for the installed mod list;
- **the WoW Warrior class mod** (`Data/` and most other folders): paused since Oct 2025.

**Read these first, in order:**
1. [docs/SESSION-ROLES.md](docs/SESSION-ROLES.md): which role you are, what you own, and how to report to Lead. Re-read it on every new task.
2. [docs/PROJECT-LAYOUT.md](docs/PROJECT-LAYOUT.md): where everything lives, the live paths, and who may run each live writer.
3. [docs/HANDOFF.md](docs/HANDOFF.md): the baton, then the latest entry.
4. For tool work: [Scripts/ModUpdateCheck/README.md](Scripts/ModUpdateCheck/README.md).

Rules that are easy to miss:
- **Only the Gatekeeper changes the live game** (the Mods folder, `modsettings.lsx`, the game install, Script Extender settings), and only after Teno approves in Lead. Each change is logged in [docs/LIVE-LOG.md](docs/LIVE-LOG.md).
- **The game must be closed** before anything writes to `modsettings.lsx`.
- **Never launch or close the game** except through `Test-GameLoad.ps1` as part of an approved change.
- **API keys** stay in `%LOCALAPPDATA%\BG3ModHelper\settings.json`. Never print, copy or store them.
- **Downloads** need Teno's OK, naming the file, source and size.
- **Never `git add -A`.** Never commit the Warrior mod's edits, `Reports/` output or `.claude/launch.json`.
- **Commit and push only when Teno asks**, with `git -c user.name="Tenodevilliers" -c user.email="tenodevilliers@gmail.com"`.

The root `.agent.md`, `INDEX.md`, `README.md` and `STARTER_PROMPT_FOR_NEW_SESSION.md` describe only the Warrior mod. Follow them only when working on it (the Forge role). Codex reads [AGENTS.md](AGENTS.md), which points back here.
