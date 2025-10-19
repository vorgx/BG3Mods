# WoW-Style Talent Tree Implementation Plan (v2.0)

**Date**: October 17, 2025  
**Target**: Complete overhaul to match design document specification  
**Status**: 🟡 **PLANNING PHASE - AWAITING APPROVAL**  
**Estimated Effort**: 200-300 hours over 4-6 weeks

---

## 📋 Executive Summary

### **Goal**
Transform the current fixed linear progression into a full WoW-style talent tree system with:
- **Class Talents**: 10 rows of choices (9 player choices)
- **SubclassSpec Talents**: 10 rows of choices (9 player choices)
- **SubclassBase Talents**: Ability pool system (~18 player choices)
- **Specialization**: Full hero talent implementation (~12 player choices)
- **Total**: ~48 meaningful choices across 20 levels

### **Scope**
- ✅ Keep existing abilities/spells (46 abilities already implemented)
- ✅ Reorganize progression into talent tree structure
- ✅ Add choice mechanisms at specified levels
- ✅ Create UI/UX for talent selection (BG3 limitations apply)
- ✅ Rebalance for combinatorial interactions
- ✅ Comprehensive documentation overhaul
- ✅ Extensive testing (all talent combinations)

---

## 🎯 Phase Breakdown

### **Phase 1: Research & Design** (Week 1)
Understand constraints and create detailed specifications

### **Phase 2: Architecture** (Week 1-2)
Design BG3-compatible talent selection system

### **Phase 3: Implementation** (Week 2-4)
Build talent trees in Progressions.lsx

### **Phase 4: Testing & Balance** (Week 4-5)
Test all combinations and balance

### **Phase 5: Documentation** (Week 5-6)
Complete documentation overhaul

### **Phase 6: Release** (Week 6)
Package and release v2.0

---

# PHASE 1: RESEARCH & DESIGN (Week 1 - 40 hours)

## 1.1 BG3 Constraint Research (8 hours)

### **Critical Questions to Answer**:

#### **Q1: Can BG3 support row-based talent selection?**
- **Investigation**: Examine vanilla BG3 classes (Wizard subclasses, Warlock invocations)
- **Look for**: SelectPassives, SelectSpells with row/tier constraints
- **Files to study**: 
  - `Game/Public/Shared/ClassDescriptions/ClassDescriptions.lsx`
  - `Game/Public/SharedDev/Progressions/Progressions.lsx`
- **Expected finding**: BG3 supports "pick N from list" but may not support "pick from Row X at Level Y"
- **Workaround if needed**: Use level-gated SelectPassives with Requirement attributes

#### **Q2: Can we gate choices by previously selected talents?**
- **Investigation**: Check if Requirement attribute can reference other passives
- **Test case**: `Requirement="HasPassive('WAR_ClassTalent_Row1_ChoiceA')"`
- **Expected finding**: Should work (already using this for hero talents)
- **Critical for**: Ensuring players pick Row 1 before Row 2, etc.

#### **Q3: How many SelectPassives nodes can we have per level?**
- **Investigation**: Check vanilla classes for multiple selection nodes
- **Test case**: Can L3 have "Class Talents Row 2" + "SubclassSpec Row 2" simultaneously?
- **Expected finding**: Should work (Warlock picks invocations + spells at same level)
- **Critical for**: Running 4 parallel talent systems

#### **Q4: Can we create a "bucket pool" that depletes as chosen?**
- **Investigation**: Check if BG3 supports "pick from list, remove from future choices"
- **Test case**: Monk ki abilities, Warlock spell choices
- **Expected finding**: May need to manually exclude already-learned spells
- **Workaround if needed**: Use Requirement="not:HasPassive(X)" for each option

#### **Q5: UI/UX limitations?**
- **Investigation**: How does BG3 present multiple SelectPassives at one level?
- **Test case**: Level up screen with 4 simultaneous choices
- **Expected finding**: May show sequential dialogs (annoying but workable)
- **Workaround if needed**: Consolidate some choices to reduce UI friction

### **Deliverables**:
- ✅ `BG3_TALENT_SYSTEM_CONSTRAINTS.md` - Document all findings
- ✅ `TECHNICAL_FEASIBILITY_REPORT.md` - Can we do this? What are the limits?
- ✅ `WORKAROUNDS_CATALOG.md` - Solutions for any limitations found

---

## 1.2 Ability Categorization (12 hours)

### **Task**: Sort all 46 existing abilities into talent tree structure

#### **Step 1: Class Talents (Base Warrior)**
Review current base Warrior abilities and assign to 10 rows:

**Current Base Warrior Abilities** (13 total):
1. WAR_Charge (L1)
2. WAR_HeroicStrike (L1)
3. WAR_BattleShout (L2)
4. WAR_Execute (L3)
5. WAR_DefensiveStance (L6)
6. WAR_IntimidatingShout (L7)
7. WAR_HeroicLeap (L9)
8. WAR_RallyingCry (L10)
9. WAR_Hamstring (L14)
10. WAR_SpellReflection (L15)
11. WAR_DiebytheSword (L17)
12. Target_WAR_Indomitable (L18)
13. WAR_Avatar (L19)

