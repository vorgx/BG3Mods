# Cleanup and Consolidation Plan - Post FILE 3

**Date**: October 19, 2025  
**Status**: PAUSING after FILE 3 completion to establish clean source of truth  
**Problem**: Multiple conflicting documents, old data mixed with new, unclear what's current

---

## Current Situation Analysis

### ✅ What's ACTUALLY Complete and Validated

1. **FILE 1: meta.lsx** - Transformed, test passing
2. **FILE 2: ClassDescriptions.lsx** - Transformed, test passing
3. **FILE 3: ActionResourceDefinitions.lsx** - Transformed, test passing

**Location**: `Data/Public/Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7/`

### ❌ What's Causing Confusion

#### Problem 1: Multiple Conflicting Planning Documents

**Root Directory Documents** (outdated/conflicting):
```
ARMS_WARRIOR_FULL_PROGRESSION.md
COMPLETE_LINE_BY_LINE_INVESTIGATION.md
COMPLETE_RESTRUCTURE_REPORT.md
CRASH_DIAGNOSIS_PHASE1.md
FOLDER_CLEANUP_FIXES.md
FOLDER_STRUCTURE_ISSUE.md
IMPLEMENTATION_COMPLETE.md
MINIMAL_TEST_DEPLOYED.md
MINIMAL_TEST_PLAN.md
MISSING_ABILITIES_FULL_LIST.md
PRE_LAUNCH_VALIDATION_COMPLETE.md
PROGRESSION_SYSTEM_MISMATCH_ANALYSIS.md
QUICK_REF_NEW_STRUCTURE.md
QUICK_START_NEXT_SESSION.md
SESSION_COMPLETE_SUMMARY.md
SESSION_HANDOVER_READY_OCT18.md
SESSION_SUMMARY.md
SELECTOR_FIX_COMPLETE.md
TAG_BASED_POOL_SYSTEM_ANALYSIS.md
TESTING_INSTRUCTIONS.md
VALIDATION_REPORT_FULL.md
WARLOCK_AUTOPSY_PLAN.md
WARLOCK_REVERSE_ENGINEERING.md
WORKFLOW_PROTOCOL_ADDED.md
WOW_TALENT_TREE_IMPLEMENTATION_PLAN_v2.md
```

**Reports/ Directory** (new, but some conflicting):
```
FILE_BY_FILE_TRANSFORMATION_PLAN.md
SPELL_LISTS_OPTIONS_COMPARISON.md (outdated - L1-L12 only)
SPELL_LISTS_OPTIONS_REVISED_WITH_L13-20.md (partially outdated)
WARRIOR_ACTUAL_PROGRESSION_STATUS.md (contradicts other docs)
WARRIOR_SPELLLISTS_LEVELBYLEVL_BREAKDOWN.md (newest, but not verified)
```

#### Problem 2: Unclear Source of Truth

**Multiple "truth" sources**:
- `Tests/WARRIOR_BACKUP_BEFORE_TEMPLATE_20251018_183829/` - Old Warrior implementation
- `Data/Public/Warrior_Wow.../` - Current working files (some Warlock template still)
- `Documentation/07_DesignDocuments/Warrior_Class_Blueprint.md` - Design intent
- Multiple planning documents with different spell counts (54 vs 62 SpellLists)

#### Problem 3: File Transformation Strategy Unclear

**Conflicting approaches documented**:
- Option A: Keep Warrior pattern (direct AddSpells)
- Option B: Convert to Warlock pattern (SpellLists)
- Option C: Hybrid approach
- User decision: "both" → convert everything to Warlock pattern

**Not documented**: Actual step-by-step transformation plan for remaining files

---

## Proposed Cleanup Structure

### Phase 1: Archive Old Documents (15 minutes)

Create archive structure to preserve history but remove clutter:

