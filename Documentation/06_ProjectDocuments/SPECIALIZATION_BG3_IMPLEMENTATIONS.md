# Specialization Talents (Hero Talents) - BG3 Implementation Guide

**Date:** October 17, 2025  
**Scope:** 6 Specializations (Pools 4 & 5) - Levels 13-20  
**Implementation Status:** Design Complete, Ready for Stat Files

---

## Overview

**Specializations** (Hero Talents) are high-level talent trees chosen at **Level 13** that define endgame playstyle. Each specialization has:

- **1 Keystone** (L13) - Unlocks specialization identity
- **3-4 Choice Nodes** (L15/16/17/18/19) - Pick 1 of 2-3 options
- **3-4 Passives** (L14/16/17/18/20) - Auto-granted enhancements
- **1 Capstone** (L20) - Ultimate ability

### Specialization Availability

| Specialization | Arms | Fury | Protection | Structure | Keystone Level |
|----------------|:----:|:----:|:----------:|-----------|----------------|
| **Mountain Thane** | ✅ | ❌ | ❌ | 4-Tier | L13 |
| **Colossus** (Arms) | ✅ | ❌ | ✅ | 3-Tier | L13 |
| **Colossus** (Prot) | ❌ | ❌ | ✅ | 3-Tier | L13 |
| **Slayer** (Arms) | ✅ | ✅ | ❌ | 3-Tier | L13 |
| **Slayer** (Fury) | ❌ | ✅ | ❌ | 3-Tier | L13 |
| **Mountain Thane** (Fury) | ❌ | ✅ | ❌ | 4-Tier | L13 |

---

## Mountain Thane (Arms) - 4-Tier Structure

**Identity:** Thunder god warrior, lightning damage, AoE burst  
**Key Mechanic:** Thunder Blast procs, lightning damage conversion  
**Playstyle:** Mix physical and lightning damage, strong AoE presence

### Keystone: Avatar of the Storm (L13)

**Grants Ability:** Thunder Blast (new spell)

**File:** `Spell_Zone.txt`

```
new entry "Zone_WAR_ThunderBlast"
type "SpellData"
data "SpellType" "Zone"
data "Level" "0"
data "UseCosts" "ActionPoint:1;Rage:30"
data "TargetRadius" "18"
data "AreaRadius" "3"
data "TargetConditions" "Character() and not Dead()"
data "SpellSuccess" "DealDamage(3d8,Lightning,Magical)"
data "Cooldown" "OncePerTurn"
data "DisplayName" "hThunderBlast;1"
data "Description" "hThunderBlastDesc;1"
data "Icon" "Spell_Warrior_ThunderBlast"
data "CastEffect" "VFX_Thunder_Cast"
data "TargetEffect" "VFX_Lightning_Explosion"
```

**Keystone Passive:**

```
new entry "WAR_MountainThane_Keystone"
type "PassiveData"
data "DisplayName" "hAvatarOfStorm;1"
data "Description" "hAvatarOfStormDesc;1"
data "Icon" "Passive_MountainThane"
data "Boosts" "UnlockSpell(Zone_WAR_ThunderBlast);DamageBonus(Lightning,1d6)"
data "StatsFunctorContext" "OnCast"
data "Conditions" "HasStringInSpellRoll('Target(WAR_Charge)') or HasStringInSpellRoll('Target(ARMS_MortalStrike)')"
data "StatsFunctors" "ApplyStatus(SELF,WAR_THUNDER_BLAST_PROC,100,2)"
```

**Status - Thunder Blast Proc:**

```
new entry "WAR_THUNDER_BLAST_PROC"
type "StatusData"
data "StatusType" "BOOST"
data "DisplayName" "hThunderBlastReady;1"
data "Icon" "Spell_Warrior_ThunderBlast_Proc"
data "RemoveEvents" "OnSpellCast;OnTurnEnd"
data "RemoveConditions" "SpellId('Zone_WAR_ThunderBlast') or TurnCounter(2)"
```

**BG3 Stats:**
- **Thunder Blast:** 3d8 lightning, 3m AoE, 30 Rage
- **Proc:** Charge/Mortal Strike trigger free Thunder Blast (2 turn window)
- **Bonus:** +1d6 lightning damage to all attacks
- **Tags:** AoE, Lightning, Proc-Based

