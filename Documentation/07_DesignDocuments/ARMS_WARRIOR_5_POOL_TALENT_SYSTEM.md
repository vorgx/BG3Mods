# Arms Warrior - Complete 5-Pool Talent System
**Date**: October 17, 2025  
**Version**: v2.0 Design Specification  
**Status**: Authoritative Design Document

---

## Executive Summary

The Arms Warrior uses a **5-pool talent system** modeled after World of Warcraft's The War Within (11.2) talent structure. This system provides deep customization through multiple parallel progression paths:

1. **Class Talents** (10 rows) - Warrior abilities shared by all 3 specs
2. **SubclassSpec Talents** (10 rows) - Arms-specific spec talents
3. **SubclassBase Talents** (Bucket/Pool) - Baseline Arms Warrior abilities
4. **Specialization: Colossus** (Hero talent tree) - Tank/defense-focused
5. **Specialization: Slayer** (Hero talent tree) - DPS/execution-focused

**Total Player Choices**: ~48 across 20 levels (9 Class + 9 SubclassSpec + 12 SubclassBase + ~18 Specialization)

### Specialization Availability Matrix

At Level 13, Warriors choose 1 of 2 specializations based on their base spec:

| Base Spec | Specialization Option 1 | Specialization Option 2 |
|-----------|------------------------|------------------------|
| **Arms** | **Colossus** (3 tiers) | **Slayer** (3 tiers) |
| **Fury** | **Mountain Thane** (4 tiers) | **Slayer** (3 tiers) |
| **Protection** | **Mountain Thane** (4 tiers) | **Colossus** (3 tiers) |

**Tier Structure**:
- **3-Tier Specializations** (Colossus, Slayer): Choice nodes at L15, L17, L19 (3 picks from 9 options)
- **4-Tier Specializations** (Mountain Thane): Choice nodes at L15, L16, L18, L19 (4 picks from 12 options)

**This document covers Arms Warrior specifically.** See `FURY_WARRIOR_5_POOL_TALENT_SYSTEM.md` and `PROTECTION_WARRIOR_5_POOL_TALENT_SYSTEM.md` for other specs.

---

## POOL 1: Class Talents (10 Rows)
**Type**: Row-based progression system  
**Scope**: Shared by Arms, Fury, and Protection Warriors  
**Progression**: Row 1 granted at L1, then pick 1 from next row every 2 levels

### Row 1 - Stance (Auto-Granted at L1)
**Battle Stance**
- **Type**: Passive
- **Effect**: Balanced stance for offensive combat
- **BG3 Implementation**: +5% damage dealt, -5% damage taken
- **Tags**: Stance, Offensive

**Defensive Stance**
- **Type**: Passive
- **Effect**: Defensive stance for tanking
- **BG3 Implementation**: +10% damage reduction, -10% damage dealt
- **Tags**: Stance, Defensive

### Row 2 - Early Utility (Pick 1 at L1)
**Fast Footwork**
- **Type**: Passive
- **Effect**: Increased movement speed
- **BG3 Implementation**: +3m movement speed
- **Tags**: Mobility

**War Machine**
- **Type**: Passive
- **Effect**: Rage generation on kill
- **BG3 Implementation**: Gain +20 Rage when you kill an enemy
- **Tags**: Resource, RageGeneration

**Leeching Strikes**
- **Type**: Passive
- **Effect**: Lifesteal on melee attacks
- **BG3 Implementation**: Heal for 5% of melee damage dealt
- **Tags**: Sustain, Healing

**Intervene**
- **Type**: Action
- **Effect**: Dash to ally and protect them
- **BG3 Implementation**:
  - Action, Jump to ally within 9m
  - Grant ally +2 AC for 2 turns
  - Recharge: Short Rest
- **Tags**: Mobility, Defense, Ally

### Row 3 - Mobility & Control (Pick 1 at L3)
**Impending Victory**
- **Type**: Action
- **Effect**: Melee attack that heals you
- **BG3 Implementation**:
  - Action, Melee Weapon Attack
  - Damage: 1d8 + Strength modifier
  - Heal: 1d8 + Constitution modifier
  - Costs: 10 Rage
- **Tags**: Sustain, MeleeWeapon

**Heroic Leap**
- **Type**: Action
- **Effect**: Leap to location with AoE damage
- **BG3 Implementation**:
  - Action, Jump (12m range)
  - Land and deal 1d8 + STR to all enemies within 3m
  - Recharge: Short Rest
- **Tags**: Mobility, AoE, Jump

**Storm Bolt**
- **Type**: Action
- **Effect**: Ranged stun
- **BG3 Implementation**:
  - Action, Ranged Attack (18m)
  - Damage: 1d10 + Strength modifier
  - Apply Stunned for 1 turn (Constitution Save DC 8+Prof+STR)
  - Recharge: Short Rest (2 turns)
- **Tags**: Control, Ranged, Stun

### Row 4 - Advanced Utility (Pick 1 at L5)
**Intimidating Shout**
- **Type**: Action
- **Effect**: AoE fear
- **BG3 Implementation**:
  - Action, AoE Control (4m radius)
  - Apply Frightened for 1 turn (Wisdom Save DC 8+Prof+STR)
  - Recharge: Short Rest (3 turns)
- **Tags**: Control, AoE, Fear

**Second Wind**
- **Type**: Bonus Action
- **Effect**: Self-heal
- **BG3 Implementation**:
  - Bonus Action, Self-heal
  - Heal: 2d10 + level HP
  - Recharge: Short Rest (3 turns)
- **Tags**: Sustain, Healing

**Frothing Berserker**
- **Type**: Passive
- **Effect**: Occasional Rage refund
- **BG3 Implementation**: 15% chance to refund Rage spent on abilities
- **Tags**: Resource, RageGeneration

**Bounding Stride**
- **Type**: Passive
- **Effect**: Heroic Leap improvement
- **BG3 Implementation**: Heroic Leap range increased to 18m and you gain +3m movement for 2 turns after landing
- **Tags**: Mobility

**Pain and Gain**
- **Type**: Passive
- **Effect**: Chip self-heal over time
- **BG3 Implementation**: Heal 1d4 HP at start of your turn while in combat
- **Tags**: Sustain, Healing

**Thunder Clap**
- **Type**: Action
- **Effect**: AoE damage + slow
- **BG3 Implementation**:
  - Action, AoE Attack (4m radius)
  - Damage: 2d6 + Strength to all targets
  - Reduce movement speed by 20% for 3 turns
  - Costs: 10 Rage
- **Tags**: AoE, Control, Slowing

### Row 5 - Advanced Control (Pick 1 at L7)
**Cacophonous Roar**
- **Type**: Action
- **Effect**: AoE fear/taunt mix
- **BG3 Implementation**:
  - Action, AoE Control (5m radius)
  - Enemies with <50% HP: Frightened for 2 turns
  - Enemies with >=50% HP: Taunted (disadvantage on attacks not targeting you) for 2 turns
  - Recharge: Long Rest
