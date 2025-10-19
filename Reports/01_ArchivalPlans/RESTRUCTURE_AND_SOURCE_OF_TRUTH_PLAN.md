# Complete Restructure & Source of Truth Build Plan

**Date**: October 19, 2025  
**Status**: AWAITING APPROVAL  
**Purpose**: Establish clean folder structure + living Source of Truth document with feedback loops

---

## PHASE 1: FOLDER RESTRUCTURE (Time: 45 minutes)

### Step 1.1: Move Transformation Templates to Root (5 min)

**Action**: `Documentation/08_TransformationTemplates` → `Transformation_Templates` (root)

**What Stays Inside**:
- FILE_01_meta.lsx_TEMPLATE.md
- FILE_02_ClassDescriptions.lsx_TEMPLATE.md
- FILE_03_ActionResourceDefinitions.lsx_TEMPLATE.md
- FILE_03_ActionResourceDefinitions.lsx_COMPLETE.md
- FILE_03_ORGANIZATION_COMPLETE.md
- README.md
- Tests/ folder (all FILE_##_Test-*.ps1 scripts)

**Cross-References to Update**:
1. README.md references to `Documentation/08_TransformationTemplates/` → `Transformation_Templates/`
2. INDEX.md links
3. HANDOVER_FILE_BY_FILE_START.md references
4. Test-AllFiles.ps1 internal paths (if any relative references)

**Validation**:
```powershell
# After move, run tests to verify nothing broke
.\Transformation_Templates\Tests\Test-AllFiles.ps1 -ModPath "C:\...\Data"
```

---

### Step 1.2: Rename Backups Folders (10 min)

**Current State**: All folders named `BEFORE_FULL_RESTRUCTURE_20251018_HHMMSS`

**New Structure**:
```
Backups/
├── 01_Oct18_165343_BeforeFullRestructure/
├── 02_Oct18_165426_BeforeFullRestructure/
├── 03_Oct18_165435_BeforeFullRestructure/
├── 04_Oct18_165449_BeforeFullRestructure/
├── 05_Oct18_165510_BeforeFullRestructure/
└── README.md (NEW - explains backup naming convention)
```

**Naming Convention**: `##_{Date}_{Time}_{Description}`
- Numeric prefix for chronological sorting
- Date in MMM-DD format
- Description of what backup captured

**Backup README Content**:
```markdown
# Backup Naming Convention

Format: `##_{MonthDay}_{Time}_{Description}/`

Example: `01_Oct18_165343_BeforeFullRestructure/`

- **Prefix Number**: Chronological order (01, 02, 03...)
- **Date**: MMM-DD (Oct18, Nov02, etc.)
- **Time**: HHMMSS (24-hour format)
- **Description**: What this backup captured

## Current Backups
1. Oct 18, 2025 16:53:43 - Before full restructure attempt 1
2. Oct 18, 2025 16:54:26 - Before full restructure attempt 2
3. Oct 18, 2025 16:54:35 - Before full restructure attempt 3
4. Oct 18, 2025 16:54:49 - Before full restructure attempt 4
5. Oct 18, 2025 16:55:10 - Before full restructure attempt 5
```

---

### Step 1.3: Sort Root Directory Files (15 min)

**Current Root Clutter** (30+ loose files):
```
ARMS_WARRIOR_FULL_PROGRESSION.md
CLEANUP_AND_CONSOLIDATION_PLAN.md
COMPLETE_LINE_BY_LINE_INVESTIGATION.md
COMPLETE_RESTRUCTURE_REPORT.md
CRASH_DIAGNOSIS_PHASE1.md
DOCUMENTATION_MERGE_COMPLETE.md
DOCUMENTATION_UPDATE_COMPLETE_OCT18.md
FOLDER_CLEANUP_FIXES.md
FOLDER_STRUCTURE_ISSUE.md
HANDOVER_FILE_BY_FILE_START.md
IMPLEMENTATION_COMPLETE.md
MINIMAL_TEST_DEPLOYED.md
MINIMAL_TEST_PLAN.md
MISSING_ABILITIES_FULL_LIST.md
PRE_LAUNCH_VALIDATION_COMPLETE.md
PROGRESSION_SYSTEM_MISMATCH_ANALYSIS.md
QUICK_REF_NEW_STRUCTURE.md
QUICK_START_NEXT_SESSION.md
RESTRUCTURE_COMPLETE_ACTION_ITEMS.md
SELECTOR_FIX_COMPLETE.md
SESSION_COMPLETE_SUMMARY.md
SESSION_HANDOVER_READY_OCT18.md
SESSION_SUMMARY.md
TAG_BASED_POOL_SYSTEM_ANALYSIS.md
TESTING_INSTRUCTIONS.md
VALIDATION_REPORT_FULL.md
WARLOCK_AUTOPSY_PLAN.md
WARLOCK_REVERSE_ENGINEERING.md
WORKFLOW_PROTOCOL_ADDED.md
WOW_TALENT_TREE_IMPLEMENTATION_PLAN_v2.md
+ 10+ .py/.ps1 scripts
```

**Sorting Strategy**:

#### Archive Old Session Docs → `Archive/PreOct19_SessionDocs/`
(Documents from before SOURCE_OF_TRUTH.md was created)
- ARMS_WARRIOR_FULL_PROGRESSION.md
- COMPLETE_LINE_BY_LINE_INVESTIGATION.md
- COMPLETE_RESTRUCTURE_REPORT.md
- CRASH_DIAGNOSIS_PHASE1.md
- FOLDER_CLEANUP_FIXES.md
- FOLDER_STRUCTURE_ISSUE.md
- IMPLEMENTATION_COMPLETE.md
- MINIMAL_TEST_DEPLOYED.md
- MINIMAL_TEST_PLAN.md
- MISSING_ABILITIES_FULL_LIST.md
- PRE_LAUNCH_VALIDATION_COMPLETE.md
- PROGRESSION_SYSTEM_MISMATCH_ANALYSIS.md
- QUICK_REF_NEW_STRUCTURE.md
- QUICK_START_NEXT_SESSION.md
- RESTRUCTURE_COMPLETE_ACTION_ITEMS.md
- SELECTOR_FIX_COMPLETE.md
- SESSION_COMPLETE_SUMMARY.md
- SESSION_HANDOVER_READY_OCT18.md
- SESSION_SUMMARY.md
- TAG_BASED_POOL_SYSTEM_ANALYSIS.md
- TESTING_INSTRUCTIONS.md
- VALIDATION_REPORT_FULL.md
- WOW_TALENT_TREE_IMPLEMENTATION_PLAN_v2.md

#### Move to Reports/ → `Reports/ArchivalPlans/`
- CLEANUP_AND_CONSOLIDATION_PLAN.md (superseded by this plan)
- WARLOCK_AUTOPSY_PLAN.md (completed, archived for reference)

#### Move to Documentation/ → `Documentation/00_SourcesOfTruth/`
- WARLOCK_REVERSE_ENGINEERING.md (reference material)

#### Move to Scripts/ folder
- analyze_lists_files.py
- analyze_working_mods.py
- apply_warlock_template.ps1
- check_resource_node_id.py
- complete_restructure.py
- convert_selectors.py
- convert_selectors_final.py
- convert_selectors_v2.py
- fix_progressions_complete.py
- fix_progressions_final.py
- fix_with_xml_parser.py
- fix_xml_corruption.py
- remove_hero_talents.py
- restructure_action_resources.py
- restructure_progressions.py
- restructure_summary.py
- validate_all_files.py
- validate_spell_references.ps1
- View_Logs.ps1

#### Move to Archive/ → `Archive/TemporaryFiles/`
- temp_backup.lsx
- restructure_output.txt
- working_mods_analysis.txt

#### Move to Documentation/05_SessionReports/ (Current Session Records)
- DOCUMENTATION_MERGE_COMPLETE.md (current session record)
- DOCUMENTATION_UPDATE_COMPLETE_OCT18.md (current session record)
- WORKFLOW_PROTOCOL_ADDED.md (active protocol)

#### Keep in Root (Essential Files Only)
- HANDOVER_FILE_BY_FILE_START.md (current session context - user requested)
- INDEX.md (navigation hub)
- README.md (project overview - GitHub convention)
- settings.json (VS Code config)
- BG3Mods.code-workspace (VS Code workspace)

---

### Step 1.4: Sort Tests/ Directory (5 min)

**Current Structure**:
```
Tests/
├── 01_ValidationReports/
├── 02_ExampleMods/
├── 03_TestReports/
├── 05_Troubleshooting/
├── WARRIOR_BACKUP_BEFORE_TEMPLATE_20251018_183829/
└── Loose files (11 markdown docs)
```

**Issues**:
- Missing `04_` folder (gap in numbering)
- 11 loose markdown files in root

**New Structure**:
```
Tests/
├── 01_ValidationReports/ (keep as-is)
├── 02_ExampleMods/ (keep as-is)
├── 03_TestReports/ (keep as-is)
├── 04_Backups/
│   └── WARRIOR_BACKUP_BEFORE_TEMPLATE_20251018_183829/
├── 05_Troubleshooting/ (keep as-is)
└── 06_SessionReports/
    ├── WARLOCK_COMPLETE_REPORT.md
    ├── SESSION_SUMMARY_OFFICIAL_GUIDE_INTEGRATION.md
    ├── ROOT_CAUSE_IDENTIFIED.md
    ├── PROGRESSIONS_STRUCTURE_ANALYSIS.md
    ├── PROGRESSIONS_RESTRUCTURE_COMPLETE.md
    ├── LOCALIZATION_XML_FIX.md
    ├── LISTS_FIX_COMPLETE.md
    ├── GUID_HANDLES_CONVERSION.md
    ├── DEATHKNIGHT_COMPLETE_REPORT.md
    ├── COMPREHENSIVE_VALIDATION_FINDINGS.md
    ├── COMPLETE_RESTRUCTURE_FINAL.md
    └── CLASS_VISIBILITY_FIX_MISSING_FILES.md
```

---

### Step 1.5: Sort Reports/ Directory (5 min)

**Current Structure**: 26 markdown files (mostly loose in root)

**New Structure**:
```
Reports/
├── 00_CURRENT_STATUS.md (current state - keep in root)
├── 01_ArchivalPlans/
│   ├── CLEANUP_AND_CONSOLIDATION_PLAN.md
│   └── WARLOCK_AUTOPSY_PLAN.md
├── 02_Transformation/
│   ├── FILE_BY_FILE_TRANSFORMATION_PLAN.md
│   ├── MASTER_TRANSFORMATION_PLAN.md
│   ├── 07_DETAILED_TRANSFORMATION_PLAN.md
│   ├── 06_WARLOCK_TEMPLATE_PLAN.md
│   ├── 05_SOLUTION_READY.md
│   ├── 04_ROOT_CAUSE_IDENTIFIED.md
│   ├── 03_CRITICAL_DISCOVERY_STAT_FILES.md
│   ├── 02_WEBSITE_TO_FILES_MAPPING.md
│   ├── 01_FILE_INVENTORY.md
│   └── 00_AUTOPSY_SUMMARY.md
├── 03_FileDecisions/
│   ├── FILE_03_DECISION_SUMMARY.md
│   ├── FILE_03_APPROVED_OPTION_B_MODIFIED.md
│   └── PHASE3_LISTS_STRATEGIC_DECISION.md
├── 04_Analysis/
│   ├── WARRIOR_SPELLLISTS_LEVELBYLEVL_BREAKDOWN.md
│   ├── WARRIOR_ACTUAL_PROGRESSION_STATUS.md
│   ├── WARRIOR_CHARGE_RESOURCE_ANALYSIS.md
│   ├── SPELL_LISTS_OPTIONS_REVISED_WITH_L13-20.md
│   ├── SPELL_LISTS_OPTIONS_COMPARISON.md
│   ├── RESOURCE_ACTIVATION_SYSTEM.md
│   ├── DELETED_WARLOCK_CONTENT_REFERENCE.md
│   ├── CRITICAL_HERO_TALENTS_ANALYSIS.md
│   ├── COMPLETE_HERO_TALENTS_ANALYSIS.md
│   ├── CHARGE_RESOURCES_DEEP_DIVE.md
│   └── CHARGE_MODIFICATION_OPPORTUNITIES.md
└── README.md (navigation for Reports/)
```

---

### Step 1.6: Sort Documentation/ Directory (5 min)

**Issues**:
- Duplicate folder numbers: `06_ProjectDocuments/` AND `06_SessionSummaries/`
- Duplicate folder numbers: `08_TransformationTemplates/` AND `08_WoWSourceMaterial/`
- Duplicate folder numbers: `10_ValidationReports/` AND `11_SessionSummaries/`
- 4 loose markdown files in root

**New Structure**:
```
Documentation/
├── 00_SourcesOfTruth/ (NEW - Living document goes here)
│   ├── SOURCE_OF_TRUTH.md (THE living document)
│   ├── README.md (explains priority, feedback loops)
│   └── WARLOCK_REVERSE_ENGINEERING.md (reference material)
├── 01_Reference-Guides/ (keep)
├── 02_Setup-Guides/ (keep)
├── 03_Workflows/ (keep)
├── 04_Organization-Reports/ (keep)
├── 05_SessionReports/ (RENAME from 05_SessionReports/)
├── 06_ProjectDocuments/ (keep)
├── 07_DesignDocuments/ (keep)
├── 08_WoWSourceMaterial/ (RENAME from 08_WoWSourceMaterial/)
├── 09_ResearchFindings/ (keep)
├── 10_SessionSummaries/ (CONSOLIDATE 06_SessionSummaries + 11_SessionSummaries → here)
├── 11_ValidationReports/ (RENAME from 10_ValidationReports/)
└── 12_ReferenceMods/ (keep)
```

**Loose Files** → Move to `Archive/Documentation_RootClutter/`:
- BACKUP_Documentation_Files.txt
- BACKUP_MyDocumentation_Files.txt
- DOCUMENTATION_AUDIT_CORRECTIONS_REQUIRED.md
- DOCUMENTATION_CORRECTION_SESSION_SUMMARY.md
- DOCUMENTATION_MASS_UPDATE_SCRIPT.md
- EXTRACTED_FILES_CORRECTION_COMPLETE.md

---

### Step 1.7: Sort Package/ Directory (Already Clean ✅)

**Current Structure**:
```
Package/
├── README.md
├── INSTALL_GUIDE.md
├── CHANGELOG.md
├── TEST_INSTRUCTIONS.md
├── RETENTION_POLICY.md
└── (Built .pak files)
```

**Status**: ✅ Already well-organized, no changes needed

---

## PHASE 2: IMPLEMENT FEEDBACK LOOPS (Time: 30 min) ⭐ MOVED BEFORE PHASE 3

**Why This Order**: Establishes protocols BEFORE creating SOURCE_OF_TRUTH.md content, ensuring feedback loops are active during all documentation work (2-3 hours).

### Step 2.1: Update copilot-instructions.md (20 min)

Add new protocol section to `.github/copilot-instructions.md`:

```markdown
## Source of Truth Protocol (CRITICAL - ALWAYS FOLLOW)

### Pre-Change Protocol
**BEFORE making ANY code or file changes**:
1. Read relevant section of `Documentation/00_SourcesOfTruth/SOURCE_OF_TRUTH.md`
2. Use it as baseline for current state
3. Cross-reference with design documents if needed
4. Proceed with change

### Post-Change Protocol
**AFTER any change + tests pass**:
1. Update SOURCE_OF_TRUTH.md with new information
2. Update "Last Updated" timestamp in changed section
3. Add "Changed by" note with date and reason
4. If creating new files, update [12] Folder Structure Inventory
5. If changing UUIDs/names, update all relevant sections

### File Creation Protocol
**BEFORE creating new files**:
1. Check [12] Folder Structure Inventory in SOURCE_OF_TRUTH.md
2. Determine correct folder location
3. Present location to user for confirmation
4. Create file in confirmed location
5. Update SOURCE_OF_TRUTH.md folder inventory

### Cross-Reference Protocol
**WHEN moving/renaming files or folders**:
1. Search SOURCE_OF_TRUTH.md for all references to old path/name
2. Update ALL references to new path/name
3. Search codebase for broken links
4. Update README.md, INDEX.md, HANDOVER docs
5. Run all tests to verify nothing broke
6. Update SOURCE_OF_TRUTH.md with rename record

### Archive Protocol
**DO NOT use information from Archive/** folders unless explicitly asked
- Archive folders contain outdated information
- Always use SOURCE_OF_TRUTH.md as primary reference
- If user asks about history, check Archive/ AFTER checking SOURCE_OF_TRUTH.md
```

---

### Step 2.2: Create SOURCE_OF_TRUTH.md Structure (10 min)

Create initial document with header + 12 empty sections (content filled in Phase 3):

**Location**: `Documentation/00_SourcesOfTruth/SOURCE_OF_TRUTH.md`

```markdown
# Warrior Mod - Complete Source of Truth

**Living Document - Always Current**

## Document Metadata

**Created**: October 19, 2025  
**Last Major Update**: October 19, 2025  
**Current Mod Version**: v1.0.1.0  
**Game Version**: Patch 8 (BG3 v4.8.0.10)

## Change Log (Last 10 Updates)

| Date | Section | Change | Reason |
|------|---------|--------|--------|
| Oct 19, 2025 | [All] | Created initial structure | Establish SOURCE_OF_TRUTH framework |

## How to Use This Document

### For AI Agents:
1. **ALWAYS read relevant section BEFORE making changes**
2. **ALWAYS update section AFTER changes + tests pass**
3. **NEVER skip cross-reference validation**
4. **NEVER use Archive/ information without user request**

### For Users:
- This is the single source of truth for the Warrior mod
- All information is current and validated
- Archive/ folders contain old/outdated information
- Check "Last Updated" timestamps to see freshness

### Sections:
1. [Overview](#1-overview)
2. [Meta Information](#2-meta-information)
3. [Class Details](#3-class-details)
4. [Subclasses](#4-subclasses)
5. [Specializations/Hero Classes](#5-specializationshero-classes-l13-20)
6. [Progression](#6-progression)
7. [Lists - Spells](#7-lists---spells)
8. [Lists - Status](#8-lists---status)
9. [Lists - Passive](#9-lists---passive)
10. [Action Resources](#10-action-resources)
11. [File Transformation Status](#11-file-transformation-status)
12. [Folder Structure Inventory](#12-folder-structure-inventory)

---

## [1] Overview
**Status**: 🚧 Under Construction  
**Last Updated**: TBD

(Content will be added in Phase 3)

---

## [2] Meta Information
**Status**: 🚧 Under Construction  
**Last Updated**: TBD

(Content will be added in Phase 3)

---

## [3] Class Details
**Status**: 🚧 Under Construction  
**Last Updated**: TBD

(Content will be added in Phase 3)

---

## [4] Subclasses
**Status**: 🚧 Under Construction  
**Last Updated**: TBD

(Content will be added in Phase 3)

---

## [5] Specializations/Hero Classes (L13-20)
**Status**: 🚧 Under Construction  
**Last Updated**: TBD

(Content will be added in Phase 3)

---

## [6] Progression
**Status**: 🚧 Under Construction  
**Last Updated**: TBD

(Content will be added in Phase 3)

---

## [7] Lists - Spells
**Status**: 🚧 Under Construction  
**Last Updated**: TBD

(Content will be added in Phase 3)

---

## [8] Lists - Status
**Status**: 🚧 Under Construction  
**Last Updated**: TBD

(Content will be added in Phase 3)

---

## [9] Lists - Passive
**Status**: 🚧 Under Construction  
**Last Updated**: TBD

(Content will be added in Phase 3)

---

## [10] Action Resources
**Status**: 🚧 Under Construction  
**Last Updated**: TBD

(Content will be added in Phase 3)

---

## [11] File Transformation Status
**Status**: 🚧 Under Construction  
**Last Updated**: TBD

(Content will be added in Phase 3)

---

## [12] Folder Structure Inventory
**Status**: 🚧 Under Construction  
**Last Updated**: TBD

(Content will be added in Phase 3)
```

**Result**: SOURCE_OF_TRUTH.md exists with structure, ready for content population with protocols active.

---

## PHASE 3: BUILD SOURCE OF TRUTH CONTENT (Time: 2-3 hours)

**With Feedback Loops Active** ✅

### Framework: Living Document with Feedback Loops

**Location**: `Documentation/00_SourcesOfTruth/SOURCE_OF_TRUTH.md`

**Principle**: Single source of truth that is ALWAYS updated when ANY file changes

**Feedback Loop Rules** (enforced in copilot-instructions.md):

1. **BEFORE any code/file change**:
   - Read relevant section of SOURCE_OF_TRUTH.md
   - Use it as the baseline

2. **AFTER any code/file change + tests pass**:
   - Update SOURCE_OF_TRUTH.md with new information
   - Update "Last Updated" timestamp
   - Document what changed and why

3. **BEFORE creating new files**:
   - Scan folder structure in SOURCE_OF_TRUTH.md
   - Determine correct location
   - Get user confirmation
   - Create file
   - Update SOURCE_OF_TRUTH.md folder inventory

4. **Cross-Reference Validation**:
   - When moving/renaming folders: Update all references in SOURCE_OF_TRUTH.md
   - When creating templates: Update template inventory section
   - When adding tests: Update test inventory section

---

### Document Structure (12 Sections)

#### Section [1] Overview (15 min)
**Process with Feedback Loops Active**:
1. Gather information from sources (listed below)
2. Write comprehensive overview content
3. Remove "🚧 Under Construction" marker
4. Update "Last Updated" timestamp
5. Add change log entry: "Section [1] completed - Initial overview from meta.lsx, templates, handover docs"
6. Confirm accuracy with user

**Content**:
- Project name: BG3Wow - Baldur's Gate 3 Warrior Class Mod
- Mod UUID: `78fe4967-4e62-5491-d981-dd781acca4d7`
- Current version: v1.0.1.0
- Game version: Patch 8 (BG3 v4.8.0.10)
- Template approach: Based on WoWWarlock mod (13K+ downloads)
- Transformation status: FILES 1-3 complete, FILES 4-15 pending

**Sources**:
- `Data/Mods/.../meta.lsx` (for UUID, version)
- `Transformation_Templates/FILE_01_meta.lsx_TEMPLATE.md`
- `HANDOVER_FILE_BY_FILE_START.md`

---

#### Section [2] Meta Information (10 min)
**Process with Feedback Loops Active**:
1. Extract data from meta.lsx and templates
2. Write content
3. Update section status and timestamp
4. Add change log entry
5. Validate with FILE_01 test
**Content**:
- Mod folder structure (Mods/ and Public/ paths)
- UUID consistency across files
- Version management (Version64, PublishVersion)
- Dependencies (all 13 + Gustav)
- Author, Name, Description

**Sources**:
- `Data/Mods/BG3Wow_78fe4967.../meta.lsx`
- `Transformation_Templates/FILE_01_meta.lsx_TEMPLATE.md`
- `Transformation_Templates/Tests/FILE_01_Test-MetaLsx.ps1` (validation rules)

**Validation**:
- Run FILE_01 test to verify accuracy
- Cross-reference with Warlock template

---

#### Section [3] Class Details (15 min)
**Process with Feedback Loops Active**:
1. Gather from ClassDescriptions.lsx and FILE_02 template
2. Write base Warrior details (HP, primary ability, equipment)
3. Remove construction marker
4. Update timestamp
5. Add change log entry

**Content**:
- Base class: Warrior
  - UUID: `78fe4967-4e62-5491-d981-dd781acca4d7`
  - HP: 10 (BaseHp) + 10 per level (HpPerLevel)
  - Primary Ability: Strength (1)
  - Spell Casting Ability: Strength (1)
  - Class Equipment: Barbarian
  - Sound Class Type: Barbarian
  - Can Learn Spells: false
  - Must Prepare Spells: false
  - Localization: DisplayName, Description handles

**Sources**:
- `Data/Public/.../ClassDescriptions/ClassDescriptions.lsx`
- `Transformation_Templates/FILE_02_ClassDescriptions.lsx_TEMPLATE.md`
- `Documentation/07_DesignDocuments/Warrior_Class_Blueprint.md`

**Validation**:
- Run FILE_02 test
- Compare with Warrior_Class_Blueprint.md design intent

---

#### Section [4] Subclasses (30 min)
**Process with Feedback Loops Active**:
1. Gather from ClassDescriptions.lsx, Warrior backups, design docs
2. Write Arms/Fury/Protection details with L1-L12 progression
3. Remove construction marker
4. Update timestamp
5. Add change log entry

**Content for EACH subclass** (Arms, Fury, Protection):

**Arms Warrior**:
- UUID: (extract from ClassDescriptions.lsx)
- ParentGuid: Links to base Warrior UUID
- DisplayName/Description: Localization handles
- Primary Ability: Strength
- Specialization: Two-handed weapon master
- HP: Same as base (10/10)
- Starting equipment: (from ClassDescriptions.lsx)
- Key mechanics: Mortal Strike, Colossus Smash, Overpower
- Progression L1-L12: (full spell list from Progressions.lsx backup)
- Hero talent options: Colossus OR Slayer

**Fury Warrior**:
- [Same structure]
- Specialization: Dual-wield berserker
- Key mechanics: Bloodthirst, Rampage, Raging Blow
- Hero talent options: Mountain Thane OR Slayer

**Protection Warrior**:
- [Same structure]
- Specialization: Sword and shield tank
- Key mechanics: Shield Slam, Shield Block, Revenge
- Hero talent options: Mountain Thane OR Colossus

**Sources**:
- `Data/Public/.../ClassDescriptions/ClassDescriptions.lsx`
- `Tests/WARRIOR_BACKUP_BEFORE_TEMPLATE_.../Progressions/Progressions.lsx` (spell lists)
- `Documentation/07_DesignDocuments/Warrior_Class_Blueprint.md`
- `Reports/WARRIOR_SPELLLISTS_LEVELBYLEVL_BREAKDOWN.md`

**Validation**:
- Cross-reference spell lists with stat files
- Verify hero talent compatibility matrix

---

#### Section [5] Specializations/Hero Classes L13-20 (45 min)
**Process with Feedback Loops Active**:
1. Gather from Passives.txt, design docs, progression tables
2. Write Mountain Thane/Colossus/Slayer details (keystones, choice nodes)
3. Remove construction marker
4. Update timestamp
5. Add change log entry

**Content for EACH hero specialization** (Mountain Thane, Colossus, Slayer):

**Mountain Thane** (4-tier):
- Available to: Fury + Protection
- Keystone (L13): (spell/passive name, effect)
- Choice nodes:
  - L15: (2 options with names + effects)
  - L16: (2 options)
  - L18: (2 options)
  - L19: (2 options)
- Capstone (L20): (conditional application via IF(HasPassive()))
- Passive list UUIDs: (for SelectPassives in Progressions.lsx)

**Colossus** (3-tier):
- Available to: Arms + Protection
- Keystone (L13): WAR_Colossus_Keystone
- Grants spell: WAR_Demolish
- Choice nodes:
  - L15: (2-3 options)
  - L17: (2-3 options)
  - L19: (2-3 options)
- Capstone (L20): WAR_Colossus_PreciseMight status
- Passive list UUIDs: (to be created in FILE 13)

**Slayer** (3-tier):
- Available to: Arms + Fury
- [Same structure]

**Sources**:
- `Documentation/07_DesignDocuments/Warrior_Class_Blueprint.md` (design intent)
- `Tests/WARRIOR_BACKUP_BEFORE_TEMPLATE_.../Progressions/Progressions.lsx` (L20 conditional logic)
- `Reports/COMPLETE_HERO_TALENTS_ANALYSIS.md`
- `Reports/CRITICAL_HERO_TALENTS_ANALYSIS.md`

**Note**: Hero talents NOT YET IMPLEMENTED (L13-L19 nodes empty in backup)

---

#### Section [6] Progression (60 min)
**Process with Feedback Loops Active**:
1. Gather from Progressions.lsx backup, design docs, spell lists
2. Build L1-L20 tables for base + 3 subclasses
3. Remove construction marker
4. Update timestamp
5. Add change log entry

**Content**: Complete level-by-level breakdown for L1-L20

**Base Class Progression** (all Warriors):
| Level | Spells | Passives | Notes |
|-------|--------|----------|-------|
| 1 | Charge, Heroic Strike | UnlockRage, RageGeneration | Starting abilities |
| 2 | Battle Shout | - | Party buff |
| 3 | Execute | - | Low-HP finisher |
| 4 | - | - | Feat/ASI |
| 5 | - | ExtraAttack | Attack twice |
| ... | ... | ... | ... |
| 20 | - | - | Feat/ASI + Hero capstone |

**Arms Progression** (L1-L12):
| Level | Spells | Passives | Notes |
| ... | ... | ... | ... |

**Fury Progression** (L1-L12):
| Level | Spells | Passives | Notes |
| ... | ... | ... | ... |

**Protection Progression** (L1-L12):
| Level | Spells | Passives | Notes |
| ... | ... | ... | ... |

**Hero Talent Progression** (L13-L20):
| Level | Arms Options | Fury Options | Protection Options |
|-------|--------------|--------------|-------------------|
| 13 | Colossus OR Slayer keystone | Mountain Thane OR Slayer | Mountain Thane OR Colossus |
| 14 | (empty - base class spell) | (empty) | (empty) |
| 15 | Choice node | Choice node | Choice node |
| ... | ... | ... | ... |

**Sources**:
- `Tests/WARRIOR_BACKUP_BEFORE_TEMPLATE_.../Progressions/Progressions.lsx` (all 527 lines)
- `Reports/WARRIOR_SPELLLISTS_LEVELBYLEVL_BREAKDOWN.md`
- `Documentation/07_DesignDocuments/Warrior_Class_Blueprint.md`

**Validation**:
- Every spell reference must exist in stat files
- Every passive reference must exist in Passive.txt
- Cross-check with Warrior_Class_Blueprint.md design

---

#### Section [7] Lists - Spells (30 min)
**Process with Feedback Loops Active**:
1. Gather from SpellLists.lsx template, Warrior backups, stat files
2. Build comprehensive 62-list inventory with UUIDs
3. Remove construction marker
4. Update timestamp
5. Add change log entry

**Content**: Complete inventory of ALL spells with metadata

**SpellLists.lsx Structure** (62 total):
- 20 Base Warrior (L1-L20): List names, UUIDs, spell contents
- 12 Arms (L1-L12): List names, UUIDs, spell contents
- 12 Fury (L1-L12): List names, UUIDs, spell contents
- 12 Protection (L1-L12): List names, UUIDs, spell contents
- 6 Hero Keystones (L13): List names, UUIDs, spell unlocks

**Spell Inventory by Type**:

**Spell_Target.txt** (single-target):
- WAR_Charge
- WAR_HeroicStrike
- WAR_Execute
- [... complete list with descriptions]

**Spell_Shout.txt** (self-buffs/AoE buffs):
- WAR_BattleShout
- WAR_DefensiveStance
- [... complete list]

**Spell_Zone.txt** (ground-targeted AoE):
- WAR_Revenge
- WAR_Whirlwind
- [... complete list]

**Spell_Jump.txt** (gap closers):
- WAR_HeroicLeap
- WAR_Intervene
- [... complete list]

**Sources**:
- `Data/Public/.../Stats/Generated/Data/Spell_*.txt` (current implementation)
- `Tests/WARRIOR_BACKUP_BEFORE_TEMPLATE_.../Stats/` (original implementation)
- `Reports/WARRIOR_SPELLLISTS_LEVELBYLEVL_BREAKDOWN.md`
- `Documentation/06_ProjectDocuments/ABILITY_IMPLEMENTATION_INVENTORY.md`

**Validation**:
- Every spell in progression tables exists in stat files
- Every stat file entry has localization handles
- SpellLists.lsx structure matches Warlock pattern

---

#### Section [8] Lists - Status (20 min)
**Process with Feedback Loops Active**:
1. Gather from Status_BOOST.txt, design docs
2. Catalog all buffs/debuffs with effects
3. Remove construction marker
4. Update timestamp
5. Add change log entry

**Content**: All status effects (buffs/debuffs)

**Status_BOOST.txt Inventory**:
- WAR_ENRAGED (Rage active state)
- WAR_BATTLE_SHOUT (Attack bonus buff)
- WAR_DEFENSIVE_STANCE (Damage reduction)
- WAR_AVATAR (Ultimate form transformation)
- WAR_COLOSSUS_PRECISEMIGHT (Hero talent L20 capstone)
- WAR_SLAYER_MALICE (Hero talent L20 capstone)
- WAR_MOUNTAINTHANE_GATHERINGSTORMS (Hero talent L20 capstone)
- [... complete list with durations, effects, stacking rules]

**Sources**:
- `Data/Public/.../Stats/Generated/Data/Status_BOOST.txt`
- `Tests/WARRIOR_BACKUP_BEFORE_TEMPLATE_.../Stats/Status_BOOST.txt`
- Grep search for `ApplyStatus()` in all spell files

**Validation**:
- Every ApplyStatus() reference in spells has matching status entry
- All status entries have localization handles

---

#### Section [9] Lists - Passive (20 min)
**Process with Feedback Loops Active**:
1. Gather from Passive.txt, PassiveLists.lsx template, design docs
2. Organize by category (base/subclass/hero talents)
3. Remove construction marker
4. Update timestamp
5. Add change log entry

**Content**: All passive abilities

**Passive.txt Inventory**:

**Base Class Passives**:
- WAR_UnlockRage
- WAR_RageGeneration
- WAR_InspiringPresence
- ExtraAttack (Larian default)
- ImprovedExtraAttack (Larian default)

**Arms Passives**:
- WAR_ARMS_WeaponMastery
- WAR_ARMS_TacticalMastery

**Fury Passives**:
- WAR_FURY_DualWieldMastery
- WAR_FURY_Bloodbath

**Protection Passives**:
- WAR_PROT_ShieldSpecialization

**Hero Talent Passives** (NOT YET IMPLEMENTED):
- WAR_Colossus_Keystone
- WAR_Slayer_Keystone
- WAR_MountainThane_Keystone
- [... all choice node passives]

**Sources**:
- `Data/Public/.../Stats/Generated/Data/Passive.txt`
- `Tests/WARRIOR_BACKUP_BEFORE_TEMPLATE_.../Stats/Passive.txt`
- `Documentation/06_ProjectDocuments/PASSIVES_*.md` files

**Validation**:
- Every PassivesAdded reference in Progressions.lsx exists in Passive.txt
- Every IF(HasPassive()) check references valid passive

---

#### Section [10] Action Resources (10 min)
**Process with Feedback Loops Active**:
1. Extract from ActionResourceDefinitions.lsx and FILE_03 template
2. Document all 6 resources with UUIDs and purposes
3. Remove construction marker
4. Update timestamp
5. Add change log entry

**Content**: Custom resources for abilities

**ActionResourceDefinitions.lsx** (6 resources):
1. **Rage**
   - UUID: a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d
   - MaxLevel: 100
   - ReplenishType: Default (manual via abilities)
   - Purpose: Primary resource for all Warrior abilities

2. **DefensiveCharge**
   - UUID: e7f8a9b0-1c2d-3e4f-5a6b-7c8d9e0f1a2b
   - MaxLevel: 1
   - ReplenishType: Rest
   - Purpose: Shield Block tracking (Protection)

3. **TankCooldown**
   - UUID: b3c4d5e6-f7a8-9b0c-1d2e-3f4a5b6c7d8e
   - MaxLevel: 1
   - ReplenishType: Rest
   - Purpose: Shield Wall tracking (Protection)

4. **MobilityCharge**
   - UUID: c9d8e7f6-5a4b-3c2d-1e0f-9b8a7c6d5e4f
   - MaxLevel: 2
   - ReplenishType: ShortRest
   - Purpose: Heroic Leap + Charge tracking

5. **OverpowerCharge**
   - UUID: d1e2f3a4-b5c6-7d8e-9f0a-1b2c3d4e5f6a
   - MaxLevel: 2
   - ReplenishType: Default
   - Purpose: Overpower tracking (Arms)

6. **ThunderCharge**
   - UUID: e5f6a7b8-c9d0-1e2f-3a4b-5c6d7e8f9a0b
   - MaxLevel: 3
   - ReplenishType: Default
   - Purpose: Thunder Clap tracking (Mountain Thane hero talent)

**Sources**:
- `Data/Public/.../ActionResourceDefinitions/ActionResourceDefinitions.lsx`
- `Transformation_Templates/FILE_03_ActionResourceDefinitions.lsx_TEMPLATE.md`
- `Reports/FILE_03_APPROVED_OPTION_B_MODIFIED.md`

**Validation**:
- Run FILE_03 test
- Cross-reference with spell UseCosts

---

#### Section [11] File Transformation Status (15 min)
**Process with Feedback Loops Active**:
1. Review all FILE_## templates and tests
2. Build completion tracker table
3. Remove construction marker
4. Update timestamp after EVERY file transformation completion
5. Add change log entry

**Content**: Track which files complete, which pending

**Transformation Template Status**:
| File # | Name | Status | Test | Template Doc | Last Updated |
|--------|------|--------|------|--------------|--------------|
| 1 | meta.lsx | ✅ COMPLETE | PASS | FILE_01_meta.lsx_TEMPLATE.md | Oct 19, 2025 |
| 2 | ClassDescriptions.lsx | ✅ COMPLETE | PASS | FILE_02_ClassDescriptions.lsx_TEMPLATE.md | Oct 19, 2025 |
| 3 | ActionResourceDefinitions.lsx | ✅ COMPLETE | PASS | FILE_03_ActionResourceDefinitions.lsx_TEMPLATE.md | Oct 19, 2025 |
| 4-10 | Stats/*.txt files | ⏸️ PENDING | N/A | Not yet created | - |
| 11 | Progressions.lsx | ⏸️ PENDING | N/A | Not yet created | - |
| 12 | SpellLists.lsx | ⏸️ PENDING | N/A | Not yet created | - |
| 13 | PassiveLists.lsx | ⏸️ PENDING | N/A | Not yet created | - |
| 14 | Localization (English.loca.xml) | ⏸️ PENDING | N/A | Not yet created | - |
| 15 | Script Extender | ⏸️ PENDING | N/A | Not yet created | - |

**Next Priority**: FILES 12-13 (SpellLists + PassiveLists) → FILE 11 (Progressions) → FILES 4-10 (Stats)

**Sources**:
- `Transformation_Templates/` (all FILE_## docs)
- `Transformation_Templates/Tests/` (all FILE_##_Test-*.ps1)
- `Reports/FILE_BY_FILE_TRANSFORMATION_PLAN.md`

---

#### Section [12] Folder Structure Inventory (15 min)
**Process with Feedback Loops Active**:
1. Run list_dir on all major folders
2. Document current structure with file placement rules
3. Remove construction marker
4. Update timestamp after ANY folder restructuring
5. Add change log entry

**Content**: Complete project organization reference

**Root Directory**:
```
BG3Mods/
├── Data/ (MOD FILES - NEVER MOVE)
├── Transformation_Templates/ (moved from Documentation/)
├── Archive/ (old docs, don't use for new work)
├── Backups/ (timestamped mod backups)
├── Documentation/ (organized reference materials)
├── LsLib/ (packaging tool)
├── Package/ (built .pak files)
├── Reports/ (analysis and planning docs)
├── Scripts/ (automation scripts)
├── Tests/ (validation, examples, troubleshooting)
├── INDEX.md (navigation)
├── README.md (project overview)
├── HANDOVER_FILE_BY_FILE_START.md (current session)
└── [Other active session docs]
```

**Documentation/ Subfolders**:
```
00_SourcesOfTruth/ (THIS DOCUMENT + references)
01_Reference-Guides/ (BG3 modding references)
02_Setup-Guides/ (installation, tools)
03_Workflows/ (development processes)
04_Organization-Reports/ (folder structure docs)
05_SessionReports/ (session summaries)
06_ProjectDocuments/ (ability inventories, guides)
07_DesignDocuments/ (Warrior_Class_Blueprint.md)
08_WoWSourceMaterial/ (WoW reference docs)
09_ResearchFindings/ (discoveries, patterns)
10_SessionSummaries/ (historical session records)
11_ValidationReports/ (test results, validations)
12_ReferenceMods/ (example mod docs)
```

**File Placement Rules**:
- **New reports** → `Reports/04_Analysis/`
- **New session summaries** → `Documentation/05_SessionReports/`
- **New templates** → `Transformation_Templates/FILE_##_{Name}_TEMPLATE.md`
- **New tests** → `Transformation_Templates/Tests/FILE_##_Test-{Name}.ps1`
- **Scripts** → `Scripts/` folder
- **Old docs** → `Archive/` with timestamp subfolder

**Sources**:
- Current directory listing (`list_dir` of all folders)
- `INDEX.md` (current navigation structure)

---

## IMPLEMENTATION TIMELINE

| Phase | Task | Time | Total |
|-------|------|------|-------|
| **PHASE 1: RESTRUCTURE** | | | **45 min** |
| 1.1 | Move Transformation Templates to root | 5 min | 5 min |
| 1.2 | Rename Backups folders | 10 min | 15 min |
| 1.3 | Sort root directory files | 15 min | 30 min |
| 1.4 | Sort Tests/ directory | 5 min | 35 min |
| 1.5 | Sort Reports/ directory | 5 min | 40 min |
| 1.6 | Sort Documentation/ directory | 5 min | 45 min |
| 1.7 | Package/ (already clean) | 0 min | 45 min |
| **PHASE 2: FEEDBACK LOOPS** ⭐ | | | **30 min** |
| 2.1 | Update copilot-instructions.md | 20 min | 65 min |
| 2.2 | Create SOURCE_OF_TRUTH.md structure | 10 min | 75 min |
| **PHASE 3: SOURCE OF TRUTH CONTENT** | | | **2-3 hours** |
| 3.1 | Section [1] Overview | 15 min | 90 min |
| 3.2 | Section [2] Meta Information | 10 min | 100 min |
| 3.3 | Section [3] Class Details | 15 min | 115 min |
| 3.4 | Section [4] Subclasses (3×) | 30 min | 145 min |
| 3.5 | Section [5] Hero Classes (3×) | 45 min | 190 min |
| 3.6 | Section [6] Progression tables | 60 min | 250 min |
| 3.7 | Section [7] Spell Lists | 30 min | 280 min |
| 3.8 | Section [8] Status Lists | 20 min | 300 min |
| 3.9 | Section [9] Passive Lists | 20 min | 320 min |
| 3.10 | Section [10] Action Resources | 10 min | 330 min |
| 3.11 | Section [11] Transformation Status | 15 min | 345 min |
| 3.12 | Section [12] Folder Inventory | 15 min | 360 min |

**GRAND TOTAL**: ~6 hours (can split across multiple sessions)

---

## VALIDATION CHECKLIST

After completion, verify:

### Restructure Validation
- [ ] Transformation_Templates/ in root (not in Documentation/)
- [ ] All tests still pass: `.\Transformation_Templates\Tests\Test-AllFiles.ps1`
- [ ] Backups/ folders renamed with numeric prefixes
- [ ] Root directory has <10 loose files
- [ ] Tests/ has no loose markdown files (all in subfolders)
- [ ] Reports/ organized into 5 subfolders
- [ ] Documentation/ no duplicate folder numbers
- [ ] All cross-references updated (README.md, INDEX.md, HANDOVER.md)

### Source of Truth Validation
- [ ] SOURCE_OF_TRUTH.md exists in `Documentation/00_SourcesOfTruth/`
- [ ] All 12 sections complete with comprehensive information
- [ ] Every section cites source files with paths
- [ ] Change log header present
- [ ] copilot-instructions.md updated with protocol
- [ ] Folder Structure Inventory matches actual structure
- [ ] Transformation Status table accurate

### Feedback Loop Validation
- [ ] Test: Make small change → SOURCE_OF_TRUTH.md updated
- [ ] Test: Create new file → Folder inventory updated
- [ ] Test: Move folder → Cross-references updated
- [ ] Test: Archive old doc → Not referenced in SOURCE_OF_TRUTH.md

---

## RECOMMENDATIONS FOR IMPROVEMENT

1. **Automated Change Tracking**:
   - Add Git pre-commit hook to remind about SOURCE_OF_TRUTH.md updates
   - PowerShell script to auto-update "Last Updated" timestamps

2. **Section Linking**:
   - Add hyperlinks between related sections (e.g., spell references link to [7] Lists)
   - Cross-reference table: "Spell X → defined in [7], used in Progression [6], granted by SpellList [UUID]"

3. **Version Control**:
   - Tag each SOURCE_OF_TRUTH.md version when cutting new mod release
   - Keep historical versions: `SOURCE_OF_TRUTH_v1.0.0.md`, `SOURCE_OF_TRUTH_v1.0.1.md`

4. **Validation Script**:
   - PowerShell script: Check if all spells in Progressions exist in stat files
   - PowerShell script: Check if all status references have definitions
   - Run before packaging mod

5. **Visual Diagrams**:
   - Add Mermaid diagram for hero talent tree relationships
   - Add flowchart for resource consumption (Rage → abilities → status effects)

---

## APPROVAL REQUIRED

**User**: Please review this plan and confirm:

1. **Restructure approach** (Phase 1): Moving folders, renaming, sorting files
2. **SOURCE_OF_TRUTH.md structure** (Phase 2): 12 sections covering all aspects
3. **Feedback loop rules** (Phase 3): Pre/post-change protocols
4. **Timeline**: ~6 hours total (can split into sessions)
5. **Additional recommendations**: Implement now or later?

Once approved, I will execute this plan step-by-step with confirmation at each major milestone.

**Reply "APPROVED" to begin execution, or suggest modifications.**

---

**End of Plan**
