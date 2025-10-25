# Data Folder Backup Archive - October 26, 2025

**Created**: October 26, 2025  
**Purpose**: Archive backup files removed from `Data/` folder to prevent mod size bloat

## Why This Archive Exists

The `Data/` folder is packaged into the mod's `.pak` file. Any backup files in `Data/` would inflate the mod size unnecessarily. This archive stores those backups outside the packaging directory for historical reference.

## Archive Contents

### Localization Backups (11 files)
**Original Location**: `Data/Mods/Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7/Localization/English/`

**Files Archived**:
- `english_BACKUP_20251025_172934.xml`
- `english_BACKUP_20251025_174708.xml`
- `english_BACKUP_20251025_181440.xml`
- `english_BACKUP_20251025_181632.xml`
- `english_BACKUP_20251025_182348.xml`
- `english_BACKUP_20251025_183829.xml`
- `english_BACKUP_20251025_183927.xml`
- `english_BACKUP_20251025_184105.xml`
- `english_BACKUP_20251025_184200.xml`
- `english_BACKUP_20251025_184244.xml`
- `english_BACKUP_20251025_185050.xml` (final backup before Wowhead link removal)

**Context**: Created during Oct 25, 2025 session when regenerating localization to sync with ability database descriptions and remove Wowhead URLs.

---

### Stat File Backups (7 files)
**Original Location**: `Data/Public/Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7/Stats/Generated/Data/`

**Files Archived**:
- `Passive_BACKUP_20251025_181642.txt`
- `Spell_Jump_BACKUP_20251025_181642.txt`
- `Spell_Projectile_BACKUP_20251025_181642.txt`
- `Spell_Shout_BACKUP_20251025_181642.txt`
- `Spell_Target_BACKUP_20251025_181642.txt`
- `Spell_Zone_BACKUP_20251025_181642.txt`
- `Status_BOOST_BACKUP_20251025_181642.txt`

**Context**: Created during Oct 25, 2025 session when implementing charge resource system (updated spell entries to spend MobilityCharge, DefensiveCharge, TankCooldown, OverpowerCharge). All 7 backups share same timestamp (single batch operation).

---

## Production Files Remaining in Data/

**Localization** (`Data/Mods/.../Localization/English/`):
- ✅ `english.xml` (production localization, 1883 lines, 494 handles)
- ✅ `English.loca` (binary localization)

**Stat Files** (`Data/Public/.../Stats/Generated/Data/`):
- ✅ `Passive.txt` (161 passive abilities)
- ✅ `Spell_Jump.txt` (gap closers: Charge, Heroic Leap, Intervene)
- ✅ `Spell_Projectile.txt` (ranged attacks: Heroic Throw, Storm Bolt)
- ✅ `Spell_Shout.txt` (AoE buffs: Battle Shout, Rallying Cry, etc.)
- ✅ `Spell_Target.txt` (single-target abilities: Execute, Mortal Strike, etc.)
- ✅ `Spell_Zone.txt` (AoE attacks: Whirlwind, Bladestorm, Thunder Clap, etc.)
- ✅ `Status_BOOST.txt` (25 status effects: buffs, debuffs, stances, hero procs)

---

## Restoration Instructions

If you need to restore a backup file:

1. **Identify the version you need** from this archive
2. **Copy the backup file** to the appropriate `Data/` subfolder
3. **Rename to remove `_BACKUP_*` suffix** (e.g., `english_BACKUP_20251025_185050.xml` → `english.xml`)
4. **Validate with test scripts** (if available)
5. **Repackage mod** and test in-game

**⚠️ Warning**: Restoring old backups may undo recent changes. Check SOURCE_OF_TRUTH.md change log to see what was modified after the backup timestamp.

---

## Related Documentation

- **SOURCE_OF_TRUTH.md**: See Section [12] Folder Structure Inventory for full context
- **Change Log Entry**: October 26, 2025 - "DATA FOLDER BACKUP CLEANUP"
- **Troubleshooting Log**: `TROUBLESHOOTING_LOG.md` (root) for any backup-related issues

---

**Archive Integrity**: All 18 files confirmed present in subdirectories (11 localization + 7 stat files)
