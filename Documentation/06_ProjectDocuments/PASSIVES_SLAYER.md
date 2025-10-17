# Slayer Specialization - Passive Definitions
**Date:** October 16, 2025  
**Status:** 📋 **READY FOR STATS FILE IMPLEMENTATION**

---

## ⚔️ SLAYER PASSIVES

**Specialization**: Mark & Execute theme, executioner gameplay  
**Available For**: Arms Warrior, Fury Warrior  
**Total Passives**: 11 (1 keystone + 9 tier choices + 1 capstone)

---

### **LEVEL 13: KEYSTONE**

#### **WAR_Slayer_Keystone**
```
new entry "WAR_Slayer_Keystone"
type "PassiveData"
data "DisplayName" "h125abc01;1" // Slayer
data "Description" "h125abc02;1" // You become an executioner, marking enemies for death. Your melee attacks have a 15% chance to deal 2d8 bonus Slashing damage and apply Marked for Execution for 4 turns. Marked targets take +10% damage from Execute and +1d6 damage from all your attacks.
data "Icon" "PassiveFeature_Generic_Dark"
data "Properties" "Highlighted"
data "StatsFunctorContext" "OnDamage"
data "Conditions" "IsMeleeAttack()"
data "StatsFunctors" "IF(RandomCastOutcome(15,100)):DealDamage(2d8,Slashing,Magical);IF(RandomCastOutcome(15,100)):ApplyStatus(WAR_MARKED_FOR_EXECUTION,4)"
data "PriorityOrder" "100"
```

**Notes:**
- 15% chance on any melee attack hit
- Deals 2d8 bonus Slashing damage (separate proc)
- Applies `WAR_MARKED_FOR_EXECUTION` status (4 turns)
- Status grants:
  - Execute takes +10% damage
  - All attacks from you deal +1d6 damage
- Status definition needed in Status_Warrior.txt

---

### **LEVEL 15: TIER 1 CHOICES**

#### **1. WAR_Slayer_BrutalFinish** ✅ RECOMMENDED
```
new entry "WAR_Slayer_BrutalFinish"
type "PassiveData"
data "DisplayName" "h125abc03;1" // Brutal Finish
data "Description" "h125abc04;1" // Execute deals +50% damage against targets Marked for Execution.
data "Icon" "PassiveFeature_Generic_Damage"
data "Properties" "Highlighted"
data "StatsFunctorContext" "OnDamage"
data "Conditions" "HasPassive('WAR_Slayer_Keystone',context.Source) and HasStringInSpellRoll('Projectile(WAR_Execute)') and HasStatus('WAR_MARKED_FOR_EXECUTION',context.Target)"
data "StatsFunctors" "DealDamage(LastDamage*0.5,MainMeleeWeaponDamageType)"
data "PriorityOrder" "99"
```

**Notes:**
- Triggers when Execute hits a Marked target
- Deals +50% of Execute's base damage as bonus damage
- Example: Execute deals 4d12 → vs Marked deals 6d12 effective (4d12 + 50%)
- Major Execute scaling, defines Slayer identity

---

#### **2. WAR_Slayer_ImminentDemise**
```
new entry "WAR_Slayer_ImminentDemise"
type "PassiveData"
data "DisplayName" "h125abc05;1" // Imminent Demise
data "Description" "h125abc06;1" // Mortal Strike deals +30% damage against targets Marked for Execution and applies Healing Reduction (-50% healing received) for 3 turns.
data "Icon" "PassiveFeature_Generic_Damage"
data "Properties" "Highlighted"
data "StatsFunctorContext" "OnDamage"
data "Conditions" "HasPassive('WAR_Slayer_Keystone',context.Source) and HasStringInSpellRoll('Projectile(WAR_MortalStrike)') and HasStatus('WAR_MARKED_FOR_EXECUTION',context.Target)"
data "StatsFunctors" "DealDamage(LastDamage*0.3,MainMeleeWeaponDamageType);ApplyStatus(HEALING_REDUCTION,3)"
data "PriorityOrder" "99"
```

**Notes:**
- Mortal Strike alternative to Execute focus
- +30% damage vs Marked targets
- Applies vanilla BG3 `HEALING_REDUCTION` status (-50% healing, 3 turns)
- Anti-heal utility for boss fights and enemy healers
- Uses vanilla status, no custom definition needed

---

