# Mountain Thane Specialization - Passive Definitions
**Date:** October 16, 2025  
**Status:** 📋 **READY FOR STATS FILE IMPLEMENTATION**

---

## 🌩️ MOUNTAIN THANE PASSIVES

**Specialization**: Lightning/Storm theme, proc-based gameplay  
**Available For**: Fury Warrior, Protection Warrior  
**Total Passives**: 11 (1 keystone + 9 tier choices + 1 capstone)

---

### **LEVEL 13: KEYSTONE**

#### **WAR_MountainThane_Keystone**
```
new entry "WAR_MountainThane_Keystone"
type "PassiveData"
data "DisplayName" "h123abc01;1" // Mountain Thane
data "Description" "h123abc02;1" // You channel the fury of the storm, becoming a lightning-wreathed warrior. When you activate Avatar, you become an Avatar of the Storm, dealing 1d8 Lightning damage to all enemies within 3m at the start of each of your turns.
data "Icon" "PassiveFeature_Generic_Lightning"
data "Properties" "Highlighted"
data "Boosts" "IF(HasStatus('SG_Polymorph_BeastShape_Behaviour')):ApplyStatus(SELF,WAR_AVATAR_OF_THE_STORM,-1)"
data "StatsFunctorContext" "OnStatusApplied"
data "Conditions" "HasStatus('SG_Polymorph_BeastShape_Behaviour',context.Source)"
data "StatsFunctors" "ApplyStatus(SELF,WAR_AVATAR_OF_THE_STORM,-1)"
```

**Notes:**
- Triggers when Avatar ability is used (Avatar status = `SG_Polymorph_BeastShape_Behaviour` placeholder - replace with actual Avatar status)
- Applies `WAR_AVATAR_OF_THE_STORM` status which handles lightning damage
- Status definition needed in Status_Warrior.txt

---

### **LEVEL 15: TIER 1 CHOICES**

#### **1. WAR_MountainThane_LightningStrikes** ✅ RECOMMENDED
```
new entry "WAR_MountainThane_LightningStrikes"
type "PassiveData"
data "DisplayName" "h123abc03;1" // Lightning Strikes
data "Description" "h123abc04;1" // Thunder Clap, Revenge, and Execute have a 25% chance to strike one enemy with a lightning bolt, dealing 1d10 Lightning damage. This chance increases to 32.5% while Avatar is active.
data "Icon" "PassiveFeature_Generic_Lightning"
data "Properties" "Highlighted"
data "StatsFunctorContext" "OnDamage"
data "Conditions" "HasPassive('WAR_MountainThane_Keystone',context.Source) and (HasStringInSpellRoll('Projectile(WAR_ThunderClap)') or HasStringInSpellRoll('Projectile(WAR_Revenge)') or HasStringInSpellRoll('Projectile(WAR_Execute)'))"
data "StatsFunctors" "IF(RandomCastOutcome(25,100)):DealDamage(1d10,Lightning,Magical);IF(HasStatus('WAR_AVATAR_OF_THE_STORM',context.Source) and RandomCastOutcome(7,100)):DealDamage(1d10,Lightning,Magical)"
data "PriorityOrder" "100"
```

**Notes:**
- 25% base chance, +7.5% during Avatar (total 32.5%)
- Triggers on Thunder Clap, Revenge, or Execute damage events
- Uses RandomCastOutcome for proc chance
- Requires HasPassive check for keystone

---

#### **2. WAR_MountainThane_BurstOfPower**
```
new entry "WAR_MountainThane_BurstOfPower"
type "PassiveData"
data "DisplayName" "h123abc05;1" // Burst of Power
data "Description" "h123abc06;1" // Lightning Strikes has a 25% chance to grant you Burst of Power for 2 turns. While active, your next 2 Shield Slams cost a Bonus Action instead of an Action and generate +2 Rage each.
data "Icon" "PassiveFeature_Generic_Lightning"
data "Properties" "Highlighted"
data "StatsFunctorContext" "OnDamage"
data "Conditions" "HasPassive('WAR_MountainThane_Keystone',context.Source) and HasPassive('WAR_MountainThane_LightningStrikes',context.Source) and DamageType(Lightning)"
data "StatsFunctors" "IF(RandomCastOutcome(25,100)):ApplyStatus(SELF,WAR_BURST_OF_POWER,2)"
data "PriorityOrder" "99"
```

