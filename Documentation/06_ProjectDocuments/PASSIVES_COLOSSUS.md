# Colossus Specialization - Passive Definitions
**Date:** October 16, 2025  
**Status:** 📋 **READY FOR STATS FILE IMPLEMENTATION**

---

## 💥 COLOSSUS PASSIVES

**Specialization**: Stack & Burst theme, Demolish finisher  
**Available For**: Arms Warrior, Protection Warrior  
**Total Passives**: 11 (1 keystone + 9 tier choices + 1 capstone)

---

### **LEVEL 13: KEYSTONE**

#### **WAR_Colossus_Keystone**
```
new entry "WAR_Colossus_Keystone"
type "PassiveData"
data "DisplayName" "h124abc01;1" // Colossus
data "Description" "h124abc02;1" // You become a devastating force on the battlefield. Grants the Demolish ability and Colossal Might passive. Shield Slam, Execute, and Revenge (when hitting 3+ targets) grant you 1 stack of Colossal Might (max 5). Colossal Might increases Demolish damage by +10% per stack and lasts until consumed or 60 seconds out of combat.
data "Icon" "PassiveFeature_Generic_Damage"
data "Properties" "Highlighted"
data "Boosts" "UnlockSpell(WAR_Demolish)"
data "StatsFunctorContext" "OnCast"
data "Conditions" "HasStringInSpellRoll('Projectile(WAR_ShieldSlam)') or HasStringInSpellRoll('Projectile(WAR_Execute)') or (HasStringInSpellRoll('Projectile(WAR_Revenge)') and TargetCountAtLeast(3))"
data "StatsFunctors" "ApplyStatus(SELF,WAR_COLOSSAL_MIGHT,100,5)"
```

**Notes:**
- Unlocks `WAR_Demolish` spell (needs Spell_Warrior.txt entry)
- Grants stack of `WAR_COLOSSAL_MIGHT` status on Shield Slam, Execute, or Revenge (3+ targets)
- Status stacks to 5, lasts 100 turns (60 seconds out of combat)
- Status boosts Demolish damage by 10% per stack
- Status definition needed in Status_Warrior.txt
- Spell definition needed in Spell_Warrior.txt (Demolish: 3×3d10, consumes all stacks)

---

### **LEVEL 15: TIER 1 CHOICES**

#### **1. WAR_Colossus_NoStrangerToPain** ✅ RECOMMENDED
```
new entry "WAR_Colossus_NoStrangerToPain"
type "PassiveData"
data "DisplayName" "h124abc03;1" // No Stranger to Pain
data "Description" "h124abc04;1" // Ignore Pain damage prevention increased by +20%.
data "Icon" "PassiveFeature_Generic_Defense"
data "Properties" "Highlighted"
data "Boosts" "IF(HasPassive('WAR_Colossus_Keystone')):DamageReduction(Increase,20,IgnorePain)"
```

**Notes:**
- Direct 20% boost to Ignore Pain ability damage absorption
- Passive boost, always active with keystone
- Requires Ignore Pain ability implementation in base Warrior kit

---

#### **2. WAR_Colossus_VeteranVitality**
```
new entry "WAR_Colossus_VeteranVitality"
type "PassiveData"
data "DisplayName" "h124abc05;1" // Veteran Vitality
data "Description" "h124abc06;1" // When your HP drops below 35%, automatically heal for 15% of your maximum HP over 2 turns (7.5% per turn). Gain temporary HP equal to 10% of damage dealt by Demolish. Cooldown: 90 seconds.
data "Icon" "PassiveFeature_Generic_Healing"
data "Properties" "Highlighted"
data "StatsFunctorContext" "OnDamage"
data "Conditions" "HasPassive('WAR_Colossus_Keystone',context.Source)"
data "StatsFunctors" "IF(HPPercentageLessThan(35) and not HasStatus('WAR_VETERAN_VITALITY_CD',context.Source)):ApplyStatus(SELF,WAR_VETERAN_VITALITY_HEAL,2);IF(HPPercentageLessThan(35)):ApplyStatus(SELF,WAR_VETERAN_VITALITY_CD,15)"
data "PriorityOrder" "100"
```

**Additional Functor (OnDamage for Demolish):**
```
data "StatsFunctorContext" "OnDamage"
data "Conditions" "HasPassive('WAR_Colossus_Keystone',context.Source) and HasPassive('WAR_Colossus_VeteranVitality',context.Source) and HasStringInSpellRoll('Projectile(WAR_Demolish)')"
data "StatsFunctors" "GainTemporaryHitPoints(LastDamage*0.1)"
```