---

### Choice Node 1 (L15): Storm Strike vs Avatar's Thunderbolt

#### Option A: Storm Strike (Charge Enhancement)

```
new entry "WAR_MountainThane_StormStrike"
type "PassiveData"
data "DisplayName" "hStormStrike;1"
data "Description" "hStormStrikeDesc;1"
data "Icon" "Passive_MountainThane_StormStrike"
data "StatsFunctorContext" "OnCast"
data "Conditions" "HasStringInSpellRoll('Target(WAR_Charge)')"
data "StatsFunctors" "DealDamage(2d6,Lightning,Magical)"
```

**Effect:** Charge deals +2d6 lightning damage

#### Option B: Avatar's Thunderbolt (Ranged Lightning)

**Grants Spell:**

```
new entry "Projectile_WAR_AvatarsThunderbolt"
type "SpellData"
data "SpellType" "Projectile"
data "UseCosts" "ActionPoint:1;Rage:20"
data "TargetRadius" "18"
data "TargetConditions" "Character() and not Dead()"
data "SpellSuccess" "DealDamage(3d10,Lightning,Magical)"
data "Cooldown" "OncePerTurn"
data "DisplayName" "hAvatarsThunderbolt;1"
data "Description" "hAvatarsThunderboltDesc;1"
data "Icon" "Spell_Warrior_Thunderbolt"
```

**Effect:** Ranged lightning bolt (3d10, 18m)

---

### Passive (L14): Steadfast as the Peaks

```
new entry "WAR_MountainThane_Steadfast"
type "PassiveData"
data "DisplayName" "hSteadfastPeaks;1"
data "Description" "hSteadfastPeaksDesc;1"
data "Icon" "Passive_MountainThane_Steadfast"
data "Boosts" "Resistance(Lightning,Resistant);SavingThrowAdvantage(Dexterity)"
```

**Effect:** Lightning resistance, Advantage on DEX saves

---

### Choice Node 2 (L16): Burst of Power vs Storm Bolts

#### Option A: Burst of Power (Cooldown Reduction)

```
new entry "WAR_MountainThane_BurstOfPower"
type "PassiveData"
data "DisplayName" "hBurstOfPower;1"
data "Description" "hBurstOfPowerDesc;1"
data "Icon" "Passive_MountainThane_Burst"
data "StatsFunctorContext" "OnCast"
data "Conditions" "HasStringInSpellRoll('Zone(WAR_ThunderBlast)')"
data "StatsFunctors" "RestoreResource(SELF,Rage,20,0)"
```

**Effect:** Thunder Blast refunds 20 Rage

#### Option B: Storm Bolts (Multi-Target Lightning)

```
new entry "WAR_MountainThane_StormBolts"
type "PassiveData"
data "DisplayName" "hStormBolts;1"
data "Icon" "Passive_MountainThane_StormBolts"
data "StatsFunctorContext" "OnDamage"
data "Conditions" "DamageType(Lightning)"
data "StatsFunctors" "DealDamage(Lightning,25%);ForceTarget(NearbyEnemies(3))"
```

**Effect:** Lightning damage chains to nearby enemies for 25%

---

### Passive (L17): Thorim's Might

```
new entry "WAR_MountainThane_ThorimsMight"
type "PassiveData"
data "DisplayName" "hThorimsMight;1"
data "Description" "hThorimsMightDesc;1"
data "Icon" "Passive_MountainThane_Thorim"
data "Boosts" "CriticalHit(AttackTarget);IF(DamageType(Lightning)):CriticalDamage(50)"
```

**Effect:** Attacks have advantage on crits, lightning damage crits deal +50% damage

---

### Choice Node 3 (L18): Lightning Strikes vs Thunder Clap Enhancement

#### Option A: Lightning Strikes (Attack Replacement)

```
new entry "WAR_MountainThane_LightningStrikes"
type "PassiveData"
data "DisplayName" "hLightningStrikes;1"
data "Icon" "Passive_MountainThane_Lightning"
data "StatsFunctorContext" "OnDamage"
data "Conditions" "MeleeWeaponAttack()"
data "StatsFunctors" "DealDamage(1d8,Lightning,Magical);RemoveDamageType(MainMeleeWeaponDamageType)"
```

