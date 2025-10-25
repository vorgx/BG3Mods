# PHASE 2 COMPREHENSIVE IMPLEMENTATION PLAN
## Nested Subclass Hero Talents (L13 Choice)

**Date**: October 24, 2025  
**Implementation**: 9 total subclasses (3 base at L1 + 6 hero talents at L13)  
**Estimated Time**: 6-8 hours total

---

## OVERVIEW: What We're Building

### Current Structure (Phase 1):
```
L1: Choose Warrior → Choose Arms/Fury/Protection
L3-12: Progress in chosen spec
L13-20: Auto-granted ALL 22 hero talents (both trees)
```

### Target Structure (Phase 2):
```
L1: Choose Warrior → Choose Arms/Fury/Protection
L3-12: Progress in chosen spec
L13: Choose Hero Talent Tree (2 options per spec)
    - Arms → Colossus OR Slayers
    - Fury → Mountain Thane OR Slayers
    - Protection → Mountain Thane OR Colossus
L14-20: Progress in chosen hero tree (11 talents)
```

---

## SECTION-BY-SECTION CHANGE INVENTORY

### ✅ SECTIONS THAT NEED UPDATES

#### 1. ClassDescriptions.lsx ⚠️ CRITICAL
**Location**: `Data/Public/Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7/ClassDescriptions/ClassDescriptions.lsx`

**Current State**: 4 class descriptions
- 1 base Warrior class
- 3 subclasses (Arms, Fury, Protection)

**Required Changes**: Add 6 new hero talent subclasses
- ArmsColossus (parent: Arms)
- ArmsSlayers (parent: Arms)
- FuryMountainThane (parent: Fury)
- FurySlayers (parent: Fury)
- ProtectionMountainThane (parent: Protection)
- ProtectionColossus (parent: Protection)

**Action**: INSERT 6 new `<node id="ClassDescription">` entries

**Validation After**: 10 total class descriptions (1 base + 3 subclasses + 6 hero subclasses)

---

#### 2. Progressions.lsx ⚠️ CRITICAL
**Location**: `Data/Public/Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7/Progressions/Progressions.lsx`

**Current State**: 74 progression nodes
- 12 base Warrior (L1-12)
- 18 Arms (L3-20)
- 18 Fury (L3-20)
- 18 Protection (L3-20)
- 8 other nodes (multiclass, etc.)

**Required Changes**:

**A. Modify 3 existing L13 nodes** (Arms/Fury/Protection):
- REMOVE: `PassivesAdded` (currently auto-grants hero talents)
- ADD: `<SubClasses>` node with 2 hero talent options each

**B. Add 48 new progression nodes** (6 hero subclasses × 8 levels L13-20):
- ArmsColossus L13-20 (8 nodes)
- ArmsSlayers L13-20 (8 nodes)
- FuryMountainThane L13-20 (8 nodes)
- FurySlayers L13-20 (8 nodes)
- ProtectionMountainThane L13-20 (8 nodes)
- ProtectionColossus L13-20 (8 nodes)

**Validation After**: 119 total nodes (74 current - 3 modified + 48 new)

---

#### 3. AbilityDatabase_Warrior_FullyEnriched.csv ⚠️ NEEDS UPDATE
**Location**: `Documentation/00_SourcesOfTruth/AbilityDatabase_Warrior_FullyEnriched.csv`

**Current State**: Hero talents have dual-spec unlock columns
- Example: `WAR_Demolish` has `arms_unlock=13` AND `protection_unlock=13`

**Problem**: Database represents "tree availability" (which 2 specs can access tree), NOT "which subclass grants it"

**Required Changes**: Add new column `granted_by_subclass`
- `WAR_Demolish` → `granted_by_subclass=ArmsColossus,ProtectionColossus`
- `WAR_Lightning_Strikes` → `granted_by_subclass=FuryMountainThane,ProtectionMountainThane`
- `WAR_Slayer_s_Dominance` → `granted_by_subclass=ArmsSlayers,FurySlayers`

**Validation After**: All 33 hero talents have `granted_by_subclass` populated

---

#### 4. Localization (English.loca.xml)
**Location**: `Data/Public/Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7/Localization/English/English.loca.xml`

