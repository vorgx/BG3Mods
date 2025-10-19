# SubclassSpec Talents: Arms Warrior - BG3 Implementation Guide

**Date:** October 17, 2025  
**Scope:** 24+ Arms-Specific Talents (Pool 2) - Arms Warrior Only  
**Implementation Status:** Design Complete, Ready for Stat Files

---

## Overview

**SubclassSpec Talents** are Arms-specific abilities available only to Arms Warriors across Levels 3-12. Players choose **1 talent per row** for a total of **9 choices** from **10 rows** of talents.

### Arms Identity

- **Playstyle:** Big single-target hits, bleeding damage, armor reduction
- **Resource:** High Rage costs (30-40), slower but harder-hitting
- **Key Mechanics:** Mortal Strike, Overpower, Rend, Colossus Smash
- **Theme:** Precision over speed, tactical debuff application

---

## Row-by-Row Implementation

### Row 1 (Level 3): Core Rotation Starters

**Theme:** Primary damage abilities

#### Mortal Strike (Priority Choice)

**File:** `Spell_Target.txt`

```
new entry "Target_ARMS_MortalStrike"
type "SpellData"
data "SpellType" "Target"
data "Level" "0"
data "UseCosts" "ActionPoint:1;Rage:30"
data "TargetRadius" "3"
data "TargetConditions" "Character() and not Dead()"
data "SpellSuccess" "DealDamage(2d12+StrengthModifier,MainMeleeWeaponDamageType,Magical);ApplyStatus(ARMS_MORTAL_WOUNDS,100,2)"
data "Cooldown" "OncePerTurn"
data "DisplayName" "hMortalStrike;1"
data "Description" "hMortalStrikeDesc;1"
data "Icon" "Spell_Warrior_MortalStrike"
data "TooltipDamageList" "DealDamage(2d12+StrengthModifier,MainMeleeWeaponDamageType)"
data "TooltipAttackSave" "MeleeWeaponAttack"
data "PrepareEffect" "VFX_Arms_MortalStrike_Prepare"
data "CastEffect" "VFX_Arms_MortalStrike_Cast"
data "TargetEffect" "VFX_Arms_MortalStrike_Impact"
```

**Status - Mortal Wounds:**
```
new entry "ARMS_MORTAL_WOUNDS"
type "StatusData"
data "StatusType" "BOOST"
data "DisplayName" "hMortalWounds;1"
data "Description" "hMortalWoundsDesc;1"
data "Icon" "Spell_Warrior_MortalStrike"
data "Boosts" "IncreaseHealingReceived(-50)"
data "StatusEffect" "VFX_MortalWounds"
data "RemoveEvents" "OnTurnEnd"
data "RemoveConditions" "TurnCounter(2)"
```

**BG3 Stats:**
- **Damage:** 2d12+STR (13-28+4 avg)
- **Cost:** 30 Rage (3 pips)
- **Cooldown:** OncePerTurn
- **Effect:** -50% healing received for 2 turns
- **Tags:** Single-Target, High Damage, Debuff

**WoW Comparison:**
- WoW: 180% weapon damage, 6s CD
- BG3: Higher relative damage (turn-based), longer CD (1 turn vs 1 GCD)

---

#### Overpower (Alternative Choice)

**File:** `Spell_Target.txt`

```
new entry "Target_ARMS_Overpower"
type "SpellData"
data "SpellType" "Target"
data "Level" "0"
data "UseCosts" "ActionPoint:1;Rage:30"
data "TargetRadius" "3"
data "TargetConditions" "Character() and not Dead()"
data "SpellSuccess" "DealDamage(2d10+StrengthModifier,MainMeleeWeaponDamageType,Magical);IF(HasStatus('ARMS_OVERPOWER_PROC',context.Source)):DealDamage(1d10,MainMeleeWeaponDamageType,Magical)"
data "Cooldown" "OncePerTurn"
data "DisplayName" "hOverpower;1"
data "Description" "hOverpowerDesc;1"
data "Icon" "Spell_Warrior_Overpower"
```

**Proc Passive (Triggered on Dodge/Parry):**
```
new entry "ARMS_Overpower_OnDodge"
type "PassiveData"
data "DisplayName" "hOverpowerProc;1"
data "Description" "hOverpowerProcDesc;1"
data "Icon" "Spell_Warrior_Overpower"
data "StatsFunctorContext" "OnDodge;OnParry"
data "Conditions" "Character()"
data "StatsFunctors" "ApplyStatus(SELF,ARMS_OVERPOWER_PROC,100,2)"
```

