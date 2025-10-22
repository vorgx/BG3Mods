# Progression CSV - Full Structure Report

**Date**: October 22, 2025  
**File**: `Warrior Progression for all subclasses and Default hero structure.csv`

---

## 📊 FILE STRUCTURE OVERVIEW

### Basic Metrics
- **Total Rows**: 23
  - Header Rows: 3 (rows 1-3)
  - Data Rows: 20 (rows 4-23 = levels 1-20)
- **Total Columns**: 69
- **Columns with Data**: 61
- **Unique Abilities**: 186
- **Total Ability Instances**: 227 (with duplicates across levels/specs)

---

## 📋 COLUMN STRUCTURE

### Header Row 1 - Main Categories (Column Ranges)

| Columns | Category | Purpose |
|---------|----------|---------|
| **0** | Level | Level number (1-20) |
| **1-2** | BG3 (All Classes) | Attacks/Feats columns |
| **3-4** | Baseline Arms Warrior Abilities | Auto-granted Arms baseline |
| **5-7** | Baseline Protection Warrior Spells | Auto-granted Protection baseline |
| **8-9** | Baseline Fury Warrior Abilities | Auto-granted Fury baseline |
| **10-19** | **Warrior Class Talents (All subclasses)** | **Talents ALL specs get** |
| **20-32** | Arms Spec Talents (Only for Arms) | Arms-exclusive talents |
| **33-43** | Fury Spec Talents (Only for Fury) | Fury-exclusive talents |
| **44-51** | Protection Spec Talents (Only for Protection) | Protection-exclusive talents |
| **52-54** | Mountain Thane Talents (Protection, Fury) | Hero talents for Prot/Fury |
| **55-57** | Colossus Talents (Arms, Protection) | Hero talents for Arms/Prot |
| **58-68** | Slayers Talents (Arms, Fury) | Hero talents for Arms/Fury |

### Database Column Mapping

| CSV Column Range | Database Unlock Column(s) |
|-----------------|---------------------------|
| 3-4 | `arms_unlock` |
| 5-7 | `protection_unlock` |
| 8-9 | `fury_unlock` |
| **10-19** | **`warrior_unlock`** ← All specs get these! |
| 20-32 | `arms_unlock` |
| 33-43 | `fury_unlock` |
| 44-51 | `protection_unlock` |
| 52-54 | `protection_unlock`, `fury_unlock` |
| 55-57 | `arms_unlock`, `protection_unlock` |
| 58-68 | `arms_unlock`, `fury_unlock` |

---

## 📈 ABILITIES PER LEVEL

### Levels 1-12 (Active Progression)

| Level | Ability Count | Status |
|-------|---------------|--------|
| **1** | 16 | ✅ Highest single-level count |
| **2** | 8 | ✅ |
| **3** | 21 | ✅ |
| **4** | 22 | ✅ |
| **5** | 25 | ✅ |
| **6** | 29 | ✅ |
| **7** | 35 | ✅ **Maximum abilities in one level** |
| **8** | 16 | ✅ |
| **9** | 25 | ✅ |
| **10** | 23 | ✅ |
| **11** | 4 | ⚠️ Only baseline ability adjustments |
| **12** | 3 | ⚠️ Only baseline ability adjustments |

### Levels 13-20 (No Data in CSV)

| Level | Ability Count | Reason |
|-------|---------------|--------|
| **13-20** | 0 | ❌ Empty rows - no data in CSV |

**Note**: Hero talents (Mountain Thane, Colossus, Slayers) are included in levels 1-12 data, not in separate 13+ rows.

---

## 🔍 WARRIOR CLASS TALENTS BREAKDOWN

**Column Range**: 10-19 (10 columns)  
**Purpose**: Talents that ALL subclasses get at the same level  
**Database Column**: `warrior_unlock`

### Warrior Class Talents by Level

| Level | Count | Talents |
|-------|-------|---------|
| **1** | 2 | Battle Stance, Defensive Stance |
| **2** | 4 | Fast Footwork, War Machine, Leeching Strikes, Intervene |
| **3** | 3 | Impending Victory, Heroic Leap, Storm Bolt |
| **4** | 6 | Intimidating Shout, Second Wind, Frothing Berserker, Bounding Stride, Pain and Gain, Thunder Clap |
| **5** | 6 | Cacophonous Roar, Menace, Spell Reflection, Rallying Cry, Shockwave, Barbaric Training |
| **6** | 6 | Honed Reflexes, Crushing Force, Bitter Immunity, Overwhelming Rage, Rumbling Earth, Reinforced Plates |
| **7** | 8 | Wrecking Throw, Shattering Throw, Sidearm, Double Time, Seismic Reverberation, Concussive Blows, Berserker Shout, Piercing Howl |
| **8** | 4 | Cruel Strikes, Wild Strikes, Dual Wield Specialization, Armored to the Teeth |
| **9** | 3 | Thunderous Roar, Avatar, Champion's Spear |
| **10** | 6 | Uproar, Thunderous Words, Berserker's Torment, Titan's Torment, Piercing Challenge, Champion's Might |
| **11-12** | 0 | (No class talents at these levels) |