**Effect:** Melee attacks deal lightning damage instead of physical

#### Option B: Thunder Clap Enhancement (Existing Spell Buff)

```
new entry "WAR_MountainThane_ThunderClapEnhancement"
type "PassiveData"
data "DisplayName" "hThunderClapEnhanced;1"
data "Icon" "Passive_MountainThane_ThunderClap"
data "StatsFunctorContext" "OnCast"
data "Conditions" "HasStringInSpellRoll('Zone(WAR_ThunderClap)')"
data "StatsFunctors" "DealDamage(2d6,Lightning,Magical);ApplyStatus(context.Target,SLOWED,100,2)"
```

**Effect:** Thunder Clap deals +2d6 lightning and slows for 2 turns

---

### Choice Node 4 (L19): Flashing Skies vs Stormbreaker

#### Option A: Flashing Skies (Movement Enhancement)

```
new entry "WAR_MountainThane_FlashingSkies"
type "PassiveData"
data "DisplayName" "hFlashingSkies;1"
data "Icon" "Passive_MountainThane_Flashing"
data "Boosts" "IF(HasStatus('WAR_THUNDER_BLAST_PROC',context.Source)):ActionResource(Movement,+3,0)"
```

**Effect:** +3m movement when Thunder Blast proc is active

#### Option B: Stormbreaker (Lightning Burst on Kill)

```
new entry "WAR_MountainThane_Stormbreaker"
type "PassiveData"
data "DisplayName" "hStormbreaker;1"
data "Icon" "Passive_MountainThane_Stormbreaker"
data "StatsFunctorContext" "OnKill"
data "Conditions" "Character()"
data "StatsFunctors" "DealDamage(3d6,Lightning,Magical);ForceTarget(NearbyEnemies(6))"
```

**Effect:** Killing enemies triggers 3d6 lightning AoE (6m radius)

---

### Passive (L20): Gathering Storms (Capstone)

```
new entry "WAR_MountainThane_GatheringStorms"
type "PassiveData"
data "DisplayName" "hGatheringStorms;1"
data "Description" "hGatheringStormsDesc;1"
data "Icon" "Passive_MountainThane_Capstone"
data "StatsFunctorContext" "OnCast"
data "Conditions" "HasStringInSpellRoll('Zone(WAR_ThunderBlast)')"
data "StatsFunctors" "ApplyStatus(SELF,WAR_GATHERING_STORMS,100,-1)"
```

**Status - Gathering Storms Stack:**

```
new entry "WAR_GATHERING_STORMS"
type "StatusData"
data "StatusType" "BOOST"
data "DisplayName" "hGatheringStorms;1"
data "Icon" "Passive_MountainThane_Capstone"
data "Boosts" "DamageBonus(Lightning,1d6)"
data "StackId" "WAR_GATHERING_STORMS"
data "StackType" "Additive"
data "StackPriority" "10"
```

**Effect:** Each Thunder Blast cast permanently increases lightning damage by +1d6 (stacks indefinitely)

---

## Colossus (Arms/Protection) - 3-Tier Structure

**Identity:** Unstoppable juggernaut, shield mastery, tank dominance  
**Key Mechanic:** Colossal Might stacks (+5% damage per stack)  
**Playstyle:** Shield Slam spam, defensive cooldowns, control

### Keystone: Demolish + Colossal Might (L13)

**Grants Ability:** Demolish (new spell)

**File:** `Spell_Target.txt`

```
new entry "Target_WAR_Demolish"
type "SpellData"
data "SpellType" "Target"
data "UseCosts" "ActionPoint:1;Rage:30"
data "TargetRadius" "3"
data "TargetConditions" "Character() and not Dead()"
data "SpellSuccess" "DealDamage(3d10+StrengthModifier,MainMeleeWeaponDamageType,Magical);IF(HasShieldEquipped(context.Source)):DealDamage(2d8,Bludgeoning,Magical);ApplyStatus(context.Target,KNOCKED_PRONE,100,1)"
data "Cooldown" "OncePerTurn"
data "DisplayName" "hDemolish;1"
data "Description" "hDemolishDesc;1"
data "Icon" "Spell_Warrior_Demolish"
```

**Keystone Passive:**