- **Tags**: Control, AoE, Fear, Taunt

**Menace**
- **Type**: Action
- **Effect**: AoE knockback
- **BG3 Implementation**:
  - Action, AoE Control (4m radius)
  - Push all enemies 3m away (Strength Save DC 8+Prof+STR)
  - Recharge: Short Rest
- **Tags**: Control, AoE, Knockback

**Spell Reflection**
- **Type**: Reaction
- **Effect**: Reflect spell back to caster
- **BG3 Implementation**:
  - Reaction (when targeted by spell)
  - Reflect spell back to caster, you take no damage
  - Recharge: Short Rest
- **Tags**: Defense, Reaction, Reflect

**Rallying Cry**
- **Type**: Bonus Action
- **Effect**: Party temp HP
- **BG3 Implementation**:
  - Bonus Action, AoE Buff (9m radius)
  - All allies gain Temp HP: 2d8 + your level
  - Recharge: Short Rest
- **Tags**: Team-Defense, AoE, TempHP

**Shockwave**
- **Type**: Action
- **Effect**: Cone stun
- **BG3 Implementation**:
  - Action, Cone Attack (5m cone)
  - Damage: 2d8 + Strength to all targets
  - Apply Stunned for 1 turn (Constitution Save DC 8+Prof+STR)
  - Recharge: Long Rest
- **Tags**: Control, AoE, Stun

**Crackling Thunder**
- **Type**: Passive
- **Effect**: Thunder Clap improvement
- **BG3 Implementation**: Thunder Clap radius increased to 6m and can hit 2 additional targets
- **Tags**: AoE

### Row 6 - Enhancement Passives (Pick 1 at L9)
**Honed Reflexes**
- **Type**: Passive
- **Effect**: Cooldown reduction on defensive abilities
- **BG3 Implementation**: Defensive abilities recharge 1 turn faster
- **Tags**: CDR, Defensive

**Crushing Force**
- **Type**: Passive
- **Effect**: Slam damage increase
- **BG3 Implementation**: Slam deals +1d6 damage
- **Tags**: Damage

**Bitter Immunity**
- **Type**: Bonus Action
- **Effect**: Cleanse + small heal
- **BG3 Implementation**:
  - Bonus Action, Self-cleanse
  - Remove 1 poison/disease, heal 1d6 HP
  - Recharge: Short Rest
- **Tags**: Cleanse, Healing

**Overwhelming Rage**
- **Type**: Passive
- **Effect**: Increased Rage capacity
- **BG3 Implementation**: Maximum Rage increased to 120 (from 100)
- **Tags**: Resource

**Rumbling Earth**
- **Type**: Passive
- **Effect**: Shockwave upgrades
- **BG3 Implementation**: Shockwave stun duration increased to 2 turns and cone length increased to 7m
- **Tags**: Control, AoE

**Reinforced Plates**
- **Type**: Passive
- **Effect**: AC increase
- **BG3 Implementation**: +1 AC
- **Tags**: Defense

### Row 7 - Tactical Options (Pick 1 at L11)
**Wrecking Throw**
- **Type**: Action
- **Effect**: Break physical shields/barriers
- **BG3 Implementation**:
  - Action, Ranged Attack (18m)
  - Damage: 2d8 + Strength
  - Remove Shield of Faith, Mage Armor, etc.
  - Recharge: Short Rest
- **Tags**: Utility, Ranged

**Shattering Throw**
- **Type**: Action
- **Effect**: Break magic shields
- **BG3 Implementation**:
  - Action, Ranged Attack (18m)
  - Damage: 1d8 + Strength
  - Remove magical shields and reduce target's AC by 2 for 3 turns
  - Recharge: Short Rest
- **Tags**: Utility, Ranged, Debuff

**Barbaric Training**
- **Type**: Passive
- **Effect**: Slam/Cleave damage increase
- **BG3 Implementation**: Slam and Cleave deal +25% damage
- **Tags**: Damage

**Sidearm**
- **Type**: Passive
- **Effect**: Off-hand throw proc
- **BG3 Implementation**: 20% chance on melee hit to throw weapon at enemy within 6m (1d6 damage, bonus action cost)
- **Tags**: Proc, Ranged

**Double Time**
- **Type**: Passive
- **Effect**: Charge improvement
- **BG3 Implementation**: Charge gains 2 charges and range increased to 18m
- **Tags**: Mobility

**Seismic Reverberation**
- **Type**: Passive
- **Effect**: AoE follow-up on abilities
- **BG3 Implementation**: When you use Shockwave or Thunder Clap, deal 1d6 damage to all enemies within 3m at start of your next turn
- **Tags**: AoE, Proc

**Concussive Blows**
- **Type**: Passive
- **Effect**: Stun duration increase
- **BG3 Implementation**: Your stun effects last 1 additional turn
- **Tags**: Control

**Berserker Shout**
- **Type**: Bonus Action
- **Effect**: Cleanse fear/charm
- **BG3 Implementation**:
  - Bonus Action, Self-cleanse
  - Remove fear, charm, and incapacitate effects
  - Recharge: Short Rest
- **Tags**: Cleanse

**Piercing Howl**
- **Type**: Action
- **Effect**: AoE slow shout
- **BG3 Implementation**:
  - Action, AoE Control (6m radius)
  - Reduce movement speed by 50% for 4 turns
  - Recharge: Short Rest
- **Tags**: Control, AoE, Slow

### Row 8 - Combat Passives (Pick 1 at L13)
**Cruel Strikes**
- **Type**: Passive
- **Effect**: Critical hit chance increase
- **BG3 Implementation**: Critical hit range increased by 1 (19-20)
- **Tags**: Crit

**Wild Strikes**
- **Type**: Passive
- **Effect**: Attack speed increase
- **BG3 Implementation**: +10% attack speed (extra attack on natural 20)
- **Tags**: Haste

**Two-Handed Weapon Specialization**
- **Type**: Passive
- **Effect**: Damage increase with 2H weapons
- **BG3 Implementation**: +2 damage with two-handed melee weapons
- **Tags**: Weapon, Damage

**Armored to the Teeth**
- **Type**: Passive
- **Effect**: Damage from armor
- **BG3 Implementation**: +1 damage per point of AC from armor
- **Tags**: Damage, Defense

### Row 9 - Major Cooldowns (Pick 1 at L15)
**Thunderous Roar**
- **Type**: Action
- **Effect**: AoE Bleed shout
- **BG3 Implementation**:
  - Action, AoE Attack (6m radius)
  - Apply Bleeding: 2d6 damage per turn for 4 turns to all enemies
  - Recharge: Short Rest (3 turns)
- **Tags**: AoE, Bleed, DoT

**Avatar**
- **Type**: Bonus Action
- **Effect**: Transform into avatar of war
- **BG3 Implementation**:
  - Bonus Action, Self-buff
  - Duration: 4 turns
  - Effect: +4 Strength, +2 AC, Immune to fear/charm, generate +50% Rage
  - Recharge: Long Rest
