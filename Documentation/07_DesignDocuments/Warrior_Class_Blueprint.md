# BG3Wow - Warrior Class Blueprint

**Version:** 0.1.0-alpha  
**Author:** vorgx  
**Namespace:** VORGX  
**Module UUID:** `78fe4967-4e62-5491-d981-dd781acca4d7`  
**Template Version:** 1.0  
**Game Compatibility:** Patch 8 (BG3 v4.8.0.10+)

---

## Table of Contents

- [Overview](#overview)
- [Meta Information](#meta-information)
- [Dependencies](#dependencies)
- [Class Details](#class-details)
- [Core Abilities](#core-abilities)
- [Subclasses](#subclasses)
  - [Arms](#arms-warrior)
  - [Fury](#fury-warrior)
  - [Protection](#protection-warrior)
- [Specializations (Level 13-20)](#specializations-level-13-20)
  - [Mountain Thane](#mountain-thane)
  - [Colossus](#colossus)
  - [Slayer](#slayer)
- [Level Progression](#level-progression)
- [Implementation Status](#implementation-status)
- [Technical Details](#technical-details)

---

## Overview

**BG3Wow - Warrior Class** brings World of Warcraft's iconic Warrior to Baldur's Gate 3, featuring:

- **Rage Resource System**: Generate and spend Rage (0-100) through combat
- **Three Subclasses**: Arms, Fury, and Protection specializations (unlocked at Level 3)
- **Six Specializations**: Mountain Thane, Colossus, and Slayer hero talents (unlocked at Level 13)
- **20 Levels**: Full progression from Level 1 to 20 with Patch 8 compatibility

**Tagline:** *"Charge into battle with unbridled fury"*

---

## Meta Information

### Identifiers

| Property | Value |
|----------|-------|
| **Mod Name** | BG3Wow - Warrior Class |
| **Class Name** | Warrior |
| **Class Key** | `CLASS_VORGX_WARRIOR` |
| **Slug** | `vorgx-warrior` |
| **Module UUID** | `78fe4967-4e62-5491-d981-dd781acca4d7` |

### Version

- **Current Version:** 0.1.0-alpha
- **Semantic Version:** `0.1.0-alpha`
- **Authoring Mode:** Exact
- **Progression Curve:** Patch8_L20

---

## Dependencies

### Required

- **GustavX** (Base Game)
  - UUID: `cb555efe-2d9e-131f-8195-a89329d218ea`
  - Required: Yes

### Compatibility

- **Minimum Game Build:** 4.1.1.0
- **Level Curve:** Patch8_L20 (Levels 1-20)

---

## Class Details

### Identity

**Warrior** - Masters of martial combat who harness rage to fuel devastating attacks. Warriors wear heavy armor and wield any weapon with deadly proficiency.

| Attribute | Value |
|-----------|-------|
| **Primary Ability** | Strength |
| **Saving Throws** | Strength, Constitution |
| **Hit Die** | d10 |
| **Starting HP** | 10 |
| **HP per Level** | 6 |

### Proficiencies

#### Armor
- Light Armor
- Medium Armor
- Heavy Armor
- Shields

#### Weapons
- Simple Weapons
- Martial Weapons

#### Saving Throws
- Strength
- Constitution

#### Skills
**Choose 2 from:**
- Athletics
- Acrobatics
- Intimidation
- Perception
- Survival
- Animal Handling

### Starting Equipment

**Starting Gold:** 5d4 × 10 gp

**Starting Equipment Options:**
1. Chain Mail OR Leather Armor + Longbow + 20 Arrows
2. Martial Weapon + Shield OR Two Martial Weapons
3. Light Crossbow + 20 Bolts OR Two Handaxes
4. Dungeoneer's Pack OR Explorer's Pack

### Multiclassing

**Prerequisite:** Strength 13

---

## 5-Pool Talent System (v2.0)

**Status:** Fully Designed, Implementation Planned

The Warrior class features a comprehensive **5-pool talent system** inspired by World of Warcraft's talent trees, offering deep customization and player choice across 20 levels.

### Talent Pool Overview

| Pool # | Name | Levels | Choices | Type | Total Talents |
|--------|------|--------|---------|------|---------------|
| **1** | Class Talents | L1-L12 | 9 | Shared by all specs | 24+ talents |
| **2** | SubclassSpec Talents | L3-L12 | 9 | Spec-specific | 24+ per spec |
| **3** | SubclassBase Talents | L3-L12 | 12 | Auto-granted | 12 baseline abilities |
| **4** | Specialization A | L13-L20 | 3-4 | Choice at L13 | 9 talents per spec |
| **5** | Specialization B | L13-L20 | 3-4 | Choice at L13 | 9 talents per spec |

**Total Player Choices:** 43+ choices across 20 levels (9 Class + 9 SubclassSpec + 3-4 Specialization per tier)

### Pool 1: Class Talents (Shared - 10 Rows)

**Availability:** All Warriors (Arms, Fury, Protection)  
**Levels:** 1-12  
**Structure:** 10 rows, pick 1 talent per row = 9 choices

**Purpose:** Core Warrior identity abilities shared across all specializations

**Example Talents:**
- **Row 1 (L1):** Charge | Heroic Leap | Intervene
- **Row 2 (L2):** Battle Shout | Commanding Shout | Rallying Cry
- **Row 3 (L3):** Berserker Rage | Die by the Sword | Defensive Stance
- **Row 4-10:** Additional utility, mobility, and defensive options

**Implementation:** SelectPassives system with choice nodes at each level

### Pool 2: SubclassSpec Talents (Spec-Specific - 10 Rows)

**Availability:** Specific to Arms, Fury, or Protection  
**Levels:** 3-12  
**Structure:** 10 rows, pick 1 talent per row = 9 choices

**Purpose:** Defines specialization playstyle (Arms: big hits/bleeds, Fury: speed/multi-hit, Protection: defense/mitigation)

**Arms Example Talents:**
- **Row 1 (L3):** Mortal Strike | Overpower | Rend
- **Row 2 (L4):** Colossus Smash | Warbreaker | Cleave
- **Row 3-10:** Arms-specific enhancements and abilities

**Fury Example Talents:**
- **Row 1 (L3):** Bloodthirst | Raging Blow | Rampage
- **Row 2 (L4):** Enrage | Bloodbath | Frenzy

**Protection Example Talents:**
- **Row 1 (L3):** Shield Slam | Revenge | Ignore Pain
- **Row 2 (L4):** Shield Block | Last Stand | Devastate

**Implementation:** Separate SelectPassives progressions per subclass

### Pool 3: SubclassBase Talents (12 Baseline Abilities)

**Availability:** Auto-granted based on subclass choice at L3  
**Levels:** 3-12  
**Structure:** 12 abilities granted automatically (no choices)

**Purpose:** Core rotation abilities that define each spec's baseline gameplay

**Note:** Each subclass receives the same 12 abilities but in different orders to support their unique playstyle and identity.

**Arms Baseline Abilities (Two-Handed DPS):**
1. Whirlwind (L3) - AoE cleave
2. Execute (L4) - Arms specialty finisher
3. Hamstring (L5) - Tactical slow
4. Slam (L6) - Basic filler
5. Charge (L7) - Gap closer
6. Victory Rush (L8) - Sustain
7. Heroic Throw (L9) - Ranged pull
8. Shield Slam (L10) - Shield utility option
9. Pummel (L11) - Interrupt
10. Battle Shout (L12) - Party buff
11. Berserker Rage (L12) - Cleanse
12. Taunt (L12) - Utility

**Fury Baseline Abilities (Dual-Wield DPS):**
1. Whirlwind (L3) - Dual-wield AoE
2. Slam (L4) - Fast filler
3. Berserker Rage (L5) - Enrage mechanic (core to Fury identity)
4. Charge (L6) - Early mobility for aggressive playstyle
5. Victory Rush (L7) - Sustain for risky gameplay
6. Execute (L8) - Execute phase tool
7. Heroic Throw (L9) - Ranged utility
8. Hamstring (L10) - Utility slow
9. Pummel (L11) - Interrupt
10. Battle Shout (L12) - Party buff
11. Taunt (L12) - Off-spec utility
12. Shield Slam (L12) - Off-spec utility

**Protection Baseline Abilities (Shield Tank):**
1. Taunt (L3) - Core tanking tool (early threat generation)
2. Shield Slam (L4) - Shield-based damage
3. Heroic Throw (L5) - Ranged pull tool
4. Charge (L6) - Gap closer for engagement
5. Pummel (L7) - Interrupt (critical for tanks)
6. Slam (L8) - Filler damage
7. Execute (L9) - Threat spike tool
8. Victory Rush (L10) - Sustain
9. Whirlwind (L11) - AoE threat generation
10. Battle Shout (L12) - Party buff
11. Hamstring (L12) - Utility slow
12. Berserker Rage (L12) - Cleanse

**Status:** ✅ ALL 12 EXIST in current implementation (Spell_Target.txt, Spell_Zone.txt, Spell_Shout.txt)

**Design Rationale:** 
- **Protection gets Taunt at L3** (not L12) - Can effectively tank from subclass selection
- **Arms gets Execute at L4** - Reinforces Arms as the Execute specialist
- **Fury gets Berserker Rage at L5** - Early access to enrage mechanics defines Fury gameplay
- **Each spec feels unique** - Different ability orders create distinct playstyles from early levels

**Implementation:** Boosts in Progressions.lsx that auto-unlock spells at specific levels

### Pool 4 & 5: Specializations (Hero Talents - L13-20)

**Availability:** Choose 1 of 2 options per base spec at L13  
**Levels:** 13-20  
**Structure:** 3-tier OR 4-tier progression

**Specialization Availability Matrix:**

| Base Spec | Specialization Option 1 | Specialization Option 2 |
|-----------|------------------------|------------------------|
| **Arms** | Colossus (3 tiers) | Slayer (3 tiers) |
| **Fury** | Mountain Thane (4 tiers) | Slayer (3 tiers) |
| **Protection** | Mountain Thane (4 tiers) | Colossus (3 tiers) |

#### 3-Tier Specializations (Colossus, Slayer)

**Structure:**
- **L13:** Keystone (auto-granted, defines specialization theme)
- **L14:** Passive 1 (auto-granted)
- **L15:** Choice Node 1 (pick 1 of 2-3 talents)
- **L16:** Passive 2 (auto-granted)
- **L17:** Choice Node 2 (pick 1 of 2-3 talents)
- **L18:** Passive 3 (auto-granted)
- **L19:** Choice Node 3 (pick 1 of 2-3 talents)
- **L20:** Passive 4 (auto-granted) + **Capstone** (ultimate power)

**Total:** 1 Keystone + 3 choices + 4 passives + 1 Capstone = **9 talents**

#### 4-Tier Specializations (Mountain Thane)

**Structure:**
- **L13:** Keystone (auto-granted)
- **L14:** Passive 1 (auto-granted)
- **L15:** Choice Node 1 (pick 1 of 2)
- **L16:** Choice Node 2 (pick 1 of 2)
- **L17:** Passive 2 (auto-granted)
- **L18:** Choice Node 3 (pick 1 of 2)
- **L19:** Choice Node 4 (pick 1 of 2)
- **L20:** Passive 3 (auto-granted) + **Capstone**

**Total:** 1 Keystone + 4 choices + 3 passives + 1 Capstone = **9 talents**

### Specialization Descriptions

**Mountain Thane** (4-tier):
- **Theme:** Storm and lightning, Avatar enhancement
- **Keystone:** Avatar of the Storm (Lightning bursts during Avatar)
- **Playstyle:** Thunder Clap focused, Lightning damage, Avatar-centric

**Colossus** (3-tier):
- **Theme:** Tank/Defense, Demolish ability, Colossal Might stacking
- **Keystone:** Demolish (3d12 armor-crushing strike) + Colossal Might passive
- **Playstyle:** Shield Slam/Revenge focused, stacking mechanic, mitigation

**Slayer** (3-tier):
- **Theme:** DPS/Execution, Marked for Execution debuff
- **Keystone:** Slayer's Dominance (15% chance to Mark targets)
- **Playstyle:** Execute focused, high damage against marked enemies

### Detailed Documentation

For complete talent breakdowns, see:
- **`ARMS_WARRIOR_5_POOL_TALENT_SYSTEM.md`** - Full Arms implementation with all 5 pools (95KB)
- **`SPECIALIZATION_TIER_STRUCTURES.md`** - 3-tier vs 4-tier comparisons
- **`Arms_Warrior_Talents_Extracted.md`** - Arms: Colossus + Slayer specs
- **`Fury_Warrior_Talents_Extracted.md`** - Fury: Mountain Thane + Slayer specs
- **`Protection_Warrior_Talents_Extracted.md`** - Protection: Mountain Thane + Colossus specs

---

## Extra Attack (Level 5)

**Status:** Core BG3 Mechanic, Auto-Granted

### Overview

At **Level 5**, all Warriors gain the **Extra Attack** feature, a standard BG3 martial class progression milestone. This feature is **auto-granted** and does not require player choice.

### Mechanics

**Extra Attack**
- **Type:** Passive Feature
- **Granted At:** Level 5 (all Warriors - Arms, Fury, Protection)
- **Effect:** When you take the **Attack** action on your turn, you can attack **twice** instead of once
- **Applies To:** Main Attack action only (not bonus actions, reactions, or special attacks)

### Implementation

**Progressions.lsx Entry:**
```xml
<node id="Progression">
    <attribute id="Level" type="uint8" value="5"/>
    <attribute id="Name" type="LSString" value="Warrior"/>
    <attribute id="Boosts" type="LSString" value="ActionResource(ActionPoint,1,0)"/>
    <attribute id="PassivesAdded" type="LSString" value="ExtraAttack"/>
</node>
```

**How It Works:**
1. Player selects "Attack" action in combat
2. First attack executes normally
3. Second attack automatically available (same target or different)
4. Both attacks use the same modifier (Strength + proficiency)
5. Both attacks can trigger on-hit effects (Rage generation, status effects, etc.)

### Interactions with Warrior Abilities

**Compatible With:**
- ✅ Whirlwind (AoE attacks count as separate mechanic)
- ✅ Cleave (can cleave on both attacks)
- ✅ Charge (gap closer, then Extra Attack applies)
- ✅ Execute (Execute is separate action, not affected by Extra Attack)
- ✅ Mortal Strike / Overpower (spec abilities still use single attacks)

**Does NOT Stack With:**
- ❌ Sweeping Strikes (separate dual-wield mechanic)
- ❌ Rampage (Fury-specific multi-hit ability)
- ❌ Bloodthirst (single attack ability)

### Standard BG3 Implementation

Extra Attack is a **core BG3 feature** shared with:
- **Fighter** (Level 5)
- **Barbarian** (Level 5)
- **Ranger** (Level 5)
- **Paladin** (Level 5)
- **Monk** (Level 5)

Warriors follow the same implementation pattern as these classes, ensuring compatibility and balance.

### Why Level 5?

Level 5 is the **power spike level** in BG3 where martial classes gain significant combat effectiveness:
- **Casters:** Get Level 3 spells (Fireball, Lightning Bolt, etc.)
- **Martials:** Get Extra Attack (double damage output)

This maintains class balance and follows D&D 5e core rules.

### Documentation

For implementation details, see:
- **`WARRIOR_LEVEL_5_EXTRA_ATTACK.md`** - Full mechanical breakdown
- **Progressions.lsx** - Lines 150-165 (Level 5 progression node)

---

## Core Abilities

Core abilities available to all Warriors regardless of subclass.

### Level 1: Rage (Passive)

**Key:** `PASSIVE_VORGX_WAR_RAGE`  
**Type:** Passive  
**Tags:** PrimaryCategory:Passive, Identity:ResourceSystem

**Description:** Your fury in battle fuels your attacks. You generate Rage through combat and spend it on powerful abilities.

**Mechanics:**
- **Resource Type:** RES_VORGX_WAR_RAGE
- **Max Rage:** 100
- **Generation:** Dealing or taking damage generates Rage
- **Decay:** Out of combat, Rage slowly decays

---

### Level 1: Charge

**Key:** `ACTION_VORGX_WAR_CHARGE`  
**Type:** Action  
**Tags:** Action, Builder, Leap, Mid Cooldown, Bludgeoning, Weapon Scaling

**Description:** Charge to a target, dealing weapon damage and generating 20 Rage.

**Mechanics:**
- **Damage:** Weapon Damage
- **Range:** 18m
- **Cooldown:** 1 turn
- **Rage Generated:** 20
- **Effects:** Root target for 1 turn

---

### Level 1: Heroic Strike

**Key:** `ACTION_VORGX_WAR_HEROIC_STRIKE`  
**Type:** Action  
**Tags:** Action, Spender, Melee, Light Cooldown, Slashing, Weapon Scaling

**Description:** A powerful strike that costs 30 Rage. Deal 1d8 + Strength modifier damage.

**Mechanics:**
- **Damage:** 1d8 + Strength Modifier
- **Range:** Melee
- **Rage Cost:** 30

---

### Level 2: Battle Shout

**Key:** `ACTION_VORGX_WAR_BATTLE_SHOUT`  
**Type:** Bonus Action  
**Tags:** Bonus Action, Utility, Self, Heavy Cooldown

**Description:** Rally yourself and nearby allies, granting +2 to attack rolls for 3 turns.

**Mechanics:**
- **Range:** 9m radius
- **Duration:** 3 turns
- **Cooldown:** 2 turns
- **Effects:** +2 Attack Rolls
- **Rage Generated:** 10

---

### Level 3: Execute

**Key:** `ACTION_VORGX_WAR_EXECUTE`  
**Type:** Action  
**Tags:** Action, Finisher, Melee, Light Cooldown, Slashing, Weapon Scaling

**Description:** Execute a wounded foe. Costs 30 Rage. Deal massive damage to enemies below 20% HP (doubled damage).

**Mechanics:**
- **Damage:** 2d8 + Strength Modifier (4d8 if target below 20% HP)
- **Range:** Melee
- **Rage Cost:** 30
- **Effects:** Double damage on low-HP targets

---

## Subclasses

Warriors choose a specialization at **Level 3**, gaining unique abilities and playstyles.

---

## Arms Warrior

**Key:** `SUBCLASS_VORGX_WAR_ARMS`  
**Unlock Level:** 3

### Identity

**Playstyle:** Two-handed weapon specialist with tactical abilities

**Strengths:**
- Single-target damage
- Weapon mastery
- Tactical control

**Weaknesses:**
- Lower mobility
- Fewer defensive options

**Preferred Weapons:** Greatswords, Greataxes, Polearms  
**Armor Type:** Heavy

---

### Arms Abilities

#### Level 3: Mortal Strike

**Key:** `ACTION_VORGX_WAR_ARMS_MORTAL_STRIKE`  
**Type:** Action  
**Tags:** Action, Spender, Melee, Mid Cooldown, Slashing, Weapon Scaling

**Description:** Signature Arms ability. Deal 2d10 + Strength damage and apply Healing Reduction (50% less healing) for 2 turns. Costs 30 Rage.

**Mechanics:**
- **Damage:** 2d10 + Strength Modifier
- **Range:** Melee
- **Rage Cost:** 30
- **Cooldown:** 1 turn
- **Effects:** Healing Reduction 50% for 2 turns

---

#### Level 3: Weapon Mastery (Passive)

**Key:** `PASSIVE_VORGX_WAR_ARMS_WEAPONMASTER`  
**Type:** Passive  
**Tags:** Passive, Enhancement

**Description:** Your expertise with two-handed weapons grants you +1 to attack and damage rolls when wielding a two-handed weapon.

**Mechanics:**
- **Effects:** +1 Attack and Damage with Two-Handed weapons

---

#### Level 5: Overpower

**Key:** `ACTION_VORGX_WAR_ARMS_OVERPOWER`  
**Type:** Bonus Action  
**Tags:** Bonus Action, Spender, Melee, Light Cooldown, Bludgeoning, Weapon Scaling

**Description:** Overwhelm your opponent's defenses. Deal 1d12 + Strength damage and ignore 50% of target's AC. Costs 20 Rage.

**Mechanics:**
- **Damage:** 1d12 + Strength Modifier
- **Range:** Melee
- **Rage Cost:** 20
- **Effects:** Ignore 50% target AC

---

## Fury Warrior

**Key:** `SUBCLASS_VORGX_WAR_FURY`  
**Unlock Level:** 3

### Identity

**Playstyle:** Dual-wielding berserker with high attack speed

**Strengths:**
- Multi-target damage
- High attack speed
- Rage generation

**Weaknesses:**
- Low defense
- Reckless playstyle

**Preferred Weapons:** Dual one-handed weapons  
**Armor Type:** Medium/Heavy

---

### Fury Abilities

#### Level 3: Bloodthirst

**Key:** `ACTION_VORGX_WAR_FURY_BLOODTHIRST`  
**Type:** Action  
**Tags:** Action, Spender, Melee, Light Cooldown, Slashing, Weapon Scaling, Healing

**Description:** A vicious strike that heals you for 5% of your maximum HP. Costs 20 Rage.

**Mechanics:**
- **Damage:** 1d10 + Strength Modifier
- **Range:** Melee
- **Rage Cost:** 20
- **Effects:** Heal for 5% Max HP

---

#### Level 3: Enrage (Passive)

**Key:** `PASSIVE_VORGX_WAR_FURY_ENRAGE`  
**Type:** Passive  
**Tags:** Passive, Enhancement

**Description:** Your critical strikes Enrage you, increasing damage by 15% for 4 turns.

**Mechanics:**
- **Trigger:** Critical Hit
- **Effects:** +15% Damage for 4 turns

---

#### Level 5: Whirlwind

**Key:** `ACTION_VORGX_WAR_FURY_WHIRLWIND`  
**Type:** Action  
**Tags:** Action, Spender, AoE, Mid Cooldown, Slashing, Weapon Scaling

**Description:** Spin in a devastating circle, hitting all nearby enemies. Costs 25 Rage.

**Mechanics:**
- **Damage:** Weapon Damage to all targets
- **Range:** 5m radius
- **Rage Cost:** 25
- **Cooldown:** 1 turn

---

## Protection Warrior

**Key:** `SUBCLASS_VORGX_WAR_PROT`  
**Unlock Level:** 3

### Identity

**Playstyle:** Tank with shield-based defensive abilities

**Strengths:**
- Damage mitigation
- Threat generation
- Ally protection

**Weaknesses:**
- Lower damage output
- Support-dependent

**Preferred Weapons:** One-handed weapon + Shield  
**Armor Type:** Heavy

---

### Protection Abilities

#### Level 3: Shield Slam

**Key:** `ACTION_VORGX_WAR_PROT_SHIELD_SLAM`  
**Type:** Action  
**Tags:** Action, Spender, Melee, Light Cooldown, Bludgeoning, Weapon Scaling

**Description:** Slam your shield into an enemy, dealing 1d12 + Strength damage and stunning them for 1 turn. Costs 20 Rage.

**Mechanics:**
- **Damage:** 1d12 + Strength Modifier
- **Range:** Melee
- **Rage Cost:** 20
- **Effects:** Stun target for 1 turn

---

#### Level 3: Shield Block (Passive)

**Key:** `PASSIVE_VORGX_WAR_PROT_SHIELD_BLOCK`  
**Type:** Passive  
**Tags:** Passive, Defense

**Description:** Your shield mastery grants you +2 AC when wielding a shield.

**Mechanics:**
- **Effects:** +2 AC with Shield equipped

---

#### Level 5: Revenge

**Key:** `ACTION_VORGX_WAR_PROT_REVENGE`  
**Type:** Bonus Action  
**Tags:** Bonus Action, Spender, Melee, Light Cooldown, Bludgeoning, Weapon Scaling

**Description:** Strike back after taking damage. Deal 1d10 + Strength damage. Can only be used after being hit. Costs 15 Rage.

**Mechanics:**
- **Damage:** 1d10 + Strength Modifier
- **Range:** Melee
- **Rage Cost:** 15
- **Requirement:** Must have taken damage since last turn

---

## Specializations (Level 13-20)

At **Level 13**, Warriors choose one of three specializations, gaining unique hero talents and playstyle enhancements. These are cross-subclass paths inspired by WoW's Hero Talent system.

---

## Mountain Thane

**Available to:** Arms, Protection  
**Unlock Level:** 13

### Identity

**Theme:** Thunder-infused warrior channeling the fury of storms

**Playstyle:** Enhance Thunder Clap and Avatar with elemental power

**Key Mechanics:**
- Thunder damage bonuses
- Ground-slam area effects
- Storm-themed buffs

### Mountain Thane Talents

| Level | Talent | Type | Description |
|-------|--------|------|-------------|
| 13 | **Keystone: Mountain Thane** | Passive | Unlocks specialization. Thunder Clap gains +2d6 Lightning damage. |
| 15 | **Thunder Blast** OR **Storm Bolts** | Choice | Thunder Blast: Thunder Clap radius +3m. / Storm Bolts: Charge also throws storm bolt. |
| 17 | **Lightning Strikes** OR **Gathering Storms** | Choice | Lightning Strikes: Critical Thunder Claps deal double damage. / Gathering Storms: Thunder Clap cooldown -1 turn. |
| 19 | **Avatar of Thunder** OR **Storm's Wrath** | Choice | Avatar of Thunder: Avatar grants Lightning Resistance. / Storm's Wrath: Thunder Clap applies Stunned (1 turn). |
| 20 | **Capstone: Crashing Thunder** | Passive | Thunder Clap deals 4d6 Lightning + 2d6 Thunder damage. |

---

## Colossus

**Available to:** All subclasses  
**Unlock Level:** 13

### Identity

**Theme:** Unstoppable juggernaut with earth-shattering might

**Playstyle:** Stack Colossal Might through combat, unleash with Demolish

**Key Mechanics:**
- Colossal Might stacks (max 3)
- Demolish ability (3×3d10 damage, consumes stacks)
- Size and impact bonuses

### Colossus Talents

| Level | Talent | Type | Description |
|-------|--------|------|-------------|
| 13 | **Keystone: Colossus** | Passive | Unlocks Demolish ability. Gain Colossal Might on Shield Slam casts. |
| 15 | **Mountain of Muscle** OR **One Against Many** | Choice | Mountain: +2 Strength (max 22). / One Against Many: Damage reduction per nearby enemy. |
| 17 | **Unstoppable Force** OR **Crushing Advance** | Choice | Unstoppable: Immunity to Immobilize/Slow. / Crushing: Enemies take damage when moving near you. |
| 19 | **Dominance of the Colossus** OR **Practiced Strikes** | Choice | Dominance: Intimidate on hit (Disadvantage). / Practiced: +1 attack per Colossal Might stack. |
| 20 | **Capstone: Colossal Might Perfected** | Passive | Demolish max stacks +1 (4 total), each stack +1d10 damage. |

#### Special Ability: Demolish

**Key:** `ACTION_VORGX_WAR_DEMOLISH`  
**Type:** Action  
**Unlock Level:** 13

**Description:** Ground-slam attack that consumes all Colossal Might stacks, dealing 3d10 damage per stack consumed.

**Mechanics:**
- **Damage:** 3d10 per Colossal Might stack (max 3 stacks = 9d10)
- **Range:** 3m radius AoE
- **Rage Cost:** 40
- **Effects:** Consumes all Colossal Might stacks, Knocks enemies Prone

---

## Slayer

**Available to:** Arms, Fury  
**Unlock Level:** 13

### Identity

**Theme:** Relentless executioner specializing in finishing wounded foes

**Playstyle:** Enhanced Execute and low-HP target burst damage

**Key Mechanics:**
- Execute bonuses and cooldown resets
- Damage increases on low-HP targets
- Reaper's Mark mechanic

### Slayer Talents

| Level | Talent | Type | Description |
|-------|--------|------|-------------|
| 13 | **Keystone: Slayer** | Passive | Execute cooldown resets when killing a target. Execute deals +2d12 damage. |
| 15 | **Culling Strike** OR **Slayer's Malice** | Choice | Culling: Execute usable on targets below 35% HP. / Malice: Marked targets take +10% damage. |
| 17 | **Vicious Agility** OR **Death Drive** | Choice | Agility: +3m movement after Execute kill. / Death Drive: Execute critical chance +15%. |
| 19 | **Relentless Pursuit** OR **Overwhelming Rage** | Choice | Pursuit: Charge range +6m after Execute. / Rage: Execute rage cost -15. |
| 20 | **Capstone: Reaper's Mark** | Passive | Execute applies Reaper's Mark (30s). Marked enemies take +20% Execute damage. |

---

## Level Progression

### Base Class Progression (Levels 1-20)

| Level | Features | Abilities Gained | Notes |
|-------|----------|------------------|-------|
| 1 | Rage System, Heavy Armor | Charge, Heroic Strike | Core mechanics introduced |
| 2 | Battle Shout | Battle Shout | Party buff ability |
| 3 | **Subclass Choice**, Execute | Execute, Subclass Abilities | Choose Arms/Fury/Protection |
| 4 | Ability Score Improvement | — | +2 to one stat or +1 to two |
| 5 | Extra Attack | Subclass Abilities | Attack twice per action |
| 6 | Defensive Stance | Defensive Stance | Damage reduction stance |
| 7 | Intimidating Shout | Intimidating Shout | Fear AoE |
| 8 | Ability Score Improvement | — | +2 to one stat or +1 to two |
| 9 | Heroic Leap | Heroic Leap | Leap to location, AoE damage |
| 10 | Rallying Cry | Rallying Cry | Party healing ability |
| 11 | Subclass Feature | Subclass Abilities | Subclass-specific enhancement |
| 12 | Ability Score Improvement | — | +2 to one stat or +1 to two |
| 13 | **Specialization Choice** | Specialization Keystone | Choose Mountain Thane/Colossus/Slayer |
| 14 | Hamstring | Hamstring | Movement impairment |
| 15 | Specialization Choice Node | — | Choose between 2 talents |
| 16 | Ability Score Improvement | — | +2 to one stat or +1 to two |
| 17 | Specialization Choice Node | — | Choose between 2 talents |
| 18 | Indomitable | Indomitable | Legendary save ability |
| 19 | Specialization Choice Node | — | Choose between 2 talents |
| 20 | Specialization Capstone | — | Final specialization power |

---

## Implementation Status

### ✅ Phase 1: Core Files (COMPLETE)

**Status:** 100% Complete, Validated for Patch 8

**Files Implemented:**
1. **ActionResourceDefinitions.lsx**
   - Rage resource (UUID: `8fe271a3-3f3c-4170-8c6a-a6eb9b597894`)
   - Max: 100, Default: 0
   
2. **ClassDescriptions.lsx**
   - 4 ClassDescription nodes:
     - Base Warrior
     - Arms Subclass
     - Fury Subclass
     - Protection Subclass
   
3. **Progressions.lsx**
   - Complete L1-20 progression
   - All subclass progressions
   - Specialization progressions (L13-20)

**Validation:** 100% validated (Patch 8 compatible, BG3 v4.8.0.10)

---

### ✅ Phase 2: Specializations (DOCUMENTED)

**Status:** Fully Documented, Implementation-Ready

**Documentation Files:**
- `SPECIALIZATIONS_REFERENCE.md` - All 6 specializations detailed
- `PASSIVES_MOUNTAIN_THANE.md` - 11 passives defined
- `PASSIVES_COLOSSUS.md` - 11 passives + Demolish spell
- `PASSIVES_SLAYER.md` - 11 passives defined
- `PASSIVES_MASTER.md` - Implementation guide

**Validation:** Cross-references validated, Progressions.lsx corrected

**Total Passive Count:** 33 passives across 3 specializations

---

### ⏸️ Phase 3: Stats Files (PENDING)

**Status:** Not Started

**Required Files:**
1. **Status_Warrior.txt** - 16 status definitions
2. **Passive_Warrior.txt** - 33 passive entries
3. **Spell_Warrior.txt** - Demolish spell + base abilities
4. **English.loca.xml** - 70+ localization handles

**Next Steps:**
1. Create Status_Warrior.txt with 16 statuses
2. Create Passive_Warrior.txt with 33 passives
3. Add Demolish to Spell_Warrior.txt
4. Generate localization handles

---

### ⏸️ Phase 4: Abilities (PLANNED)

**Status:** Planned, Not Implemented

#### Base Abilities (13 Total)
1. Charge (L1) - 12m Rush, 1d4+STR, +10 Rage, Off Balance
2. Heroic Strike (L1) - 20 Rage, weapon damage + bonus
3. Battle Shout (L2) - Party buff
4. Execute (L3) - 20 Rage, 4d12 vs low HP
5. Defensive Stance (L6)
6. Intimidating Shout (L7)
7. Heroic Leap (L9)
8. Rallying Cry (L10)
9. Avatar (L13 base)
10. Hamstring (L14)
11. Spell Reflection (L15 base)
12. Die by the Sword (L17 base)
13. Indomitable (L18)

#### Subclass Abilities

**Arms:**
- Mortal Strike
- Overpower
- Colossus Smash
- Sweeping Strikes
- Warbreaker

**Fury:**
- Bloodthirst
- Rampage
- Whirlwind
- Enraged Regeneration
- Raging Blow

**Protection:**
- Shield Slam
- Shield Block
- Taunt
- Revenge
- Shield Wall
- Shockwave

#### Specialization Abilities

**Colossus:**
- Demolish (3×3d10, consumes Colossal Might stacks)

---

## Technical Details

### File Structure

```
Data/
├── Mods/BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7/
│   ├── meta.lsx
│   └── ScriptExtender/
└── Public/BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7/
    ├── ActionResourceDefinitions/
    │   └── ActionResourceDefinitions.lsx
    ├── ClassDescriptions/
    │   └── ClassDescriptions.lsx
    ├── Progressions.lsx
    ├── Stats/Generated/Data/
    │   ├── Status_Warrior.txt (PENDING)
    │   ├── Passive_Warrior.txt (PENDING)
    │   └── Spell_Warrior.txt (PENDING)
    └── Localization/English/
        └── English.loca.xml (PENDING)
```

### Generation Settings

**Output Folder:** `Data/Public/BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7`

**Generation Flags:**
- ✅ Generate LSX files
- ✅ Generate Stats files
- ✅ Generate Localization
- ❌ Generate Icons (not implemented)

### File Mapping

| File | Destination |
|------|-------------|
| ClassDescriptions.lsx | RootTemplates/ |
| Progressions.lsx | Content/[PAK]_BG3Wow/ |
| Data.txt | Stats/Generated/ |
| English.loca.xml | Localization/English/ |

---

## Tools Required

1. **LSLib v1.20.3+** (Patch 8 compatible)
2. **Text Editor** (VS Code recommended)
3. **BG3 Script Extender** (optional, for testing)
4. **BG3 Mod Manager**

---

## Next Immediate Steps

1. ✅ Create Status_Warrior.txt (16 statuses)
2. ✅ Create Passive_Warrior.txt (33 passives)
3. ✅ Create Spell_Warrior.txt (Demolish + base abilities)
4. ⏸️ Generate English.loca.xml (70+ handles)
5. ⏸️ Package into .pak and test in-game

---

## Validation Reports

### Completed Validations

1. **PATCH8_COMPATIBILITY_REPORT.md** - Patch 8 compatibility confirmed
2. **VALIDATION_REPORT_ActionResourceDefinitions.md** - 9/9 = 100%
3. **VALIDATION_REPORT_ClassDescriptions_v2.md** - 15/15 = 100%
4. **VALIDATION_REPORT_Specializations_FINAL.md** - 33/33 passives matched

---

## Documentation Structure

### 01_ProjectDocuments (16 files)
- CHARGE_IMPLEMENTATION_NOTES.md
- FILE_REFERENCE.md
- GETTING_STARTED.md
- PASSIVES_BREAKDOWN.md
- PASSIVES_COLOSSUS.md
- PASSIVES_MASTER.md
- PASSIVES_MOUNTAIN_THANE.md
- PASSIVES_SLAYER.md
- PROGRESSIONS_GENERATION_PLAN.md
- PROGRESSIONS_REFERENCE.md
- RESOURCES_BOOKMARKS.md
- SPECIALIZATIONS_REFERENCE.md
- TASK_TRACKER.md
- WARRIOR_LEVEL1_BREAKDOWN.md
- VALIDATION_REPORT_Specializations.md
- VALIDATION_REPORT_Specializations_FINAL.md

### 02_DesignDocuments (4 files)
- **Warrior_Class_Blueprint.json** (THIS FILE)
- BG3_Global_Rules.md
- Class Blueprint Template Full v1.md
- resource_kit_catalog_v_1.md

### 03_WoWSourceMaterial
- Fury_Warrior_Talents_Extracted.md
- Protection_Warrior_Talents_Extracted.md
- WoWhead HTML files

### 04_ResearchFindings
- PATCH8_COMPATIBILITY_REPORT.md
- RESEARCH_FINDINGS_BG3_Structure.md
- RESEARCH_FINDINGS_DeathKnight.md

### 05_ValidationReports
- VALIDATION_REPORT_ActionResourceDefinitions.md
- VALIDATION_REPORT_ClassDescriptions_v2.md

### 06_SessionSummaries
- SESSION_SUMMARY_Patch8_Validation.md

### 07_ReferenceMods
- WoWDeathKnightClass/
- WoWDeathKnightFix/
- WoWPriest/

---

## Current Status Summary

| Component | Status | Notes |
|-----------|--------|-------|
| **Progressions** | ✅ COMPLETE | L1-20 with specializations |
| **Class Descriptions** | ✅ COMPLETE | 4 nodes validated |
| **Action Resources** | ✅ COMPLETE | Rage resource defined |
| **Specializations** | ✅ DOCUMENTED | 33 passives ready |
| **Stats Files** | ⏸️ PENDING | Status/Passive/Spell txt files |
| **Localization** | ⏸️ PENDING | 70+ handles needed |
| **Testing** | ⏸️ PENDING | Awaiting Stats file implementation |

---

**Last Updated:** Based on JSON Blueprint v1.0  
**Implementation Progress:** ~65% (Core systems complete, abilities pending)  
**Ready for:** Stats file implementation and testing phase