```
Archive/
├── Pre_Template_Sessions/          # Old session docs before Oct 18
│   ├── ARMS_WARRIOR_FULL_PROGRESSION.md
│   ├── COMPLETE_LINE_BY_LINE_INVESTIGATION.md
│   ├── COMPLETE_RESTRUCTURE_REPORT.md
│   ├── CRASH_DIAGNOSIS_PHASE1.md
│   ├── FOLDER_CLEANUP_FIXES.md
│   ├── IMPLEMENTATION_COMPLETE.md
│   ├── MINIMAL_TEST_DEPLOYED.md
│   ├── MINIMAL_TEST_PLAN.md
│   ├── PRE_LAUNCH_VALIDATION_COMPLETE.md
│   ├── PROGRESSION_SYSTEM_MISMATCH_ANALYSIS.md
│   ├── SESSION_COMPLETE_SUMMARY.md
│   ├── SELECTOR_FIX_COMPLETE.md
│   ├── TAG_BASED_POOL_SYSTEM_ANALYSIS.md
│   ├── TESTING_INSTRUCTIONS.md
│   ├── VALIDATION_REPORT_FULL.md
│   └── WARLOCK_AUTOPSY_PLAN.md
│
├── Outdated_Plans/                 # Superseded planning docs
│   ├── SPELL_LISTS_OPTIONS_COMPARISON.md
│   ├── SPELL_LISTS_OPTIONS_REVISED_WITH_L13-20.md
│   ├── WARRIOR_ACTUAL_PROGRESSION_STATUS.md
│   ├── MISSING_ABILITIES_FULL_LIST.md
│   ├── QUICK_REF_NEW_STRUCTURE.md
│   ├── QUICK_START_NEXT_SESSION.md
│   └── WOW_TALENT_TREE_IMPLEMENTATION_PLAN_v2.md
│
└── README.md                       # Explains what's archived and why
```

**Keep in root**:
- `README.md` - Main project overview
- `HANDOVER_FILE_BY_FILE_START.md` - Current session handover
- `INDEX.md` - Navigation

### Phase 2: Create Single Source of Truth Documents (30 minutes)

#### 2.1 Establish Clear Data Sources

**Create**: `Documentation/00_SourcesOfTruth/README.md`

```markdown
# Sources of Truth - Priority Order

## 1. Current Working Implementation (HIGHEST PRIORITY)
**Location**: `Data/Public/Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7/`

**Status by File**:
- ✅ meta.lsx - TRANSFORMED (Warrior UUID, v1.0.1.0)
- ✅ ClassDescriptions.lsx - TRANSFORMED (4 classes defined)
- ✅ ActionResourceDefinitions.lsx - TRANSFORMED (6 resources)
- ❌ Progressions.lsx - WARLOCK TEMPLATE (not transformed)
- ❌ Lists/SpellLists.lsx - WARLOCK CONTENT (not transformed)
- ❌ Lists/PassiveLists.lsx - DOES NOT EXIST
- ❌ Stats/Generated/Data/*.txt - NEEDS REVIEW (may be partial Warrior)

**Last verified**: October 19, 2025

## 2. Original Warrior Backup (REFERENCE ONLY)
**Location**: `Tests/WARRIOR_BACKUP_BEFORE_TEMPLATE_20251018_183829/`

**Purpose**: Source for original Warrior spell progression (L1-L20)
**Warning**: Uses direct AddSpells pattern, NOT Warlock SpellList pattern
**Use for**: Extracting spell names, progression levels, passive names

## 3. Design Documents (DESIGN INTENT)
**Location**: `Documentation/07_DesignDocuments/Warrior_Class_Blueprint.md`

**Purpose**: Intended final design (hero talents, abilities, mechanics)
**Warning**: May not match current implementation
**Use for**: Understanding intended features, not current state

## 4. Working Transformation Plan (CURRENT STRATEGY)
**Location**: `Reports/FILE_BY_FILE_TRANSFORMATION_PLAN.md`

**Purpose**: Step-by-step transformation strategy (FILES 1-15)
**Status**: FILES 1-3 complete, FILES 4-15 pending
**Use for**: Next steps, file priorities, transformation approach
```

#### 2.2 Consolidate Spell/Progression Data

**Create**: `Documentation/00_SourcesOfTruth/WARRIOR_COMPLETE_SPELL_INVENTORY.md`

This document will be the **SINGLE SOURCE** for:
- All spells by level (base class L1-L20)
- All subclass spells (Arms/Fury/Protection L1-L12)
- All hero talent keystone spells (L13)
- All passive names
- Spell file types (Target/Shout/Zone/Jump/Projectile)

**Source**: Extract from `Tests/WARRIOR_BACKUP_BEFORE_TEMPLATE_20251018_183829/Progressions.lsx`

#### 2.3 Create Clear Transformation Plan

**Create**: `Documentation/00_SourcesOfTruth/TRANSFORMATION_STRATEGY_WARLOCK_PATTERN.md`