```
new entry "WAR_Colossus_Keystone"
type "PassiveData"
data "DisplayName" "hColossusKeystone;1"
data "Description" "hColossusKeystoneDesc;1"
data "Icon" "Passive_Colossus"
data "Boosts" "UnlockSpell(Target_WAR_Demolish)"
data "StatsFunctorContext" "OnCast"
data "Conditions" "HasStringInSpellRoll('Target(WAR_ShieldSlam)') or HasStringInSpellRoll('Target(WAR_Revenge)')"
data "StatsFunctors" "ApplyStatus(SELF,WAR_COLOSSAL_MIGHT,100,5)"
```

**Status - Colossal Might:**

```
new entry "WAR_COLOSSAL_MIGHT"
type "StatusData"
data "StatusType" "BOOST"
data "DisplayName" "hColossalMight;1"
data "Icon" "Passive_Colossus_Might"
data "Boosts" "DamageBonus(All,5%)"
data "StackId" "WAR_COLOSSAL_MIGHT"
data "StackType" "Additive"
data "StackPriority" "5"
data "RemoveEvents" "OnTurnEnd"
data "RemoveConditions" "TurnCounter(5)"
```

**BG3 Stats:**
- **Demolish:** 3d10+STR + 2d8 (shield bonus), knocks prone
- **Colossal Might:** Shield Slam/Revenge grant +5% damage (stacks 5 turns)
- **Tags:** Control, Stacking Buff, Shield Required

---

### Choice Node 1 (L15): One-Handed Weapon Specialization vs Practiced Strikes

#### Option A: One-Handed Weapon Specialization

```
new entry "WAR_Colossus_OneHandedSpec"
type "PassiveData"
data "DisplayName" "hOneHandedSpec;1"
data "Icon" "Passive_Colossus_OneHanded"
data "Boosts" "IF(HasShieldEquipped(context.Source)):DamageBonus(All,15%)"
```

**Effect:** +15% damage with shield equipped

#### Option B: Practiced Strikes

```
new entry "WAR_Colossus_PracticedStrikes"
type "PassiveData"
data "DisplayName" "hPracticedStrikes;1"
data "Icon" "Passive_Colossus_Practiced"
data "StatsFunctorContext" "OnCast"
data "Conditions" "HasStringInSpellRoll('Target(WAR_ShieldSlam)')"
data "StatsFunctors" "ApplyStatus(SELF,WAR_PRACTICED_STRIKES,100,2)"
```

**Status - Practiced Strikes:**

```
new entry "WAR_PRACTICED_STRIKES"
type "StatusData"
data "StatusType" "BOOST"
data "Boosts" "CriticalHit(AttackTarget)"
data "RemoveEvents" "OnAttack;OnTurnEnd"
data "RemoveConditions" "TurnCounter(2)"
```

**Effect:** Shield Slam grants advantage on next attack (2 turn window)

---

### Passive (L14): Unshakable

```
new entry "WAR_Colossus_Unshakable"
type "PassiveData"
data "DisplayName" "hUnshakable;1"
data "Icon" "Passive_Colossus_Unshakable"
data "Boosts" "IF(HasStatus('WAR_COLOSSAL_MIGHT',context.Source)):AC(StackCount('WAR_COLOSSAL_MIGHT'))"
```

**Effect:** +1 AC per Colossal Might stack (max +5 AC)

---

### Choice Node 2 (L17): Crashing Chaos vs Impassable Wall

#### Option A: Crashing Chaos (Demolish Enhancement)

```
new entry "WAR_Colossus_CrashingChaos"
type "PassiveData"
data "DisplayName" "hCrashingChaos;1"
data "Icon" "Passive_Colossus_Crashing"
data "StatsFunctorContext" "OnCast"
data "Conditions" "HasStringInSpellRoll('Target(WAR_Demolish)')"
data "StatsFunctors" "DealDamage(2d10,MainMeleeWeaponDamageType,Magical);ForceTarget(NearbyEnemies(3))"
```

**Effect:** Demolish creates shockwave dealing 2d10 in 3m radius

#### Option B: Impassable Wall (Defensive Stance)

