# Phase 3: Lists Folder - Strategic Analysis & Decision

**Created**: October 18, 2025  
**Status**: ⚠️ CRITICAL ISSUE DISCOVERED

---

## Critical Discovery

The Lists folder has **severe naming inconsistencies** that will cause the mod to crash:

### Problem 1: Mismatched Prefixes

**PassiveLists.lsx** contains passives with prefix `WoWWarrior_*` (e.g., `WoWWarrior_UnlockBurningRush`)

**BUT**

**Passive.txt** contains passives with prefix `WAR_*` (e.g., `WAR_MountainThane_Keystone`)

**Result**: Game will look for "WoWWarrior_*" passives that don't exist → **CRASH**

### Problem 2: Warlock Content Still Present

**SpellLists.lsx** and **PassiveLists.lsx** contain:
- Warlock demon summon spells
- Warlock soul shard passives
- Warlock talent row passives (9 talent rows × 3 subclasses = 27+ rows)
- 53 SpellLists entries (only 12 needed for base class L1-L12)
- 52 PassiveLists entries (far more than needed)

**Result**: These reference spells/passives that don't exist in our stat files → **CRASH**

---

## Strategic Options

### Option A: Complete Rebuild (RECOMMENDED)
**Time**: 2 hours  
**Risk**: Low (clean slate, no conflicts)

**Approach**:
1. Delete ALL existing Lists content
2. Create new SpellLists for Warrior (simplified structure)
3. Create new PassiveLists for Warrior (only what we need)
4. Match our actual stat file entries (WAR_* prefixes)

**Structure**:
- **Base Class (L1-L12)**: 12 SpellLists (one per level)
- **Arms Subclass (L1-L12)**: 12 SpellLists (one per level)
- **Fury/Protection**: Empty placeholders (L2 only)
- **PassiveLists**: Only for hero talents L13-L20 (if using talent rows)

**Pros**:
- Clean, simple structure
- No leftover Warlock references
- Guaranteed to match our stat files
- Easier to debug

**Cons**:
- Takes longer (must create from scratch)
- Loses Warlock's talent row system (but we use hardcoded PassivesAdded)

---

### Option B: Transform Existing Lists (NOT RECOMMENDED)
**Time**: 3+ hours  
**Risk**: High (many opportunities for mistakes)

**Approach**:
1. Find/replace all "WoWWarrior_" → "WAR_" in PassiveLists.lsx
2. Map each of 53 Warlock SpellLists to Warrior equivalent
3. Map each of 52 Warlock PassiveLists to Warrior equivalent
4. Delete unmappable entries
5. Verify every UUID reference

**Pros**:
- Preserves talent row system
- More "complete" structure

**Cons**:
- Very time-consuming
- High error rate
- We don't even use talent rows (we use hardcoded PassivesAdded in Progressions.lsx)
- Complex to maintain

---

### Option C: Hybrid - Keep Structure, Replace Content (COMPROMISE)
**Time**: 1.5 hours  
**Risk**: Medium