**Proposed Class Talent Rows**:
```
Row 1 (L1 - Auto-granted):
- WAR_Charge (gap closer)
- WAR_HeroicStrike (basic Rage spender)

Row 2 (L3 - Pick 1):
Option A: WAR_BattleShout (party buff)
Option B: WAR_RallyingCry (party heal)
Option C: WAR_IntimidatingShout (AoE fear)

Row 3 (L5 - Pick 1):
Option A: WAR_Execute (finisher)
Option B: WAR_Hamstring (slow)
Option C: WAR_Rend (DoT - NEW ABILITY TO CREATE)

Row 4 (L7 - Pick 1):
Option A: WAR_DefensiveStance (defensive toggle)
Option B: WAR_ShieldBlock (block - NEW ABILITY TO CREATE)
Option C: WAR_BerserkerStance (offensive toggle - NEW)

Row 5 (L9 - Pick 1):
Option A: WAR_HeroicLeap (AoE gap closer)
Option B: WAR_Intervene (jump to ally - already exists!)
Option C: WAR_Charge_Improved (enhanced Charge - NEW)

Row 6 (L11 - Pick 1):
Option A: WAR_SpellReflection (reflect magic)
Option B: WAR_CommandingShout (max HP buff - NEW)
Option C: WAR_PiercingHowl (AoE slow - NEW)

Row 7 (L13 - Pick 1):
Option A: WAR_Avatar (ultimate form)
Option B: WAR_Bladestorm (spinning attack - NEW)
Option C: WAR_Recklessness (offense boost - NEW)

Row 8 (L15 - Pick 1):
Option A: WAR_DiebytheSword (parry)
Option B: Target_WAR_Indomitable (save advantage)
Option C: WAR_VictoryRush (heal on kill - NEW)

Row 9 (L17 - Pick 1):
Option A: WAR_ImpendingVictory (heal - NEW)
Option B: WAR_StormBolt (stun - NEW)
Option C: WAR_ShatteringThrow (armor break - NEW)

Row 10 (L19 - Pick 1):
Option A: WAR_Ravager (summon weapon - NEW)
Option B: WAR_Spear_of_Bastion (ranged execute - NEW)
Option C: WAR_Thunderous_Roar (AoE knockback - NEW)
```

**Analysis**:
- ✅ Current abilities: 13
- ❌ Need for 30 slots (10 rows × 3 options): **17 new abilities required**
- ⚠️ Some can be variants of existing (e.g., Improved Charge = Charge with bonus)

#### **Step 2: SubclassSpec Talents (Arms Warrior)**
Review current Arms abilities and assign to 10 rows:

**Current Arms Abilities** (5 total):
1. WAR_ARMS_WeaponMastery (L1 passive)
2. WAR_ARMS_MortalStrike (L3)
3. WAR_ARMS_Overpower (L3)
4. WAR_ARMS_TacticalMastery (L5 passive)
5. WAR_ARMS_ColossusSmash (L7)
6. WAR_ARMS_SweepingStrikes (L9)
7. WAR_ARMS_Warbreaker (L11)

**Proposed SubclassSpec Rows**:
```
Row 1 (L1 - Auto-granted):
- WAR_ARMS_WeaponMastery (passive: +1 atk/dmg 2H)
- WAR_ARMS_MortalStrike (signature strike)

Row 2 (L3 - Pick 1):
Option A: WAR_ARMS_Overpower (instant strike)
Option B: WAR_ARMS_Slam (heavy hit - NEW)
Option C: WAR_ARMS_Cleave (frontal cone - NEW)

Row 3 (L5 - Pick 1):
Option A: WAR_ARMS_TacticalMastery (tactical passive)
Option B: WAR_ARMS_SecondWind (self-heal - NEW)
Option C: WAR_ARMS_DefensiveStance_Arms (Arms version - NEW)

Row 4 (L7 - Pick 1):
Option A: WAR_ARMS_ColossusSmash (armor shred)
Option B: WAR_ARMS_Rend (bleed DoT - NEW)
Option C: WAR_ARMS_Bladestorm_Arms (Arms version - NEW)

Row 5 (L9 - Pick 1):
Option A: WAR_ARMS_SweepingStrikes (cleave buff)
Option B: WAR_ARMS_ThunderClap_Arms (AoE damage - NEW)
Option C: WAR_ARMS_Demoralizing_Shout (debuff - NEW)

Row 6 (L11 - Pick 1):
Option A: WAR_ARMS_Warbreaker (AoE finisher)
Option B: WAR_ARMS_DeadlyCalm (free abilities - NEW)
Option C: WAR_ARMS_WarMachine (cooldown reduction - NEW)

Row 7 (L13 - Pick 1):
Option A: WAR_ARMS_TestOfMight (burst window - NEW)
Option B: WAR_ARMS_Fervor (Rage generation - NEW)
Option C: WAR_ARMS_InDomain (control zone - NEW)

Row 8 (L15 - Pick 1):
Option A: WAR_ARMS_Massacre (Execute threshold - NEW)
Option B: WAR_ARMS_Ravager_Arms (summon - NEW)
Option C: WAR_ARMS_Avatar_Arms (ultimate - NEW)

Row 9 (L17 - Pick 1):
Option A: WAR_ARMS_AngerManagement (CDR - NEW)
Option B: WAR_ARMS_Collateral (multi-target - NEW)
Option C: WAR_ARMS_ImpaleExecute (improved Execute - NEW)

Row 10 (L19 - Pick 1):
Option A: WAR_ARMS_Executioners_Precision (mastery - NEW)
Option B: WAR_ARMS_StormOfSwords (multi-hit - NEW)
Option C: WAR_ARMS_JuggernautBuff (unstoppable - NEW)
```

**Analysis**:
- ✅ Current abilities: 7
- ❌ Need for 30 slots: **23 new Arms abilities required**