- **Tags**: Buff, Transformation

**Champion's Spear**
- **Type**: Action
- **Effect**: Throw spear creating damage zone
- **BG3 Implementation**:
  - Action, Ranged Attack (18m)
  - Create 4m radius zone for 4 turns
  - Enemies in zone take +10% damage from you and +1d6 damage at start of their turn
  - Recharge: Short Rest (3 turns)
- **Tags**: Zone, Debuff, Ranged

### Row 10 - Capstones (Pick 1 at L17)
**Uproar**
- **Type**: Passive
- **Effect**: Thunderous Roar enhancement
- **BG3 Implementation**: Thunderous Roar bleed damage increased to 3d6 per turn and lasts 6 turns

**Thunderous Words**
- **Type**: Passive
- **Effect**: Shout ability enhancement
- **BG3 Implementation**: All shout abilities (Battle Shout, Intimidating Shout, etc.) have +50% radius

**Warlord's Torment**
- **Type**: Passive
- **Effect**: Avatar enhancement
- **BG3 Implementation**: Avatar grants +6 Strength (instead of +4) and lasts 6 turns (instead of 4)

**Blademaster's Torment**
- **Type**: Passive
- **Effect**: Weapon specialization enhancement
- **BG3 Implementation**: Critical hits with weapon attacks deal +1d8 damage

**Piercing Challenge**
- **Type**: Action
- **Effect**: Single-target debuff
- **BG3 Implementation**:
  - Action, Single-target debuff (18m range)
  - Target takes +15% damage from all sources for 4 turns
  - Recharge: Short Rest (2 turns)
- **Tags**: Debuff, SingleTarget

**Champion's Might**
- **Type**: Passive
- **Effect**: General power increase
- **BG3 Implementation**: +2 Strength, +5% damage dealt

---

## POOL 2: SubclassSpec Talents (10 Rows - Arms)
**Type**: Row-based progression system  
**Scope**: Arms Warrior only  
**Progression**: Row 1 granted at L1 (with spec), then pick 1 from next row every 2 levels

### Row 1 - Signature Ability (Auto-Granted at L1)
**Mortal Strike (MS)**
- **Type**: Action
- **Effect**: Signature Arms ability with healing reduction
- **BG3 Implementation**:
  - Action, Melee Weapon Attack
  - Damage: 2d10 + Strength modifier
  - Apply Mortal Wound: Target receives -50% healing for 2 turns
  - Costs: 30 Rage
  - Cooldown: OncePerTurn
- **Tags**: MeleeWeapon, SingleTarget, HealingReduction
- **Icon**: ability_warrior_savageblow.gif

### Row 2 - Secondary Attack (Pick 1 at L1)
**Overpower (OP)**
- **Type**: Action
- **Effect**: Overwhelm defenses with crushing blow
- **BG3 Implementation**:
  - Bonus Action, Melee Weapon Attack
  - Damage: 1d12 + Strength modifier
  - Ignore 50% of target's AC (treat as if AC is halved)
  - Costs: 20 Rage
- **Tags**: MeleeWeapon, SingleTarget, ArmorPierce
- **Icon**: ability_meleedamage.gif

**Rend**
- **Type**: Action
- **Effect**: Apply strong bleed effect
- **BG3 Implementation**:
  - Action, Melee Weapon Attack
  - Damage: 1d6 + Strength initial
  - Apply Rend: 2d6 Bleeding per turn for 5 turns
  - Costs: 10 Rage
- **Tags**: MeleeWeapon, Bleed, DoT
- **Icon**: ability_gouge.gif

### Row 3 - Overpower Enhancements (Pick 1 at L3)
**Improved Overpower**
- **Type**: Passive
- **Effect**: Overpower reliability
- **BG3 Implementation**: Overpower gains +1d6 damage and 2 charges
- **Tags**: Enhancement

**Dreadnaught**
- **Type**: Passive
- **Effect**: Overpower power increase
- **BG3 Implementation**: Overpower deals +25% damage and reduces target's damage by -10% for 2 turns
- **Tags**: Enhancement, Debuff

**Skullsplitter**
- **Type**: Action
- **Effect**: Rage generator strike
- **BG3 Implementation**:
  - Bonus Action, Melee Weapon Attack
  - Damage: 1d10 + Strength
  - Generate +20 Rage
  - Cooldown: OncePerTurn
- **Tags**: MeleeWeapon, RageGenerator
- **Icon**: ability_criticalstrike.gif

**Die by the Sword**
- **Type**: Action
- **Effect**: Parry all attacks
- **BG3 Implementation**:
  - Bonus Action, Self-buff
  - Parry all melee attacks for 3 turns
  - Recharge: Long Rest
- **Tags**: Defensive, SelfBuff
- **Icon**: ability_warrior_defensivestance.gif

### Row 4 - Execute Enhancements (Pick 1 at L5)
**Massacre**
- **Type**: Passive
- **Effect**: Execute available earlier
- **BG3 Implementation**: Execute can be used when target is below 35% HP (instead of 20%)
- **Tags**: Enhancement, Execute
- **Icon**: inv_sword_48.gif

**Improved Execute**
- **Type**: Passive
- **Effect**: Execute more lethal
- **BG3 Implementation**: Execute deals +50% damage and costs -10 Rage
- **Tags**: Enhancement, Execute

### Row 5 - Major Unlocks (Pick 1 at L7)
**Colossus Smash (CS)**
- **Type**: Action
- **Effect**: Devastating armor-shattering strike
- **BG3 Implementation**:
  - Action, Melee Weapon Attack
  - Damage: 3d8 + Strength
  - Apply Shattered Defenses: -3 AC for 3 turns
  - Costs: 40 Rage
  - Recharge: Short Rest
- **Tags**: MeleeWeapon, SingleTarget, ArmorDebuff
- **Icon**: ability_warrior_colossussmash.gif

**Sweeping Strikes (SS)**
- **Type**: Action
- **Effect**: Cleave buff for next attacks
- **BG3 Implementation**:
  - Bonus Action, Self-buff
  - Duration: 2 turns or 2 attacks
  - Effect: Next 2 single-target melee attacks cleave to 1 additional enemy (50% damage)
  - Recharge: Short Rest
- **Tags**: Buff, Cleave, AoE
- **Icon**: ability_warrior_cleave.gif

**Juggernaut**
- **Type**: Passive
- **Effect**: Execute reduces armor
- **BG3 Implementation**: Execute applies Sundered Armor (-2 AC) for 3 turns
- **Tags**: Enhancement, Execute, Debuff

### Row 6 - Combat Enhancements (Pick 1 at L9)
**Crushing Force**
- **Type**: Passive
- **Effect**: Strength boost after Colossus Smash
- **BG3 Implementation**: After using Colossus Smash, gain +2 Strength for 4 turns
- **Tags**: Buff