**Approach**:
1. Keep UUID structure from Warlock (don't change UUIDs)
2. Replace all spell/passive references with our WAR_* entries
3. Delete subclass-specific rows we don't need
4. Keep talent row structure for future use

**Pros**:
- Faster than full rebuild
- Preserves UUIDs (Progressions.lsx already references them)
- Leaves talent row framework in place

**Cons**:
- Still complex
- Retains some unnecessary structure

---

## Recommendation: Option A (Complete Rebuild)

**Reasoning**:

1. **Our current Progressions.lsx doesn't use SelectPassives talent rows**
   - We use hardcoded `PassivesAdded` in Progressions.lsx
   - Talent rows are unnecessary for our design
   - Example from Progressions: `<attribute id="PassivesAdded" type="LSString" value="WAR_MountainThane_Keystone"/>`

2. **Simpler = Fewer Bugs**
   - Clean structure with only what we need
   - No leftover Warlock references to cause crashes
   - Easier to understand and modify later

3. **Matches Our Design**
   - Our hero talents are hardcoded at L13-L20
   - We don't need 9 talent rows × 3 subclasses
   - We just need spell grants per level

4. **UUID References in Progressions Can Be Updated**
   - Yes, Progressions.lsx references SpellList UUIDs
   - But those references will be updated in Phase 5 (Progressions transformation)
   - Creating new UUIDs now is fine - we'll map them in Phase 5

---

## Proposed New Structure (Option A)

### SpellLists.lsx (14 entries total)

```xml
<!-- Base Class Spell Lists (L1-L12) -->
<node id="SpellList">
    <attribute id="Name" value="WAR_Class_Level_1"/>
    <attribute id="Spells" value="Target_WAR_Charge;Shout_WAR_BattleShout"/>
    <attribute id="UUID" value="NEW-UUID-1"/>
</node>
<node id="SpellList">
    <attribute id="Name" value="WAR_Class_Level_2"/>
    <attribute id="Spells" value="Target_WAR_SunderArmor"/>
    <attribute id="UUID" value="NEW-UUID-2"/>
</node>
<!-- ... L3-L12 similar pattern -->

<!-- Arms Subclass Spell Lists (L1-L12) -->
<node id="SpellList">
    <attribute id="Name" value="WAR_Arms_Level_1"/>
    <attribute id="Spells" value="Target_WAR_MortalStrike"/>
    <attribute id="UUID" value="NEW-UUID-13"/>
</node>
<!-- ... Arms L2-L12 -->
```

### PassiveLists.lsx (Minimal - for future expansion)

```xml
<!-- Optional: Talent rows for future use -->
<node id="PassiveList">
    <attribute id="Name" value="WAR_TalentRow_L13"/>
    <attribute id="Passives" value="WAR_MountainThane_Keystone,WAR_Colossus_Keystone,WAR_Slayer_Keystone"/>
    <attribute id="UUID" value="NEW-UUID-PASSIVE-1"/>
</node>
<!-- Currently unused - our Progressions use hardcoded PassivesAdded -->
```

**OR**: Delete PassiveLists entirely if we don't use talent rows

---

## Implementation Plan (Option A - 2 hours)

### Step 1: Backup Current Lists (5 min)
```powershell
Copy-Item "Data\Public\...\Lists\*" "Tests\LISTS_BACKUP_BEFORE_REBUILD\"
```

### Step 2: Map Our Abilities to Levels (30 min)
Create mapping document:
- L1: Charge, Battle Shout
- L2: Sunder Armor, Heroic Strike
- L3: Thunder Clap, Victory Rush
- etc. through L20

### Step 3: Create New SpellLists.lsx (45 min)
- Base class L1-L12 (12 entries)
- Arms L1-L12 (12 entries)
- Fury/Protection placeholders (2 entries)
- Total: 26 entries (down from 53)

### Step 4: Create New PassiveLists.lsx (15 min)
- Option A: Empty file (we don't use talent rows)
- Option B: Minimal structure for future expansion

### Step 5: Verify UUIDs (15 min)
- Generate new UUIDs for all lists
- Document UUID → List Name mapping for Phase 5

### Step 6: Update References (15 min)
- Note: Progressions.lsx will be updated in Phase 5
- For now, just ensure new Lists files are valid XML

---

## User Decision Required

**Please choose**:

1. **Option A: Complete Rebuild** (Recommended - 2 hours, clean slate)
2. **Option B: Transform Existing** (Not recommended - 3+ hours, high risk)
3. **Option C: Hybrid Approach** (Compromise - 1.5 hours, medium risk)

**OR**

4. **Skip Phase 3 for Now** - Move to Phase 4 (stat files), come back to Lists later

---

## Impact on Other Phases

### If we choose Option A (Rebuild):
- **Phase 4**: No change (stat files independent)
- **Phase 5**: Update Progressions to reference new SpellList UUIDs (already planned)
- **Phase 6**: No change (meta, ClassDescriptions, etc.)
- **Phase 7**: No change (packaging)

### If we skip Phase 3:
- **Risk**: Mod will crash due to mismatched passive names
- **Must fix before packaging**: Yes, absolutely critical

---

## Next Steps (Awaiting User Decision)

Once you choose an option, I will:
1. Execute the plan
2. Create verification report
3. Move to Phase 4 (Stat Files Restructure)

**Ready to proceed with your chosen option?**
