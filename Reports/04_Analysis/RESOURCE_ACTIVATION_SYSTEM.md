# Resource Activation & Unlock System: Warlock vs Warrior

**Date**: October 18, 2025  
**Purpose**: Explain when/how resources become available to players  
**Context**: Understanding Warlock's proven system to apply to Warrior

---

## 🎯 HOW WARLOCK MOD ACTIVATES RESOURCES

### System Overview
Resources are activated through **Passives** that grant `ActionResource(ResourceName,Amount,0)` at specific levels.

---

## 📊 WARLOCK RESOURCE ACTIVATION BREAKDOWN

### **Resource #1: Soul Shard (Primary Resource)**

**When Unlocked**: Level 1 (automatic)  
**How**: Passive granted at L1 in Progressions.lsx

```xml
<!-- In Progressions.lsx (L1) -->
<attribute id="PassivesAdded" type="LSString" value="WoWWarlock_Unlock_SoulShard;WoWWarlock_BlackHarvest"/>
```

```
// In Passive.txt
new entry "WoWWarlock_Unlock_SoulShard"
type "PassiveData"
data "DisplayName" "hfcac4604g2900g5ae2g5c1cg1b122b9c2e1f;1"
data "Description" "h264df7d6g8756g820fg4427geee8c7aa4b59;2"
data "Icon" "WoWWarlock_Class_SoulShard"
data "Properties" "Highlighted"
data "Boosts" "ActionResource(SoulShard,5,0);"
```

**Result**: At L1, Warlock has 5 Soul Shards immediately available

---

### **Resource #2: Demonic Core (Demonology Spec)**

**When Unlocked**: When selecting Demonology talent (L3+)  
**How**: Passive granted via talent selection

```
// In Passive.txt
new entry "WoWWarlock_Demo_DemonicCore"
type "PassiveData"
data "DisplayName" "h65edbba3g53e1gdd01gae9fge6395c8e6c24;2"
data "Description" "ha78aab56g78ebga0d2g8e2eg31bd240dca61;7"
data "Icon" "WoWWarlock_Class_Demo_DemonicCore"
data "Properties" "Highlighted"
data "Boosts" "UnlockSpell(Projectile_Demo_Demonbolt_1);ActionResource(DemonicCore,4,0);"
```

**Result**: When player selects Demonology talent, they gain 4 Demonic Cores + unlocks Demonbolt spell

---

### **Resource #3: Havoc (Destruction Spec)**

**When Unlocked**: When selecting Destruction talent  
**How**: Passive granted via talent selection

```
// In Passive.txt (line ~1369)
data "Boosts" "UnlockSpellVariant(...);ActionResource(Havoc,1,0);"
```

**Result**: When player selects Destruction talent, they gain 1 Havoc charge + spell variants

---

### **Resource #4-10: Other Spec Resources**

All follow same pattern:
1. Player selects talent/passive at specific level
2. Passive grants `ActionResource(ResourceName,MaxAmount,0)`
3. Resource appears in UI immediately

---

## 🔑 KEY PATTERNS FROM WARLOCK

### Pattern 1: **Base Class Resource at L1**
```
Level 1 → Grant "Unlock_PrimaryResource" passive → Player has max charges immediately
```
**Example**: Soul Shards (5) available from character creation

### Pattern 2: **Spec Resources via Talents**
```
Player selects talent → Passive grants ActionResource → Resource becomes available
```
**Example**: Demonic Core (4) only available if Demonology talent selected

### Pattern 3: **Charge Generation via Passives**
```
Passive with StatsFunctorContext → Condition met → RestoreResource(ResourceName,Amount,0)
```
**Example**: Hand of Gul'dan cast → 18+ on d20 roll → +1 Demonic Core

### Pattern 4: **Resource + Spell Unlock Combined**
```
data "Boosts" "UnlockSpell(SpellName);ActionResource(ResourceName,Amount,0);"
```
**Example**: Demonic Core passive unlocks Demonbolt AND grants 4 charges

---

## 🛡️ APPLYING TO WARRIOR MOD

### **Resource #1: Rage (Primary Resource)**

**When Unlocked**: Level 1 (automatic)  
**How**: Passive granted at L1 in Progressions.lsx

```xml
<!-- In Progressions.lsx (L1) -->
<attribute id="PassivesAdded" type="LSString" value="WAR_Unlock_Rage"/>
```