**Endurance Training**
- **Type**: Passive
- **Effect**: Stamina and armor increase
- **BG3 Implementation**: +10% Maximum HP and +1 AC
- **Tags**: Defense, HP

**Exhilarating Blows**
- **Type**: Passive
- **Effect**: Overpower generates Rage
- **BG3 Implementation**: Overpower generates +5 Rage when it hits
- **Tags**: RageGeneration

**Storm of Swords**
- **Type**: Passive
- **Effect**: Whirlwind improvement
- **BG3 Implementation**: Whirlwind costs -5 Rage and buff lasts +1 turn
- **Tags**: Enhancement, AoE

### Row 7 - Advanced Mechanics (Pick 1 at L11)
**Warbreaker (WB)**
- **Type**: Action
- **Effect**: Powerful AoE armor shatter
- **BG3 Implementation**:
  - Action, Cone Attack (5m cone)
  - Damage: 4d10 + Strength to all targets
  - Apply Sundered Armor (-2 AC) to all for 3 turns
  - Costs: 40 Rage
  - Recharge: Long Rest
- **Tags**: MeleeWeapon, AoE, ArmorDebuff
- **Icon**: inv_warbreaker.gif

**Bloodletting**
- **Type**: Passive
- **Effect**: Bleed damage increase
- **BG3 Implementation**: Bleeding effects you apply deal +30% damage
- **Tags**: Enhancement, Bleed

**Martial Prowess**
- **Type**: Passive
- **Effect**: Overpower crit increase
- **BG3 Implementation**: Overpower critical hit range increased by 2 (18-20)
- **Tags**: Crit

**Unhinged**
- **Type**: Passive
- **Effect**: Sweeping Strikes enhancement
- **BG3 Implementation**: While Sweeping Strikes active, deal +20% damage with all attacks
- **Tags**: Enhancement, Buff

**Valor in Victory**
- **Type**: Passive
- **Effect**: Execute healing
- **BG3 Implementation**: Execute heals you for 5% max HP when it kills an enemy
- **Tags**: Sustain, Execute

**Honed Reflexes**
- **Type**: Passive
- **Effect**: Die by the Sword improvement
- **BG3 Implementation**: Die by the Sword duration increased to 5 turns and you gain Riposte (counterattack on parry)
- **Tags**: Defensive

### Row 8 - Major Cooldowns (Pick 1 at L13)
**Avatar**
- **Type**: Bonus Action
- **Effect**: Transform into avatar of war
- **BG3 Implementation**:
  - Bonus Action, Self-buff
  - Duration: 4 turns
  - Effect: +4 Strength, +2 AC, Immune to fear/charm, generate +50% Rage
  - Recharge: Long Rest
- **Tags**: Buff, Transformation
- **Icon**: warrior_talent_icon_avatar.gif

**Bladestorm (BS)**
- **Type**: Action
- **Effect**: Become a whirlwind of steel
- **BG3 Implementation**:
  - Action, AoE Attack (3m radius)
  - Duration: 4 turns (channeled)
  - Damage: 2d8 + Strength per turn to all within 3m
  - Cannot be interrupted
  - Recharge: Long Rest
- **Tags**: AoE, Channeled
- **Icon**: ability_warrior_bladestorm.gif

**Test of Might**
- **Type**: Passive
- **Effect**: Warbreaker grants Strength
- **BG3 Implementation**: When you use Warbreaker, gain +2 Strength for 5 turns
- **Tags**: Buff

**Improved Sweeping Strikes**
- **Type**: Passive
- **Effect**: Sweeping Strikes better
- **BG3 Implementation**: Sweeping Strikes lasts 3 attacks (instead of 2) and cleave damage increased to 75%
- **Tags**: Enhancement

**Anger Management (AM)**
- **Type**: Passive
- **Effect**: Cooldown reduction via Rage
- **BG3 Implementation**: Spending 20 Rage reduces Avatar and Bladestorm cooldowns by 1 turn each
- **Tags**: CDR, Resource

### Row 9 - Execute Phase (Pick 1 at L15)
**Fatality**
- **Type**: Passive
- **Effect**: Execute auto-crit
- **BG3 Implementation**: Execute automatically critically hits when target is below 20% HP
- **Tags**: Execute, Crit

**Bloodborne**
- **Type**: Passive
- **Effect**: Major bleed damage increase
- **BG3 Implementation**: Bleeding effects you apply deal +25% damage (stacks with Bloodletting for +55% total)
- **Tags**: Enhancement, Bleed

### Row 10 - Capstones (Pick 1 at L17)
**Executioner's Precision**
- **Type**: Passive
- **Effect**: Execute strikes additional targets
- **BG3 Implementation**: Execute now cleaves to 2 additional nearby targets for 50% damage
- **Tags**: Execute, AoE

**Unrelenting Assault**
- **Type**: Passive
- **Effect**: Bladestorm damage increase
- **BG3 Implementation**: During Bladestorm, all your attacks deal +30% damage
- **Tags**: Enhancement, AoE

**Champion's Might**
- **Type**: Passive
- **Effect**: Avatar becomes stronger
- **BG3 Implementation**: Avatar grants +6 Strength (instead of +4) and lasts 6 turns (instead of 4)
- **Tags**: Enhancement, Buff

**Deadly Calm**
- **Type**: Action
- **Effect**: Rage efficiency cooldown
- **BG3 Implementation**:
  - Bonus Action, Self-buff
  - Duration: 3 turns
  - Effect: All abilities cost 0 Rage
  - Recharge: Short Rest
- **Tags**: Buff, ResourceManagement
- **Icon**: spell_holy_painsupression.gif

---

## POOL 3: SubclassBase Talents (Bucket/Pool - Baseline Abilities)
**Type**: Auto-granted progression system  
**Scope**: Arms Warrior only  
**Progression**: Abilities granted automatically at specific levels (L3-L12)  
**Total Abilities**: 12 baseline abilities

**Design Philosophy**: Each subclass receives the same 12 abilities but in different orders to support their unique playstyle. Arms focuses on two-handed precision strikes and executes.

### Arms Progression Order (L3-L12)

1. **Whirlwind (L3)** - AoE cleave identity from the start
2. **Execute (L4)** - Arms specialty finisher (earlier than other specs)
3. **Hamstring (L5)** - Tactical slow for precision control
4. **Slam (L6)** - Basic filler damage
5. **Charge (L7)** - Gap closer for engagement
6. **Victory Rush (L8)** - Sustain tool
7. **Heroic Throw (L9)** - Ranged pull utility
8. **Shield Slam (L10)** - Shield utility option (1H+shield builds)
9. **Pummel (L11)** - Interrupt
10. **Battle Shout (L12)** - Party buff
11. **Berserker Rage (L12)** - Cleanse
12. **Taunt (L12)** - Utility

### Detailed Ability Descriptions

**Note**: All 12 abilities are shared across Arms/Fury/Protection, only the unlock order differs per spec.

### Offensive Abilities (7 total)

