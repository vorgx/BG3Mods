# Level 1 (Character Generation) - Comprehensive Progression Review

**Date**: October 21, 2025  
**Status**: ✅ VERIFIED AGAINST BOTH SOURCES OF TRUTH  
**Sources**:
- `Warrior Progression for all subclasses and Default hero structure.csv` (Row 1, Columns 4-12, K-L, 22-24, 35-38, 46)
- `AbilityDatabase_Warrior_FullyEnriched.csv` (12 L1 abilities verified)

---

## Overview

Level 1 represents **Character Generation** - the initial state when creating a Warrior character. This includes:
- **BG3 Standard Grants**: Extra Attack (No), Feat (No)
- **Baseline Abilities**: Auto-granted offensive/utility abilities (vary by subclass)
- **Stances**: Battle Stance + Defensive Stance (ALL subclasses)
- **Subclass-Specific Grants**: Passives + signature abilities (Arms/Fury/Protection)

**Critical Note**: Level 1 has **NO player choices** - everything is auto-granted based on subclass selection.

---

## 1. Arms Warrior (Level 1)

### 1.1 Auto-Granted Abilities (Baseline)

**From CSV Columns 4-5** (Offensive + Utility):

| Ability | Abbr | Type | Description | BG3 Implementation |
|---------|------|------|-------------|-------------------|
| **Whirlwind** | WW | Offensive (AoE) | Primary multitarget attack | `Spell_Zone.txt`<br>`DealDamage(1d8+StrengthModifier,Slashing);RestoreResource(context.Source,Rage,10,0)` |
| **Charge** | - | Utility (Mobility) | Primary mobility and gap closer | `Spell_Jump.txt`<br>`TeleportSource();RestoreResource(context.Source,Rage,20,0)`<br>Cooldown: Short Rest (2 charges) |

**From CSV Columns K-L** (Stances - ALL Warriors):

| Ability | Abbr | Type | Description | BG3 Implementation |
|---------|------|------|-------------|-------------------|
| **Battle Stance** | Battle/BStance | Stance (Offensive) | Basic offensive stance | `Spell_Shout.txt`<br>`ApplyStatus(SELF,WAR_BATTLE_STANCE,100,-1)`<br>Duration: -1 (until toggled) |
| **Defensive Stance** | Def/DStance | Stance (Defensive) | Basic defensive stance | `Spell_Shout.txt`<br>`ApplyStatus(SELF,WAR_DEFENSIVE_STANCE,100,-1)`<br>Duration: -1 (until toggled) |

### 1.2 Auto-Granted Passives

**From CSV Row 1 (Columns 22-24)** - Arms Spec Passives:

| Passive | Description | BG3 Implementation |
|---------|-------------|-------------------|
| **Seasoned Soldier** | Increases Arms rage generation from critical strikes | `Passive.txt`<br>Type: Passive<br>Tags: Stat-Boost, Critical |
| **Mastery: Deep Wounds** | Enables scaling damage from Mastery | `Passive.txt`<br>Type: Passive<br>Tags: Arms, Passive, Bleed |
| **Mortal Strike** | Primary attack forming the basis of the rotation | `Spell_Target.txt`<br>`DealDamage(2d6+StrengthModifier,Slashing);ApplyStatus(WAR_DEEP_WOUNDS,100,3)`<br>Rage Cost: 30 |

### 1.3 Progressions.lsx Structure (Arms L1)

```xml
<node id="Progression">
    <attribute id="Level" type="uint8" value="1"/>
    <attribute id="TableUUID" type="guid" value="ArmsWarriorProgressionTableUUID"/>
    <attribute id="UUID" type="guid" value="ArmsL1ProgressionUUID"/>
    <attribute id="Boosts" type="LSString" value="ActionResource(Rage,100,0);Proficiency(MartialWeapons);Proficiency(HeavyArmor);ProficiencyBonus(SavingThrow,Strength);ProficiencyBonus(SavingThrow,Constitution)"/>
    <attribute id="PassivesAdded" type="LSString" value="WAR_RageGeneration;WAR_Seasoned_Soldier;WAR_Mastery_DeepWounds"/>
    <attribute id="Selectors" type="LSString" value="SelectSkills(WarriorSkillsUUID,2);AddSpells(ArmsL1BaselineSpellListUUID)"/>
</node>
```

