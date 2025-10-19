# WoW → BG3 Ability Conversion Guide

**Date:** October 17, 2025  
**Purpose:** Comprehensive guide for converting World of Warcraft Warrior abilities to Baldur's Gate 3 mechanics  
**Scope:** ~80+ abilities across Class Talents, SubclassSpec Talents, and Specializations

---

## Table of Contents

- [Overview](#overview)
- [Core Conversion Principles](#core-conversion-principles)
- [Damage Formula Conversions](#damage-formula-conversions)
- [Status Effect Conversions](#status-effect-conversions)
- [Cooldown Conversions](#cooldown-conversions)
- [Rage Cost Conversions](#rage-cost-conversions)
- [Range and Targeting Conversions](#range-and-targeting-conversions)
- [Duration Conversions](#duration-conversions)
- [Ability Type Mapping](#ability-type-mapping)
- [Conversion Examples](#conversion-examples)
- [Implementation Checklist](#implementation-checklist)

---

## Overview

Converting WoW abilities to BG3 requires translating real-time MMO mechanics into turn-based D&D 5e systems while preserving the **feel** and **power fantasy** of each ability.

### Key Differences: WoW vs BG3

| Aspect | WoW | BG3 |
|--------|-----|-----|
| **Combat** | Real-time, fast-paced | Turn-based, tactical |
| **Damage** | % weapon damage, AP scaling | Dice notation (XdY + modifier) |
| **Cooldowns** | Seconds (6s, 12s, 45s, etc.) | Turns, Short Rest, Long Rest |
| **Rage** | 0-100 resource | 0-11 pips (each pip = ~9 Rage) |
| **Durations** | Seconds (6s, 12s, 18s) | Turns (1 turn ≈ 6 seconds) |
| **Range** | Yards (0-40 yards) | Meters (0-18m) |
| **GCD** | 1.5s Global Cooldown | Action economy (Action/Bonus/Reaction) |

### Conversion Goals

1. **Preserve Power Fantasy:** Abilities should *feel* like their WoW counterparts
2. **Maintain Balance:** Match BG3 power levels (compare to Fighter, Barbarian abilities)
3. **Respect D&D Rules:** Use established BG3 mechanics (dice, action economy, status effects)
4. **Keep Identity:** Arms = big hits/bleeds, Fury = speed/multi-hit, Protection = defense

---

## Core Conversion Principles

### 1. Power Budget

**WoW Abilities Scale With:**
- Attack Power (primary stat)
- Critical Strike chance
- Haste (attack speed)
- Mastery (spec-specific bonus)

**BG3 Abilities Scale With:**
- Dice rolls (RNG, bounded by dice type)
- Ability modifiers (Strength, proficiency bonus)
- Critical hits (natural 20 or 19-20)
- Weapon enchantments

**Conversion Rule:**  
WoW ability damage should match BG3 abilities of similar cooldown/resource cost. Compare to Fighter maneuvers, Barbarian attacks.

### 2. Action Economy

**WoW GCD System:**
- Most abilities: 1.5s GCD
- Instant abilities: No GCD (off-GCD)
- Cast times: 1.5s-3s

**BG3 Action Economy:**
- **Action:** Major ability (1 per turn)
- **Bonus Action:** Minor ability (1 per turn)
- **Reaction:** Opportunity Attack, triggered effects (1 per round)
- **Free Action:** Movement, item interaction

**Conversion Table:**

| WoW Ability Type | BG3 Action Type | Example |
|------------------|-----------------|---------|
| High damage, high cost | Action | Mortal Strike, Execute |
| Medium damage, medium cost | Action or Bonus Action | Bloodthirst, Overpower |
| Utility, short cooldown | Bonus Action | Battle Shout, Rallying Cry |
| Instant, defensive | Bonus Action or Reaction | Shield Block, Die by the Sword |
| Interrupt | Reaction | Pummel, Spell Reflection |

### 3. Balance Reference Points

**Compare to BG3 Martial Classes:**

**Fighter Maneuvers (Battle Master):**
- **Riposte:** Reaction, 1d8 + STR damage
- **Trip Attack:** 1d8 + STR, target prone (STR save)
- **Precision Attack:** +1d8 to attack roll

**Barbarian Abilities:**
- **Rage:** Bonus Action, +2 damage per hit, resistance
- **Reckless Attack:** Advantage on attacks, enemies get advantage
- **Frenzy:** Extra attack as bonus action

**Warrior abilities should match this power level.**

---

## Damage Formula Conversions

### WoW Damage Notation

**Format:** `X% weapon damage + Y Attack Power`

**Examples:**
- `100% weapon damage` = 1 weapon strike
- `150% weapon damage` = 1.5× weapon damage
- `200% weapon damage + 500 AP` = 2× weapon + flat bonus

### BG3 Damage Notation

**Format:** `XdY + Modifier`

**Examples:**
- `1d12 + STR` = 1-12 + Strength modifier
- `3d8 + STR` = 3-24 + Strength modifier
- `4d12` = 4-48 (no modifier)

### Conversion Formula

#### Step 1: Calculate WoW Average Damage

**Weapon Damage:** Assume 50 DPS weapon (typical endgame)
- 2H weapon: 100-150 damage per hit
- 1H weapon: 50-80 damage per hit
- Average: ~125 damage (2H), ~65 damage (1H)

**Attack Power Scaling:** Assume 3000 AP (typical endgame)
- 1 AP ≈ 0.1 damage per second
- 500 AP ≈ 50 flat damage

**Example:** `150% weapon damage + 500 AP`
- Weapon damage: 125 × 1.5 = 187.5
- AP bonus: 500 × 0.1 = 50
- **Total:** ~237.5 damage

#### Step 2: Convert to BG3 Dice

**BG3 Damage Ranges:**
- **Low:** 1d6 (1-6, avg 3.5)
- **Medium:** 1d8 (1-8, avg 4.5)
- **High:** 1d10 (1-10, avg 5.5)
- **Very High:** 1d12 (1-12, avg 6.5)

**Modifiers:**
- **STR Modifier:** +3 to +5 (typical L5-L10)
- **Proficiency:** +2 to +6 (level dependent)

**Conversion Table:**

| WoW Damage | BG3 Dice (No Modifier) | BG3 Dice (+ STR) | Example Ability |
|------------|------------------------|------------------|-----------------|
| 50-100 | 1d6 or 1d8 | 1d6+STR | Slam, Pummel |
| 100-150 | 2d6 or 1d10 | 1d10+STR | Bloodthirst, Overpower |
| 150-200 | 2d8 or 1d12 | 1d12+STR or 2d8+STR | Mortal Strike |
| 200-300 | 3d8 or 2d12 | 2d12+STR or 3d8+STR | Execute (low HP) |
| 300-400 | 4d10 or 3d12 | 3d12+STR | Execute (20% HP) |
| 400+ | 4d12 or 5d10 | 4d12+STR | Demolish, Capstone abilities |

**Rule of Thumb:** For every 50 WoW damage, add 1d8 (or equivalent dice).

#### Step 3: Adjust for Cooldown/Cost

**High Cooldown/Cost = Higher Damage:**

| Cooldown | Cost | Damage Multiplier | Example |
|----------|------|-------------------|---------|
| None | 10 Rage | 1.0× | Slam |
| 1 turn | 20 Rage | 1.2× | Bloodthirst |
| 2 turns | 30 Rage | 1.5× | Mortal Strike |
| Short Rest | 40 Rage | 2.0× | Execute, Demolish |
| Long Rest | — | 2.5× | Avatar, Bladestorm |

### Conversion Examples

#### Example 1: Mortal Strike

**WoW Version:**
- **Damage:** 180% weapon damage
- **Cost:** 30 Rage
- **Cooldown:** 6 seconds
- **Effect:** Apply Mortal Wounds (-25% healing)

**WoW Calculation:**
- 125 × 1.8 = 225 damage

**BG3 Conversion:**
- **Damage:** `2d12 + STR` (avg 13 + 4 = 17) ← Lower because turn-based
- **Cost:** 30 Rage (3 pips)
- **Cooldown:** 2 turns (6s × 2 = 12s in WoW terms, higher for balance)
- **Effect:** Apply Mortal Wounds (-50% healing for 2 turns) ← Stronger % because turns matter more

**Why Lower Dice?** Turn-based combat = fewer attacks per minute. 225 WoW damage ≠ 225 BG3 damage.

**BG3 Implementation:**
```
new entry "Target_WAR_MortalStrike"
type "SpellData"
data "SpellType" "Target"
data "Level" "0"
data "UseCosts" "ActionPoint:1;Rage:30"
data "SpellSuccess" "DealDamage(2d12+StrengthModifier,MainMeleeWeaponDamageType,Magical);ApplyStatus(MORTAL_WOUNDS,100,2)"
data "TargetConditions" "Character() and not Dead()"
data "Cooldown" "OncePerTurn"
```

#### Example 2: Execute

**WoW Version:**
- **Damage:** 200% weapon damage (scales with Rage spent)
- **Cost:** 20 Rage (can spend up to 40 for more damage)
- **Effect:** Only usable on targets below 20% HP

**WoW Calculation:**
- Base: 125 × 2.0 = 250 damage
- Max: 125 × 3.5 = 437.5 damage (with 40 Rage)

**BG3 Conversion:**
- **Base Damage:** `3d12 + STR` (avg 19.5 + 4 = 23.5)
- **Max Damage:** `4d12 + STR` (avg 26 + 4 = 30) with 40 Rage
- **Cost:** 20 Rage (can spend up to 40)
- **Condition:** Target HP ≤ 20%

**Scaling Rule:** +1d12 per 10 extra Rage spent (max 2d12 bonus)

**BG3 Implementation:**
```
new entry "Target_WAR_Execute"
type "SpellData"
data "SpellType" "Target"
data "UseCosts" "ActionPoint:1;Rage:20"
data "TargetConditions" "HealthPercentage(context.Target) <= 20"
data "SpellSuccess" "DealDamage(3d12+StrengthModifier+IF(HasStatus('HIGH_RAGE',context.Source)):1d12,MainMeleeWeaponDamageType,Magical)"
```

---

## Status Effect Conversions

### WoW Status Effects

**Common WoW Debuffs:**
- **Slow:** -30% to -50% movement speed
- **Hamstring:** -50% movement speed, 15 seconds
- **Sunder Armor:** -20% armor, stacks 3 times
- **Mortal Wounds:** -25% healing, 10 seconds
- **Dazed:** Miss chance increase, 4 seconds
- **Stun:** Cannot act, 3-6 seconds

### BG3 Status Effects

**BG3 Conditions:**
- **Prone:** Disadvantage on attacks, melee attackers have advantage
- **Restrained:** Speed 0, disadvantage on DEX saves, attackers have advantage
- **Stunned:** Cannot act, auto-fail STR/DEX saves, attackers have advantage
- **Blinded:** Disadvantage on attacks, attackers have advantage
- **Frightened:** Disadvantage on attacks, cannot move closer to source
- **Slowed:** Half movement speed
- **Bleeding:** 2d4 damage per turn
- **Weakened:** Disadvantage on STR checks/saves

### Conversion Table

| WoW Effect | BG3 Equivalent | Duration Conversion | Notes |
|------------|----------------|---------------------|-------|
| **Slow (30-50%)** | Slowed (half speed) | 6s → 1 turn | BG3 has binary slow (half vs full) |
| **Hamstring** | Slowed + Bleeding | 15s → 2-3 turns | Add bleed for flavor |
| **Sunder Armor** | -2 to -5 AC | 12s → 2 turns | AC reduction instead of % armor |
| **Mortal Wounds** | -50% healing | 10s → 2 turns | Stronger % because fewer heals |
| **Dazed** | Disadvantage on attacks | 4s → 1 turn | Miss chance = disadvantage |
| **Stun** | Stunned | 3-6s → 1 turn | Stun is powerful, 1 turn max |
| **Root** | Restrained | 4-8s → 1-2 turns | Speed 0 + disadvantage |
| **Bleed** | Bleeding (2d4/turn) | 12-18s → 2-3 turns | Damage per turn |

### Conversion Rules

1. **Duration:** Divide WoW seconds by 6 (1 turn ≈ 6 seconds), round down
2. **Effect Strength:** Increase % effects because turns matter more (fewer heals, fewer attacks)
3. **Stacking:** BG3 doesn't support stacking well, use tiered effects instead (Sunder 1, Sunder 2, Sunder 3)
4. **Dispels:** BG3 has fewer dispels, so debuffs are stronger

### Example Conversions

#### Sunder Armor (WoW → BG3)

**WoW:**
- **Effect:** -20% armor per stack
- **Max Stacks:** 3 (-60% armor)
- **Duration:** 30 seconds

**BG3 Option 1: AC Reduction**
- **Effect:** -2 AC per application
- **Max Stacks:** 3 (-6 AC total)
- **Duration:** 5 turns
- **Implementation:** 3 separate statuses (SUNDER_1, SUNDER_2, SUNDER_3)

**BG3 Option 2: Vulnerability**
- **Effect:** Target takes +10% physical damage
- **Max Stacks:** 1 (no stacking)
- **Duration:** 3 turns
- **Implementation:** Single status (SUNDERED)

**Recommended:** Option 2 (simpler, less bookkeeping)

```
new entry "WAR_STATUS_SUNDERED"
type "StatusData"
data "StatusType" "BOOST"
data "DisplayName" "hSunderedArmor;1"
data "Icon" "Spell_Warrior_SunderArmor"
data "Boosts" "Resistance(Slashing,Resistant);Resistance(Piercing,Resistant);Resistance(Bludgeoning,Resistant)"
data "StackId" "WAR_SUNDERED"
data "StatusPropertyFlags" "DisableCombatlog;DisableOverhead;DisablePortraitIndicator"
```

#### Mortal Wounds (WoW → BG3)

**WoW:**
- **Effect:** -25% healing received
- **Duration:** 10 seconds

**BG3:**
- **Effect:** -50% healing received ← Doubled because turns matter
- **Duration:** 2 turns (10s ÷ 6s ≈ 2 turns)
- **Implementation:** Status modifies healing received

```
new entry "WAR_STATUS_MORTAL_WOUNDS"
type "StatusData"
data "StatusType" "BOOST"
data "DisplayName" "hMortalWounds;1"
data "Description" "hMortalWoundsDesc;1"
data "Icon" "Spell_Warrior_MortalStrike"
data "Boosts" "IncreaseHealingReceived(-50)"
data "StackId" "WAR_MORTAL_WOUNDS"
data "RemoveEvents" "OnTurnEnd"
data "RemoveConditions" "HasStatus('MORTAL_WOUNDS') and TurnCounter(2)"
```

---

## Cooldown Conversions

### WoW Cooldown System

**Categories:**
- **No CD:** Spammable (limited by Rage)
- **Short CD:** 6-12 seconds (1-2 GCDs)
- **Medium CD:** 20-30 seconds
- **Long CD:** 45-90 seconds
- **Major CD:** 2-3 minutes

### BG3 Cooldown System

**Categories:**
- **No CD:** Spammable (limited by Action Points or Rage)
- **OncePerTurn:** 1 use per turn (≈ 6 seconds)
- **Short Rest:** Recharges on Short Rest (every 2-3 encounters)
- **Long Rest:** Recharges on Long Rest (once per day)
- **OncePerShortRest:** Alternative notation
- **OncePerCombat:** Very powerful, 1 per fight

### Conversion Table

| WoW Cooldown | BG3 Equivalent | Conversion Rule | Example Ability |
|--------------|----------------|-----------------|-----------------|
| **None** | No Cooldown | Rage/AP limited | Slam, Bloodthirst (with Rage) |
| **6s (1 GCD)** | OncePerTurn or 1 turn | 1 turn = 6s | Overpower, Raging Blow |
| **12s (2 GCD)** | 2 turns or OncePerTurn | Slightly longer wait | Shield Slam, Revenge |
| **20-30s** | Short Rest (2-4 uses/day) | Short Rest ≈ 30-45 min | Charge, Thunder Clap |
| **45-90s** | Short Rest (1-2 uses/day) | Major ability | Bladestorm, Ravager |
| **2-3 min** | Long Rest (1/day) | Ultimate power | Avatar, Recklessness |

### Conversion Guidelines

#### Spammable Abilities (No CD)

**WoW Example:** Bloodthirst (No CD, 25 Rage cost)

**BG3 Conversion:**
- **No Cooldown:** Unlimited uses
- **Gated by:** Rage cost (25 Rage)
- **Balance:** Rage generation rate limits spam

**When to Use:** Core rotation abilities that define spec identity

#### Short Cooldown (1-2 Turns)

**WoW Example:** Mortal Strike (6s CD, 30 Rage)

**BG3 Conversion:**
- **Cooldown:** OncePerTurn or 2 turns
- **Cost:** 30 Rage
- **Balance:** High damage justifies wait time

**When to Use:** High-damage abilities with resource cost

#### Medium Cooldown (Short Rest)

**WoW Example:** Charge (20s CD, 20 Rage generation)

**BG3 Conversion:**
- **Cooldown:** Short Rest (UntilShortRest)
- **Effect:** Gap closer + Rage generation
- **Uses per Day:** 2-3 (depends on rest frequency)

**When to Use:** Utility abilities with combat-defining effects

#### Long Cooldown (Long Rest)

**WoW Example:** Avatar (3 min CD)

**BG3 Conversion:**
- **Cooldown:** Long Rest (UntilLongRest)
- **Effect:** +20% damage, +20% HP, 20s duration → 3 turns
- **Uses per Day:** 1

**When to Use:** Ultimate abilities (Capstones, Hero powers)

### Implementation Examples

#### OncePerTurn Cooldown

```
data "Cooldown" "OncePerTurn"
```

**Effect:** Can use 1 time per turn, recharges every turn

#### Short Rest Cooldown

```
data "UseCosts" "ActionPoint:1;Rage:20;ShortRestPoint:1"
```

**Effect:** Consumes 1 Short Rest charge (2-3 per day)

#### Long Rest Cooldown

```
data "UseCosts" "ActionPoint:1;LongRestPoint:1"
```

**Effect:** 1 use per Long Rest (once per day)

#### Custom Turn Cooldown

```
data "Cooldown" "OncePerTurn"
data "CooldownType" "OncePerTurn"
```

**Advanced:** Can modify to "OncePerTwoTurns" with custom functor

---

## Rage Cost Conversions

### WoW Rage System

**Range:** 0-100 Rage  
**Generation:** ~10-15 Rage per second (in combat)  
**Spenders:** 20-40 Rage per ability

**Typical Costs:**
- **Light Spenders:** 20 Rage (Slam, Bloodthirst)
- **Medium Spenders:** 30 Rage (Mortal Strike, Overpower)
- **Heavy Spenders:** 40 Rage (Execute, Demolish, Ignore Pain)
- **Variable:** 20-40 Rage (Execute scales)

### BG3 Rage System

**Range:** 0-11 pips (each pip ≈ 9.09 Rage)  
**Display:** UI shows 11 discrete pips  
**Generation:** +10 Rage per weapon hit, +20 per damage taken

**Pip Conversion:**
- 1 pip = 9.09 Rage
- 2 pips = 18.18 Rage (≈ 20 Rage)
- 3 pips = 27.27 Rage (≈ 30 Rage)
- 4 pips = 36.36 Rage (≈ 40 Rage)
- 11 pips = 100 Rage (max)

### Conversion Table

| WoW Rage Cost | BG3 Rage Cost | BG3 Pips | Example Abilities |
|---------------|---------------|----------|-------------------|
| **10** | 10 | ~1 pip | Slam, Pummel |
| **20** | 20 | ~2 pips | Bloodthirst, Revenge |
| **25** | 30 | ~3 pips | Raging Blow (adjusted up) |
| **30** | 30 | ~3 pips | Mortal Strike, Overpower |
| **40** | 40 | ~4 pips | Execute, Demolish, Ignore Pain |
| **Variable (20-40)** | 20-40 (scales) | 2-4 pips | Execute (scales with extra Rage) |

### Conversion Rules

1. **Round to Multiples of 10:** BG3 uses 10-Rage increments (easier math)
2. **Adjust for Power:** If ability is weaker in BG3, reduce cost
3. **Maintain Ratios:** High-cost abilities should be ~2× spammable abilities
4. **Generator Balance:** 2 attacks (20 Rage) should fund 1 spender

### Generation vs Spending Balance

**Rage Generation Rate (BG3):**
- **Per Attack:** +10 Rage (with Extra Attack = +20/turn)
- **Taking Damage:** +20 Rage per hit received
- **Critical Hit:** +10 Rage (same as normal hit)

**Example 3-Turn Rotation:**
1. **Turn 1:** 2 attacks = +20 Rage → Spend 20 on Bloodthirst (net 0)
2. **Turn 2:** 2 attacks = +20 Rage → Spend 30 on Mortal Strike (net -10)
3. **Turn 3:** 2 attacks = +20 Rage, enemy hits you = +20 Rage → Spend 40 on Execute (net 0)

**Target Balance:** ~30 Rage generated per turn, ~25 Rage spent per turn (slow accumulation)

### Variable Rage Costs (Execute)

**WoW Execute:**
- Base cost: 20 Rage
- Can spend up to 40 Rage for increased damage

**BG3 Implementation:**
```
new entry "Target_WAR_Execute"
data "UseCosts" "ActionPoint:1;Rage:20"
data "SpellSuccess" "IF(HasStatus('HIGH_RAGE',context.Source)):DealDamage(4d12+StrengthModifier,MainMeleeWeaponDamageType,Magical);IF(NOT HasStatus('HIGH_RAGE',context.Source)):DealDamage(3d12+StrengthModifier,MainMeleeWeaponDamageType,Magical)"
```

**HIGH_RAGE Status:** Applied when Rage ≥ 40, consumed by Execute

---

## Range and Targeting Conversions

### WoW Range System

**Measured in Yards:**
- **Melee:** 0-5 yards (close combat)
- **Short Range:** 8-15 yards (Charge, Heroic Throw)
- **Medium Range:** 20-30 yards (ranged attacks)
- **Long Range:** 40 yards (max range)

### BG3 Range System

**Measured in Meters:**
- **Melee:** 1.5m-3m (weapon reach)
- **Short Range:** 6m-9m (close abilities)
- **Medium Range:** 12m-18m (gap closers, throws)
- **Long Range:** 18m+ (rare for Warriors)

### Conversion Table

| WoW Range (Yards) | BG3 Range (Meters) | Conversion Factor | Example Ability |
|-------------------|---------------------|-------------------|-----------------|
| **0-5** (Melee) | 1.5m-3m | 1 yard ≈ 0.9m | All melee attacks |
| **8** | 6m-9m | Direct conversion | Thunder Clap AoE |
| **12** | 12m | 1:1 ratio | Charge range |
| **20** | 18m | Scale down | Heroic Throw |
| **30** | 18m+ | Cap at 18m | Max range (BG3 limit) |
| **40** | 18m | Cap at 18m | Very long range (rare) |

**Rule of Thumb:** 1 WoW yard ≈ 1 BG3 meter (close enough for gameplay)

### Targeting Type Conversions

| WoW Targeting | BG3 Targeting | SpellType | Example |
|---------------|---------------|-----------|---------|
| **Single Target** | Single enemy/ally | Target | Mortal Strike, Bloodthirst |
| **Self-Buff** | Self | Shout | Battle Shout, Defensive Stance |
| **AoE Circle** | Radius around caster | Zone or Shout | Thunder Clap, Whirlwind |
| **AoE Cone** | 90°-120° cone | Zone | Cleave, Revenge |
| **Ground-Targeted** | Click location, then AoE | Zone | Heroic Leap, Ravager |
| **Line/Charge** | Line to target | Jump or Projectile | Charge, Intervene |

### Implementation Examples

#### Melee Single Target

```
data "SpellType" "Target"
data "TargetRadius" "3"
data "TargetConditions" "Character() and not Dead()"
```

#### AoE Around Caster (Thunder Clap)

```
data "SpellType" "Shout"
data "AreaRadius" "6"
data "TargetConditions" "Character() and not Dead() and not Self()"
```

#### Ground-Targeted AoE (Heroic Leap)

```
data "SpellType" "Zone"
data "TargetRadius" "18"
data "AreaRadius" "4"
data "SpellSuccess" "ApplyStatus(SELF,LEAPING,100,1);DealDamage(2d6,Bludgeoning,Magical)"
```

---

## Duration Conversions

### WoW Duration System

**Real-Time Seconds:**
- **Short:** 3-6 seconds (debuffs, stuns)
- **Medium:** 10-15 seconds (bleeds, buffs)
- **Long:** 18-30 seconds (major buffs, Sunder stacks)
- **Very Long:** 60+ seconds (Battle Shout, persistent effects)

### BG3 Duration System

**Turn-Based:**
- **1 Turn:** ≈ 6 seconds
- **2 Turns:** ≈ 12 seconds
- **3 Turns:** ≈ 18 seconds
- **UntilRest:** Lasts until Short or Long Rest
- **UntilLongRest:** Lasts entire day

### Conversion Formula

**Basic Conversion:** `BG3 Turns = WoW Seconds ÷ 6`

**Rounding Rules:**
- **0-4s:** 1 turn (minimum duration)
- **5-9s:** 1-2 turns (short effect)
- **10-15s:** 2-3 turns (medium effect)
- **16-24s:** 3-4 turns (long effect)
- **25+s:** UntilRest or 5+ turns

### Conversion Table

| WoW Duration (Seconds) | BG3 Duration (Turns) | Example Effect |
|------------------------|----------------------|----------------|
| **3s** | 1 turn | Stun, Daze |
| **6s** | 1 turn | Hamstring, Slow |
| **9-12s** | 2 turns | Rend, Sunder Armor |
| **15-18s** | 3 turns | Mortal Wounds, Bleeding |
| **20-30s** | UntilShortRest | Battle Shout (out of combat) |
| **60s+** | UntilLongRest | Long-duration buffs |

### Duration Balancing

**Why Adjust Durations:**
- **Turn-based = Fewer Actions:** 3 turns in BG3 = 18 seconds WoW, but only 3 actions vs ~10-12 GCDs
- **Debuffs Are Stronger:** Losing 1 turn to stun = 100% of your turn vs 3s/60s = 5% of WoW time
- **Damage Over Time Is Weaker:** 3 ticks in BG3 vs 6 ticks in WoW (same duration, half the ticks)

**Adjustment Rules:**
1. **Stuns/Hard CC:** Always 1 turn max (very powerful)
2. **Slows/Soft CC:** 1-2 turns (impactful but not crippling)
3. **Damage Over Time:** Increase damage per tick to compensate for fewer ticks
4. **Buffs:** Extend to UntilRest if out-of-combat buff (Battle Shout)

### Implementation Examples

#### Short Duration (Stun)

```
data "StatusType" "INCAPACITATED"
data "RemoveEvents" "OnTurnEnd"
data "RemoveConditions" "TurnCounter(1)"
```

**Effect:** Stunned for 1 turn, removed at end of turn

#### Medium Duration (Bleeding)

```
data "StatusType" "BOOST"
data "Boosts" "DamagePerTurn(2d4,Slashing)"
data "RemoveEvents" "OnTurnEnd"
data "RemoveConditions" "TurnCounter(3)"
```

**Effect:** 2d4 damage per turn for 3 turns

#### Long Duration (Battle Shout - In Combat)

```
data "StatusType" "BOOST"
data "Boosts" "Advantage(AttackRoll)"
data "RemoveEvents" "OnTurnEnd"
data "RemoveConditions" "TurnCounter(5)"
```

**Effect:** Advantage on attacks for 5 turns (30 seconds)

#### Permanent Duration (Until Rest)

```
data "StatusType" "BOOST"
data "Boosts" "ACBonus(2)"
data "RemoveEvents" "OnShortRest;OnLongRest"
```

**Effect:** +2 AC until next rest

---

## Ability Type Mapping

### WoW Ability Categories

1. **Rage Generators:** Build Rage (Bloodthirst, Charge)
2. **Rage Spenders:** Consume Rage (Mortal Strike, Execute)
3. **Cooldown Abilities:** Fixed cooldown (Charge, Bladestorm)
4. **Proc-Based:** Random chance (Overpower reset, Sudden Death)
5. **Passive Enhancements:** Modify other abilities (Mastery, talents)
6. **Defensive Cooldowns:** Reduce damage (Shield Block, Die by the Sword)

### BG3 Spell Types

| BG3 SpellType | Description | WoW Equivalent | Example |
|---------------|-------------|----------------|---------|
| **Target** | Single target | Single-target attacks | Mortal Strike, Execute |
| **Shout** | Self + radius AoE | Self-buff or AoE around caster | Battle Shout, Thunder Clap |
| **Zone** | Ground-targeted AoE | Ground-targeted | Heroic Leap, Ravager |
| **Jump** | Leap to location | Gap closer | Charge, Intervene |
| **Projectile** | Ranged attack | Ranged attacks | Heroic Throw, Storm Bolt |
| **Passive** | Always active | Passive talents | Rage Generation, Mastery |

### Mapping Table

| WoW Ability Type | BG3 SpellType | UseCosts | Example Implementation |
|------------------|---------------|----------|------------------------|
| **Melee Attack** | Target | ActionPoint:1;Rage:X | Mortal Strike, Bloodthirst |
| **Self-Buff** | Shout | ActionPoint:1 or BonusActionPoint:1 | Battle Shout, Defensive Stance |
| **AoE Around Self** | Shout | ActionPoint:1;Rage:X | Thunder Clap, Whirlwind |
| **Gap Closer** | Jump | ActionPoint:1 or BonusActionPoint:1 | Charge, Heroic Leap |
| **Ground-Targeted** | Zone | ActionPoint:1;Rage:X | Ravager, Bladestorm |
| **Ranged Attack** | Projectile | ActionPoint:1 | Heroic Throw, Storm Bolt |
| **Proc Ability** | Target (triggered) | No cost (proc) | Overpower (on dodge), Sudden Death Execute |
| **Passive Talent** | Passive | N/A | Enrage, Mastery: Critical Block |

---

## Conversion Examples

### Example 1: Bloodthirst (Fury Core Ability)

#### WoW Version

**Bloodthirst:**
- **Type:** Melee attack
- **Damage:** 120% weapon damage
- **Cost:** 25 Rage
- **Cooldown:** None (spammable)
- **Effect:** Heal for 3% max HP

#### BG3 Conversion Process

**Step 1: Damage Calculation**
- WoW: 125 × 1.2 = 150 damage
- BG3: 150 damage ≈ 2d6 or 1d10 (+ STR)
- **Choice:** 1d10+STR (avg 5.5 + 4 = 9.5) ← Lower because turn-based

**Step 2: Cost Adjustment**
- WoW: 25 Rage
- BG3: 30 Rage (round to multiple of 10, adjust up for spammability)

**Step 3: Cooldown**
- WoW: None
- BG3: None (Rage-gated)

**Step 4: Healing**
- WoW: 3% max HP
- BG3: 1d6 + Constitution modifier (scales with HP, avoids % calculation)

#### Final BG3 Implementation

```
new entry "Target_WAR_Bloodthirst"
type "SpellData"
data "SpellType" "Target"
data "Level" "0"
data "SpellSchool" "None"
data "AIFlags" "CanNotUse"
data "UseCosts" "ActionPoint:1;Rage:30"
data "TargetRadius" "3"
data "TargetConditions" "Character() and not Dead()"
data "SpellSuccess" "DealDamage(1d10+StrengthModifier,MainMeleeWeaponDamageType,Magical);RegainHitPoints(1d6+ConstitutionModifier)"
data "TooltipDamageList" "DealDamage(1d10+StrengthModifier,MainMeleeWeaponDamageType)"
data "TooltipAttackSave" "MeleeWeaponAttack"
data "DisplayName" "hBloodthirst;1"
data "Description" "hBloodthirstDesc;1"
data "Icon" "Spell_Warrior_Bloodthirst"
data "PrepareEffect" "VFX_Warrior_Bloodthirst_Prepare"
data "CastEffect" "VFX_Warrior_Bloodthirst_Cast"
data "TargetEffect" "VFX_Warrior_Bloodthirst_Hit"
```

**Key Changes:**
- Damage: 120% weapon → 1d10+STR
- Cost: 25 Rage → 30 Rage
- Healing: 3% HP → 1d6+CON

---

### Example 2: Sunder Armor (Debuff Ability)

#### WoW Version

**Sunder Armor:**
- **Type:** Melee attack
- **Damage:** 100% weapon damage
- **Cost:** 30 Rage
- **Effect:** Reduce armor by 20%, stacks 3 times (60% max)
- **Duration:** 30 seconds per stack

#### BG3 Conversion Process

**Step 1: Damage**
- WoW: 125 damage
- BG3: 1d6+STR (minor damage, focus on debuff)

**Step 2: Debuff**
- WoW: -20% armor per stack, max 3 stacks
- BG3 Option A: -2 AC per stack (3 separate statuses)
- BG3 Option B: -5 AC (single status, simpler)
- **Choice:** Option B (less bookkeeping)

**Step 3: Duration**
- WoW: 30 seconds
- BG3: 5 turns (30s ÷ 6s = 5 turns)

#### Final BG3 Implementation

**Spell:**
```
new entry "Target_WAR_SunderArmor"
type "SpellData"
data "SpellType" "Target"
data "UseCosts" "ActionPoint:1;Rage:30"
data "TargetRadius" "3"
data "SpellSuccess" "DealDamage(1d6+StrengthModifier,MainMeleeWeaponDamageType,Magical);ApplyStatus(WAR_SUNDERED,100,5)"
data "DisplayName" "hSunderArmor;1"
data "Description" "hSunderArmorDesc;1"
data "Icon" "Spell_Warrior_SunderArmor"
```

**Status:**
```
new entry "WAR_SUNDERED"
type "StatusData"
data "StatusType" "BOOST"
data "DisplayName" "hSundered;1"
data "Description" "hSunderedDesc;1"
data "Icon" "Spell_Warrior_SunderArmor"
data "Boosts" "AC(-5)"
data "StackId" "WAR_SUNDERED"
data "StackType" "Overwrite"
data "RemoveEvents" "OnTurnEnd"
data "RemoveConditions" "TurnCounter(5)"
```

**Key Changes:**
- Stacking: 3 stacks → single -5 AC (simpler)
- Duration: 30s → 5 turns
- Effect: -20% armor → -5 AC

---

### Example 3: Avatar (Major Cooldown)

#### WoW Version

**Avatar:**
- **Type:** Self-buff
- **Duration:** 20 seconds
- **Cooldown:** 3 minutes
- **Effects:**
  - +20% damage dealt
  - +20% maximum HP
  - Immune to movement-impairing effects
  - Generate Rage faster

#### BG3 Conversion Process

**Step 1: Duration**
- WoW: 20 seconds
- BG3: 3 turns (20s ÷ 6s ≈ 3.3 turns, round down)

**Step 2: Cooldown**
- WoW: 3 minutes
- BG3: Long Rest (once per day, ultimate power)

**Step 3: Effects**
- +20% damage → Damage(All,20%) boost
- +20% HP → TemporaryHP(20% max HP)
- Immune to slow → Advantage(SavingThrow,Strength)
- Rage generation → +10 Rage per turn (status effect)

#### Final BG3 Implementation

**Spell:**
```
new entry "Shout_WAR_Avatar"
type "SpellData"
data "SpellType" "Shout"
data "UseCosts" "BonusActionPoint:1;LongRestPoint:1"
data "SpellSuccess" "ApplyStatus(SELF,WAR_AVATAR,100,3)"
data "DisplayName" "hAvatar;1"
data "Description" "hAvatarDesc;1"
data "Icon" "Spell_Warrior_Avatar"
data "CastEffect" "VFX_Warrior_Avatar_Cast"
```

**Status:**
```
new entry "WAR_AVATAR"
type "StatusData"
data "StatusType" "BOOST"
data "DisplayName" "hAvatarStatus;1"
data "Description" "hAvatarStatusDesc;1"
data "Icon" "Spell_Warrior_Avatar"
data "Boosts" "Damage(All,20);TemporaryHP(20);Advantage(SavingThrow,Strength);Advantage(SavingThrow,Dexterity)"
data "StatusEffect" "VFX_Warrior_Avatar_Status"
data "RemoveEvents" "OnTurnEnd"
data "RemoveConditions" "TurnCounter(3)"
data "OnApplyFunctors" "ApplyStatus(SELF,WAR_AVATAR_RAGE_GEN,100,3)"
```

**Rage Generation Sub-Status:**
```
new entry "WAR_AVATAR_RAGE_GEN"
type "StatusData"
data "StatusType" "BOOST"
data "Boosts" "ActionResourceReplenishType(1,1,Rage,10)"
data "RemoveEvents" "OnTurnEnd"
data "RemoveConditions" "TurnCounter(3)"
```

**Key Changes:**
- Cooldown: 3 min → Long Rest (1/day)
- Duration: 20s → 3 turns
- Effects: Translated to BG3 boosts
- Rage gen: New mechanic (+10 Rage/turn during Avatar)

---

## Implementation Checklist

### Pre-Conversion Phase

- [ ] **List All Abilities:** Catalog all WoW abilities to convert (~80+)
- [ ] **Group by Category:** Class Talents, SubclassSpec, Specializations
- [ ] **Identify Core Abilities:** Priority list (rotation abilities first)
- [ ] **Reference Vanilla BG3:** Compare to Fighter/Barbarian for power level

### Conversion Phase (Per Ability)

- [ ] **Extract WoW Stats:** Damage, cost, cooldown, effects, duration
- [ ] **Calculate Damage:** Convert % weapon damage to dice notation
- [ ] **Set Rage Cost:** Round to multiples of 10, balance generation vs spending
- [ ] **Choose Cooldown:** No CD, OncePerTurn, Short Rest, Long Rest
- [ ] **Convert Status Effects:** Map WoW debuffs to BG3 conditions
- [ ] **Set Duration:** Convert seconds to turns (÷6, adjust for balance)
- [ ] **Choose Spell Type:** Target, Shout, Zone, Jump, Projectile, Passive
- [ ] **Determine Action Type:** Action, Bonus Action, Reaction, Free
- [ ] **Balance Check:** Compare to similar BG3 abilities (Fighter maneuvers, etc.)

### Implementation Phase

- [ ] **Create Spell Entry:** Spell_Warrior.txt with full stats
- [ ] **Create Status Entries:** Status_Warrior.txt for debuffs/buffs
- [ ] **Create Passive Entries:** Passive_Warrior.txt for talents
- [ ] **Localization:** English.loca.xml handles for DisplayName/Description
- [ ] **Add to Progressions:** Progressions.lsx entries to grant abilities
- [ ] **Icons:** Assign WoW icons from Documentation/08_WoWSourceMaterial
- [ ] **VFX:** Assign BG3 visual effects (or create custom)

### Testing Phase

- [ ] **Damage Testing:** Verify damage output matches expectations
- [ ] **Rage Economy:** Check generation vs spending balance
- [ ] **Cooldown Testing:** Verify recharge timing (turns, rests)
- [ ] **Status Effects:** Confirm debuffs/buffs work correctly
- [ ] **Duration Testing:** Verify effects last correct number of turns
- [ ] **Interaction Testing:** Check combos (Charge → Attack, etc.)
- [ ] **Balance Testing:** Compare to vanilla classes in real combat

### Post-Implementation

- [ ] **Document Changes:** Note any deviations from WoW version
- [ ] **Update Guides:** Reflect BG3 implementation in documentation
- [ ] **Balance Adjustments:** Nerf/buff based on testing feedback
- [ ] **Community Feedback:** Gather player impressions, iterate

---

## Related Documentation

### Implementation Guides

- **`CLASS_TALENTS_BG3_IMPLEMENTATIONS.md`** - All 24+ Class Talents with BG3 stats
- **`SUBCLASSSPEC_TALENTS_ARMS_BG3_IMPLEMENTATIONS.md`** - Arms-specific talents
- **`SPECIALIZATION_BG3_IMPLEMENTATIONS.md`** - All specialization abilities

### Design Documents

- **`ARMS_WARRIOR_5_POOL_TALENT_SYSTEM.md`** - Complete 5-pool design
- **`Warrior_Class_Blueprint.md`** - Class overview
- **`Arms/Fury/Protection_Warrior_Talents_Extracted.md`** - WoW source data

### Technical References

- **`FILE_REFERENCE.md`** - BG3 file format syntax
- **`GETTING_STARTED.md`** - Implementation workflow
- **`PASSIVES_MASTER.md`** - Passive implementation guide

---

## Conclusion

Converting WoW abilities to BG3 is **both art and science**:

- **Science:** Mathematical conversions (damage, cooldowns, costs)
- **Art:** Preserving ability identity and power fantasy

**Key Principles:**
1. **Balance > Accuracy:** BG3 balance is more important than 1:1 WoW accuracy
2. **Identity > Mechanics:** Preserve *feel* even if mechanics change
3. **Simplicity > Complexity:** Simpler implementations = fewer bugs
4. **Testing > Theory:** Playtest extensively, adjust based on feedback

Use this guide as a **reference**, not a **rulebook**. Every ability is unique, and some may require creative solutions not covered here.

**Next Steps:**
1. Start with **core rotation abilities** (highest priority)
2. Convert **Class Talents** (shared by all specs)
3. Convert **SubclassSpec Talents** (Arms, Fury, Protection)
4. Convert **Specialization Talents** (Mountain Thane, Colossus, Slayer)

**Estimated Total Work:** ~80+ abilities × 30 min/ability ≈ **40 hours**

---

**Last Updated:** October 17, 2025  
**Author:** BG3Wow Development Team  
**Status:** ✅ **COMPLETE REFERENCE GUIDE**