**Notes:**
- Requires both keystone AND Lightning Strikes passive
- 25% chance when Lightning Strikes deals damage
- Applies `WAR_BURST_OF_POWER` status (2 turns, 2 charges)
- Status handles Shield Slam cost reduction and Rage bonus
- Status definition needed in Status_Warrior.txt

---

#### **3. WAR_MountainThane_CrashingThunder**
```
new entry "WAR_MountainThane_CrashingThunder"
type "PassiveData"
data "DisplayName" "h123abc07;1" // Crashing Thunder
data "Description" "h123abc08;1" // When Whirlwind or Revenge hits 3 or more enemies, hit all targets again for 40% weapon damage, generate +3 Rage, and each additional hit has a 25% chance to trigger Lightning Strikes.
data "Icon" "PassiveFeature_Generic_Thunder"
data "Properties" "Highlighted"
data "StatsFunctorContext" "OnDamage"
data "Conditions" "HasPassive('WAR_MountainThane_Keystone',context.Source) and (HasStringInSpellRoll('Projectile(WAR_Whirlwind)') or HasStringInSpellRoll('Projectile(WAR_Revenge)')) and TargetCountAtLeast(3)"
data "StatsFunctors" "DealDamage(MainMeleeWeapon*0.4,MainMeleeWeaponDamageType);RestoreResource(context.Source,ActionResource,1,0);IF(RandomCastOutcome(25,100)):DealDamage(1d10,Lightning,Magical)"
data "PriorityOrder" "100"
```

**Notes:**
- Triggers when Whirlwind or Revenge hits 3+ targets
- Deals 40% weapon damage as follow-up attack
- Restores 1 Rage (ActionResource with UUID from ActionResourceDefinitions.lsx)
- 25% chance per additional hit to proc Lightning Strikes (1d10 Lightning)
- Multi-target multiplication potential

---

### **LEVEL 17: TIER 2 CHOICES**

#### **1. WAR_MountainThane_ThunderBlast** ✅ RECOMMENDED
```
new entry "WAR_MountainThane_ThunderBlast"
type "PassiveData"
data "DisplayName" "h123abc09;1" // Thunder Blast
data "Description" "h123abc10;1" // Shield Slam has a 35% chance to grant you a Thunder Blast charge (max 2). Your next Thunder Clap consumes a charge to deal +40% damage and generate +2 Rage, appearing as empowered blue lightning.
data "Icon" "PassiveFeature_Generic_Lightning"
data "Properties" "Highlighted"
data "StatsFunctorContext" "OnCast"
data "Conditions" "HasPassive('WAR_MountainThane_Keystone',context.Source) and HasStringInSpellRoll('Projectile(WAR_ShieldSlam)')"
data "StatsFunctors" "IF(RandomCastOutcome(35,100)):ApplyStatus(SELF,WAR_THUNDER_BLAST_CHARGE,100,2)"
data "PriorityOrder" "100"
```

**Notes:**
- Shield Slam has 35% chance to grant Thunder Blast charge
- Status `WAR_THUNDER_BLAST_CHARGE` stacks to 2, duration 100 turns
- Thunder Clap checks for this status and consumes 1 charge
- Status boosts Thunder Clap damage by 40% and grants +2 Rage
- Status definition needed in Status_Warrior.txt

---

#### **2. WAR_MountainThane_GroundCurrent**
```
new entry "WAR_MountainThane_GroundCurrent"
type "PassiveData"
data "DisplayName" "h123abc11;1" // Ground Current
data "Description" "h123abc12;1" // When you deal Lightning damage, it chains to 1 additional nearby enemy within 5m for 60% damage. Chained lightning has a 25% chance to trigger Lightning Strikes. Avatar of the Storm lightning bursts can also chain.
data "Icon" "PassiveFeature_Generic_Lightning"
data "Properties" "Highlighted"
data "StatsFunctorContext" "OnDamage"
data "Conditions" "HasPassive('WAR_MountainThane_Keystone',context.Source) and DamageType(Lightning)"
data "StatsFunctors" "DealDamage(LastDamage*0.6,Lightning,Magical,ClosestEnemyNotSelf,5);IF(RandomCastOutcome(25,100)):DealDamage(1d10,Lightning,Magical,ClosestEnemyNotSelf,5)"
data "PriorityOrder" "98"
```