**1. Whirlwind (WW)**
- **Type**: Action (AoE attack)
- **Effect**: Primary multitarget attack
- **BG3 Implementation**:
  - Action, Cone Attack (5m cone)
  - Damage: 1d8 + Strength to all targets
  - Apply Whirlwind buff: Next 2 single-target attacks cleave to 1 additional target
  - Costs: 10 Rage
- **Tags**: AoE, MeleeWeapon, Cleave
- **Icon**: ability_whirlwind.gif
- **Status**: ✅ EXISTS (`Zone_WAR_Whirlwind` in Spell_Zone.txt line 142)

**2. Slam**
- **Type**: Action
- **Effect**: Initial rage spender, quickly replaced by other abilities
- **BG3 Implementation**:
  - Action, Melee Weapon Attack
  - Damage: 2d6 + Strength
  - Costs: 15 Rage
- **Tags**: MeleeWeapon, BasicAttack
- **Icon**: ability_warrior_decisivestrike.gif
- **Status**: ✅ EXISTS (`Target_WAR_Slam` in Spell_Target.txt line 775)

**3. Shield Slam**
- **Type**: Action
- **Effect**: Early offensive ability, replaced upon specializing
- **BG3 Implementation**:
  - Action, Melee Weapon Attack
  - Damage: 3d8 + Strength
  - Bonus damage if Shield Block active (+30%)
  - Generate +15 Rage
  - Requires: Shield equipped
- **Tags**: MeleeWeapon, RageGenerator, Shield
- **Icon**: inv_shield_05.gif
- **Status**: ✅ EXISTS (`Target_WAR_ShieldSlam` in Spell_Target.txt line 69)

**4. Hamstring**
- **Type**: Action
- **Effect**: Minor snare
- **BG3 Implementation**:
  - Bonus Action, Melee Weapon Attack
  - Damage: 1d6 + Strength
  - Apply Hamstrung: Reduce movement speed by 50% for 3 turns
- **Tags**: MeleeWeapon, Slow, Control
- **Icon**: ability_gouge.gif
- **Status**: ✅ EXISTS (`Target_WAR_Hamstring` in Spell_Target.txt line 659)

**5. Victory Rush (VR)**
- **Type**: Action
- **Effect**: Very useful free heal after getting a kill
- **BG3 Implementation**:
  - Bonus Action, Melee Weapon Attack
  - Damage: 1d8 + Strength
  - Heal: 2d8 + level HP
  - Requires: Victorious buff (granted when you kill an enemy)
  - Duration: Victorious lasts 2 turns after kill
- **Tags**: MeleeWeapon, Healing, Conditional
- **Icon**: ability_warrior_victoryrush.gif
- **Status**: ✅ EXISTS (`Target_WAR_VictoryRush` in Spell_Target.txt line 695 + Passive enabler)

**6. Execute (Exe)**
- **Type**: Action
- **Effect**: Arms' version of Execute
- **BG3 Implementation**:
  - Action, Melee Weapon Attack
  - Only usable on targets below 20% HP (or 35% with Massacre talent)
  - Damage: 4d12 + Strength (scales with Rage spent, up to 40 Rage)
  - Costs: 20-40 Rage (more spent = more damage)
- **Tags**: MeleeWeapon, Execute, SingleTarget
- **Icon**: inv_sword_48.gif
- **Status**: ✅ EXISTS (`Target_WAR_Execute` in Spell_Target.txt line 29)

**7. Heroic Throw (HT)**
- **Type**: Action
- **Effect**: Pitifully low damage ranged attack, only appropriate for pulling from a distance
- **BG3 Implementation**:
  - Action, Ranged Weapon Attack (18m)
  - Damage: MainMeleeWeapon damage (1d6-1d12 depending on weapon)
  - Execute weapon functors (apply weapon enchantments)
- **Tags**: Ranged, Weapon, Pulling
- **Icon**: inv_throwingaxe_06.gif
- **Status**: ✅ EXISTS (`Projectile_WAR_HeroicThrow` in Spell_Projectile.txt line 9)

### Utility Abilities (5 total)

**8. Charge**
- **Type**: Action
- **Effect**: Primary mobility and gap closer
- **BG3 Implementation**:
  - Action, Jump (18m range to target enemy)
  - Damage: 1d4 + Strength
  - Apply Off Balance (disadvantage on next attack) for 2 turns
  - Generate +20 Rage
- **Tags**: Mobility, Gap Closer, Jump
- **Icon**: ability_warrior_charge.gif
- **Status**: ✅ EXISTS (`Target_WAR_Charge` in Spell_Target.txt line 271 + Jump component)

**9. Pummel**
- **Type**: Action
- **Effect**: Low cooldown interrupt
- **BG3 Implementation**:
  - Bonus Action, Melee Weapon Attack (melee range only)
  - Damage: 1d4 + Strength
  - Apply Interrupted: Silenced for 1 turn (cannot cast spells)
  - Cooldown: 1 turn
- **Tags**: Control, Interrupt, MeleeWeapon
- **Icon**: inv_gauntlets_04.gif
- **Status**: ✅ EXISTS (`Target_WAR_Pummel` in Spell_Target.txt line 739)

**10. Battle Shout (Shout)**
- **Type**: Action
- **Effect**: Worth ~5% damage for melee classes and Hunters
- **BG3 Implementation**:
  - Bonus Action, AoE Buff (9m radius)
  - Effect: +2 to attack rolls and damage rolls for all allies for 5 turns
  - Recharge: Short Rest
- **Tags**: Buff, AoE, Party, Shout
- **Icon**: ability_warrior_battleshout.gif
- **Status**: ✅ EXISTS (`Shout_WAR_BattleShout` in Spell_Shout.txt line 13)

**11. Berserker Rage (BzR)**
- **Type**: Action
- **Effect**: Preemptive or reactive CC removal
- **BG3 Implementation**:
  - Bonus Action, Self-cleanse
  - Remove fear, charm, sap, and incapacitate effects
  - Grant immunity to those effects for 6 turns
  - Recharge: Short Rest
- **Tags**: Cleanse, Defensive, SelfBuff
- **Icon**: racial_orc_berserkerstrength.gif (or spell_nature_shamanrage.gif)
- **Status**: ✅ EXISTS (`Target_WAR_BerserkerRage` in Spell_Target.txt line 814 + status)

**12. Taunt**
- **Type**: Action
- **Effect**: Draws aggro and generally gets you killed
- **BG3 Implementation**:
  - Action, Single-target debuff (9m range)
  - Apply Taunted: Target has disadvantage on attacks not targeting you for 2 turns
  - Useful for tanking/protecting allies
- **Tags**: Control, Taunt, SingleTarget
- **Icon**: spell_nature_reincarnation.gif (or ability_fomor_boss_shout.gif)
- **Status**: ✅ EXISTS (`Target_WAR_Taunt` in Spell_Target.txt line 962 + WAR_TAUNTED status)

### Comparison: Fury & Protection Progression Orders