```
new entry "WAR_Colossus_ImpassableWall"
type "PassiveData"
data "DisplayName" "hImpassableWall;1"
data "Icon" "Passive_Colossus_Wall"
data "Boosts" "IF(HasShieldEquipped(context.Source)):Resistance(Physical,Resistant)"
```

**Effect:** Resistance to physical damage with shield equipped

---

### Passive (L16): Unyielding

```
new entry "WAR_Colossus_Unyielding"
type "PassiveData"
data "DisplayName" "hUnyielding;1"
data "Icon" "Passive_Colossus_Unyielding"
data "Boosts" "StatusImmunity(PRONE);StatusImmunity(KNOCKED_BACK)"
```

**Effect:** Immune to Prone and Knockback

---

### Choice Node 3 (L19): No Quarter vs Mountain of Steel

#### Option A: No Quarter (Cooldown Reduction)

```
new entry "WAR_Colossus_NoQuarter"
type "PassiveData"
data "DisplayName" "hNoQuarter;1"
data "Icon" "Passive_Colossus_NoQuarter"
data "StatsFunctorContext" "OnCast"
data "Conditions" "HasStringInSpellRoll('Target(WAR_Demolish)')"
data "StatsFunctors" "ResetCooldown(Target_WAR_ShieldSlam)"
```

**Effect:** Demolish resets Shield Slam cooldown

#### Option B: Mountain of Steel (Temporary HP)

```
new entry "WAR_Colossus_MountainOfSteel"
type "PassiveData"
data "DisplayName" "hMountainOfSteel;1"
data "Icon" "Passive_Colossus_Mountain"
data "StatsFunctorContext" "OnCast"
data "Conditions" "HasStringInSpellRoll('Target(WAR_ShieldSlam)')"
data "StatsFunctors" "ApplyStatus(SELF,TEMPORARY_HIT_POINTS,100,0);SetStatusDuration(TEMPORARY_HIT_POINTS,10)"
```

**Effect:** Shield Slam grants 10 Temporary HP

---

### Passive (L18): Concussive Blows

```
new entry "WAR_Colossus_ConcussiveBlows"
type "PassiveData"
data "DisplayName" "hConcussiveBlows;1"
data "Icon" "Passive_Colossus_Concussive"
data "StatsFunctorContext" "OnCast"
data "Conditions" "HasStringInSpellRoll('Target(WAR_ShieldSlam)') or HasStringInSpellRoll('Target(WAR_Demolish)')"
data "StatsFunctors" "ApplyStatus(context.Target,CONCUSSED,100,1)"
```

**Status - Concussed:**

```
new entry "CONCUSSED"
type "StatusData"
data "StatusType" "BOOST"
data "DisplayName" "hConcussed;1"
data "Icon" "Status_Concussed"
data "Boosts" "Disadvantage(AttackRoll)"
data "RemoveEvents" "OnTurnEnd"
data "RemoveConditions" "TurnCounter(1)"
```

**Effect:** Shield Slam and Demolish give Disadvantage on attacks (1 turn)

---

### Passive (L20): Dominance of the Colossus (Capstone)

```
new entry "WAR_Colossus_Dominance"
type "PassiveData"
data "DisplayName" "hDominanceColossus;1"
data "Description" "hDominanceColossusDesc;1"
data "Icon" "Passive_Colossus_Capstone"
data "Boosts" "IF(StackCount('WAR_COLOSSAL_MIGHT') >= 3):ActionResourceBlock(Rage);IF(StackCount('WAR_COLOSSAL_MIGHT') >= 3):SpellCostOverride(0)"
```

**Effect:** At 3+ Colossal Might stacks, Rage costs become 0 (abilities are free)

**Balance Note:** Extremely powerful, encourages stacking Colossal Might before burst phase

---

## Slayer (Arms/Fury) - 3-Tier Structure

**Identity:** Execute specialist, ruthless burst, critical focus  
**Key Mechanic:** Execute damage scaling, critical enhancements  
**Playstyle:** Execute spam, burst windows, high-risk high-reward

### Keystone: Slayer's Dominance (L13)