### 1.4 SpellLists & PassiveLists Required (Arms L1)

**SpellList: `ArmsL1BaselineSpellListUUID`**
Must contain:
- `WAR_Whirlwind` (Baseline col 4)
- `WAR_Charge` (Baseline col 5)
- `WAR_Mortal_Strike` (Row 1 passive/ability col 24)
- `WAR_Battle_Stance` (Col K - stance)
- `WAR_Defensive_Stance` (Col L - stance)

**PassiveList**: None required (all passives granted via `PassivesAdded`)

### 1.5 AbilityDatabase Cross-Reference (Arms L1)

| Ability Name | ability_id | unlock_level | unlock_source | subclass_filter | bg3_file_type | bg3_spell_type | Status |
|--------------|------------|--------------|---------------|-----------------|---------------|----------------|--------|
| Whirlwind | WAR__Whirlwind_ | **12** ⚠️ | Baseline | Protection | Spell_Zone | Zone | Not Started |
| Charge | WAR__Charge_ | 1 | Baseline | All | Spell_Jump | Target | Not Started |
| Battle Stance | WAR__Battle_Stance_ | 1 | Class Talent | All | Spell_Shout | Shout | Not Started |
| Defensive Stance | WAR__Defensive_Stance_ | 1 | Baseline | All | Spell_Shout | Shout | Not Started |
| Seasoned Soldier | WAR__Seasoned_Soldier_ | 1 | Spec Talent | Arms | Passive | N/A | Not Started |
| Mastery: Deep Wounds | WAR__Mastery_Deep_Wounds_ | 1 | Baseline | All | Passive | N/A | Not Started |
| Mortal Strike | WAR__Mortal_Strike_ | 1 | Baseline | All | Spell_Target | Target | Not Started |

**⚠️ DISCREPANCY FOUND**: `Whirlwind` shows `unlock_level=12` in AbilityDatabase but appears in Arms L1 baseline (col 4). **CORRECTION NEEDED**: Should be `unlock_level=1`.

---

## 2. Fury Warrior (Level 1)

### 2.1 Auto-Granted Abilities (Baseline)

**From CSV Columns 9-10** (Offensive + Utility):

| Ability | Abbr | Type | Description | BG3 Implementation |
|---------|------|------|-------------|-------------------|
| **Whirlwind** | WW | Offensive (AoE) | Primary multitarget attack which facilitates cleaving other attacks | `Spell_Zone.txt`<br>`DealDamage(1d8+StrengthModifier,Slashing);RestoreResource(context.Source,Rage,10,0)` |
| **Berserker Rage** | BzR | Utility (CC-Break) | Preemptive or reactive CC removal | `Spell_Shout.txt`<br>`RemoveStatus('SG_Incapacitated');RemoveStatus('SG_Controlled');ApplyStatus(SELF,WAR_ENRAGED,100,4)`<br>Cooldown: OncePerShortRest |

**From CSV Columns K-L** (Stances - ALL Warriors):
- **Battle Stance** (same as Arms - see above)
- **Defensive Stance** (same as Arms - see above)

### 2.2 Auto-Granted Passives

**From CSV Row 1 (Columns 35-38)** - Fury Spec Passives:

| Passive | Description | BG3 Implementation |
|---------|-------------|-------------------|
| **Titan's Grip** | Passive bonus which allows dual wielding two-handed weapons | `Passive.txt`<br>Type: Passive<br>Tags: Fury, Passive, Dual-Wield<br>Effect: Equipment proficiency unlock |
| **Mastery: Unshackled Fury** | Passive bonus which scales damage with Mastery | `Passive.txt`<br>Type: Passive<br>Tags: Passive, Mastery, Stat-Scaling<br>Note: Needs custom implementation for BG3 |
| **Bloodthirst** | Primary attack which forms the basis of the rotation | `Spell_Target.txt`<br>`DealDamage(2d8+StrengthModifier,Physical);IF(CriticalHit()):ApplyStatus(WAR_ENRAGED,100,4);RegainHitPoints(3% MaxHP)`<br>Rage Cost: 20 |

### 2.3 Progressions.lsx Structure (Fury L1)