#### **3. WAR_Slayer_OverwhelmingBlades**
```
new entry "WAR_Slayer_OverwhelmingBlades"
type "PassiveData"
data "DisplayName" "h125abc07;1" // Overwhelming Blades
data "Description" "h125abc08;1" // When you apply Marked for Execution, it spreads to 1 additional nearby enemy within 4m. When you Execute a Marked target, gain Blood Frenzy for 2 turns: +2 melee damage and +10% movement speed.
data "Icon" "PassiveFeature_Generic_Damage"
data "Properties" "Highlighted"
data "StatsFunctorContext" "OnStatusApplied"
data "Conditions" "HasPassive('WAR_Slayer_Keystone',context.Source) and StatusId('WAR_MARKED_FOR_EXECUTION')"
data "StatsFunctors" "ApplyStatus(WAR_MARKED_FOR_EXECUTION,4,ClosestEnemyNotSelf,4)"
data "PriorityOrder" "100"
```

**Additional Functor (Execute Blood Frenzy):**
```
data "StatsFunctorContext" "OnKill"
data "Conditions" "HasPassive('WAR_Slayer_Keystone',context.Source) and HasPassive('WAR_Slayer_OverwhelmingBlades',context.Source) and HasStringInSpellRoll('Projectile(WAR_Execute)') and HasStatus('WAR_MARKED_FOR_EXECUTION',context.Target)"
data "StatsFunctors" "ApplyStatus(SELF,WAR_BLOOD_FRENZY,2)"
```

**Notes:**
- Mark spread: When applying Marked, spread to 1 nearby enemy (4m radius)
- Multi-target marking for AoE builds
- Execute kill on Marked target → `WAR_BLOOD_FRENZY` status (2 turns)
- Blood Frenzy grants:
  - `Damage(Increase,2,Melee)` boost
  - `ActionResource(Movement,10%,0)` boost
- Status definition needed in Status_Warrior.txt

---

### **LEVEL 17: TIER 2 CHOICES**

#### **1. WAR_Slayer_CullingCyclone** ✅ RECOMMENDED
```
new entry "WAR_Slayer_CullingCyclone"
type "PassiveData"
data "DisplayName" "h125abc09;1" // Culling Cyclone
data "Description" "h125abc10;1" // Whirlwind deals +1d6 damage per enemy Marked for Execution hit.
data "Icon" "PassiveFeature_Generic_Damage"
data "Properties" "Highlighted"
data "StatsFunctorContext" "OnDamage"
data "Conditions" "HasPassive('WAR_Slayer_Keystone',context.Source) and HasStringInSpellRoll('Projectile(WAR_Whirlwind)') and HasStatus('WAR_MARKED_FOR_EXECUTION',context.Target)"
data "StatsFunctors" "DealDamage(1d6,Slashing)"
data "PriorityOrder" "99"
```

**Notes:**
- Whirlwind gains +1d6 damage per Marked enemy hit
- Multi-target synergy with Mark spread (Overwhelming Blades)
- Example: Whirlwind hits 3 Marked enemies → +3d6 total bonus damage
- Bridges single-target Execute with AoE cleave

---

#### **2. WAR_Slayer_Opportunist**
```
new entry "WAR_Slayer_Opportunist"
type "PassiveData"
data "DisplayName" "h125abc11;1" // Opportunist
data "Description" "h125abc12;1" // Attacks against targets Marked for Execution have Advantage. When you critically hit a Marked target, reduce Execute cooldown by 1 turn.
data "Icon" "PassiveFeature_Generic_Critical"
data "Properties" "Highlighted"
data "Boosts" "IF(HasPassive('WAR_Slayer_Keystone') and HasStatus('WAR_MARKED_FOR_EXECUTION',context.Target)):Advantage(AttackRoll)"
data "StatsFunctorContext" "OnDamage"
data "Conditions" "HasPassive('WAR_Slayer_Keystone',context.Source) and IsCriticalHit() and HasStatus('WAR_MARKED_FOR_EXECUTION',context.Target)"
data "StatsFunctors" "ReduceCooldown(WAR_Execute,1,context.Source)"
```

**Notes:**
- Grants Advantage on all attack rolls vs Marked targets
- Increases crit chance indirectly (Advantage = roll twice)
- Crit on Marked target → Execute cooldown reduced by 1 turn
- Synergizes with Show No Mercy (L19 crit range 19-20)
- Execute spam machine with high crit rate