```
// In Passive.txt
new entry "WAR_Unlock_Rage"
type "PassiveData"
data "DisplayName" "h125abc01;1"
data "Description" "h125abc02;1"
data "Icon" "Action_Barbarian_Rage"
data "Properties" "Highlighted"
data "Boosts" "ActionResource(Rage,100,0);"
```

**Result**: At L1, Warrior has 100 Rage immediately available (starts at 0, can generate to 100)

---

### **Resource #2: DefensiveCharge**

**When Unlocked**: Level 1 (automatic, available to all Warriors)  
**How**: Passive granted at L1

```
// In Passive.txt
new entry "WAR_Unlock_DefensiveCharge"
type "PassiveData"
data "DisplayName" "h125abc03;1"
data "Description" "h125abc04;1"
data "Icon" "Action_Paladin_ShieldOfFaith"
data "Properties" "Highlighted"
data "Boosts" "ActionResource(DefensiveCharge,1,0);"
```

**Result**: At L1, Warrior has 1 DefensiveCharge (can use Die by the Sword OR Berserker Rage)

---

### **Resource #3: TankCooldown**

**When Unlocked**: Level 3 (when selecting Protection subclass)  
**How**: Granted via Protection subclass selection

**Option A - Automatic with Subclass**:
```xml
<!-- In Progressions.lsx - Protection subclass L3 -->
<attribute id="PassivesAdded" type="LSString" value="WAR_Protection_TankCooldown"/>
```

**Option B - Via Talent Selection**:
```
// Player chooses Protection talent that grants resource
```

**Recommendation**: **Option A** (automatic with subclass)  
**Rationale**: Tank cooldowns are core Protection identity, shouldn't require talent choice

---

### **Resource #4: MobilityCharge**

**When Unlocked**: Level 1 (automatic, available to all Warriors)  
**How**: Passive granted at L1

```
// In Passive.txt
new entry "WAR_Unlock_MobilityCharge"
type "PassiveData"
data "DisplayName" "h125abc05;1"
data "Description" "h125abc06;1"
data "Icon" "Action_Jump"
data "Properties" "Highlighted"
data "Boosts" "ActionResource(MobilityCharge,2,0);"
```

**Result**: At L1, Warrior has 2 MobilityCharges (for Heroic Leap, Intervene, Storm Bolt)

---

### **Resource #5: OverpowerCharge**

**When Unlocked**: Level 3 (when selecting Arms subclass OR Arms talent)  
**How**: Granted via Arms talent selection

```
// In Passive.txt
new entry "WAR_ARMS_Unlock_Overpower"
type "PassiveData"
data "DisplayName" "h8a7f2b01;1"
data "Description" "h8a7f2b02;1"
data "Icon" "Action_Barbarian_FrenziedStrike"
data "Properties" "Highlighted"
data "Boosts" "UnlockSpell(Target_WAR_Overpower);ActionResource(OverpowerCharge,2,0);"
data "StatsFunctorContext" "OnAttackTarget"
data "Conditions" "AttackRollFailed() and not IsCriticalMiss() and not TurnBased(SG_OverpowerProcThisTurn)"
data "StatsFunctors" "RestoreResource(SELF,OverpowerCharge,1,0);ApplyStatus(SELF,SG_OverpowerProcThisTurn,100,1)"
```

**Result**: 
- Arms talent grants Overpower spell + 2 max charges (starts at 0)
- Enemy dodges/parries → +1 OverpowerCharge (max once per turn)
- Can store up to 2 charges

---

### **Resource #6: ThunderCharge**

**When Unlocked**: Level 13 (Mountain Thane keystone)  
**How**: Granted via L13 specialization choice

```
// In Passive.txt
new entry "WAR_MountainThane_Keystone"
type "PassiveData"
data "DisplayName" "h123abc01;1"
data "Description" "h123abc02;1"
data "Icon" "PassiveFeature_Generic_Lightning"
data "Properties" "Highlighted"
data "Boosts" "ActionResource(ThunderCharge,3,0);"
data "StatsFunctorContext" "OnStatusApplied"
data "Conditions" "HasStatus('SG_Polymorph_BeastShape_Behaviour',context.Source)"
data "StatsFunctors" "ApplyStatus(SELF,WAR_AVATAR_OF_THE_STORM,-1)"
```

**Result**: 
- Mountain Thane keystone grants 3 max charges (starts at 0)
- Shield Slam (35% chance) → +1 ThunderCharge
- Can store up to 3 charges for empowered Thunder Clap

---

## 📊 WARRIOR RESOURCE ACTIVATION TIMELINE

