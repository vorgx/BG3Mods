# Warrior Implementation - Quick Reference Guide

## COMPLETE ABILITY INVENTORY (38 Total)

### ✅ BASELINE WARRIOR (19 abilities)

#### Core Attacks (3)
- **Heroic Strike** - 1d8+STR, generates 15 Rage
- **Slam** ⚠️ - 2d6+STR, costs 15 Rage (FEATURE_BASELINE_UTILITY)
- **Charge** - Rush attack, generates 10 Rage, applies Off Balance

#### Execute Phase (1)
- **Execute** - 4d12+STR, usable below 20% HP, costs 20-40 Rage

#### AoE Attacks (2)
- **Whirlwind** - 1d8+STR radius, grants cleave buff
- **Thunder Clap** - 2d6+STR Thunder radius, slows enemies

#### Defensive (2)
- **Die by the Sword** - Parry all attacks for 3 turns, Long Rest
- **Spell Reflection** - Reflect spells for 1 turn, Long Rest

#### Support Shouts (3)
- **Battle Shout** - +2 attack/damage to allies, 5 turns
- **Rallying Cry** - 2d8+level Temp HP to allies
- **Intimidating Shout** - Fear 4m radius, 3 turns

#### Mobility (1)
- **Heroic Leap** - 12m jump, 1d8+STR landing damage

#### Major Cooldown (1)
- **Avatar** - +4 STR, +2 AC, +50% Rage, immunities, 4 turns

#### Utility (7 - FEATURE_BASELINE_UTILITY) ⚠️
- **Hamstring** - 1d6+STR, -3 Movement for 3 turns
- **Victory Rush** - 1d8+STR, heals 2d8+CON on hit
- **Pummel** - 1d4+STR, Silence 1 turn, Once per Turn
- **Berserker Rage** - CC immunity/removal, 2 turns, Short Rest
- **Heroic Throw** - 1d4+STR ranged, 18m, Once per Turn
- **Storm Bolt** - 2d6+STR Thunder ranged, Stun 2 turns, Short Rest

---

### ✅ ARMS WARRIOR (10 abilities)

#### Primary Rotation (4)
- **Mortal Strike** - 2d10+STR, -50% healing debuff, 30 Rage
- **Overpower** - 1d12+STR, ignores 50% AC, 20 Rage, Bonus Action
- **Rend** - 1d6+STR + 2d6 bleed/turn × 5, 10 Rage
- **Skullsplitter** - 1d10+STR, generates 20 Rage, Once per Turn, Bonus Action

#### Major Cooldowns (3)
- **Colossus Smash** - 3d8+STR, -3 AC for 3 turns, 40 Rage, Short Rest
- **Warbreaker** - 4d10+STR cone, -2 AC to all, 40 Rage, Long Rest
- **Bladestorm** - 2d8+STR/turn × 4 turns, channeled, Long Rest

#### Buffs (2)
- **Sweeping Strikes** - Cleave next 2 attacks, Short Rest, Bonus Action
- **Deadly Calm** - 0 Rage cost for 3 turns, Short Rest, Bonus Action

#### Supporting Abilities (1)
- **Demolish** - 3×3d10+STR (Colossus specialization keystone)

---

### ⏸️ FURY WARRIOR (8 abilities planned)
- Bloodthirst
- Rampage
- Recklessness
- Enraged Regeneration
- Onslaught
- Bladestorm (shared with Arms)
- Ravager
- Odyn's Fury

---

### ⏸️ PROTECTION WARRIOR (9 abilities planned)
- Devastate
- Shield Block
- Ignore Pain
- Demoralizing Shout
- Last Stand
- Taunt
- Impending Victory
- Shield Charge
- Ravager (shared with Fury)

---

## FEATURE TAGS

### FEATURE_BASELINE_UTILITY ⚠️
**Purpose**: Optional utility abilities that can be disabled for balance

