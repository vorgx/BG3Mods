# Class Talents - BG3 Implementation Guide

**Date:** October 17, 2025  
**Scope:** 24+ Class Talents (Pool 1) - Shared by all Warriors  
**Implementation Status:** Design Complete, Ready for Stat Files

---

## Overview

**Class Talents** are shared abilities available to all Warriors (Arms, Fury, Protection) across Levels 1-12. Players choose **1 talent per row** for a total of **9 choices** from **10 rows** of talents.

### Structure

- **Pool:** Class Talents (Pool 1 of 5-pool system)
- **Availability:** All Warriors
- **Levels:** 1-12
- **Rows:** 10 (one row per level, skip L5 for Extra Attack milestone)
- **Choices:** 9 total (pick 1 per row)
- **Total Talents:** 24+ abilities designed

---

## Row-by-Row Implementation

### Row 1 (Level 1): Mobility / Gap Closers

**Theme:** How you engage enemies

#### Charge (Default - Already Implemented ✅)

**File:** `Spell_Jump.txt`

```
new entry "Jump_WAR_Charge"
type "SpellData"
data "SpellType" "Jump"
data "Level" "0"
data "UseCosts" "ActionPoint:1"
data "TargetRadius" "18"
data "AreaRadius" "3"
data "TargetConditions" "Character() and not Self() and not Dead()"
data "SpellSuccess" "ApplyStatus(context.Target,WAR_ROOTED,100,1);DealDamage(1d4+StrengthModifier,Bludgeoning,Magical);ApplyStatus(SELF,WAR_CHARGE_RAGE,100,0)"
data "Cooldown" "OncePerTurn"
data "DisplayName" "hCharge;1"
data "Description" "hChargeDesc;1"
data "Icon" "Spell_Warrior_Charge"
data "PrepareEffect" "VFX_Warrior_Charge_Prepare"
data "CastEffect" "VFX_Warrior_Charge_Cast"
data "TargetEffect" "VFX_Warrior_Charge_Impact"
```

**Status - Rage Generation:**
```
new entry "WAR_CHARGE_RAGE"
type "StatusData"
data "StatusType" "BOOST"
data "Boosts" "ActionResource(Rage,20,0)"
data "StatusPropertyFlags" "DisableCombatlog;DisableOverhead;DisablePortraitIndicator"
data "RemoveEvents" "OnApply"
```

**BG3 Stats:**
- **Type:** Action, Gap Closer (Jump)
- **Range:** 18m
- **Cooldown:** OncePerTurn
- **Damage:** 1d4+STR
- **Effect:** Root target 1 turn, gain 20 Rage
- **Tags:** Mobility, Builder, Crowd Control

---

#### Heroic Leap (Alternative Choice)

**File:** `Spell_Zone.txt`

```
new entry "Zone_WAR_HeroicLeap"
type "SpellData"
data "SpellType" "Zone"
data "Level" "0"
data "UseCosts" "ActionPoint:1"
data "TargetRadius" "18"
data "AreaRadius" "4"
data "TargetConditions" "Character() and not Dead()"
data "SpellSuccess" "DealDamage(2d6,Bludgeoning,Magical)"
data "Cooldown" "UntilShortRest"
data "DisplayName" "hHeroicLeap;1"
data "Description" "hHeroicLeapDesc;1"
data "Icon" "Spell_Warrior_HeroicLeap"
data "PrepareEffect" "VFX_Warrior_HeroicLeap_Prepare"
data "CastEffect" "VFX_Warrior_HeroicLeap_Jump"
data "TargetEffect" "VFX_Warrior_HeroicLeap_Impact"
```

**BG3 Stats:**
- **Type:** Action, Ground-Targeted AoE
- **Range:** 18m (leap destination)
- **AoE:** 4m radius at landing
- **Cooldown:** Short Rest
- **Damage:** 2d6 (no modifier, AoE damage)
- **Tags:** Mobility, AoE, Damage

---

#### Intervene (Alternative Choice)

**File:** `Spell_Jump.txt`

```
new entry "Jump_WAR_Intervene"
type "SpellData"
data "SpellType" "Jump"
data "Level" "0"
data "UseCosts" "ActionPoint:1"
data "TargetRadius" "18"
data "TargetConditions" "Ally() and not Self() and not Dead()"
data "SpellSuccess" "ApplyStatus(context.Target,WAR_INTERVENE_PROTECT,100,1);ApplyStatus(SELF,WAR_INTERVENE_TANK,100,1)"
data "Cooldown" "OncePerTurn"
data "DisplayName" "hIntervene;1"
data "Description" "hInterveneDesc;1"
data "Icon" "Spell_Warrior_Intervene"
```