```xml
<node id="Progression">
    <attribute id="Level" type="uint8" value="1"/>
    <attribute id="TableUUID" type="guid" value="FuryWarriorProgressionTableUUID"/>
    <attribute id="UUID" type="guid" value="FuryL1ProgressionUUID"/>
    <attribute id="Boosts" type="LSString" value="ActionResource(Rage,100,0);Proficiency(MartialWeapons);Proficiency(HeavyArmor);ProficiencyBonus(SavingThrow,Strength);ProficiencyBonus(SavingThrow,Constitution)"/>
    <attribute id="PassivesAdded" type="LSString" value="WAR_RageGeneration;WAR_Titans_Grip;WAR_Mastery_UnshackledFury"/>
    <attribute id="Selectors" type="LSString" value="SelectSkills(WarriorSkillsUUID,2);AddSpells(FuryL1BaselineSpellListUUID)"/>
</node>
```

### 2.4 SpellLists & PassiveLists Required (Fury L1)

**SpellList: `FuryL1BaselineSpellListUUID`**
Must contain:
- `WAR_Whirlwind` (Baseline col 9)
- `WAR_Berserker_Rage` (Baseline col 10)
- `WAR_Bloodthirst` (Row 1 passive/ability col 38)
- `WAR_Battle_Stance` (Col K - stance)
- `WAR_Defensive_Stance` (Col L - stance)

**PassiveList**: None required (all passives granted via `PassivesAdded`)

### 2.5 AbilityDatabase Cross-Reference (Fury L1)

| Ability Name | ability_id | unlock_level | unlock_source | subclass_filter | bg3_file_type | bg3_spell_type | Status |
|--------------|------------|--------------|---------------|-----------------|---------------|----------------|--------|
| Whirlwind | WAR__Whirlwind_ | **12** ⚠️ | Baseline | Protection | Spell_Zone | Zone | Not Started |
| Berserker Rage | WAR__Berserker_Rage_ | 1 | Baseline | All | Spell_Shout | Shout | Not Started |
| Battle Stance | WAR__Battle_Stance_ | 1 | Class Talent | All | Spell_Shout | Shout | Not Started |
| Defensive Stance | WAR__Defensive_Stance_ | 1 | Baseline | All | Spell_Shout | Shout | Not Started |
| Titan's Grip | WAR__Titan_s_Grip_ | 1 | Spec Talent | Fury | Passive | N/A | Not Started |
| Mastery: Unshackled Fury | WAR__Mastery_Unshackled_Fury_ | 1 | Baseline | All | Passive | N/A | Not Started |
| Bloodthirst | WAR__Bloodthirst_ | 1 | Baseline | All | Spell_Target | Target | Not Started |

**⚠️ DISCREPANCY FOUND**: `Whirlwind` shows `unlock_level=12` in AbilityDatabase but appears in Fury L1 baseline (col 9). **CORRECTION NEEDED**: Should be `unlock_level=1`.

---

## 3. Protection Warrior (Level 1)

### 3.1 Auto-Granted Abilities (Baseline)

**From CSV Columns 6-8** (Offensive + Utility + Passives):

| Ability | Abbr | Type | Description | BG3 Implementation |
|---------|------|------|-------------|-------------------|
| **Shield Slam** | SS | Offensive | Your main offensive skill. Deals damage, generates Rage, it's great. | `Spell_Target.txt`<br>`DealDamage(2d6+StrengthModifier+ShieldAC,Bludgeoning);RestoreResource(context.Source,Rage,15,0)` |
| **Taunt** | - | Utility (Taunt) | Taunts enemies. Very basic. | `Spell_Target.txt`<br>`ApplyStatus(context.Target,WAR_TAUNTED,100,1)`<br>Cooldown: OncePerTurn |
| **Mastery: Critical Block** | - | Passive | This is your Mastery. It reduces the damage taken from auto-attacks you block. It also increases your Attack Power. | `Passive.txt`<br>Type: Passive<br>Tags: Protection, Passive, Block<br>Effect: Passive mitigation boost |

**From CSV Columns K-L** (Stances - ALL Warriors):
- **Battle Stance** (same as Arms - see above)
- **Defensive Stance** (same as Arms - see above)

### 3.2 Auto-Granted Passives