**Fury Baseline Abilities (Dual-Wield DPS):**
1. Whirlwind (L3) - Dual-wield AoE
2. Slam (L4) - Fast filler
3. Berserker Rage (L5) - **Enrage mechanic early (core to Fury)**
4. Charge (L6) - Early mobility
5. Victory Rush (L7) - Sustain
6. Execute (L8) - Execute phase
7. Heroic Throw (L9) - Ranged utility
8. Hamstring (L10) - Utility slow
9. Pummel (L11) - Interrupt
10. Battle Shout (L12) - Party buff
11. Taunt (L12) - Off-spec utility
12. Shield Slam (L12) - Off-spec utility

**Protection Baseline Abilities (Shield Tank):**
1. Taunt (L3) - **Core tanking tool early**
2. Shield Slam (L4) - Shield damage
3. Heroic Throw (L5) - Ranged pull
4. Charge (L6) - Gap closer
5. Pummel (L7) - Interrupt (critical for tanks)
6. Slam (L8) - Filler
7. Execute (L9) - Threat spike
8. Victory Rush (L10) - Sustain
9. Whirlwind (L11) - AoE threat
10. Battle Shout (L12) - Party buff
11. Hamstring (L12) - Utility slow
12. Berserker Rage (L12) - Cleanse

**Key Differences:**
- **Arms gets Execute at L4** (specialty), Protection/Fury get it L8-L9
- **Fury gets Berserker Rage at L5** (enrage identity), Arms/Prot get it L12
- **Protection gets Taunt at L3** (tank identity), Arms/Fury get it L12

### Implementation Status
✅ **ALL 12 BASELINE ABILITIES ALREADY EXIST** - No new spell creation needed!

**Required Work**: Create subclass-specific Progressions.lsx entries with different unlock levels per spec

**Implementation Method**: Use `PassivesAdded` or `Boosts="UnlockSpell(...)"` at appropriate levels in each subclass progression

---

## POOL 4: Specialization - Colossus (Hero Talent Tree)
**Type**: Hero talent specialization (tank/defense focus)  
**Scope**: Arms OR Protection Warriors  
**Unlock**: Level 13 (Arms: choose Colossus OR Slayer | Protection: choose Colossus OR Mountain Thane)  
**Progression**: Keystone + Capstone + **3 Choice Tiers (L15, L17, L19)** + 4 Passives

### Key Talent (Granted at L13)

**Demolish**
- **Type**: Action
- **Effect**: Very powerful three-hit combo, slowing movement speed by 99%. Defensive and mobility abilities do not interrupt the attack
- **BG3 Implementation**:
  - Action, Channeled Attack (4 turns)
  - Hit 1: 2d12 + Strength
  - Hit 2: 2d12 + Strength
  - Hit 3: 4d12 + Strength (finisher)
  - Total: 8d12 + (3 × Strength) damage
  - Apply Crushed: Reduce movement speed by 99% for 3 turns
  - While channeling: Take -10% damage, immune to stuns/knockbacks
  - Can block, parry, dodge while channeling
  - Costs: 40 Rage
  - Recharge: Long Rest
- **Tags**: Channeled, MeleeWeapon, Control, Defensive
- **Icon**: inv_ability_colossuswarrior_demolish.gif

### Capstone Talent (Granted at L20)

**Dominance of the Colossus**
- **Type**: Passive
- **Effect**: Grants cooldown reduction and applies a debuff that increases all damage dealt, including that of the Demolish that applies it
- **BG3 Implementation**:
  - **Colossal Might Stacks**: When you use Shield Slam or Demolish, gain Colossal Might (+2% damage, stacks up to 10 times, lasts 12 turns)
  - **Demolish CDR**: If you would gain Colossal Might at max stacks, reduce Demolish cooldown by 2 turns instead
  - **Dominated Debuff**: Enemies hit by Demolish take +10% damage from all sources for 4 turns
- **Tags**: Passive, Enhancement, CDR, Debuff
- **Icon**: ability_warrior_titansgrip.gif

### Choice Node 1 (Pick 1 at L15)

**Boneshaker**
- **Type**: Passive
- **Effect**: Shield Slam enhancement
- **BG3 Implementation**: Shield Slam deals +1d8 damage and applies Shaken (target has disadvantage on saving throws) for 2 turns
- **Tags**: Enhancement, Shield, Debuff
- **Icon**: ability_warrior_shieldreflection.gif

**Colossal Might (Passive Enhancement)**
- **Type**: Passive
- **Effect**: Demolish power increase
- **BG3 Implementation**: Demolish's final hit (Hit 3) deals +50% damage and grants you temporary HP equal to 10% of damage dealt
- **Tags**: Enhancement, TempHP
- **Icon**: warrior_talent_icon_avatar.gif

**One-Handed Weapon Specialization**
- **Type**: Passive
- **Effect**: Damage increase when using 1H+Shield
- **BG3 Implementation**: +3 damage with one-handed melee weapons when shield is equipped, +1 AC
- **Tags**: Weapon, Shield, Defense
- **Icon**: inv_sword_27.gif

### Choice Node 2 (Pick 1 at L17)

**Arterial Bleed**
- **Type**: Passive
- **Effect**: Demolish applies powerful bleed
- **BG3 Implementation**: Demolish applies Deep Wounds: 3d6 Bleeding damage per turn for 5 turns to primary target
- **Tags**: Bleed, DoT
- **Icon**: ability_warrior_bloodsurge.gif

**Practiced Strikes**
- **Type**: Passive
- **Effect**: Colossal Might stacks faster
- **BG3 Implementation**: Gain 2 stacks of Colossal Might per Shield Slam (instead of 1)
- **Tags**: Enhancement, Stacking
- **Icon**: ability_warrior_weaponmastery.gif

**Unstoppable Force**
- **Type**: Passive
- **Effect**: While channeling Demolish, cannot be stopped
- **BG3 Implementation**: While channeling Demolish, you are immune to all control effects (stun, fear, charm, etc.) and cannot be forced to move
- **Tags**: Control Immunity, Defensive
- **Icon**: ability_warrior_stalwartprotector.gif

### Choice Node 3 (Pick 1 at L19)

**Earthquaker**
- **Type**: Passive
- **Effect**: Demolish becomes AoE
- **BG3 Implementation**: Demolish's finisher hit (Hit 3) deals AoE damage in 3m radius (50% damage to secondary targets)
- **Tags**: AoE, Enhancement
- **Icon**: spell_nature_earthquake.gif

**Walls of Iron**
- **Type**: Passive
- **Effect**: Defensive enhancement
- **BG3 Implementation**: While you have 5+ stacks of Colossal Might, gain +3 AC and resistance to physical damage
- **Tags**: Defense, AC, Resistance
- **Icon**: inv_chest_plate04.gif

**Mountain of Muscle and Scars**
- **Type**: Passive
- **Effect**: General damage/defense, and almost unnoticeable size increase
- **BG3 Implementation**: You deal +5% damage and take -5% damage. Size increased by 5% (cosmetic)
- **Tags**: Damage, Defense, Passive
- **Icon**: ability_warrior_intensifyrage.gif

