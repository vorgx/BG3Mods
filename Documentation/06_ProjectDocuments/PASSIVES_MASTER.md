# Warrior Specializations - Complete Passive Definitions
**Date:** October 16, 2025  
**Status:** 📋 **READY FOR STATS FILE IMPLEMENTATION**

---

## 📚 DOCUMENT OVERVIEW

This master document consolidates all specialization passive definitions for the Warrior class mod. For detailed breakdowns, see individual specialization documents:

- **PASSIVES_MOUNTAIN_THANE.md** - Lightning/Storm theme (Fury + Protection)
- **PASSIVES_COLOSSUS.md** - Stack & Burst theme (Arms + Protection)
- **PASSIVES_SLAYER.md** - Mark & Execute theme (Arms + Fury)

---

## 📊 IMPLEMENTATION SUMMARY

### **Total Passive Count by Specialization**

| Specialization | Unique Passives | Duplicate Options | Total Entries |
|----------------|-----------------|-------------------|---------------|
| **Mountain Thane** | 11 | 0 | 11 |
| **Colossus** | 11 | 0 | 11 |
| **Slayer** | 9 | 2 (L17/L19 alts) | 11 |
| **GRAND TOTAL** | **31 unique** | **2 duplicates** | **33 entries** |

### **Localization Handles Required**

| Specialization | DisplayName | Description | Status Handles | Total |
|----------------|-------------|-------------|----------------|-------|
| **Mountain Thane** | 11 | 11 | 0 | 22 |
| **Colossus** | 11 | 11 | 4 | 26 |
| **Slayer** | 9 | 9 | 4 | 22 |
| **GRAND TOTAL** | **31** | **31** | **8** | **70** |

### **Status Definitions Required**

#### **Mountain Thane Statuses (6 new)**
1. `WAR_AVATAR_OF_THE_STORM` - Keystone lightning aura
2. `WAR_BURST_OF_POWER` - L15 Shield Slam cost reduction (2 charges)
3. `WAR_THUNDER_BLAST_CHARGE` - L17 Thunder Clap enhancement (max 2 stacks)
4. `WAR_THORIM_MIGHT` - L17 Avatar stat boost
5. `WAR_THUNDER_BLAST_DR` - L19 damage reduction + Prone immunity
6. `WAR_STEADFAST` - L19 comeback mechanic (<50% HP)

#### **Colossus Statuses (7 new)**
1. `WAR_COLOSSAL_MIGHT` - Keystone stacking buff (max 5)
2. `WAR_VETERAN_VITALITY_HEAL` - L15 heal over time
3. `WAR_VETERAN_VITALITY_CD` - L15 cooldown tracker (15 turns)
4. `WAR_ONE_AGAINST_MANY` - L15 damage scaling by target count
5. `WAR_BLEEDING_ENHANCED` - L17 scaled bleed with Colossal Might
6. `WAR_DEMOLISH_SHOCKWAVE_BUFF` - L19 combo empowerment (2 turns)
7. `WAR_DEMORALIZED_ENHANCED` - Shared with Mountain Thane

#### **Slayer Statuses (3 new)**
1. `WAR_MARKED_FOR_EXECUTION` - Keystone main debuff (4 turns)
2. `WAR_BLOOD_FRENZY` - L15 Execute reward (2 turns)
3. `WAR_OVERWHELMED` - L19 AoE debuff (3 turns)

**Total New Statuses**: **16** (6 Mountain Thane + 7 Colossus + 3 Slayer)

### **Vanilla BG3 Statuses Used (No Implementation Needed)**
- `BLEEDING` - 1d6 Slashing/turn (Colossus Arterial Bleed)
- `HEALING_REDUCTION` - -50% healing (Slayer Imminent Demise)
- `PRONE` - Knock down (Colossus Earthquaker, immunity from Mountain Thane)
- `STUNNED` - Shockwave base (enhanced by Colossus L19)

