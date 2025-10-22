# Unlock Levels Population Plan

**Date**: October 22, 2025  
**Purpose**: Populate warrior_unlock, arms_unlock, fury_unlock, protection_unlock columns from progression CSV  
**Status**: ⚠️ **PREVIEW - NOT EXECUTED YET**

---

## Current Database State

### Columns (31 total)
✅ Already has the 4 unlock columns:
- `warrior_unlock` - Unlock level for all Warriors (baseline abilities)
- `arms_unlock` - Unlock level for Arms specifically
- `fury_unlock` - Unlock level for Fury specifically
- `protection_unlock` - Unlock level for Protection specifically

✅ **No old `unlock_level` column found** - Nothing to remove!

### Current Data State

**Sample Current Values** (mostly empty):

| Ability | warrior_unlock | arms_unlock | fury_unlock | protection_unlock |
|---------|---------------|-------------|-------------|-------------------|
| Whirlwind | '' | '1' | '1' | '12' |
| Execute | '' | '3' | '7' | '' |
| Mortal Strike | '' | ??? | ??? | ??? |
| Battle Stance | '' | ??? | ??? | ??? |
| Lightning Strikes | '' | ??? | ??? | ??? |

**Issue**: Most unlock levels are **MISSING** (empty strings), but Whirlwind and Execute have some data already.

---

## What the Script Will Do

### Source Data
**File**: `Documentation/00_SourcesOfTruth/Warrior Progression for all subclasses and Default hero structure.csv`

**Columns to Parse**:
1. **Level** - The unlock level (1-20)
2. **Baseline Arms Warrior Abilities** - Auto-granted Arms abilities
3. **Baseline Protection Warrior Spells** - Auto-granted Protection abilities
4. **Baseline Fury Warrior Abilities** - Auto-granted Fury abilities
5. **Warrior Class Talents** - Shared by all subclasses
6. **Arms Spec Talents** - Arms-only talents
7. **Fury Spec Talents** - Fury-only talents
8. **Protection Warrior Spec Talents** - Protection-only talents
9. **Mountain Thane Talents** (Protection, Fury) - Hero talents L13-20
10. **Colossus Talents** (Arms, Protection) - Hero talents L13-20
11. **Slayers Talents** (Arms, Fury) - Hero talents L13-20

### Processing Logic

#### 1. Extract Ability Names
The CSV has entries like:
- `"Whirlwind (WW) - primary multitarget attack."`
- `"Execute (Exe) - Arms' version of Execute"`
- `"Battle Stance (Battle/BStance) - basic offensive stance."`

**Parsing Strategy**:
- Strip leading/trailing symbols (`'`, `"`, `·`, spaces)
- Extract ability name before `(abbreviation)` or before `-` description
- Examples:
  - Input: `"·Whirlwind· (WW) - primary multitarget attack."` → Output: `Whirlwind`
  - Input: `"Execute (Exe) - Arms' version"` → Output: `Execute`
  - Input: `"Lightning Strikes"` → Output: `Lightning Strikes`

#### 2. Assign Unlock Levels by Subclass

**Baseline Abilities** (columns: Arms/Prot/Fury Offensive + Utility + Passives):
- If found in **Arms column** at level X → `arms_unlock = X`, `warrior_unlock = X`
- If found in **Prot column** at level Y → `protection_unlock = Y`, `warrior_unlock = Y`
- If found in **Fury column** at level Z → `fury_unlock = Z`, `warrior_unlock = Z`
- If same ability appears in multiple columns → Each spec gets its unlock level

**Class Talents** (Stance columns):
- If found → `arms_unlock = X`, `fury_unlock = X`, `protection_unlock = X`, `warrior_unlock = X`
- Shared by all subclasses

**Spec Talents** (Passive/Ability columns per spec):
- If found in **Arms Spec Talents** → `arms_unlock = X`, other columns = empty
- If found in **Fury Spec Talents** → `fury_unlock = X`, other columns = empty
- If found in **Protection Spec Talents** → `protection_unlock = X`, other columns = empty

**Hero Talents** (L13-20 columns):
- **Mountain Thane** → `protection_unlock = X`, `fury_unlock = X`, `warrior_unlock = empty`
- **Colossus** → `arms_unlock = X`, `protection_unlock = X`, `warrior_unlock = empty`
- **Slayers** → `arms_unlock = X`, `fury_unlock = X`, `warrior_unlock = empty`

#### 3. Fuzzy Matching
If exact name match fails, try fuzzy matching:
- Database: `"Mastery: Deep Wounds"` vs CSV: `"Mastery Deep Wounds"`
- Use substring matching to find closest match

---

## Expected Results

### Example: Whirlwind (Baseline Ability)

**From CSV**:
- Level 1 Arms: `"Whirlwind (WW) - primary multitarget attack."`
- Level 1 Fury: `"Whirlwind (WW) - primary multitarget attack which facilitates cleaving other attacks."`
- Level 12 Protection: `"Whirlwind (WW) - A basic Rage-spending, AoE damage skill. It is not useful to Protection Warriors."`

**Expected Database Update**:
```csv
ability_name: Whirlwind
warrior_unlock: 1  (earliest level across all specs)
arms_unlock: 1
fury_unlock: 1
protection_unlock: 12
```

