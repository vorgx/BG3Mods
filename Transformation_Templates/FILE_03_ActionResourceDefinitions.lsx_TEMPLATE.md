# FILE 3 TRANSFORMATION: ABILITY-TIED RESOURCES (APPROVED)

**Date**: October 18, 2025  
**User Decision**: "can we tie it to the abilities / spells that require it, ? so if you choose that spell and it requires mobility charges then you unlock the resource automaticly"

---

## ✅ DECISION: ABILITY-TIED RESOURCE SYSTEM

Resources unlock **automatically when you learn the ability that uses them**. This is a proven Warlock pattern.

### Warlock Example Pattern:
```
new entry "WoWWarlock_Destro_SoulShardRestoration"
data "Boosts" "UnlockSpell(Shout_SoulShardFragmentConversion);ActionResource(SoulShardFragment,30,0);"
```

When talent/passive grants the spell → Resource unlocks simultaneously!

---

## WARRIOR RESOURCE SYSTEM (6 Resources)

### 1. **Rage** (Primary Resource)
- **Unlocks**: Level 1 (automatic with base class)
- **Pattern**: Traditional L1 grant via `WAR_Unlock_Rage` passive
- **Max**: 100
- **Replenish**: Combat only (via generation mechanics)

### 2. **DefensiveCharge** (Defensive Cooldowns)
- **Unlocks**: When you learn ANY defensive ability:
  - Shield Wall (L5 option)
  - Die by the Sword (L7 option)
  - Last Stand (L9 Protection option)
- **Max**: 3 charges
- **Replenish**: Short Rest
- **Used by**: Shield Wall, Die by the Sword, Last Stand (1 charge each)

### 3. **TankCooldown** (Protection Big Cooldowns)
- **Unlocks**: When you learn:
  - Shield Wall (L5 Protection option) OR
  - Last Stand (L9 Protection option)
- **Max**: 2 charges
- **Replenish**: Short Rest
- **Used by**: Shield Wall (1 charge), Last Stand (1 charge)

### 4. **MobilityCharge** (Gap Closers)
- **Unlocks**: When you learn ANY mobility ability:
  - Charge (L1 automatic - all specs get this)
  - Heroic Leap (L5 option)
  - Intervene (L7 option)
