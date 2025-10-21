# Section [3.3] Level-by-Level Base Class Features - FINAL SUMMARY

**Date**: October 19, 2025  
**Status**: ✅ Ready for Approval  
**Source**: Excel columns A-U (Warrior Progression for all subclasses.xlsx)  
**Changes**: Updated to use "Stance" terminology consistently

---

## Summary of Section [3.3] Contents

### Document Structure

**10 Level Breakdowns** (Levels 1-10):
- **Level 1** (Character Creation) - Starting loadouts by subclass
- **Level 2** (Talent-only) - No abilities, 1 talent choice
- **Level 3** (Subclass Specialization) - Diverging ability grants begin
- **Level 4** (Feat/ASI) - No abilities, 3 choices
- **Level 5** (Extra Attack) - Power spike + abilities
- **Level 6** (Talent-only) - No abilities, 2 talent choices
- **Level 7** (Ability Grants Resume) - Convergence begins
- **Level 8** (Feat/ASI) - No abilities, 3 choices
- **Level 9** (Convergence) - Toolkit completion
- **Level 10** (Talent-only) - No abilities, 2 talent choices (final Class Talent row)

**3 Summary Tables**:
1. **Total Baseline Abilities by Level** - Shows Protection 17 vs. Arms/Fury 13 features
2. **Ability Unlock Timing Comparison** - Shows Execute, Berserker Rage, Charge timing differences
3. **Talent Choices by Level** - Shows 19 total choices L1-L10

---

## Key Design Insights

### Level 1 Starting Loadout

**All Warriors Receive**:
- ✅ Rage Resource (0-100 max, combat-only, decays -5 per turn)
- ✅ 9 Proficiencies (STR/CON saves, all armor, shields, simple/martial weapons)
- ✅ 2 Passives (`WAR_UnlockRage`, `WAR_RageGeneration`)

**Subclass-Specific Grants**:

| Subclass | Baseline Abilities | Baseline Passives | Class Talents Row 1 | Total Features |
|----------|-------------------|-------------------|---------------------|----------------|
| **Arms** | Whirlwind + Charge | — | Battle Stance + Defensive Stance (Stances) | **4** (2 abilities + 2 stances) |
| **Protection** | Shield Slam + Taunt | Mastery: Critical Block | Battle Stance + Defensive Stance (Stances) | **5** (2 abilities + 1 passive + 2 stances) |
| **Fury** | Whirlwind + Berserker Rage + Battle Stance + Defensive Stance | — | — (stances in baseline) | **4** (2 abilities + 2 stances) |

**Critical Distinction**:
- **Arms/Protection**: Stances come from **Class Talents Row 1** (columns K-L in Excel, auto-granted)
- **Fury**: Stances come from **Baseline Abilities** (columns I-J in Excel, part of subclass identity)

**Why This Matters**:
- Fury's stances are CORE to identity (enrage-focused, always active)
- Arms/Protection share stances as a class feature (tactical switching)

---

## Total Features L1-L10

### Feature Count by Level

| Level | Arms | Protection | Fury | Notes |
|-------|------|-----------|------|-------|
| **L1** | 4 | **5** ⭐ | 4 | Protection gets Mastery: Critical Block |
| **L2** | 0 | 0 | 0 | Talent-only level |
| **L3** | 2 | **3** ⭐ | 2 | Protection gets Shield Block + Riposte |
| **L4** | 0 | 0 | 0 | Feat/ASI level |
| **L5** | 3 | **4** ⭐ | 3 | Protection gets extra utility + resource upgrade |
| **L6** | 0 | 0 | 0 | Talent-only level |
| **L7** | 2 | **3** ⭐ | 2 | Protection gets Vanguard passive |
| **L8** | 0 | 0 | 0 | Feat/ASI level |
| **L9** | 2 | 2 | 2 | All specs converge |
| **L10** | 0 | 0 | 0 | Talent-only level |
| **TOTAL** | **13** | **17** ⭐ | **13** | Protection +4 features for tank role |

**Key Insight**: Protection gets **4 extra features** across L1-L10 to enable tank role from start and maintain utility edge.

---

## Ability Unlock Timing (Selected Abilities)

| Ability | Arms | Protection | Fury | Level Gap |
|---------|------|-----------|------|-----------|
| **Execute** | **L3** ✨ | L9 | L7 | Arms 6 levels ahead of Protection |
| **Berserker Rage** | L7 | L12 | **L1** ✨ | Fury 6 levels ahead of Arms |
| **Charge** | **L1** ✨ | L5 | L3 | Arms first, Fury 2nd, Protection last |
| **Whirlwind** | **L1** ✨ | L12 | **L1** ✨ | DPS specs early, tanks 11 levels later |
| **Taunt** | L9 | **L1** ✨ | L9 | Protection 8 levels ahead (tank priority) |
| **Shield Slam** | L12 | **L1** ✨ | L12 | Protection 11 levels ahead (threat tool) |
| **Battle Shout** | **L5** ✨ | L11 | L7 | Arms 6 levels ahead (group support) |
| **Victory Rush** | L9 | L9 | **L5** ✨ | Fury 4 levels ahead (sustain) |

**Design Philosophy**:
1. **Protection = Tank-Ready L1**: Shield Slam + Taunt + Mastery enables immediate tanking
2. **Arms = Execute Specialist**: Gets signature finisher 6 levels before Protection
3. **Fury = Enrage Identity**: Gets Berserker Rage 6 levels before Arms
4. **Different Pacing = Different Feel**: Same 12 baseline abilities, different unlock orders