### **New Spell Required**
- `WAR_Demolish` (Colossus Keystone)
  - Type: Target Spell (melee range)
  - Cost: 40 Rage
  - Damage: 3 attacks × (3d10 + STR modifier) each
  - Effect: Consumes all Colossal Might stacks (+10% damage per stack)
  - Recharge: Short Rest
  - Target: Single enemy

---

## 🗂️ FILE STRUCTURE FOR IMPLEMENTATION

### **1. Passive_Warrior.txt**
Location: `Data/Public/BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7/Stats/Generated/Data/`

**Content to Add**: All 33 passive entries (31 unique + 2 duplicates)
- Mountain Thane: 11 passives
- Colossus: 11 passives
- Slayer: 11 passives (9 unique + 2 alt options)

**Format**: Standard BG3 PassiveData entries with:
- DisplayName (TranslatedString handle)
- Description (TranslatedString handle)
- Icon (reuse vanilla icons)
- Boosts (passive effects)
- StatsFunctorContext (trigger conditions)
- StatsFunctors (active effects)

### **2. Status_Warrior.txt**
Location: `Data/Public/BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7/Stats/Generated/Data/`

**Content to Add**: 16 new status definitions
- Each status needs:
  - StatusType (BOOST, COMBAT, etc.)
  - DisplayName + Description (if visible to player)
  - Icon (if visible)
  - Boosts (mechanical effects)
  - Duration handling (turns, UntilLongRest, etc.)
  - StackId (if stackable)
  - RemoveEvents/Conditions (if conditional)

### **3. Spell_Warrior.txt**
Location: `Data/Public/BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7/Stats/Generated/Data/`

**Content to Add**: 1 new spell (Demolish)
- SpellType: Target
- TargetRadius: Melee range
- Damage formula: 3×(3d10+StrengthModifier)
- UseCosts: ActionPoint:1;ActionResource(Rage,40)
- SpellSuccess: DealDamage with Colossal Might multiplier
- Requirements: Check Colossal Might stacks, consume all
- Recharge: Short Rest

### **4. English.loca.xml**
Location: `Data/Mods/BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7/Localization/English/`

**Content to Add**: 70 TranslatedString entries
- 31 passive DisplayNames
- 31 passive Descriptions
- 8 status DisplayNames/Descriptions
- Handles format: `h123abc01` through `h125abc20` + status handles

---

## 🔧 IMPLEMENTATION CHECKLIST

### **Phase 1: Status Definitions** ⏸️
- [ ] Create Status_Warrior.txt in Stats/Generated/Data/
- [ ] Define 16 new statuses (6 Mountain Thane + 7 Colossus + 3 Slayer)
- [ ] Test status application/removal (use console commands)
- [ ] Verify stacking mechanics (Colossal Might, Thunder Blast Charge)
- [ ] Test duration handling (turn-based, UntilLongRest)

### **Phase 2: Spell Definition** ⏸️
- [ ] Create Spell_Warrior.txt (or add to existing)
- [ ] Define WAR_Demolish spell
- [ ] Implement Colossal Might stack consumption
- [ ] Test damage calculation with stack multipliers
- [ ] Verify Rage cost and cooldown

### **Phase 3: Passive Definitions** ⏸️
- [ ] Create Passive_Warrior.txt (or add to existing)
- [ ] Add all 33 passive entries
- [ ] Link passives to statuses via StatsFunctors
- [ ] Test proc chances (Lightning Strikes 25%, Thunder Blast 35%, etc.)
- [ ] Verify conditional requirements (HasPassive checks for keystone)

### **Phase 4: Localization** ⏸️
- [ ] Create English.loca.xml (or add to existing)
- [ ] Generate 70 TranslatedString handles
- [ ] Write display names (short, clear)
- [ ] Write descriptions (explain mechanics, include numbers)
- [ ] Test in-game tooltip display

### **Phase 5: Integration Testing** ⏸️
- [ ] Test all 3 specializations in character creation
- [ ] Verify L13 specialization choice shows 2 options per subclass
- [ ] Verify L15/17/19 tier choices gated by keystone (HasPassive check)
- [ ] Test L20 capstone auto-grant based on L13 choice
- [ ] Verify Progressions.lsx integration (PassivesAdded references)

