# SOURCE_OF_TRUTH.md - Required Updates Report

**Generated**: October 20, 2025  
**Purpose**: Document corrections needed in SOURCE_OF_TRUTH.md based on updated Excel CSV

---

## ✅ Issues Found - 2 Corrections Needed

### Issue 1: Fury L1 Baseline Has Stances (INCORRECT)

**Location**: Line 1090

**❌ CURRENT (INCORRECT)**:
```markdown
| **Fury** | Whirlwind + Berserker Rage + Battle Stance + Defensive Stance | — | — (stances in baseline) | **4** (2 abilities + 2 stances) |
```

**✅ SHOULD BE**:
```markdown
| **Fury** | Whirlwind + Berserker Rage | — | Battle Stance + Defensive Stance (Stances) | **4** (2 abilities + 2 stances) |
```

**Explanation**: 
- Fury baseline (columns I-J in Excel) only contains Whirlwind + Berserker Rage
- Battle Stance + Defensive Stance come from Class Talents Row 1 (columns K-L)
- ALL Warriors get stances from Class Talents Row 1, not from baseline

---

### Issue 2: Colossus Keystone Shows "Demolish + Colossal Might" (INCORRECT)

**Location**: Line 927

**❌ CURRENT (INCORRECT)**:
```markdown
| **Colossus** | **Arms + Protection** | Demolish + Colossal Might | Dominance of the Colossus | Physical dominance, crowd control |
```

**✅ SHOULD BE**:
```markdown
| **Colossus** | **Arms + Protection** | Demolish | Dominance of the Colossus | Physical dominance, crowd control |
```

**Explanation**:
- L13 Keystone is "Demolish" only (Excel column BG, row 16)
- "Colossal Might" is a separate talent granted at L15 (Excel column BH, row 18)
- L15 grants: Martial Expert + Colossal Might + Earthquake (3 talents)

---

## ✅ No Issues Found - Already Correct

### Feat Count - Already Correct ✅

SOURCE_OF_TRUTH.md correctly shows:
- Section [3.3] covers L1-L12 only
- Lists Feats at L4, L8, L12 (3 Feats in that section)
- Does NOT claim to cover L13-L20 Feats

**No correction needed** - The document is scoped to L1-L12, so it correctly shows 3 Feats.

**Note**: When Section [5] (L13-L20) is added, it should include:
- L16 Feat
- L19 Feat
- L20 Feat
- Total L13-L20: 3 additional Feats (6 total L1-L20)

---

## 📝 Detailed Correction Instructions

### Correction 1: Fix Fury L1 Baseline Table

**File**: `Documentation/00_SourcesOfTruth/SOURCE_OF_TRUTH.md`  
**Line**: ~1090  
**Section**: [3.1] Level 1: Character Creation - Summary Table

**Find this line**:
```markdown
| **Fury** | Whirlwind + Berserker Rage + Battle Stance + Defensive Stance | — | — (stances in baseline) | **4** (2 abilities + 2 stances) |
```

**Replace with**:
```markdown
| **Fury** | Whirlwind + Berserker Rage | — | Battle Stance + Defensive Stance (Stances) | **4** (2 abilities + 2 stances) |
```

---

### Correction 2: Fix Colossus Keystone Name

**File**: `Documentation/00_SourcesOfTruth/SOURCE_OF_TRUTH.md`  
**Line**: ~927  
**Section**: [2.4] Hero Talent Specializations Table

**Find this line**:
```markdown
| **Colossus** | **Arms + Protection** | Demolish + Colossal Might | Dominance of the Colossus | Physical dominance, crowd control |
```

**Replace with**:
```markdown
| **Colossus** | **Arms + Protection** | Demolish | Dominance of the Colossus | Physical dominance, crowd control |
```

---

## 🔍 Additional Verification Needed

After making these corrections, verify these sections don't have the same errors:

### Check Section [3.1] Detailed Ability Breakdown

Look for any detailed descriptions of Fury L1 that might list stances as baseline abilities.

**Search for**: "Fury Warrior (L1)" or "Fury.*L1"

**Verify**: Only lists Whirlwind + Berserker Rage, NOT stances

---

### Check Section [5] (if it exists)

If Section [5] Hero Talents has been added, verify:
- Colossus L13 lists "Demolish" only
- Colossus L15 lists "Martial Expert + Colossal Might + Earthquake"
- Total Feats L1-L20 = 6 (L4, L8, L12, L16, L19, L20)

---

## 📊 Summary

**Total Corrections Needed**: 2

1. ✏️ Line ~1090: Remove stances from Fury baseline, add to Class Talents column
2. ✏️ Line ~927: Remove "Colossal Might" from Colossus keystone

**No Other Issues Found**: 
- Feat counts are correct for L1-L12 scope
- No other stance-related errors found
- No other Colossus-related errors found

---

## ✅ Post-Update Verification Checklist

After making corrections:

- [ ] Fury L1 baseline shows only "Whirlwind + Berserker Rage"
- [ ] Fury L1 Class Talents shows "Battle Stance + Defensive Stance"
- [ ] Colossus keystone shows only "Demolish"
- [ ] Search document for any remaining "Fury.*L1.*Battle Stance" (should be 0 results)
- [ ] Search document for any remaining "Colossus.*Colossal Might.*L13" (should be 0 results)
- [ ] Update "Last Updated" timestamp in change log
- [ ] Add change log entry documenting these 2 corrections

---

**Status**: Ready for implementation  
**Priority**: Medium (affects accuracy but not critical path)  
**Estimated Time**: 5 minutes (2 simple find-replace operations)

**Last Updated**: October 20, 2025