**Abilities** (7):
1. Hamstring
2. Victory Rush
3. Pummel
4. Slam
5. Berserker Rage
6. Heroic Throw
7. Storm Bolt

**How to Disable**:
- Search for `FEATURE_BASELINE_UTILITY` in stat files
- Comment out or delete sections between markers
- Keeps core rotation intact while removing "nice to have" utilities

**Recommendation**: Keep enabled unless testing shows balance issues

---

## FILE LOCATIONS

### Stats Files
- **Spell_Target.txt** - 20 abilities (10 base + 5 utility + 6 Arms - 1 self-buff)
- **Spell_Zone.txt** - 6 abilities (4 base + 2 Arms)
- **Spell_Shout.txt** - 3 abilities (all base)
- **Spell_Jump.txt** - 1 ability (base)
- **Spell_Projectile.txt** - 2 abilities (utility)
- **Status_BOOST.txt** - 44 statuses (16 base + 8 Arms + 16 specializations + 4 utility)
- **Passive.txt** - 33 passives (specializations only)

### Documentation Files
- **ARMS_IMPLEMENTATION_STATUS.md** - Comprehensive Arms analysis
- **ARMS_WARRIOR_IMPLEMENTATION.md** - Arms ability details
- **BASELINE_UTILITY_IMPLEMENTATION.md** - Utility ability details
- **WARRIOR_IMPLEMENTATION_PROGRESS.md** - Overall progress tracking

---

## LOCALIZATION HANDLE RANGES

### Current Usage: h125abc01 - h125abc116 (116 handles)

**Base Abilities** (h125abc01-64):
- Execute: 01-02
- Shield Slam: 03-04 + 05-06 (rage gen)
- Mortal Strike: 07-08 + 09 (Mortal Wound)
- Raging Blow: 10-11 + 12 (Enraged)
- Avatar: 13-14 + 15 (Avatar status)
- Revenge: 16-17
- Shockwave: 18-19
- Thunder Clap: 20-21 + 22 (slow)
- Whirlwind: 23-24 + 25 (buff)
- Shield Block: 26-27 + 28 (status)
- Battle Shout: 29-30 + 31 (status)
- Defensive Stance: 32-33 (status)
- Charge: 34-35 + 36 (rage)
- Heroic Strike: 37-38 + 39 (rage)
- Die by the Sword: 40-41 + 42 (status)
- Spell Reflection: 43-44 + 45 (status)
- Rallying Cry: 46-47 + 48 (temp HP)
- Heroic Leap: 49-50
- Intimidating Shout: 51-52
- Demolish: 53-54