| Level | Resource | How Unlocked | Granted By | Max Charges |
|-------|----------|--------------|------------|-------------|
| **L1** | Rage | Automatic | Base class passive | 100 |
| **L1** | DefensiveCharge | Automatic | Base class passive | 1 |
| **L1** | MobilityCharge | Automatic | Base class passive | 2 |
| **L3** | TankCooldown | Subclass | Protection subclass passive | 1 |
| **L3** | OverpowerCharge | Talent | Arms talent passive | 2 (starts at 0) |
| **L13** | ThunderCharge | Specialization | Mountain Thane keystone | 3 (starts at 0) |

---

## 🎮 PLAYER EXPERIENCE

### **At Character Creation (L1)**:
```
Resources Visible:
- Rage: 0/100 (generates in combat)
- DefensiveCharge: 1/1 (ready to use)
- MobilityCharge: 2/2 (ready to use)
```

### **At L3 (Arms Warrior)**:
```
Resources Visible:
- Rage: 0/100
- DefensiveCharge: 1/1
- MobilityCharge: 2/2
- OverpowerCharge: 0/2 (NEW - procs from dodges)
```

### **At L3 (Protection Warrior)**:
```
Resources Visible:
- Rage: 0/100
- DefensiveCharge: 1/1
- MobilityCharge: 2/2
- TankCooldown: 1/1 (NEW - for Last Stand/Shield Wall/Indomitable)
```

### **At L13 (Mountain Thane Protection)**:
```
Resources Visible:
- Rage: 0/100
- DefensiveCharge: 1/1
- MobilityCharge: 2/2
- TankCooldown: 1/1
- ThunderCharge: 0/3 (NEW - procs from Shield Slam)
```

---

## ✅ IMPLEMENTATION PLAN

### FILE 3 (ActionResourceDefinitions.lsx):
✅ Define all 6 resources with max values + replenish types

### FILE 11 (Passives - Later):
✅ Create unlock passives:
- `WAR_Unlock_Rage` (L1)
- `WAR_Unlock_DefensiveCharge` (L1)
- `WAR_Unlock_MobilityCharge` (L1)
- `WAR_Protection_TankCooldown` (L3 Protection)
- `WAR_ARMS_Unlock_Overpower` (L3 Arms)
- `WAR_MountainThane_Keystone` (L13 Mountain Thane)

### FILE 11 (Progressions.lsx - Later):
✅ Grant passives at correct levels:
- L1: `WAR_Unlock_Rage;WAR_Unlock_DefensiveCharge;WAR_Unlock_MobilityCharge`
- L3 Protection: `WAR_Protection_TankCooldown`
- L3 Arms: `WAR_ARMS_Unlock_Overpower` (via talent choice)
- L13: `WAR_MountainThane_Keystone` (via specialization choice)

---

## 🎯 KEY DECISION FOR YOU

**Question**: Should **TankCooldown** and **OverpowerCharge** be:

### **Option 1: Automatic with Subclass** (Warlock-style)
- Protection Warriors get TankCooldown at L3 (no choice)
- Arms Warriors get OverpowerCharge at L3 (no choice)
- **Pros**: Simple, guaranteed resources for specs
- **Cons**: No player choice

### **Option 2: Via Talent Selection** (Player choice)
- TankCooldown is a Protection talent (player chooses to unlock)
- OverpowerCharge is an Arms talent (player chooses to unlock)
- **Pros**: Player agency, can opt-out if preferred
- **Cons**: More complex, resource might not be available

### **My Recommendation**: **Option 1 (Automatic)**
**Rationale**:
- TankCooldown is CORE Protection identity (tank cooldowns define tanks)
- OverpowerCharge is CORE Arms identity (reactive damage is Arms theme)
- Warlock uses automatic (Demonic Core granted with Demonology selection)
- Simplifies player experience (don't have to "unlock" core mechanics)

---

## ❓ YOUR DECISION NEEDED

**Before we proceed with FILE 3**:

1. **TankCooldown**: Automatic at L3 Protection OR talent choice?
2. **OverpowerCharge**: Automatic at L3 Arms OR talent choice?
3. **ThunderCharge**: Automatic at L13 Mountain Thane OR talent choice? (I recommend automatic)

**Most Common Pattern** (Warlock + other mods): **Automatic with subclass/specialization**

**Reply**: "All automatic" OR specify custom choices

Once decided, I'll document this in FILE 3 template and proceed with transformation! 🚀
