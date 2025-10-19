# Tag-Based Pool System Analysis for BG3Wow

**Date**: October 17, 2025  
**Purpose**: Determine if BG3 supports tag-based spell filtering for talent pools

---

## Understanding Your Vision

### **What You Want**:
A **tag-based system** where:
1. Every spell has **multiple tags** (e.g., `Offensive_Abilities`, `Baseline_Arms_Warrior_Abilities`)
2. Progression system **filters by tags** to show relevant choices
3. **Pools are dynamic** - defined by tags, not hardcoded lists
4. Same spell can appear in **multiple pools** (e.g., Whirlwind in Fury, Protection, AND Arms pools)

### **Example**:
```
Spell: Whirlwind
Tags: 
  - Offensive_Abilities
  - Baseline_Fury_Warrior_Abilities
  - Baseline_Protection_Warrior_Abilities  
  - Baseline_Arms_Warrior_Abilities
  - AoE_Ability
  - Rage_Spender

When Arms Warrior levels up:
  → System shows all spells tagged "Baseline_Arms_Warrior_Abilities"
  → Player picks one
  → That spell is removed from future choices (already learned)
```

---

## BG3 Engine Investigation

### **Question 1: Does BG3 support spell tags?**

#### **Investigation Results**:
❌ **NO** - BG3's `.txt` spell files do NOT have a native "Tags" field

**Evidence**:
- Grep search for "Tags", "SpellTags", "SpellCategory" in our spell files = 0 matches
- Standard BG3 spell format has no tag system visible in stat files

#### **Where Tags MIGHT Exist**:
1. **Passives** - BG3 uses "Tag" attribute in Progressions.lsx SelectPassives nodes
2. **ClassDescriptions** - May have internal categorization
3. **Hidden metadata** - Could be in compiled game files

---

### **Question 2: Can we use the "Tag" system in Progressions.lsx?**

#### **Current Usage** (from our hero talents):
```xml
<SelectPassives Amount="1">
    <Passive Tag="WAR_Colossus_Keystone"/>
    <Passive Tag="WAR_Slayer_Keystone"/>
</SelectPassives>
```

**How it works**:
- `Tag` attribute references a **passive name** from `Passive.txt`
- BG3 matches the Tag to find the passive entry
- Shows that passive as a choice option

#### **Can we adapt this for spells?**

**Possible Approaches**:

**Approach A: Tag-based Passive Wrappers** ✅ FEASIBLE
```
Every spell has a passive wrapper:
  
Passive: WAR_Pool_Whirlwind
  Tag: Baseline_Arms_Warrior_Abilities
  Tag: Baseline_Fury_Warrior_Abilities
  Tag: Offensive_Abilities
  Boosts: UnlockSpell(WAR_Whirlwind)
```

Then in Progressions.lsx:
```xml
<SelectPassives Amount="1" Tag="Baseline_Arms_Warrior_Abilities">
    <!-- BG3 shows all passives with this tag -->
</SelectPassives>
```

**Problem**: BG3's SelectPassives only accepts **ONE Tag per node**, not multiple tag filtering

**Approach B: Custom Filtering with Requirements** ✅ FEASIBLE (but tedious)
```xml
<SelectPassives Amount="1">
    <Passive Tag="WAR_Pool_Whirlwind" 
             Requirement="not:HasPassive('WAR_Pool_Whirlwind')"/>
    <Passive Tag="WAR_Pool_Charge" 
             Requirement="not:HasPassive('WAR_Pool_Charge')"/>
    <Passive Tag="WAR_Pool_Execute" 
             Requirement="not:HasPassive('WAR_Pool_Execute')"/>
    <!-- List ALL 20 baseline abilities -->
    <!-- BG3 hides already-learned ones via Requirement -->
</SelectPassives>
```

**Problem**: Must manually list every spell in every progression node (not tag-filtered)

