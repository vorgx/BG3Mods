# Section [3.3] Level-by-Level Base Class Features - DRAFT

**Status**: Draft - Awaiting User Review  
**Created**: October 19, 2025  
**Source**: EXCEL_WARRIOR_PROGRESSION_ANALYSIS.md (lines 135-280)  
**Scope**: Levels 1-10 (Base class + subclass-specific grants)

---

## DRAFT CONTENT

### Level-by-Level Base Class Features (L1-L10)

**Last Updated**: October 19, 2025  
**Status**: ✅ Complete

**Source**: Excel `Warrior Progression for all subclasses.xlsx` columns 4-29 + EXCEL_WARRIOR_PROGRESSION_ANALYSIS.md

---

#### Overview

This subsection documents what abilities Warriors receive at each level from 1-10, showing how the three subclasses (Arms, Fury, Protection) receive **the same baseline abilities in different orders** to create distinct playstyles. Each level shows:

- **BG3 Milestones**: Standard game features (Extra Attack, Feats, etc.)
- **Baseline Abilities Granted**: Auto-granted abilities per subclass
- **Total Features**: Count of new abilities/passives/resources

**Critical Design Note**: Levels 4, 8, and 12 are **Feat/ASI levels** (no baseline abilities granted). Levels 2, 6, and 10 are **talent choice levels** (no baseline abilities, but talent choices available).

---

#### Level 1 - Character Creation (Starting Loadout)

**BG3 Milestones**: Starting level, subclass selection

**Universal Grants** (All Warriors):
- ✅ **Rage Resource** (0-100 max, combat-only, decays -5 per turn out of combat)
- ✅ **Proficiencies**: 
  - Saves: STR, CON
  - Armor: Light, Medium, Heavy
  - Shields: Yes
  - Weapons: Simple, Martial
- ✅ **Passives**: `WAR_UnlockRage`, `WAR_RageGeneration`

**Subclass-Specific Grants**:

| Subclass | Baseline Abilities | Baseline Passives | Class Talents (Row 1) | Total Features |
|----------|-------------------|-------------------|----------------------|----------------|
| **Arms** | Whirlwind + Charge | — | Battle Stance + Defensive Stance (Stances) | **4** (2 abilities + 2 stances) |
| **Protection** | Shield Slam + Taunt | Mastery: Critical Block | Battle Stance + Defensive Stance (Stances) | **5** (2 abilities + 1 passive + 2 stances) |
| **Fury** | Whirlwind + Berserker Rage + Battle Stance + Defensive Stance | — | — (stances in baseline) | **4** (2 abilities + 2 stances) |

**Detailed Ability Breakdown**:

**Arms Warrior (L1)**:
- 🗡️ **Whirlwind** (Offensive) - AoE cleave attack
- 🛡️ **Charge** (Utility) - Gap closer, generates Rage
- 💪 **Battle Stance** (Stance - Class Talent Row 1)
- 💪 **Defensive Stance** (Stance - Class Talent Row 1)

**Protection Warrior (L1)** - **TANK-READY FROM START!**:
- 🗡️ **Shield Slam** (Offensive) - Damage + threat generation
- 🛡️ **Taunt** (Utility) - Threat control
- 💪 **Mastery: Critical Block** (Passive) - Damage mitigation on critical blocks
- 💪 **Battle Stance** (Stance - Class Talent Row 1)
- 💪 **Defensive Stance** (Stance - Class Talent Row 1)

**Fury Warrior (L1)** - **ENRAGE IDENTITY FROM START!**:
- 🗡️ **Whirlwind** (Offensive) - Dual-wield AoE cleave
- 🛡️ **Berserker Rage** (Utility) - Enrage mechanic, CC removal, Rage generation
- 💪 **Battle Stance** (Stance - Baseline Ability)
- 💪 **Defensive Stance** (Stance - Baseline Ability)

**Design Philosophy**:
- **Arms**: Mobility + AoE damage from start (Charge + Whirlwind) + stances from Class Talents Row 1
- **Protection**: Full tank kit from level 1 (threat + mitigation + stances from Class Talents Row 1)
- **Fury**: Enrage mechanic defines identity immediately (Berserker Rage at L1 vs. L7 for others) + stances in baseline abilities

**Critical Difference**: 
- **Arms/Protection**: Get stances from **Class Talents Row 1** (Battle Stance + Defensive Stance, auto-granted)
- **Fury**: Gets stances as **Baseline Abilities** (Battle Stance + Defensive Stance, part of subclass identity)