**Notes:**
- Triggers at <35% HP, applies `WAR_VETERAN_VITALITY_HEAL` status (2 turns)
- Status heals 7.5% max HP per turn (total 15%)
- Applies 15-turn cooldown status `WAR_VETERAN_VITALITY_CD` (90 seconds)
- Separate trigger for Demolish: grants temp HP = 10% of Demolish damage dealt
- Status definitions needed in Status_Warrior.txt

---

#### **3. WAR_Colossus_OneAgainstMany**
```
new entry "WAR_Colossus_OneAgainstMany"
type "PassiveData"
data "DisplayName" "h124abc07;1" // One Against Many
data "Description" "h124abc08;1" // Shockwave, Revenge, and Whirlwind deal +5% damage per target affected (max +25% at 5 targets). When hitting 4+ targets with these abilities, gain 1 Colossal Might stack.
data "Icon" "PassiveFeature_Generic_Damage"
data "Properties" "Highlighted"
data "StatsFunctorContext" "OnCast"
data "Conditions" "HasPassive('WAR_Colossus_Keystone',context.Source) and (HasStringInSpellRoll('Projectile(WAR_Shockwave)') or HasStringInSpellRoll('Projectile(WAR_Revenge)') or HasStringInSpellRoll('Projectile(WAR_Whirlwind)'))"
data "StatsFunctors" "ApplyStatus(SELF,WAR_ONE_AGAINST_MANY,1);IF(TargetCountAtLeast(4)):ApplyStatus(SELF,WAR_COLOSSAL_MIGHT,100,5)"
data "PriorityOrder" "100"
```

**Status Entry (for dynamic damage scaling):**
```
new entry "WAR_ONE_AGAINST_MANY"
type "StatusData"
data "StatusType" "BOOST"
data "DisplayName" "h124abc09;1" // One Against Many
data "Description" "h124abc10;1" // Damage increased by 5% per target hit.
data "StackId" "WAR_ONE_AGAINST_MANY"
data "StackPriority" "1"
data "Boosts" "Damage(Increase,5*TargetCount,WAR_Shockwave,WAR_Revenge,WAR_Whirlwind)"
data "StatusPropertyFlags" "DisableOverhead;DisableCombatlog"
```

**Notes:**
- Applies temporary `WAR_ONE_AGAINST_MANY` status that scales damage by target count
- Max +25% damage at 5 targets (5% × 5)
- Hitting 4+ targets grants Colossal Might stack (stack generation alternative)
- Status definition needed in Status_Warrior.txt

---

### **LEVEL 17: TIER 2 CHOICES**

#### **1. WAR_Colossus_PracticedStrikes** ✅ RECOMMENDED
```
new entry "WAR_Colossus_PracticedStrikes"
type "PassiveData"
data "DisplayName" "h124abc11;1" // Practiced Strikes
data "Description" "h124abc12;1" // Shield Slam and Revenge damage increased by +10%. Shield Slam generates +3 Rage.
data "Icon" "PassiveFeature_Generic_Damage"
data "Properties" "Highlighted"
data "Boosts" "IF(HasPassive('WAR_Colossus_Keystone')):Damage(Increase,10,WAR_ShieldSlam);IF(HasPassive('WAR_Colossus_Keystone')):Damage(Increase,10,WAR_Revenge)"
data "StatsFunctorContext" "OnCast"
data "Conditions" "HasPassive('WAR_Colossus_Keystone',context.Source) and HasStringInSpellRoll('Projectile(WAR_ShieldSlam)')"
data "StatsFunctors" "RestoreResource(context.Source,ActionResource,3,0)"
```

**Notes:**
- Permanent +10% damage to Shield Slam and Revenge
- Shield Slam casts restore 3 Rage (ActionResource)
- Enhances stack builders, accelerates Demolish access

---

#### **2. WAR_Colossus_ArterialBleed**
```
new entry "WAR_Colossus_ArterialBleed"
type "PassiveData"
data "DisplayName" "h124abc13;1" // Arterial Bleed
data "Description" "h124abc14;1" // Melee attacks that deal Slashing damage have a 30% chance to apply Bleeding for 3 turns (1d6 Slashing per turn). Bleeding damage is increased by +5% per Colossal Might stack (max +25%). Demolish always applies Bleeding.
data "Icon" "PassiveFeature_Generic_Bleed"
data "Properties" "Highlighted"
data "StatsFunctorContext" "OnDamage"
data "Conditions" "HasPassive('WAR_Colossus_Keystone',context.Source) and IsMeleeAttack() and DamageType(Slashing)"
data "StatsFunctors" "IF(RandomCastOutcome(30,100)):ApplyStatus(BLEEDING,3)"
data "PriorityOrder" "100"
```

