# Baseline Utility Abilities - Balance Adjustments

## Changes Made (October 16, 2025)

### Summary
Applied balance adjustments to baseline utility abilities based on WoW mechanics and BG3 gameplay balance.

---

## ABILITY ADJUSTMENTS

### 1. Hamstring ✅
**Changes**:
- Movement penalty increased: `-3m` → **`-6m`**

**Rationale**:
- More impactful snare
- Matches "hamstring" theme (severe movement impairment)
- Makes ability worth the bonus action cost

**Status Update**:
```
data "Boosts" "ActionResource(Movement,-6,0)"
```

---

### 2. Victory Rush ✅
**Changes**:
- Target condition added: **Only usable on targets below 30% HP**
- Description parameter count: 2 → **3** (added HP threshold)

**Rationale**:
- WoW Source: "Very useful free heal after getting a kill"
- BG3 Adaptation: Below 30% HP represents "finishing blow" scenario
- Prevents spamming as general-purpose heal
- Rewards proper target selection (execute-style mechanic)

**Target Conditions**:
```
data "TargetConditions" "not Self() and not Dead() and Enemy() and HealthPercentage(LessOrEqual,30)"
```

**Updated Description**:
```
data "DescriptionParams" "DealDamage(1d8+StrengthModifier,MainMeleeWeaponDamageType);RegainHitPoints(2d8+ConstitutionModifier);30"
```
- [1] = Damage dealt
- [2] = Healing received  
- [3] = HP threshold (30%)

---

### 3. Pummel ✅
**Changes**:
- Comment clarified: **Melee range only** (already was 1.5m)

**Rationale**:
- Already implemented correctly at 1.5m (melee range)
- Comment updated for clarity
- Prevents confusion with ranged interrupts

**No Code Changes** - was already correct:
```
data "TargetRadius" "1.5"
```

---

### 4. Slam ✅
**Changes**:
- Cooldown added: `None` → **`OncePerTurn`**

**Rationale**:
- WoW: "Initial rage spender, quickly replaced by other abilities"
- Without cooldown: Could spam for 2d6+STR every turn if Rage available
- Too strong as spammable Action (higher damage than Heroic Strike)
- Once per Turn prevents Action spam while keeping it viable

**Updated**:
```
data "Cooldown" "OncePerTurn"
```

---

### 5. Heroic Throw ✅
**Changes**:
- Damage formula: `1d4+StrengthModifier` → **`MainMeleeWeapon`**
- Description updated to reflect weapon damage
- Weapon damage type: Fixed Piercing → **`MainMeleeWeaponDamageType`**

**Rationale**:
- User request: "uses damage rolls from your equipped weapon"
- Acts like Barbarian Throwing Attack
- Returns after throw (inherent to non-consumable weapon mechanics in BG3)
- Makes ability scale with weapon quality

**Updated**:
```
data "SpellSuccess" "DealDamage(MainMeleeWeapon,MainMeleeWeaponDamageType,Magical);ExecuteWeaponFunctors(MainHand)"
data "TooltipDamageList" "DealDamage(MainMeleeWeapon,MainMeleeWeaponDamageType)"
data "DescriptionParams" "DealDamage(MainMeleeWeapon,MainMeleeWeaponDamageType);18"
```

**Note**: Weapon automatically returns in BG3 (no special code needed for returning mechanic)

---

### 6. Action/Bonus Action Labels ✅
**Changes**:
- Added Action/Bonus Action labels to all ability comments

**Updated Comments**:
- Hamstring: `// HAMSTRING - Melee Snare (Bonus Action)`
- Victory Rush: `// VICTORY RUSH - Conditional Heal After Kill (Bonus Action)`
- Pummel: `// PUMMEL - Interrupt (Bonus Action, Melee Range Only)`
- Slam: `// SLAM - Basic Rage Spender (Action, Alternative to Heroic Strike)`
- Berserker Rage: `// BERSERKER RAGE - CC Break (Bonus Action)`
- Heroic Throw: `// HEROIC THROW - Weapon Throw (Action)`
- Storm Bolt: `// STORM BOLT - Ranged Stun (Action)`

---

## UPDATED ABILITY STATS

### Hamstring (Bonus Action)
- **Damage**: 1d6 + STR (Slashing)
- **Effect**: -6m Movement for 3 turns
- **Cost**: Bonus Action
- **Cooldown**: None
- **Range**: Melee (1.5m)

### Victory Rush (Bonus Action)
- **Damage**: 1d8 + STR
- **Healing**: 2d8 + CON
- **Condition**: Target below 30% HP
- **Cost**: Bonus Action
- **Cooldown**: None
- **Range**: Melee (1.5m)

### Pummel (Bonus Action)
- **Damage**: 1d4 + STR (Bludgeoning)
- **Effect**: Silence for 1 turn
- **Cost**: Bonus Action
- **Cooldown**: Once per Turn
- **Range**: Melee (1.5m)

### Slam (Action)
- **Damage**: 2d6 + STR (Bludgeoning)
- **Cost**: Action + 15 Rage
- **Cooldown**: Once per Turn
- **Range**: Melee (1.5m)

### Berserker Rage (Bonus Action)
- **Effect**: Remove and prevent Fear/Charm/Flee for 2 turns
- **Cost**: Bonus Action
- **Cooldown**: Once per Short Rest
- **Range**: Self

### Heroic Throw (Action)
- **Damage**: Main Weapon Damage
- **Cost**: Action
- **Cooldown**: Once per Turn
- **Range**: 18m

### Storm Bolt (Action)
- **Damage**: 2d6 + STR (Thunder)
- **Effect**: Stun for 2 turns
- **Cost**: Action
- **Cooldown**: Once per Short Rest
- **Range**: 18m