**Status - Protect Ally:**
```
new entry "WAR_INTERVENE_PROTECT"
type "StatusData"
data "StatusType" "BOOST"
data "DisplayName" "hInterveneProtected;1"
data "Icon" "Spell_Warrior_Intervene"
data "Boosts" "AC(2)"
data "RemoveEvents" "OnTurnEnd"
data "RemoveConditions" "TurnCounter(1)"
```

**Status - Self (Tank Attacks):**
```
new entry "WAR_INTERVENE_TANK"
type "StatusData"
data "StatusType" "BOOST"
data "Boosts" "Disadvantage(AttackTarget,Melee,All,All,context.Target)"
data "RemoveEvents" "OnTurnEnd"
data "RemoveConditions" "TurnCounter(1)"
```

**BG3 Stats:**
- **Type:** Action, Ally Leap
- **Range:** 18m (leap to ally)
- **Cooldown:** OncePerTurn
- **Effect:** Ally +2 AC, enemies have disadvantage attacking ally for 1 turn
- **Tags:** Mobility, Utility, Protection

---

### Row 2 (Level 2): Party Buffs

**Theme:** Shouts and raid-wide effects

#### Battle Shout (Default - Already Implemented ✅)

**File:** `Spell_Shout.txt`

```
new entry "Shout_WAR_BattleShout"
type "SpellData"
data "SpellType" "Shout"
data "Level" "0"
data "UseCosts" "BonusActionPoint:1"
data "AreaRadius" "9"
data "TargetConditions" "Ally() and not Dead()"
data "SpellSuccess" "ApplyStatus(WAR_BATTLE_SHOUT,100,5)"
data "Cooldown" "UntilShortRest"
data "DisplayName" "hBattleShout;1"
data "Description" "hBattleShoutDesc;1"
data "Icon" "Spell_Warrior_BattleShout"
data "CastEffect" "VFX_Warrior_BattleShout"
```

**Status:**
```
new entry "WAR_BATTLE_SHOUT"
type "StatusData"
data "StatusType" "BOOST"
data "DisplayName" "hBattleShoutStatus;1"
data "Icon" "Spell_Warrior_BattleShout"
data "Boosts" "Advantage(AttackRoll)"
data "RemoveEvents" "OnTurnEnd"
data "RemoveConditions" "TurnCounter(5)"
```

**BG3 Stats:**
- **Type:** Bonus Action, AoE Buff
- **Range:** 9m radius
- **Cooldown:** Short Rest
- **Effect:** Advantage on attack rolls for 5 turns
- **Tags:** Utility, Support, Buff

---

#### Commanding Shout (Alternative Choice)

**File:** `Spell_Shout.txt`

```
new entry "Shout_WAR_CommandingShout"
type "SpellData"
data "SpellType" "Shout"
data "UseCosts" "BonusActionPoint:1"
data "AreaRadius" "9"
data "TargetConditions" "Ally() and not Dead()"
data "SpellSuccess" "ApplyStatus(WAR_COMMANDING_SHOUT,100,5)"
data "Cooldown" "UntilShortRest"
data "DisplayName" "hCommandingShout;1"
data "Description" "hCommandingShoutDesc;1"
data "Icon" "Spell_Warrior_CommandingShout"
```

**Status:**
```
new entry "WAR_COMMANDING_SHOUT"
type "StatusData"
data "StatusType" "BOOST"
data "DisplayName" "hCommandingShoutStatus;1"
data "Icon" "Spell_Warrior_CommandingShout"
data "Boosts" "TemporaryHP(20)"
data "RemoveEvents" "OnTurnEnd"
data "RemoveConditions" "TurnCounter(5)"
```

**BG3 Stats:**
- **Type:** Bonus Action, AoE Buff
- **Range:** 9m radius
- **Cooldown:** Short Rest
- **Effect:** +20 Temporary HP for 5 turns
- **Tags:** Utility, Support, Survivability

---

#### Rallying Cry (Alternative Choice)

**File:** `Spell_Shout.txt`

```
new entry "Shout_WAR_RallyingCry"
type "SpellData"
data "SpellType" "Shout"
data "UseCosts" "BonusActionPoint:1"
data "AreaRadius" "9"
data "TargetConditions" "Ally() and not Dead()"
data "SpellSuccess" "RegainHitPoints(2d8)"
data "Cooldown" "UntilLongRest"
data "DisplayName" "hRallyingCry;1"
data "Description" "hRallyingCryDesc;1"
data "Icon" "Spell_Warrior_RallyingCry"
```

**BG3 Stats:**
- **Type:** Bonus Action, AoE Heal
- **Range:** 9m radius
- **Cooldown:** Long Rest (once per day)
- **Effect:** Heal allies for 2d8 HP
- **Tags:** Utility, Support, Healing