**Additional Functor (Demolish guaranteed bleed):**
```
data "StatsFunctorContext" "OnCast"
data "Conditions" "HasPassive('WAR_Colossus_Keystone',context.Source) and HasPassive('WAR_Colossus_ArterialBleed',context.Source) and HasStringInSpellRoll('Projectile(WAR_Demolish)')"
data "StatsFunctors" "ApplyStatus(WAR_BLEEDING_ENHANCED,3)"
```

**Notes:**
- Uses vanilla BG3 `BLEEDING` status (1d6/turn)
- 30% proc chance on Slashing melee attacks
- Demolish applies custom `WAR_BLEEDING_ENHANCED` status that scales with Colossal Might stacks
- Enhanced bleed status: `Boosts "Damage(Increase,5*StatusCount(WAR_COLOSSAL_MIGHT),BLEEDING)"`
- Status definition needed in Status_Warrior.txt (WAR_BLEEDING_ENHANCED)

---

#### **3. WAR_Colossus_Earthquaker**
```
new entry "WAR_Colossus_Earthquaker"
type "PassiveData"
data "DisplayName" "h124abc15;1" // Earthquaker
data "Description" "h124abc16;1" // Shockwave knocks enemies Prone (DEX save). Shockwave cooldown reduced by 1 turn. When Shockwave hits 3+ enemies, generate +5 Rage.
data "Icon" "PassiveFeature_Generic_Control"
data "Properties" "Highlighted"
data "Boosts" "IF(HasPassive('WAR_Colossus_Keystone')):ReduceCooldown(WAR_Shockwave,1)"
data "StatsFunctorContext" "OnCast"
data "Conditions" "HasPassive('WAR_Colossus_Keystone',context.Source) and HasStringInSpellRoll('Projectile(WAR_Shockwave)')"
data "StatsFunctors" "ApplyStatus(PRONE,2,SavingThrow(Ability.Dexterity,SourceSpellDC()));IF(TargetCountAtLeast(3)):RestoreResource(context.Source,ActionResource,5,0)"
data "PriorityOrder" "100"
```

**Notes:**
- Adds Prone effect to Shockwave (DEX save vs spell DC)
- Reduces Shockwave cooldown by 1 turn (more frequent CC)
- Hitting 3+ targets restores 5 Rage (mass combat Rage generation)
- Uses vanilla `PRONE` status (2 turns)

---

### **LEVEL 19: TIER 3 CHOICES**

#### **1. WAR_Colossus_MartialExpert** ✅ RECOMMENDED
```
new entry "WAR_Colossus_MartialExpert"
type "PassiveData"
data "DisplayName" "h124abc17;1" // Martial Expert
data "Description" "h124abc18;1" // Revenge damage increased by +7% per Colossal Might stack (max +35% at 5 stacks).
data "Icon" "PassiveFeature_Generic_Damage"
data "Properties" "Highlighted"
data "Boosts" "IF(HasPassive('WAR_Colossus_Keystone')):Damage(Increase,7*StatusCount(WAR_COLOSSAL_MIGHT),WAR_Revenge)"
```

**Notes:**
- Dynamic damage scaling based on Colossal Might stacks
- At 5 stacks: Revenge deals +35% damage
- Massive scaling for stack-and-burst gameplay
- Works with Practiced Strikes (+10%) for total +45% at 5 stacks

---

#### **2. WAR_Colossus_TideOfBattle**
```
new entry "WAR_Colossus_TideOfBattle"
type "PassiveData"
data "DisplayName" "h124abc19;1" // Tide of Battle
data "Description" "h124abc20;1" // Revenge damage increased by +7% per Colossal Might stack (max +35% at 5 stacks). Revenge cooldown reduced by 1 turn.
data "Icon" "PassiveFeature_Generic_Damage"
data "Properties" "Highlighted"
data "Boosts" "IF(HasPassive('WAR_Colossus_Keystone')):Damage(Increase,7*StatusCount(WAR_COLOSSAL_MIGHT),WAR_Revenge);IF(HasPassive('WAR_Colossus_Keystone')):ReduceCooldown(WAR_Revenge,1)"
```

**Notes:**
- Same damage scaling as Martial Expert (+35% at 5 stacks)
- Additional benefit: Revenge cooldown reduced by 1 turn
- Trade-off: More frequent Revenge casts vs burst window focus
- Enables Revenge spam build for faster stack generation

---