**Approach C: Mega-List with Tag Metadata** ⚠️ HYBRID
```
Create one giant SelectPassives node with all abilities
Use passive names as pseudo-tags: WAR_Baseline_Arms_Whirlwind
Group by naming convention, but list all explicitly
```

---

## Critical Discovery: BG3 Limitations

### ❌ **What BG3 CANNOT Do**:
1. **Dynamic tag filtering** - Can't say "show all spells with Tag X"
2. **Multi-tag queries** - Can't say "show spells with Tag A AND Tag B"
3. **Tag inheritance** - Can't define tag hierarchies
4. **Tag-based SelectSpells** - SelectSpells doesn't support tag filtering at all

### ✅ **What BG3 CAN Do**:
1. **Explicit listing** - List every option in SelectPassives/SelectSpells nodes
2. **Requirement filtering** - Hide options based on conditions (e.g., "not:HasPassive(X)")
3. **Passive-based unlocks** - Passives can unlock spells via Boosts
4. **Tag attribute** - Can use "Tag" in passive definitions (for organization, not filtering)

---

## Recommended Implementation: Hybrid Tag System

### **System Architecture**:

#### **1. Spell Tagging (Organizational Only)**
Add comments to spell files for human readability:
```
// FILE: Spell_Zone.txt
// Tags: Offensive_Abilities, Baseline_Arms_Warrior_Abilities, AoE_Ability

new entry "Zone_WAR_Whirlwind"
type "SpellData"
// ... spell data ...
```

#### **2. Passive Wrappers for Each Pool Entry**
Create passives that unlock spells and serve as pool entries:

**FILE: Passive.txt**
```
// ========================================
// ARMS WARRIOR BASELINE POOL
// Category: Offensive Abilities
// ========================================

new entry "WAR_BaselineArms_Whirlwind"
type "PassiveData"
data "DisplayName" "h125abc300;1"  // "Whirlwind (Baseline)"
data "Description" "h125abc301;1"
data "Icon" "Action_Barbarian_Whirlwind"
data "Properties" "Highlighted"
data "Boosts" "UnlockSpell(Zone_WAR_Whirlwind)"

new entry "WAR_BaselineArms_Execute"
type "PassiveData"
data "DisplayName" "h125abc302;1"  // "Execute (Baseline)"
data "Description" "h125abc303;1"
data "Icon" "Action_Execute"
data "Properties" "Highlighted"
data "Boosts" "UnlockSpell(Target_WAR_Execute)"

new entry "WAR_BaselineArms_Charge"
type "PassiveData"
data "DisplayName" "h125abc304;1"  // "Charge (Baseline)"
data "Description" "h125abc305;1"
data "Icon" "Action_Dash"
data "Properties" "Highlighted"
data "Boosts" "UnlockSpell(Jump_WAR_Charge)"

// ... 17 more baseline abilities ...
```

#### **3. Progression Nodes with Explicit Lists**