**Status - Overpower Proc:**
```
new entry "ARMS_OVERPOWER_PROC"
type "StatusData"
data "StatusType" "BOOST"
data "DisplayName" "hOverpowerReady;1"
data "Icon" "Spell_Warrior_Overpower_Proc"
data "RemoveEvents" "OnTurnEnd;OnSpellCast"
data "RemoveConditions" "TurnCounter(2) or SpellId('Target_ARMS_Overpower')"
```

**BG3 Stats:**
- **Base Damage:** 2d10+STR (12-24+4 avg)
- **Proc Damage:** +1d10 (if proc active)
- **Cost:** 30 Rage
- **Cooldown:** OncePerTurn
- **Proc:** Triggers on dodge/parry (lasts 2 turns)
- **Tags:** Single-Target, Proc-Based, Reactive

---

#### Rend (Alternative Choice - DoT Focus)

**File:** `Spell_Target.txt`

```
new entry "Target_ARMS_Rend"
type "SpellData"
data "SpellType" "Target"
data "Level" "0"
data "UseCosts" "ActionPoint:1;Rage:20"
data "TargetRadius" "3"
data "TargetConditions" "Character() and not Dead()"
data "SpellSuccess" "DealDamage(1d6+StrengthModifier,Slashing,Magical);ApplyStatus(ARMS_REND,100,3)"
data "DisplayName" "hRend;1"
data "Description" "hRendDesc;1"
data "Icon" "Spell_Warrior_Rend"
```

**Status - Bleeding:**
```
new entry "ARMS_REND"
type "StatusData"
data "StatusType" "BOOST"
data "DisplayName" "hRend;1"
data "Description" "hRendDesc;1"
data "Icon" "Spell_Warrior_Rend"
data "Boosts" "DamagePerTurn(2d6,Slashing)"
data "StackId" "ARMS_REND"
data "StackType" "Overwrite"
data "StatusEffect" "VFX_Bleeding"
data "RemoveEvents" "OnTurnEnd"
data "RemoveConditions" "TurnCounter(3)"
```

**BG3 Stats:**
- **Initial Damage:** 1d6+STR
- **DoT:** 2d6 per turn for 3 turns
- **Total Damage:** 1d6+STR + 6d6 (avg 24.5 total)
- **Cost:** 20 Rage (cheaper than Mortal Strike)
- **Tags:** DoT, Bleeding, Multi-Target Friendly

---

### Row 2 (Level 4): Armor Shredding

**Theme:** Debuff-focused abilities

#### Colossus Smash (High Impact Debuff)

**File:** `Spell_Target.txt`

```
new entry "Target_ARMS_ColossusSmash"
type "SpellData"
data "SpellType" "Target"
data "Level" "0"
data "UseCosts" "ActionPoint:1;Rage:40"
data "TargetRadius" "3"
data "TargetConditions" "Character() and not Dead()"
data "SpellSuccess" "DealDamage(2d10+StrengthModifier,MainMeleeWeaponDamageType,Magical);ApplyStatus(ARMS_COLOSSUS_SMASH,100,3)"
data "Cooldown" "UntilShortRest"
data "DisplayName" "hColossusSmash;1"
data "Description" "hColossusSmashDesc;1"
data "Icon" "Spell_Warrior_ColossusSmash"
```

**Status - Armor Shattered:**
```
new entry "ARMS_COLOSSUS_SMASH"
type "StatusData"
data "StatusType" "BOOST"
data "DisplayName" "hColossusSmashed;1"
data "Description" "hColossusSmashDesc;1"
data "Icon" "Spell_Warrior_ColossusSmash"
data "Boosts" "AC(-5);Resistance(Slashing,Vulnerable);Resistance(Piercing,Vulnerable);Resistance(Bludgeoning,Vulnerable)"
data "StatusEffect" "VFX_ColossusSmash_Cracked"
data "RemoveEvents" "OnTurnEnd"
data "RemoveConditions" "TurnCounter(3)"
```

**BG3 Stats:**
- **Damage:** 2d10+STR
- **Cost:** 40 Rage (expensive)
- **Cooldown:** Short Rest (major debuff)
- **Effect:** -5 AC, vulnerable to physical damage for 3 turns
- **Tags:** Single-Target, Debuff, Setup

---

#### Warbreaker (AoE Debuff Alternative)

**File:** `Spell_Shout.txt`

```
new entry "Shout_ARMS_Warbreaker"
type "SpellData"
data "SpellType" "Shout"
data "Level" "0"
data "UseCosts" "ActionPoint:1;Rage:40"
data "AreaRadius" "6"
data "TargetConditions" "Character() and not Self() and not Dead()"
data "SpellSuccess" "DealDamage(2d8,MainMeleeWeaponDamageType,Magical);ApplyStatus(ARMS_WARBREAKER,100,2)"
data "Cooldown" "UntilShortRest"
data "DisplayName" "hWarbreaker;1"
data "Description" "hWarbreakerDesc;1"
data "Icon" "Spell_Warrior_Warbreaker"
```

