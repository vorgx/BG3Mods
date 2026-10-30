# Brief: Gatekeeper · install 3 mod updates (31 Oct 2026)

**Role:** Gatekeeper ([SESSION-ROLES.md](../SESSION-ROLES.md)). **Lead:** `local_dbd0f178-3091-47a9-b414-beef0c7dba1c`. **Loop:** Apply.

**Teno's approvals, word for word:**
- "Install the updates" (31 Oct 2026).
- Downloads: "Yes, download all 3 (Recommended)", answered to Lead's question that listed the files below.

Teno's game works well right now and they are wary of load-order changes. Change only what's listed here.

Read first: `CLAUDE.md`, `docs/SESSION-ROLES.md` (your card), `docs/PROJECT-LAYOUT.md`, `Scripts/ModUpdateCheck/README.md`. Run commands from `Scripts/ModUpdateCheck`.

## Approved plan (from the read-only `update.py` preview Lead ran at about 01:50)

| Mod | Installed → new | Source | File | Size |
|---|---|---|---|---|
| AutomaticMagicalSecretsExtender | 1.1.4.0 → 1.1.5 | Nexus | `AutomaticMagicalSecretsExtender 20247 1.1.5 2026-10-29T22-16Z bWpj0fQ8Y.zip` | < 0.1 MB |
| B52's Finesse Weaponry | 3.1.1.2 → 3.1.1.3 | mod.io | `finesseblugeonweapons_75888327-bt1g.zip` | 97.8 MB |
| Skynet | 7.0.0.0 → 7.5 | Nexus | `Skynet 19315 7.5 2026-10-30T13-06Z IiWVDb7Jp.7z` | 0.2 MB |

## Steps

1. **Preconditions:**
   - BG3 is not running.
   - `git -C C:\Projects\BG3Mods status --short Scripts/ModUpdateCheck` is empty.
   - Re-run the plan: `. .\_env.ps1; Invoke-Py 'update.py' @()`. It must list exactly these 3 mods, versions and files. **If anything differs, stop and report to Lead.**
2. **Install:** run `.\Update-Mods.ps1 -Only AutomaticMagicalSecretsExtender,"B52's Finesse Weaponry",Skynet -Yes -SkipLoadOrderFix`. If `-Only` doesn't match all three names, use `.\Update-Mods.ps1 -Yes -SkipLoadOrderFix` instead, because the plan holds only these three. It:
   - downloads each file;
   - moves each old pak to `Backups\ModCheck\<time>_update\paks`;
   - installs the new pak and updates its version in `modsettings.lsx`;
   - re-runs the check, which makes read-only network calls.
   Note the backup folder name. Any refusal (downgrade, changed UUID, name clash): stop and report.
3. **Load order:** run `.\Fix-LoadOrder.ps1`, the preview only.
   - If it says nothing to change, or only version updates: move on.
   - If it would **move, add or remove any mod**: don't apply. Report the list to Lead, because Teno decides that separately.
4. **Test launch:** run `.\Test-GameLoad.ps1`. Teno's approval covers this launch to the main menu. It must report that the game kept every entry. If the game resets the order, restore with `.\Restore-ModCheck.ps1 <the update backup folder>`, keep the logs, and report. Don't diagnose any further yourself.
5. **Logs:** read the newest Script Extender runtime log written by that launch ("Extender Runtime <date>.log"; its file name uses UTC) and the game's own log. Note any errors or warnings, especially for the three updated mods.
6. **Live log:** append one line to `docs/LIVE-LOG.md` with:
   - the time;
   - "3 mod updates (AMSE 1.1.5, B52's Finesse Weaponry 3.1.1.3, Skynet 7.5)";
   - the command;
   - the backup folder;
   - the result, including the test-launch entry count;
   - the approval quoted as "Install the updates".
   Don't commit.
7. **Report to Lead** in the SESSION-ROLES format. Include a reminder for Teno: if they use BG3 Mod Manager, they should re-import the order (File → Import Order from File) before its next Export.

## Never

- Touch tool code or `config/`.
- Apply a load order change that moves mods.
- Delete anything.
- Launch the game other than via `Test-GameLoad.ps1`.
- Download anything not in the table.
- Commit or push.