```
new entry "WAR_Slayer_Keystone"
type "PassiveData"
data "DisplayName" "hSlayersDominance;1"
data "Description" "hSlayersDominanceDesc;1"
data "Icon" "Passive_Slayer"
data "Boosts" "IF(HealthPercentage(context.Target) <= 35):DamageBonus(All,25%)"
data "StatsFunctorContext" "OnCast"
data "Conditions" "HasStringInSpellRoll('Target(WAR_Execute)')"
data "StatsFunctors" "RestoreResource(SELF,Rage,10,0)"
```

**BG3 Stats:**
- **Passive Effect:** +25% damage vs targets below 35% HP
- **Execute Refund:** Execute refunds 10 Rage on use
- **Tags:** Damage Amplification, Execute Focus

---

### Choice Node 1 (L15): Culling Cyclone vs Opportunist

#### Option A: Culling Cyclone (Whirlwind Enhancement - Fury)

```
new entry "WAR_Slayer_CullingCyclone"
type "PassiveData"
data "DisplayName" "hCullingCyclone;1"
data "Icon" "Passive_Slayer_Culling"
data "StatsFunctorContext" "OnCast"
data "Conditions" "HasStringInSpellRoll('Zone(FURY_Whirlwind)')"
data "StatsFunctors" "IF(HealthPercentage(context.Target) <= 35):DealDamage(3d8,MainMeleeWeaponDamageType,Magical)"
```

**Effect:** Whirlwind deals +3d8 to targets below 35% HP

#### Option B: Opportunist (Crit Enhancement - Arms)

```
new entry "WAR_Slayer_Opportunist"
type "PassiveData"
data "DisplayName" "hOpportunist;1"
data "Icon" "Passive_Slayer_Opportunist"
data "Boosts" "IF(HealthPercentage(context.Target) <= 35):CriticalHit(AttackTarget)"
```

**Effect:** Attacks have advantage on crits vs targets below 35% HP

---

### Passive (L14): Imminent Demise

```
new entry "WAR_Slayer_ImminentDemise"
type "PassiveData"
data "DisplayName" "hImminentDemise;1"
data "Icon" "Passive_Slayer_Imminent"
data "Boosts" "ActionResource(Rage,+10,0);HealthPercentageThreshold(35)"
```

**Effect:** Gain 10 Rage when enemy drops below 35% HP

---

### Choice Node 2 (L17): Unrelenting Onslaught vs Death Blow

#### Option A: Unrelenting Onslaught (Cooldown Reduction)

```
new entry "WAR_Slayer_UnrelentingOnslaught"
type "PassiveData"
data "DisplayName" "hUnrelentingOnslaught;1"
data "Icon" "Passive_Slayer_Unrelenting"
data "StatsFunctorContext" "OnKill"
data "Conditions" "Character()"
data "StatsFunctors" "ResetCooldown(Target_WAR_Execute)"
```

**Effect:** Kills reset Execute cooldown

#### Option B: Death Blow (Damage Scaling)

```
new entry "WAR_Slayer_DeathBlow"
type "PassiveData"
data "DisplayName" "hDeathBlow;1"
data "Icon" "Passive_Slayer_DeathBlow"
data "StatsFunctorContext" "OnCast"
data "Conditions" "HasStringInSpellRoll('Target(WAR_Execute)')"
data "StatsFunctors" "IF(HealthPercentage(context.Target) <= 20):DealDamage(4d12,MainMeleeWeaponDamageType,Magical)"
```

**Effect:** Execute deals +4d12 to targets below 20% HP

---

### Passive (L16): Brutal Finish

```
new entry "WAR_Slayer_BrutalFinish"
type "PassiveData"
data "DisplayName" "hBrutalFinish;1"
data "Icon" "Passive_Slayer_Brutal"
data "StatsFunctorContext" "OnKill"
data "Conditions" "HasStringInSpellRoll('Target(WAR_Execute)')"
data "StatsFunctors" "ApplyStatus(SELF,WAR_BRUTAL_FINISH,100,2)"
```

**Status - Brutal Finish:**

```
new entry "WAR_BRUTAL_FINISH"
type "StatusData"
data "StatusType" "BOOST"
data "DisplayName" "hBrutalFinish;1"
data "Icon" "Passive_Slayer_Brutal"
data "Boosts" "ActionResourceMultiplier(ActionPoint,100)"
data "RemoveEvents" "OnTurnEnd"
data "RemoveConditions" "TurnCounter(2)"
```

