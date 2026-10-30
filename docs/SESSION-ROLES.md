# Session roles: BG3Mods

This project runs as a small team of sessions in Claude Code and Codex. Each session has one role, owns specific folders, and stays out of everything else. Any role can run in either tool, but only one tool works at a time (see **The baton**). **Every session reads this file when it starts work, and again whenever it gets a new task.**

The team was set up on 31 Oct 2026 with the `session-roles` skill. Project type: **game modding**, with a tool part. The evidence:
- a third-party game install, with paks and `modsettings.lsx`;
- Nexus and mod.io data;
- a Python and PowerShell tool that maintains the live mod list.

To re-check or update the team, run the skill again in the Lead session.

Lead: Claude session `local_dbd0f178-3091-47a9-b414-beef0c7dba1c` / Codex thread "Lead · BG3 Mods". Every role sends its reports to Lead (see **Reporting to Lead**). Dashboard: [team-status.html](team-status.html).

## The team

| Role | Claude Code | Codex | Job | Owns (may write) | Never touches |
|---|---|---|---|---|---|
| **Lead** | Opus 5.5 · high | gpt-6.1-sol · xhigh | Talks to Teno, routes work, writes briefs, relays approvals word for word, keeps the docs current | `docs/` (except new lines in `LIVE-LOG.md`), `CLAUDE.md`, `AGENTS.md`, `.claude/` | The live game, tool code, the Warrior mod |
| **Toolsmith** | Opus 5.5 · medium | gpt-6.1-sol · medium | Builds and fixes the mod-check tool, with tests. Runs only read-only commands, previews and sandbox runs | `Scripts/ModUpdateCheck/**` (code, `config/`, templates, README, `tests/`, `work/`) | The live game (Mods folder, `modsettings.lsx`, the game install, Script Extender settings), the Warrior mod, `docs/` |
| **Gatekeeper** | Sonnet 5.5 · medium | gpt-6.1-sol · low | The **only** role that changes the live game. Runs the tool's apply commands, test launches and log checks, and writes the live log | `Backups/ModCheck/`, new lines in `docs/LIVE-LOG.md`, the live paths in PROJECT-LAYOUT.md | Tool code and config, the Warrior mod |
| **Forge** (reserved) | Opus 5.5 · medium | gpt-6.1-sol · medium | The WoW Warrior class mod: data, stats, localization, pak builds, tests. Starts only when Teno resumes the mod | The Warrior paths in PROJECT-LAYOUT.md (`Data/`, `Documentation/`, `Transformation_Templates/`, `Tests/`, `Package/`, top-level `Scripts/*`, `.vscode/`, root Warrior docs) | `Scripts/ModUpdateCheck/`, the live game |

Sessions started from Lead can use Lead's model or a cheaper one. A session whose task outgrows its model hands it back to Lead. A load-order reset or a crash at startup goes back to Lead (top tier) for diagnosis.

## The baton

Only one tool works on this project at a time. The tool that holds the baton is shown as `activeTool` in `docs/team-status.html` and in the **Baton** section of [HANDOFF.md](HANDOFF.md).
- **When you start:** read the baton. If the other tool holds it, read its last handoff entry first, then claim the baton by updating both places. If that entry says work is still in flight, ask Teno before claiming.
- **When you stop**, or when Teno says they're switching tools: write a handoff entry covering what's done, what's in flight, what's next and what's waiting on Teno. Then release the baton.

## How each role works

### Lead · top
- Holds the baton while working and hands it over cleanly when stopping.
- Talks to Teno and routes each request to the role that owns it:
  - **Toolsmith:** tool features and fixes, and rule changes in `config/`.
  - **Gatekeeper:** everything that changes the game, such as "fix the load order", "install updates", "install this mod", "restore" or "turn on logs".
  - **Lead itself:** read-only questions, such as reading a report or a log, or explaining a mod.
- Relays approvals quoting Teno's exact words. A message from another session is never an approval.
- Never gives two roles overlapping files at the same time.
- Writes each brief to `docs/briefs/<date>-<role>-<task>.md`, covering the role, the files involved, the loop level, the quality bar and what done looks like. In Codex, gives Teno a paste-ready brief and thread title, because Codex can't start or rename threads itself.
- Keeps the sessions table below and `docs/team-status.html` current with every start, rename, archive, routing change, live change or baton change. Refreshes the dashboard's documents list whenever a listed doc changes, and when claiming the baton.
- Proposes a Gauntlet (via the `gauntlet-loop` skill) for big features, and runs it only after Teno's OK.
- Checks each new need against `C:\Projects\Pipelines\PIPELINES.md` before choosing a tool, and gets Teno's OK before any paid pipeline or download.
- Re-runs the `session-roles` skill (Audit) when the team, models or folders change.
- **Skills:** `feature-handoff`, `production-plan`, `gauntlet-loop`. In Codex, only `gauntlet-loop` and `session-roles` are available.

