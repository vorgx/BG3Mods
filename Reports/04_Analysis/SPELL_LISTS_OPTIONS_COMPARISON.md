# Spell Lists Transformation - Three Options Detailed Comparison

**Date**: October 18, 2025  
**Context**: FILE 3 complete (ActionResourceDefinitions.lsx). Planning FILES 4-10 transformation.  
**Decision Required**: Choose spell list structure approach before copying spell files.

---

## Current Situation

### Warlock Template Structure (What We Have Now)
```
Data/Public/Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7/Lists/SpellLists.lsx
```

**Current Content**:
- 53 SpellList entries (12 base class + 12 per subclass × 3 = 48, plus metadata entries)
- Naming: `WoW_Warlock_Class_Level_1` through `WoW_Warlock_Class_Level_12`
- Naming: `WoW_Warlock_Demo_Level_1` through `WoW_Warlock_Demo_Level_12`
- Naming: `WoW_Warlock_Destro_Level_1` through `WoW_Warlock_Destro_Level_12`
- Naming: `WoW_Warlock_Afflic_Level_1` through `WoW_Warlock_Afflic_Level_12`
- Each list has Name + UUID + Spells (semicolon-separated)

**Example Entry**:
```xml
<node id="SpellList">
    <attribute id="Name" type="FixedString" value="WoW_Warlock_Class_Level_1"/>
    <attribute id="Spells" type="LSString" value="Target_SummonDemon"/>
    <attribute id="UUID" type="guid" value="9e2ec5ea-a47c-475a-b756-c0e0ca69a281"/>
</node>
```

### What We Need (Warrior Mod)

**Warrior Structure** (from ARMS_WARRIOR_FULL_PROGRESSION.md):
- **Base Class**: 12 levels (L1-L12) with shared abilities
- **Arms Subclass**: 12 levels (L1-L12) with Arms-specific abilities
- **Fury Subclass**: 12 levels (L1-L12) with Fury-specific abilities (currently only 2 active)
- **Protection Subclass**: 12 levels (L1-L12) with Protection-specific abilities (currently only 2 active)

**Spell Progression** (Level-by-Level):

**Base Class (Shared by All)**:
- L1: `WAR_Charge`, `WAR_HeroicStrike`
- L2: `WAR_BattleShout`
- L3: `WAR_Execute`
- L4: (Feat - no spells)
- L5: (Extra Attack passive - no spells)
- L6: `WAR_DefensiveStance`
- L7: `WAR_IntimidatingShout`
- L8: (Feat - no spells)
- L9: `WAR_HeroicLeap`
- L10: `WAR_RallyingCry`
- L11: (Improved Extra Attack passive - no spells)
- L12: (Feat - no spells)

**Arms Subclass** (L1-L12):
- L1: (Passive only - `WAR_ARMS_WeaponMastery`)
- L2: (Base class spell only)
- L3: `WAR_ARMS_MortalStrike`, `WAR_ARMS_Overpower`
- L4: (Feat - no spells)
- L5: (Passive only - `WAR_ARMS_TacticalMastery`)
- L6: (Base class spell only)
- L7: `WAR_ARMS_ColossusSmash`
- L8: (Feat - no spells)
- L9: `WAR_ARMS_SweepingStrikes`
- L10: (Base class spell only)
- L11: `WAR_ARMS_Warbreaker`
- L12: (Feat - no spells)

**Fury Subclass** (L1-L12):
- L1: `WAR_FURY_Enrage` (passive + spell combo)
- L2-L12: Placeholder spells (not fully implemented yet)

**Protection Subclass** (L1-L12):
- L1: `WAR_PROT_ShieldBlock` (passive + spell combo)
- L2-L12: Placeholder spells (not fully implemented yet)

---

## Option A: Complete Rebuild (Recommended)

### Overview
- **Time**: 2 hours
- **Risk**: Low
- **Approach**: Delete all Warlock content, create fresh Warrior lists from scratch
- **UUIDs**: Generate new UUIDs for all lists (will update Progressions.lsx in FILE 11)

### What "Closest to Warlock" Means
This option **EXACTLY MATCHES** the Warlock structure:
- ✅ 12 base class lists (one per level L1-L12)
- ✅ 12 subclass lists per specialization (Arms/Fury/Protection)
- ✅ Same naming pattern: `WoW_Warrior_Class_Level_X` and `WoW_Warrior_Arms_Level_X`
- ✅ Same file structure (one SpellLists.lsx file with all entries)
- ✅ Same XML format (Name + UUID + Spells attributes)