### Example: Execute (Baseline Ability, Different Levels)

**From CSV**:
- Level 3 Arms: `"Execute (Exe) - Arms' version of Execute"`
- Level 7 Fury: `"Execute (Exe) - Fury's version of Execute"`
- Level 10 Protection: `"Execute - Powerful single-target damage skill..."`

**Expected Database Update**:
```csv
ability_name: Execute
warrior_unlock: 3  (earliest level)
arms_unlock: 3
fury_unlock: 7
protection_unlock: 10
```

### Example: Mortal Strike (Arms Spec Talent)

**From CSV**:
- Level 1 Arms Spec Talents: `"Mortal Strike (MS) - primary attack forming the basis of the rotation."`

**Expected Database Update**:
```csv
ability_name: Mortal Strike
warrior_unlock: (empty - not baseline)
arms_unlock: 1
fury_unlock: (empty - Arms only)
protection_unlock: (empty - Arms only)
```

### Example: Battle Stance (Class Talent)

**From CSV**:
- Level 1 Warrior Class Talents: `"Battle Stance (Battle/BStance) - basic offensive stance."`

**Expected Database Update**:
```csv
ability_name: Battle Stance
warrior_unlock: 1  (shared by all)
arms_unlock: 1
fury_unlock: 1
protection_unlock: 1
```

### Example: Lightning Strikes (Hero Talent - Mountain Thane)

**From CSV**:
- Level 13 Mountain Thane Talents: `"Lightning Strikes"`

**Expected Database Update**:
```csv
ability_name: Lightning Strikes
warrior_unlock: (empty - hero talent, not baseline)
arms_unlock: (empty - not Arms hero path)
fury_unlock: 13  (Fury + Protection path)
protection_unlock: 13  (Fury + Protection path)
```

### Example: Demolish (Hero Talent - Colossus)

**From CSV**:
- Level 13 Colossus Talents: `"Demolish"`

**Expected Database Update**:
```csv
ability_name: Demolish
warrior_unlock: (empty)
arms_unlock: 13  (Arms + Protection path)
fury_unlock: (empty - not Fury hero path)
protection_unlock: 13  (Arms + Protection path)
```

---

## Summary of Changes

### Expected Updates
- **~200 abilities** will have unlock levels populated
- **~15 abilities** may not match (talent choices, alternate names)

### Columns Modified
- `warrior_unlock` - Will be populated for baseline/class abilities
- `arms_unlock` - Will be populated for Arms baseline + Arms spec talents + Arms hero talents
- `fury_unlock` - Will be populated for Fury baseline + Fury spec talents + Fury hero talents
- `protection_unlock` - Will be populated for Protection baseline + Protection spec talents + Protection hero talents

### Columns Preserved
- All other 27 columns remain unchanged
- No data loss

### Output
- **Backup created**: Database will be backed up before modification
- **Updated file**: `Documentation/00_SourcesOfTruth/AbilityDatabase_Warrior_FullyEnriched.csv`

---

## Validation Strategy

### After Script Runs
1. **Count check**: Verify 215 rows still present
2. **Column check**: Verify 31 columns still present
3. **Spot check**: Manually verify 10+ sample abilities
4. **Range check**: All unlock levels should be 1-20
5. **Logic check**: `warrior_unlock` should be earliest level across all specs

### Sample Abilities to Verify
- ✅ Whirlwind (baseline, all specs, different levels)
- ✅ Execute (baseline, all specs, different levels)
- ✅ Mortal Strike (Arms spec talent, L1)
- ✅ Bloodthirst (Fury spec talent, L1)
- ✅ Shield Slam (Protection baseline, L1 Prot vs L12 Arms/Fury)
- ✅ Battle Stance (class talent, all specs, L1)
- ✅ Lightning Strikes (Mountain Thane hero talent, L13)
- ✅ Demolish (Colossus hero talent, L13)
- ✅ Slayer's Dominance (Slayer hero talent, L13)

---

## Risk Assessment

### Low Risk
- ✅ No data deletion (only populating empty columns)
- ✅ Backup created before modification
- ✅ CSV export/import preserves all data
- ✅ Script only updates 4 specific columns

### Medium Risk
- ⚠️ Name matching may fail for ~15 abilities (fuzzy matching helps)
- ⚠️ Manual review needed for non-matched abilities

### Mitigation
- **Backup**: Always create backup before running
- **Preview**: This document shows expected behavior
- **Validation**: Post-script validation checks
- **Rollback**: Can restore from backup if issues occur

---

## User Approval Required

**Before executing the script, please confirm**:

1. ✅ You understand the script will populate the 4 unlock columns
2. ✅ You've reviewed the expected results above
3. ✅ You're ready to proceed with the update
4. ✅ You understand ~15 abilities may need manual review after

**Next Steps**:
1. User reviews this document
2. User approves execution
3. Script runs with backup creation
4. Validation checks performed
5. Results documented
6. Section [13] in SOURCE_OF_TRUTH.md updated

---

**Document Status**: ✅ Ready for User Review  
**Script Status**: ⏸️ Waiting for User Approval