**FILE: Progressions.lsx**
```xml
<!-- =====================================================
     ARMS BASELINE POOL - Offense + Utility Pick at L1
     ===================================================== -->

<Progression Level="1" TableUUID="[ARMS_UUID]">
    <!-- Pick 1 Offensive Ability -->
    <SelectPassives Amount="1" UUID="[UUID_OFFENSE]">
        <Passive Tag="WAR_BaselineArms_Whirlwind"/>
        <Passive Tag="WAR_BaselineArms_Execute"/>
        <Passive Tag="WAR_BaselineArms_MortalStrike"/>
        <Passive Tag="WAR_BaselineArms_Overpower"/>
        <Passive Tag="WAR_BaselineArms_ColossusSmash"/>
        <Passive Tag="WAR_BaselineArms_SweepingStrikes"/>
        <Passive Tag="WAR_BaselineArms_Warbreaker"/>
        <Passive Tag="WAR_BaselineArms_Slam"/>
        <Passive Tag="WAR_BaselineArms_Rend"/>
        <Passive Tag="WAR_BaselineArms_Bladestorm"/>
    </SelectPassives>
    
    <!-- Pick 1 Utility Ability -->
    <SelectPassives Amount="1" UUID="[UUID_UTILITY]">
        <Passive Tag="WAR_BaselineArms_Charge"/>
        <Passive Tag="WAR_BaselineArms_HeroicLeap"/>
        <Passive Tag="WAR_BaselineArms_Hamstring"/>
        <Passive Tag="WAR_BaselineArms_IntimidatingShout"/>
        <Passive Tag="WAR_BaselineArms_DefensiveStance"/>
        <Passive Tag="WAR_BaselineArms_SpellReflection"/>
        <Passive Tag="WAR_BaselineArms_RallyingCry"/>
        <Passive Tag="WAR_BaselineArms_DiebytheSword"/>
        <Passive Tag="WAR_BaselineArms_BattleShout"/>
        <Passive Tag="WAR_BaselineArms_Taunt"/>
    </SelectPassives>
</Progression>

<!-- =====================================================
     ARMS BASELINE POOL - Pick 1 per level L2-12
     ===================================================== -->

<Progression Level="2" TableUUID="[ARMS_UUID]">
    <SelectPassives Amount="1" 
                    Requirement="not:HasPassive('WAR_BaselineArms_Whirlwind');
                                 not:HasPassive('WAR_BaselineArms_Execute');
                                 not:HasPassive('WAR_BaselineArms_MortalStrike');
                                 not:HasPassive('WAR_BaselineArms_Overpower');
                                 not:HasPassive('WAR_BaselineArms_ColossusSmash');
                                 not:HasPassive('WAR_BaselineArms_SweepingStrikes');
                                 not:HasPassive('WAR_BaselineArms_Warbreaker');
                                 not:HasPassive('WAR_BaselineArms_Slam');
                                 not:HasPassive('WAR_BaselineArms_Rend');
                                 not:HasPassive('WAR_BaselineArms_Bladestorm');
                                 not:HasPassive('WAR_BaselineArms_Charge');
                                 not:HasPassive('WAR_BaselineArms_HeroicLeap');
                                 not:HasPassive('WAR_BaselineArms_Hamstring');
                                 not:HasPassive('WAR_BaselineArms_IntimidatingShout');
                                 not:HasPassive('WAR_BaselineArms_DefensiveStance');
                                 not:HasPassive('WAR_BaselineArms_SpellReflection');
                                 not:HasPassive('WAR_BaselineArms_RallyingCry');
                                 not:HasPassive('WAR_BaselineArms_DiebytheSword');
                                 not:HasPassive('WAR_BaselineArms_BattleShout');
                                 not:HasPassive('WAR_BaselineArms_Taunt')">
        <!-- List ALL 20 baseline passives again -->
        <Passive Tag="WAR_BaselineArms_Whirlwind"/>
        <Passive Tag="WAR_BaselineArms_Execute"/>
        <!-- ... all 20 ... -->
    </SelectPassives>
</Progression>

<!-- Repeat for L3, L4, L5... L12 -->
```

---

## Pros & Cons of This Approach

### ✅ **Pros**:
1. **Works within BG3 constraints** - No custom UI, no engine hacks
2. **Player sees choices** - Clear selection UI at level-up
3. **Depletion works** - Requirement filters hide learned abilities
4. **Cross-spec sharing** - Same spell in multiple pools (just list it in each)
5. **Organizational tags** - Can use comments for our own categorization

### ❌ **Cons**:
1. **Tedious to maintain** - Must list all 20 abilities at each level (L2-12)
2. **Verbose XML** - Progressions.lsx will be HUGE (~5000+ lines)
3. **Not truly dynamic** - Adding new ability = update 11 progression nodes
4. **Requirement hell** - Long requirement strings (20 "not:HasPassive" checks)
5. **No actual tags** - Tags are just in comments, not functional

---

## Alternative: Simplified List System

If the above is too complex, we could use **explicit lists per level**:

