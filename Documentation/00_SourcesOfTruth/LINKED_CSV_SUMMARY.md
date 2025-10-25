# LINKED CSV System - Quick Reference

**⚠️ OUTDATED - See HERO_TALENTS_COMPLETE_SUMMARY.md for current information**

**Version**: 1.0  
**Date**: October 23, 2025 (OUTDATED - references old "LINKED.csv" file)  
**Replacement**: `HERO_TALENTS_COMPLETE_SUMMARY.md` (current file: "LINKED - Main.csv")  
**Status**: ⚠️ **OUTDATED** (references 26 hero talents, actual count is 33)

**⚠️ NOTE**: This document references the wrong file ("Warrior Progression LINKED.csv") and outdated hero talent counts. The current source of truth is **"Warrior Progression LINKED - Main.csv"** with all 33 hero talents (11 per tree). See `HERO_TALENTS_COMPLETE_SUMMARY.md` for up-to-date information.

---

## 🎯 Quick Facts

- **File**: `Warrior Progression LINKED.csv` ← **OUTDATED, use "LINKED - Main.csv"**
- **Structure**: 68 columns × 25 rows (3 header + 20 levels + 2 blank)
- **Format**: `"Ability Name - ability_id"` per cell
- **Total Abilities**: 213 unique ability_id references
- **Coverage**: 100% (all abilities exist in database)
- **Hero Talents**: 26 (out of 33 in database)

---

## 📋 Header System (3 Rows)

### Row 1: Category Grouping
Defines which **progression track** (e.g., `Baseline_Arms`, `Warrior_Class`, `Arms_Subclass`)

### Row 2: Grant Method
Defines **how** abilities are obtained:
- `Auto Grant` / `Auto Granted` → Automatically added at level
- `Choose one for this per level` → Player picks 1 from options
- `Pick one for this level` → Player picks 1 from options

### Row 3: Ability Type
Defines **what kind** of ability (e.g., `Offensive Abilities`, `Passive`, `Keystone`)

---

## 🗂️ Column Groups (68 Total)

| Columns | Track | Abilities | Grant Method |
|---------|-------|-----------|--------------|
| 1-2 | Metadata | - | - |
| 3-4 | BG3 Baseline | 0 | Placeholder |
| 5-6 | Baseline_Arms | 12 | Auto Grant |
| 7-9 | Baseline_Protection | 12 | Auto Grant |
| 10-11 | Baseline_Fury | 6 | Auto Grant |
| 12-21 | Warrior_Class | 10 | Auto Grant (stances) + Choice |
| 22-34 | Arms_Subclass | 3 | Auto Grant + Pick one |
| 35-45 | Fury_Subclass | 1 | Auto Grant + Pick one |
| 46-53 | Protection_Subclass | 1 | Auto Grant + Pick one |
| 54-58 | Mountain Thane | 9 | Auto Granted |
| 59-63 | Colossus | 9 | Auto Granted |
| 64-68 | Slayer | 3 | Auto Granted |

---

## 🏆 Hero Talents Breakdown

| Tree | Database | LINKED.csv | Missing |
|------|----------|------------|---------|
| Mountain Thane | 15 | 9 | 6 |
| Colossus | 5 | 9 | -4 (overlap?) |
| Slayer | 13 | 3 | 10 |
| **TOTAL** | **33** | **26** | **7** |

**Key Insight**: Slayer tree is most underpopulated (only 3 abilities vs 13 in database)

---

## 🔗 Usage Pattern (FILE 12)

### Step 1: Extract ability_id
```powershell
$cell = "Whirlwind - WAR__Whirlwind_"
if ($cell -match '- (WAR[_\w]+)$') {
    $abilityId = $Matches[1]  # "WAR__Whirlwind_"
}
```

### Step 2: Look up in database
```powershell
$ability = $Database | Where-Object { $_.ability_id -eq $abilityId }
```

### Step 3: Use full details
```powershell
$spellName = $ability.ability_id            # "WAR__Whirlwind_"
$displayName = $ability.ability_name        # "Whirlwind"
$fileType = $ability.bg3_file_type          # "Spell_Zone"
$spellType = $ability.bg3_spell_type        # "Zone"
$formula = $ability.damage_formula_bg3      # "1d8+StrengthModifier,Slashing"
```

---

## ✅ Validation Results

- ✅ **100% Coverage**: All 213 ability_id in LINKED.csv exist in database
- ✅ **Zero Duplicates**: Database has 224 unique abilities
- ✅ **Zero Missing**: No LINKED abilities missing from database
- ⚠️ **Hero Talents**: 7 missing (mostly Slayer tree + keystones/capstones)

---

## 📄 Related Files

- **Complete Analysis**: `LINKED_CSV_COMPLETE_ANALYSIS.md` (comprehensive 68-column guide)
- **Database**: `AbilityDatabase_Warrior_FullyEnriched.csv` (224 abilities)
- **SOURCE_OF_TRUTH.md**: Section [13] - Master Ability Database
- **Re-linking Script**: `Relink_WarriorProgression.ps1`

---

**Ready for**: FILE 12 (Progressions.lsx) transformation using relational query pattern