**This is the MOST SIMILAR to Warlock structure** - it's literally the same pattern with Warrior content.

### File Structure After Rebuild
```
Data/Public/Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7/Lists/
├── SpellLists.lsx (CLEAN - 38 entries total)
└── PassiveLists.lsx (OPTIONAL - for hero talents L13-L20)
```

### SpellLists.lsx Structure (38 entries)

#### Base Class Lists (12 entries)
```xml
<node id="SpellList">
    <attribute id="Name" type="FixedString" value="WoW_Warrior_Class_Level_1"/>
    <attribute id="Spells" type="LSString" value="Target_WAR_Charge;Target_WAR_HeroicStrike"/>
    <attribute id="UUID" type="guid" value="NEW-UUID-1"/>
</node>
<node id="SpellList">
    <attribute id="Name" type="FixedString" value="WoW_Warrior_Class_Level_2"/>
    <attribute id="Spells" type="LSString" value="Shout_WAR_BattleShout"/>
    <attribute id="UUID" type="guid" value="NEW-UUID-2"/>
</node>
<node id="SpellList">
    <attribute id="Name" type="FixedString" value="WoW_Warrior_Class_Level_3"/>
    <attribute id="Spells" type="LSString" value="Target_WAR_Execute"/>
    <attribute id="UUID" type="guid" value="NEW-UUID-3"/>
</node>
<node id="SpellList">
    <attribute id="Name" type="FixedString" value="WoW_Warrior_Class_Level_4"/>
    <attribute id="UUID" type="guid" value="NEW-UUID-4"/>
    <!-- Empty - feat level -->
</node>
<!-- ... L5-L12 continue pattern -->
```

#### Arms Subclass Lists (12 entries)
```xml
<node id="SpellList">
    <attribute id="Name" type="FixedString" value="WoW_Warrior_Arms_Level_1"/>
    <attribute id="UUID" type="guid" value="NEW-UUID-13"/>
    <!-- Empty - passive only -->
</node>
<node id="SpellList">
    <attribute id="Name" type="FixedString" value="WoW_Warrior_Arms_Level_2"/>
    <attribute id="UUID" type="guid" value="NEW-UUID-14"/>
    <!-- Empty - base class spells only -->
</node>
<node id="SpellList">
    <attribute id="Name" type="FixedString" value="WoW_Warrior_Arms_Level_3"/>
    <attribute id="Spells" type="LSString" value="Target_WAR_ARMS_MortalStrike;Target_WAR_ARMS_Overpower"/>
    <attribute id="UUID" type="guid" value="NEW-UUID-15"/>
</node>
<!-- ... L4-L12 continue pattern -->
```

#### Fury Subclass Lists (12 entries)
```xml
<node id="SpellList">
    <attribute id="Name" type="FixedString" value="WoW_Warrior_Fury_Level_1"/>
    <attribute id="Spells" type="LSString" value="Shout_WAR_FURY_Enrage"/>
    <attribute id="UUID" type="guid" value="NEW-UUID-25"/>
</node>
<!-- ... L2-L12 placeholders -->
```

#### Protection Subclass Lists (12 entries)
```xml
<node id="SpellList">
    <attribute id="Name" type="FixedString" value="WoW_Warrior_Protection_Level_1"/>
    <attribute id="Spells" type="LSString" value="Shout_WAR_PROT_ShieldBlock"/>
    <attribute id="UUID" type="guid" value="NEW-UUID-37"/>
</node>
<!-- ... L2-L12 placeholders -->
```

### Implementation Steps

#### Step 1: Backup Current File (5 minutes)
```powershell
$BackupPath = "Tests\LISTS_BACKUP_BEFORE_REBUILD_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
New-Item -ItemType Directory -Path $BackupPath -Force
Copy-Item "Data\Public\Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7\Lists\*" `
    -Destination $BackupPath -Recurse
