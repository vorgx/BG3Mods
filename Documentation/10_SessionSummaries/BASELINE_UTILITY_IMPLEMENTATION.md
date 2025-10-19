# Baseline Warrior Utility Implementation Summary

## Overview
Successfully implemented 7 missing baseline Warrior abilities with **FEATURE_BASELINE_UTILITY** tag for easy toggle control.

**Feature Tag**: `FEATURE_BASELINE_UTILITY`
- **Purpose**: Allows disabling all utility abilities if they cause balance issues
- **Implementation**: Add comment tag to each ability section
- **Toggle Method**: Comment out or remove abilities by searching for this tag

---

## FILES MODIFIED

### 1. Spell_Target.txt
Added 5 melee/self-target utility abilities:

#### Hamstring
- **Type**: Bonus Action melee attack
- **Damage**: 1d6 + STR (Slashing)
- **Effect**: Applies WAR_HAMSTRING (-3 Movement for 3 turns)
- **Tooltip**: h125abc95-96
- **Purpose**: Movement control, kiting, preventing escapes
- **WoW Fidelity**: Maintained snare mechanic

#### Victory Rush
- **Type**: Bonus Action melee attack
- **Damage**: 1d8 + STR
- **Effect**: Heals self for 2d8 + CON on hit
- **Tooltip**: h125abc97-98
- **Purpose**: Conditional sustain heal (rewarding aggression)
- **WoW Fidelity**: "Free heal after getting a kill" adapted to heal on hit

#### Pummel
- **Type**: Bonus Action melee attack
- **Damage**: 1d4 + STR (Bludgeoning)
- **Cooldown**: Once per Turn
- **Effect**: Applies WAR_PUMMEL (Silence for 1 turn)
- **Tooltip**: h125abc99-100
- **Purpose**: Low-cooldown interrupt for spellcasters
- **WoW Fidelity**: Maintained interrupt mechanic (as Silence in BG3)

#### Slam
- **Type**: Action melee attack
- **Damage**: 2d6 + STR (Bludgeoning)
- **Cost**: 15 Rage
- **Tooltip**: h125abc101-102
- **Purpose**: Alternative rage spender to Heroic Strike
- **WoW Fidelity**: "Initial rage spender" - basic damage option

#### Berserker Rage
- **Type**: Bonus Action self-buff
- **Duration**: 2 turns
- **Cooldown**: Once per Short Rest
- **Effect**: Applies WAR_BERSERKER_RAGE (CC immunity + removal)
- **Tooltip**: h125abc103-104
- **Purpose**: Preemptive or reactive CC break
- **WoW Fidelity**: "CC removal" - grants Fear/Charm/Flee immunity

### 2. Spell_Projectile.txt (NEW FILE)
Created new file for ranged projectile attacks:

#### Heroic Throw
- **Type**: Action ranged attack
- **Damage**: 1d4 + STR (Piercing)
- **Range**: 18m
- **Cooldown**: Once per Turn
- **Tooltip**: h125abc105-106
- **Purpose**: Low-damage ranged pull/poke
- **WoW Fidelity**: "Pitifully low damage" maintained - utility, not damage
- **BG3 Adaptation**: Useful for pulling, breaking concentration, tagging enemies

#### Storm Bolt
- **Type**: Action ranged attack
- **Damage**: 2d6 + STR (Thunder)
- **Range**: 18m
- **Cooldown**: Once per Short Rest
- **Effect**: Applies STUNNED for 2 turns
- **Tooltip**: h125abc107-108
- **Purpose**: Ranged stun on low cooldown
- **WoW Fidelity**: "Useful ranged stun on relatively low cooldown"
- **BG3 Adaptation**: Short Rest CD makes it valuable control option

### 3. Status_BOOST.txt
Added 4 supporting statuses:

#### WAR_HAMSTRING (h125abc109-110)
- **Effect**: ActionResource(Movement,-3,0)
- **Duration**: 3 turns
- **Applied by**: Hamstring
- **Purpose**: Reduces movement speed by 3m

#### WAR_VICTORY_RUSH_HEAL (h125abc111-112)
- **Effect**: OnApplyFunctors: RegainHitPoints(2d8+ConstitutionModifier)
- **Hidden**: DisableCombatlog, DisablePortraitIndicator
- **Applied by**: Victory Rush
- **Purpose**: Instant heal on application