#### **Step 3: SubclassBase Talents (Ability Pool)**
Create bucket of baseline Arms abilities to pick from each level:

**Proposed SubclassBase Pool** (needs 20+ abilities):

**Offense Category** (~10 abilities):
1. WAR_ARMS_Execute_Base (if not in Class Talents)
2. WAR_ARMS_Slam
3. WAR_ARMS_Rend
4. WAR_ARMS_Cleave
5. WAR_ARMS_ThunderClap
6. WAR_ARMS_Bladestorm
7. WAR_ARMS_StormBolt
8. WAR_ARMS_Ravager
9. WAR_ARMS_ShatteringThrow
10. WAR_ARMS_ImpendingVictory

**Utility Category** (~10 abilities):
1. WAR_ARMS_HamstringArms
2. WAR_ARMS_Disarm
3. WAR_ARMS_PiercingHowl
4. WAR_ARMS_IntimidatingShout_Arms
5. WAR_ARMS_RallyingCry_Arms
6. WAR_ARMS_DefensiveStance_Arms
7. WAR_ARMS_SpellReflection_Arms
8. WAR_ARMS_BerserkerRage (remove CC)
9. WAR_ARMS_ShieldWall_Arms (even for 2H)
10. WAR_ARMS_VictoryRush_Arms

**Analysis**:
- ❌ Need: ~20 abilities for baseline pool
- ❌ Many overlap with Class/SubclassSpec rows
- ⚠️ **DESIGN DECISION NEEDED**: Should SubclassBase be:
  - **Option A**: Completely separate abilities (40+ NEW abilities total!)
  - **Option B**: Reuse Class/SubclassSpec abilities not chosen (complex tracking)
  - **Option C**: Simplified pool of "extra utilities" (10-15 new abilities)

#### **Step 4: Specialization (Hero Talents)**
**Current Status**: ✅ Already mostly implemented
- Colossus: 3 tiers + keystone + capstone = 5 elements
- Slayer: 3 tiers + keystone + capstone = 5 elements

**Design calls for**:
- Key Talent (L13) ✅ EXISTS
- Capstone (L13 per design, L20 in implementation) ⚠️ MOVE NEEDED
- Choice Node 1 (L15) ✅ EXISTS
- Choice Node 2 (L17) ✅ EXISTS
- Choice Node 3 (L19) ✅ EXISTS
- Passives pool (8 passives, 1 per level L13-20) ❌ MISSING

**Missing Passives** (need 8 per spec):

**Colossus Passives** (need 8 total):
1. Currently chosen tier passives (3) ✅
2. Keystone passive (1) ✅
3. Capstone (1) ✅
4. **Need 3 more passives** for L14/16/18

**Slayer Passives** (need 8 total):
1. Currently chosen tier passives (3) ✅
2. Keystone passive (1) ✅
3. Capstone (1) ✅
4. **Need 3 more passives** for L14/16/18

### **Deliverables**:
- ✅ `CLASS_TALENTS_DESIGN.md` - Complete 10-row structure with all 30 abilities
- ✅ `SUBCLASSSPEC_TALENTS_DESIGN.md` - Complete 10-row Arms structure with all 30 abilities
- ✅ `SUBCLASSBASE_POOL_DESIGN.md` - Pool of 20+ baseline abilities
- ✅ `SPECIALIZATION_ENHANCED_DESIGN.md` - Full hero talent system with 8 passives per spec
- ✅ `NEW_ABILITIES_REQUIRED.md` - Complete list of ~40-60 new abilities to create
- ✅ `DESIGN_DECISION_LOG.md` - Record of all design choices made

---

## 1.3 Progression Mapping (12 hours)

### **Task**: Map exactly what happens at each level 1-20

Create detailed level-by-level progression chart showing:
- Base Warrior progression
- Arms subclass progression
- When each talent system activates
- How many choices per level
- UI/UX flow for leveling up

**Example Format**:
```
LEVEL 1 (Character Creation):
├─ Base Warrior (Auto-grants):
│  ├─ Class Talents Row 1 (auto): Charge + Heroic Strike
│  ├─ Rage resource: 0-100
│  ├─ Proficiencies: All armor, shields, simple/martial weapons
│  └─ Saves: STR, CON
├─ Arms Subclass (chosen at creation):
│  ├─ SubclassSpec Row 1 (auto): Weapon Mastery + Mortal Strike
│  └─ SubclassBase Pick 1 Offense + Pick 1 Utility
└─ Player Choices: 2 skills, 2 ability points, 1 offense ability, 1 utility ability

LEVEL 2:
├─ SubclassBase: Pick 1 from pool (17 remaining)
└─ Player Choices: 1 ability from pool

LEVEL 3:
├─ Class Talents Row 2: Pick 1 of 3 (Battle Shout / Rallying Cry / Intimidating Shout)
├─ SubclassSpec Row 2: Pick 1 of 3 (Overpower / Slam / Cleave)
├─ SubclassBase: Pick 1 from pool (16 remaining)
└─ Player Choices: 3 total (1 class + 1 spec + 1 pool)

...and so on for all 20 levels
```

### **Deliverables**:
- ✅ `LEVEL_BY_LEVEL_PROGRESSION_CHART.md` - Complete L1-20 breakdown
- ✅ `PLAYER_CHOICE_FLOW_DIAGRAM.md` - Visual flowchart of choice points
- ✅ `UI_UX_MOCKUPS.md` - Mockups of level-up screens

---

