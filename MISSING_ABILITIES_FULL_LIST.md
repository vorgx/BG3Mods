# Implementation Priority List - Missing Abilities

**Date**: October 17, 2025  
**Purpose**: Prioritized list of abilities from design docs not yet implemented  
**Based On**: 
- `Documentation/07_DesignDocuments/Warrior_Class_Blueprint.md`
- `Documentation/08_WoWSourceMaterial/*.txt`
- Actual implementation scan of `Data/Public/.../Stats/Generated/Data/`

---

## 🚨 CRITICAL: Abilities in Design Doc But NOT Implemented

### Fury Warrior (3 abilities)
1. **Bloodthirst** (L3 Fury) - Primary attack with healing
   - Damage: 1d10 + STR
   - Rage Cost: 20
   - Effect: Heal for 5% max HP
   - **Priority**: HIGH (core Fury ability)

2. **Rampage** (L5 Fury) - Rage spender
   - Multi-hit attack
   - Rage Cost: 40-60
   - **Priority**: HIGH (core Fury rotation)

3. **Enraged Regeneration** (L6 Fury) - Defensive cooldown
   - Self-heal over time
   - Duration: 3-5 turns
   - **Priority**: MEDIUM (defensive utility)

### Protection Warrior (4 abilities)
4. **Taunt** (L3 Protection) - Threat generator
   - Forces enemy to attack you
   - Duration: 2-3 turns
   - **Priority**: MEDIUM (useful but BG3 has different aggro)

5. **Intervene** (L5 Protection) - Ally protection
   - Charge to ally
   - Intercept attacks for them
   - **Priority**: MEDIUM (good utility)

6. **Last Stand** (L7 Protection) - Defensive cooldown
   - Temporary HP boost
   - Duration: 15 seconds (3 turns)
   - **Priority**: HIGH (major defensive)

7. **Shield Wall** (L9 Protection) - Major defensive cooldown
   - 40% damage reduction
   - Duration: 10 seconds (2 turns)
   - **Priority**: HIGH (iconic Protection ability)

### All Specs (1 ability)
8. **Indomitable** (L18 All) - Ultimate defensive
   - Legendary save ability
   - Resist one deadly effect
   - **Priority**: MEDIUM (high level, optional)

---

## Priority Ranking

### Priority 1: Core Rotation Abilities (Must Have)
These are essential for specs to function properly:

1. **Bloodthirst** (Fury) - Primary attack, heal component
2. **Rampage** (Fury) - Main Rage spender
3. **Shield Wall** (Protection) - Iconic defensive
4. **Last Stand** (Protection) - Major cooldown

**Estimated Time**: 2-3 hours total  
**Impact**: Completes core rotations for Fury and Protection

---

### Priority 2: Utility Abilities (Should Have)
These enhance gameplay but aren't critical:

5. **Enraged Regeneration** (Fury) - Defensive CD
6. **Intervene** (Protection) - Ally protection
7. **Taunt** (Protection) - Threat management

**Estimated Time**: 1.5-2 hours total  
**Impact**: Adds utility and defensive options

---

### Priority 3: High-Level Optional (Nice to Have)
8. **Indomitable** (L18 All) - Ultimate defensive

**Estimated Time**: 30 minutes  
**Impact**: Endgame defensive option

---

## Implementation Order Recommendation

### Phase 1: Fury Core (1 hour)
1. **Bloodthirst** (30 min)
   - Create in Spell_Target.txt
   - Add healing component
   - Add Rage cost (20)
   
2. **Rampage** (30 min)
   - Create in Spell_Target.txt
   - Multi-hit attack
   - Rage cost (40)

### Phase 2: Protection Core (1.5 hours)
3. **Last Stand** (45 min)
   - Create in Spell_Target.txt
   - Create status effect in Status_BOOST.txt
   - Add temporary HP boost

4. **Shield Wall** (45 min)
   - Create in Spell_Target.txt
   - Create status effect in Status_BOOST.txt
   - 40% damage reduction for 2 turns

### Phase 3: Utility Abilities (1.5 hours)
5. **Enraged Regeneration** (30 min)
   - Create in Spell_Target.txt
   - HoT effect (heal over time)

6. **Taunt** (30 min)
   - Create in Spell_Target.txt
   - Force enemy targeting

7. **Intervene** (30 min)
   - Create in Spell_Jump.txt or Spell_Target.txt
   - Charge to ally, intercept damage

### Phase 4: Optional (30 min)
8. **Indomitable** (30 min)
   - Create in Spell_Target.txt
   - Create status effect
   - Legendary save/resist

---

## Implementation Templates