### **Phase 6: Gameplay Testing** ⏸️
- [ ] Mountain Thane: Test Lightning Strikes proc rate, Avatar synergy, Thunder Blast charges
- [ ] Colossus: Test Colossal Might stacking, Demolish damage scaling, stack consumption
- [ ] Slayer: Test Mark application, Execute scaling, crit range expansion
- [ ] Test alternative talent builds (non-recommended paths)
- [ ] Balance validation (damage numbers, proc rates, cooldowns)

---

## 📖 CROSS-REFERENCE WITH PROGRESSIONS.LSX

Each specialization keystone passive must match the Progressions.lsx entries:

### **Mountain Thane (Fury + Protection)**
**Progressions.lsx L13 SelectPassives**:
```xml
<node id="Passive">
  <attribute id="Tag" type="guid" value="WAR_MountainThane_Keystone"/>
  <attribute id="UUID" type="guid" value="[UUID from Progressions.lsx]"/>
</node>
```

**Passive_Warrior.txt Entry**:
```
new entry "WAR_MountainThane_Keystone"
type "PassiveData"
data "DisplayName" "h123abc01;1"
data "Description" "h123abc02;1"
...
```

### **Colossus (Arms + Protection)**
**Progressions.lsx L13 SelectPassives**:
```xml
<node id="Passive">
  <attribute id="Tag" type="guid" value="WAR_Colossus_Keystone"/>
  <attribute id="UUID" type="guid" value="[UUID from Progressions.lsx]"/>
</node>
```

**Passive_Warrior.txt Entry**:
```
new entry "WAR_Colossus_Keystone"
type "PassiveData"
data "DisplayName" "h124abc01;1"
data "Description" "h124abc02;1"
...
```

### **Slayer (Arms + Fury)**
**Progressions.lsx L13 SelectPassives**:
```xml
<node id="Passive">
  <attribute id="Tag" type="guid" value="WAR_Slayer_Keystone"/>
  <attribute id="UUID" type="guid" value="[UUID from Progressions.lsx]"/>
</node>
```

**Passive_Warrior.txt Entry**:
```
new entry "WAR_Slayer_Keystone"
type "PassiveData"
data "DisplayName" "h125abc01;1"
data "Description" "h125abc02;1"
...
```

**CRITICAL**: The `Tag` attribute in Progressions.lsx must EXACTLY match the passive entry name in Passive_Warrior.txt.

---

## 🎯 RECOMMENDED IMPLEMENTATION ORDER

1. **Start with Slayer** (simplest mechanics)
   - Only 3 statuses required
   - No new spell needed
   - Mark system is straightforward

2. **Then Mountain Thane** (medium complexity)
   - 6 statuses, mostly passive effects
   - Proc-based gameplay tests RNG systems
   - No new spell needed

3. **Finally Colossus** (most complex)
   - 7 statuses + 1 new spell (Demolish)
   - Stack management system
   - Stack consumption mechanics

4. **Test Each Specialization Independently**
   - Create test character at L13
   - Use console to grant abilities
   - Verify all talents work before moving to next spec

5. **Integration Test All Three**
   - Test specialization exclusivity (choosing one locks out others)
   - Verify multiclass behavior
   - Test respec scenarios

---

## 📝 NOTES FOR FUTURE REFERENCE

### **Placeholder Ability References**
Some passives reference abilities not yet implemented in base Warrior kit. Update these references once abilities are created:

- `WAR_Avatar` - Base class ultimate ability (placeholder status used: `SG_Polymorph_BeastShape_Behaviour`)
- `WAR_ThunderClap` - Base class AoE ability
- `WAR_Revenge` - Tank AoE ability
- `WAR_Execute` - Execute low-HP enemies
- `WAR_ShieldSlam` - Tank builder ability
- `WAR_Whirlwind` - AoE cleave ability
- `WAR_Shockwave` - AoE stun ability
- `WAR_DemoralizingShout` - Debuff ability
- `WAR_MortalStrike` - Arms signature ability
- `WAR_RagingBlow` - Fury signature ability
- `IgnorePain` - Damage absorption ability

