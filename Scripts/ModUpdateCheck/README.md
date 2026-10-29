# BG3 Mod Update and Load Order Check

Checks every installed Baldur's Gate 3 mod against Nexus Mods and mod.io, checks the load order, and writes one HTML report with two tabs: **Updates** and **Load order**.

It only reads your game files. It never changes `modsettings.lsx`, the Mods folder, or BG3 Mod Manager.

## Run it

```powershell
.\Scripts\ModUpdateCheck\Run-ModCheck.ps1
```

The first run creates a Python environment in `work\venv`, which takes about a minute. After that a full run takes about 2 minutes, most of it hashing paks.

Output goes to `Reports\`:

| File | What it is |
|------|-----------|
| `BG3_Mod_Check_<date>.html` | The report. Open it in a browser. |
| `BG3_Recommended_Load_Order_<date>.json` | The recommended order. In BG3 Mod Manager: File → Import Order from File, then Save and Export. |

Options:
- `-UseCache` reuses the last run's Nexus data, so no Nexus API calls are made and a run takes about 10 seconds. mod.io is only 2 calls, so it's always refreshed. Use it after editing `config\` to re-render quickly.
- `-OutDir <path>` writes the report somewhere else.

## Requirements

- Python 3.10+ on PATH. The runner installs `lz4`, `zstandard` and `requests` into its own venv.
- BG3ModHelper with a Nexus API key and a mod.io API key in `%LOCALAPPDATA%\BG3ModHelper\settings.json`. The keys are read from there and never copied anywhere. BG3ModHelper's records (`installedmods.json`, `mod_fileids.json`, `nexusid_db.json`, `modiodata.json`, `user_mod_links.json`) are what link each pak to its Nexus or mod.io page.

## How the update check works

1. **`scan.py`**: opens every `.pak` (LSPK v15, v16 and v18), reads `meta.lsx` for the name, author, version and UUID, and links it to a Nexus or mod.io page.
2. **`fetch.py`**: Nexus API v1 (mod details and file lists) and the mod.io API. mod.io now requires the `g-<gameid>.modapi.io` domain; `api.mod.io` returns 404.
3. **`analyze.py`**: first verdict from version numbers, Nexus "file replaced" chains and upload dates. A Nexus upload within 3 days of your pak counts as the same release, because pak dates are build dates and many authors never change the version inside the pak.
4. **`verify.py`**: hashes every installed pak (SHA1) and compares it with Nexus download manifests (`content_preview_link`).
   - Newer manifests list a hash for every file inside the archive, which gives a byte-for-byte answer.
   - Older manifests list only rounded sizes ("21.2 kB"), so the comparison is approximate.
   - Manifests are cached in `work\manifests` because they never change.
5. **`analyze.py`** runs again with the hash results, which overrule version-number guesses.

## How the load order check works

- **`lo_scan.py`** reads the current order from `modsettings.lsx`. For each pak it also reads dependencies, declared conflicts, the file list, stat entries, and whether it uses Script Extender.
- **`lo_notes.py`** pulls load-order sentences ("load after…", "bottom of your load order") out of each mod's Nexus description.
- **`lo_analyze.py`** checks:
  - dependencies are installed, active and loaded above the mods that need them
  - patches and add-ons load below what they patch
  - author placement rules: Community Library, ImpUI, MCM and Volition Cabinet at the top, Compatibility Framework at the bottom
  - duplicates, unreadable paks, and the hand-checked rules in `config\`

  The recommended order is your current order with only the rule-breaking mods moved, using a stable topological sort. It also lists every stat entry and file that two active mods both define; the later mod wins.
- **`lo_incompat.py`** (optional) lists "not compatible with X" sentences from Nexus pages where X is another installed mod. Check each one by hand, then add the real ones to `config\incompat_verified.json`.

## Hand-checked config (`config\`)

| File | Use it for |
|------|-----------|
| `extra_matches.json` | Paks BG3ModHelper couldn't link (`nexus_id` / `modio_id`), and hand verdicts: `"status": "gone"` (no longer hosted, keep your copy), `"obsolete"` (remove), or `"update"`, each with a `"note"` that shows in the report. |
| `incompat_verified.json` | Real incompatibilities between two paks, shown as serious problems. |
| `manual_rules.json` | Extra "A must load before B" rules, for example Enhanced AI above Necromancy Reanimated because both replace the `AnimateDeadZombie` action list. Add `"skip": true` to keep a note without enforcing the rule. |

The current entries record the 2026-10-29 findings: the JG33 classes, Leila Preset and Enhanced AI are no longer hosted, FeatsOverhaul_SpellsPatch is obsolete, and Astralities' Glow Eyes is incompatible with Eyes of the Beholder.

## Files

`work\` holds caches, the venv and intermediate JSON. It is git-ignored and safe to delete. The next run rebuilds it, but deleting `work\manifests` means about 900 manifests are downloaded again.