**Required Changes**: Add 12 new localization handles
- 6 hero subclass names (DisplayName)
- 6 hero subclass descriptions (Description)

**Example**:
```xml
<content contentuid="hHERO01" version="1">Colossus</content>
<content contentuid="hHERO02" version="1">Arms Warrior embracing the Colossus hero talents. Become an unstoppable juggernaut, smashing through enemies with devastating power.</content>
<content contentuid="hHERO03" version="1">Slayers</content>
<content contentuid="hHERO04" version="1">Arms Warrior embracing the Slayers hero talents. Execute wounded foes with brutal precision and relentless aggression.</content>
<!-- ... 4 more pairs -->
```

**Validation After**: 12 new handles added, all referenced in ClassDescriptions.lsx

---

#### 5. SpellList_UUID_Mapping.csv ⚠️ NEEDS UPDATE
**Location**: `Scripts/SpellList_UUID_Mapping.csv`

**Current State**: Maps levels to spell list UUIDs for 3 subclasses (Arms/Fury/Protection L3-20)

**Required Changes**: Add mappings for 6 hero subclasses L13-20
- ArmsColossus,13,UUID
- ArmsColossus,15,UUID
- ... (8 rows per hero subclass × 6 = 48 new rows)

**Decision Needed**: 
- **Option A**: Reuse existing spell list UUIDs from base specs (simpler)
  - ArmsColossus L13 uses same UUID as Arms L13
- **Option B**: Generate new unique spell list UUIDs for each hero subclass (cleaner separation)

**Recommendation**: Option A (reuse) - hero talents don't grant spells, only passives

**Validation After**: CSV has entries for all 9 subclasses × appropriate level ranges

---

### ❌ SECTIONS THAT DON'T NEED UPDATES

#### 6. Passive.txt - NO CHANGES NEEDED ✅
**Location**: `Data/Public/Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7/Stats/Generated/Data/Passive.txt`

**Current State**: 33 hero talent passives defined
- All passives work as-is (no conditional checks needed)
- Each passive functions independently

**Why No Changes**: 
- We're using separate subclasses (not status conditions)
- Each subclass progression grants ONLY its 11 passives
- No need for `EnabledConditions` checks

**Validation**: Passives remain unchanged

---

#### 7. Spell_*.txt Files - NO CHANGES NEEDED ✅
**Location**: `Data/Public/Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7/Stats/Generated/Data/Spell_*.txt`

**Why No Changes**: 
- Spell definitions are independent of progression/subclass
- Passives unlock spells via `UnlockSpell()` boosts
- No spell modifications needed

**Validation**: All spell files remain unchanged

---

#### 8. Status_BOOST.txt - NO CHANGES NEEDED ✅
**Location**: `Data/Public/Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7/Stats/Generated/Data/Status_BOOST.txt`

**Why No Changes**:
- No status-based choice mechanism (using subclasses instead)
- All existing status effects work as-is

**Validation**: Status file remains unchanged

---

#### 9. Lists/SpellLists.lsx - MINOR UPDATE POSSIBLE
**Location**: `Data/Public/Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7/Lists/SpellLists.lsx`

**Current State**: Spell lists for each level/subclass combination

**Decision Needed**:
- **Option A**: Reuse existing spell lists from base specs (Arms/Fury/Protection)
  - Hero subclasses reference same spell list UUIDs as their parent
  - Example: ArmsColossus L13 uses same spell list as Arms L13
- **Option B**: Create new spell lists for hero subclasses
  - 48 new spell list entries (6 subclasses × 8 levels)

**Recommendation**: Option A (reuse) - simpler, hero talents don't add new spells

**Validation**: If Option A, no changes needed. If Option B, add 48 new `<node id="SpellList">` entries

---

#### 10. Lists/PassiveLists.lsx - NO CHANGES NEEDED ✅
**Location**: `Data/Public/Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7/Lists/PassiveLists.lsx`

**Why No Changes**:
- Passives are granted directly via `PassivesAdded` in Progressions.lsx
- No passive lists needed for hero talents

**Validation**: File remains unchanged

---

## VALIDATION SCRIPTS NEEDED