## 1.4 Balance Framework (8 hours)

### **Task**: Create balancing guidelines for ~48 choices

#### **Key Questions**:
1. **Power Budget**: How much power per talent?
2. **Mandatory vs Optional**: Should some talents be clearly best?
3. **Synergies**: Which talents combo well? (combinatorial explosion!)
4. **Anti-Synergies**: Which talents conflict? (can't pick both)
5. **Rage Economy**: How does each talent affect Rage generation/spending?
6. **Action Economy**: How many bonus actions/reactions per build?
7. **Cooldown Management**: How many long/short rest abilities?

#### **Balancing Constraints**:
- **Total DPS**: Arms should match BG3 Fighter/Paladin DPS (~60-80 per round)
- **Total Defense**: Should match BG3 Fighter AC/HP (~18-20 AC, 120-140 HP at L20)
- **Resource Management**: Rage system should feel impactful but not punishing
- **Build Diversity**: Multiple viable builds (not one "correct" path)

### **Deliverables**:
- ✅ `BALANCE_FRAMEWORK.md` - Guidelines for talent power levels
- ✅ `SYNERGY_MATRIX.md` - Which talents work well together
- ✅ `ANTI_SYNERGY_LIST.md` - Which talents conflict
- ✅ `POWER_BUDGET_CALCULATOR.md` - Math for balancing abilities

---

# PHASE 2: ARCHITECTURE (Week 1-2 - 60 hours)

## 2.1 Progressions.lsx Structure Design (20 hours)

### **Task**: Design new Progressions.lsx architecture

#### **Current Structure** (simplified):
```xml
<!-- Base Warrior: 20 fixed levels -->
<Progression Level="1"> ... auto-grant abilities ... </Progression>
<Progression Level="2"> ... auto-grant abilities ... </Progression>
...

<!-- Arms: 11 fixed levels -->
<Progression Level="1"> ... auto-grant abilities ... </Progression>
<Progression Level="3"> ... auto-grant abilities ... </Progression>
...
```

#### **New Structure** (with talent trees):
```xml
<!-- =====================================================
     BASE WARRIOR CLASS TALENTS (10 Rows)
     ===================================================== -->

<!-- LEVEL 1: Auto-grant Row 1 -->
<Progression Level="1" TableUUID="[BASE_WARRIOR_UUID]">
    <AddSpells>WAR_Charge;WAR_HeroicStrike</AddSpells>
    <PassivesAdded>WAR_RageGeneration</PassivesAdded>
</Progression>

<!-- LEVEL 3: Row 2 Choice -->
<Progression Level="3" TableUUID="[BASE_WARRIOR_UUID]">
    <SelectPassives Amount="1">
        <Passive Tag="WAR_ClassTalent_Row2_BattleShout"/>
        <Passive Tag="WAR_ClassTalent_Row2_RallyingCry"/>
        <Passive Tag="WAR_ClassTalent_Row2_IntimidatingShout"/>
    </SelectPassives>
</Progression>

<!-- =====================================================
     ARMS SUBCLASS SPEC TALENTS (10 Rows)
     ===================================================== -->

<!-- LEVEL 1: Auto-grant Row 1 -->
<Progression Level="1" TableUUID="[ARMS_UUID]">
    <PassivesAdded>WAR_ARMS_WeaponMastery</PassivesAdded>
    <AddSpells>WAR_ARMS_MortalStrike</AddSpells>
</Progression>

<!-- LEVEL 3: Row 2 Choice -->
<Progression Level="3" TableUUID="[ARMS_UUID]">
    <SelectPassives Amount="1">
        <Passive Tag="WAR_ARMS_SpecTalent_Row2_Overpower"/>
        <Passive Tag="WAR_ARMS_SpecTalent_Row2_Slam"/>
        <Passive Tag="WAR_ARMS_SpecTalent_Row2_Cleave"/>
    </SelectPassives>
</Progression>

<!-- =====================================================
     ARMS SUBCLASS BASE TALENTS (Bucket Pool)
     ===================================================== -->

<!-- LEVEL 1: Pick 1 Offense + 1 Utility -->
<Progression Level="1" TableUUID="[ARMS_UUID]">
    <!-- Offense Choice -->
    <SelectPassives Amount="1" UUID="[UUID_OFFENSE]">
        <Passive Tag="WAR_ARMS_Base_Execute"/>
        <Passive Tag="WAR_ARMS_Base_Slam"/>
        <Passive Tag="WAR_ARMS_Base_Rend"/>
        ... [10 total offense options]
    </SelectPassives>
    
    <!-- Utility Choice -->
    <SelectPassives Amount="1" UUID="[UUID_UTILITY]">
        <Passive Tag="WAR_ARMS_Base_Hamstring"/>
        <Passive Tag="WAR_ARMS_Base_Disarm"/>
        <Passive Tag="WAR_ARMS_Base_SpellReflect"/>
        ... [10 total utility options]
    </SelectPassives>
</Progression>

<!-- LEVELS 2-20: Pick 1 from combined pool -->
<Progression Level="2" TableUUID="[ARMS_UUID]">
    <SelectPassives Amount="1" 
                    Requirement="not:HasPassive('WAR_ARMS_Base_Execute');
                                 not:HasPassive('WAR_ARMS_Base_Slam');
                                 ... [exclude already learned]">
        <!-- All 20 options listed, game will hide already-learned -->
        <Passive Tag="WAR_ARMS_Base_Execute"/>
        <Passive Tag="WAR_ARMS_Base_Slam"/>
        ... [all 20 base abilities]
    </SelectPassives>
</Progression>

<!-- =====================================================
     SPECIALIZATION (Hero Talents)
     ===================================================== -->

<!-- LEVEL 13: Keystone + Capstone + Passive #1 -->
<Progression Level="13" TableUUID="[ARMS_UUID]">
    <!-- Choose specialization -->
    <SelectPassives Amount="1">
        <Passive Tag="WAR_Colossus_Keystone"/>
        <Passive Tag="WAR_Slayer_Keystone"/>
    </SelectPassives>
    
    <!-- Auto-grant capstone based on choice -->
    <PassivesAdded>
        IF(HasPassive('WAR_Colossus_Keystone')):ApplyStatus(SELF,WAR_Colossus_Capstone);
        IF(HasPassive('WAR_Slayer_Keystone')):ApplyStatus(SELF,WAR_Slayer_Capstone)
    </PassivesAdded>
    
    <!-- Pick passive #1 from spec pool -->
    <SelectPassives Amount="1" Requirement="HasPassive('WAR_Colossus_Keystone')">
        <Passive Tag="WAR_Colossus_Passive1"/>
        <Passive Tag="WAR_Colossus_Passive2"/>
        ... [all Colossus passives not in choice nodes]
    </SelectPassives>
    
    <SelectPassives Amount="1" Requirement="HasPassive('WAR_Slayer_Keystone')">
        <Passive Tag="WAR_Slayer_Passive1"/>
        <Passive Tag="WAR_Slayer_Passive2"/>
        ... [all Slayer passives not in choice nodes]
    </SelectPassives>
</Progression>

<!-- LEVEL 14: Passive #2 -->
<Progression Level="14" TableUUID="[ARMS_UUID]">
    <SelectPassives Amount="1" Requirement="HasPassive('WAR_Colossus_Keystone')">
        ... [remaining Colossus passives]
    </SelectPassives>
    <SelectPassives Amount="1" Requirement="HasPassive('WAR_Slayer_Keystone')">
        ... [remaining Slayer passives]
    </SelectPassives>
</Progression>

<!-- LEVEL 15: Choice Node 1 + Passive #3 -->
<Progression Level="15" TableUUID="[ARMS_UUID]">
    <!-- Choice Node 1 (already exists) -->
    <SelectPassives Amount="1" Requirement="HasPassive('WAR_Colossus_Keystone')">
        <Passive Tag="WAR_Colossus_NoStrangerToPain"/>
        <Passive Tag="WAR_Colossus_VeteranVitality"/>
        <Passive Tag="WAR_Colossus_OneAgainstMany"/>
    </SelectPassives>
    
    <!-- Passive #3 from pool -->
    <SelectPassives Amount="1" Requirement="HasPassive('WAR_Colossus_Keystone')">
        ... [remaining Colossus passives, exclude already picked]
    </SelectPassives>
    
    <!-- Same for Slayer -->
</Progression>

... [continue pattern for L16-20]
```

### **Challenges to Solve**:
1. **Multiple SelectPassives per level**: Can BG3 handle 3-4 choices at once?
2. **Exclusion logic**: How to hide already-learned abilities from pool?
3. **Requirement chaining**: Can we require "pick Row 1 before Row 2"?
4. **UUID management**: Need ~200+ unique UUIDs for all nodes

### **Deliverables**:
- ✅ `PROGRESSIONS_ARCHITECTURE_v2.xml` - Template structure
- ✅ `UUID_NAMESPACE_PLAN.md` - UUID allocation strategy
- ✅ `REQUIREMENT_LOGIC_GUIDE.md` - How to implement exclusions
- ✅ `BG3_LIMITATIONS_WORKAROUNDS.md` - Solutions for engine limits

---

## 2.2 Spell/Passive Creation Templates (20 hours)

### **Task**: Create templates for ~40-60 new abilities

#### **Categories**:
1. **Active Abilities** (spells in Spell_*.txt)
2. **Passive Abilities** (entries in Passive.txt)
3. **Status Effects** (entries in Status_BOOST.txt)
4. **Localization** (handles in English.loca.xml)

#### **Template Structure**:

**Active Ability Template**:
```
new entry "Target_WAR_[ABILITY_NAME]"
type "SpellData"
data "SpellType" "Target"
data "Level" "0"
data "SpellSchool" "None"
data "TargetRadius" "1.5"
data "TargetConditions" "[CONDITIONS]"
data "SpellAnimation" "dd086f95-951e-464b-bc56-86be80f8baa5"
data "SpellAnimationType" "Melee"
data "SpellFlags" "IsAttack;IsHarmful;IsSpell"
data "UseCosts" "ActionPoint:1;Rage:[COST]"
data "SpellSuccess" "[EFFECTS]"
data "SpellFail" "[FAIL_EFFECTS]"
data "TooltipAttackSave" "[SAVE_TYPE]"
data "TooltipDamageList" "[DAMAGE_FORMULA]"
data "TooltipStatusApply" "[STATUSES]"
data "PrepareEffect" "[PREPARE_VFX]"
data "CastEffect" "[CAST_VFX]"
data "TargetEffect" "[TARGET_VFX]"
data "Cooldown" "[COOLDOWN]"
data "DisplayName" "h[HANDLE];1"
data "Description" "h[HANDLE+1];1"
data "ExtraDescription" "h[HANDLE+2];1"
data "Icon" "[ICON_PATH]"

[NOTES]:
- [ABILITY_NAME]: CamelCase name (e.g., "Slam", "ThunderClap")
- [CONDITIONS]: Target requirements (e.g., "Character() and not Dead()")
- [COST]: Rage cost (0-100, typically 10-40)
- [EFFECTS]: Game actions (DealDamage, ApplyStatus, etc.)
- [COOLDOWN]: "OncePerTurn", "OncePerShortRest", "OncePerRest"
```

**Passive Ability Template**:
```
new entry "WAR_[CATEGORY]_[PASSIVE_NAME]"
type "PassiveData"
data "DisplayName" "h[HANDLE];1"
data "Description" "h[HANDLE+1];1"
data "Icon" "[ICON_PATH]"
data "Properties" "Highlighted"
data "BoostContext" "[CONTEXT]"
data "Boosts" "[BOOST_STRING]"
data "StatsFunctorContext" "[FUNCTOR_CONTEXT]"
data "StatsFunctors" "[FUNCTORS]"
data "Conditions" "[CONDITIONS]"

[NOTES]:
- [CATEGORY]: "ClassTalent", "SpecTalent", "Base", "Colossus", "Slayer"
- [PASSIVE_NAME]: Descriptive name
- [CONTEXT]: When passive applies (OnCreate, OnAttack, OnCast, etc.)
- [BOOST_STRING]: Stat modifications (ActionResource, Proficiency, etc.)
- [FUNCTORS]: Triggered effects
```

### **Deliverables**:
- ✅ `ABILITY_TEMPLATE_LIBRARY.md` - All templates with examples
- ✅ `NAMING_CONVENTIONS_v2.md` - Updated naming for new structure
- ✅ `ICON_ASSET_REQUIREMENTS.md` - List of icons needed
- ✅ `VFX_REQUIREMENTS.md` - Visual effects catalog

---

## 2.3 Localization System Design (10 hours)

### **Task**: Plan localization for ~40-60 new abilities

#### **Current Handle Range**: h125abc001 - h125abc178
#### **Needed Handles**: ~180 new handles (3 per ability: name, description, extra)

**Handle Allocation Plan**:
```
h125abc179-h125abc238: Class Talent Row 2 abilities (20 handles)
h125abc239-h125abc298: Class Talent Row 3 abilities (20 handles)
...
h125abc999: Last available handle in h125abc series
Next series: h125abd000-h125abd999 (if needed)
```

### **Deliverables**:
- ✅ `LOCALIZATION_HANDLE_ALLOCATION.md` - Complete handle assignment
- ✅ `LOCALIZATION_TEMPLATE.xml` - Template for English.loca.xml
- ✅ `ABILITY_DESCRIPTIONS_GUIDE.md` - Writing style guide

---

## 2.4 Testing Framework Design (10 hours)

### **Task**: Plan how to test ~48 choices and combinations

#### **Testing Challenges**:
- **Combinatorial Explosion**: 3^19 (≈1.6 billion) possible combinations!
- **Critical Path Testing**: Test all single-path progressions
- **Synergy Testing**: Test known talent combos
- **Edge Case Testing**: Test conflicting talents, impossible combinations

#### **Testing Strategy**:
1. **Unit Tests** (per ability):
   - Does ability cast correctly?
   - Does Rage cost deduct?
   - Does cooldown work?
   - Does damage/effect apply?

2. **Integration Tests** (talent interactions):
   - Do Row 1 + Row 2 talents work together?
   - Do Class + SubclassSpec talents interact correctly?
   - Does SubclassBase pool deplete correctly?
   - Do Specialization passives stack?

3. **Balance Tests** (builds):
   - Test 5-10 "archetype builds" (tank, DPS, hybrid)
   - Compare DPS to vanilla Fighter
   - Compare survivability to vanilla Fighter
   - Test Rage economy across full combat

4. **UI/UX Tests**:
   - Does level-up screen show all choices?
   - Can player select talents in correct order?
   - Do tooltips display correctly?
   - Does respec work? (if supported)

### **Deliverables**:
- ✅ `TESTING_STRATEGY.md` - Complete testing plan
- ✅ `TEST_BUILDS_CATALOG.md` - 10 archetype builds to test
- ✅ `TESTING_CHECKLIST.md` - Checklist for each ability/talent
- ✅ `BUG_TRACKING_TEMPLATE.md` - Issue tracking format

---

# PHASE 3: IMPLEMENTATION (Week 2-4 - 80 hours)

## 3.1 Create New Abilities (40 hours)

### **Task**: Implement ~40-60 new abilities

**Priority Order**:
1. **Class Talent Rows 2-10** (24 abilities) - Highest priority
2. **SubclassSpec Rows 2-10** (24 abilities) - High priority
3. **SubclassBase Pool** (20 abilities) - Medium priority (reuse some from rows)
4. **Specialization Passives** (6 abilities, 3 per spec) - Low priority (simple passives)

**Weekly Breakdown**:
- **Week 2**: Class Talent abilities (24) + localization
- **Week 3**: SubclassSpec abilities (24) + localization
- **Week 4**: SubclassBase pool (20) + Spec passives (6) + localization

### **Per-Ability Checklist**:
- [ ] Create spell entry in appropriate Spell_*.txt file
- [ ] Create status effect in Status_BOOST.txt (if needed)
- [ ] Create passive entry in Passive.txt (if passive)
- [ ] Add 3 localization handles (name, desc, extra)
- [ ] Test ability in-game
- [ ] Document ability in ability catalog

### **Deliverables**:
- ✅ Updated `Spell_Target.txt` (+ ~20 new abilities)
- ✅ Updated `Spell_Shout.txt` (+ ~10 new abilities)
- ✅ Updated `Spell_Zone.txt` (+ ~10 new abilities)
- ✅ Updated `Status_BOOST.txt` (+ ~30 new statuses)
- ✅ Updated `Passive.txt` (+ ~40 new passives)
- ✅ Updated `English.loca.xml` (+ ~180 new handles)
- ✅ `NEW_ABILITIES_CATALOG.md` - Complete documentation

---

## 3.2 Rebuild Progressions.lsx (30 hours)

### **Task**: Completely rewrite progression tables

**Steps**:
1. Backup current Progressions.lsx
2. Create new structure with 4 parallel talent systems
3. Implement Class Talent rows (10 rows × 20 levels)
4. Implement SubclassSpec rows (10 rows × 20 levels)
5. Implement SubclassBase pool (20 levels × 1 pick)
6. Enhance Specialization system (8 levels × 1 passive)
7. Test level-up flow for all 20 levels

### **Deliverables**:
- ✅ `Progressions_v2.lsx` - New progression table
- ✅ `Progressions_v1_BACKUP.lsx` - Backup of current system
- ✅ `PROGRESSION_DIFF.md` - What changed from v1 to v2

---

## 3.3 Integration & Bug Fixing (10 hours)

### **Task**: Fix all integration issues

**Expected Issues**:
- Missing UUID references
- Duplicate localization handles
- Circular requirement dependencies
- UI/UX choking on too many choices per level
- Passive stack interactions
- Rage economy imbalances

### **Deliverables**:
- ✅ Bug-free build that packages successfully
- ✅ `INTEGRATION_ISSUES_LOG.md` - All bugs found and fixed

---

# PHASE 4: TESTING & BALANCE (Week 4-5 - 60 hours)

## 4.1 Unit Testing (20 hours)

### **Task**: Test every single ability

**Per-Ability Test**:
- [ ] Cast ability (does it work?)
- [ ] Verify Rage cost
- [ ] Verify cooldown
- [ ] Verify damage/healing/effects
- [ ] Verify VFX/SFX
- [ ] Verify tooltip text

**Testing Tools**:
- In-game testing (create L20 character, use mods to grant all abilities)
- Script Extender console (spawn enemies, test combos)
- Save file editing (test at various levels)

### **Deliverables**:
- ✅ `UNIT_TEST_RESULTS.md` - Pass/fail for all 46+ old + 40+ new = 86+ abilities

---

## 4.2 Integration Testing (20 hours)

### **Task**: Test talent combinations

**Test Scenarios**:
1. **Linear Path Test**: Pick Row 1 → Row 2 → Row 3... for all rows
2. **Mixed Path Test**: Pick different options across rows
3. **Specialization Test**: Colossus build with various Class/Spec talents
4. **Pool Depletion Test**: Verify SubclassBase pool works correctly
5. **Conflict Test**: Try to break system with impossible combinations

### **Deliverables**:
- ✅ `INTEGRATION_TEST_RESULTS.md` - Pass/fail for major combinations

---

## 4.3 Balance Testing (20 hours)

### **Task**: Balance builds against vanilla BG3

**Test Builds**:
1. **Tank Build**: Defensive Class talents + Colossus spec
2. **DPS Build**: Offensive Class talents + Slayer spec
3. **Hybrid Build**: Mixed talents + either spec
4. **Execute Build**: Execute-focused talents + Slayer
5. **AoE Build**: Cleave talents + Colossus
6. **Control Build**: CC talents + utility pool

**Balance Metrics**:
- DPS vs. Fighter (should be within 10%)
- Survivability vs. Fighter (AC, HP, damage reduction)
- Rage economy (should feel impactful, not punishing)
- Fun factor (subjective but important!)

### **Deliverables**:
- ✅ `BALANCE_TEST_RESULTS.md` - DPS/survivability comparisons
- ✅ `BALANCE_ADJUSTMENTS_LOG.md` - What was tweaked and why

---

# PHASE 5: DOCUMENTATION (Week 5-6 - 40 hours)

## 5.1 Update All Design Documents (15 hours)

### **Task**: Make documentation match reality

**Documents to Update**:
- `Warrior_Class_Blueprint.md` - Add all new abilities
- `Talets mechanics.md` - Mark as "IMPLEMENTED"
- `ARMS_WARRIOR_FULL_PROGRESSION.md` - Complete rewrite
- `WOW_SOURCE_IMPLEMENTATION_STATUS.md` - Update completion %
- All passive documentation files

### **Deliverables**:
- ✅ All design docs updated and accurate

---

## 5.2 Create Player Guides (15 hours)

### **Task**: Write guides for players

**Guides Needed**:
1. **Talent Tree Guide**: How the system works
2. **Build Guide**: Recommended talent paths
3. **Leveling Guide**: What to pick at each level
4. **FAQ**: Common questions
5. **Changelog**: What's new in v2.0

### **Deliverables**:
- ✅ `TALENT_TREE_GUIDE.md` - System explanation
- ✅ `BUILD_GUIDE.md` - Recommended builds
- ✅ `LEVELING_GUIDE.md` - Level-by-level recommendations
- ✅ `FAQ_v2.md` - Frequently asked questions
- ✅ `CHANGELOG_v2.0.md` - Complete changelog

---

## 5.3 Create Developer Documentation (10 hours)

### **Task**: Document for future maintainers

**Documentation Needed**:
1. **Architecture Document**: How the system works
2. **Adding New Abilities**: How to add more talents
3. **Modifying Progressions**: How to tweak level grants
4. **Balancing Guide**: How to balance new additions

### **Deliverables**:
- ✅ `ARCHITECTURE_v2.md` - System architecture
- ✅ `ADDING_TALENTS_GUIDE.md` - How to add new talents
- ✅ `MODIFYING_PROGRESSIONS_GUIDE.md` - How to tweak progression
- ✅ `BALANCING_GUIDE.md` - Balancing methodology

---

# PHASE 6: RELEASE (Week 6 - 20 hours)

## 6.1 Packaging & Validation (8 hours)

### **Task**: Package v2.0 and validate

**Steps**:
1. Run pre-package validation checklist
2. Package with LSLib
3. Test package installs correctly
4. Test full playthrough (L1-20)
5. Generate release notes

### **Deliverables**:
- ✅ `BG3Wow_v2.0.0.pak` - Release package
- ✅ `RELEASE_NOTES_v2.0.md` - What's new

---

## 6.2 Community Release (12 hours)

### **Task**: Release to community

**Steps**:
1. Upload to Nexus Mods (if applicable)
2. Create release announcement
3. Update README.md
4. Tag GitHub release
5. Monitor for critical bugs

### **Deliverables**:
- ✅ Public release of v2.0
- ✅ Community announcement
- ✅ Bug tracking for post-release issues

---

# CRITICAL DECISIONS NEEDED (BEFORE STARTING)

## Decision 1: SubclassBase Talents - What's in the pool?

**Options**:
- **A**: Separate 20+ abilities (40+ NEW abilities total!)
- **B**: Reuse Class/SubclassSpec talents not chosen (complex tracking)
- **C**: Simplified pool of 10-15 utility abilities (easier to implement)

**Recommendation**: **Option C** - Simplified pool
**Reason**: Balancing 60+ new abilities is too much for v2.0

---

## Decision 2: Hero Talent Passives - How many?

**Design says**: 8 passives per spec (1 per level L13-20)
**Currently have**: 5 elements per spec (keystone + 3 choices + capstone)

**Options**:
- **A**: Create 6 new passives (3 per spec) for L14/16/18/20
- **B**: Keep current 5-element system (simpler)

**Recommendation**: **Option A** - Create 6 new passives
**Reason**: Design specifically calls for 8, and 6 simple passives is manageable

---

## Decision 3: Feats - Keep or remove?

**Current**: 5 feat choices at L4/8/12/16/20
**Design**: Doesn't mention feats

**Options**:
- **A**: Keep feats (more choice, familiar to BG3 players)
- **B**: Remove feats (more faithful to WoW design)

**Recommendation**: **Option A** - Keep feats
**Reason**: Feats are a core BG3 mechanic, removing them would feel bad

---

## Decision 4: Icons - Use vanilla or create custom?

**Need**: ~60+ icons for new abilities

**Options**:
- **A**: Reuse vanilla BG3 icons (free, fast, may not match thematically)
- **B**: Create custom icons (expensive, time-consuming, perfect fit)
- **C**: Use WoW ability icons (free, perfect theme, may have copyright issues)

**Recommendation**: **Option A** initially, **Option C** if safe
**Reason**: Functionality first, polish later

---

## Decision 5: Testing - How thorough?

**Options**:
- **A**: Test every combination (impossible - 1.6 billion combos)
- **B**: Test 10 archetype builds thoroughly
- **C**: Test critical path only (all rows sequentially)

**Recommendation**: **Option B** - 10 archetype builds
**Reason**: Balances coverage with feasibility

---

# ESTIMATED TOTALS

## Time Investment:
- **Phase 1 (Research)**: 40 hours
- **Phase 2 (Architecture)**: 60 hours
- **Phase 3 (Implementation)**: 80 hours
- **Phase 4 (Testing)**: 60 hours
- **Phase 5 (Documentation)**: 40 hours
- **Phase 6 (Release)**: 20 hours
- **Total**: **300 hours** (~7.5 weeks full-time, or 3 months part-time)

## New Content:
- **New Abilities**: 40-60
- **New Passives**: 40+
- **New Status Effects**: 30+
- **Localization Handles**: 180+
- **New Documentation**: 30+ files

## Risk Assessment:
- **High Risk**: BG3 may not support 4 parallel talent systems
- **Medium Risk**: Balancing 60+ new abilities
- **Medium Risk**: UI/UX may choke on multiple choices per level
- **Low Risk**: Implementation (we know how to code abilities)

---

# APPROVAL CHECKLIST

Before proceeding to Phase 1, confirm:

- [ ] **Decision 1**: SubclassBase pool approach (A/B/C)
- [ ] **Decision 2**: Hero talent passive count (5 or 8)
- [ ] **Decision 3**: Keep or remove feats
- [ ] **Decision 4**: Icon strategy (vanilla/custom/WoW)
- [ ] **Decision 5**: Testing thoroughness (A/B/C)
- [ ] **Time commitment**: Can dedicate 300 hours over 6-12 weeks
- [ ] **Scope acceptance**: Understand this is a major overhaul
- [ ] **Risk acceptance**: BG3 engine may have hard limits we hit
- [ ] **Rollback plan**: Keep v1.0 as fallback if v2.0 fails

---

**STATUS**: 🟡 **AWAITING YOUR APPROVAL TO PROCEED**

**Next Steps**: Review this plan, make decisions 1-5, then I'll begin Phase 1 research.