**Effect:** Kills with Execute grant extra Action (2 turn window)

---

### Choice Node 3 (L19): Vicious Agility vs Stunning Assault

#### Option A: Vicious Agility (Movement)

```
new entry "WAR_Slayer_ViciousAgility"
type "PassiveData"
data "DisplayName" "hViciousAgility;1"
data "Icon" "Passive_Slayer_Vicious"
data "StatsFunctorContext" "OnCast"
data "Conditions" "HasStringInSpellRoll('Target(WAR_Execute)')"
data "StatsFunctors" "ApplyStatus(SELF,WAR_VICIOUS_AGILITY,100,1)"
```

**Status - Vicious Agility:**

```
new entry "WAR_VICIOUS_AGILITY"
type "StatusData"
data "StatusType" "BOOST"
data "Boosts" "ActionResource(Movement,+6,0)"
data "RemoveEvents" "OnTurnEnd"
```

**Effect:** Execute grants +6m movement (1 turn)

#### Option B: Stunning Assault (Execute Control)

```
new entry "WAR_Slayer_StunningAssault"
type "PassiveData"
data "DisplayName" "hStunningAssault;1"
data "Icon" "Passive_Slayer_Stunning"
data "StatsFunctorContext" "OnCast"
data "Conditions" "HasStringInSpellRoll('Target(WAR_Execute)') and HealthPercentage(context.Target) <= 20"
data "StatsFunctors" "ApplyStatus(context.Target,STUNNED,100,1)"
```

**Effect:** Execute stuns targets below 20% HP for 1 turn

---

### Passive (L18): Fierce Followthrough

```
new entry "WAR_Slayer_FierceFollowthrough"
type "PassiveData"
data "DisplayName" "hFierceFollowthrough;1"
data "Icon" "Passive_Slayer_Fierce"
data "StatsFunctorContext" "OnKill"
data "Conditions" "Character()"
data "StatsFunctors" "ApplyStatus(SELF,WAR_FIERCE_FOLLOWTHROUGH,100,2)"
```

**Status - Fierce Followthrough:**

```
new entry "WAR_FIERCE_FOLLOWTHROUGH"
type "StatusData"
data "StatusType" "BOOST"
data "Boosts" "DamageBonus(All,25%)"
data "RemoveEvents" "OnTurnEnd"
data "RemoveConditions" "TurnCounter(2)"
```

**Effect:** Kills grant +25% damage for 2 turns

---

### Passive (L20): Slayer's Malice (Capstone)

**Arms Variant:**

```
new entry "WAR_Slayer_Malice_Arms"
type "PassiveData"
data "DisplayName" "hSlayersMalice;1"
data "Description" "hSlayersMaliceDesc;1"
data "Icon" "Passive_Slayer_Capstone"
data "Boosts" "IF(HealthPercentage(context.Target) <= 35):CriticalDamage(100);IF(HealthPercentage(context.Target) <= 20):CriticalDamage(200)"
```

**Fury Variant:**

```
new entry "WAR_Slayer_Malice_Fury"
type "PassiveData"
data "DisplayName" "hSlayersMalice;1"
data "Description" "hSlayersMaliceDesc;1"
data "Icon" "Passive_Slayer_Capstone"
data "Boosts" "IF(HealthPercentage(context.Target) <= 35):ActionResourceMultiplier(Rage,-50);ActionResourceOverride(Rage,Minimum,20)"
```

**Effect:**
- **Arms:** +100% crit damage below 35% HP, +200% below 20% HP
- **Fury:** -50% Rage costs below 35% HP (minimum 20 Rage)

---

## Implementation Priorities

### Phase 1: Keystones (HIGH PRIORITY)

Must complete all 6 keystones first:

1. **Mountain Thane** - Thunder Blast + proc system
2. **Colossus** - Demolish + Colossal Might stacks
3. **Slayer** - Damage boost + Execute refund

**Estimated Time:** 12 hours (6 keystones × 2 hours each)

### Phase 2: Choice Nodes (MEDIUM PRIORITY)

Implement choice nodes (3-4 per specialization):

- Mountain Thane: 4 nodes (L15/16/18/19)
- Colossus: 3 nodes (L15/17/19)
- Slayer: 3 nodes (L15/17/19)

