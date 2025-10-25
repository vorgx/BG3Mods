# FILE 11: Progressions.lsx Transformation Plan

**Date**: October 24, 2025  
**Status**: Planning Phase  
**Complexity**: ⭐⭐⭐⭐⭐ HIGHEST (Most complex file in entire mod)

---

## Overview

**Purpose**: Define level-by-level ability grants for Warrior class (L1-20) + 3 subclasses  
**Source**: `Documentation/00_SourcesOfTruth/Warrior Progression LINKED - Main.csv` (260 ability slots, validated Oct 23-24)  
**Template**: Warlock Progressions.lsx (L1-12 only, needs extension to L13-20)

---

## Current State

### Warlock Template (L1-12):
- **Base class**: 12 level progressions
- **Multiclass**: 1 variant
- **Subclasses**: 3 subclasses (Affliction, Demonology, Destruction) with L1-10 progressions each
- **Total entries**: ~50 Progression nodes
- **Uses talent rows**: SelectPassives(UUID, count, RowName) pattern

### Warrior Target (L1-20):
- **Base class**: 20 level progressions (EXTEND from 12 to 20)
- **Subclasses**: 3 subclasses (Arms, Fury, Protection) with full L1-20 progressions
- **Hero talents**: L13-20 (Mountain Thane, Colossus, Slayer) - hardcoded passives
- **Total entries**: ~80 Progression nodes
- **260 ability slots** validated in Section [6]

---

## Transformation Strategy

### Phase 1: Base Class (L1-12) Transformation
**Approach**: Replace Warlock spell/passive references with Warrior equivalents

**Changes per level**:
1. **Level 1**:
   - `Boosts`: Change armor proficiency (Light → Heavy/Medium)
   - `Boosts`: Change saving throws (Wisdom/Charisma → Strength/Constitution)
   - `PassivesAdded`: Replace Warlock passives with WAR_* passives
   - `Selectors`: Replace AddSpells UUID (Warlock spells → Warrior spells)
   - `Selectors`: Replace SelectPassives UUIDs (talent rows)

2. **Levels 2-12**: Same pattern
   - Update `PassivesAdded` with WAR_* passives from LINKED CSV
   - Update `AddSpells` UUIDs (will need SpellList creation in FILE 12)
   - Update `SelectPassives` UUIDs (talent choice rows)

**Question**: Do we keep talent rows (SelectPassives) or hardcode abilities?
- **Option A**: Keep talent rows (requires PassiveLists.lsx creation)
- **Option B**: Hardcode passives (PassivesAdded="WAR_Passive1;WAR_Passive2") - SIMPLER

**Recommendation**: **Option B** (hardcode) for initial version - talent rows add complexity

### Phase 2: Extend L13-20
**Approach**: Add 8 new Progression nodes for L13-20

**Hero Talent Integration**:
- **L13**: Keystone passive (one of: WAR_Mountain_Thane_Keystone, WAR_Colossus_Keystone, WAR_Slayer_Keystone)
- **L15/L17/L19/L20**: Choice nodes (2-3 hero talent passives per tier)

**Implementation**:
```xml
<node id="Progression">
    <attribute id="Level" type="uint8" value="13"/>
    <attribute id="Name" type="LSString" value="Warrior"/>
    <attribute id="ProgressionType" type="uint8" value="0"/>
    <attribute id="PassivesAdded" type="LSString" value="WAR_Mountain_Thane_Keystone"/>
    <attribute id="Selectors" type="LSString" value="AddSpells(UUID_L13_Spells)"/>
    <attribute id="TableUUID" type="guid" value="[WARRIOR_CLASS_UUID]"/>
    <attribute id="UUID" type="guid" value="[NEW_L13_UUID]"/>
</node>
```

**Note**: Each level 13-20 needs:
- Unique UUID (generate 8 new UUIDs)
- Reference to Warrior TableUUID (from ClassDescriptions.lsx)
- Passives from LINKED CSV
- Spells from LINKED CSV (via AddSpells UUID)

### Phase 3: Subclass Progressions (Arms/Fury/Protection)
**Approach**: Transform Warlock subclass progressions to Warrior subclasses

**Warlock Subclasses** (L1-10):
- Affliction UUID: `8e387e2d-1cfd-46a0-9b2d-af065217f841`
- Demonology UUID: `54ad57a9-7b0b-4cd5-944f-efe20a80d9e9`
- Destruction UUID: `e9aaae5b-7f50-4c51-8d4a-8cfc8b575e15`

**Warrior Subclasses** (L1-20):
- **Arms UUID**: (from ClassDescriptions.lsx - already set)
- **Fury UUID**: (from ClassDescriptions.lsx - already set)
- **Protection UUID**: (from ClassDescriptions.lsx - already set)

**Critical**: Subclass UUIDs must match ClassDescriptions.lsx FILE 2

**Changes**:
1. Replace subclass UUID references in base class `<SubClasses>` node
2. Create full L1-20 progressions for each subclass (using LINKED CSV spec-specific columns)
3. Add spec-specific passives (e.g., `arms_unlock`, `fury_unlock`, `protection_unlock` columns)