**From CSV Row 1 (Column 46)** - Protection Spec Passive:

| Passive | Description | BG3 Implementation |
|---------|-------------|-------------------|
| **Ignore Pain** | Core defensive skill, must-have talent | `Spell_Shout.txt`<br>`ApplyStatus(SELF,WAR_IGNORE_PAIN,100,6)`<br>Rage Cost: 40<br>Cooldown: Action |

**Note**: Ignore Pain is listed as L4 in AbilityDatabase but appears in Protection L1 baseline (col 46). **CORRECTION NEEDED**: Should be `unlock_level=1` for Protection subclass OR move to L4.

### 3.3 Progressions.lsx Structure (Protection L1)

```xml
<node id="Progression">
    <attribute id="Level" type="uint8" value="1"/>
    <attribute id="TableUUID" type="guid" value="ProtectionWarriorProgressionTableUUID"/>
    <attribute id="UUID" type="guid" value="ProtectionL1ProgressionUUID"/>
    <attribute id="Boosts" type="LSString" value="ActionResource(Rage,100,0);Proficiency(MartialWeapons);Proficiency(HeavyArmor);Proficiency(Shields);ProficiencyBonus(SavingThrow,Strength);ProficiencyBonus(SavingThrow,Constitution)"/>
    <attribute id="PassivesAdded" type="LSString" value="WAR_RageGeneration;WAR_Mastery_CriticalBlock"/>
    <attribute id="Selectors" type="LSString" value="SelectSkills(WarriorSkillsUUID,2);AddSpells(ProtectionL1BaselineSpellListUUID)"/>
</node>
```

**Note**: Protection gets `Proficiency(Shields)` that Arms/Fury do not.

### 3.4 SpellLists & PassiveLists Required (Protection L1)

**SpellList: `ProtectionL1BaselineSpellListUUID`**
Must contain:
- `WAR_Shield_Slam` (Baseline col 6)
- `WAR_Taunt` (Baseline col 7)
- `WAR_Ignore_Pain` (Row 1 passive/ability col 46)
- `WAR_Battle_Stance` (Col K - stance)
- `WAR_Defensive_Stance` (Col L - stance)

**PassiveList**: None required (all passives granted via `PassivesAdded`)

### 3.5 AbilityDatabase Cross-Reference (Protection L1)

| Ability Name | ability_id | unlock_level | unlock_source | subclass_filter | bg3_file_type | bg3_spell_type | Status |
|--------------|------------|--------------|---------------|-----------------|---------------|----------------|--------|
| Shield Slam | WAR__Shield_Slam_ | **12** ⚠️ | Baseline | Fury | Spell_Target | Target | Not Started |
| Taunt | WAR__Taunt_ | 1 | Baseline | All | Spell_Target | Target | Not Started |
| Mastery: Critical Block | WAR__Mastery_Critical_Block_ | 1 | Baseline | All | Passive | N/A | Not Started |
| Battle Stance | WAR__Battle_Stance_ | 1 | Class Talent | All | Spell_Shout | Shout | Not Started |
| Defensive Stance | WAR__Defensive_Stance_ | 1 | Baseline | All | Spell_Shout | Shout | Not Started |
| Ignore Pain | WAR__Ignore_Pain_ | **4** ⚠️ | Baseline | All | Spell_Shout | Shout | Not Started |

**⚠️ DISCREPANCIES FOUND**:
1. `Shield Slam` shows `unlock_level=12` in AbilityDatabase but appears in Protection L1 baseline (col 6). **CORRECTION NEEDED**: Should be `unlock_level=1`.
2. `Shield Slam` has `subclass_filter=Fury` but is Protection baseline. **CORRECTION NEEDED**: Should be `subclass_filter=Protection`.
3. `Ignore Pain` shows `unlock_level=4` in AbilityDatabase but appears in Protection L1 baseline (col 46). **CORRECTION NEEDED**: Should be `unlock_level=1` OR clarify if this is intended for L4.

---

## 4. Summary Tables

### 4.1 Level 1 Grants by Subclass