---

### Row 3 (Level 3): Defensive Cooldowns

**Theme:** Damage reduction and survivability

#### Berserker Rage (Default - Already Implemented ✅)

**File:** `Spell_Shout.txt`

```
new entry "Shout_WAR_BerserkerRage"
type "SpellData"
data "SpellType" "Shout"
data "UseCosts" "BonusActionPoint:1"
data "SpellSuccess" "ApplyStatus(SELF,WAR_BERSERKER_RAGE,100,3);RemoveStatus(FRIGHTENED);RemoveStatus(CHARMED)"
data "Cooldown" "UntilShortRest"
data "DisplayName" "hBerserkerRage;1"
data "Description" "hBerserkerRageDesc;1"
data "Icon" "Spell_Warrior_BerserkerRage"
```

**Status:**
```
new entry "WAR_BERSERKER_RAGE"
type "StatusData"
data "StatusType" "BOOST"
data "DisplayName" "hBerserkerRageStatus;1"
data "Icon" "Spell_Warrior_BerserkerRage"
data "Boosts" "StatusImmunity(FRIGHTENED);StatusImmunity(CHARMED);Advantage(SavingThrow,Wisdom)"
data "RemoveEvents" "OnTurnEnd"
data "RemoveConditions" "TurnCounter(3)"
```

**BG3 Stats:**
- **Type:** Bonus Action, Self-Buff
- **Cooldown:** Short Rest
- **Effect:** Immune to Fear/Charm, Advantage on Wisdom saves for 3 turns
- **Tags:** Defensive, Utility, Crowd Control Immunity

---

#### Die by the Sword (Alternative Choice)

**File:** `Spell_Shout.txt`

```
new entry "Shout_WAR_DiebytheSword"
type "SpellData"
data "SpellType" "Shout"
data "UseCosts" "BonusActionPoint:1"
data "SpellSuccess" "ApplyStatus(SELF,WAR_DIE_BY_SWORD,100,2)"
data "Cooldown" "UntilShortRest"
data "DisplayName" "hDiebytheSword;1"
data "Description" "hDiebytheSwordDesc;1"
data "Icon" "Spell_Warrior_DiebytheSword"
```

**Status:**
```
new entry "WAR_DIE_BY_SWORD"
type "StatusData"
data "StatusType" "BOOST"
data "DisplayName" "hDiebytheSwordStatus;1"
data "Icon" "Spell_Warrior_DiebytheSword"
data "Boosts" "AC(5)"
data "StatusEffect" "VFX_Warrior_DiebytheSword_Aura"
data "RemoveEvents" "OnTurnEnd"
data "RemoveConditions" "TurnCounter(2)"
```

**BG3 Stats:**
- **Type:** Bonus Action, Self-Buff
- **Cooldown:** Short Rest
- **Effect:** +5 AC for 2 turns (major defensive cooldown)
- **Tags:** Defensive, Survival

---

#### Defensive Stance (Alternative Choice)

**File:** `Spell_Shout.txt`

```
new entry "Shout_WAR_DefensiveStance"
type "SpellData"
data "SpellType" "Shout"
data "UseCosts" "BonusActionPoint:1"
data "SpellSuccess" "ApplyStatus(SELF,WAR_DEFENSIVE_STANCE,100,-1)"
data "DisplayName" "hDefensiveStance;1"
data "Description" "hDefensiveStanceDesc;1"
data "Icon" "Spell_Warrior_DefensiveStance"
```

**Status:**
```
new entry "WAR_DEFENSIVE_STANCE"
type "StatusData"
data "StatusType" "BOOST"
data "DisplayName" "hDefensiveStanceStatus;1"
data "Icon" "Spell_Warrior_DefensiveStance"
data "Boosts" "Resistance(Slashing,Resistant);Resistance(Piercing,Resistant);Resistance(Bludgeoning,Resistant);Damage(All,-10)"
data "StackId" "WAR_DEFENSIVE_STANCE"
data "ToggleOnEffect" "VFX_Warrior_DefensiveStance_On"
data "ToggleOffEffect" "VFX_Warrior_DefensiveStance_Off"
data "RemoveEvents" "OnReapply"
```

**BG3 Stats:**
- **Type:** Bonus Action, Toggle Stance
- **Effect:** Resistance to physical damage, -10% damage dealt (toggle on/off)
- **Tags:** Defensive, Stance, Toggle

---

### Rows 4-10 Summary Table

Due to space constraints, remaining rows are summarized. Full implementations available in separate detailed files.