**Notes:**
- Triggers on ANY Lightning damage (Lightning Strikes, Avatar of the Storm, Thunder Blast)
- Chains to closest enemy within 5m (not original target)
- Chain deals 60% of original Lightning damage
- Chain has 25% chance to trigger additional Lightning Strikes
- Creates chain reaction potential with multiple procs

---

#### **3. WAR_MountainThane_ThoriMight**
```
new entry "WAR_MountainThane_ThoriMight"
type "PassiveData"
data "DisplayName" "h123abc13;1" // Thorim's Might
data "Description" "h123abc14;1" // While Avatar is active, gain +4 Strength, +2 AC, and your Lightning damage ignores resistance.
data "Icon" "PassiveFeature_Generic_Lightning"
data "Properties" "Highlighted"
data "StatsFunctorContext" "OnStatusApplied;OnStatusRemoved"
data "Conditions" "HasPassive('WAR_MountainThane_Keystone',context.Source) and HasStatus('WAR_AVATAR_OF_THE_STORM',context.Source)"
data "StatsFunctors" "IF(HasStatus('WAR_AVATAR_OF_THE_STORM')):ApplyStatus(SELF,WAR_THORIM_MIGHT,-1);IF(not HasStatus('WAR_AVATAR_OF_THE_STORM')):RemoveStatus(SELF,WAR_THORIM_MIGHT)"
data "PriorityOrder" "100"
```

**Notes:**
- Conditional on Avatar active (checks for `WAR_AVATAR_OF_THE_STORM` status)
- Applies `WAR_THORIM_MIGHT` status which grants:
  - `AC(2)` boost
  - `Ability(Strength,4)` boost
  - `IgnoreDamageResistances(Lightning)` boost
- Status auto-removes when Avatar ends
- Status definition needed in Status_Warrior.txt

---

### **LEVEL 19: TIER 3 CHOICES**

#### **1. WAR_MountainThane_StrengthOfMountain** ✅ RECOMMENDED
```
new entry "WAR_MountainThane_StrengthOfMountain"
type "PassiveData"
data "DisplayName" "h123abc15;1" // Strength of the Mountain
data "Description" "h123abc16;1" // Shield Slam damage increased by +15%. Demoralizing Shout reduces enemy damage by an additional -5%.
data "Icon" "PassiveFeature_Generic_Damage"
data "Properties" "Highlighted"
data "Boosts" "IF(HasPassive('WAR_MountainThane_Keystone')):Damage(Increase,15,WAR_ShieldSlam)"
data "StatsFunctorContext" "OnCast"
data "Conditions" "HasPassive('WAR_MountainThane_Keystone',context.Source) and HasStringInSpellRoll('Projectile(WAR_DemoralizingShout)')"
data "StatsFunctors" "ApplyStatus(WAR_DEMORALIZED_ENHANCED,3)"
```

**Notes:**
- Direct 15% damage boost to Shield Slam
- Enhances Demoralizing Shout status (needs custom status `WAR_DEMORALIZED_ENHANCED` with -5% extra damage reduction)
- Passive boost, always active with keystone
- Status definition needed in Status_Warrior.txt

---

#### **2. WAR_MountainThane_KeepFeetOnGround**
```
new entry "WAR_MountainThane_KeepFeetOnGround"
type "PassiveData"
data "DisplayName" "h123abc17;1" // Keep Your Feet on the Ground
data "Description" "h123abc18;1" // Reduce physical damage taken by -3%. When Thunder Blast is active, reduce physical damage by an additional -10% for 5 turns and gain immunity to being knocked Prone.
data "Icon" "PassiveFeature_Generic_Defense"
data "Properties" "Highlighted"
data "Boosts" "IF(HasPassive('WAR_MountainThane_Keystone')):Resistance(Physical,Resistant3);IF(HasStatus('WAR_THUNDER_BLAST_DR')):Resistance(Physical,Resistant10);IF(HasStatus('WAR_THUNDER_BLAST_DR')):StatusImmunity(PRONE)"
data "StatsFunctorContext" "OnCast"
data "Conditions" "HasPassive('WAR_MountainThane_Keystone',context.Source) and HasStringInSpellRoll('Projectile(WAR_ThunderClap)') and HasStatus('WAR_THUNDER_BLAST_CHARGE',context.Source)"
data "StatsFunctors" "ApplyStatus(SELF,WAR_THUNDER_BLAST_DR,5)"
```