```

#### Step 2: Generate New UUIDs (10 minutes)
Create UUID mapping document with 38 new UUIDs:
```powershell
# PowerShell UUID generator
1..38 | ForEach-Object { 
    [guid]::NewGuid().ToString() 
} | Out-File "Reports\NEW_SPELL_LIST_UUIDS.txt"
```

#### Step 3: Create Spell Mapping Table (20 minutes)
Document **exactly** what spells go in each list (based on ARMS_WARRIOR_FULL_PROGRESSION.md):

| Level | Base Class Spells | Arms Spells | Fury Spells | Protection Spells |
|-------|-------------------|-------------|-------------|-------------------|
| 1     | WAR_Charge, WAR_HeroicStrike | (passive only) | WAR_FURY_Enrage | WAR_PROT_ShieldBlock |
| 2     | WAR_BattleShout | - | - | - |
| 3     | WAR_Execute | WAR_ARMS_MortalStrike, WAR_ARMS_Overpower | - | - |
| 4     | - | - | - | - |
| 5     | - | - | - | - |
| 6     | WAR_DefensiveStance | - | - | - |
| 7     | WAR_IntimidatingShout | WAR_ARMS_ColossusSmash | - | - |
| 8     | - | - | - | - |
| 9     | WAR_HeroicLeap | WAR_ARMS_SweepingStrikes | - | - |
| 10    | WAR_RallyingCry | - | - | - |
| 11    | - | WAR_ARMS_Warbreaker | - | - |
| 12    | - | - | - | - |

#### Step 4: Write New SpellLists.lsx (45 minutes)
Create XML file with:
- XML header (version 4.8.0.200)
- `<region id="SpellLists">` wrapper
- 38 `<node id="SpellList">` entries with correct Name/UUID/Spells
- Proper formatting and indentation

**Template**:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<save>
    <version major="4" minor="8" revision="0" build="200"/>
    <region id="SpellLists">
        <node id="root">
            <children>
                <!-- Base Class Lists (12) -->
                <!-- Arms Lists (12) -->
                <!-- Fury Lists (12) -->
                <!-- Protection Lists (12) -->
            </children>
        </node>
    </region>
</save>
```

#### Step 5: Validate XML Syntax (10 minutes)
- Open in VS Code - check for syntax errors
- Validate all UUIDs are unique
- Verify all spell names match actual spell entries (from backup stat files)

#### Step 6: Create Verification Report (15 minutes)
Document:
- All 38 UUIDs with their list names
- Mapping of old Warlock UUIDs → new Warrior UUIDs (for Progressions.lsx update)
- List of which spells are referenced in which lists

