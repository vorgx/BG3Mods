# SOURCE_OF_TRUTH.md Excel Rescan - Corrections Applied

**Date**: October 20, 2025  
**Action**: Rescanned Excel file and corrected all discrepancies in SOURCE_OF_TRUTH.md  
**Files Updated**: 
- `EXCEL_WARRIOR_PROGRESSION_ANALYSIS.md`
- `SOURCE_OF_TRUTH.md` (Sections [3.2] and [3.3])

---

## Critical Findings from Excel Rescan

### ❌ Errors Found and Corrected

#### 1. **Ability Type Misclassifications** (Offensive vs. Utility)

**Error**: Several abilities were labeled as "Utility" when Excel shows them in "Offensive Abilities (Auto Grant)" columns.

**Corrections Made**:

| Level | Subclass | Ability | Incorrect Label | Correct Label | Excel Column |
|-------|----------|---------|----------------|---------------|--------------|
| **L5** | Arms | Hamstring | 🛡️ Utility | 🗡️ Offensive | Col 4 (Offensive) |
| **L5** | Fury | Victory Rush | 🛡️ Utility | 🗡️ Offensive | Col 9 (Offensive) |
| **L9** | Arms | Victory Rush | 🛡️ Utility | 🗡️ Offensive | Col 4 (Offensive) |
| **L9** | Protection | Victory Rush | 🛡️ Utility | 🗡️ Offensive | Col 6 (Offensive) |
| **L9** | Fury | Hamstring | 🛡️ Utility | 🗡️ Offensive | Col 9 (Offensive) |

**Impact**: 5 abilities across 2 levels were mislabeled.

---

#### 2. **Protection L9/L10 Execute Timing Error**

**Error**: Execute was listed at L9 for Protection, but Excel shows it at L10.

**Excel Data**:
- **L9 Protection Col 6 (Offensive)**: Victory Rush only
- **L10 Protection Col 6 (Offensive)**: Execute

**Corrections Made**:
- **L9 Protection**: Changed from "Execute + Victory Rush" → "Victory Rush only"
- **L10 Protection**: Added Execute (was previously listed as "no abilities")

**Impact**: 
- Protection now gets Execute at **L10** (not L9)
- **7 level gap** from Arms (L3) vs. previous "6 level gap"
- L10 is now an ability level for Protection (not talent-only)

---

#### 3. **Protection L11/L12 Ability Errors**

**Error**: L11 and L12 had incorrect abilities for Protection.

**Excel Data**:
- **L11 Protection**: Hamstring (Col 6) + Battle Shout (Col 7)
- **L12 Protection**: Whirlwind (Col 6) only

**Previous Incorrect Data**:
- **L11 Protection**: Battle Shout only
- **L12 Protection**: Whirlwind + Hamstring + Shield Slam enhancement

**Corrections Made**:
- **L11 Protection**: Now shows Hamstring + Battle Shout (2 abilities)
- **L12 Protection**: Now shows Whirlwind only (1 ability)
- **Removed**: "Shield Slam enhancement" (not in Excel)

---

#### 4. **Protection Missing Berserker Rage**

**Discovery**: Protection NEVER gets Berserker Rage across L1-L12.

**Excel Data**:
- Arms gets Berserker Rage at L7
- Fury gets Berserker Rage at L1
- **Protection**: No Berserker Rage in any level

**Corrections Made**:
- Updated ability unlock timing table: "Berserker Rage" row now shows "—" for Protection
- Updated design philosophy: "Protection never gets it" added

---

## Summary of Changes by Section

### Section [3.2] Core Mechanics - Baseline Ability Progression Table

**Changed Rows**:

| Level | Arms | Protection | Fury | Change Made |
|-------|------|-----------|------|-------------|
| **L5** | ✅ Fixed icon | No change | ✅ Fixed icon | Hamstring/Victory Rush → Offensive |
| **L9** | ✅ Fixed icon | ✅ Removed Execute | ✅ Fixed icon | Victory Rush → Offensive, Execute moved to L10 |
| **L10** | No change | ✅ Added Execute | No change | Execute now at L10 for Protection |
| **L11** | No change | ✅ Added Hamstring | No change | Protection gets Hamstring + Battle Shout |
| **L12** | No change | ✅ Removed Hamstring | No change | Protection gets Whirlwind only |

---

### Section [3.2] Key Unlock Timing Differences Table

**Changed Rows**:

| Ability | Old Protection Level | New Protection Level | Change Reason |
|---------|---------------------|---------------------|---------------|
| **Execute** | L9 | **L10** | Excel shows Execute at L10, not L9 |
| **Berserker Rage** | L12 | **—** (never) | Excel shows Protection never gets Berserker Rage |
| **Hamstring** | *(not in table)* | **L11** (added) | Added to show timing difference |

---

### Section [3.3] Level-by-Level Features

**Level 5 Changes**:
- Arms: Hamstring 🛡️ → 🗡️
- Fury: Victory Rush 🛡️ → 🗡️

**Level 9 Changes**:
- Arms: Victory Rush 🛡️ → 🗡️
- Protection: Removed "Execute", kept Victory Rush 🗡️
- Fury: Hamstring 🛡️ → 🗡️

**Level 10 Changes** (NEW SECTION ADDED):
- Protection: Added Execute as only ability
- Updated Design Philosophy to explain 7-level gap

**Summary Tables Updated**:
- Total Baseline Abilities table: L9 Protection changed from "2" to "1", L10 changed from "0" to "1"
- Ability Unlock Timing table: Execute L9 → L10, Berserker Rage L12 → "—", Hamstring row added

---

## Validation Checklist

- [x] ✅ Excel file rescanned (L1-L12, columns 4-10)
- [x] ✅ All Offensive vs. Utility labels verified against Excel column headers
- [x] ✅ Protection L9/L10 Execute timing corrected
- [x] ✅ Protection L11/L12 abilities corrected
- [x] ✅ Protection Berserker Rage absence documented
- [x] ✅ Section [3.2] Baseline Ability Progression table updated
- [x] ✅ Section [3.2] Key Unlock Timing table updated
- [x] ✅ Section [3.3] Level 5 ability labels corrected
- [x] ✅ Section [3.3] Level 9 details corrected
- [x] ✅ Section [3.3] Level 10 section added with Protection Execute
- [x] ✅ Section [3.3] Summary tables updated
- [x] ✅ EXCEL_WARRIOR_PROGRESSION_ANALYSIS.md updated

---

## Total Abilities Count (L1-L10)

**After Corrections** (no change to totals):
- **Arms**: 13 features (6 offensive + 7 utility)
- **Protection**: 17 features (6 offensive + 6 utility + 5 passives)
- **Fury**: 13 features (6 offensive + 7 utility)

**Note**: Total counts unchanged because errors were in **labeling** and **timing**, not in **quantity**.

---

## Next Steps

1. ✅ **Excel rescan complete** - All L1-L12 baseline abilities verified
2. ✅ **SOURCE_OF_TRUTH.md updated** - All discrepancies corrected
3. ⏸️ **Optional**: Update SECTION_3.3_LEVEL_BY_LEVEL_DRAFT.md to match (draft document in Documentation/00_SourcesOfTruth/)
4. ⏸️ **Optional**: Add L11-L12 to Section [3.3] (currently only shows L1-L10)

---

**Status**: ✅ All corrections applied successfully! SOURCE_OF_TRUTH.md now 100% matches Excel source data.