---

#### **3. WAR_Slayer_OverwhelmingBlades_Alt** (if not picked at L15)
```
new entry "WAR_Slayer_OverwhelmingBlades_Alt"
type "PassiveData"
data "DisplayName" "h125abc07;1" // Overwhelming Blades
data "Description" "h125abc08;1" // When you apply Marked for Execution, it spreads to 1 additional nearby enemy within 4m. When you Execute a Marked target, gain Blood Frenzy for 2 turns: +2 melee damage and +10% movement speed.
data "Icon" "PassiveFeature_Generic_Damage"
data "Properties" "Highlighted"
data "StatsFunctorContext" "OnStatusApplied"
data "Conditions" "HasPassive('WAR_Slayer_Keystone',context.Source) and StatusId('WAR_MARKED_FOR_EXECUTION')"
data "StatsFunctors" "ApplyStatus(WAR_MARKED_FOR_EXECUTION,4,ClosestEnemyNotSelf,4)"
data "PriorityOrder" "100"
```

**Notes:**
- Duplicate of L15 option for second chance
- Same mechanics (Mark spread + Blood Frenzy on Execute)
- Allows flexibility if player chose different L15 talent

---

### **LEVEL 19: TIER 3 CHOICES**

#### **1. WAR_Slayer_ShowNoMercy** ✅ RECOMMENDED
```
new entry "WAR_Slayer_ShowNoMercy"
type "PassiveData"
data "DisplayName" "h125abc13;1" // Show No Mercy
data "Description" "h125abc14;1" // Critical hit range increased by 1 against targets Marked for Execution (critical on 19-20 instead of 20).
data "Icon" "PassiveFeature_Generic_Critical"
data "Properties" "Highlighted"
data "Boosts" "IF(HasPassive('WAR_Slayer_Keystone') and HasStatus('WAR_MARKED_FOR_EXECUTION',context.Target)):CriticalHitRange(1)"
```

**Notes:**
- Crit range expansion: 20 → 19-20 vs Marked targets
- Effective +10% crit chance (5% base → 10% vs Marked)
- Synergizes with Opportunist (Advantage + 19-20 crit = frequent crits)
- More crits = enemies drop to Execute threshold faster

---

#### **2. WAR_Slayer_ReapTheStorm**
```
new entry "WAR_Slayer_ReapTheStorm"
type "PassiveData"
data "DisplayName" "h125abc15;1" // Reap the Storm
data "Description" "h125abc16;1" // When you hit 3 or more enemies with Whirlwind or Revenge, apply Overwhelmed to all targets for 3 turns. Overwhelmed targets take +8% damage from you. Stacks with Marked for Execution.
data "Icon" "PassiveFeature_Generic_Damage"
data "Properties" "Highlighted"
data "StatsFunctorContext" "OnCast"
data "Conditions" "HasPassive('WAR_Slayer_Keystone',context.Source) and (HasStringInSpellRoll('Projectile(WAR_Whirlwind)') or HasStringInSpellRoll('Projectile(WAR_Revenge)')) and TargetCountAtLeast(3)"
data "StatsFunctors" "ApplyStatus(WAR_OVERWHELMED,3)"
data "PriorityOrder" "100"
```

**Status Entry:**
```
new entry "WAR_OVERWHELMED"
type "StatusData"
data "StatusType" "BOOST"
data "DisplayName" "h125abc17;1" // Overwhelmed
data "Description" "h125abc18;1" // Taking +8% damage from the Warrior.
data "Icon" "Status_Generic_Debuff"
data "StackId" "WAR_OVERWHELMED"
data "StatusPropertyFlags" "DisableCombatlog"
data "Boosts" "Damage(Increase,8,FromSource)"
```

**Notes:**
- Multi-target encounters (3+ enemies hit)
- Applies `WAR_OVERWHELMED` status (+8% damage from you, 3 turns)
- Stacks with Marked for Execution:
  - Marked: +10% Execute damage + 1d6 all attacks
  - Overwhelmed: +8% all damage
  - Total vs Marked+Overwhelmed: +18% + 1d6
- AoE damage amplification specialist
- Status definition needed in Status_Warrior.txt

---