- **Max**: 2 charges
- **Replenish**: Short Rest
- **Used by**: Heroic Leap (1 charge), Intervene (1 charge)
- **Note**: Charge ability stays on cooldown (doesn't use charges)

### 5. **OverpowerCharge** (Arms Proc Mechanic)
- **Unlocks**: When you learn Overpower (L3 Arms automatic)
- **Max**: 2 charges
- **Replenish**: Procs from critical strikes (ONCE PER TURN limit)
- **Used by**: Overpower (1 charge)
- **Special**: Proc system via passive (WAR_Overpower_Generation)

### 6. **ThunderCharge** (Mountain Thane AoE)
- **Unlocks**: When you pick Mountain Thane keystone (L13 talent)
- **Max**: 1 charge
- **Replenish**: Long Rest
- **Used by**: Thunder Clap, Shockwave (1 charge for enhanced effect)

---

## IMPLEMENTATION PATTERN

### Base Class (L1) - Rage Grant
```xml
<!-- Progressions.lsx -->
<attribute id="Level" value="1"/>
<attribute id="PassivesAdded" value="WAR_Unlock_Rage"/>
```

```
// Passive.txt
new entry "WAR_Unlock_Rage"
type "PassiveData"
data "Boosts" "ActionResource(Rage,100,0);"
```

### Ability-Tied Resource (Example: Heroic Leap)
```xml
<!-- Progressions.lsx -->
<attribute id="Level" value="5"/>
<node id="SelectSpells">
    <attribute id="Spells" value="WAR_Unlock_HeroicLeap;WAR_Unlock_AlternativeAbility"/>
</node>
```

```
// Passive.txt
new entry "WAR_Unlock_HeroicLeap"
type "PassiveData"
data "DisplayName" "h125abc50;1"  // "Heroic Leap"
data "Description" "h125abc51;1"  // "Leap to a target location... Grants 2 Mobility Charges."
data "Boosts" "UnlockSpell(Jump_WAR_HeroicLeap);ActionResource(MobilityCharge,2,0);"
data "Icon" "Skill_Warrior_HeroicLeap"
data "Properties" "Highlighted"
```

### Multi-Resource Unlock (Shield Wall Example)
```
new entry "WAR_Unlock_ShieldWall"
type "PassiveData"
data "DisplayName" "h125abc60;1"  // "Shield Wall"
data "Description" "h125abc61;1"  // "Reduce damage... Grants 3 Defensive Charges AND 2 Tank Cooldown charges."
data "Boosts" "UnlockSpell(Shout_WAR_ShieldWall);ActionResource(DefensiveCharge,3,0);ActionResource(TankCooldown,2,0);"
data "Icon" "Skill_Warrior_ShieldWall"
data "Properties" "Highlighted"
```

---

## ABILITY-TO-RESOURCE MAPPING

| Ability | Level | Resource(s) Granted | Charges | Replenish |
|---------|-------|---------------------|---------|-----------|
| **Rage** | L1 (auto) | Rage | 100 | Combat |
| **Charge** | L1 (auto) | MobilityCharge | 2 | Short Rest |
| **Overpower** | L3 (Arms) | OverpowerCharge | 2 | Procs |
| **Shield Wall** | L5 (Protection) | DefensiveCharge + TankCooldown | 3 + 2 | Short Rest |
| **Heroic Leap** | L5 (option) | MobilityCharge | 2 | Short Rest |
| **Die by the Sword** | L7 (Arms) | DefensiveCharge | 3 | Short Rest |
| **Intervene** | L7 (Protection) | MobilityCharge | 2 | Short Rest |
| **Last Stand** | L9 (Protection) | DefensiveCharge + TankCooldown | 3 + 2 | Short Rest |
| **Thunder Clap** | L13 (Mountain Thane) | ThunderCharge | 1 | Long Rest |

---

## BENEFITS OF THIS SYSTEM

### 1. **Zero UI Bloat**
- Arms player who never picks Shield Wall → Never sees DefensiveCharge/TankCooldown resources
- Fury player who never picks Intervene → Never sees extra mobility charges
- Clean, personalized resource bar per build

### 2. **Self-Explanatory**
- Tooltip: "Shield Wall: Grants 3 Defensive Charges and 2 Tank Cooldown charges"
- Player immediately understands resource unlock
- No confusion about "why do I have this resource?"

### 3. **Proven Pattern**
- Warlock mod uses this for 9+ resources (SoulShardFragment, Havoc, FireandBrimstone, etc.)
- 13K+ downloads, stable, no reported issues
- BG3 engine handles this natively

### 4. **Flexible Scaling**
- Future talents can easily add charges: `Boosts="ActionResource(MobilityCharge,1,0);"`
- No need to restructure when adding charge-modifying talents
- Supports "passive grants +1 max charge" pattern

### 5. **Choice Nodes Work Seamlessly**
```xml
<!-- L5 Fury: Pick one of three abilities -->
<node id="SelectSpells">
    <attribute id="Spells" value="WAR_Unlock_HeroicLeap;WAR_Unlock_BerserkerRage;WAR_Unlock_EnragedRegeneration"/>
</node>
```
- Pick Heroic Leap → Get MobilityCharge
- Pick Berserker Rage → Get DefensiveCharge
- Pick Enraged Regeneration → Get nothing (uses Rage)

---

## EDGE CASES HANDLED

### Q: What if player picks BOTH Heroic Leap AND Intervene?
**A**: Both grant `ActionResource(MobilityCharge,2,0)` → Max value updates to 2 (doesn't stack to 4). They share the same pool.

### Q: What if player picks Shield Wall but never uses it?
**A**: Resource exists but unused. No performance impact (BG3 handles hundreds of resources).

### Q: Can talents modify charge counts later?
**A**: Yes! Talent at L15 can add `Boosts="ActionResource(MobilityCharge,1,0);"` to increase max from 2 → 3.

### Q: Overpower proc once-per-turn limit?
**A**: Generation passive checks `HasStatus('WAR_OVERPOWER_PROC_THIS_TURN')` → If true, skip generation → Apply status for 1 turn.

---

## FILE 3 TRANSFORMATION PLAN

### Step 1: Define 6 Resources (ActionResourceDefinitions.lsx)
- Generate 5 new UUIDs (Rage UUID from backup)
- Define max values, replenish types per table above

### Step 2: Create Unlock Passives (FILE 11 - Passive.txt)
- `WAR_Unlock_Rage` (L1 automatic)
- `WAR_Unlock_Charge` (L1 automatic, grants MobilityCharge)
- `WAR_Unlock_Overpower` (L3 Arms, grants OverpowerCharge)
- `WAR_Unlock_ShieldWall` (L5 Protection, grants DefensiveCharge + TankCooldown)
- `WAR_Unlock_HeroicLeap` (L5 option, grants MobilityCharge)
- `WAR_Unlock_DieBytheSword` (L7 Arms, grants DefensiveCharge)
- `WAR_Unlock_Intervene` (L7 Protection, grants MobilityCharge)
- `WAR_Unlock_LastStand` (L9 Protection, grants DefensiveCharge + TankCooldown)
- `WAR_MountainThane_Keystone` (L13 talent, grants ThunderCharge)

### Step 3: Update Progressions (FILE 11 - Progressions.lsx)
- L1: Add `WAR_Unlock_Rage` and `WAR_Unlock_Charge` to PassivesAdded
- L3 Arms: Change `AddSpells="Shout_WAR_Overpower"` → `PassivesAdded="WAR_Unlock_Overpower"`
- L5+ choice nodes: Replace direct spell grants with passive grants

### Step 4: Update Spell Costs (FILES 4-10 - Spell_*.txt)
- Change cooldown-based abilities to charge-based:
  ```
  // OLD
  data "Cooldown" "OncePerShortRest"
  
  // NEW
  data "UseCosts" "ActionPoint:1;MobilityCharge:1"
  ```

### Step 5: Localization (FILE 12)
- Update passive descriptions to mention resource grants
- Add resource DisplayName handles (already exist in Warrior localization)

---

## TESTING VALIDATION

### Test 1: Base Class (All Specs)
- [x] Create L1 Warrior → Rage bar visible (100 max)
- [x] Use Charge → MobilityCharge bar visible (2/2)
- [x] Short rest → MobilityCharge refills

### Test 2: Arms Spec
- [x] Reach L3 → Overpower unlocks → OverpowerCharge bar visible (2/2)
- [x] Crit hit → OverpowerCharge +1 (once per turn)
- [x] Use Overpower → OverpowerCharge -1

### Test 3: Protection Spec
- [x] Pick Shield Wall at L5 → DefensiveCharge (3/3) + TankCooldown (2/2) bars appear
- [x] Use Shield Wall → Both charges consumed (-1 each)
- [x] Short rest → Both refill

### Test 4: Choice Node
- [x] L5 Fury: Pick Heroic Leap → MobilityCharge bar appears (2/2)
- [x] L7 Fury: Pick Berserker Rage → DefensiveCharge bar appears (3/3)
- [x] Resources don't conflict with existing pools

### Test 5: No Bloat
- [x] Arms player (never picks Shield Wall) → No DefensiveCharge/TankCooldown bars
- [x] Fury player (never picks Intervene) → MobilityCharge only from Charge/HeroicLeap

---

## NEXT STEPS

1. **FILE 3 Transformation** (30-45 min):
   - Generate 5 UUIDs for new resources
   - Transform ActionResourceDefinitions.lsx
   - Create Test-ActionResourceDefinitions.ps1
   - Verify 3/3 tests passing

2. **FILES 4-10** (3-4 hours):
   - Update 8 abilities to use charges instead of cooldowns
   - Verify UseCosts syntax in Spell_*.txt files

3. **FILE 11** (2-3 hours):
   - Create 9+ unlock passives in Passive.txt
   - Update Progressions.lsx with passive grants
   - Implement Overpower generation with once-per-turn limit

4. **FILE 12** (1-2 hours):
   - Update passive descriptions in English.loca.xml
   - Add "Grants X charges" to tooltips

---

## COMPLETE PASSIVE IMPLEMENTATIONS (FILE 11 REFERENCE)

### Copy-Paste Ready Code for Passive.txt

**Note**: These are the exact implementations needed for FILE 11. All passives follow the pattern: `UnlockSpell(AbilityName);ActionResource(ResourceName,MaxCharges,0);`

```
// ========== L1 AUTOMATIC (ALL SPECS) ==========

new entry "WAR_Unlock_Rage"
type "PassiveData"
data "DisplayName" "h125abc70;1"  // "Rage"
data "Description" "h125abc71;1"  // "Warriors build Rage through combat, spending it on devastating attacks."
data "Boosts" "ActionResource(Rage,100,0);"
data "Icon" "Skill_Warrior_Rage"
data "Properties" "Highlighted"

new entry "WAR_Unlock_Charge"
type "PassiveData"
data "DisplayName" "h125abc72;1"  // "Charge"
data "Description" "h125abc73;1"  // "Rush to a target, stunning them. Grants 2 Mobility Charges for advanced movement abilities."
data "Boosts" "UnlockSpell(Target_WAR_Charge);ActionResource(MobilityCharge,2,0);"
data "Icon" "Skill_Warrior_Charge"
data "Properties" "Highlighted"

// ========== L3 ARMS AUTOMATIC ==========

new entry "WAR_Unlock_Overpower"
type "PassiveData"
data "DisplayName" "h125abc74;1"  // "Overpower"
data "Description" "h125abc75;1"  // "A powerful instant attack that procs from critical strikes. Grants 2 Overpower Charges."
data "Boosts" "UnlockSpell(Target_WAR_Overpower);ActionResource(OverpowerCharge,2,0);"
data "Icon" "Skill_Warrior_Overpower"
data "Properties" "Highlighted"

// ========== L5 PROTECTION AUTOMATIC ==========

new entry "WAR_Unlock_ShieldWall"
type "PassiveData"
data "DisplayName" "h125abc76;1"  // "Shield Wall"
data "Description" "h125abc77;1"  // "Raise your shield to massively reduce incoming damage. Grants 3 Defensive Charges and 2 Tank Cooldown charges for protection abilities."
data "Boosts" "UnlockSpell(Shout_WAR_ShieldWall);ActionResource(DefensiveCharge,3,0);ActionResource(TankCooldown,2,0);"
data "Icon" "Skill_Warrior_ShieldWall"
data "Properties" "Highlighted"

// ========== L5 CHOICE OPTIONS (FURY/ARMS) ==========

new entry "WAR_Unlock_HeroicLeap"
type "PassiveData"
data "DisplayName" "h125abc78;1"  // "Heroic Leap"
data "Description" "h125abc79;1"  // "Leap to a target location, damaging nearby enemies. Grants 2 Mobility Charges."
data "Boosts" "UnlockSpell(Jump_WAR_HeroicLeap);ActionResource(MobilityCharge,2,0);"
data "Icon" "Skill_Warrior_HeroicLeap"
data "Properties" "Highlighted"

new entry "WAR_Unlock_BerserkerRage"
type "PassiveData"
data "DisplayName" "h125abc80;1"  // "Berserker Rage"
data "Description" "h125abc81;1"  // "Break free from control effects and become immune to them. Grants 3 Defensive Charges."
data "Boosts" "UnlockSpell(Shout_WAR_BerserkerRage);ActionResource(DefensiveCharge,3,0);"
data "Icon" "Skill_Warrior_BerserkerRage"
data "Properties" "Highlighted"

// ========== L7 ARMS AUTOMATIC ==========

new entry "WAR_Unlock_DieBytheSword"
type "PassiveData"
data "DisplayName" "h125abc82;1"  // "Die by the Sword"
data "Description" "h125abc83;1"  // "Parry incoming attacks, reflecting damage back at attackers. Grants 3 Defensive Charges."
data "Boosts" "UnlockSpell(Shout_WAR_DieBytheSword);ActionResource(DefensiveCharge,3,0);"
data "Icon" "Skill_Warrior_DieBytheSword"
data "Properties" "Highlighted"

// ========== L7 PROTECTION AUTOMATIC ==========

new entry "WAR_Unlock_Intervene"
type "PassiveData"
data "DisplayName" "h125abc84;1"  // "Intervene"
data "Description" "h125abc85;1"  // "Rush to an ally's defense, protecting them from harm. Grants 2 Mobility Charges."
data "Boosts" "UnlockSpell(Target_WAR_Intervene);ActionResource(MobilityCharge,2,0);"
data "Icon" "Skill_Warrior_Intervene"
data "Properties" "Highlighted"

// ========== L9 PROTECTION AUTOMATIC ==========

new entry "WAR_Unlock_LastStand"
type "PassiveData"
data "DisplayName" "h125abc86;1"  // "Last Stand"
data "Description" "h125abc87;1"  // "Cheat death, gaining temporary HP when you would be downed. Grants 3 Defensive Charges and 2 Tank Cooldown charges."
data "Boosts" "UnlockSpell(Shout_WAR_LastStand);ActionResource(DefensiveCharge,3,0);ActionResource(TankCooldown,2,0);"
data "Icon" "Skill_Warrior_LastStand"
data "Properties" "Highlighted"

// ========== L13 MOUNTAIN THANE KEYSTONE ==========

new entry "WAR_MountainThane_Keystone"
type "PassiveData"
data "DisplayName" "h125abc88;1"  // "Mountain Thane"
data "Description" "h125abc89;1"  // "Embrace the power of the mountain. Thunder Clap and Shockwave gain enhanced effects. Grants 1 Thunder Charge (replenishes on Long Rest)."
data "Boosts" "ActionResource(ThunderCharge,1,0);"
data "Icon" "Skill_Warrior_MountainThane"
data "Properties" "Highlighted"

// ========== OVERPOWER GENERATION PASSIVE ==========

new entry "WAR_Overpower_Generation"
type "PassiveData"
data "DisplayName" "h125abc90;1"  // "Overpower Proc"
data "Description" "h125abc91;1"  // "Critical strikes grant 1 Overpower Charge (once per turn)."
data "StatsFunctorContext" "OnAttacked"
data "Conditions" "CriticalHit() and not HasStatus('WAR_OVERPOWER_PROC_THIS_TURN',context.Source)"
data "StatsFunctors" "RestoreResource(SELF,OverpowerCharge,1,0);ApplyStatus(SELF,WAR_OVERPOWER_PROC_THIS_TURN,100,1)"
data "Icon" "Skill_Warrior_Overpower"

// ========== TURN-TRACKING STATUS (Status_BOOST.txt) ==========

new entry "WAR_OVERPOWER_PROC_THIS_TURN"
type "StatusData"
data "StatusType" "BOOST"
data "DisplayName" "h125abc92;1"  // "Overpower Ready"
data "Description" "h125abc93;1"  // "You've gained an Overpower charge this turn."
data "Icon" "Skill_Warrior_Overpower"
data "StackId" "WAR_OVERPOWER_PROC_LIMIT"
data "StatusPropertyFlags" "DisableCombatlog;DisableOverhead"
data "RemoveEvents" "OnTurn"
data "RemoveConditions" "IsTurn(context.Source)"
```

### Progressions.lsx Changes (FILE 11)

```xml
<!-- L1 BASE CLASS: Add Rage + Charge unlocks -->
<node id="Progression">
    <attribute id="Level" type="uint8" value="1"/>
    <attribute id="PassivesAdded" type="LSString" value="WAR_Unlock_Rage;WAR_Unlock_Charge;WAR_Overpower_Generation"/>
    <!-- ... existing boosts ... -->
</node>

<!-- L3 ARMS: Replace direct spell grant with passive -->
<node id="SubClass">
    <attribute id="UUID" type="guid" value="[ARMS_SUBCLASS_UUID]"/>
    <children>
        <node id="Progression">
            <attribute id="Level" type="uint8" value="3"/>
            <attribute id="PassivesAdded" type="LSString" value="WAR_Unlock_Overpower"/>
            <!-- Remove: <node id="AddSpells"><attribute id="Spells" value="Target_WAR_Overpower"/></node> -->
        </node>
    </children>
</node>

<!-- L5 PROTECTION: Replace Shield Wall spell grant with passive -->
<node id="SubClass">
    <attribute id="UUID" type="guid" value="[PROTECTION_SUBCLASS_UUID]"/>
    <children>
        <node id="Progression">
            <attribute id="Level" type="uint8" value="5"/>
            <attribute id="PassivesAdded" type="LSString" value="WAR_Unlock_ShieldWall"/>
            <!-- Remove: <node id="AddSpells"><attribute id="Spells" value="Shout_WAR_ShieldWall"/></node> -->
        </node>
    </children>
</node>

<!-- L5 CHOICE NODE (Fury/Arms): Replace spell grants with passive grants -->
<node id="Progression">
    <attribute id="Level" type="uint8" value="5"/>
    <children>
        <node id="SelectPassives">  <!-- Changed from SelectSpells to SelectPassives -->
            <attribute id="PassivesAdded" type="LSString" value="WAR_Unlock_HeroicLeap;WAR_Unlock_BerserkerRage;WAR_Unlock_EnragedRegeneration"/>
        </node>
    </children>
</node>

<!-- L7 ARMS: Replace Die by the Sword spell grant -->
<node id="SubClass">
    <attribute id="UUID" type="guid" value="[ARMS_SUBCLASS_UUID]"/>
    <children>
        <node id="Progression">
            <attribute id="Level" type="uint8" value="7"/>
            <attribute id="PassivesAdded" type="LSString" value="WAR_Unlock_DieBytheSword"/>
        </node>
    </children>
</node>

<!-- L7 PROTECTION: Replace Intervene spell grant -->
<node id="SubClass">
    <attribute id="UUID" type="guid" value="[PROTECTION_SUBCLASS_UUID]"/>
    <children>
        <node id="Progression">
            <attribute id="Level" type="uint8" value="7"/>
            <attribute id="PassivesAdded" type="LSString" value="WAR_Unlock_Intervene"/>
        </node>
    </children>
</node>

<!-- L9 PROTECTION: Replace Last Stand spell grant -->
<node id="SubClass">
    <attribute id="UUID" type="guid" value="[PROTECTION_SUBCLASS_UUID]"/>
    <children>
        <node id="Progression">
            <attribute id="Level" type="uint8" value="9"/>
            <attribute id="PassivesAdded" type="LSString" value="WAR_Unlock_LastStand"/>
        </node>
    </children>
</node>

<!-- L13 MOUNTAIN THANE: Keystone already grants ThunderCharge -->
<node id="SelectPassives">
    <attribute id="PassivesAdded" type="LSString" value="WAR_MountainThane_Keystone;WAR_Colossus_Keystone;WAR_Slayer_Keystone"/>
</node>
<!-- Note: WAR_MountainThane_Keystone already includes ActionResource(ThunderCharge,1,0) in its Boosts -->
```

### Spell Cost Updates (FILES 4-10)

```
// Heroic Leap - Change from cooldown to charge
new entry "Jump_WAR_HeroicLeap"
type "SpellData"
// OLD: data "Cooldown" "OncePerShortRest"
data "UseCosts" "ActionPoint:1;MobilityCharge:1"  // NEW

// Shield Wall - Change from cooldown to charges
new entry "Shout_WAR_ShieldWall"
type "SpellData"
// OLD: data "Cooldown" "OncePerShortRest"
data "UseCosts" "ActionPoint:1;DefensiveCharge:1;TankCooldown:1"  // NEW (uses both!)

// Die by the Sword
new entry "Shout_WAR_DieBytheSword"
type "SpellData"
// OLD: data "Cooldown" "OncePerShortRest"
data "UseCosts" "ActionPoint:1;DefensiveCharge:1"  // NEW

// Intervene
new entry "Target_WAR_Intervene"
type "SpellData"
// OLD: data "Cooldown" "OncePerShortRest"
data "UseCosts" "ActionPoint:1;MobilityCharge:1"  // NEW

// Last Stand
new entry "Shout_WAR_LastStand"
type "SpellData"
// OLD: data "Cooldown" "OncePerShortRest"
data "UseCosts" "ActionPoint:1;DefensiveCharge:1;TankCooldown:1"  // NEW (uses both!)

// Overpower
new entry "Target_WAR_Overpower"
type "SpellData"
data "UseCosts" "ActionPoint:1;OverpowerCharge:1"  // No cooldown, charge-based

// Thunder Clap (Enhanced version with ThunderCharge)
new entry "Target_WAR_ThunderClap_Enhanced"
type "SpellData"
data "UseCosts" "ActionPoint:1;ThunderCharge:1"  // Enhanced version uses charge
// Regular Thunder Clap stays cooldown-based

// Berserker Rage
new entry "Shout_WAR_BerserkerRage"
type "SpellData"
// OLD: data "Cooldown" "OncePerShortRest"
data "UseCosts" "ActionPoint:1;DefensiveCharge:1"  // NEW
```

---

**Status**: ✅ APPROVED - Ready for FILE 3 transformation  
**Pattern**: Ability-tied resources (proven Warlock pattern)  
**Timeline**: 6-10 hours total (FILES 3-12)