#### Step 7: Handle PassiveLists.lsx (20 minutes)
**Option A1**: Delete PassiveLists.lsx entirely (we don't use talent rows)
**Option A2**: Create minimal PassiveLists.lsx for hero talents L13-L20:
```xml
<!-- Optional: Hero Talent Selection Lists -->
<node id="PassiveList">
    <attribute id="Name" type="FixedString" value="WAR_HeroTalent_L13"/>
    <attribute id="Passives" type="LSString" value="WAR_Colossus_Keystone;WAR_Slayer_Keystone"/>
    <attribute id="UUID" type="guid" value="NEW-UUID-PASSIVE-1"/>
</node>
```

### Pros
✅ **Exact match to Warlock structure** (same pattern, same file organization)  
✅ **Clean slate** - no leftover references, no confusion  
✅ **Easy to understand** - clear naming, logical structure  
✅ **Low risk** - no complex transformations, just straightforward XML creation  
✅ **Maintainable** - future changes are simple  
✅ **Documented** - full mapping of UUIDs for Progressions.lsx update  
✅ **Validated** - can test each list independently  

### Cons
⚠️ **New UUIDs** - must update Progressions.lsx references (but we're doing that in FILE 11 anyway)  
⚠️ **2 hours work** - not the fastest option  
⚠️ **Manual creation** - requires careful XML writing  

### Why This Is "Closest to Warlock"
This option **literally replicates** the Warlock mod's proven structure:
1. Same naming convention pattern
2. Same file count (1 SpellLists.lsx)
3. Same level-based organization (L1-L12)
4. Same subclass structure (base + 3 specs)
5. Same XML format
6. Only difference: Warrior content instead of Warlock content

**If you want the Warrior mod to work EXACTLY like the Warlock mod works, this is the option.**

---

## Option B: Transform Existing (Not Recommended)

### Overview
- **Time**: 3+ hours
- **Risk**: High
- **Approach**: Find/replace Warlock references with Warrior references, preserve UUIDs
- **UUIDs**: Keep existing Warlock UUIDs (no Progressions.lsx update needed)

### What "Closest to Warlock" Means
This option **PRESERVES** the Warlock structure:
- ✅ Keeps all 53 existing Warlock UUIDs
- ✅ Keeps existing XML structure
- ⚠️ Find/replace "Warlock" → "Warrior" in list names
- ⚠️ Replace spell references (Warlock spells → Warrior spells)
- ⚠️ Must map 53 Warlock lists to 38 Warrior needs

**This is NOT closest to Warlock** - it's technically the most different because we're forcing Warrior content into Warlock UUIDs.

### Implementation Steps

#### Step 1: Analyze Current List Structure (30 minutes)
Map every Warlock list to its Warrior equivalent:
- Which Warlock lists map to base class?
- Which map to Arms? Fury? Protection?
- Which lists are unused/can be deleted?

#### Step 2: Find/Replace List Names (30 minutes)
```xml
<!-- Before -->
<attribute id="Name" value="WoW_Warlock_Class_Level_1"/>

<!-- After -->
<attribute id="Name" value="WoW_Warrior_Class_Level_1"/>
```

Repeat for all 53 entries (or decide which to delete).

#### Step 3: Replace Spell References (60 minutes)
```xml
<!-- Before -->
<attribute id="Spells" value="Target_SummonDemon;Projectile_AfflictionCurse"/>

<!-- After -->
<attribute id="Spells" value="Target_WAR_Charge;Target_WAR_HeroicStrike"/>
```

Must do this for every list with spells (approximately 30-40 lists).

#### Step 4: Handle Extra Lists (30 minutes)
Decision for each extra list:
- Delete it? (reduces count from 53 → 38)
- Repurpose it? (for future Warrior abilities)
- Leave empty? (preserves UUID for Progressions.lsx)

#### Step 5: Validate References (30 minutes)
- Every spell name exists in backup stat files
- No leftover Warlock spell references
- All UUIDs still unique
- Progressions.lsx still references correct UUIDs

#### Step 6: Test in Game (30 minutes)
- Package mod
- Load game
- Verify spells appear at correct levels
- Check for crashes

### Pros
✅ **Preserves UUIDs** - Progressions.lsx doesn't need UUID updates  
✅ **Keeps structure** - file organization unchanged  

### Cons
❌ **High error risk** - easy to miss Warlock references  
❌ **Complex mapping** - 53 lists → 38 needs, which maps to what?  
❌ **Confusing** - why is `WoW_Warlock_Demo_Level_1` UUID used for Arms?  
❌ **Hard to maintain** - future changes require remembering mapping  
❌ **Time consuming** - 3+ hours of careful find/replace work  
❌ **Validation nightmare** - must check every single line  
❌ **Not actually "closest to Warlock"** - we're breaking the Warlock pattern by forcing Warrior content into Warlock UUIDs  

### Why This Is NOT "Closest to Warlock"
While it preserves UUIDs, it breaks the semantic structure:
- Warlock UUIDs now point to Warrior content (confusing)
- List names don't match UUIDs (WoW_Warrior_Arms_Level_3 might use Warlock Demo UUID)
- Documentation becomes complex ("Use Demo UUID for Arms")
- Future maintainers will be confused

**This is the LEAST similar to Warlock's logical structure.**

---

## Option C: Hybrid Approach (Compromise)

### Overview
- **Time**: 1.5 hours
- **Risk**: Medium
- **Approach**: Keep Warlock UUIDs but create clean new content
- **UUIDs**: Reuse existing Warlock UUIDs in new Warrior lists

### What "Closest to Warlock" Means
This option **MIMICS** the Warlock structure with UUID preservation:
- ✅ Same naming pattern as Warlock (WoW_Warrior_Class_Level_X)
- ✅ Same file structure as Warlock (38 entries)
- ⚠️ Reuses Warlock UUIDs in different order
- ⚠️ Creates new XML but preserves UUID references

**This is "middle ground"** - structure like Option A, UUIDs like Option B.

### Implementation Steps

#### Step 1: Extract Warlock UUIDs (15 minutes)
Create UUID pool from existing file:
```powershell
# Extract all 53 UUIDs from current SpellLists.lsx
Select-Xml -Path "Data\Public\...\Lists\SpellLists.lsx" -XPath "//attribute[@id='UUID']" | 
    Select-Object -ExpandProperty Node | 
    Select-Object -ExpandProperty value |
    Out-File "Reports\WARLOCK_UUID_POOL.txt"
```

#### Step 2: Map UUIDs to Warrior Lists (20 minutes)
Assign 38 UUIDs from pool to new Warrior lists:
```
WoW_Warrior_Class_Level_1 → 9e2ec5ea-a47c-475a-b756-c0e0ca69a281 (was Warlock Class L1)
WoW_Warrior_Class_Level_2 → 7e7c204e-0bcb-4ddb-9dd5-78a2f85cdfb2 (was Warlock Class L2)
WoW_Warrior_Arms_Level_1 → aedc2c38-5a25-4033-bb19-f801f2e79101 (was Warlock Demo L1)
```

#### Step 3: Create New SpellLists.lsx (30 minutes)
Write fresh XML using:
- Warrior list names (WoW_Warrior_*)
- Warrior spell references (WAR_*)
- Warlock UUIDs (from mapping)

#### Step 4: Validate Structure (15 minutes)
- Check XML syntax
- Verify UUIDs are unique
- Confirm spell names exist

#### Step 5: Create Verification Report (10 minutes)
Document:
- Which Warlock UUIDs map to which Warrior lists
- Which UUIDs were unused (15 leftovers from 53-38)

### Pros
✅ **Clean structure** - like Option A, easy to read  
✅ **Preserves UUIDs** - Progressions.lsx doesn't need UUID updates  
✅ **Faster than Option B** - no complex find/replace  
✅ **Logical naming** - Warrior lists have Warrior names  
✅ **Warlock-like pattern** - same structure as proven mod  

### Cons
⚠️ **UUID semantics broken** - Demo UUID used for Arms (confusing for debugging)  
⚠️ **Documentation overhead** - must track UUID mapping  
⚠️ **Medium risk** - UUID reassignment could have hidden issues  
⚠️ **Not as clean as Option A** - UUID provenance unclear  

### Why This Is "Somewhat Like Warlock"
This option gets the structure right (like Warlock) but the UUIDs are semantically wrong:
- Structure matches Warlock ✅
- Naming matches Warlock ✅
- UUID logic matches Warlock ❌ (reused in different context)

**If you want Warlock structure but need to preserve UUIDs, this works. But it's not as clean as Option A.**

---

## Side-by-Side Comparison

| Aspect | Option A: Rebuild | Option B: Transform | Option C: Hybrid |
|--------|-------------------|---------------------|------------------|
| **Time Required** | 2 hours | 3+ hours | 1.5 hours |
| **Risk Level** | Low | High | Medium |
| **UUID Strategy** | New (38) | Preserve (53) | Reuse (38 from 53) |
| **Structure Match** | ✅ Exact Warlock pattern | ❌ Breaks pattern | ✅ Exact Warlock pattern |
| **Naming** | WoW_Warrior_* | WoW_Warrior_* | WoW_Warrior_* |
| **Maintainability** | ✅ Excellent | ❌ Poor | ⚠️ Good |
| **Progressions Update** | Required (FILE 11) | Not required | Not required |
| **Debugging** | ✅ Easy (clear UUIDs) | ❌ Hard (semantic mismatch) | ⚠️ Medium (UUID mapping) |
| **Future Changes** | ✅ Simple | ❌ Complex | ⚠️ Moderate |
| **Documentation** | ✅ Clear | ❌ Complex | ⚠️ Moderate |
| **Crash Risk** | Low | High (missed references) | Medium |
| **"Closest to Warlock"** | ✅ **YES - Exact structure** | ❌ NO - Breaks semantics | ⚠️ Partially - Structure only |

---

## Recommendation: Option A (Complete Rebuild)

### Why Option A Is Best

1. **It IS "Closest to Warlock"**:
   - Exact same structure as Warlock mod (12 base + 12 per spec)
   - Same naming pattern (WoW_Warrior_Class_Level_X)
   - Same file organization
   - Only difference: Warrior content instead of Warlock content
   - **This is literally how the Warlock mod is built** - we're following the same blueprint

2. **Lowest Risk**:
   - Clean slate = no hidden Warlock references
   - No complex transformations to introduce errors
   - Easy to validate each entry

3. **Best Long-Term**:
   - Easy to maintain
   - Clear documentation
   - Simple to add new abilities later
   - No confusing UUID mapping

4. **We're Updating Progressions Anyway**:
   - FILE 11 (Progressions.lsx) is already on our todo list
   - We'll update SelectSpells nodes with new list UUIDs
   - No extra work compared to Option C

5. **Proven Pattern**:
   - Warlock mod has 13K+ downloads
   - This structure is tested and works
   - We're literally copying a successful pattern

6. **Clear Documentation**:
   - UUID mapping document shows old → new
   - Easy for future sessions to understand
   - No semantic confusion (UUID matches content)

### Time Breakdown (2 hours total)
- 5 min: Backup
- 10 min: Generate UUIDs
- 20 min: Create spell mapping table
- 45 min: Write SpellLists.lsx
- 10 min: Validate XML
- 15 min: Create verification report
- 15 min: Handle PassiveLists.lsx (or delete it)

### Next Session Impact
After this, we can proceed confidently with:
- FILES 4-10: Copy spell files from backup (no list structure uncertainty)
- FILE 11: Update Progressions.lsx with new list UUIDs (straightforward mapping)
- FILE 12: Localization (no impact from list choice)

---

## Decision Matrix

**Choose Option A if**:
- ✅ You want the **exact same structure as Warlock mod** (RECOMMENDED)
- ✅ You value clean, maintainable code
- ✅ You're okay with 2 hours of work for long-term benefits
- ✅ You're already planning to update Progressions.lsx (FILE 11)

**Choose Option C if**:
- ⚠️ You must preserve Warlock UUIDs for some reason
- ⚠️ You want to save 30 minutes vs. Option A
- ⚠️ You're okay with UUID semantic confusion

**Choose Option B if**:
- ❌ You enjoy debugging complex find/replace errors (NOT RECOMMENDED)
- ❌ You have 3+ hours to spend on high-risk work
- ❌ You want to confuse future maintainers

---

## User Decision Required

**Which option do you prefer?**

1. **Option A: Complete Rebuild** (2 hours, exact Warlock structure, new UUIDs)
2. **Option B: Transform Existing** (3+ hours, preserve UUIDs, high risk)
3. **Option C: Hybrid Approach** (1.5 hours, Warlock structure + Warlock UUIDs)

**My strong recommendation**: Option A

**Reasoning**: You said you want "closest to the warlock one, where we have our spells and list for each level" - that's EXACTLY what Option A gives you. It replicates the Warlock mod's structure with Warrior content. Option B actually breaks the Warlock pattern by forcing Warrior content into Warlock UUIDs, and Option C is a compromise that works but isn't as clean.

**Once you decide, I will**:
1. Execute the chosen option
2. Create verification report
3. Update todo list for FILES 4-10
4. Proceed with spell file transformation

---

## Appendix: Complete Spell Mapping Table

### Base Class Spell Progression (L1-L12)

| Level | Spells to Add | Notes |
|-------|---------------|-------|
| 1 | `Target_WAR_Charge`, `Target_WAR_HeroicStrike` | Core abilities |
| 2 | `Shout_WAR_BattleShout` | Party buff |
| 3 | `Target_WAR_Execute` | Execute mechanic |
| 4 | (none) | Feat level |
| 5 | (none) | Extra Attack passive |
| 6 | `Shout_WAR_DefensiveStance` | Defensive toggle |
| 7 | `Shout_WAR_IntimidatingShout` | AoE fear |
| 8 | (none) | Feat level |
| 9 | `Jump_WAR_HeroicLeap` | Gap closer |
| 10 | `Shout_WAR_RallyingCry` | Party heal |
| 11 | (none) | Improved Extra Attack passive |
| 12 | (none) | Feat level |

### Arms Subclass Spell Progression (L1-L12)

| Level | Spells to Add | Notes |
|-------|---------------|-------|
| 1 | (none) | Passive only |
| 2 | (none) | Base class only |
| 3 | `Target_WAR_ARMS_MortalStrike`, `Target_WAR_ARMS_Overpower` | Signature abilities |
| 4 | (none) | Feat level |
| 5 | (none) | Passive only |
| 6 | (none) | Base class only |
| 7 | `Target_WAR_ARMS_ColossusSmash` | Armor shred |
| 8 | (none) | Feat level |
| 9 | `Shout_WAR_ARMS_SweepingStrikes` | AoE damage |
| 10 | (none) | Base class only |
| 11 | `Zone_WAR_ARMS_Warbreaker` | AoE finisher |
| 12 | (none) | Feat level |

### Fury Subclass Spell Progression (L1-L12)

| Level | Spells to Add | Notes |
|-------|---------------|-------|
| 1 | `Shout_WAR_FURY_Enrage` | Fury resource |
| 2-12 | (placeholders) | Not fully implemented |

### Protection Subclass Spell Progression (L1-L12)

| Level | Spells to Add | Notes |
|-------|---------------|-------|
| 1 | `Shout_WAR_PROT_ShieldBlock` | Shield mechanic |
| 2-12 | (placeholders) | Not fully implemented |

---

**End of Options Comparison Document**

**Ready for your decision!**