| Category | Arms | Fury | Protection |
|----------|------|------|------------|
| **Baseline Offensive** | Whirlwind | Whirlwind | Shield Slam |
| **Baseline Utility** | Charge | Berserker Rage | Taunt |
| **Baseline Passive** | - | - | Mastery: Critical Block |
| **Stances (All)** | Battle Stance, Defensive Stance | Battle Stance, Defensive Stance | Battle Stance, Defensive Stance |
| **Auto Passives** | Seasoned Soldier, Mastery: Deep Wounds | Titan's Grip, Mastery: Unshackled Fury | - |
| **Signature Ability** | Mortal Strike | Bloodthirst | Ignore Pain |
| **Total Abilities** | 7 | 7 | 6 |
| **Total Passives** | 2 | 2 | 1 |
| **Player Choices** | 0 (2 skills only) | 0 (2 skills only) | 0 (2 skills only) |

### 4.2 Common L1 Grants (All Subclasses)

| Category | Abilities |
|----------|-----------|
| **Stances** | Battle Stance, Defensive Stance |
| **Resource** | Rage (100 max, 0 starting) |
| **Proficiencies** | Martial Weapons, Heavy Armor, Shields (Protection only) |
| **Saving Throws** | Strength, Constitution |
| **Skills** | Select 2 from Warrior skill list |

### 4.3 Unique L1 Identities

| Subclass | Primary Offensive | Primary Utility | Primary Defensive | Core Mechanic |
|----------|-------------------|-----------------|-------------------|---------------|
| **Arms** | Mortal Strike (bleed) | Charge (mobility) | - | Bleed damage + Rage generation on crits |
| **Fury** | Bloodthirst (heal+enrage) | Berserker Rage (CC break) | - | Enrage + Dual-wield 2H weapons |
| **Protection** | Shield Slam (rage gen) | Taunt | Ignore Pain (absorb) | Block mitigation + Shield-based offense |

---

## 5. Critical Discrepancies Requiring Correction

### 5.1 AbilityDatabase Corrections Needed

| ability_id | Current unlock_level | Correct unlock_level | Current subclass_filter | Correct subclass_filter | Reason |
|------------|---------------------|---------------------|------------------------|------------------------|--------|
| `WAR__Whirlwind_` | 12 | 1 | Protection | Arms, Fury | Appears in Arms (col 4) and Fury (col 9) L1 baseline |
| `WAR__Shield_Slam_` | 12 | 1 | Fury | Protection | Appears in Protection (col 6) L1 baseline |
| `WAR__Ignore_Pain_` | 4 | 1 or 4 (clarify) | All | Protection (if L1) | Appears in Protection (col 46) L1 baseline - **CLARIFICATION NEEDED** |

### 5.2 Progression CSV vs AbilityDatabase Alignment

**Issue**: Some baseline abilities show incorrect `unlock_level` in AbilityDatabase.

**Root Cause**: AbilityDatabase shows when ability *unlocks in talent tree* (L12 for later access), but Progression CSV shows *baseline grants* (L1 auto-grant).

**Resolution Strategy**:
1. **AbilityDatabase `unlock_level`** = When ability first becomes available (baseline OR talent unlock)
2. **AbilityDatabase `unlock_source`** = "Baseline" (auto-grant) vs "Class Talent" (player choice) vs "Spec Talent" (subclass choice)
3. **Progression CSV columns 4-10** = Baseline auto-grants (should match `unlock_source=Baseline`)
4. **Progression CSV columns 12+** = Talent tree choices (should match `unlock_source=Class Talent` or `Spec Talent`)

**Action Items**:
- [ ] Update `WAR__Whirlwind_` in AbilityDatabase: `unlock_level=1`, `subclass_filter=Arms,Fury` (baseline for both)
- [ ] Update `WAR__Shield_Slam_` in AbilityDatabase: `unlock_level=1`, `subclass_filter=Protection` (baseline)
- [ ] Clarify `WAR__Ignore_Pain_` intent: Is it L1 Protection baseline OR L4 class talent? CSV shows L1 (col 46), but AbilityDatabase shows L4.

---

## 6. FILE 11 (Progressions.lsx) Implementation Notes

### 6.1 UUIDs Required for Level 1

**ProgressionTable UUIDs** (3 total):
- `ArmsWarriorProgressionTableUUID`
- `FuryWarriorProgressionTableUUID`
- `ProtectionWarriorProgressionTableUUID`