#### **3. WAR_Colossus_DemolishShockwave**
```
new entry "WAR_Colossus_DemolishShockwave"
type "PassiveData"
data "DisplayName" "h124abc21;1" // Demolish: Shockwave
data "Description" "h124abc22;1" // Demolish cooldown reduced by 1 turn. After using Demolish, your next Shockwave has +3m range, stuns for 1 additional turn, and grants 1 Colossal Might stack.
data "Icon" "PassiveFeature_Generic_Damage"
data "Properties" "Highlighted"
data "Boosts" "IF(HasPassive('WAR_Colossus_Keystone')):ReduceCooldown(WAR_Demolish,1)"
data "StatsFunctorContext" "OnCast"
data "Conditions" "HasPassive('WAR_Colossus_Keystone',context.Source) and HasStringInSpellRoll('Projectile(WAR_Demolish)')"
data "StatsFunctors" "ApplyStatus(SELF,WAR_DEMOLISH_SHOCKWAVE_BUFF,2)"
data "PriorityOrder" "100"
```

**Status Entry:**
```
new entry "WAR_DEMOLISH_SHOCKWAVE_BUFF"
type "StatusData"
data "StatusType" "BOOST"
data "DisplayName" "h124abc23;1" // Demolish: Shockwave
data "Description" "h124abc24;1" // Next Shockwave has +3m range, +1 turn stun, and grants 1 Colossal Might stack.
data "Icon" "PassiveFeature_Generic_Control"
data "Boosts" "IncreaseSpellRange(3,WAR_Shockwave);StatusDurationIncrease(STUNNED,1)"
data "RemoveEvents" "OnCast"
data "RemoveConditions" "HasStringInSpellRoll('Projectile(WAR_Shockwave)')"
data "OnRemoveFunctors" "ApplyStatus(context.Source,WAR_COLOSSAL_MIGHT,100,5)"
```

**Notes:**
- Reduces Demolish cooldown by 1 turn (more frequent burst windows)
- After Demolish, applies `WAR_DEMOLISH_SHOCKWAVE_BUFF` status (2 turns)
- Next Shockwave cast consumes buff and grants:
  - +3m range (better positioning)
  - +1 turn stun duration (stronger CC)
  - 1 Colossal Might stack (restart stacking immediately)
- Combo rotation: Demolish → empowered Shockwave → rebuild stacks
- Status definition needed in Status_Warrior.txt

---

### **LEVEL 20: CAPSTONE**

#### **WAR_Colossus_PreciseMight**
```
new entry "WAR_Colossus_PreciseMight"
type "PassiveData"
data "DisplayName" "h124abc25;1" // Precise Might
data "Description" "h124abc26;1" // Critical hit chance increased by +2% per Colossal Might stack (max +10% at 5 stacks).
data "Icon" "PassiveFeature_Generic_Critical"
data "Properties" "Highlighted"
data "Boosts" "IF(HasPassive('WAR_Colossus_Keystone')):CriticalHitChance(2*StatusCount(WAR_COLOSSAL_MIGHT))"
```

**Notes:**
- Dynamic crit chance scaling based on Colossal Might stacks
- At 5 stacks: +10% crit chance (effectively crit range 18-20)
- Synergizes with Martial Expert: at 5 stacks = +35% Revenge damage + +10% crit
- Ultimate scaling capstone: more stacks = more damage, more crits, bigger Demolish

---

## 📊 COLOSSUS SUMMARY

**Total Passives**: 11  
**Localization Handles Required**: 26 (11 DisplayName + 11 Description + 4 status descriptions)  
**New Statuses Required**: 8
- `WAR_COLOSSAL_MIGHT` (keystone stacking buff)
- `WAR_VETERAN_VITALITY_HEAL` (L15 alternative - healing)
- `WAR_VETERAN_VITALITY_CD` (L15 alternative - cooldown tracker)
- `WAR_ONE_AGAINST_MANY` (L15 alternative - damage scaling)
- `WAR_BLEEDING_ENHANCED` (L17 alternative - scaled bleed)
- `WAR_DEMOLISH_SHOCKWAVE_BUFF` (L19 alternative - combo buff)
- `WAR_DEMORALIZED_ENHANCED` (referenced in other spec - shared)

**Vanilla BG3 Statuses Used**: 
- `BLEEDING` (1d6/turn Slashing, used by Arterial Bleed)
- `PRONE` (knock down, used by Earthquaker)
- `STUNNED` (Shockwave base effect, enhanced by Demolish: Shockwave)

**New Spell Required**:
- `WAR_Demolish` (Target Spell, 40 Rage cost, melee range)
  - Damage: 3 attacks of 3d10+STR each
  - Consumes all Colossal Might stacks
  - Damage multiplier: +10% per stack consumed
  - Recharge: Short Rest

**Ability References**:
- WAR_ShieldSlam
- WAR_Execute
- WAR_Revenge
- WAR_Shockwave
- WAR_Whirlwind
- WAR_Demolish (unlocked by keystone)
- IgnorePain (base Warrior ability)

---

**Ready for**: Status_Warrior.txt, Passive_Warrior.txt, and Spell_Warrior.txt implementation