### Passives (Granted L13-L20, one per level until exhausted)

**Colossal Endurance** (L14)
- **Type**: Passive
- **Effect**: HP increase
- **BG3 Implementation**: +15% Maximum HP
- **Tags**: HP, Defense

**Shield Mastery** (L16)
- **Type**: Passive
- **Effect**: Shield Block improvement
- **BG3 Implementation**: Shield Block grants +3 AC (instead of +2) and lasts 3 turns (instead of 2)
- **Tags**: Shield, Defense

**Demolishing Charge** (L18)
- **Type**: Passive
- **Effect**: Charge enhancement
- **BG3 Implementation**: Charge generates +10 Rage and reduces Demolish cooldown by 1 turn when used
- **Tags**: Mobility, CDR

**Titanic Fury** (L20)
- **Type**: Passive
- **Effect**: Rage generation enhancement
- **BG3 Implementation**: Generate +5 Rage when you take damage from attacks (max 3 procs per turn)
- **Tags**: RageGeneration, Defensive

---

## POOL 5: Specialization - Slayer (Hero Talent Tree)
**Type**: Hero talent specialization (DPS/execution focus)  
**Scope**: Arms OR Fury Warriors  
**Unlock**: Level 13 (Arms: choose Colossus OR Slayer | Fury: choose Slayer OR Mountain Thane)  
**Progression**: Keystone + Capstone + **3 Choice Tiers (L15, L17, L19)** + 4 Passives

### Key Talent (Granted at L13)

**Slayer's Dominance**
- **Type**: Passive
- **Effect**: Frequent random single-target damage proc that inflicts Marked for Execution
- **BG3 Implementation**:
  - 15% chance on melee hit to trigger Slayer's Strike
  - **Slayer's Strike**: Deal bonus 2d8 damage and apply Marked for Execution
  - **Marked for Execution**: 
    - Target takes +10% damage from Execute
    - Target takes +1d6 damage from your attacks
    - Duration: 4 turns
    - Stacks up to 3 times (stacking effect: Execute bonus stacks to +30%)
- **Tags**: Passive, Proc, Debuff, Execute
- **Icon**: inv_ability_slayerwarrior_slayersdominance.gif

### Capstone Talent (Granted at L20)

**Slayer's Malice**
- **Type**: Passive
- **Effect**: General Overpower damage increase
- **BG3 Implementation**:
  - **Arms**: Overpower deals +30% damage
  - **Fury**: (Not applicable to Arms)
  - **Protection**: (Not applicable to Arms)
- **Tags**: Passive, Enhancement, Damage
- **Icon**: ability_warrior_revenge.gif

### Choice Node 1 (Pick 1 at L15)

**Brutal Finish**
- **Type**: Passive
- **Effect**: Execute damage increase when Marked
- **BG3 Implementation**: Execute deals +50% damage against Marked for Execution targets
- **Tags**: Execute, Enhancement

**Opportunist**
- **Type**: Passive
- **Effect**: Mortal Strike enhancement
- **BG3 Implementation**: When Mortal Strike hits a Marked for Execution target, it deals +1d8 damage and refunds 10 Rage
- **Tags**: Enhancement, Resource

**Overwhelming Blades**
- **Type**: Passive
- **Effect**: Multi-target Marked for Execution spread
- **BG3 Implementation**: When you apply Marked for Execution, it spreads to 1 additional nearby enemy (within 3m) at half effectiveness (duration 2 turns instead of 4)
- **Tags**: AoE, Debuff

### Choice Node 2 (Pick 1 at L17)

**Show No Mercy**
- **Type**: Passive
- **Effect**: Critical strike bonus tied to Marked for Execution
- **BG3 Implementation**: Attacks against Marked for Execution targets have critical hit range increased by 1 (19-20, or 18-20 if combined with other crit talents)
- **Tags**: Crit, Enhancement

**Culling Cyclone**
- **Type**: Passive
- **Effect**: Whirlwind benefit from Marked
- **BG3 Implementation**: Whirlwind deals +1d6 damage per Marked for Execution enemy hit (stacks multiplicatively, 3 marked enemies = +3d6)
- **Tags**: AoE, Enhancement

**Relentless Pursuit**
- **Type**: Passive
- **Effect**: Movement speed increase
- **BG3 Implementation**: +3m movement speed. When you Execute a Marked enemy, gain +6m movement for 2 turns (stacks with base)
- **Tags**: Mobility, Execute

### Choice Node 3 (Pick 1 at L19)

**Reap the Storm**
- **Type**: Passive
- **Effect**: Multi-target debuff
- **BG3 Implementation**: When you hit 3+ enemies with a single attack, apply Overwhelmed status on all targets (take +8% damage from you) for 3 turns
- **Tags**: AoE, Debuff
- **Icon**: ability_arakkoa_spinning_blade.gif

**Flurry of Blades**
- **Type**: Passive
- **Effect**: Attack speed increase when Marked enemies present
- **BG3 Implementation**: For each Marked for Execution enemy within 9m, gain +5% attack speed (max 15%)
- **Tags**: Haste, Conditional

**Death Sentence**
- **Type**: Passive
- **Effect**: Execute critical strike bonus
- **BG3 Implementation**: Execute automatically critically hits Marked for Execution targets below 35% HP
- **Tags**: Execute, Crit

### Passives (Granted L13-L20, one per level until exhausted)

**Imminent Demise** (L14)
- **Type**: Passive
- **Effect**: Core ability damage increase against Marked targets
- **BG3 Implementation**: Mortal Strike and Overpower deal +25% damage against Marked for Execution targets
- **Tags**: Enhancement, Damage

**Marked Fury** (L16)
- **Type**: Passive
- **Effect**: Rage generation from Marked targets
- **BG3 Implementation**: Generate +5 Rage when you hit Marked for Execution targets with Rage-costing abilities
- **Tags**: RageGeneration

**Unrelenting Onslaught** (L18)
- **Type**: Passive
- **Effect**: Execute resets on kill
- **BG3 Implementation**: When Execute kills a Marked for Execution enemy, reduce Bladestorm cooldown by 5 turns and apply 2 stacks of Marked for Execution to nearest enemy
- **Tags**: Execute, CDR, Proc

**Slayer's Focus** (L20)
- **Type**: Passive
- **Effect**: Damage increase against primary target
- **BG3 Implementation**: Your primary target (most recently attacked enemy) takes +10% damage from you. When you apply Marked for Execution, it's automatically applied to your primary target
- **Tags**: Damage, SingleTarget, Focus

---

## Progression Integration Chart

### Level-by-Level Talent Acquisition (Arms Warrior)