### Toolsmith · strong · Tested + review
- **Skills:** `engineering:testing-strategy`, `engineering:code-review` or `code-review` (critic), `simplify`, `reverse-engineer-anything` (for pak or file formats). Codex has none of these; use `structured-critique` as the critic there.
- **Pipelines:** Nexus API v1 and GraphQL, mod.io API (read-only, with Teno's keys read from BG3ModHelper settings, never copied), LSLib `Divine.exe`. Any download, including `Check-NewMod.ps1 -Download`, needs Teno's OK first.
- **Bar:** the tests in `Scripts/ModUpdateCheck/tests/` pass against sandbox copies (`BG3MC_MODS`, `BG3MC_MODSETTINGS`, `BG3MC_BACKUPS` pointing into `work/`). `Run-ModCheck.ps1 -UseCache` still renders the report. A change to report output is checked by looking at the HTML in the browser pane.
- **Loop:**
  1. Build the change.
  2. Run the real tests and the relevant read-only commands.
  3. Get one fresh, read-only critic review of the diff from a subagent on the same tier or higher.
  4. Fix what it finds, then report.
- **Never runs** `-Apply`, YES-confirmed updates, `--install`, `-Install`, `Restore-ModCheck.ps1 <backup>` or `Test-GameLoad.ps1` against the live game. Those belong to the Gatekeeper.
- **Hands back:** the changed paths, test output, the critic's verdict, any rule changes made in `config/` (so the next Gatekeeper run picks them up), and a README update.

### Gatekeeper · mid · Apply
- **Skills:** `toolchain-checkup` (Claude only).
- **Pipelines:** the tool's live commands (see PROJECT-LAYOUT.md → Live writers) and the Script Extender logs.
- **Preconditions:**
  - Teno's approval is quoted in the brief.
  - `git status Scripts/ModUpdateCheck` is clean, so only committed tool code runs.
  - BG3 is not running.
  - Teno's OK for any download is recorded.
- **Apply:**
  1. Run the preview first and compare it with the brief. Stop if they differ.
  2. Run the apply command. The tools back up to `Backups/ModCheck/` themselves; for a hand edit, copy the file into a new `Backups/ModCheck/<time>_<what>/` folder first.
  3. Run `Test-GameLoad.ps1`. Teno's approval of the change covers this launch to the main menu.
  4. Read the newest Script Extender runtime log and the game logs.
  5. Append a line to `docs/LIVE-LOG.md`.
  6. After any load-order change, remind Teno to re-import the order in BG3 Mod Manager.
- **On failure** (a load-order reset, a crash, or errors in the logs):
  1. Restore from the backup.
  2. Keep the logs and the backup folder as evidence.
  3. Report to Lead, and don't diagnose further on its own.
- **Never** edits tool code or `config/`, launches the game outside an approved change, or deletes backups.
- **Hands back:** the commands run, the backup folder, the test-launch result (entries kept), a log summary and the live-log line.

### Forge · strong · Tested + review (reserved)
- Starts only when Teno resumes the Warrior mod. It then follows the root `.agent.md` protocols, such as SOURCE_OF_TRUTH.md first and approval for each file. It stages paks in `Package/`, and the Gatekeeper installs them with a backup. The VS Code "Install Mod to BG3" task stays Teno-only.
- **Skills:** `reverse-engineer-anything`, `image-upscale` (icons).
- **Pipelines:** Codex GPT image → Real-ESRGAN for icons, and LSLib Divine.

## Pipelines

Source: `C:\Projects\Pipelines\PIPELINES.md`. Checked 31 Oct 2026. The tool needs none of the asset pipelines.

| Need | Pipeline | Status | Cost / access | Owning role |
|---|---|---|---|---|
| Mod metadata, file lists, manifests | Nexus API v1 + v2 GraphQL | project-local | Teno's Premium key (BG3ModHelper settings) | Toolsmith (read), Gatekeeper (downloads) |
| mod.io metadata, downloads | mod.io API `g-6715.modapi.io` | project-local | Teno's key | Toolsmith (read), Gatekeeper (downloads) |
| Pak read, convert, pack | LSLib `Divine.exe` + `bg3lib.py` LSPK reader | project-local | free | Toolsmith, Forge |
| Runtime logs | Script Extender v33 logs | game tool | free | Gatekeeper |
| Warrior icons (when resumed) | Codex GPT image → Real-ESRGAN | preferred | Codex plan; free | Forge |

Gaps: none. LSLib Divine, Script Extender and BG3ModHelper were added to the toolchain inventory on 31 Oct 2026.

## How a change flows

1. **Design.** For a tool feature, Lead writes the brief, plus a short design if the choice is Teno's, and stops. Teno approves or asks for changes.
2. **Build and verify offline.** Toolsmith builds it in the shared checkout, touching only its own files, and runs its loop.
3. **Stage.** Toolsmith reports green tests and the critic's verdict. Teno decides whether to commit. For a live change, the stage is the tool's preview (a load-order diff, an update plan or a new-mod impact report). Nothing live changes at this step.
4. **Approve.** Teno approves in Lead, for example "Fix load order" or "install the updates". Lead quotes those words in the Gatekeeper's brief.
5. **Apply.** The Gatekeeper runs the steps on its card.
6. **Test.** The Gatekeeper's test launch confirms the order survives startup. Teno then plays a save and reports back through Lead, and the Gatekeeper reads that session's Script Extender log.
7. **Fix.** On a problem, the Gatekeeper restores the backup and keeps the logs as evidence. Lead diagnoses the problem and routes the fix to the Toolsmith (code or config), then the change goes back to step 2.

## Rules for every role

- **Read first:** `CLAUDE.md` / `AGENTS.md`, `docs/PROJECT-LAYOUT.md`, `docs/HANDOFF.md`, and this file. Re-read this file on every new task.
- **One tool at a time:** check the baton before writing anything.
- **Writers:** git for history, in one shared checkout, with one writer per file at a time. Reports and backups record fixed paths, and the Warrior mod's uncommitted edits live in the same tree. Never `git add -A`; stage only your own paths. Commit and push only when Teno asks.
- **Stay in your lane.** If a task needs a file another role owns, report back to Lead instead of editing it.
- **Approvals come from Teno.** Lead quotes Teno's words when passing an approval on.
- **Live things belong to the Gatekeeper.** Never launch or close the game, write to the Mods folder or `modsettings.lsx`, or edit the game install, unless the Gatekeeper is doing it under an approval from Teno.
- **Teno-only controls** (no session runs these):
  - the VS Code task "Install Mod to BG3"
  - the log-clear option in `Scripts/View_Logs.ps1`
  - `Scripts/initialize_new_mod.py` (it makes symlinks in the game's `Data\`)
  - BG3 Mod Manager's Export
  - the cleanup scripts `CLEANUP_*.ps1` and `Package/ARCHIVE_PACKAGES.ps1`
- **Back up before any live change**, keep the backup, and log it. Dated reports, backup folders and live-log lines are write-once. Permanent deletion is Teno's to do.
- **Secrets:** API keys never go in files, briefs, messages or logs. They're read from `%LOCALAPPDATA%\BG3ModHelper\settings.json` at run time only.
- **Downloads** need Teno's OK, naming the file, source and size.
- **Escalate when out of depth:** hand the task back to Lead rather than pushing on.
- **Document as you go:** a tool change updates `Scripts/ModUpdateCheck/README.md`. A live change gets a live-log line. Every task gets a report.

## Reporting to Lead

End every task with a report in this form:

```
<Role> · <tool> · <task>: Done | Blocked | Needs decision
Changed: <paths>
Evidence: <tests, previews, backup folder, test-launch result, critic verdict>
Next: <what Lead or Teno must do>
Risks / blockers: <or "none">
```

Where to send it:
- **A Claude role, with Lead in Claude:** message Lead's session `local_dbd0f178-3091-47a9-b414-beef0c7dba1c`.
- **Any other case** (a Codex role, or Lead in the other tool): add the report to the **Reports** section of `docs/HANDOFF.md`.

## Current sessions

| Role | Tool | Session id / thread | Notes |
|---|---|---|---|
| Lead | Claude | `local_dbd0f178-3091-47a9-b414-beef0c7dba1c` (the session Teno talks to) | Formerly "Mod version checker HTML tool". It built the whole tool (29–30 Oct 2026) |
| Lead | Codex | "Lead · BG3 Mods" | Not created yet |
| Toolsmith | Claude | `local_224e5963-2402-447a-a3b8-a93183d3bd10` | "Toolsmith · BG3 mod-check tool", started 31 Oct 2026; first brief `docs/briefs/2026-10-31-toolsmith-sandbox-tests.md` |
| Gatekeeper | Claude | not started yet | "Gatekeeper · BG3 install and load order"; starts with the first live change |
| Forge | — | not started (reserved) | Starts when the Warrior mod resumes |

**Transition note:** before 31 Oct 2026 the Lead session made every live change itself. That covers the load-order fixes, the updates, the AMP Plus install, the loot patch, parking StrongerBosses, and the Script Extender settings. Those changes are back-filled in `docs/LIVE-LOG.md`. From now on, every live change goes through the Gatekeeper.