```xml
<!-- LEVEL 1: Pick 1 Offense + 1 Utility -->
<Progression Level="1">
    <SelectPassives Amount="1">
        <Passive Tag="WAR_OffenseChoice1_Execute"/>
        <Passive Tag="WAR_OffenseChoice2_MortalStrike"/>
        <Passive Tag="WAR_OffenseChoice3_Whirlwind"/>
    </SelectPassives>
    <SelectPassives Amount="1">
        <Passive Tag="WAR_UtilityChoice1_Charge"/>
        <Passive Tag="WAR_UtilityChoice2_Hamstring"/>
        <Passive Tag="WAR_UtilityChoice3_DefensiveStance"/>
    </SelectPassives>
</Progression>

<!-- LEVEL 2: Pick 1 from remaining 14 -->
<Progression Level="2">
    <SelectPassives Amount="1">
        <!-- List remaining 14, BG3 hides ones from L1 via Requirements -->
        <Passive Tag="WAR_OffenseChoice1_Execute" 
                 Requirement="not:HasPassive('WAR_OffenseChoice1_Execute')"/>
        <!-- ... -->
    </SelectPassives>
</Progression>
```

---

## Questions for You

### **Question 1: Tag Purpose**
Are tags meant to:
- **A**: Actually filter/query spells dynamically (BG3 can't do this)
- **B**: Organize for humans (we use comments)
- **C**: Track which pools a spell belongs to (we can use naming conventions)

### **Question 2: Cross-Spec Sharing**
If Whirlwind is in Arms, Fury, AND Protection pools, should:
- **A**: Learning it in Arms make it unavailable in Fury? (separate passive wrappers)
- **B**: Learning it in Arms make it available in Fury automatically? (shared passive)

### **Question 3: Pool Size**
How many abilities per baseline pool?
- **A**: 20+ (need passive wrapper for each)
- **B**: 10-15 (smaller, more manageable)
- **C**: 5-8 per level tier (curated choices)

---

## Recommendation

### **Immediate Action**:
1. **Accept BG3 limitation**: No true dynamic tag system
2. **Use passive wrappers**: One passive per pool entry
3. **Explicit listing**: List all options at each level
4. **Requirement filtering**: Hide already-learned options
5. **Naming convention as "tags"**: `WAR_BaselineArms_SpellName` (implies pool membership)

### **File Structure**:
```
Data/Public/.../Stats/Generated/Data/
├── Spell_Target.txt        ← Actual spells (no tags)
├── Spell_Zone.txt          ← Actual spells (no tags)
├── Passive.txt             ← Pool entry wrappers
│   ├── WAR_BaselineArms_Whirlwind (unlocks Zone_WAR_Whirlwind)
│   ├── WAR_BaselineArms_Execute (unlocks Target_WAR_Execute)
│   └── ... (20+ passives for baseline pool)
└── Progressions.lsx        ← Explicit lists with Requirements
```

---

## What This Means for Implementation Plan

### **Updated Approach**:
1. Keep spells as-is in Spell_*.txt files
2. Create ~60-80 passive wrappers (one per pool entry per spec)
3. Define pools via naming conventions (not true tags)
4. List all pool entries explicitly in Progressions.lsx
5. Use Requirements to filter already-learned

### **Estimated Effort Adjustment**:
- **Before**: 300 hours (assuming dynamic tags)
- **Now**: 250 hours (simpler - no tag system to build)
- **Savings**: 50 hours (but more tedious manual work)

---

## 📌 RETURN TO DECISIONS

Now that we understand BG3's limitations, the 5 decisions become:

1. **Decision 1 (SubclassBase)**: How many abilities in baseline pool?
   - A: 20+ abilities (comprehensive)
   - B: 10-15 abilities (manageable)
   - C: 5-8 abilities (minimal)

2. **Decision 2 (Hero Passives)**: Keep 5 or expand to 8?
3. **Decision 3 (Feats)**: Keep or remove?
4. **Decision 4 (Icons)**: Vanilla / Custom / WoW?
5. **Decision 5 (Testing)**: How thorough?

**Ready to answer these now?**