#### WAR_PUMMEL (h125abc113-114)
- **Effect**: StatusImmunity(SG_Condition)
- **Duration**: 1 turn
- **Applied by**: Pummel
- **Purpose**: Prevents casting (Silence effect)

#### WAR_BERSERKER_RAGE (h125abc115-116)
- **Effect**: 
  - StatusImmunity(FRIGHTENED, CHARMED, SG_Fleeing)
  - OnApplyFunctors: RemoveStatus(FRIGHTENED, CHARMED, SG_Fleeing)
- **Duration**: 2 turns
- **Applied by**: Berserker Rage
- **Purpose**: CC immunity + removal on activation

---

## IMPLEMENTATION STATS

### Abilities Added
- **Target Spells**: 5 (Hamstring, Victory Rush, Pummel, Slam, Berserker Rage)
- **Projectile Spells**: 2 (Heroic Throw, Storm Bolt)
- **Total**: 7 baseline utility abilities

### Statuses Added
- **Total**: 4 new statuses
- **Debuffs**: 2 (Hamstring, Pummel)
- **Buffs**: 2 (Victory Rush Heal, Berserker Rage)

### Localization Handles
- **Abilities**: 14 handles (h125abc95 - h125abc108)
- **Statuses**: 8 handles (h125abc109 - h125abc116)
- **Total**: 22 new handles

---

## DESIGN DECISIONS

### Action Economy Distribution
- **Actions**: 3 (Slam, Heroic Throw, Storm Bolt)
- **Bonus Actions**: 4 (Hamstring, Victory Rush, Pummel, Berserker Rage)

### Cooldown Tiers
- **No Cooldown**: Hamstring, Victory Rush, Slam
- **Once per Turn**: Pummel, Heroic Throw
- **Once per Short Rest**: Berserker Rage, Storm Bolt

### Rage Economy
- **Free**: All utility abilities except Slam
- **Spender**: Slam (15 Rage)
- **Design**: Utilities don't consume Rage to remain accessible

### Damage Scaling
- **Minimal**: Heroic Throw (1d4) - pull/utility
- **Low**: Pummel (1d4), Hamstring (1d6) - control focus
- **Medium**: Victory Rush (1d8), Slam (2d6), Storm Bolt (2d6) - balanced

---

## FEATURE TAG IMPLEMENTATION

### How to Disable Baseline Utilities

**Method 1: Comment Out in Spell Files**
```
// Feature Tag: FEATURE_BASELINE_UTILITY - DISABLED
/*
new entry "Target_WAR_Hamstring"
type "SpellData"
... (rest of ability)
*/
```

**Method 2: Search and Remove**
1. Search for `FEATURE_BASELINE_UTILITY` in all stat files
2. Delete or comment sections between markers
3. Keep section headers for reference

**Method 3: Conditional Compilation**
- Use build scripts to exclude abilities with this tag
- Create separate "Full" and "Core" versions of mod

### What to Disable
If utilities cause issues, disable in this order (least to most impactful):

1. **Heroic Throw** - Low priority (minimal damage ranged)
2. **Slam** - Covered by Heroic Strike
3. **Hamstring** - Snares less critical in turn-based
4. **Berserker Rage** - CC less prevalent in BG3
5. **Pummel** - Keep if interrupts are valuable
6. **Storm Bolt** - Keep (strong control option)
7. **Victory Rush** - Keep (sustain is always useful)

---

## TACTICAL ANALYSIS

### High Value Utilities ⭐
1. **Storm Bolt** - Ranged stun on Short Rest CD
2. **Victory Rush** - Free healing on hit
3. **Pummel** - Per-turn interrupt

### Situational Utilities
4. **Berserker Rage** - CC break (depends on encounter design)
5. **Hamstring** - Movement control (useful vs mobile enemies)

### Low Impact Utilities
6. **Heroic Throw** - Ranged poke (mostly for pulling)
7. **Slam** - Alternative spender (redundant with Heroic Strike)

---

## BALANCE CONSIDERATIONS

### Potential Issues
1. **Action Economy Bloat**: 7 more abilities in hotbar
   - **Solution**: Use feature tag to disable low-priority ones
   
2. **Bonus Action Competition**: 4 bonus action options
   - **Solution**: Players can choose based on situation
   
3. **Cooldown Management**: Only 2 have cooldowns (Storm Bolt, Berserker Rage)
   - **Impact**: Minimal - most are free/low-cost utilities

### Why These Are Safe
- **Low Rage Costs**: Only Slam costs Rage (15)
- **Situational Use**: Most are reactive/conditional
- **Low Damage**: Damage values kept minimal (1d4-2d6)
- **Cooldown Gated**: Strong effects have Short Rest CDs