**Notes:**
- Base -3% physical damage reduction (always active)
- Thunder Clap cast while holding Thunder Blast charge applies `WAR_THUNDER_BLAST_DR` status (5 turns)
- Status grants -10% physical damage reduction and Prone immunity
- Total -13% physical DR while status active
- Status definition needed in Status_Warrior.txt

---

#### **3. WAR_MountainThane_SteadfastAsPeaks**
```
new entry "WAR_MountainThane_SteadfastAsPeaks"
type "PassiveData"
data "DisplayName" "h123abc19;1" // Steadfast as the Peaks
data "Description" "h123abc20;1" // Maximum HP increased by +8%. When you drop below 50% HP, gain Steadfast (until end of combat): +2 to all Saving Throws, heal for 2% max HP at the start of each turn, and gain +1 AC.
data "Icon" "PassiveFeature_Generic_Defensive"
data "Properties" "Highlighted"
data "Boosts" "IF(HasPassive('WAR_MountainThane_Keystone')):IncreaseMaxHP(8%)"
data "StatsFunctorContext" "OnDamage"
data "Conditions" "HasPassive('WAR_MountainThane_Keystone',context.Source) and HPPercentageLessThan(50) and not HasStatus('WAR_STEADFAST',context.Source)"
data "StatsFunctors" "ApplyStatus(SELF,WAR_STEADFAST,UntilLongRest)"
```

**Notes:**
- Permanent +8% max HP boost
- When HP drops below 50%, applies `WAR_STEADFAST` status
- Status lasts until Long Rest (combat persistence)
- Status grants:
  - `SavingThrowBonus(AllSavingThrows,2)` boost
  - `RegainHP(2%PerTurn)` boost
  - `AC(1)` boost
- Only triggers once per combat (HasStatus check prevents reapplication)
- Status definition needed in Status_Warrior.txt

---

### **LEVEL 20: CAPSTONE**

#### **WAR_MountainThane_GatheringStorms**
```
new entry "WAR_MountainThane_GatheringStorms"
type "PassiveData"
data "DisplayName" "h123abc21;1" // Gathering Storms
data "Description" "h123abc22;1" // Lightning Strikes generate +3 Rage. Revenge and Execute deal +25% damage.
data "Icon" "PassiveFeature_Generic_Lightning"
data "Properties" "Highlighted"
data "Boosts" "IF(HasPassive('WAR_MountainThane_Keystone')):Damage(Increase,25,WAR_Revenge);IF(HasPassive('WAR_MountainThane_Keystone')):Damage(Increase,25,WAR_Execute)"
data "StatsFunctorContext" "OnDamage"
data "Conditions" "HasPassive('WAR_MountainThane_Keystone',context.Source) and DamageType(Lightning) and HasPassive('WAR_MountainThane_LightningStrikes',context.Source)"
data "StatsFunctors" "RestoreResource(context.Source,ActionResource,3,0)"
```

**Notes:**
- Permanent +25% damage to Revenge and Execute
- When Lightning Strikes deals damage, restore 3 Rage (ActionResource)
- Requires Lightning Strikes passive (keystone + L15 choice)
- Major Rage economy boost from frequent procs
- ActionResource UUID from ActionResourceDefinitions.lsx

---

## 📊 MOUNTAIN THANE SUMMARY

**Total Passives**: 11  
**Localization Handles Required**: 22 (11 DisplayName + 11 Description)  
**New Statuses Required**: 6
- `WAR_AVATAR_OF_THE_STORM` (keystone effect)
- `WAR_BURST_OF_POWER` (L15 alternative)
- `WAR_THUNDER_BLAST_CHARGE` (L17 recommended)
- `WAR_THORIM_MIGHT` (L17 alternative)
- `WAR_THUNDER_BLAST_DR` (L19 alternative)
- `WAR_STEADFAST` (L19 alternative)

**Vanilla BG3 Statuses Used**: 
- `PRONE` (immunity granted by Keep Your Feet on the Ground)

**Ability References**:
- WAR_Avatar (placeholder - replace with actual Avatar status)
- WAR_ThunderClap
- WAR_Revenge
- WAR_Execute
- WAR_ShieldSlam
- WAR_Whirlwind
- WAR_DemoralizingShout

---

**Ready for**: Status_Warrior.txt and Passive_Warrior.txt implementation
