# PHASE 5: Feats + ASI Validation Report

**Date**: October 24, 2025  
**Phase**: 5 of 7  
**Status**: Complete  
**Validation Result**: PASS

---

## Summary

Validated BG3 core features (Extra Attack, Feats, ASI) in the Warrior Progression LINKED CSV:
- **Extra Attack** (martial class feature at L5)
- **Feat milestones** (L4, L8, L12, L16, L19, L20 = 6 total)
- **ASI** (Ability Score Improvement - bundled with Feat choice in BG3)

**Validation Findings**:
- [PASS] Extra Attack: Correct (L5)
- [PASS] Feat Milestones: All 6 present
- [INFO] ASI: Bundled with Feat choice (BG3 standard)

---

## Validation Findings

 += "
### [CORRECT] Correct Elements

"

**Extra Attack**:
- L5: Grant Extra Attack (Column 2)

**Feat Milestones**:
- L4: Add Feat (Column 3)
- L8: Add Feat (Column 3)
- L12: Add Feat (Column 3)
- L16: Add Feat (Column 3)
- L19: Add Feat (Column 3)
- L20: Add Feat (Column 3)

### [DISCREPANCIES] Discrepancies Found

None - All BG3 core features are correct!

### [INFO] BG3 Mechanics Note

**Feat vs ASI**: In Baldur's Gate 3, Ability Score Improvement (ASI) is not a separate feature. At feat levels (L4/8/12/16/19/20), players choose EITHER:
- A Feat (special ability/bonus)
- +2 to one ability score (or +1 to two different scores)

This is the standard D&D 5e system. The progression table correctly shows 'Add Feat' as the milestone, with ASI being an implicit alternative choice.

---

## Evidence: BG3 Core Features Summary

| Feature | Expected | Found | Levels | Status |
|---------|----------|-------|--------|--------|
| Extra Attack | L5 (1x) | 1x | L5 | [PASS] |
| Feat Milestones | L4,8,12,16,19,20 (6x) | 6x | L4, L8, L12, L16, L19, L20 | [PASS] |
| ASI (explicit) | Bundled with Feats | Not shown | N/A | [INFO] |

---

## Analysis: Level-by-Level Breakdown

| Level | Extra Attack | Feat | Warrior Abilities | Notes |
|-------|--------------|------|-------------------|-------|
| L1 |  |  | 16 abilities |  |
| L2 |  |  | 9 abilities |  |
| L3 |  |  | 21 abilities |  |
| L4 |  | [YES] Feat | 23 abilities |  |
| L5 | [YES] |  | 24 abilities | Martial class feature |
| L6 |  |  | 30 abilities |  |
| L7 |  |  | 34 abilities |  |
| L8 |  | [YES] Feat | 17 abilities |  |
| L9 |  |  | 25 abilities |  |
| L10 |  |  | 23 abilities |  |
| L11 |  |  | 2 abilities |  |
| L12 |  | [YES] Feat | 3 abilities |  |
| L13 |  |  | 3 abilities | Hero talent keystone |
| L14 |  |  | 0 abilities |  |
| L15 |  |  | 9 abilities |  |
| L16 |  | [YES] Feat | 0 abilities |  |
| L17 |  |  | 9 abilities |  |
| L18 |  |  | 0 abilities |  |
| L19 |  | [YES] Feat | 9 abilities |  |
| L20 |  | [YES] Feat | 3 abilities | Max level + capstone |

---

## Recommendations

**No corrections needed!** All BG3 core features validated successfully.





---

## Next Steps

[PASS] **Phase 5 Complete** - Ready for PHASE 6: Choice Count Validation

---

## Validation Statistics

- **Extra Attack Issues**: 0
- **Feat Milestone Issues**: 0
- **Total Issues**: 0
- **Success**: 100%

---

**Generated**: 2025-10-24 00:13:16  
**Script**: Phase5_Feats_ASI_Validation.ps1