---

## WOW SOURCE FIDELITY

### Maintained Mechanics
- ✅ **Hamstring**: Movement snare
- ✅ **Victory Rush**: Heal after kill (adapted to heal on hit)
- ✅ **Pummel**: Interrupt (as Silence)
- ✅ **Slam**: Basic rage spender
- ✅ **Berserker Rage**: CC removal
- ✅ **Heroic Throw**: Low damage ranged
- ✅ **Storm Bolt**: Ranged stun

### BG3 Adaptations
- **Victory Rush**: Changed from "after kill" to "on hit" (more reliable in turn-based)
- **Pummel**: Silence instead of cast interrupt (BG3 equivalent)
- **Heroic Throw**: 18m range (BG3 ranged standard)
- **Storm Bolt**: Stun duration 2 turns (balanced for turn-based)

---

## TESTING CHECKLIST

### Functionality
- [ ] Hamstring reduces movement by 3m for 3 turns
- [ ] Victory Rush heals on successful hit
- [ ] Pummel applies Silence for 1 turn
- [ ] Slam deals damage and costs 15 Rage
- [ ] Berserker Rage removes and prevents CC
- [ ] Heroic Throw hits at 18m range
- [ ] Storm Bolt stuns for 2 turns

### Tooltips
- [ ] All DisplayName handles show proper names
- [ ] All Description handles show proper descriptions
- [ ] DescriptionParams populate [#] placeholders correctly

### Balance
- [ ] Abilities don't overshadow core rotation
- [ ] Rage costs appropriate for power level
- [ ] Cooldowns prevent spam of strong effects

---

## NEXT STEPS

### Immediate
- ✅ Baseline utilities implemented
- ⏸️ Continue with Fury Warrior subclass (8 abilities)
- ⏸️ Continue with Protection Warrior subclass (9 abilities)

### Future Enhancements
1. **Passive Talents** - Create ~30 Arms passive talents in Passive.txt
2. **Talent Interactions** - Add talents that modify these utilities:
   - Double Time (2 charges of Charge)
   - Honed Reflexes (improved Die by the Sword)
   - Piercing Howl (upgrade to Hamstring)

### Localization
- Add 22 new handles to English.loca.xml
- Range now: h125abc01 - h125abc116 (116 handles total)

---

## FINAL STATUS

**Baseline Warrior Kit**: ✅ **COMPLETE**

### All Implemented Abilities (31 total)
**Core Rotation** (12):
- Heroic Strike, Charge, Execute, Mortal Strike, Shield Slam, Raging Blow, Avatar, Whirlwind, Thunder Clap, Shockwave, Revenge, Demolish

**Defensive** (2):
- Die by the Sword, Spell Reflection

**Support** (3):
- Battle Shout, Rallying Cry, Intimidating Shout

**Mobility** (1):
- Heroic Leap

**Utility** (7 - NEW):
- Hamstring, Victory Rush, Pummel, Slam, Berserker Rage, Heroic Throw, Storm Bolt

**Arms Subclass** (10):
- Overpower, Colossus Smash, Sweeping Strikes, Warbreaker, Rend, Skullsplitter, Bladestorm, Deadly Calm

**Protection** (Planned):
- Devastate, Shield Block, Ignore Pain, Demoralizing Shout, Last Stand, Taunt, Impending Victory, Shield Charge, Ravager

**Fury** (Planned):
- Bloodthirst, Rampage, Recklessness, Enraged Regeneration, Onslaught, Bladestorm, Ravager, Odyn's Fury

---

## FEATURE TAG SUMMARY

**Tag**: `FEATURE_BASELINE_UTILITY`
**Location**: Spell_Target.txt, Spell_Projectile.txt, Status_BOOST.txt
**Abilities Tagged**: 7 (Hamstring, Victory Rush, Pummel, Slam, Berserker Rage, Heroic Throw, Storm Bolt)
**Statuses Tagged**: 4 (WAR_HAMSTRING, WAR_VICTORY_RUSH_HEAL, WAR_PUMMEL, WAR_BERSERKER_RAGE)
**Purpose**: Easy enable/disable toggle for balance testing
**Recommendation**: Keep enabled unless testing shows issues

---

**Date**: October 16, 2025  
**Status**: ✅ Baseline utilities complete with feature tagging  
**Next**: Fury Warrior subclass implementation
