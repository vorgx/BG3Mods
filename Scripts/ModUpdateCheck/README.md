# BG3 Mod Check: updates, load order, add-ons, new mods

Tools for a large Baldur's Gate 3 mod list. They check every installed mod against Nexus Mods and mod.io, fix the load order, install updates, find missing add-ons, and vet a new mod before you install it.

**Safety rules every command follows:**
- Nothing changes unless you ask for it (`-Apply`, or typing YES).
- Before any change, `modsettings.lsx` is copied to `Backups\ModCheck\<time>_<what>\`. Replaced paks are moved there too, never deleted.
- Any change can be undone with `Restore-ModCheck.ps1`.
- Nothing writes while Baldur's Gate 3 is running.
- In `modsettings.lsx` only the mod list is edited. Everything else, including the Windows line endings, stays byte-for-byte the same.

## Commands

Run these from `Scripts\ModUpdateCheck`.

| Command | What it does |
|---------|-------------|
| `.\Run-ModCheck.ps1` | Builds the report `Reports\BG3_Mod_Check_<date>.html` (tabs: Updates, Load order, Add-ons) and `Reports\BG3_Recommended_Load_Order_<date>.json`. Read-only. About 2 minutes; `-UseCache` re-renders in about 10 seconds without Nexus calls. |
| `.\Fix-LoadOrder.ps1` | Previews the recommended load order against your current one. |
| `.\Fix-LoadOrder.ps1 -Apply` | Writes it into `modsettings.lsx`. Add `-Disable X.pak` to take mods out of the order (the pak stays installed), or `-Enable X.pak` to add installed but inactive paks. |
| `.\Update-Mods.ps1` | Shows the download plan for every "Update available" mod, asks you to type YES, then downloads, backs up, installs, re-checks, and re-applies the load order. `-Only Goon,Rebalance` limits it to matching mods. `-RemoveObsolete` also removes paks marked obsolete. |
| `.\Check-NewMod.ps1 <url>` | Due diligence on a Nexus or mod.io mod you're considering. Lists its requirements, which of your mods do the same job, and which of your mods its page names. Writes `Reports\New_Mod_Check_<name>_<date>.html`. |
| `.\Check-NewMod.ps1 <url> -Download` | Also downloads it into `work\newmods\`, for inspection only. Compares its game data with every installed pak: shared stat entries, replaced action lists, shared loot tables, identical files. Says whether it's a newer copy of something you have, and where it should load. Also writes `Reports\Impact_<name>_<date>.html` (via `impact.py`), described below. |
| `python build_lootpatch.py --install` (from `work\venv`) | Rebuilds the local **ModCheck Loot Merge** pak from `config\loot_merge.json` and copies it into Mods (old copy backed up). Run it after updating AMP, AMP Plus, AMPFEDMIX or Witcher Class, then `.\Run-ModCheck.ps1` to re-check. |
| `.\Test-GameLoad.ps1` | Starts Baldur's Gate 3, waits up to 45 seconds to see whether it resets the load order (it does this at startup when a mod fails its checks), then closes the game again. It never gets past the main menu, so saves are untouched, and `modsettings.lsx` is restored afterwards. `-Find` bisects over recently changed mods to name the one the game rejects (one launch per step). **Run it after every update, install or order change.** |
| `.\Restore-ModCheck.ps1` | Lists backups. `latest` or a folder name undoes that change: restores `modsettings.lsx` and moves the replaced paks back. |

Update details:
- **Nexus downloads** use your Nexus Premium API key (direct download links require Premium).
- **mod.io:** mods installed through the in-game mod manager (they have a mod.io publish handle) are updated from mod.io, so the game keeps tracking them.
- **The updater refuses to install:**
  - a download whose version is lower than yours
  - a pak whose mod UUID changed
  - a pak whose new file name is already taken

  Each refusal is reported so you can handle it by hand.
- **Archives:** `.zip` files are extracted with Python. `.7z` and `.rar` use Windows' built-in `tar` (bsdtar), so 7-Zip isn't needed.

If you also use BG3 Mod Manager, import the same order there (File → Import Order from File). Otherwise its next Export overwrites `modsettings.lsx`.

## Requirements

- Python 3.10+ on PATH. The first run creates `work\venv` and installs `lz4`, `zstandard` and `requests`.
- BG3ModHelper (`%LOCALAPPDATA%\BG3ModHelper`):
  - Its `settings.json` holds the Nexus and mod.io API keys. They're read from there and never copied anywhere.
  - Its records link each pak to its Nexus or mod.io page.

## How the update check works

1. **`scan.py`**: opens every `.pak` (LSPK v15, v16 and v18) and reads `meta.lsx`. Links each pak to its Nexus or mod.io page using BG3ModHelper's records and `config\extra_matches.json`.
2. **`fetch.py`**: Nexus API v1 (mod details and file lists) and the mod.io API (`g-<gameid>.modapi.io`; `api.mod.io` now returns 404).
3. **`analyze.py`**: first verdict from version numbers, Nexus "file replaced" chains and upload dates.
   - A Nexus upload within 3 days of your pak counts as the same release.
   - A version number an author stamps on 3+ of their mods (e.g. 1.0.9.88) is ignored.
4. **`verify.py`**: hashes every installed pak (SHA1) and compares it with Nexus download manifests.
   - Newer uploads list the hash of every file inside the archive, which gives a byte-for-byte answer.
   - Older uploads list only rounded sizes, so the comparison is approximate.
   - A pak that differs from Nexus but has a higher version is treated as a newer build you got elsewhere, not an update.
5. **`analyze.py`** again, with the hash results overruling version-number guesses.

## How the load order check works

- **`lo_scan.py`** reads the current order from `modsettings.lsx`. For each pak it also reads dependencies, declared conflicts, files, stat entries, and Script Extender use.
- **`lo_notes.py`** pulls load-order sentences out of Nexus descriptions.
- **`lo_analyze.py`** checks dependencies, patch-after-parent order, author placement rules (Community Library, ImpUI, MCM and Volition Cabinet at the top; Compatibility Framework last) and the hand-checked rules in `config\`.
  - The recommended order keeps your current order and moves only rule-breakers, using a stable topological sort.
  - It also lists the stat entries and files that two mods both define. The later mod wins.
- **`fix_order.py`** applies the recommended order (behind `Fix-LoadOrder.ps1`).

## How the add-on scan works (`addons.py`)

- **Missing requirements:**
  - Nexus requirements, from the GraphQL API, with the author's notes. "Optional" or "recommended" notes become suggestions instead.
  - mod.io dependencies.
  - Tools (Script Extender, mod managers) and requirements another installed pak already provides are skipped.
- **Suggested patches:**
  - Optional files on your mods' Nexus pages whose title names another mod you have, or patch files whose description does.
  - Patch mods linked from your mods' descriptions that name another mod you have.
  - Not suggested: framework mods (they're mentioned everywhere), game-patch wording ("Patch 8 ready"), translations, close variants of files you already have, and add-ons for mods you're about to disable.
- **Other optional files** are listed for browsing.

## How the impact report works (`impact.py`)

For a downloaded new mod, it compares the class, subclass, progression, feat, race, background and spell/passive list definitions (`.lsx`; binary `.lsf` is converted with `LsLib\Tools\Divine.exe`) against every installed pak and the base game (`Shared`, `Gustav` and `GustavX` paks in the game's `Data` folder).
- **Replaced:** the same ID defined by both. Only the later one in the load order survives. Includes spells your mods add to class spell lists that the new mod's lists would drop.
- **Duplicated:** a different ID with the same display name (and the same parent class for subclasses), so it shows twice in character creation.
- **Breaks:**
  - a class whose subclass choice moves to a different level, and installed subclasses that start earlier
  - level 13–20 add-ons on rebuilt classes
  - spells dropped from class lists
  - issues stated on mod pages, recorded in `config\known_issues.json`
- Stat-entry overlaps from the download check are shown per mod, split into full replacements and merges.

## Hand-checked config (`config\`)

| File | Use it for |
|------|-----------|
| `extra_matches.json` | Paks BG3ModHelper couldn't link (`nexus_id` / `modio_id`), and hand verdicts: `"status": "gone"` (no longer hosted, keep your copy), `"obsolete"` (remove), or `"update"`, each with a `"note"` that shows in the report. |
| `incompat_verified.json` | Real incompatibilities between two paks. `"a"` is the one to disable. |
| `manual_rules.json` | Extra "A loads before B" rules. Add `"skip": true` to keep a note without enforcing it, or `"pull": true` to move A up to just above B instead of pushing B down. |
| `loot_merge.json` (note) | The patch pak declares **no dependencies**. On 30 Oct 2026 the game reset the whole load order at startup when it listed its nine source mods as dependencies. Instead, `build_lootpatch.py` writes `work\lootpatch\sources.json`, and `lo_analyze.py` keeps the patch after those mods. |
| `loot_merge.json` | Loot tables the local merge patch rebuilds. `pools`: merge one mod's additions into another's single-list pools (AMPFEDMIX's Fade gear into AMP Plus's 29 pools). `subtables`: rebuild a table from a base plus every later mod's drop groups, treating listed full replacements as additions (Witcher Class on the Dark Shambling Mound). |
| `known_issues.json` | Issues stated on mod pages that data checks can't see, keyed by the new mod (`nexus<id>` / `modio<id>`), shown in its impact report when the named pak is installed. |

## Files

- **Python scripts:** `bg3lib.py` holds the shared pak, `modsettings` and API helpers.
- **`work\`:** caches, the venv, downloads and intermediate JSON. It's git-ignored and safe to delete.
  - Deleting `work\manifests` means about 900 manifests are downloaded again.
  - `work\downloads` keeps each update's original archives until you delete it.
- **Testing overrides:** set `BG3MC_MODS`, `BG3MC_MODSETTINGS` and `BG3MC_BACKUPS` to point the tools at sandbox copies.