### Phase 4: Multiclass Variant
**Approach**: Keep multiclass variant structure, update references

**Changes**:
- Same as base class L1 but with `IsMulticlass="true"`
- Remove skill selection (multiclass doesn't get skill proficiencies)
- Keep spell grants

---

## Data Source Mapping

### LINKED CSV → Progressions.lsx Mapping

**CSV Columns**:
- `warrior_unlock`: Base class ability grants (L1-20)
- `arms_unlock`, `fury_unlock`, `protection_unlock`: Spec-specific grants
- `choice_group`: Talent choice tiers (if keeping SelectPassives)
- `implementation_status`: Filter for implemented abilities only

**Progressions.lsx Fields**:
- `Level`: Level number (1-20)
- `PassivesAdded`: Comma-separated passive IDs from CSV
- `Selectors`: `AddSpells(UUID)` - needs SpellList UUID creation
- `Boosts`: Static boosts (proficiencies, action resources)

### SpellList UUID Requirements

Each level with spell grants needs a SpellList UUID. **260 ability slots** means many spells.

**Options**:
1. **One SpellList per level** (20 SpellLists for base class + subclass variants)
2. **Zero SpellList approach** (embed all spells directly in Progressions - NOT RECOMMENDED, causes crashes)

**Decision**: Create SpellLists in FILE 12 (58+ UUIDs required based on Section [6.8] analysis)

---

## Dependencies

**Must be complete before starting**:
- ✅ FILES 4-10: All stat files (Passive.txt, Spell_*.txt, Status_BOOST.txt) - COMPLETE
- ✅ Section [6]: Progression validation (260 slots, 181 choices) - COMPLETE Oct 23-24
- ⚠️ FILE 12: SpellLists.lsx (58+ UUIDs for spell grants) - PENDING

**Chicken-and-egg problem**:
- Progressions needs SpellList UUIDs
- SpellLists needs to know which spells to include (from Progressions)

**Solution**: Two-pass approach:
1. **Pass 1**: Create SpellLists from LINKED CSV (group spells by level)
2. **Pass 2**: Reference SpellList UUIDs in Progressions

---

## Generation Strategy

### Option A: PowerShell Script Generation
**Pros**:
- Automated from LINKED CSV
- Consistent with FILES 4-10 approach
- Less error-prone

**Cons**:
- XML generation complex (nested nodes, attributes)
- Need to generate UUIDs
- Hard to validate

### Option B: Manual Transformation
**Pros**:
- Full control over XML structure
- Can validate incrementally
- Easier to debug

**Cons**:
- Time-consuming (80+ Progression nodes)
- Error-prone for 260 ability references

**Recommendation**: **Hybrid approach**
1. PowerShell script generates base structure from LINKED CSV
2. Manual review and adjustment of XML
3. Validate with test script

---

## Implementation Steps

### Step 1: Create SpellLists (FILE 12 first!)
**Why first?**: Progressions needs SpellList UUIDs

**Actions**:
1. Query LINKED CSV for all warrior_unlock abilities by level
2. Group spells by level (L1, L2, ..., L20)
3. Create SpellList entry for each level
4. Generate 58+ UUIDs (base class + subclasses)
5. Export SpellList UUID mapping (Level → UUID)

### Step 2: Generate Base Class Progressions (L1-20)
**Actions**:
1. Create PowerShell script: `Generate_Progressions_BaseClass.ps1`
2. Input: LINKED CSV + SpellList UUID mapping
3. Output: XML nodes for L1-20 base class
4. Insert into Progressions.lsx template

### Step 3: Generate Subclass Progressions
**Actions**:
1. Create PowerShell script: `Generate_Progressions_Subclasses.ps1`
2. Input: LINKED CSV (arms/fury/protection columns) + SpellList UUID mapping
3. Output: XML nodes for 3 subclasses × L1-20
4. Append to Progressions.lsx

### Step 4: Validate Progressions.lsx
**Actions**:
1. XML syntax validation (well-formed XML)
2. UUID reference validation (all UUIDs exist)
3. Ability reference validation (all WAR_* abilities exist in stat files)
4. Level count validation (20 levels for base class + subclasses)

---

## Estimated Complexity

**Lines of code**: ~2,000 lines of XML (80 Progression nodes × ~25 lines each)  
**Time estimate**: 4-6 hours (including SpellLists creation)  
**Error risk**: HIGH (260 ability references, 58+ UUID references)

**Recommendation**: Split into 2 sessions:
1. **Session A**: FILE 12 (SpellLists.lsx) - 2 hours
2. **Session B**: FILE 11 (Progressions.lsx) - 3 hours

---

## Next Actions

**DECISION REQUIRED**: Should we proceed with FILE 11 (Progressions.lsx) or tackle FILE 12 (SpellLists.lsx) first?

**Recommended order**:
1. **FILE 12 first** (SpellLists.lsx) - creates UUIDs needed by Progressions
2. **FILE 11 second** (Progressions.lsx) - references SpellList UUIDs

**Alternative approach** (faster but less clean):
- Use **dummy UUIDs** in Progressions for now
- Create SpellLists later
- Replace dummy UUIDs in final pass

**What's your preference?** 🤔