### **ActionResource UUID**
All Rage generation/costs reference `ActionResource` which maps to the Rage resource defined in `ActionResourceDefinitions.lsx`:
```xml
<attribute id="UUID" type="guid" value="8fe271a3-3f3c-4170-8c6a-a6eb9b597894"/>
```

Use this UUID when implementing `RestoreResource` or `UseCosts` functors.

### **Icon Recommendations**
Reuse vanilla BG3 icons to avoid custom asset creation:
- Lightning theme: `PassiveFeature_Generic_Lightning`
- Damage boosts: `PassiveFeature_Generic_Damage`
- Defense: `PassiveFeature_Generic_Defense`
- Critical hits: `PassiveFeature_Generic_Critical`
- Control/CC: `PassiveFeature_Generic_Control`
- Dark/Execute theme: `PassiveFeature_Generic_Dark`

---

## ✅ VALIDATION AFTER IMPLEMENTATION

### **In-Game Checks**
1. **Character Creation**: All 3 subclasses show 2 specialization options at L13
2. **Tooltips**: All passives display correct names and descriptions
3. **Talent Trees**: L15/17/19 choices only show for chosen specialization
4. **Capstone**: L20 automatically grants correct capstone based on L13 choice
5. **Visuals**: Status icons display correctly, stack counts show properly
6. **Combat Log**: Damage numbers match expected calculations
7. **Proc Rates**: Lightning Strikes ~25%, Thunder Blast ~35%, Slayer Mark ~15%

### **Console Testing Commands**
```
# Grant specific specialization keystone
TemplateAddTo("S_Player_Shadowheart_3ed74f06-3c60-42dc-83f6-f034cb47c679", "WAR_MountainThane_Keystone")

# Apply status for testing
ApplyStatus("S_Player_Shadowheart_3ed74f06-3c60-42dc-83f6-f034cb47c679", "WAR_COLOSSAL_MIGHT", 100, 1)

# Check status stacks
GetStatus("S_Player_Shadowheart_3ed74f06-3c60-42dc-83f6-f034cb47c679", "WAR_COLOSSAL_MIGHT")

# Remove status
RemoveStatus("S_Player_Shadowheart_3ed74f06-3c60-42dc-83f6-f034cb47c679", "WAR_COLOSSAL_MIGHT")
```

---

## 🎨 EXAMPLE: FULL PASSIVE ENTRY

Here's a complete example showing all required fields:

```
new entry "WAR_MountainThane_LightningStrikes"
type "PassiveData"
data "DisplayName" "h123abc03;1"
data "Description" "h123abc04;1"
data "Icon" "PassiveFeature_Generic_Lightning"
data "Properties" "Highlighted"
data "StatsFunctorContext" "OnDamage"
data "Conditions" "HasPassive('WAR_MountainThane_Keystone',context.Source) and (HasStringInSpellRoll('Projectile(WAR_ThunderClap)') or HasStringInSpellRoll('Projectile(WAR_Revenge)') or HasStringInSpellRoll('Projectile(WAR_Execute)'))"
data "StatsFunctors" "IF(RandomCastOutcome(25,100)):DealDamage(1d10,Lightning,Magical);IF(HasStatus('WAR_AVATAR_OF_THE_STORM',context.Source) and RandomCastOutcome(7,100)):DealDamage(1d10,Lightning,Magical)"
data "PriorityOrder" "100"
```

**Corresponding Localization**:
```xml
<content contentuid="h123abc03" version="1">Lightning Strikes</content>
<content contentuid="h123abc04" version="1">Thunder Clap, Revenge, and Execute have a 25% chance to strike one enemy with a lightning bolt, dealing 1d10 Lightning damage. This chance increases to 32.5% while Avatar is active.</content>
```

---

**Document Status**: Complete  
**Ready For**: Stats file implementation (Status, Passive, Spell, Localization)  
**Next Step**: Create Status_Warrior.txt with 16 status definitions