### 1. Validate_HeroSubclass_Progressions.ps1
**Purpose**: Verify all 6 hero subclasses have complete L13-20 progressions

**Checks**:
- [ ] Each hero subclass has exactly 8 progression nodes (L13-20)
- [ ] Each L13 node grants correct keystone passive (1 only)
- [ ] Each L15/17/19/20 node grants correct hero talents
- [ ] Total hero talents per subclass = 11
- [ ] No overlap (ArmsColossus doesn't grant Slayers talents)

---

### 2. Validate_Subclass_Choices.ps1
**Purpose**: Verify L13 subclass selection presents correct options

**Checks**:
- [ ] Arms L13 has SubClasses node with 2 options (Colossus, Slayers)
- [ ] Fury L13 has SubClasses node with 2 options (Mountain Thane, Slayers)
- [ ] Protection L13 has SubClasses node with 2 options (Mountain Thane, Colossus)
- [ ] Each SubClass references correct UUID from ClassDescriptions.lsx

---

### 3. Validate_ClassDescriptions_Hierarchy.ps1
**Purpose**: Verify parent-child relationships in class definitions

**Checks**:
- [ ] Base Warrior class has no ParentGuid
- [ ] 3 base subclasses (Arms/Fury/Protection) have ParentGuid = Warrior UUID
- [ ] 6 hero subclasses have ParentGuid = correct base subclass UUID
- [ ] All 10 class descriptions have unique UUIDs
- [ ] All ProgressionTableUUIDs are unique

---

### 4. Validate_Database_Subclass_Mappings.ps1
**Purpose**: Verify database has correct subclass assignments

**Checks**:
- [ ] All 33 hero talents have `granted_by_subclass` column populated
- [ ] Mountain Thane talents → FuryMountainThane, ProtectionMountainThane
- [ ] Colossus talents → ArmsColossus, ProtectionColossus
- [ ] Slayers talents → ArmsSlayers, FurySlayers
- [ ] No talents assigned to wrong subclasses

---

### 5. Validate_Localization_Complete.ps1
**Purpose**: Verify all localization handles exist

**Checks**:
- [ ] All 6 hero subclass DisplayName handles exist in English.loca.xml
- [ ] All 6 hero subclass Description handles exist in English.loca.xml
- [ ] All handles referenced in ClassDescriptions.lsx have corresponding entries
- [ ] No duplicate contentuid values

---

## SOURCE OF TRUTH UPDATES

### Documentation/00_SourcesOfTruth/SOURCE_OF_TRUTH.md

**Sections to Update**:

#### [3] Class Architecture
**Add**:
```markdown
### Hero Talent Subclasses (L13 Choice)

**9 Total Subclasses**:
- Base (L1-2): Warrior
- Spec (L3): Arms, Fury, Protection
- Hero (L13): ArmsColossus, ArmsSlayers, FuryMountainThane, FurySlayers, ProtectionMountainThane, ProtectionColossus

**Subclass Hierarchy**:
Warrior (base)
├── Arms (L3)
│   ├── ArmsColossus (L13) → 11 Colossus talents
│   └── ArmsSlayers (L13) → 11 Slayers talents
├── Fury (L3)
│   ├── FuryMountainThane (L13) → 11 Mountain Thane talents
│   └── FurySlayers (L13) → 11 Slayers talents
└── Protection (L3)
    ├── ProtectionMountainThane (L13) → 11 Mountain Thane talents
    └── ProtectionColossus (L13) → 11 Colossus talents
```

#### [11] FILE 11 (Progressions.lsx)
**Update Status**:
```markdown
**Status**: Phase 2 Complete - Nested subclass hero talent selection at L13

**Structure**:
- 12 base Warrior nodes (L1-12)
- 18 Arms nodes (L3-20) - L13 modified with SubClasses choice
- 18 Fury nodes (L3-20) - L13 modified with SubClasses choice
- 18 Protection nodes (L3-20) - L13 modified with SubClasses choice
- 48 hero subclass nodes (6 subclasses × 8 levels L13-20)
- **Total**: 119 progression nodes

**Hero Talent Selection**:
- L13 Arms: Choose Colossus OR Slayers (2 options)
- L13 Fury: Choose Mountain Thane OR Slayers (2 options)
- L13 Protection: Choose Mountain Thane OR Colossus (2 options)
```

#### [2] FILE 2 (ClassDescriptions.lsx)
**Update Status**:
```markdown
**Status**: Phase 2 Complete - 10 class descriptions (1 base + 3 specs + 6 hero subclasses)

**Class Hierarchy**:
- Warrior (base class)
- Arms, Fury, Protection (L3 subclasses)
- ArmsColossus, ArmsSlayers, FuryMountainThane, FurySlayers, ProtectionMountainThane, ProtectionColossus (L13 hero subclasses)

**UUIDs**:
- Base Warrior: 78fe4967-4e62-5491-d981-dd781acca4d7
- Arms: [CURRENT_UUID]
- Fury: [CURRENT_UUID]
- Protection: [CURRENT_UUID]
- ArmsColossus: [NEW_UUID_1]
- ArmsSlayers: [NEW_UUID_2]
- FuryMountainThane: [NEW_UUID_3]
- FurySlayers: [NEW_UUID_4]
- ProtectionMountainThane: [NEW_UUID_5]
- ProtectionColossus: [NEW_UUID_6]
```

#### [1] Ability Database Section
**Add Column**:
```markdown
**New Column**: `granted_by_subclass`
- Purpose: Maps hero talents to specific subclasses that grant them
- Format: Comma-separated list of subclass names
- Example: `ArmsColossus,ProtectionColossus` for Colossus talents

**Usage**: 
- Progressions generation scripts use this to assign passives to correct subclass levels
- Validation scripts verify no talent granted by wrong subclass
```

---

## IMPLEMENTATION STEP-BY-STEP

### STEP 1: Generate UUIDs (5 minutes)
```powershell
# Generate 18 UUIDs (6 ClassDescription + 6 ProgressionTable + 6 for spare)
1..18 | ForEach-Object { [guid]::NewGuid().ToString() }
```

**Document UUIDs in workspace** (e.g., `PHASE2_UUIDS.txt`)

---

### STEP 2: Update Database (30 minutes)
**Script**: `Add_Subclass_Column_To_Database.ps1`

```powershell
# Add granted_by_subclass column
$Database = Import-Csv "AbilityDatabase_Warrior_FullyEnriched.csv"

# Add new column
$Database | Add-Member -MemberType NoteProperty -Name "granted_by_subclass" -Value "" -Force

# Map hero talents to subclasses
$HeroTalentMappings = @{
    # Mountain Thane (11 talents)
    "WAR_Lightning_Strikes" = "FuryMountainThane,ProtectionMountainThane"
    "WAR_Crashing_Thunder" = "FuryMountainThane,ProtectionMountainThane"
    # ... (9 more)
    
    # Colossus (11 talents)
    "WAR_Demolish" = "ArmsColossus,ProtectionColossus"
    "WAR_Martial_Expert" = "ArmsColossus,ProtectionColossus"
    # ... (9 more)
    
    # Slayers (11 talents)
    "WAR_Slayer_s_Dominance" = "ArmsSlayers,FurySlayers"
    "WAR_Imminent_Demise" = "ArmsSlayers,FurySlayers"
    # ... (9 more)
}

foreach ($row in $Database) {
    if ($HeroTalentMappings.ContainsKey($row.ability_name)) {
        $row.granted_by_subclass = $HeroTalentMappings[$row.ability_name]
    }
}

# Export
$Database | Export-Csv "AbilityDatabase_Warrior_FullyEnriched.csv" -NoTypeInformation
```

**Validation**: Run `Validate_Database_Subclass_Mappings.ps1`

---

### STEP 3: Add Hero Subclasses to ClassDescriptions.lsx (1 hour)

**Action**: INSERT 6 new class description nodes

**Template** (repeat 6 times with different values):
```xml
<!-- ArmsColossus -->
<node id="ClassDescription">
    <attribute id="CharacterCreationPose" type="guid" value="COPY_FROM_ARMS"/>
    <attribute id="Description" type="TranslatedString" handle="hHERO02" version="1"/>
    <attribute id="DisplayName" type="TranslatedString" handle="hHERO01" version="1"/>
    <attribute id="LearningStrategy" type="uint8" value="1"/>
    <attribute id="Name" type="FixedString" value="ArmsColossus"/>
    <attribute id="ParentGuid" type="guid" value="CURRENT_ARMS_UUID"/>
    <attribute id="PrimaryAbility" type="uint8" value="1"/>
    <attribute id="ProgressionTableUUID" type="guid" value="NEW_UUID_1"/>
    <attribute id="SoundClassType" type="FixedString" value="Fighter"/>
    <attribute id="UUID" type="guid" value="NEW_UUID_7"/>
    <children>
        <node id="Tags">
            <attribute id="Object" type="guid" value="COPY_FROM_ARMS"/>
        </node>
    </children>
</node>
```

**Copy these attributes from parent subclass**:
- CharacterCreationPose
- PrimaryAbility
- SoundClassType
- Tags/Object

**Validation**: Run `Validate_ClassDescriptions_Hierarchy.ps1`

---

### STEP 4: Add Localization (30 minutes)

**Add 12 handles to English.loca.xml**:
```xml
<!-- Hero Subclass Names -->
<content contentuid="hHERO01" version="1">Colossus</content>
<content contentuid="hHERO03" version="1">Slayers</content>
<content contentuid="hHERO05" version="1">Mountain Thane</content>
<content contentuid="hHERO07" version="1">Slayers</content>
<content contentuid="hHERO09" version="1">Mountain Thane</content>
<content contentuid="hHERO11" version="1">Colossus</content>

<!-- Hero Subclass Descriptions -->
<content contentuid="hHERO02" version="1">Arms Warrior wielding the Colossus hero talents. Become an unstoppable juggernaut with devastating power and unbreakable resilience. Grants 11 Colossus talents from L13-20.</content>
<content contentuid="hHERO04" version="1">Arms Warrior wielding the Slayers hero talents. Execute wounded foes with brutal precision and relentless aggression. Grants 11 Slayers talents from L13-20.</content>
<content contentuid="hHERO06" version="1">Fury Warrior wielding the Mountain Thane hero talents. Harness the power of thunder and storm to overwhelm enemies. Grants 11 Mountain Thane talents from L13-20.</content>
<content contentuid="hHERO08" version="1">Fury Warrior wielding the Slayers hero talents. Execute wounded foes with brutal precision and relentless aggression. Grants 11 Slayers talents from L13-20.</content>
<content contentuid="hHERO10" version="1">Protection Warrior wielding the Mountain Thane hero talents. Harness the power of thunder and storm while defending allies. Grants 11 Mountain Thane talents from L13-20.</content>
<content contentuid="hHERO12" version="1">Protection Warrior wielding the Colossus hero talents. Become an unstoppable juggernaut protecting your allies with devastating counterattacks. Grants 11 Colossus talents from L13-20.</content>
```

**Validation**: Run `Validate_Localization_Complete.ps1`

---

### STEP 5: Modify Progressions.lsx L13 Nodes (30 minutes)

**Action**: REPLACE L13 PassivesAdded with SubClasses choice for Arms/Fury/Protection

**BEFORE (Arms L13)**:
```xml
<node id="Progression">
    <attribute id="Level" type="uint8" value="13"/>
    <attribute id="Name" type="LSString" value="Arms"/>
    <attribute id="PassivesAdded" type="LSString" value="WAR_Demolish;WAR_Slayer_s_Dominance"/>
    <!-- ... -->
</node>
```

**AFTER (Arms L13)**:
```xml
<node id="Progression">
    <attribute id="Level" type="uint8" value="13"/>
    <attribute id="Name" type="LSString" value="Arms"/>
    <attribute id="ProgressionType" type="uint8" value="1"/>
    <attribute id="TableUUID" type="guid" value="CURRENT_ARMS_TABLE_UUID"/>
    <attribute id="UUID" type="guid" value="CURRENT_ARMS_L13_UUID"/>
    <children>
        <node id="SubClasses">
            <children>
                <node id="SubClass">
                    <attribute id="Object" type="guid" value="NEW_UUID_7"/>  <!-- ArmsColossus -->
                </node>
                <node id="SubClass">
                    <attribute id="Object" type="guid" value="NEW_UUID_8"/>  <!-- ArmsSlayers -->
                </node>
            </children>
        </node>
    </children>
</node>
```

**Repeat for**:
- Fury L13 (Mountain Thane / Slayers options)
- Protection L13 (Mountain Thane / Colossus options)

**Validation**: Verify no PassivesAdded on L13 nodes for base specs

---

### STEP 6: Generate Hero Subclass Progressions (2-3 hours)

**Script**: `Generate_HeroSubclass_Progressions.ps1`

```powershell
# For each of 6 hero subclasses:
#   1. Read database to get hero talents for this subclass
#   2. Distribute 11 talents across L13, 15, 17, 19, 20
#   3. Generate 8 progression nodes (L13-20)
#   4. Include spell list references from parent spec

$HeroSubclasses = @(
    @{ Name="ArmsColossus"; Tree="Colossus"; Parent="Arms"; TableUUID="NEW_UUID_1" }
    @{ Name="ArmsSlayers"; Tree="Slayers"; Parent="Arms"; TableUUID="NEW_UUID_2" }
    @{ Name="FuryMountainThane"; Tree="Mountain_Thane"; Parent="Fury"; TableUUID="NEW_UUID_3" }
    @{ Name="FurySlayers"; Tree="Slayers"; Parent="Fury"; TableUUID="NEW_UUID_4" }
    @{ Name="ProtectionMountainThane"; Tree="Mountain_Thane"; Parent="Protection"; TableUUID="NEW_UUID_5" }
    @{ Name="ProtectionColossus"; Tree="Colossus"; Parent="Protection"; TableUUID="NEW_UUID_6" }
)

foreach ($subclass in $HeroSubclasses) {
    # Get 11 hero talents from database where granted_by_subclass contains $subclass.Name
    $HeroTalents = $Database | Where-Object { 
        $_.granted_by_subclass -match $subclass.Name 
    } | Sort-Object { [int]$_.($subclass.Parent + "_unlock") }
    
    # Distribute talents by level
    $TalentsByLevel = @{
        13 = $HeroTalents | Where-Object { [int]$_.($subclass.Parent + "_unlock") -eq 13 }
        15 = $HeroTalents | Where-Object { [int]$_.($subclass.Parent + "_unlock") -eq 15 }
        17 = $HeroTalents | Where-Object { [int]$_.($subclass.Parent + "_unlock") -eq 17 }
        19 = $HeroTalents | Where-Object { [int]$_.($subclass.Parent + "_unlock") -eq 19 }
        20 = $HeroTalents | Where-Object { [int]$_.($subclass.Parent + "_unlock") -eq 20 }
    }
    
    # Generate progression nodes for L13-20
    foreach ($level in 13..20) {
        $PassiveList = ($TalentsByLevel[$level] | Select-Object -ExpandProperty ability_name) -join ';'
        
        # Generate node XML
        # ...
    }
}
```

**Manual validation points**:
- Each hero subclass has exactly 8 nodes (L13-20)
- Each hero subclass grants exactly 11 passives total
- No overlap between subclasses

**Validation**: Run `Validate_HeroSubclass_Progressions.ps1`

---

### STEP 7: Update SpellList_UUID_Mapping.csv (15 minutes)

**Decision**: Use Option A (reuse parent spell lists)

**Script**: `Add_HeroSubclass_SpellLists.ps1`

```powershell
# For each hero subclass L13-20:
#   Copy spell list UUID from parent spec at same level

$Mapping = Import-Csv "SpellList_UUID_Mapping.csv"

$NewMappings = @(
    # ArmsColossus uses Arms spell lists
    @{ Subclass="ArmsColossus"; Level=13; UUID=(Get from Arms L13) }
    @{ Subclass="ArmsColossus"; Level=15; UUID=(Get from Arms L15) }
    # ... etc
)

$Mapping += $NewMappings
$Mapping | Export-Csv "SpellList_UUID_Mapping.csv" -NoTypeInformation
```

**Validation**: CSV has all 9 subclasses with appropriate level ranges

---

### STEP 8: Update SOURCE_OF_TRUTH.md (30 minutes)

**Update sections** as outlined in "SOURCE OF TRUTH UPDATES" above

**Critical updates**:
- [2] FILE 2 status + UUIDs
- [3] Class architecture + subclass hierarchy
- [11] FILE 11 status + node counts
- [1] Database new column documentation

**Validation**: All UUIDs documented, all file statuses updated

---

### STEP 9: Testing (2-3 hours)

#### Test Suite 1: Character Creation
- [ ] Create Warrior character
- [ ] At L1: Choose Arms
- [ ] Verify L3-12 progression (Arms abilities)
- [ ] At L13: See 2 options (Colossus / Slayers)
- [ ] Choose Colossus
- [ ] Verify L13-20 progression (11 Colossus talents, NO Slayers)

#### Test Suite 2: All 6 Subclass Combinations
- [ ] Arms → Colossus (11 Colossus talents)
- [ ] Arms → Slayers (11 Slayers talents)
- [ ] Fury → Mountain Thane (11 Mountain Thane talents)
- [ ] Fury → Slayers (11 Slayers talents)
- [ ] Protection → Mountain Thane (11 Mountain Thane talents)
- [ ] Protection → Colossus (11 Colossus talents)

#### Test Suite 3: Hero Talent Functionality
- [ ] Hero talent passives activate correctly
- [ ] Hero talent abilities work as expected
- [ ] No wrong-tree talents granted
- [ ] No duplicate passives

#### Test Suite 4: Respec
- [ ] Respec at L13+ allows changing hero talent choice
- [ ] Previous hero talents removed
- [ ] New hero talents granted
- [ ] No conflicts or crashes

#### Test Suite 5: Validation Scripts
- [ ] Run all 5 validation scripts
- [ ] All checks pass
- [ ] No errors in console

---

## TOTAL TIME ESTIMATE: 6-8 Hours

| Step | Task | Time | Priority |
|------|------|------|----------|
| 1 | Generate UUIDs | 5 min | P0 |
| 2 | Update Database | 30 min | P0 |
| 3 | Add ClassDescriptions | 1 hour | P0 |
| 4 | Add Localization | 30 min | P0 |
| 5 | Modify Progressions L13 | 30 min | P0 |
| 6 | Generate Hero Progressions | 2-3 hours | P0 |
| 7 | Update SpellList Mapping | 15 min | P1 |
| 8 | Update SOURCE_OF_TRUTH | 30 min | P1 |
| 9 | Testing | 2-3 hours | P0 |
| **TOTAL** | | **7-9 hours** | |

---

## RISK MITIGATION

### Risk 1: BG3 May Not Support Nested Subclass Selection at L13
**Mitigation**: Test with minimal example (1 hero subclass) before implementing all 6

### Risk 2: ParentGuid May Not Filter L13 Options
**Mitigation**: If all 6 options shown, rely on clear naming ("Arms: Colossus" vs "Fury: Mountain Thane")

### Risk 3: Progression Script May Have Errors
**Mitigation**: Generate progressions incrementally, test each subclass before moving to next

### Risk 4: Database Mappings May Be Incorrect
**Mitigation**: Run validation script after database update, before using in progression generation

---

## SUCCESS CRITERIA

Phase 2 is complete when:

✅ **All 10 class descriptions exist** (1 base + 3 specs + 6 hero subclasses)  
✅ **119 progression nodes** (12 base + 54 spec + 48 hero + 5 other)  
✅ **L13 subclass selection works** (2 options per spec)  
✅ **All 6 hero subclasses grant exactly 11 talents** (no more, no less)  
✅ **No talent overlap** (ArmsColossus doesn't grant Slayers talents)  
✅ **All validation scripts pass** (0 errors)  
✅ **In-game testing confirms** (all 6 combinations work)  
✅ **SOURCE_OF_TRUTH.md updated** (all sections accurate)  
✅ **Respec works** (can change hero talent choice)

---

## NEXT ACTIONS

1. **User Approval**: Confirm this comprehensive plan
2. **Create Backup**: Full backup before any changes
3. **Execute Step 1**: Generate UUIDs, document them
4. **Execute Step 2**: Update database with subclass column
5. **Continue sequentially** through steps 3-9
6. **Document any deviations** from plan during implementation

**Ready to proceed?**