#### **3. WAR_Slayer_ImminentDemise_Alt** (if not picked at L15)
```
new entry "WAR_Slayer_ImminentDemise_Alt"
type "PassiveData"
data "DisplayName" "h125abc05;1" // Imminent Demise
data "Description" "h125abc06;1" // Mortal Strike deals +30% damage against targets Marked for Execution and applies Healing Reduction (-50% healing received) for 3 turns.
data "Icon" "PassiveFeature_Generic_Damage"
data "Properties" "Highlighted"
data "StatsFunctorContext" "OnDamage"
data "Conditions" "HasPassive('WAR_Slayer_Keystone',context.Source) and HasStringInSpellRoll('Projectile(WAR_MortalStrike)') and HasStatus('WAR_MARKED_FOR_EXECUTION',context.Target)"
data "StatsFunctors" "DealDamage(LastDamage*0.3,MainMeleeWeaponDamageType);ApplyStatus(HEALING_REDUCTION,3)"
data "PriorityOrder" "99"
```

**Notes:**
- Duplicate of L15 option for second chance
- Same mechanics (Mortal Strike scaling + anti-heal)
- Allows flexibility if player chose different L15 talent

---

### **LEVEL 20: CAPSTONE**

#### **WAR_Slayer_Malice**
```
new entry "WAR_Slayer_Malice"
type "PassiveData"
data "DisplayName" "h125abc19;1" // Slayer's Malice
data "Description" "h125abc20;1" // Raging Blow deals +30% damage and has a +10% chance to apply Marked for Execution.
data "Icon" "PassiveFeature_Generic_Dark"
data "Properties" "Highlighted"
data "Boosts" "IF(HasPassive('WAR_Slayer_Keystone')):Damage(Increase,30,WAR_RagingBlow)"
data "StatsFunctorContext" "OnDamage"
data "Conditions" "HasPassive('WAR_Slayer_Keystone',context.Source) and HasStringInSpellRoll('Projectile(WAR_RagingBlow)')"
data "StatsFunctors" "IF(RandomCastOutcome(10,100)):ApplyStatus(WAR_MARKED_FOR_EXECUTION,4)"
data "PriorityOrder" "100"
```

**Notes:**
- Permanent +30% damage to Raging Blow
- Raging Blow gains +10% chance to apply Marked for Execution
- Total Mark chance on Raging Blow: 25% (15% base + 10% Slayer's Malice)
- Raging Blow becomes primary Mark engine
- Frequent hits → constant Mark uptime → Execute spam with Brutal Finish

---

## 📊 SLAYER SUMMARY

**Total Passives**: 11 (9 unique + 2 duplicates at L17/L19 for flexibility)  
**Localization Handles Required**: 22 (9 unique DisplayName + 9 unique Description + 2 status descriptions + 2 duplicate handles)  
**New Statuses Required**: 3
- `WAR_MARKED_FOR_EXECUTION` (keystone - main debuff)
- `WAR_BLOOD_FRENZY` (L15 alternative - Execute reward)
- `WAR_OVERWHELMED` (L19 alternative - AoE debuff)

**Vanilla BG3 Statuses Used**: 
- `HEALING_REDUCTION` (-50% healing, used by Imminent Demise)

**Ability References**:
- WAR_Execute (primary finisher)
- WAR_MortalStrike (Arms signature ability)
- WAR_Whirlwind (AoE cleave)
- WAR_Revenge (tank AoE)
- WAR_RagingBlow (Fury signature ability, capstone focus)

**Gameplay Mechanics**:
- **Mark System**: 15-25% chance to apply Marked for Execution (15% base + 10% from Slayer's Malice on Raging Blow)
- **Execute Scaling**: +50% damage vs Marked (Brutal Finish) + +10% base (Marked status) + 1d6 bonus
- **Crit Synergy**: 19-20 crit range (Show No Mercy) + Advantage (Opportunist) = frequent crits → Execute cooldown reduction
- **Multi-target**: Mark spread (Overwhelming Blades) + Whirlwind bonus (Culling Cyclone) + Overwhelmed debuff (Reap the Storm)

**Build Paths**:
1. **Execute Machine** (Recommended): Brutal Finish → Culling Cyclone → Show No Mercy → constant Execute spam
2. **Mortal Strike Specialist**: Imminent Demise → Opportunist → Imminent Demise (alt) → anti-heal utility
3. **AoE Cleave**: Overwhelming Blades → Culling Cyclone → Reap the Storm → multi-target devastation

---

**Ready for**: Status_Warrior.txt and Passive_Warrior.txt implementation