---

## Player Choices L1-L10

| Level | Class Talents | SubclassSpec Talents | Feat/ASI | Total Choices |
|-------|--------------|---------------------|----------|---------------|
| **L1** | Auto-grant (Row 1) | Auto-grant | — | **0** |
| **L2** | Row 2 (4 options) | — | — | **1** |
| **L3** | Row 3 (3 options) | Row 1 | — | **2** |
| **L4** | Row 4 (6 options) | Row 2 | ✅ | **3** |
| **L5** | Row 5 (6 options) | Row 3 | — | **2** |
| **L6** | Row 6 (6 options) | Row 4 | — | **2** |
| **L7** | Row 7 (9 options ⭐) | Row 5 | — | **2** |
| **L8** | Row 8 (4 options) | Row 6 | ✅ | **3** |
| **L9** | Row 9 (3 options) | Row 7 | — | **2** |
| **L10** | Row 10 (6 options) | Row 8 | — | **2** |
| **TOTAL** | **9 choices** | **8 choices** | **2 choices** | **19 choices** |

**Note**: L1 Class Talents Row 1 is auto-granted (Battle Stance + Defensive Stance), so first player choice is at L2.

---

## Validation Against Excel

### Column Mapping Verified

| Excel Columns | Content | Draft Accuracy |
|---------------|---------|----------------|
| **A** | Level (1-20) | ✅ Correct |
| **B** | BG3 Milestones | ✅ Correct (Extra Attack L5, Feats L4/L8) |
| **D-E** | Arms Baseline | ✅ Correct (L1: Whirlwind + Charge) |
| **F-H** | Protection Baseline | ✅ Correct (L1: Shield Slam + Taunt + Mastery: Critical Block) |
| **I-J** | Fury Baseline | ✅ Correct (L1: Whirlwind + Berserker Rage + Battle Stance + Defensive Stance) |
| **K-L** | Class Talents Row 1 | ✅ Correct (Battle Stance + Defensive Stance for Arms/Protection) |
| **M-U** | Class Talents Rows 2-10 | ✅ Referenced correctly |

### Terminology Consistency

| Term | Usage | Status |
|------|-------|--------|
| **Stance** | Battle Stance, Defensive Stance | ✅ Consistent throughout |
| **Offensive** | Whirlwind, Execute, Shield Slam, Slam | ✅ Consistent |
| **Utility** | Charge, Taunt, Pummel, Battle Shout | ✅ Consistent |
| **Passive** | Mastery: Critical Block, Riposte, Vanguard | ✅ Consistent |
| **Baseline Ability** | Auto-granted per subclass | ✅ Consistent |
| **Class Talent Row 1** | Auto-granted stances (Arms/Protection) | ✅ Consistent |

---

## What's Documented

### Per-Level Details (L1-L10)
- ✅ BG3 Milestones (Extra Attack, Feats, etc.)
- ✅ Baseline Abilities Granted (by subclass)
- ✅ Detailed Ability Breakdown (per subclass)
- ✅ Design Philosophy explanations
- ✅ Talent Choices Available (Class + SubclassSpec rows)

### Summary Tables
- ✅ Total Baseline Abilities by Level (Protection 17 vs. Arms/Fury 13)
- ✅ Ability Unlock Timing Comparison (11 key abilities)
- ✅ Talent Choices by Level (19 total choices L1-L10)

### Design Insights
- ✅ Protection tank-ready from L1 (4 extra features across L1-L10)
- ✅ Arms Execute specialist identity (L3 unlock vs. L7/L9)
- ✅ Fury enrage identity (Berserker Rage L1 vs. L7)
- ✅ Stance source distinction (Class Row 1 vs. Baseline)

---

## Cross-References

- **Section [3.1]**: Base Class Definition (ClassDescription XML structure)
- **Section [3.2]**: Core Mechanics (Rage system, combat mechanics, proficiencies)
- **Section [6]**: Progression (Progressions.lsx implementation details)
- **Excel Source**: `Warrior Progression for all subclasses.xlsx` columns A-U (L1-L10 data)
- **Analysis Source**: `EXCEL_WARRIOR_PROGRESSION_ANALYSIS.md` lines 135-280

---

## Ready for Approval

### All Validation Checks Passed
- [x] ✅ Data sourced from Excel columns A-U
- [x] ✅ Stance terminology consistent ("Stance - Class Talent Row 1" or "Stance - Baseline Ability")
- [x] ✅ L1 shows subclass-specific starting loadouts (Arms 4, Protection 5, Fury 4)
- [x] ✅ L2/L6/L10 marked as talent-only levels (0 abilities)
- [x] ✅ L4/L8 marked as Feat/ASI levels (0 abilities)
- [x] ✅ L5 shows Extra Attack + subclass abilities
- [x] ✅ Protection shows 4 extra features across L1-L10
- [x] ✅ Ability unlock timing comparison shows key differences
- [x] ✅ Total abilities table shows Protection 17 vs. Arms/Fury 13
- [x] ✅ Talent choices table shows 19 total choices L1-L10
- [x] ✅ Design philosophy callouts explain timing differences

### Next Steps
1. ✅ User review complete
2. ⏸️ **PENDING**: User approval to proceed
3. ⏸️ Copy to SOURCE_OF_TRUTH.md as Section [3.3]
4. ⏸️ Update change log
5. ⏸️ Mark Section [3] complete (all 3 subsections finished)
6. ⏸️ Move to resource audit work (200+ abilities)

---

**Status**: ✅ **READY FOR FINAL APPROVAL**