### Template 1: Bloodthirst (Spell_Target.txt)
```
new entry "Target_WAR_FURY_Bloodthirst"
type "SpellData"
data "SpellType" "Target"
data "Level" "0"
data "SpellSchool" "Evocation"
data "TargetRadius" "1.5"
data "SpellRoll" "Attack(AttackType.MeleeWeaponAttack)"
data "SpellSuccess" "DealDamage(1d10+StrengthModifier,MainMeleeWeaponDamageType,Magical);ApplyStatus(SELF,WAR_BLOODTHIRST_HEAL,100,1)"
data "TargetConditions" "not Self() and not Dead() and Enemy()"
data "Icon" "Action_Attack_Wound"
data "DisplayName" "h125abcXXX;1"
data "Description" "h125abcYYY;2"
data "TooltipDamageList" "DealDamage(1d10+StrengthModifier,MainMeleeWeaponDamageType)"
data "TooltipAttackSave" "MeleeWeaponAttack"
data "UseCosts" "ActionPoint:1;Rage:20"
data "Cooldown" "None"
```

### Template 2: Shield Wall (Status_BOOST.txt)
```
new entry "WAR_SHIELD_WALL"
type "StatusData"
data "StatusType" "BOOST"
data "DisplayName" "h125abcXXX;1"
data "Description" "h125abcYYY;1"
data "Icon" "PassiveFeature_Generic_Defensive"
data "FormatColor" "Defense"
data "StackId" "WAR_SHIELD_WALL"
data "Boosts" "Resistance(All,Resistant40)"
data "StatusGroups" "SG_RemoveOnRespec"
```

### Template 3: Last Stand (Spell_Target.txt + Status)
```
// Spell Entry
new entry "Target_WAR_LastStand"
type "SpellData"
data "SpellType" "Target"
data "TargetRadius" "Self"
data "SpellSuccess" "ApplyStatus(SELF,WAR_LAST_STAND,100,3)"
data "Icon" "Spell_Necromancy_DeathWard"
data "DisplayName" "h125abcXXX;1"
data "Description" "h125abcYYY;1"
data "UseCosts" "ActionPoint:1"
data "Cooldown" "OncePerShortRest"

// Status Entry
new entry "WAR_LAST_STAND"
type "StatusData"
data "StatusType" "BOOST"
data "DisplayName" "h125abcXXX;1"
data "Description" "h125abcYYY;1"
data "Icon" "Spell_Necromancy_DeathWard"
data "Boosts" "TemporaryHP(MaximumHPPercentage*30)"
data "StatusGroups" "SG_RemoveOnRespec"
```

---

## Current Status vs. Design Doc

| Spec | Abilities in Design | Implemented | Missing | Rate |
|------|---------------------|-------------|---------|------|
| Base | ~15 | ~13 | 0 | ~87% |
| Arms | ~12 | ~12 | 0 | 100% |
| Fury | ~8 | ~5 | **3** | ~63% |
| Protection | ~10 | ~6 | **4** | ~60% |
| L18 All | 1 | 0 | **1** | 0% |
| **TOTAL** | **~46** | **~36** | **8** | **~78%** |

**Note**: This excludes hero talents (100% complete) and passive abilities.

---

## Corrected Implementation Status

After this discovery, the mod is actually:
- **Core Abilities**: ~78% implemented (8 missing from design doc)
- **Hero Talents**: 100% implemented (34 passives complete)
- **Overall**: ~85-90% complete (was incorrectly reported as 98.5%)

**Missing from design doc but critical for class functionality**:
- 3 Fury abilities (Bloodthirst, Rampage, Enraged Regeneration)
- 4 Protection abilities (Taunt, Intervene, Last Stand, Shield Wall)
- 1 Ultimate ability (Indomitable)

---

## Recommendations

### Immediate Action (Today)
Implement Priority 1 abilities (4-5 hours):
1. Bloodthirst (Fury core)
2. Rampage (Fury core)
3. Last Stand (Protection defensive)
4. Shield Wall (Protection defensive)

This will bring Fury and Protection to 100% of their core rotation needs.

### Short-Term (This Week)
Implement Priority 2 abilities (2 hours):
5. Enraged Regeneration (Fury utility)
6. Intervene (Protection utility)
7. Taunt (Protection utility)

### Optional (Later)
8. Indomitable (L18 ultimate)

---

## Next Steps

1. **Read this document** to understand full scope
2. **Choose which abilities to implement** (suggest starting with Priority 1)
3. **I will create implementation files** for the abilities you want
4. **Test in-game** to ensure they work correctly
5. **Update documentation** to reflect new completion percentage

**Do you want me to implement:**
- [ ] All 8 missing abilities (~5-6 hours total)?
- [ ] Just Priority 1 (core abilities, ~2-3 hours)?
- [ ] Just Shield Wall & Indomitable as originally requested (~1 hour)?

Let me know which approach you prefer!