**Total Warrior Class Talents**: 48 (should all have `warrior_unlock` populated)

---

## 🔄 ABILITIES APPEARING MULTIPLE TIMES

**Total**: 26 abilities appear at different levels for different specs

### Top Multi-Occurrence Abilities

| Ability | Levels | Reason |
|---------|--------|--------|
| **Whirlwind** | L1, L1, L12 | Arms/Fury baseline L1, Protection L12 |
| **Execute** | L3, L7, L10 | Arms L3, Fury L7, Protection L10 |
| **Shield Slam** | L1, L12, L12 | Protection baseline L1, Arms/Fury L12 |
| **Charge** | L1, L3, L5 | Arms L1, Fury L3, Protection L5 |
| **Slam** | L3, L7, L7 | Fury L3, Arms/Protection L7 |
| **Pummel** | L3, L5, L7 | Arms L3, Fury L5, Protection L7 |
| **Sudden Death** | L4, L4, L6 | Appears in multiple spec talent trees |
| **Massacre** | L7, L7, L9 | Arms/Fury L7, Protection L9 |
| **Anger Management** | L6, L8, L9 | Different tiers in different specs |

**Design Pattern**: Baseline abilities unlock at different levels per specialization, allowing gradual power acquisition.

---

## 🎯 COLUMN USAGE STATISTICS

### Most Active Columns (>8 rows of data)

| Column | Rows | Category | Type |
|--------|------|----------|------|
| **12-14** | 9 rows each | Warrior Class Talents | Auto-grant choices |
| **24-26** | 8 rows each | Arms Spec Talents | Spec choices |
| **36-38** | 8 rows each | Fury Spec Talents | Spec choices |
| **45-47** | 8-9 rows | Protection Spec Talents | Spec choices |

### Sparse Columns (<3 rows of data)

| Columns | Usage | Reason |
|---------|-------|--------|
| **1-2** | 1-6 rows | BG3 system grants (attacks, feats) - limited |
| **18-19** | 1 row | End of Warrior Class Talents - fewer choices |
| **30-32** | 1-3 rows | Deep Arms spec talents - end of tree |
| **42-43** | 1-2 rows | Deep Fury spec talents - end of tree |
| **50-51** | 2-3 rows | Deep Protection spec talents - end of tree |

---

## ⚠️ KEY FINDINGS

### 1. Warrior Class Talents Column Span Issue
**Problem**: "Warrior Class Talents (All subclasses)" header in Column 10, but data spans **Columns 10-19** (10 columns)  
**Impact**: Original V3 script only mapped Column 10, missing columns 12-19  
**Solution**: Manual fixes applied to populate all 48 talents with `warrior_unlock`

### 2. Levels 13-20 Empty
**Problem**: CSV rows for levels 13-20 exist but contain NO ability data  
**Impact**: Hero talents are embedded in levels 1-12, not in separate 13+ rows  
**Implication**: Hero talent unlocking likely controlled by BG3 progression system, not CSV level rows

### 3. Multiple Baseline Ability Variants
**Pattern**: Same ability name (e.g., Execute, Whirlwind) appears at different levels for different specs  
**Database Impact**: Should populate spec-specific unlock columns, NOT `warrior_unlock`  
**Validation**: ✅ Correctly handled by FIX_WARRIOR_UNLOCK_LOGIC.ps1

### 4. Duplicate Talent Names Across Specs
**Examples**: Sudden Death, Massacre, Anger Management, Bloodborne  
**Pattern**: Same talent name, different implementations per spec  
**Database**: Likely needs separate entries with spec identifiers

---

## ✅ VALIDATION CHECKLIST

- ✅ **48 Warrior Class Talents** identified (columns 10-19, levels 1-10)
- ✅ **All 48 should have `warrior_unlock` populated** in database
- ✅ **Baseline abilities** (columns 3-9) should populate spec-specific unlock columns
- ✅ **Spec talents** (columns 20-51) should populate spec-specific unlock columns
- ✅ **Hero talents** (columns 52-68) should populate MULTIPLE unlock columns

---

## 📊 SUMMARY

### CSV Health
- **Structure**: ✅ Well-formed, 69 columns, 23 rows
- **Headers**: ✅ Clear category separation
- **Data**: ✅ Levels 1-12 populated, 13-20 empty (expected)

### Population Status (After Fixes)
- **Warrior Class Talents**: ✅ 48/48 populated (100%)
- **Baseline Abilities**: ⚠️ Partial (script limitations on multi-column headers)
- **Spec Talents**: ⚠️ Partial (needs full V4 script run)
- **Hero Talents**: ⚠️ Partial (multi-column population needed)

### Next Actions
1. ✅ **DONE**: Fix all 48 Warrior Class Talents (`warrior_unlock`)
2. ⏸️ **TODO**: Re-run full population script with corrected column mapping (columns 10-19 for warrior talents)
3. ⏸️ **TODO**: Verify baseline abilities populate correct spec columns
4. ⏸️ **TODO**: Verify hero talents populate MULTIPLE spec columns

---

**Report Generated**: October 22, 2025  
**Scripts Used**: FULL_CSV_SCAN.ps1  
**Status**: ✅ Analysis Complete