**⚠️ Important Note**: Class Talents Row 1 is **AUTO-GRANTED** at character creation (not a player choice). The stances (Battle Stance + Defensive Stance) are given automatically for **Arms/Protection/Fury** - Arms/Protection receive them from Class Talents Row 1, while Fury receives them as Baseline Abilities. **First player choice is Class Talents Row 2 at Level 2.**

**Total Starting Features** (including proficiencies + Rage + abilities):
- Arms: **13** (9 proficiencies + Rage + 2 abilities + 2 stances)
- Protection: **14** (9 proficiencies + Rage + 2 abilities + 1 passive + 2 stances)
- Fury: **13** (9 proficiencies + Rage + 2 abilities + 2 stances)

---

#### Level 2 - Talent Choice Level

**BG3 Milestones**: None

**Baseline Abilities Granted**: None

**Talent Choices Available**: Class Talent Row 2 (4 options)

**Design Note**: This is the **FIRST PLAYER CHOICE** - no auto-granted abilities, but players pick 1 talent from Row 2 (Fast Footwork | War Machine | Leeching Strikes | Intervene). Class Talents Row 1 was already auto-granted at L1 (stances for Arms/Protection, or part of Fury's baseline abilities).

---

#### Level 3 - Subclass Specialization Begins

**BG3 Milestones**: Subclass features begin to diverge

**Baseline Abilities Granted**:

| Subclass | Abilities Granted | Total Features |
|----------|-------------------|----------------|
| **Arms** | Execute + Pummel | **2** (2 abilities) |
| **Protection** | Devastate + Shield Block + Riposte | **3** (2 abilities + 1 passive) |
| **Fury** | Slam + Charge | **2** (2 abilities) |

**Detailed Ability Breakdown**:

**Arms Warrior (L3)**:
- 🗡️ **Execute** (Offensive) - **ARMS SPECIALTY!** Big finisher on low-HP targets (<20% HP), 4d12 damage
- 🛡️ **Pummel** (Utility) - Interrupt enemy casts

**Protection Warrior (L3)**:
- 🗡️ **Devastate** (Offensive) - Armor reduction attack
- 🛡️ **Shield Block** (Defensive) - Active damage mitigation (1 charge)
- 💪 **Riposte** (Passive) - Counter-attack on successful block

**Fury Warrior (L3)**:
- 🗡️ **Slam** (Offensive) - Rage spender, moderate damage
- 🛡️ **Charge** (Utility) - Gap closer (same as Arms L1)

**Design Philosophy**:
- **Arms**: Gets **Execute at L3** (vs. L7/L9 for other specs) to define "execute specialist" identity
- **Protection**: Gets full defensive toolkit (Shield Block + Riposte) to enable tank gameplay
- **Fury**: Gets mobility (Charge) 2 levels later than Arms, prioritizes damage (Slam) first

**Talent Choices Available**: Class Talent Row 3 + SubclassSpec Talent Row 1 (2 choices total)

---

#### Level 4 - Feat/ASI Level

**BG3 Milestones**: Feat or Ability Score Improvement

**Baseline Abilities Granted**: None

**Talent Choices Available**: Class Talent Row 4 + SubclassSpec Talent Row 2 (2 choices total)

**Design Note**: Standard D&D 5e progression - no abilities granted, focus on character customization via Feat/ASI.

---

#### Level 5 - Extra Attack (Power Spike)

**BG3 Milestones**: **Extra Attack** (attack twice per Attack action) - **MAJOR POWER SPIKE!**

**Universal Grants** (All Warriors):
- ✅ **Passive**: `ExtraAttack` (2 attacks per Attack action)

**Subclass-Specific Grants**:

| Subclass | Abilities Granted | Total Features |
|----------|-------------------|----------------|
| **Arms** | Hamstring + Battle Shout | **3** (1 passive + 2 abilities) |
| **Protection** | Heroic Throw + Charge + Shield Block 2nd charge | **4** (3 abilities + 1 resource upgrade) |
| **Fury** | Victory Rush + Pummel | **3** (1 passive + 2 abilities) |

**Detailed Ability Breakdown**:

**Arms Warrior (L5)**:
- 💪 **ExtraAttack** (Passive) - 2 attacks per Attack action
- 🛡️ **Hamstring** (Utility) - Movement speed reduction
- 🛡️ **Battle Shout** (Utility) - AoE buff (+2 attack rolls)

**Protection Warrior (L5)** - **MOST FEATURES AT L5!**:
- 💪 **ExtraAttack** (Passive) - 2 attacks per Attack action
- 🛡️ **Heroic Throw** (Utility) - Ranged attack (30m range)
- 🛡️ **Charge** (Utility) - Gap closer (same as Arms L1, Fury L3)
- 💪 **Shield Block (2nd charge)** - **RESOURCE UPGRADE**: Shield Block max charges 1 → 2

**Fury Warrior (L5)**:
- 💪 **ExtraAttack** (Passive) - 2 attacks per Attack action
- 🛡️ **Victory Rush** (Utility) - Self-heal after killing blow
- 🛡️ **Pummel** (Utility) - Interrupt enemy casts (same as Arms L3)

**Design Philosophy**:
- **Extra Attack** is the defining martial power spike (doubles damage output)
- **Protection** gets **4 features** (most of any spec) because tanks need utility (ranged pull, mobility, more Shield Block charges)
- **Arms** gets utility (Hamstring + Battle Shout) to support group
- **Fury** gets sustain (Victory Rush) to support glass cannon playstyle

**Talent Choices Available**: Class Talent Row 5 + SubclassSpec Talent Row 3 (2 choices total)

---

#### Level 6 - Talent Choice Level

**BG3 Milestones**: None

**Baseline Abilities Granted**: None

**Talent Choices Available**: Class Talent Row 6 + SubclassSpec Talent Row 4 (2 choices total)

**Design Note**: Similar to L2, this is a **talent-only level** - no auto-granted abilities, but players make 2 talent choices.

---

#### Level 7 - Ability Grants Resume

**BG3 Milestones**: None

**Baseline Abilities Granted**:

| Subclass | Abilities Granted | Total Features |
|----------|-------------------|----------------|
| **Arms** | Slam + Berserker Rage | **2** (2 abilities) |
| **Protection** | Slam + Pummel + Vanguard | **3** (2 abilities + 1 passive) |
| **Fury** | Execute + Battle Shout | **2** (2 abilities) |

**Detailed Ability Breakdown**:

**Arms Warrior (L7)**:
- 🗡️ **Slam** (Offensive) - Rage spender (same as Fury L3, Protection L7)
- 🛡️ **Berserker Rage** (Utility) - Enrage mechanic, CC removal (same as Fury L1)

**Protection Warrior (L7)**:
- 🗡️ **Slam** (Offensive) - Rage spender (same as Fury L3, Arms L7)
- 🛡️ **Pummel** (Utility) - Interrupt (same as Arms L3, Fury L5)
- 💪 **Vanguard** (Passive) - Tank-specific passive (details TBD)

**Fury Warrior (L7)**:
- 🗡️ **Execute** (Offensive) - Big finisher (same as Arms L3, Protection L9)
- 🛡️ **Battle Shout** (Utility) - AoE buff (same as Arms L5, Protection L11)

**Design Philosophy**:
- **Arms** finally gets Berserker Rage at L7 (Fury had it at L1) - utility catch-up
- **Protection** gets Vanguard passive to enhance tank role
- **Fury** gets Execute at L7 (Arms had it at L3) - damage specialist catch-up

**Talent Choices Available**: Class Talent Row 7 (9 options - **LARGEST CHOICE POOL!**) + SubclassSpec Talent Row 5 (2 choices total)

---

#### Level 8 - Feat/ASI Level

**BG3 Milestones**: Feat or Ability Score Improvement

**Baseline Abilities Granted**: None

**Talent Choices Available**: Class Talent Row 8 + SubclassSpec Talent Row 6 (2 choices total)

**Design Note**: Second Feat/ASI level - no abilities granted, focus on character customization.

---

#### Level 9 - Ability Grants Resume

**BG3 Milestones**: None

**Baseline Abilities Granted**:

| Subclass | Abilities Granted | Total Features |
|----------|-------------------|----------------|
| **Arms** | Victory Rush + Taunt | **2** (2 abilities) |
| **Protection** | Execute + Victory Rush | **2** (2 abilities) |
| **Fury** | Hamstring + Taunt | **2** (2 abilities) |

**Detailed Ability Breakdown**:

**Arms Warrior (L9)**:
- 🛡️ **Victory Rush** (Utility) - Self-heal (same as Fury L5, Protection L9)
- 🛡️ **Taunt** (Utility) - Threat control (same as Protection L1, Fury L9)

**Protection Warrior (L9)**:
- 🗡️ **Execute** (Offensive) - Big finisher (same as Arms L3, Fury L7)
- 🛡️ **Victory Rush** (Utility) - Self-heal (same as Fury L5, Arms L9)

**Fury Warrior (L9)**:
- 🛡️ **Hamstring** (Utility) - Movement reduction (same as Arms L5, Protection L12)
- 🛡️ **Taunt** (Utility) - Threat control (same as Protection L1, Arms L9)

**Design Philosophy**:
- **All specs converging** on core utility toolkit by L9
- **Arms & Fury** finally get Taunt (Protection had it at L1) - 8 level gap for non-tanks
- **Protection** finally gets Execute (Arms L3, Fury L7) - 6 level gap for tank vs. DPS specs

**Talent Choices Available**: Class Talent Row 9 (3 options - Thunderous Roar | Avatar | Champion's Spear) + SubclassSpec Talent Row 7 (2 choices total)

---

#### Level 10 - Talent Choice Level

**BG3 Milestones**: None

**Baseline Abilities Granted**: None

**Talent Choices Available**: Class Talent Row 10 (6 options - **FINAL Class Talent choice**) + SubclassSpec Talent Row 8 (2 choices total)

**Design Note**: Last level before L11-20 progression (hero talents, higher-level abilities). This is the **final Class Talent choice** - Row 10 is the last available.

---

## Summary Tables

### Total Baseline Abilities by Level (L1-L10)

| Level | Arms | Protection | Fury | Notes |
|-------|------|-----------|------|-------|
| **L1** | 4 | **5** ⭐ | 4 | Protection gets extra passive for tank role |
| **L2** | 0 | 0 | 0 | Talent-only level |
| **L3** | 2 | **3** ⭐ | 2 | Protection gets Shield Block + Riposte combo |
| **L4** | 0 | 0 | 0 | Feat/ASI level |
| **L5** | 3 | **4** ⭐ | 3 | Protection gets extra feature (Charge + Shield Block 2nd charge) |
| **L6** | 0 | 0 | 0 | Talent-only level |
| **L7** | 2 | **3** ⭐ | 2 | Protection gets Vanguard passive |
| **L8** | 0 | 0 | 0 | Feat/ASI level |
| **L9** | 2 | 2 | 2 | All specs equal |
| **L10** | 0 | 0 | 0 | Talent-only level |
| **TOTAL** | **13** | **17** ⭐ | **13** | Protection gets 4 more features (tank support) |

**Key Insight**: Protection gets **4 extra features** (L1, L3, L5, L7) to enable tank role from start and maintain utility throughout levels 1-10.

---

### Ability Unlock Timing Comparison (Key Abilities)

| Ability | Arms | Protection | Fury | Design Intent |
|---------|------|-----------|------|---------------|
| **Shield Slam** | L12 | **L1** ✨ | L12 | Protection needs offensive threat tool from start |
| **Taunt** | L9 | **L1** ✨ | L9 | Protection needs threat control from start |
| **Execute** | **L3** ✨ | L9 | L7 | Arms specialty finisher early (6 level gap vs. Protection) |
| **Berserker Rage** | L7 | L12 | **L1** ✨ | Fury enrage identity from start (6 level gap vs. Arms) |
| **Charge** | **L1** ✨ | L5 | L3 | Arms gets mobility first, Fury 2nd, Protection last |
| **Whirlwind** | **L1** ✨ | L12 | **L1** ✨ | DPS specs get AoE early, tanks get it 11 levels later |
| **Pummel** | **L3** ✨ | L7 | L5 | Arms gets interrupt earliest (4 level gap vs. Protection) |
| **Battle Shout** | **L5** ✨ | L11 | L7 | Arms gets group buff earliest (6 level gap vs. Protection) |
| **Victory Rush** | L9 | L9 | **L5** ✨ | Fury gets sustain earliest (4 level gap) - glass cannon needs healing |
| **Shield Block** | — | **L3** ✨ | — | Protection exclusive (tank mechanic) |
| **Shield Block 2nd charge** | — | **L5** ✨ | — | Protection exclusive (resource upgrade) |

**Design Philosophy**:
1. **Protection = Tank-Ready L1**: Shield Slam + Taunt + Mastery enables tanking immediately
2. **Arms = Execute Specialist**: Gets Execute at L3 (6 levels before Protection, 4 before Fury)
3. **Fury = Enrage Identity**: Gets Berserker Rage at L1 (6 levels before Arms)
4. **Different Order = Different Feel**: All specs get most abilities, but timing creates unique gameplay pacing

---

### Talent Choices by Level (L1-L10)

| Level | Class Talents | SubclassSpec Talents | Feat/ASI | Total Choices |
|-------|--------------|---------------------|----------|---------------|
| **L1** | Auto-grant (Row 1) | Auto-grant | — | 0 (all auto-granted) |
| **L2** | Row 2 (4 options) | — | — | **1** |
| **L3** | Row 3 | Row 1 | — | **2** |
| **L4** | Row 4 | Row 2 | ✅ | **3** |
| **L5** | Row 5 | Row 3 | — | **2** |
| **L6** | Row 6 | Row 4 | — | **2** |
| **L7** | Row 7 (9 options ⭐) | Row 5 | — | **2** |
| **L8** | Row 8 | Row 6 | ✅ | **3** |
| **L9** | Row 9 (3 options) | Row 7 | — | **2** |
| **L10** | Row 10 (FINAL) | Row 8 | — | **2** |
| **TOTAL** | **10 rows** | **8 rows** | **2** | **19 choices** |

**⚠️ Important Note**: **Class Talents** and **SubclassSpec Talents** are TWO SEPARATE SYSTEMS with their own Row numbering:

- **Class Talents (Rows 1-10)**: Shared by ALL Warriors (Arms, Fury, Protection)
  - Row 1: Auto-granted stances (Battle + Defensive) for Arms/Protection at L1 *(Fury gets stances as Baseline Abilities instead)*
  - Rows 2-10: Player choices at L2-L10
  
- **SubclassSpec Talents (Rows 1-10)**: Unique per subclass (Arms has different choices than Fury/Protection)
  - Row 1 = First SubclassSpec choice at L3 *(NOT related to Class Talents Row 1)*
  - Rows 2-8 = SubclassSpec choices at L4-L10
  - Rows 9-10 = SubclassSpec choices at L11-L12 *(outside draft scope)*

**Why This Matters**: When you see "Row 1" at L3, this is **SubclassSpec Talent Row 1** (your first subclass-specific choice), NOT Class Talents Row 1 (which was already auto-granted at L1 for Arms/Protection, or given as Baseline Abilities for Fury).

**Key Insight**: Players make **19 total choices** in levels 1-10 (9 Class Talent choices + 8 SubclassSpec Talent choices + 2 Feats). This is EXCLUDING hero talent choices at L13-20.

---

## Cross-References

- **Section [3.2] Core Mechanics**: Rage system, combat mechanics, proficiency progression
- **Section [3.1] Base Class Definition**: Base class XML structure, attributes
- **Section [6] Progression**: Progressions.lsx implementation details (builds on this foundation)
- **Excel Source**: `Warrior Progression for all subclasses.xlsx` columns 4-29
- **Analysis Source**: EXCEL_WARRIOR_PROGRESSION_ANALYSIS.md (lines 135-280)
- **SpellLists Reference**: WARRIOR_SPELLLISTS_LEVELBYLEVL_BREAKDOWN.md (spell grants per level)

---

## Validation Checklist

- [x] ✅ All data sourced from Excel (columns 4-29, rows 4-13)
- [x] ✅ L1 shows subclass-specific starting loadouts (Arms 4, Protection 5, Fury 4 features)
- [x] ✅ L2/L6/L10 marked as talent-only levels (0 abilities)
- [x] ✅ L4/L8 marked as Feat/ASI levels (0 abilities)
- [x] ✅ L5 shows Extra Attack (universal martial power spike)
- [x] ✅ Protection shows 4 extra features across L1-L10 (tank support)
- [x] ✅ Ability unlock timing comparison included (Execute, Berserker Rage, Charge, etc.)
- [x] ✅ Total abilities table shows Protection 17 features vs. Arms/Fury 13
- [x] ✅ Talent choices table shows 19 total choices L1-L10
- [x] ✅ Design philosophy callouts explain timing differences
- [x] ✅ Cross-references to related sections included

---

## Next Steps

1. **User Review**: Review this draft for accuracy and completeness
2. **User Approval**: Confirm all data matches Excel and design intent
3. **Copy to SOURCE_OF_TRUTH.md**: Insert as Section [3.3] after Section [3.2]
4. **Update Change Log**: Document Section [3.3] addition
5. **Mark Section [3] Complete**: All 3 subsections finished ([3.1], [3.2], [3.3])
6. **Move to Next Section**: Proceed to Section [4] Subclasses or resource audit work

---

**Draft Status**: ✅ Ready for User Review