This document will define:
- **Decision**: Convert ALL Warrior files to Warlock SpellList/PassiveList pattern
- **Why**: Matches proven 13K+ download mod, more flexible for future changes
- **How**: Step-by-step file transformation order (FILES 4-15)
- **Validation**: Tests to verify each transformation

### Phase 3: Reorganize Reports/ Directory (10 minutes)

```
Reports/
├── 00_CURRENT_STATUS.md            # Single status document (FILES 1-3 complete)
├── FILE_BY_FILE_TRANSFORMATION_PLAN.md  # Master plan
├── WARRIOR_SPELLLISTS_LEVELBYLEVL_BREAKDOWN.md  # Keep (verify accuracy first)
└── WARLOCK_REVERSE_ENGINEERING.md  # Keep (reference for pattern)
```

**Archive to Archive/Outdated_Plans/**:
- `SPELL_LISTS_OPTIONS_COMPARISON.md`
- `SPELL_LISTS_OPTIONS_REVISED_WITH_L13-20.md`
- `WARRIOR_ACTUAL_PROGRESSION_STATUS.md`

### Phase 4: Clean Up Test Files (10 minutes)

```
Tests/
├── 02_ExampleMods/                 # Keep (Warlock reference)
│   ├── WoWWarlockHeroTalents/
│   └── ExampleMod_WoWWarlock/
│
├── WARRIOR_BACKUP_BEFORE_TEMPLATE_20251018_183829/  # Keep (source of truth)
│
└── Validation/                     # NEW: Move all test scripts here
    ├── Test-MetaLsx.ps1
    ├── Test-ClassDescriptions.ps1
    ├── Test-ActionResourceDefinitions.ps1
    └── Test-AllFiles.ps1
```

**Move test scripts from `Documentation/08_TransformationTemplates/Tests/` to `Tests/Validation/`**

### Phase 5: Update Root README.md (10 minutes)

Rewrite `README.md` to reflect:
1. Current status (FILES 1-3 complete, paused for cleanup)
2. Clear navigation to source of truth documents
3. Archive location and purpose
4. Next session start point

---

## Cleanup Execution Plan

### Step 1: Create Archive Structure (5 minutes)

```powershell
# Create archive directories
New-Item -ItemType Directory -Path "Archive/Pre_Template_Sessions" -Force
New-Item -ItemType Directory -Path "Archive/Outdated_Plans" -Force

# Create archive README
@"
# Archive Directory

This directory contains documents from previous work sessions and outdated planning documents.

**DO NOT USE** these as source of truth. They are preserved for historical reference only.

## Pre_Template_Sessions/
Documents from before October 18, 2025 template-based transformation approach.

## Outdated_Plans/
Planning documents superseded by newer analysis or contradicted by actual implementation.

**Current source of truth**: See `Documentation/00_SourcesOfTruth/README.md`
"@ | Out-File "Archive/README.md" -Encoding UTF8
```

### Step 2: Move Files to Archive (5 minutes)

```powershell
# Archive old session docs
$PreTemplateDocs = @(
    "ARMS_WARRIOR_FULL_PROGRESSION.md",
    "COMPLETE_LINE_BY_LINE_INVESTIGATION.md",
    "COMPLETE_RESTRUCTURE_REPORT.md",
    "CRASH_DIAGNOSIS_PHASE1.md",
    "FOLDER_CLEANUP_FIXES.md",
    "IMPLEMENTATION_COMPLETE.md",
    "MINIMAL_TEST_DEPLOYED.md",
    "MINIMAL_TEST_PLAN.md",
    "PRE_LAUNCH_VALIDATION_COMPLETE.md",
    "PROGRESSION_SYSTEM_MISMATCH_ANALYSIS.md",
    "SESSION_COMPLETE_SUMMARY.md",
    "SELECTOR_FIX_COMPLETE.md",
    "TAG_BASED_POOL_SYSTEM_ANALYSIS.md",
    "TESTING_INSTRUCTIONS.md",
    "VALIDATION_REPORT_FULL.md",
    "WARLOCK_AUTOPSY_PLAN.md",
    "FOLDER_STRUCTURE_ISSUE.md"
)

foreach ($doc in $PreTemplateDocs) {
    if (Test-Path $doc) {
        Move-Item $doc -Destination "Archive/Pre_Template_Sessions/" -Force
        Write-Host "Archived: $doc" -ForegroundColor Green
    }
}

# Archive outdated plans
$OutdatedPlans = @(
    "Reports/SPELL_LISTS_OPTIONS_COMPARISON.md",
    "Reports/SPELL_LISTS_OPTIONS_REVISED_WITH_L13-20.md",
    "Reports/WARRIOR_ACTUAL_PROGRESSION_STATUS.md",
    "MISSING_ABILITIES_FULL_LIST.md",
    "QUICK_REF_NEW_STRUCTURE.md",
    "QUICK_START_NEXT_SESSION.md",
    "WOW_TALENT_TREE_IMPLEMENTATION_PLAN_v2.md",
    "SESSION_HANDOVER_READY_OCT18.md"
)

foreach ($doc in $OutdatedPlans) {
    if (Test-Path $doc) {
        Move-Item $doc -Destination "Archive/Outdated_Plans/" -Force
        Write-Host "Archived: $doc" -ForegroundColor Green
    }
}
```

### Step 3: Create Source of Truth Directory (10 minutes)

```powershell
New-Item -ItemType Directory -Path "Documentation/00_SourcesOfTruth" -Force

# Will create 3 documents here (see Phase 2 above)
```

### Step 4: Reorganize Test Files (5 minutes)

```powershell
# Create validation directory
New-Item -ItemType Directory -Path "Tests/Validation" -Force

# Move test scripts
$TestScripts = @(
    "Documentation/08_TransformationTemplates/Tests/Test-MetaLsx.ps1",
    "Documentation/08_TransformationTemplates/Tests/Test-ClassDescriptions.ps1",
    "Documentation/08_TransformationTemplates/Tests/Test-ActionResourceDefinitions.ps1",
    "Documentation/08_TransformationTemplates/Tests/Test-AllFiles.ps1"
)

foreach ($script in $TestScripts) {
    if (Test-Path $script) {
        $filename = Split-Path $script -Leaf
        Move-Item $script -Destination "Tests/Validation/$filename" -Force
        Write-Host "Moved: $filename" -ForegroundColor Green
    }
}
```

### Step 5: Clean Up Reports/ Directory (5 minutes)

```powershell
# Create status document
@"
# Current Transformation Status

**Last Updated**: October 19, 2025 (Post-FILE 3 cleanup)

## Completed Files

### ✅ FILE 1: meta.lsx
- **Status**: Transformed and validated
- **Test**: Tests/Validation/Test-MetaLsx.ps1 - PASSING
- **Location**: Data/Mods/BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7/meta.lsx

### ✅ FILE 2: ClassDescriptions.lsx
- **Status**: Transformed and validated
- **Test**: Tests/Validation/Test-ClassDescriptions.ps1 - PASSING
- **Location**: Data/Public/Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7/ClassDescriptions/ClassDescriptions.lsx

### ✅ FILE 3: ActionResourceDefinitions.lsx
- **Status**: Transformed and validated (6 resources)
- **Test**: Tests/Validation/Test-ActionResourceDefinitions.ps1 - PASSING
- **Location**: Data/Public/Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7/ActionResourceDefinitions/ActionResourceDefinitions.lsx

## Pending Transformation

**Strategy**: Convert to Warlock SpellList/PassiveList pattern (user decision: Oct 19, 2025)

### FILES 4-10: Spell Stat Files
- Status: Not started
- See: Reports/FILE_BY_FILE_TRANSFORMATION_PLAN.md

### FILE 11: Progressions.lsx
- Status: Currently Warlock template (needs transformation)
- Requires: SpellLists.lsx completed first

### FILE 12: SpellLists.lsx
- Status: Not created (62 SpellLists needed)
- See: Reports/WARRIOR_SPELLLISTS_LEVELBYLEVL_BREAKDOWN.md

### FILE 13: PassiveLists.lsx
- Status: Not created (25 PassiveLists needed)

## Next Session Start

1. Verify spell inventory accuracy
2. Create FILE 12 (SpellLists.lsx) - 62 entries
3. Create FILE 13 (PassiveLists.lsx) - 25 entries
4. Transform FILES 4-10 (spell stat files)
5. Transform FILE 11 (Progressions.lsx)
"@ | Out-File "Reports/00_CURRENT_STATUS.md" -Encoding UTF8

Write-Host "Created: Reports/00_CURRENT_STATUS.md" -ForegroundColor Green
```

---

## Post-Cleanup File Structure

```
BG3Mods/
├── README.md                       # Updated main overview
├── HANDOVER_FILE_BY_FILE_START.md  # Current session context
├── INDEX.md                        # Navigation
│
├── Archive/                        # Historical documents (DO NOT USE)
│   ├── README.md
│   ├── Pre_Template_Sessions/
│   └── Outdated_Plans/
│
├── Data/                           # Current working mod files
│   ├── Mods/BG3Wow_.../meta.lsx   # ✅ Transformed
│   └── Public/Warrior_Wow_.../
│       ├── ClassDescriptions/      # ✅ Transformed
│       ├── ActionResourceDefinitions/  # ✅ Transformed
│       ├── Progressions/           # ❌ Still Warlock template
│       ├── Lists/                  # ❌ Still Warlock content
│       └── Stats/Generated/Data/   # ❌ Needs review
│
├── Documentation/
│   ├── 00_SourcesOfTruth/          # NEW: Single source of truth
│   │   ├── README.md
│   │   ├── WARRIOR_COMPLETE_SPELL_INVENTORY.md
│   │   └── TRANSFORMATION_STRATEGY_WARLOCK_PATTERN.md
│   │
│   ├── 01_Reference-Guides/
│   ├── 06_ProjectDocuments/
│   ├── 07_DesignDocuments/
│   └── 08_TransformationTemplates/
│
├── Reports/
│   ├── 00_CURRENT_STATUS.md        # NEW: Single status doc
│   ├── FILE_BY_FILE_TRANSFORMATION_PLAN.md
│   ├── WARRIOR_SPELLLISTS_LEVELBYLEVL_BREAKDOWN.md
│   └── WARLOCK_REVERSE_ENGINEERING.md
│
├── Tests/
│   ├── 02_ExampleMods/             # Warlock reference mods
│   ├── WARRIOR_BACKUP_BEFORE_TEMPLATE_.../  # Original Warrior
│   └── Validation/                 # NEW: All test scripts
│       ├── Test-MetaLsx.ps1
│       ├── Test-ClassDescriptions.ps1
│       ├── Test-ActionResourceDefinitions.ps1
│       └── Test-AllFiles.ps1
│
└── Package/                        # Built .pak files
```

---

## Benefits of This Structure

### ✅ Single Source of Truth
- **One location** for current implementation status
- **One location** for spell/progression data
- **One location** for transformation strategy

### ✅ Clear Separation
- **Archive/**: Historical, do not use
- **Documentation/00_SourcesOfTruth/**: Current truth
- **Reports/**: Working documents for current session
- **Tests/Validation/**: All validation scripts together

### ✅ Easy Navigation
- **Reports/00_CURRENT_STATUS.md**: Quick view of progress
- **Documentation/00_SourcesOfTruth/README.md**: Know what to trust
- **No conflicting documents** in root directory

### ✅ Future-Proof
- Clear archive policy (when to move docs to Archive/)
- New sessions can quickly understand project state
- Source of truth is explicitly documented

---

## Execution Timeline

| Step | Task | Time | Result |
|------|------|------|--------|
| 1 | Create Archive structure | 5 min | Archive/ directory with README |
| 2 | Move files to Archive | 5 min | 25+ old docs archived |
| 3 | Create 00_SourcesOfTruth/ | 10 min | 3 source of truth documents |
| 4 | Reorganize test files | 5 min | Tests/Validation/ with 4 scripts |
| 5 | Clean Reports/ | 5 min | 00_CURRENT_STATUS.md created |
| 6 | Update README.md | 5 min | Reflects new structure |
| 7 | Verify cleanup | 5 min | Manual check |

**Total**: ~40 minutes

---

## Validation Checklist

After cleanup, verify:

- [ ] Archive/ contains 25+ old documents
- [ ] Archive/README.md explains purpose
- [ ] Documentation/00_SourcesOfTruth/ has 3 documents
- [ ] Tests/Validation/ has 4 test scripts
- [ ] Reports/ has only 4 current documents
- [ ] Root directory has only README, HANDOVER, INDEX
- [ ] No duplicate/conflicting spell inventory docs
- [ ] Clear transformation strategy documented

---

## Next Session Quick Start

After cleanup:

1. **Read**: `Documentation/00_SourcesOfTruth/README.md` - Know what to trust
2. **Read**: `Reports/00_CURRENT_STATUS.md` - Know what's done
3. **Read**: `Documentation/00_SourcesOfTruth/WARRIOR_COMPLETE_SPELL_INVENTORY.md` - Know the spells
4. **Execute**: Start FILE 12 (SpellLists.lsx creation) with clear data

**No more confusion about old vs new data!**

---

**End of Plan**