| Level | Class Talents (10 Rows) | SubclassSpec Talents (10 Rows) | SubclassBase Pool | Specialization | Total Choices This Level |
|-------|-------------------------|-------------------------------|-------------------|----------------|-------------------------|
| **L1** | Row 1 (auto) + Row 2 choice | Row 1 (auto) + Row 2 choice | Pick 1 Offensive + 1 Utility | - | 4 (2 Class + 1 Spec + 2 Base) |
| **L2** | - | - | Pick 1 from ALL | - | 1 |
| **L3** | Row 3 choice | Row 3 choice | Pick 1 from ALL | - | 3 |
| **L4** | - | - | Pick 1 from ALL | - | 1 (+ Feat choice) |
| **L5** | Row 4 choice | Row 4 choice | Pick 1 from ALL | **Extra Attack** | 3 + Extra Attack |
| **L6** | - | - | Pick 1 from ALL | - | 1 |
| **L7** | Row 5 choice | Row 5 choice | Pick 1 from ALL | - | 3 |
| **L8** | - | - | Pick 1 from ALL | - | 1 (+ Feat choice) |
| **L9** | Row 6 choice | Row 6 choice | Pick 1 from ALL | - | 3 |
| **L10** | - | - | Pick 1 from ALL | - | 1 |
| **L11** | Row 7 choice | Row 7 choice | Pick 1 from ALL | - | 3 |
| **L12** | - | - | (Pool exhausted) | - | 0 (+ Feat choice) |
| **L13** | Row 8 choice | Row 8 choice | - | Choose Colossus OR Slayer **(Keystone ONLY)** | 3 |
| **L14** | - | - | - | Passive | 1 |
| **L15** | Row 9 choice | Row 9 choice | - | Choice Node 1 | 3 |
| **L16** | - | - | - | Passive | 1 (+ Feat choice) |
| **L17** | Row 10 choice | Row 10 choice | - | Choice Node 2 | 3 |
| **L18** | - | - | - | Passive | 1 |
| **L19** | - | - | - | Choice Node 3 | 1 |
| **L20** | - | - | - | Passive + **Capstone** | 2 (+ Feat choice) |
| **TOTAL** | **9 choices** | **9 choices** | **12 abilities** | **1 spec choice + 3 nodes + 4 passives = 8** | **38 talent choices + 5 feats + 12 baseline = 55 total** |

### Talent Choice Breakdown
- **Class Talents**: 9 choices (1 per odd level L1-17, excluding L1 which auto-grants Row 1)
- **SubclassSpec Talents**: 9 choices (1 per odd level L1-17, excluding L1 which auto-grants Row 1)
- **SubclassBase Pool**: 12 abilities (2 at L1, then 1 per level L2-11)
- **Specialization**: 8 choices (1 spec selection + 3 choice nodes + 4 passive grants)
- **Feats**: 5 choices (L4/8/12/16/20 - kept per Decision 3)
- **TOTAL**: **43 meaningful player choices across 20 levels**

---

## Implementation Notes

### Pool Interaction
1. **Class Talents** and **SubclassSpec Talents** progress in parallel (odd levels)
2. **SubclassBase** pool depletes first (L1-11)
3. **Specialization** activates at L13 and runs through L20
4. **Feats** at milestone levels (4/8/12/16/20)

### Design Principles
1. **Front-Loaded Choice**: L1 grants 4 choices (2 Class + 1 Spec + 2 Baseline)
2. **Sustained Progression**: Every level grants something (ability, passive, or choice)
3. **Build Diversity**: ~48 choices allows millions of unique builds
4. **Power Curve**: Major power spikes at L7 (Colossus Smash/Warbreaker), L13 (Specialization), L17 (Capstones)

### Balance Targets vs Vanilla Fighter
- **Single-Target DPS**: ~110% of Champion Fighter (burst windows)
- **AoE DPS**: ~90% of Champion Fighter (fewer attacks, but cleave mechanics)
- **Survivability**: ~85% of Fighter (less AC, but Rage-based mitigation and self-healing)
- **Utility**: ~120% of Fighter (more mobility, shouts, control)

### BG3 Adaptation Considerations
1. **Rage Economy**: 100 Rage max (120 with Overwhelming Rage talent)
2. **Turn-Based**: Cooldowns measured in turns (1 turn = ~6 seconds WoW time)
3. **Action Economy**: Action/Bonus Action/Reaction system
4. **No Auto-Attacks**: Damage compensated by higher per-hit damage
5. **Crowd Control**: BG3 saves (STR/DEX/CON/INT/WIS/CHA) instead of WoW diminishing returns

---

## Cross-Reference to Existing Implementation

### Already Implemented (v1.0)
- ✅ **All 12 SubclassBase abilities** (Spell files exist)
- ✅ **Rage resource system** (ActionResourceDefinitions)
- ✅ **Specialization system** (Colossus and Slayer passives exist)
- ✅ **Hero talent choice nodes** (L13/15/17/19 progression)

### Requires Implementation (v2.0)
- ⏸️ **Class Talents** (10 rows, ~24 new abilities)
- ⏸️ **SubclassSpec Talents** (10 rows, ~24 new Arms abilities)
- ⏸️ **Passive Wrappers** (~80 passives for pool system)
- ⏸️ **Progressions.lsx Rebuild** (complete restructure)
- ⏸️ **Localization** (~180 new handles for h125abc179+)

### Icon Resources Available
- ✅ **~200+ WoW icons** in `Documentation/08_WoWSourceMaterial/[Spec]_files/`
- ✅ **All baseline abilities** have matching icons
- ✅ **All spec talents** have matching icons
- ⏸️ **Conversion needed**: GIF → PNG, resize to 64x64 or 128x128

---

## Implementation Priority

### Phase 1: Research & Design (30 hours)
1. ✅ Document 5-pool system (this document)
2. ⏸️ Test BG3 constraint validation (passive wrapper approach)
3. ⏸️ Create detailed Class Talent designs
4. ⏸️ Create detailed SubclassSpec Talent designs
5. ⏸️ Map L1-20 progression chart

### Phase 2: Architecture (50 hours)
1. Design Progressions.lsx structure (4 parallel talent systems)
2. Create passive wrapper templates
3. Plan localization (180+ new handles)
4. Design testing framework

### Phase 3: Implementation (60 hours)
1. Create ~40 new abilities (Class + SubclassSpec talents)
2. Create ~80 passive wrappers (for pool system)
3. Rebuild Progressions.lsx (complete overhaul)
4. Convert ~60 icons (GIF → PNG)

### Phase 4: Testing & Balance (50 hours)
1. Test 10 archetype builds
2. Balance tuning vs vanilla Fighter
3. Bug fixing

### Phase 5: Documentation (30 hours)
1. Update all design documents
2. Create player guides
3. Create developer documentation

### Phase 6: Release (10 hours)
1. Package v2.0
2. Validation checklist
3. Community release

**Total Effort**: 230 hours (250 with buffer)

---

**END OF DESIGN SPECIFICATION**

**Document Status**: Authoritative - All 5 pools fully defined  
**Next Steps**: Begin Phase 1 BG3 constraint testing  
**Approval**: Ready for implementation (pending BG3 engine validation)