**Status - Weakened Armor:**
```
new entry "ARMS_WARBREAKER"
type "StatusData"
data "StatusType" "BOOST"
data "DisplayName" "hWarbroken;1"
data "Icon" "Spell_Warrior_Warbreaker"
data "Boosts" "AC(-3)"
data "RemoveEvents" "OnTurnEnd"
data "RemoveConditions" "TurnCounter(2)"
```

**BG3 Stats:**
- **Damage:** 2d8 (AoE, no modifier)
- **Cost:** 40 Rage
- **Cooldown:** Short Rest
- **AoE:** 6m radius
- **Effect:** -3 AC for 2 turns (multi-target)
- **Tags:** AoE, Debuff, Multi-Target

---

### Row 3 (Level 5): Cleave and Sweeping

**Theme:** Multi-target damage

#### Cleave (Frontal Cone AoE)

**File:** `Spell_Zone.txt`

```
new entry "Zone_ARMS_Cleave"
type "SpellData"
data "SpellType" "Zone"
data "Level" "0"
data "UseCosts" "ActionPoint:1;Rage:20"
data "TargetRadius" "3"
data "AreaRadius" "3"
data "Shape" "Cone"
data "TargetConditions" "Character() and not Dead()"
data "SpellSuccess" "DealDamage(1d12+StrengthModifier,MainMeleeWeaponDamageType,Magical)"
data "Cooldown" "OncePerTurn"
data "DisplayName" "hCleave;1"
data "Description" "hCleaveDesc;1"
data "Icon" "Spell_Warrior_Cleave"
```

**BG3 Stats:**
- **Damage:** 1d12+STR per target
- **Cost:** 20 Rage
- **Cooldown:** OncePerTurn
- **Shape:** 3m cone (frontal arc)
- **Tags:** AoE, Cone, Multi-Target

---

#### Sweeping Strikes (Attack Duplication)

**File:** `Spell_Shout.txt`

```
new entry "Shout_ARMS_SweepingStrikes"
type "SpellData"
data "SpellType" "Shout"
data "UseCosts" "BonusActionPoint:1"
data "SpellSuccess" "ApplyStatus(SELF,ARMS_SWEEPING_STRIKES,100,2)"
data "Cooldown" "UntilShortRest"
data "DisplayName" "hSweepingStrikes;1"
data "Description" "hSweepingStrikesDesc;1"
data "Icon" "Spell_Warrior_SweepingStrikes"
```

**Status - Sweeping Strikes (On Hit Trigger):**
```
new entry "ARMS_SWEEPING_STRIKES"
type "StatusData"
data "StatusType" "BOOST"
data "DisplayName" "hSweepingStrikes;1"
data "Icon" "Spell_Warrior_SweepingStrikes"
data "StatsFunctorContext" "OnDamage"
data "Conditions" "DamageType(Slashing) or DamageType(Piercing) or DamageType(Bludgeoning)"
data "StatsFunctors" "DealDamage(MainMeleeWeaponDamageType,50%)"
data "RemoveEvents" "OnTurnEnd"
data "RemoveConditions" "TurnCounter(2)"
```

**BG3 Stats:**
- **Cost:** Bonus Action
- **Cooldown:** Short Rest
- **Effect:** Melee attacks hit 1 additional nearby target for 50% damage (2 turns)
- **Tags:** Buff, Multi-Target, Damage Amplification

---

### Rows 4-10: Summary Table

| Row | Level | Theme | Priority Talents | Implementation Notes |
|-----|-------|-------|------------------|---------------------|
| **4** | L6 | Execute Phase | Execute, Sudden Death Execute | Already implemented ✅ |
| **5** | L7 | Utility | Hamstring, Piercing Howl | Slows, movement impairment |
| **6** | L8 | Bleeds | Deep Wounds, Massacre | Rend enhancements |
| **7** | L9 | Rage Dump | Slam, Slam (Empowered) | Low-cost spender |
| **8** | L10 | Defensive | Defensive Stance, Duel | Survivability |
| **9** | L11 | Burst | Bladestorm, Ravager | Major AoE cooldowns |
| **10** | L12 | Mastery | Strength of Arms, Test of Might | Passive enhancements |

---

## Implementation Priorities

### Phase 1: Core Arms Rotation (HIGH PRIORITY)

