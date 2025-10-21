# Section [3.3] Draft Update Summary - Columns A-U Verification

**Date**: October 19, 2025  
**Changes Made**: Corrected stance source (Class Talents Row 1 vs. Baseline Abilities)  
**Source**: Excel columns A-U, EXCEL_WARRIOR_PROGRESSION_ANALYSIS.md lines 135-280

---

## Key Corrections Applied

### 1. Level 1 Stance Source Clarification

**Issue Identified**: Draft didn't distinguish between:
- **Class Talents Row 1** (Battle Stance + Defensive Stance for Arms/Protection)
- **Baseline Abilities** (Battle Stance + Defensive Stance for Fury)

**Corrections Made**:

#### Arms Warrior (L1)
- **Before**: Listed stances without source
- **After**: 
  - Baseline: Whirlwind + Charge
  - Class Talents Row 1 (auto-granted): Battle Stance + Defensive Stance

#### Protection Warrior (L1)
- **Before**: Listed stances without source
- **After**:
  - Baseline: Shield Slam + Taunt + Mastery: Critical Block
  - Class Talents Row 1 (auto-granted): Battle Stance + Defensive Stance

#### Fury Warrior (L1)
- **Before**: Listed stances without source
- **After**:
  - Baseline: Whirlwind + Berserker Rage + Battle Stance + Defensive Stance
  - **Critical Design Note**: Fury gets stances as PART OF BASELINE ABILITIES (columns 9-10 in Excel), not from Class Talents Row 1

---

### 2. Updated Table Structure

**Old Table**:
| Subclass | Abilities Granted | Passives | Stances | Total Features |

**New Table**:
| Subclass | Baseline Abilities | Baseline Passives | Class Talents (Row 1) | Total Features |

This clarifies:
- **Baseline Abilities** = Columns D-E (Arms), F-H (Protection), I-J (Fury)
- **Class Talents Row 1** = Columns K-L (auto-granted Battle + Defensive Stance for Arms/Protection)
- **Fury Exception** = Stances are in baseline abilities (columns I-J), NOT in Class Talents

---

### 3. Design Philosophy Update

**Added Critical Distinction**:
- **Arms/Protection**: Get stances from **Class Talents Row 1** (shared system, auto-granted)
- **Fury**: Gets stances as **Baseline Abilities** (part of subclass identity, columns I-J)

**Why This Matters**:
- Shows Fury's unique design: stances are CORE to identity (enrage-focused), not just a shared class feature
- Explains why Fury appears to have 4 baseline abilities at L1 (Whirlwind + Berserker Rage + 2 stances) vs. Arms/Protection having 2-3 baseline + 2 Class Row 1

---

## Validation Against Excel Columns A-U

| Column | Content | Draft Accuracy |
|--------|---------|----------------|
| **A** | Level (1-20) | ✅ Correct |
| **B** | BG3 Milestones (Extra Attack, Feats) | ✅ Correct |
| **C** | (Empty) | N/A |
| **D-E** | Arms Baseline Abilities (Offensive + Utility) | ✅ Correct - Whirlwind + Charge at L1 |
| **F-H** | Protection Baseline Abilities (Offensive + Utility + Passives) | ✅ Correct - Shield Slam + Taunt + Mastery: Critical Block at L1 |
| **I-J** | Fury Baseline Abilities (Offensive + Utility) | ✅ **NOW CORRECT** - Whirlwind + Berserker Rage + Battle Stance + Defensive Stance at L1 |
| **K-U** | Warrior Class Talents (Rows 1-10) | ✅ Correct - Row 1 (K-L) shows Battle Stance + Defensive Stance |

**Key Discovery**: Excel column I (Fury Baseline Abilities, Level 1) shows **4 entries**:
1. Whirlwind (Offensive)
2. Berserker Rage (Utility)
3. Battle Stance (Stance)
4. Defensive Stance (Stance)

This is DIFFERENT from Arms/Protection, which only have 2-3 baseline abilities at L1, with stances coming from Class Talents Row 1 (columns K-L).

---

## Files Updated

1. **SECTION_3.3_LEVEL_BY_LEVEL_DRAFT.md**:
   - Corrected L1 ability breakdown (3 locations)
   - Updated subclass-specific grants table
   - Added design philosophy clarification
   - Added critical difference callout

---

## Ready for User Review

All data now matches Excel columns A-U exactly:
- ✅ Arms: 2 baseline + 2 Class Row 1 stances = 4 features
- ✅ Protection: 2 baseline + 1 passive + 2 Class Row 1 stances = 5 features
- ✅ Fury: 4 baseline (including stances) = 4 features

**No other changes needed** - the rest of the draft (L2-L10 breakdown, summary tables, ability timing comparisons) all remain accurate and sourced from columns A-U.