**Specializations** (h124abc##):
- Mountain Thane, Colossus, Slayer passives use h124abc## range

**Arms Abilities** (h125abc65-94):
- Overpower: 65-66
- Colossus Smash: 67-68 + 81-82 (Shattered Defenses)
- Sweeping Strikes: 69-70 + 83-84 (status)
- Rend: 71-72 + 85-86 (bleed)
- Skullsplitter: 73-74 + 87-88 (rage)
- Deadly Calm: 75-76 + 89-90 (status)
- Warbreaker: 77-78 + 91-92 (Sundered Armor)
- Bladestorm: 79-80 + 93-94 (status)

**Utility Abilities** (h125abc95-116):
- Hamstring: 95-96 + 109-110 (status)
- Victory Rush: 97-98 + 111-112 (heal)
- Pummel: 99-100 + 113-114 (silence)
- Slam: 101-102
- Berserker Rage: 103-104 + 115-116 (status)
- Heroic Throw: 105-106
- Storm Bolt: 107-108

**Next Available**: h125abc117+

---

## ACTION ECONOMY BREAKDOWN

### Actions (11)
- Mortal Strike, Slam, Execute, Heroic Throw, Storm Bolt, Warbreaker, Bladestorm, Heroic Leap (uses Action in BG3), Rallying Cry, Intimidating Shout, Rend

### Bonus Actions (11)
- Charge, Heroic Strike, Overpower, Skullsplitter, Deadly Calm, Sweeping Strikes, Hamstring, Victory Rush, Pummel, Berserker Rage, Die by the Sword, Spell Reflection, Battle Shout, Avatar

### Free Actions / Passives (0)
- All abilities require action economy

---

## COOLDOWN DISTRIBUTION

### No Cooldown (18)
- Heroic Strike, Slam, Mortal Strike, Overpower, Rend, Execute, Whirlwind, Thunder Clap, Hamstring, Victory Rush, Battle Shout, Rallying Cry, Intimidating Shout

### Once per Turn (3)
- Skullsplitter, Pummel, Heroic Throw

### Once per Short Rest (6)
- Colossus Smash, Sweeping Strikes, Deadly Calm, Berserker Rage, Storm Bolt, Shockwave

### Once per Long Rest (5)
- Avatar, Warbreaker, Bladestorm, Die by the Sword, Spell Reflection, Heroic Leap

---

## RAGE ECONOMY

### Generators (+Rage)
- Charge: +10
- Heroic Strike: +15
- Shield Slam: +15
- Skullsplitter: +20

### Low Spenders (10-20 Rage)
- Rend: 10
- Thunder Clap: 10
- Slam: 15
- Raging Blow: 15
- Execute: 20 (base)
- Revenge: 20
- Overpower: 20

### High Spenders (30-40 Rage)
- Mortal Strike: 30
- Colossus Smash: 40
- Warbreaker: 40
- Execute: up to 40 (with excess Rage)

### Free (0 Rage)
- All utilities, defensives, shouts, mobility
- Deadly Calm (makes everything free for 3 turns)

---

## IMPLEMENTATION STATUS

### ✅ Complete
- Base Warrior Kit (19 abilities)
- Arms Warrior (10 abilities)
- Baseline Utilities (7 abilities with feature tag)
- All supporting statuses (44 total)

### ⏸️ In Progress
- Fury Warrior (0/8 abilities)
- Protection Warrior (0/9 abilities)

### 📋 Planned
- Arms Passive Talents (~30 passives)
- Fury Passive Talents (~30 passives)
- Protection Passive Talents (~30 passives)
- English.loca.xml (~300+ handles)

---

## QUICK DISABLE GUIDE

### To Disable Utility Abilities
1. Open `Spell_Target.txt`
2. Search for `FEATURE_BASELINE_UTILITY`
3. Comment out sections (add `//` before each line)
4. Repeat for `Spell_Projectile.txt` and `Status_BOOST.txt`

### To Disable Specific Abilities
Search for ability name in format: `Target_WAR_AbilityName`
Comment out entire entry block

### To Disable Arms Subclass
Search for `ARMS WARRIOR SUBCLASS` in `Spell_Target.txt` and `Spell_Zone.txt`
Comment out sections

---

## TESTING PRIORITIES

### High Priority
1. ✅ Execute damage scaling
2. ✅ Rage generation (Charge, Heroic Strike, Shield Slam, Skullsplitter)
3. ✅ Major cooldowns (Avatar, Colossus Smash, Warbreaker, Bladestorm)
4. ✅ Armor reduction debuffs (-3 AC, -2 AC)

### Medium Priority
5. ⏸️ Utility abilities (Hamstring, Pummel, Storm Bolt)
6. ⏸️ Defensive abilities (Die by the Sword, Spell Reflection)
7. ⏸️ Support abilities (Battle Shout, Rallying Cry)

### Low Priority
8. ⏸️ Edge cases (Bladestorm concentration, Sweeping Strikes tracking)
9. ⏸️ Visual effects and animations
10. ⏸️ Localization handle display

---

**Last Updated**: October 16, 2025  
**Total Abilities**: 38 (19 base + 10 Arms + 7 utility + 1 Colossus + 1 placeholder)  
**Total Statuses**: 44  
**Total Passives**: 33 (specializations)  
**Next**: Fury Warrior implementation
