# Sunder Armor - Implementation Plan
**Date**: October 16, 2025  
**Decision**: User approved - Replace Heroic Strike with Sunder Armor

---

## IMPLEMENTATION DETAILS

### Status Name: WAR_SUNDERATTACK_ARMOR ✅
**No Conflict**: Different from WAR_SUNDERED_ARMOR (Warbreaker's debuff)

---

## FILES TO CREATE/MODIFY

### 1. Spell_Target.txt - Replace Heroic Strike

**Location**: Line ~311-348  
**Action**: Replace `Target_WAR_HeroicStrike` with `Target_WAR_SunderArmor`

```
new entry "Target_WAR_SunderArmor"
type "SpellData"
data "SpellType" "Target"
data "Level" "0"
data "SpellSchool" "Evocation"
data "TargetRadius" "1.5"
data "AreaRadius" "0"
data "SpellRoll" "Attack(AttackType.MeleeWeaponAttack)"
data "SpellSuccess" "DealDamage(1d6+StrengthModifier,MainMeleeWeaponDamageType,Magical);ApplyStatus(SELF,WAR_RAGE_SUNDER,100,1);ApplyStatus(WAR_SUNDERATTACK_ARMOR,100,5)"
data "TargetConditions" "not Self() and not Dead() and Enemy()"
data "Icon" "Action_Paladin_SmiteSunder"
data "DisplayName" "h125abc121;1"
data "Description" "h125abc122;4"
data "DescriptionParams" "DealDamage(1d6+StrengthModifier,MainMeleeWeaponDamageType);15;1;3"
data "TooltipDamageList" "DealDamage(1d6+StrengthModifier,MainMeleeWeaponDamageType)"
data "TooltipStatusApply" "ApplyStatus(WAR_SUNDERATTACK_ARMOR,100,5)"
data "TooltipAttackSave" "MeleeWeaponAttack"
data "TooltipOnMiss" "5d5f4487-0434-4dfc-8d60-c21948149dc8"
data "PrepareSound" "Spell_Prepare_Damage_Physical_Gen_L1to3"
data "PrepareLoopSound" "Spell_Prepare_Damage_Physical_Gen_L1to3_Loop"
data "CastSound" "Spell_Cast_Damage_Physical_MeleeWeaponAttack_L1to3"
data "TargetSound" "Spell_Impact_Damage_Physical_MeleeWeaponAttack_L1to3"
data "VocalComponentSound" "Vocal_Component_Attack"
data "UseCosts" "BonusActionPoint:1"
data "SpellAnimation" "dd86aa43-8189-4d9f-9a5c-223a7757a60d,,;d8925ce4-33c6-4c26-a723-ddd3d07cac9e,,;ad301d01-0053-4481-ad83-e5ce36adfaef,,;c7399e74-bcbb-4ee2-93d8-924ff6182b73,,;,,;328c8e3e-2c97-4c0e-befd-00e1be30e85e,,;,,;,,"
data "VerbalIntent" "Damage"
data "SpellFlags" "IsHarmful;IsMelee"
data "HitAnimationType" "MeleeWeaponAttack"
data "PrepareEffect" "9c5d1cc2-8b0d-404c-94ef-d45fdb9d7cf3"
data "CastEffect" "9c5d1cc2-8b0d-404c-94ef-d45fdb9d7cf3"
data "TargetEffect" "b863dc6e-f551-4a93-951f-c3f389b30470"
data "DamageType" "Slashing"
```

---

### 2. Status_BOOST.txt - Add Stacking Armor Debuff

**Location**: After WAR_VICTORIOUS status  
**Action**: Add new stacking status

```
new entry "WAR_SUNDERATTACK_ARMOR"
type "StatusData"
data "StatusType" "BOOST"
data "DisplayName" "h125abc123;1"
data "Description" "h125abc124;2"
data "DescriptionParams" "1;3"
data "Icon" "statIcons_Sundered"
data "FormatColor" "Red"
data "StackId" "WAR_SUNDERATTACK_ARMOR"
data "StackType" "Additive"
data "StackPriority" "1"
data "Boosts" "AC(-1)"
data "StatusPropertyFlags" "DisableOverhead;DisableCombatlog"
data "StatusEffect" "7c9e9039-9049-4094-92d7-1de7e8da3c41"
```

**Stack Limit Enforcement**: Status naturally caps at 3 because duration refreshes

---

### 3. Passive.txt - Add Rage Generation Passive

**Location**: After WAR_VictoryRush_Passive  
**Action**: Add rage generation trigger

```
new entry "WAR_SunderArmor_RageGen"
type "PassiveData"
data "DisplayName" "h125abc125;1"
data "Description" "h125abc126;1"
data "Icon" "PassiveFeature_Generic_Tactical"
data "Properties" "IsHidden"
data "StatsFunctorContext" "OnCastResolved"
data "Conditions" "HasStatus('WAR_RAGE_SUNDER',GetActiveCharacter())"
data "StatsFunctors" "ApplyStatus(SELF,WAR_RAGE_15,100,0);RemoveStatus(WAR_RAGE_SUNDER)"
```

---

### 4. Status_BOOST.txt - Add Rage Trigger Status

**Location**: Near other WAR_RAGE statuses  
**Action**: Add trigger status

```
new entry "WAR_RAGE_SUNDER"
type "StatusData"
data "StatusType" "BOOST"
data "DisplayName" "h125abc127;1"
data "Description" "h125abc128;1"
data "Icon" "statIcons_Rage"
data "StackId" "WAR_RAGE_SUNDER"
data "StatusPropertyFlags" "DisableOverhead;DisableCombatlog;DisablePortraitIndicator"
data "RemoveEvents" "OnTurn"
data "RemoveConditions" "not Combat()"
```

---

## LOCALIZATION HANDLES NEEDED

### New Handles (h125abc121-128)

```xml
<!-- Sunder Armor Spell -->
<content contentuid="h125abc121" version="1">Sunder Armor</content>
<content contentuid="h125abc122" version="4">Bonus Action • Melee Weapon Attack

Strike at enemy armor, weakening their defenses.
Deal [1] damage.
Generate [2] Rage.
Reduce target's AC by -[3] for 5 turns (stacks up to [4] times).

Tags: Generator, Single-Target, Armor Reduction</content>

<!-- WAR_SUNDERATTACK_ARMOR Status -->
<content contentuid="h125abc123" version="1">Sundered Armor (Attack)</content>
<content contentuid="h125abc124" version="2">Armor weakened by Sunder Armor attacks. -[1] AC. Stacks up to [2] times.</content>

<!-- Sunder Armor Rage Passive -->
<content contentuid="h125abc125" version="1">Sunder Armor: Rage Generation</content>
<content contentuid="h125abc126" version="1">Generate 15 Rage when using Sunder Armor.</content>

<!-- WAR_RAGE_SUNDER Trigger Status -->
<content contentuid="h125abc127" version="1">Sunder Armor Trigger</content>
<content contentuid="h125abc128" version="1">Triggers Rage generation for Sunder Armor.</content>
```

---

## MECHANICS SUMMARY

### What Sunder Armor Does

**Basic Function**:
- **Bonus Action** - Melee Weapon Attack
- **Damage**: 1d6 + STR (lower than old Heroic Strike's 1d8)
- **Rage**: Generates +15 Rage (same as Heroic Strike)
- **Debuff**: -1 AC for 5 turns, stacks up to 3 times

### Tactical Gameplay

**Setup Phase** (Turns 1-3):
1. Use Sunder Armor 3 times on priority target
2. Target now has -3 AC for 5 turns
3. Generated 45 Rage total (3 × 15)

**Burst Phase** (Turns 4-5):
1. Use big hits while armor is shredded:
   - Mortal Strike (2d10+STR) - easier to hit
   - Overpower (1d12+STR, ignores 50% AC) - ignores 50% of remaining AC after -3
   - Execute (4d12+STR) - devastating with -3 AC
2. Refresh Sunder stacks as needed

**Multi-Target**:
- Can stack on multiple enemies
- Party benefits from reduced AC
- Rogues especially benefit (Sneak Attack easier)

### Synergies

**With Other Warrior Abilities**:
- **Colossus Smash**: -3 AC from CS + -3 from Sunder = -6 AC total!
- **Warbreaker**: -2 AC AoE + -3 Sunder on boss = -5 AC
- **Overpower**: Ignores 50% AC, even better with Sunder applied

**With Party**:
- All attack rolls benefit from reduced AC
- Makes heavily armored enemies vulnerable
- Stacks with other debuffs (Faerie Fire, etc.)

### Balance Considerations

**Compared to Heroic Strike**:
```
Heroic Strike (OLD):
- Damage: 1d8 + STR (avg 5.5 + STR)
- Rage: +15
- Effect: None
- Gameplay: Spam for Rage

Sunder Armor (NEW):
- Damage: 1d6 + STR (avg 4.5 + STR) - 1 point less
- Rage: +15 (same)
- Effect: -1 AC stacking (max -3)
- Gameplay: Tactical setup then burst
```

**Why It's Balanced**:
1. **Lower Damage**: 1d6 vs 1d8 = -1 avg damage per use
2. **Stacking Cap**: Max 3 stacks = -3 AC (strong but capped)
3. **Duration**: 5 turns, refreshes on reapplication
4. **Trade-off**: Spend Bonus Actions on setup vs damage
5. **Counterplay**: Enemies can disengage/flee to avoid stacks

**Why It's Better Design**:
1. **Tactical Depth**: Plan your stacks before burst
2. **Party Synergy**: Everyone benefits from reduced AC
3. **Classic Warrior Feel**: Sunder Armor was THE warrior ability for years
4. **Meaningful Choice**: Stack on boss or spread to multiple targets?
5. **Skill Expression**: When to refresh vs when to burst

---

## TESTING CHECKLIST

After implementation, verify:

- [ ] Sunder Armor appears in character sheet (replaces Heroic Strike)
- [ ] Damage rolls 1d6 + STR
- [ ] Generates 15 Rage on hit
- [ ] Applies WAR_SUNDERATTACK_ARMOR status to target
- [ ] Status shows -1 AC in target's stats
- [ ] Status stacks when used multiple times
- [ ] Stack counter shows (1/3, 2/3, 3/3)
- [ ] Duration resets to 5 turns on reapplication
- [ ] Stacks affect attack rolls against target (easier to hit)
- [ ] Icon shows on target's portrait
- [ ] Tooltip shows all information correctly
- [ ] Passive grants Rage properly
- [ ] No conflict with Warbreaker's WAR_SUNDERED_ARMOR

---

## IMPLEMENTATION ORDER

1. ✅ Update Spell_Shout.txt (DONE - cooldowns fixed)
2. ⏳ Add WAR_SUNDERATTACK_ARMOR to Status_BOOST.txt
3. ⏳ Add WAR_RAGE_SUNDER to Status_BOOST.txt
4. ⏳ Replace Heroic Strike in Spell_Target.txt
5. ⏳ Add WAR_SunderArmor_RageGen to Passive.txt
6. ⏳ Create/update English.loca.xml with handles
7. ⏳ Test in-game
8. ⏳ Update validation report

---

**Status**: Plan Complete - Ready for Implementation  
**User Decision**: ✅ Approved - Sunder Armor with WAR_SUNDERATTACK_ARMOR  
**Conflicts**: None - Status name is unique