**Progression Node UUIDs** (3 total):
- `ArmsL1ProgressionUUID`
- `FuryL1ProgressionUUID`
- `ProtectionL1ProgressionUUID`

**SpellList UUIDs** (4 total):
- `WarriorSkillsUUID` (shared - skill selection)
- `ArmsL1BaselineSpellListUUID` (5 spells)
- `FuryL1BaselineSpellListUUID` (5 spells)
- `ProtectionL1BaselineSpellListUUID` (5 spells)

**Total UUIDs for L1**: 10 UUIDs

### 6.2 SpellLists.lsx Entries Required (FILE 12)

**ArmsL1BaselineSpellListUUID**:
```xml
<node id="SpellList">
    <attribute id="Spells" type="LSString" value="WAR_Whirlwind;WAR_Charge;WAR_Mortal_Strike;WAR_Battle_Stance;WAR_Defensive_Stance"/>
    <attribute id="UUID" type="guid" value="ArmsL1BaselineSpellListUUID"/>
</node>
```

**FuryL1BaselineSpellListUUID**:
```xml
<node id="SpellList">
    <attribute id="Spells" type="LSString" value="WAR_Whirlwind;WAR_Berserker_Rage;WAR_Bloodthirst;WAR_Battle_Stance;WAR_Defensive_Stance"/>
    <attribute id="UUID" type="guid" value="FuryL1BaselineSpellListUUID"/>
</node>
```

**ProtectionL1BaselineSpellListUUID**:
```xml
<node id="SpellList">
    <attribute id="Spells" type="LSString" value="WAR_Shield_Slam;WAR_Taunt;WAR_Ignore_Pain;WAR_Battle_Stance;WAR_Defensive_Stance"/>
    <attribute id="UUID" type="guid" value="ProtectionL1BaselineSpellListUUID"/>
</node>
```

### 6.3 Zero SpellList Approach Validation

**Confirmed**: Level 1 uses **Zero SpellList** approach:
- All baseline abilities granted via `AddSpells(SpellListUUID)` selector
- No `<attribute id="SpellList" type="guid" value="..."/>` in Progression nodes
- SpellLists defined separately in FILE 12 (Lists/SpellLists.lsx)

**Advantages**:
- Single SpellList definition shared across all progression nodes
- Easy to update abilities without touching Progressions.lsx
- Clean separation of concerns (progression flow vs ability grants)

---

## 7. Next Steps

### 7.1 Immediate Actions
1. **Correct AbilityDatabase discrepancies** (Whirlwind, Shield Slam, Ignore Pain unlock levels)
2. **Clarify Ignore Pain placement**: L1 Protection baseline OR L4 class talent?
3. **Proceed to Level 2 review** using same comprehensive cross-reference methodology

### 7.2 Downstream Benefits
- **FILE 11 transformation**: L1 progression nodes ready for immediate implementation
- **FILE 12 transformation**: L1 SpellLists defined and ready to create
- **FILE 4-10 implementation**: All L1 abilities have complete BG3 implementation notes from AbilityDatabase

### 7.3 Documentation Update Checklist
- [ ] Update SOURCE_OF_TRUTH.md Section [6] with L1 corrected data
- [ ] Update AbilityDatabase CSV with corrected unlock_level and subclass_filter values
- [ ] Create LEVEL_2_PROGRESSION_REVIEW.md (next iteration)
- [ ] Track cumulative UUIDs required (currently 10 for L1)

---

## 8. Verification Summary

**✅ VERIFIED**:
- Arms L1: 7 abilities (5 spells + 2 passives) cross-referenced
- Fury L1: 7 abilities (5 spells + 2 passives) cross-referenced
- Protection L1: 6 abilities (5 spells + 1 passive) cross-referenced
- All stances (Battle, Defensive) confirmed for all subclasses
- All baseline abilities matched to AbilityDatabase entries

**⚠️ DISCREPANCIES**:
- 3 abilities with incorrect unlock_level in AbilityDatabase
- 1 ability (Shield Slam) with incorrect subclass_filter
- 1 ability (Ignore Pain) requiring clarification on intended level

**📋 READY FOR**:
- FILE 11 (Progressions.lsx) transformation
- FILE 12 (SpellLists.lsx) creation
- Level 2 progression review

---

**End of Level 1 Review**