**Estimated Time:** 20 hours (10 nodes × 2 hours each)

### Phase 3: Passives + Capstones (LOW PRIORITY)

Final polish:

- 4-5 passives per specialization (L14/16/17/18/20)
- 6 capstones (L20)

**Estimated Time:** 18 hours (24 passives × 45 min each)

**Total Estimated Time:** 50 hours for all 6 specializations

---

## Localization Requirements

**Total Handles Needed:** ~120 (6 specializations × ~20 handles each)

**Example Block:**

```xml
<contentList>
    <!-- Mountain Thane -->
    <content contentuid="hAvatarOfStorm" version="1">Avatar of the Storm</content>
    <content contentuid="hAvatarOfStormDesc" version="1">Unlock Thunder Blast. Charge and Mortal Strike trigger Thunder Blast procs.</content>
    
    <content contentuid="hThunderBlast" version="1">Thunder Blast</content>
    <content contentuid="hThunderBlastDesc" version="1">Call down lightning in a 3m radius for 3d8 damage.</content>
    
    <!-- Colossus -->
    <content contentuid="hColossusKeystone" version="1">Colossal Might</content>
    <content contentuid="hDemolish" version="1">Demolish</content>
    
    <!-- Slayer -->
    <content contentuid="hSlayersDominance" version="1">Slayer's Dominance</content>
    <content contentuid="hSlayersMalice" version="1">Slayer's Malice</content>
    
    <!-- ... continue for all abilities ... -->
</contentList>
```

---

## Testing Checklist

### Mountain Thane Tests

- [ ] Thunder Blast deals 3d8 lightning in 3m AoE
- [ ] Charge triggers Thunder Blast proc
- [ ] Mortal Strike triggers Thunder Blast proc
- [ ] Proc allows free Thunder Blast cast (2 turn window)
- [ ] +1d6 lightning damage applies to all attacks
- [ ] Storm Strike adds 2d6 to Charge
- [ ] Lightning Strikes converts physical to lightning
- [ ] Gathering Storms stacks infinitely (+1d6 per cast)

### Colossus Tests

- [ ] Demolish deals 3d10+STR + 2d8 (shield bonus)
- [ ] Demolish knocks target prone
- [ ] Shield Slam grants Colossal Might (+5% damage)
- [ ] Colossal Might stacks (visual indicator)
- [ ] Unshakable grants +1 AC per stack (max +5)
- [ ] Dominance of the Colossus makes abilities free at 3+ stacks
- [ ] Crashing Chaos creates shockwave (3m radius)

### Slayer Tests

- [ ] +25% damage vs targets below 35% HP
- [ ] Execute refunds 10 Rage
- [ ] Imminent Demise grants 10 Rage when enemy drops below 35%
- [ ] Unrelenting Onslaught resets Execute on kill
- [ ] Death Blow deals +4d12 to targets below 20% HP
- [ ] Brutal Finish grants extra Action on Execute kill
- [ ] Slayer's Malice (Arms) doubles/triples crit damage
- [ ] Slayer's Malice (Fury) reduces Rage costs by 50%

---

## Full Documentation Reference

For complete specialization designs, see:

- **`ARMS_WARRIOR_5_POOL_TALENT_SYSTEM.md`** - Arms specializations (Mountain Thane, Colossus, Slayer)
- **`FURY_WARRIOR_5_POOL_TALENT_SYSTEM.md`** - Fury specializations
- **`PROTECTION_WARRIOR_5_POOL_TALENT_SYSTEM.md`** - Protection specializations
- **`SPECIALIZATION_TIER_STRUCTURES.md`** - 3-tier vs 4-tier comparisons

---

## Conclusion

**Specializations** define the Warrior's endgame identity (L13-20):

- **Mountain Thane:** Thunder god, lightning damage, AoE burst
- **Colossus:** Unstoppable tank, shield mastery, control
- **Slayer:** Execute specialist, critical focus, burst windows

**Total Abilities:** ~30 across 6 specializations  
**Estimated Implementation Time:** 50 hours  
**Status:** ✅ **DESIGN COMPLETE - READY FOR IMPLEMENTATION**

---

**Last Updated:** October 17, 2025  
**Next Steps:** Begin Phase 1 (Keystones - 12 hours)
