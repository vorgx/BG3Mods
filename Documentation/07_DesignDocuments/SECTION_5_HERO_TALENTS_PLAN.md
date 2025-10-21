# Section 5: Hero Talents Implementation Plan (L13-L20)

**Created**: October 20, 2025  
**Purpose**: Complete implementation plan for hero talent specializations  
**Approach**: Zero SpellLists (PassivesAdded with UnlockSpell boosts)  
**Target**: 3 specializations × 11 talents = 33 hero talents

---

## 📋 Table of Contents

1. [Overview](#overview)
2. [Section 5.1: Mountain Thane](#section-51-mountain-thane)
3. [Section 5.2: Colossus](#section-52-colossus)
4. [Section 5.3: Slayer](#section-53-slayer)
5. [Section 5.4: Shared Implementation Patterns](#section-54-shared-implementation-patterns)
6. [Section 5.5: Testing & Validation](#section-55-testing--validation)

---

## Overview

### Hero Talent Structure (All 3 Specializations)

Each specialization follows the **same progression pattern**:

| Level | Grants | Player Choice | Description |
|-------|--------|---------------|-------------|
| **L13** | Keystone (1 talent) | Choose specialization | Mountain Thane / Colossus / Slayer |
| **L14** | Empty | None | No talents granted |
| **L15** | 3 Talents | Auto-grant (no choice) | First talent tier |
| **L16** | Empty | Feat/ASI only | No talents granted |
| **L17** | 3 Talents | Auto-grant (no choice) | Second talent tier |
| **L18** | Empty | None | No talents granted |
| **L19** | 3 Talents | Auto-grant (no choice) | Third talent tier |
| **L20** | Capstone (1 talent) | Auto-grant + Feat/ASI | Ultimate power |

**Total per specialization**: 11 talents (keystone + 9 talents + capstone), all auto-granted

---

## Implementation Strategy (Zero SpellLists)

### Core Pattern: PassivesAdded with UnlockSpell

All hero talents use **unlock passives** to grant abilities:

```xml
<!-- Example: Mountain Thane L13 Keystone -->
<node id="Progression">
    <attribute id="Level" type="uint8" value="13"/>
    <attribute id="Name" type="LSString" value="MountainThane"/>
    <attribute id="PassivesAdded" type="LSString" value="WAR_MountainThane_Keystone"/>
    <attribute id="TableUUID" type="guid" value="[MOUNTAIN_THANE_PROGRESSION_UUID]"/>
</node>
```

```
new entry "WAR_MountainThane_Keystone"
type "PassiveData"
data "DisplayName" "hXXXXXX01;1"
data "Description" "hXXXXXX02;1"
data "Icon" "PassiveFeature_MountainThane"
data "Properties" "IsHidden"
data "Boosts" "UnlockSpell(WAR_LightningStrikes)"
```

### Why Zero SpellLists for Hero Talents?

✅ **Advantages**:
1. Hero talents are **all auto-granted** (no choices) - perfect for PassivesAdded
2. Many talents are **upgrades to existing abilities** (use conditions in passives)
3. Keystones often have **special mechanics** (resource systems, status effects)
4. Simple to implement: 33 passives + 33 progression nodes = done!

❌ **No need for SpellLists because**:
1. No organizational benefit (already grouped by specialization in Progressions.lsx)
2. Only 11 talents per spec (small enough to track)
3. All auto-grants (no complex choice trees)

---

## Section 5.1: Mountain Thane

### Overview
**Available To**: Fury + Protection  
**Theme**: Lightning-infused attacks, Thunder Clap synergy  
**Total Talents**: 11 (keystone + 9 + capstone)

### 5.1.1: L13 Keystone - Lightning Strikes

**Design**:
- **Lightning Strikes is a PASSIVE talent** (not a new spell/ability)
- Likely modifies Thunder Clap or provides lightning damage mechanics
- Excel shows only name, no description

**Files Needed**:
1. `Passive.txt`: `WAR_MountainThane_Keystone` (unlock passive named "Lightning Strikes")
2. `Passive.txt`: `WAR_LIGHTNING_STRIKES` (status effect tracking, if needed)
3. `Status_BOOST.txt`: `WAR_LIGHTNING_STRIKES` (buff showing stacks, if applicable)
4. `Progressions.lsx`: L13 node with `PassivesAdded="WAR_MountainThane_Keystone"`

**Implementation Template**:

```
new entry "WAR_MountainThane_Keystone"
type "PassiveData"
data "DisplayName" "h125abc10;1"  # "Lightning Strikes"
data "Description" "h125abc11;1"  # TBD - Excel shows only name, no description
data "Icon" "PassiveFeature_LightningStrikes"
data "Properties" "IsHidden"
data "Boosts" "TBD"  # May modify Thunder Clap, add lightning damage, or other mechanics
data "StatsFunctorContext" "OnCast"
data "Conditions" "HasStringInSpellRoll('Zone(WAR_ThunderClap)')"
data "StatsFunctors" "ApplyStatus(SELF,WAR_LIGHTNING_STRIKES,100,10)"
```

**NOTE**: Excel CSV shows "Lightning Strikes" as L13 talent name only. Need to research WoW source material to determine exact mechanics.

**Progression Node**:
```xml
<node id="Progression">
    <attribute id="Level" type="uint8" value="13"/>
    <attribute id="Name" type="LSString" value="MountainThane"/>
    <attribute id="PassivesAdded" type="LSString" value="WAR_MountainThane_Keystone"/>
    <attribute id="TableUUID" type="guid" value="[MOUNTAIN_THANE_UUID]"/>
    <attribute id="UUID" type="guid" value="[GENERATE_NEW]"/>
</node>
```

**Testing Checklist**:
- [ ] Thunder Clap cast applies WAR_LIGHTNING_STRIKES status
- [ ] Status shows stack count in character sheet
- [ ] Status lasts 10 turns
- [ ] Icon displays correctly

---

### 5.1.2: L15 Talent Tier 1 (3 Talents)

**Talents**: Crashing Thunder + Ground Current + Strength of the Mountain

**Implementation**:

```xml
<node id="Progression">
    <attribute id="Level" type="uint8" value="15"/>
    <attribute id="Name" type="LSString" value="MountainThane"/>
    <attribute id="PassivesAdded" type="LSString" value="WAR_MountainThane_CrashingThunder;WAR_MountainThane_GroundCurrent;WAR_MountainThane_StrengthOfMountain"/>
    <attribute id="TableUUID" type="guid" value="[MOUNTAIN_THANE_UUID]"/>
    <attribute id="UUID" type="guid" value="[GENERATE_NEW]"/>
</node>
```

**Passive Examples**:

```
new entry "WAR_MountainThane_CrashingThunder"
type "PassiveData"
data "DisplayName" "h125abc20;1"
data "Description" "h125abc21;1"
data "Icon" "PassiveFeature_CrashingThunder"
data "Properties" "IsHidden"
data "Boosts" "IF(HasStatus('WAR_LIGHTNING_STRIKES',context.Source)):ActionResource(Rage,10,0)"
data "StatsFunctorContext" "OnCast"
data "Conditions" "HasStringInSpellRoll('Zone(WAR_ThunderClap)')"
data "StatsFunctors" "RemoveStatus(WAR_LIGHTNING_STRIKES,1)"

new entry "WAR_MountainThane_GroundCurrent"
type "PassiveData"
data "DisplayName" "h125abc22;1"
data "Description" "h125abc23;1"
data "Icon" "PassiveFeature_GroundCurrent"
data "Properties" "IsHidden"
data "Boosts" "IF(HasStatus('WAR_LIGHTNING_STRIKES',context.Source,5)):Advantage(AttackRoll)"

new entry "WAR_MountainThane_StrengthOfMountain"
type "PassiveData"
data "DisplayName" "h125abc24;1"
data "Description" "h125abc25;1"
data "Icon" "PassiveFeature_StrengthOfMountain"
data "Properties" "IsHidden"
data "Boosts" "StatusImmunity(PRONE);StatusImmunity(KNOCKED_DOWN)"
```

**Testing Checklist**:
- [ ] Crashing Thunder grants 10 Rage when casting Thunder Clap with Lightning Strikes
- [ ] Ground Current grants Advantage with 5+ stacks
- [ ] Strength of Mountain prevents Prone/Knocked Down

---

### 5.1.3: L17 Talent Tier 2 (3 Talents)

**Talents**: Thunder Blast + Storm Bolts + Keep Your Feet on the Ground

**Implementation**: Same pattern as L15 (see Section 5.4 for template)

---

### 5.1.4: L19 Talent Tier 3 (3 Talents)

**Talents**: Flashing Skies + Thorim's Might + Burst of Power

**Implementation**: Same pattern as L15 (see Section 5.4 for template)

---

### 5.1.5: L20 Capstone - Avatar of the Storm

**Design**:
- Ultimate ability or permanent buff
- Likely empowers Lightning Strikes mechanic

**Implementation**:

```xml
<node id="Progression">
    <attribute id="Level" type="uint8" value="20"/>
    <attribute id="Name" type="LSString" value="MountainThane"/>
    <attribute id="PassivesAdded" type="LSString" value="WAR_MountainThane_Capstone"/>
    <attribute id="TableUUID" type="guid" value="[MOUNTAIN_THANE_UUID]"/>
    <attribute id="UUID" type="guid" value="[GENERATE_NEW]"/>
</node>
```

```
new entry "WAR_MountainThane_Capstone"
type "PassiveData"
data "DisplayName" "h125abc90;1"  # "Avatar of the Storm"
data "Description" "h125abc91;1"
data "Icon" "PassiveFeature_AvatarOfStorm"
data "Properties" "IsHidden"
data "Boosts" "UnlockSpell(WAR_AvatarOfStorm);MaximizeHealing(Lightning)"
```

---

### 5.1.6: Mountain Thane Summary Table

| Level | Talents Granted | PassivesAdded String |
|-------|----------------|----------------------|
| **L13** | Lightning Strikes (keystone) | `WAR_MountainThane_Keystone` |
| **L14** | None | Empty |
| **L15** | Crashing Thunder + Ground Current + Strength of Mountain | `WAR_MountainThane_CrashingThunder;WAR_MountainThane_GroundCurrent;WAR_MountainThane_StrengthOfMountain` |
| **L16** | None | Empty |
| **L17** | Thunder Blast + Storm Bolts + Keep Your Feet on Ground | `WAR_MountainThane_ThunderBlast;WAR_MountainThane_StormBolts;WAR_MountainThane_KeepYourFeet` |
| **L18** | None | Empty |
| **L19** | Flashing Skies + Thorim's Might + Burst of Power | `WAR_MountainThane_FlashingSkies;WAR_MountainThane_ThorimsMight;WAR_MountainThane_BurstOfPower` |
| **L20** | Avatar of the Storm (capstone) | `WAR_MountainThane_Capstone` |

**Total Passives Required**: 11

---

## Section 5.2: Colossus

### Overview
**Available To**: Arms + Protection  
**Theme**: Shield Slam synergy, colossal might, defensive mastery  
**Total Talents**: 11 (keystone + 9 + capstone)

### 5.2.1: L13 Keystone - Demolish

**Design**:
- **Demolish is a PASSIVE talent** (not a new spell/ability)
- Likely modifies Shield Slam or provides a combat mechanic
- May generate Colossal Might stacks or provide other synergies

**Files Needed**:
1. `Passive.txt`: `WAR_Colossus_Keystone` (unlock passive named "Demolish")
2. `Status_BOOST.txt`: `WAR_COLOSSAL_MIGHT` (buff tracking, if needed)
3. `Progressions.lsx`: L13 node

**Implementation Template**:

```
new entry "WAR_Colossus_Keystone"
type "PassiveData"
data "DisplayName" "h125abc100;1"  # "Demolish"
data "Description" "h125abc101;1"  # TBD - Excel shows only name, no description
data "Icon" "PassiveFeature_Demolish"
data "Properties" "IsHidden"
data "Boosts" "TBD"  # May modify Shield Slam, grant damage bonus, or other mechanics
data "StatsFunctorContext" "OnCast"
data "Conditions" "HasStringInSpellRoll('Target(WAR_ShieldSlam)')"
data "StatsFunctors" "ApplyStatus(SELF,WAR_COLOSSAL_MIGHT,100,8)"
```

**NOTE**: Excel CSV shows "Demolish" as L13 talent name only (no description). Need to research WoW source material to determine exact mechanics.

**Progression Node**:
```xml
<node id="Progression">
    <attribute id="Level" type="uint8" value="13"/>
    <attribute id="Name" type="LSString" value="Colossus"/>
    <attribute id="PassivesAdded" type="LSString" value="WAR_Colossus_Keystone"/>
    <attribute id="TableUUID" type="guid" value="[COLOSSUS_UUID]"/>
    <attribute id="UUID" type="guid" value="[GENERATE_NEW]"/>
</node>
```

**Testing Checklist**:
- [ ] Demolish ability appears at L13
- [ ] Demolish costs 1 action + 30 Rage
- [ ] Shield Slam applies WAR_COLOSSAL_MIGHT status
- [ ] Status shows stack count

---

### 5.2.2: L15-L20 Implementation

**Same pattern as Mountain Thane** - see Section 5.4 for templates

**L15 Talents**: Martial Expert + Colossal Might + Earthquake  
**L17 Talents**: Arterial Blows + Tide of Battle + No Stranger to Pain  
**L19 Talents**: Practiced Strikes + Precise Might + Mountain of Muscle and Scars  
**L20 Capstone**: Dominance of the Colossus

---

### 5.2.3: Colossus Summary Table

| Level | Talents Granted | PassivesAdded String |
|-------|----------------|----------------------|
| **L13** | Demolish (keystone) | `WAR_Colossus_Keystone` |
| **L14** | None | Empty |
| **L15** | Martial Expert + Colossal Might + Earthquake | `WAR_Colossus_MartialExpert;WAR_Colossus_ColossalMight;WAR_Colossus_Earthquake` |
| **L16** | None | Empty |
| **L17** | Arterial Blows + Tide of Battle + No Stranger to Pain | `WAR_Colossus_ArterialBlows;WAR_Colossus_TideOfBattle;WAR_Colossus_NoStrangerToPain` |
| **L18** | None | Empty |
| **L19** | Practiced Strikes + Precise Might + Mountain of Muscle | `WAR_Colossus_PracticedStrikes;WAR_Colossus_PreciseMight;WAR_Colossus_MountainOfMuscle` |
| **L20** | Dominance of the Colossus (capstone) | `WAR_Colossus_Capstone` |

**Total Passives Required**: 11

---

## Section 5.3: Slayer

### Overview
**Available To**: Arms + Fury  
**Theme**: Execute synergy, critical strikes, relentless offense  
**Total Talents**: 11 (keystone + 9 + capstone)

### 5.3.1: L13 Keystone - Slayer's Dominance

**Design**:
- **Slayer's Dominance is a PASSIVE talent** (not a new spell/ability)
- Likely modifies Execute or provides offensive bonuses
- Excel shows only name, no description

**Files Needed**:
1. `Passive.txt`: `WAR_Slayer_Keystone` (unlock passive named "Slayer's Dominance")
2. `Status_BOOST.txt`: `WAR_SLAYERS_STRIKE` (buff tracking, if applicable)
3. `Progressions.lsx`: L13 node

**Implementation Template**:

```
new entry "WAR_Slayer_Keystone"
type "PassiveData"
data "DisplayName" "h125abc200;1"  # "Slayer's Dominance"
data "Description" "h125abc201;1"  # TBD - Excel shows only name, no description
data "Icon" "PassiveFeature_SlayersDominance"
data "Properties" "IsHidden"
data "Boosts" "TBD"  # May modify Execute, add critical strike bonuses, or other mechanics
data "StatsFunctorContext" "OnCast"
data "Conditions" "HasStringInSpellRoll('Target(WAR_Execute)') and IsDead(context.Target)"
data "StatsFunctors" "ApplyStatus(SELF,WAR_SLAYERS_STRIKE,100,6)"
```

**NOTE**: Excel CSV shows "Slayer's Dominance" as L13 talent name only. Need to research WoW source material to determine exact mechanics.

**Progression Node**:
```xml
<node id="Progression">
    <attribute id="Level" type="uint8" value="13"/>
    <attribute id="Name" type="LSString" value="Slayer"/>
    <attribute id="PassivesAdded" type="LSString" value="WAR_Slayer_Keystone"/>
    <attribute id="TableUUID" type="guid" value="[SLAYER_UUID]"/>
    <attribute id="UUID" type="guid" value="[GENERATE_NEW]"/>
</node>
```

---

### 5.3.2: L15-L20 Implementation

**Same pattern as Mountain Thane** - see Section 5.4 for templates

**L15 Talents**: Imminent Demise + Overwhelming Blades + Relentless Pursuit  
**L17 Talents**: Death Drive + Brutal Finish + Opportunist  
**L19 Talents**: Show No Mercy + Reap the Storm + Slayer's Malice  
**L20 Capstone**: Unrelenting Onslaught

---

### 5.3.3: Slayer Summary Table

| Level | Talents Granted | PassivesAdded String |
|-------|----------------|----------------------|
| **L13** | Slayer's Dominance (keystone) | `WAR_Slayer_Keystone` |
| **L14** | None | Empty |
| **L15** | Imminent Demise + Overwhelming Blades + Relentless Pursuit | `WAR_Slayer_ImminentDemise;WAR_Slayer_OverwhelmingBlades;WAR_Slayer_RelentlessPursuit` |
| **L16** | None | Empty |
| **L17** | Death Drive + Brutal Finish + Opportunist | `WAR_Slayer_DeathDrive;WAR_Slayer_BrutalFinish;WAR_Slayer_Opportunist` |
| **L18** | None | Empty |
| **L19** | Show No Mercy + Reap the Storm + Slayer's Malice | `WAR_Slayer_ShowNoMercy;WAR_Slayer_ReapTheStorm;WAR_Slayer_SlayersMalice` |
| **L20** | Unrelenting Onslaught (capstone) | `WAR_Slayer_Capstone` |

**Total Passives Required**: 11

---

## Section 5.4: Shared Implementation Patterns

### Template 1: Empty Level (L14, L16, L18)

```xml
<node id="Progression">
    <attribute id="Level" type="uint8" value="14"/>
    <attribute id="Name" type="LSString" value="MountainThane"/>
    <attribute id="Boosts" type="LSString" value=""/>
    <attribute id="PassivesAdded" type="LSString" value=""/>
    <attribute id="PassivesRemoved" type="LSString" value=""/>
    <attribute id="ProgressionType" type="uint8" value="1"/>
    <attribute id="TableUUID" type="guid" value="[MOUNTAIN_THANE_UUID]"/>
    <attribute id="UUID" type="guid" value="[GENERATE_NEW]"/>
</node>
```

---

### Template 2: 3-Talent Auto-Grant (L15, L17, L19)

```xml
<node id="Progression">
    <attribute id="Level" type="uint8" value="15"/>
    <attribute id="Name" type="LSString" value="MountainThane"/>
    <attribute id="Boosts" type="LSString" value=""/>
    <attribute id="PassivesAdded" type="LSString" value="WAR_MountainThane_Talent1;WAR_MountainThane_Talent2;WAR_MountainThane_Talent3"/>
    <attribute id="PassivesRemoved" type="LSString" value=""/>
    <attribute id="ProgressionType" type="uint8" value="1"/>
    <attribute id="TableUUID" type="guid" value="[MOUNTAIN_THANE_UUID]"/>
    <attribute id="UUID" type="guid" value="[GENERATE_NEW]"/>
</node>
```

---

### Template 3: Passive with Ability Unlock

```
new entry "WAR_SpecName_TalentName"
type "PassiveData"
data "DisplayName" "hXXXXXX01;1"
data "Description" "hXXXXXX02;1"
data "Icon" "PassiveFeature_TalentIcon"
data "Properties" "IsHidden"
data "Boosts" "UnlockSpell(WAR_NewAbility)"
```

---

### Template 4: Passive with Conditional Boost

```
new entry "WAR_SpecName_TalentName"
type "PassiveData"
data "DisplayName" "hXXXXXX01;1"
data "Description" "hXXXXXX02;1"
data "Icon" "PassiveFeature_TalentIcon"
data "Properties" "IsHidden"
data "Boosts" "IF(HasStatus('WAR_KEYSTONE_STATUS',context.Source)):Damage(1d6,Fire,Magical)"
data "StatsFunctorContext" "OnCast"
data "Conditions" "HasStringInSpellRoll('Target(WAR_Execute)')"
data "StatsFunctors" "ApplyStatus(context.Target,BURNING,100,2)"
```

---

### Template 5: Passive with Status Immunity

```
new entry "WAR_SpecName_TalentName"
type "PassiveData"
data "DisplayName" "hXXXXXX01;1"
data "Description" "hXXXXXX02;1"
data "Icon" "PassiveFeature_TalentIcon"
data "Properties" "IsHidden"
data "Boosts" "StatusImmunity(FRIGHTENED);StatusImmunity(CHARMED)"
```

---

## Section 5.5: Testing & Validation

### Test Plan: Hero Talent Progression

#### Test 1: Specialization Selection at L13
1. Create new Warrior character
2. Level to 13 via console: `oe levelup` (12 times)
3. Open character sheet
4. Verify specialization choice appears (Mountain Thane / Colossus / Slayer)
5. Select specialization
6. Verify keystone passive/ability granted

**Expected Results**:
- [ ] 3 specialization options appear
- [ ] Keystone grants immediately after selection
- [ ] No crash or errors

---

#### Test 2: Auto-Grant Progression (L15)
1. Continue from Test 1 (L13 character with specialization)
2. Level to 15: `oe levelup` (2 times)
3. Open character sheet
4. Verify 3 talents granted automatically (no choice)
5. Check passive list for all 3 talents

**Expected Results**:
- [ ] 3 talents appear in passive list
- [ ] No choice prompt (auto-granted)
- [ ] Talents function correctly

---

#### Test 3: Empty Level Validation (L14, L16, L18)
1. Check character sheet at L14, L16, L18
2. Verify no new talents appear
3. Verify no crash or errors

**Expected Results**:
- [ ] No talents granted at empty levels
- [ ] No UI prompts or errors
- [ ] Progression continues smoothly

---

#### Test 4: Capstone at L20
1. Level character to 20
2. Verify capstone granted automatically
3. Test capstone ability/passive functionality

**Expected Results**:
- [ ] Capstone grants at L20
- [ ] Capstone works as designed
- [ ] No crash or errors

---

### Validation Checklist: All 33 Hero Talents

**Mountain Thane** (11 talents):
- [ ] L13: Lightning Strikes (keystone)
- [ ] L15: Crashing Thunder
- [ ] L15: Ground Current
- [ ] L15: Strength of the Mountain
- [ ] L17: Thunder Blast
- [ ] L17: Storm Bolts
- [ ] L17: Keep Your Feet on the Ground
- [ ] L19: Flashing Skies
- [ ] L19: Thorim's Might
- [ ] L19: Burst of Power
- [ ] L20: Avatar of the Storm (capstone)

**Colossus** (11 talents):
- [ ] L13: Demolish (keystone)
- [ ] L15: Martial Expert
- [ ] L15: Colossal Might
- [ ] L15: Earthquake
- [ ] L17: Arterial Blows
- [ ] L17: Tide of Battle
- [ ] L17: No Stranger to Pain
- [ ] L19: Practiced Strikes
- [ ] L19: Precise Might
- [ ] L19: Mountain of Muscle and Scars
- [ ] L20: Dominance of the Colossus (capstone)

**Slayer** (11 talents):
- [ ] L13: Slayer's Dominance (keystone)
- [ ] L15: Imminent Demise
- [ ] L15: Overwhelming Blades
- [ ] L15: Relentless Pursuit
- [ ] L17: Death Drive
- [ ] L17: Brutal Finish
- [ ] L17: Opportunist
- [ ] L19: Show No Mercy
- [ ] L19: Reap the Storm
- [ ] L19: Slayer's Malice
- [ ] L20: Unrelenting Onslaught (capstone)

---

## File Organization Summary

### Files to Create/Modify

**Progressions.lsx** (3 new progression tables):
- Mountain Thane: 8 levels (L13-L20) × 1 table = 8 nodes
- Colossus: 8 levels (L13-L20) × 1 table = 8 nodes
- Slayer: 8 levels (L13-L20) × 1 table = 8 nodes
- **Total**: 24 progression nodes

**ClassDescriptions.lsx** (3 new ClassDescription nodes):
- Mountain Thane: ParentGuid references Fury or Protection
- Colossus: ParentGuid references Arms or Protection
- Slayer: ParentGuid references Arms or Fury
- **Total**: 3 ClassDescription nodes

**Passive.txt** (33 new unlock passives):
- Mountain Thane: 11 passives
- Colossus: 11 passives
- Slayer: 11 passives
- **Total**: 33 passive entries

**Spell_*.txt** (new abilities from talents, IF ANY):
- TBD - Excel shows only passive names, no ability descriptions
- May not need any new spell entries if all talents are passive modifiers
- **Estimated**: 0-3 new spell entries (pending WoW research)

**Status_BOOST.txt** (new status effects, IF NEEDED):
- WAR_LIGHTNING_STRIKES (Mountain Thane)
- WAR_COLOSSAL_MIGHT (Colossus)
- WAR_SLAYERS_STRIKE (Slayer)
- **Total**: 3-5 new status entries

**Localization** (English.loca.xml):
- 33 talents × 2 handles (name + description) = 66 handles
- 3-5 new abilities × 2 handles = 6-10 handles
- **Total**: ~70-80 new localization handles

---

## Implementation Timeline

### Phase 1: Structure Setup (2-3 hours)
1. Create 3 ClassDescription nodes in ClassDescriptions.lsx
2. Create 3 progression tables in Progressions.lsx (8 nodes each = 24 nodes)
3. Add empty PassivesAdded strings for all 24 nodes
4. Test: Verify specialization choice appears at L13

---

### Phase 2: Keystones (3-4 hours)
1. Research WoW hero talent mechanics for all 3 keystones
2. Implement Mountain Thane keystone (Lightning Strikes passive)
3. Implement Colossus keystone (Demolish passive)
4. Implement Slayer keystone (Slayer's Dominance passive)
5. Test: Verify keystones grant at L13 and function correctly

**NOTE**: All 3 keystones are **PASSIVE talents** (not new spells/abilities). Excel CSV shows names only, no descriptions. Must research WoW source material for exact mechanics.

---

### Phase 3: L15 Talents (4-6 hours)
1. Create 9 passives (3 per spec)
2. Add to Progressions.lsx L15 nodes
3. Test: Verify all 9 talents grant automatically at L15

---

### Phase 4: L17 Talents (4-6 hours)
1. Create 9 passives (3 per spec)
2. Add to Progressions.lsx L17 nodes
3. Test: Verify all 9 talents grant automatically at L17

---

### Phase 5: L19 Talents (4-6 hours)
1. Create 9 passives (3 per spec)
2. Add to Progressions.lsx L19 nodes
3. Test: Verify all 9 talents grant automatically at L19

---

### Phase 6: Capstones (2-3 hours)
1. Create 3 capstone passives
2. Add to Progressions.lsx L20 nodes
3. Test: Verify capstones grant at L20

---

### Phase 7: Localization (2-3 hours)
1. Generate 70-80 localization handles
2. Add to English.loca.xml
3. Test: Verify all text displays correctly in-game

---

### Phase 8: Full Playthrough Testing (4-6 hours)
1. Test all 3 specializations L13-L20
2. Verify each talent functions correctly
3. Check for duplicate grants or missing talents
4. Validate no crashes or errors

---

**Total Estimated Time**: 25-35 hours

---

## Success Criteria

✅ **Section 5 Complete When**:
1. All 3 ClassDescription nodes created (Mountain Thane, Colossus, Slayer)
2. All 24 progression nodes created (8 per spec × 3 specs)
3. All 33 unlock passives created (11 per spec × 3 specs)
4. All keystones functional (L13)
5. All L15/L17/L19 talents auto-grant correctly
6. All capstones functional (L20)
7. All 70-80 localization handles added
8. Full playthrough test passes for all 3 specializations
9. No crashes, duplicate grants, or missing talents
10. Documentation updated (this plan + implementation notes)

---

## Next Steps After Section 5

1. **Section 6**: Class Talent Tree (Rows 1-10, shared by all Warriors)
2. **Section 7**: SubclassSpec Talent Trees (Arms/Fury/Protection Rows 1-10)
3. **Section 8**: Final Integration & Testing
4. **Section 9**: Packaging & Release

---

**Last Updated**: October 20, 2025  
**Status**: Ready to begin implementation  
**Approach Confirmed**: Zero SpellLists (PassivesAdded with UnlockSpell boosts)  
**Related Documents**:
- `SPELLLIST_APPROACHES_MASTER_GUIDE.md` - Reference for future migrations
- `EXCEL_WARRIOR_PROGRESSION_ANALYSIS.md` - Source data for hero talents
- `WARRIOR_COMPLETE_STRUCTURE_L1-L20.md` - Overall mod structure