| Row | Level | Theme | Talent Options | Priority |
|-----|-------|-------|----------------|----------|
| **4** | L4 | Rage Management | Enrage, Unbridled Fury, Focused Rage | High |
| **5** | *(Skip - Extra Attack)* | — | — | — |
| **6** | L6 | Interrupts/Utility | Pummel, Spell Reflection, Intimidating Shout | Medium |
| **7** | L7 | Sustain | Victory Rush, Impending Victory, Second Wind | High |
| **8** | L8 | AoE Damage | Whirlwind, Cleave, Thunder Clap | High |
| **9** | L9 | Execute Phase | Sudden Death, Massacre, Execute Mastery | Medium |
| **10** | L10 | Mobility/Rage | Juggernaut, War Machine, Bounding Stride | Low |
| **11** | L12 | Ultimate Utility | Avatar, Recklessness, Bladestorm | High |

---

## Implementation Priorities

### Phase 1: Core Rotation (HIGH)

**Must-Have for Basic Gameplay:**

1. ✅ Charge (Already implemented)
2. ✅ Battle Shout (Already implemented)
3. ✅ Berserker Rage (Already implemented)
4. **Victory Rush** (Row 7 - Healing)
5. **Whirlwind** (Row 8 - AoE)
6. **Sudden Death** (Row 9 - Execute enhancement)

**Estimated Time:** 6 hours (4 new abilities)

### Phase 2: Major Cooldowns (MEDIUM)

**Impactful Choices:**

7. **Die by the Sword** (Row 3 - Defensive)
8. **Spell Reflection** (Row 6 - Utility)
9. **Thunder Clap** (Row 8 - AoE + slow)
10. **Avatar** (Row 11 - Ultimate)

**Estimated Time:** 8 hours (4 abilities with complex effects)

### Phase 3: Polish (LOW)

**Nice-to-Have Variants:**

11. Heroic Leap (Row 1 alternative)
12. Commanding Shout (Row 2 alternative)
13. Defensive Stance (Row 3 alternative)
14. Enrage (Row 4)
15. Recklessness (Row 11 alternative)

**Estimated Time:** 10 hours (5 abilities + balance testing)

---

## Localization Requirements

### English.loca.xml Handles Needed

**Format:** `h[8hex][2digit]` (increment counter for each new string)

**Example Block:**
```xml
<contentList>
    <!-- Row 1: Charge -->
    <content contentuid="hCharge" version="1">Charge</content>
    <content contentuid="hChargeDesc" version="1">Rush to an enemy, dealing 1d4+STR damage and rooting them for 1 turn. Generates 20 Rage.</content>
    
    <!-- Row 1: Heroic Leap -->
    <content contentuid="hHeroicLeap" version="1">Heroic Leap</content>
    <content contentuid="hHeroicLeapDesc" version="1">Leap to target location, dealing 2d6 damage to all enemies in 4m radius.</content>
    
    <!-- ... (continue for all 24+ talents) ... -->
</contentList>
```

**Total Handles Needed:** ~50 (2 per talent: DisplayName + Description)

---

## Testing Checklist

### Per-Talent Testing

- [ ] Ability appears in character sheet at correct level
- [ ] Icon displays correctly
- [ ] Tooltip shows accurate damage/effects
- [ ] Cooldown functions as expected
- [ ] Rage cost deducts correctly
- [ ] Visual effects play (if applicable)
- [ ] Status effects apply/remove correctly
- [ ] Interactions with other abilities work (combos)

### Balance Testing

- [ ] Damage output comparable to Fighter/Barbarian
- [ ] Cooldowns feel appropriate (not too spammy or too long)
- [ ] Rage economy balanced (generation vs spending)
- [ ] Defensive abilities provide meaningful survivability
- [ ] Utility abilities have situational value

---

## Full Documentation Reference

For complete implementations of all 24 Class Talents, see:

- **`ARMS_WARRIOR_5_POOL_TALENT_SYSTEM.md`** - Section 4.1: Class Talents
- **`WOW_TO_BG3_ABILITY_CONVERSION_GUIDE.md`** - Conversion principles
- **`FILE_REFERENCE.md`** - BG3 spell file syntax

---

## Conclusion

Class Talents form the **foundation** of Warrior identity, shared across all specializations. Implementing these 24+ talents provides:

- **9 meaningful choices** across 10 rows (Levels 1-12)
- **Core rotation abilities** (Charge, Whirlwind, Execute enhancements)
- **Defensive tools** (Die by the Sword, Spell Reflection)
- **Utility options** (Battle Shout, Pummel, Intimidating Shout)
- **Major cooldowns** (Avatar, Recklessness, Bladestorm)

**Estimated Implementation Time:** 24 hours total (all 24 talents)

**Status:** ✅ **DESIGN COMPLETE - READY FOR IMPLEMENTATION**

---

**Last Updated:** October 17, 2025  
**Next Steps:** Begin Phase 1 (Core Rotation - 6 hours)