---

## BALANCE IMPACT

### Before Adjustments
❌ **Hamstring**: -3m felt weak  
❌ **Victory Rush**: Spammable heal on any target  
❌ **Slam**: Could spam 2d6+STR every turn with enough Rage  
❌ **Heroic Throw**: Fixed 1d4 damage (didn't scale)  

### After Adjustments
✅ **Hamstring**: -6m is meaningful movement denial  
✅ **Victory Rush**: Below 30% HP makes it execute-phase heal (WoW faithful)  
✅ **Slam**: Once per Turn prevents Action spam  
✅ **Heroic Throw**: Scales with weapon (greatsword throw = greatsword damage)  

---

## COMPARISON TO CORE ABILITIES

### Hamstring vs Other Snares
- **Ray of Frost** (Cantrip): -3m movement
- **Hamstring** (Bonus Action): -6m movement (melee only)
- **Balance**: Stronger but requires melee range and Bonus Action

### Victory Rush vs Other Heals
- **Healing Word** (Lv1 Spell): 1d4+WIS, ranged, Bonus Action
- **Cure Wounds** (Lv1 Spell): 1d8+WIS, melee, Action, spell slot
- **Victory Rush** (Bonus Action): 1d8+STR damage + 2d8+CON heal, melee, only below 30% HP
- **Balance**: Damage + healing but restricted to low-HP targets

### Slam vs Heroic Strike
- **Heroic Strike** (Bonus Action): 1d8+STR, generates 15 Rage
- **Slam** (Action): 2d6+STR, costs 15 Rage, Once per Turn
- **Balance**: Higher damage but uses Action and has cooldown

### Heroic Throw vs Other Ranged
- **Eldritch Blast** (Cantrip): 1d10 force, 18m, free cast
- **Heroic Throw** (Action): Weapon damage, 18m, Once per Turn
- **Balance**: Scales with weapon but limited to once per turn

---

## LOCALIZATION HANDLE UPDATES

### Victory Rush Description Changed
**Old**: h125abc98 with 2 parameters  
**New**: h125abc98 with 3 parameters

**New Description Template**:
```
"Strike an enemy below [3]% HP, dealing [1] damage and healing yourself for [2]."
```

**Parameters**:
- [1] = DealDamage(1d8+StrengthModifier,MainMeleeWeaponDamageType)
- [2] = RegainHitPoints(2d8+ConstitutionModifier)
- [3] = 30 (HP threshold percentage)

### Heroic Throw Description Changed
**Old**: "Throw your weapon for [1] damage at [2]m range"  
**New**: "Throw your weapon for [1] damage at [2]m range. The weapon returns to you."

**Parameters**:
- [1] = DealDamage(MainMeleeWeapon,MainMeleeWeaponDamageType)
- [2] = 18 (range)

---

## FILES MODIFIED

1. **Spell_Target.txt**
   - Hamstring: Comment updated (Bonus Action label)
   - Victory Rush: TargetConditions changed, DescriptionParams updated, Comment updated
   - Pummel: Comment updated (Bonus Action, Melee Range Only)
   - Slam: Cooldown changed, Comment updated (Action label)
   - Berserker Rage: Comment updated (Bonus Action label)

2. **Spell_Projectile.txt**
   - Heroic Throw: Damage formula changed, DescriptionParams updated, Comment updated
   - Storm Bolt: Comment updated (Action label)

3. **Status_BOOST.txt**
   - WAR_HAMSTRING: Movement penalty changed from -3 to -6

---

## TESTING CHECKLIST

### High Priority
- [ ] Victory Rush only appears when target below 30% HP
- [ ] Victory Rush heals for 2d8+CON on successful hit
- [ ] Slam can only be used once per turn (cooldown works)
- [ ] Heroic Throw uses actual weapon damage (test with different weapons)
- [ ] Hamstring reduces movement by 6m (not 3m)

### Medium Priority
- [ ] Pummel works at melee range only (1.5m)
- [ ] Heroic Throw weapon returns automatically
- [ ] All Action/Bonus Action costs correct in UI

### Low Priority
- [ ] Updated descriptions display correctly with parameters
- [ ] All tooltips show proper damage/healing formulas

---

## DESIGN NOTES

### Victory Rush HP Threshold Rationale
**Why 30%?**
- Execute abilities in WoW typically trigger at 20-35% HP
- BG3 "Reaper" feat triggers at 25% HP
- 30% gives reasonable window without being too permissive
- Matches "finishing blow" fantasy while being achievable

**Alternative Implementations** (if 30% proves problematic):
- 25% HP: More restrictive, closer to Execute
- 35% HP: More forgiving, easier to use
- On kill: Only usable for 1 turn after killing enemy (true WoW mechanic, harder in BG3)

### Heroic Throw Weapon Scaling
**Why MainMeleeWeapon?**
- Barbarian Throwing Attack uses same formula
- Makes ability scale naturally with gear progression
- Greatsword throw: 2d6, Longsword throw: 1d8, etc.
- Maintains "heroic" theme (throwing massive weapons)

**Note**: In BG3, thrown weapons automatically return (no need for special returning mechanic)

---

## FINAL STATUS

**All Adjustments**: ✅ Complete  
**Balance Impact**: Moderate (abilities more specialized)  
**WoW Fidelity**: Improved (Victory Rush execute-phase mechanic restored)  
**Testing**: Required before finalizing

**Next**: Ready to continue with Fury Warrior implementation

---

**Date**: October 16, 2025  
**Changes**: 5 abilities adjusted, 1 status modified, all comments clarified  
**Localization**: 2 description parameter counts updated (Victory Rush, Heroic Throw)