**Must-Have:**
1. ✅ Execute (Already implemented)
2. **Mortal Strike** (Row 1)
3. **Overpower** (Row 1 alternative)
4. **Colossus Smash** (Row 2)
5. **Cleave** (Row 3)

**Estimated Time:** 10 hours (4 new abilities + testing)

### Phase 2: Bleeds and DoTs (MEDIUM PRIORITY)

6. **Rend** (Row 1 alternative)
7. **Deep Wounds** (Row 6 passive)
8. **Hamstring** (Row 5)

**Estimated Time:** 6 hours (3 abilities, DoT mechanics)

### Phase 3: Major Cooldowns (LOW PRIORITY)

9. **Bladestorm** (Row 9)
10. **Ravager** (Row 9 alternative)
11. **Sweeping Strikes** (Row 3 alternative)

**Estimated Time:** 8 hours (3 complex abilities)

---

## Localization Requirements

**Total Handles Needed:** ~50 (2 per talent × 24 talents + status effects)

**Example Block:**
```xml
<contentList>
    <content contentuid="hMortalStrike" version="1">Mortal Strike</content>
    <content contentuid="hMortalStrikeDesc" version="1">A vicious strike for 2d12+STR damage that reduces healing by 50% for 2 turns. Costs 30 Rage.</content>
    
    <content contentuid="hMortalWounds" version="1">Mortal Wounds</content>
    <content contentuid="hMortalWoundsDesc" version="1">Healing received reduced by 50%.</content>
    
    <!-- ... continue for all talents ... -->
</contentList>
```

---

## Arms-Specific Mechanics

### Mortal Wounds System

**Key Feature:** Healing reduction debuff

**Implementation:**
- Applied by: Mortal Strike, Overpower (with talent)
- Duration: 2 turns
- Effect: -50% healing received
- Stacking: Overwrites (refresh duration)

**Balance Note:** Stronger than WoW (-25%) because turn-based = fewer heal opportunities

### Overpower Proc System

**Key Feature:** Reactive damage boost

**Trigger:** On dodge or parry an attack
**Duration:** 2 turns (proc lasts)
**Effect:** Next Overpower deals +1d10 damage

**Implementation:** Passive listener + status flag + conditional damage

### Bleeding Mechanics

**Key Feature:** Damage over time stacking

**Bleed Sources:**
- Rend (2d6/turn, 3 turns)
- Deep Wounds (1d6/turn, 4 turns, triggered by crits)
- Hamstring (1d4/turn, 2 turns)

**Stacking:** Different bleeds stack, same bleeds overwrite (refresh duration)

---

## Testing Checklist

### Arms-Specific Tests

- [ ] Mortal Strike applies Mortal Wounds (-50% healing)
- [ ] Mortal Wounds reduces healing from potions/spells
- [ ] Overpower proc activates on dodge/parry
- [ ] Overpower deals bonus damage when proc active
- [ ] Colossus Smash reduces AC by 5
- [ ] Colossus Smash makes target vulnerable to physical
- [ ] Rend bleed ticks each turn for 3 turns
- [ ] Multiple bleeds stack (Rend + Deep Wounds)
- [ ] Cleave hits all enemies in frontal cone
- [ ] Sweeping Strikes duplicates melee attacks to nearby targets

### Balance Tests

- [ ] Arms damage comparable to Fury/Protection
- [ ] Rage costs feel balanced (30-40 for big hits)
- [ ] Cooldowns prevent spam (Short Rest for major abilities)
- [ ] Debuffs provide meaningful team benefit
- [ ] DoT damage competitive with direct damage

---

## Full Documentation Reference

For complete Arms Warrior talent system, see:

- **`ARMS_WARRIOR_5_POOL_TALENT_SYSTEM.md`** - Complete 5-pool design (95KB)
- **`Arms_Warrior_Talents_Extracted.md`** - WoW source data
- **`WOW_TO_BG3_ABILITY_CONVERSION_GUIDE.md`** - Conversion methodology

---

## Conclusion

**Arms SubclassSpec Talents** define the Arms Warrior playstyle:

- **Big hits:** Mortal Strike (2d12+STR), Colossus Smash (2d10+STR + debuff)
- **Bleeds:** Rend (6d6 total), Deep Wounds (4d6 total)
- **Debuffs:** Mortal Wounds (-50% healing), Colossus Smash (-5 AC + vulnerable)
- **AoE:** Cleave (cone), Sweeping Strikes (attack duplication), Bladestorm

**Estimated Implementation Time:** 24 hours (all 24 talents)

**Status:** ✅ **DESIGN COMPLETE - READY FOR IMPLEMENTATION**

---

**Last Updated:** October 17, 2025  
**Next Steps:** Begin Phase 1 (Core Rotation - 10 hours)
