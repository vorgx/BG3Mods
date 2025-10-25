# SOURCE_OF_TRUTH.md - References by Section

**Generated**: October 23, 2025  
**Purpose**: Complete inventory of all references/links used in each section of SOURCE_OF_TRUTH.md

---

## [1] Overview

### External References
- **None** (overview section is self-contained)

### Internal Cross-References
- Section [2] Meta Information (UUID consistency)
- Section [3] Class Details (class attributes, hit dice)
- Section [4] Subclasses (Arms, Fury, Protection details)
- Section [5] Hero Classes (L13-20 specializations)
- Section [6] Progression (level-by-level progression)
- Section [11] File Transformation Status (transformation progress)
- Section [12] Folder Structure (file locations)

### File References
- **Template Mod**: `Tests/02_ExampleMods/ExampleMod_WoWWarlock/` (UUID: `bdb3fa73-401b-4979-f02e-485422dd8d9c`)
- **Backups**: 
  - `Tests/WARRIOR_BACKUP_BEFORE_TEMPLATE_20251018_183829/` (full mod)
  - `Tests/WARRIOR_STATS_BACKUP_20251018_183829/` (stat files only)

### Documentation References
- **Future Classes**: All 12 WoW classes listed (Warlock, Death Knight, Priest, Paladin, Druid, Demon Hunter, Hunter, Mage, Monk, Rogue, Shaman, Evoker)
- **Transformation Templates**: `Transformation_Templates/` folder
- **Reports**: `Reports/02_Transformation/FILE_BY_FILE_TRANSFORMATION_PLAN.md`

---

## [2] Meta Information

### External References
- **None**

### Internal Cross-References
- Section [1] Overview (mod attributes, version info)
- Section [3.1] Base Class Definition (UUID consistency)
- Section [6] Progression (ProgressionTableUUID links)
- Section [11] File Transformation Status (FILE 1 status)
- Section [12] Folder Structure (folder naming)

### File References
- **Actual File**: `Data/Mods/Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7/meta.lsx`
- **Template Reference**: `Transformation_Templates/FILE_01_meta.lsx_TEMPLATE.md`
- **Test Script**: `Transformation_Templates/Tests/Test-MetaLsx.ps1`
- **Comparison Analysis**: `Tests/05_Troubleshooting/COMPREHENSIVE_MOD_COMPARISON.md`

### WoW Reference Mods
- **WoWWarlock**: 13 dependencies, 2 Script entries (working reference)
- **DemonHunter**: 0 dependencies (proves dependencies optional)

### Critical UUIDs
- **Warrior Mod UUID**: `78fe4967-4e62-5491-d981-dd781acca4d7`
- **Folder Pattern**: `Warrior_Wow_{UUID}`

---

## [3] Class Details

### External References
- **None**

### Internal Cross-References
- **[3.1] Base Class Definition**:
  - Section [1] Overview (base class attributes)
  - Section [2] Meta Information (UUID consistency)
  - Section [4] Subclasses (Arms/Fury/Protection ClassDescription nodes)
  - Section [6] Progression (ProgressionTableUUID links)
  - Section [10] Action Resources (Rage system)

- **[3.2] Core Mechanics**:
  - Section [1] Overview (hit dice, ability scores)
  - Section [3.1] Base Class Definition (ClassDescription attributes)
  - Section [3.3] Level-by-Level Features (baseline progression)
  - Section [6] Progression (Progressions.lsx implementation)
  - Section [10] Action Resources (Rage + charge resources)

- **[3.3] Level-by-Level Base Class Features**:
  - Section [3.1] Base Class Definition (base class XML)
  - Section [3.2] Core Mechanics (Rage system, combat mechanics, 12 baseline abilities)
  - Section [4] Subclasses (subclass-specific ability grants)
  - Section [6] Progression (Progressions.lsx implementation)
  - Section [7] Lists - Spells (spell grants per level)

### File References
- **Actual File**: `Data/Public/Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7/ClassDescriptions/ClassDescriptions.lsx`
- **Template**: `Transformation_Templates/FILE_02_ClassDescriptions.lsx_TEMPLATE.md`
- **Test**: `Transformation_Templates/Tests/Test-ClassDescriptions.ps1`

### Excel/CSV References
- **Progression CSV**: `Warrior Progression for all subclasses and Default hero structure.csv`
  - Columns 4-10 (baseline abilities L1-L12)
  - Rows 5-16 (levels 1-12)
- **Analysis Document**: `EXCEL_WARRIOR_PROGRESSION_ANALYSIS.md`

### Supporting Documents
- **Correction Report**: `Documentation/11_ValidationReports/EXCEL_RESCAN_CORRECTIONS_APPLIED.md`
- **Validation**: `Documentation/11_ValidationReports/VALIDATION_STATUS_FINAL.md`
- **SpellLists Reference**: `WARRIOR_SPELLLISTS_LEVELBYLEVL_BREAKDOWN.md`

---

## [4] Subclasses

### External References
- **None**

### Internal Cross-References
- **[4.1] Arms Warrior**:
  - Section [1] Overview (hit dice d10, STR primary)
  - Section [3.1] Base Class Definition (ClassDescriptions.lsx)
  - Section [3.2] Core Mechanics (Rage system, 12 baseline abilities)
  - Section [3.3] Level-by-Level Features (complete L1-L12 Arms ability grants)
  - Section [5] Hero Talents (Colossus + Slayer options at L13-L20)
  - Section [6] Progression (full Progressions.lsx implementation)
  - Section [7] Lists - Spells (Arms ability stat file entries)

- **[4.2] Fury Warrior**:
  - Section [1] Overview (hit dice d8, STR primary)
  - Section [3.1] Base Class Definition (ClassDescriptions.lsx)
  - Section [3.2] Core Mechanics (Rage system, 12 baseline abilities)
  - Section [3.3] Level-by-Level Features (complete L1-L12 Fury ability grants)
  - Section [5] Hero Talents (Mountain Thane + Slayer options at L13-L20)
  - Section [6] Progression (full Progressions.lsx implementation)
  - Section [7] Lists - Spells (Fury ability stat file entries)

- **[4.3] Protection Warrior**:
  - Section [1] Overview (hit dice d12, CON primary)
  - Section [3.1] Base Class Definition (ClassDescriptions.lsx)
  - Section [3.2] Core Mechanics (Rage system, Block mechanic, 12 baseline abilities)
  - Section [3.3] Level-by-Level Features (complete L1-L12 Protection ability grants - 20 baseline abilities)
  - Section [5] Hero Talents (Mountain Thane + Colossus options at L13-L20)
  - Section [6] Progression (full Progressions.lsx implementation)
  - Section [7] Lists - Spells (Protection ability stat file entries)

- **[4.9] Tooltip Archetype Tagging** (PARKED):
  - Section [4.1] Arms Build Archetypes (tooltip tag implementation)
  - Localization: `Tests/03_TestReports/ExtractedPak_StructureFixed/Mods/.../Localization/English/English.loca.xml`

### Excel/CSV References
- **Baseline Abilities**: Columns 4-10, Rows 5-16 (L1-L12)
  - Arms: Columns 4-5
  - Protection: Columns 6-8
  - Fury: Columns 9-10
- **SubclassSpec Talents**:
  - Arms: Columns 24-36 (Rows 1-10)
  - Fury: Columns 37-47 (Rows 1-10)
  - Protection: Columns 48-55 (Rows 1-10)
- **Analysis Document**: `EXCEL_ABILITY_COUNT_SUMMARY.md` (lines 102-367)

### Supporting Documents
- **Arms Implementation**: `ARMS_WARRIOR_IMPLEMENTATION_ROADMAP.md` (767 lines)
- **Fury Implementation**: `FURY_WARRIOR_IMPLEMENTATION_ROADMAP.md` (future)
- **Protection Implementation**: `PROTECTION_WARRIOR_IMPLEMENTATION_ROADMAP.md` (future)
- **Getting Started**: `Documentation/06_ProjectDocuments/GETTING_STARTED.md` (4-week roadmap)
- **Tooltip Feasibility**: `Documentation/07_DesignDocuments/TOOLTIP_ARCHETYPE_TAGGING_FEASIBILITY.md` (400+ lines)
- **Session Milestone**: `Documentation/07_DesignDocuments/TOOLTIP_INNOVATION_SESSION_MILESTONE.md`

---

## [5] Specializations/Hero Classes (L13-20)

### External References
- **None**

### Internal Cross-References
- **[5.1] Mountain Thane**:
  - Section [3.3] Base class L1-12 progression (context for L13 unlock)
  - Section [4.2] Fury build archetypes (Rampage Enrage, AoE Cleave, Bloodthirst synergies)
  - Section [4.3] Protection build archetypes (Shout Master, Block Master, Riposte synergies)

- **[5.2] Colossus**:
  - Section [3.3] Base class L1-12 progression (context for L13 unlock)
  - Section [4.1] Arms build archetypes (Execute Master, Colossus Smash, Two-Handed Focus synergies)
  - Section [4.3] Protection build archetypes (Block Master, Immortal Tank, Shield Slam Burst synergies)

- **[5.3] Slayer**:
  - Section [3.3] Base class L1-12 progression (context for L13 unlock)
  - Section [4.1] Arms build archetypes (Execute Master, Bleed Specialist, AoE Specialist synergies)
  - Section [4.2] Fury build archetypes (Execute Specialist, Recklessness Burst, Dual-Wield Master synergies)

- **[5.4] Comparison Matrix**:
  - Section [4.1], [4.2], [4.3] (all build archetypes)
  - Section [6] Progression (L13-20 integration)

### Excel/CSV References
- **Hero Talents**: Columns 56-64 (confirmed Row 3 header: "Auto Granted")
  - Mountain Thane: Columns 56-58
  - Colossus: Columns 59-61
  - Slayer: Columns 62-64
- **Analysis**: `EXCEL_WARRIOR_PROGRESSION_ANALYSIS.md`

### Database References
- **AbilityDatabase_Warrior_FullyEnriched.csv**: Hero talent ability definitions
  - Demolish: 5d12+STR Physical damage + 2-turn Stun

---

## [6] Progression

### External References
- **None**

### Internal Cross-References
- **[6.1] Arms Progression**:
  - Section [3.3] (L1-L12 baseline)
  - Section [4.1] (Arms spec talents)
  - Section [5.2] Colossus (hero talent option)
  - Section [5.3] Slayer (hero talent option)

- **[6.2] Fury Progression**:
  - Section [3.3] (L1-L12 baseline)
  - Section [4.2] (Fury spec talents)
  - Section [5.1] Mountain Thane (hero talent option)
  - Section [5.3] Slayer (hero talent option)

- **[6.3] Protection Progression**:
  - Section [3.3] (L1-L12 baseline)
  - Section [4.3] (Protection spec talents)
  - Section [5.1] Mountain Thane (hero talent option)
  - Section [5.2] Colossus (hero talent option)

- **[6.8] Progressions.lsx Implementation**:
  - Section [1] Overview (progression structure)
  - Section [2] Meta (ProgressionTableUUID)
  - Section [3] Class Details (base class progression)
  - Section [4] Subclasses (spec progressions)
  - Section [5] Hero Classes (L13-20 auto-grants)
  - Section [7] Lists - Spells (SpellList UUIDs)
  - Section [13] Ability Database (all ability mechanics)

### Excel/CSV References
- **Progression CSV**: `Warrior Progression for all subclasses and Default hero structure.csv`
  - All columns 4-64
  - All rows 5-16 (L1-L12 data)
- **Analysis**: `EXCEL_WARRIOR_PROGRESSION_ANALYSIS.md`

### Supporting Documents
- **BG3 Spell Grant Approaches**: `BG3_SPELL_GRANT_APPROACHES.md` (Zero SpellList vs. Ghost Reference patterns)
- **Template Reference**: WoWWarlock L1 Progression node example

### File References
- **FILE 11**: Progressions.lsx (future transformation)
- **FILE 12**: SpellLists.lsx (creates SpellList UUIDs)
- **FILE 13**: PassiveLists.lsx (creates PassiveList UUIDs)

### Critical Counts
- **SpellList UUIDs needed**: 24 (8 per subclass for baseline L1/L2/L3/L5/L7/L9/L11/L12)
- **PassiveList UUIDs needed**: 34 (9 Class + 8 per subclass + 1 Hero choice)
- **Total UUIDs required**: 58

---

## [7] Lists - Spells

### Status
🚧 **Under Construction** - Content TBD

### Required References (When Built)
- Excel: `Warrior Progression for all subclasses.xlsx`
- Analysis: `EXCEL_ABILITY_COUNT_SUMMARY.md` (complete inventory)
- Estimated ~65 spell entries across all stat files

### Expected File References
- `Spell_Target.txt`
- `Spell_Zone.txt`
- `Spell_Shout.txt`
- `Spell_Jump.txt`
- `Spell_Projectile.txt`

---

## [8] Lists - Status

### Status
🚧 **Under Construction** - Content TBD

### Expected File References
- `Status_BOOST.txt`

---

## [9] Lists - Passive

### Status
🚧 **Under Construction** - Content TBD

### Required References (When Built)
- Excel: `Warrior Progression for all subclasses.xlsx`
- Analysis: `EXCEL_ABILITY_COUNT_SUMMARY.md`
- Estimated ~130+ passive entries

### Expected File References
- `Passive.txt`

---

## [10] Action Resources

### Status
🚧 **Under Construction** - Content TBD

### Expected References
- Section [3.2] Core Mechanics (Rage system, charge resources)
- **Actual File**: `Data/Public/Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7/ActionResourceDefinitions/ActionResourceDefinitions.lsx`
- **Template**: WoWWarlock Soul Shards resource (UUID: `bdb3fa73-401b-4979-f02e-485422dd8d9c`)

### Known Resources (6 Total)
1. **Rage** (UUID: `8fe271a3-3f3c-4170-8c6a-a6eb9b597894`)
2. **MobilityCharge**
3. **ShieldBlockCharge**
4. **EnrageState**
5. **ExecuteWindow**
6. **RiposteCharge**

### Supporting Documents
- `CHARGE_RESOURCES_DEEP_DIVE.md` (corrected max values)
- `RAGE_COMBAT_SIMULATION.md` (5-round balance test)

---

## [11] File Transformation Status

### Status
🚧 **Under Construction** - Content TBD

### Expected References
- **FILES 1-15** transformation templates (`Transformation_Templates/FILE_##_*.md`)
- **Test Scripts**: `Transformation_Templates/Tests/Test-*.ps1`
- **Master Test**: `Test-AllFiles.ps1`
- **Handover Document**: `HANDOVER_FILE_BY_FILE_START.md`

### Current Status (from Overview)
- ✅ FILE 1: meta.lsx (complete, test passing)
- ✅ FILE 2: ClassDescriptions.lsx (complete, test passing)
- ✅ FILE 3: ActionResourceDefinitions.lsx (complete, test passing)
- 📋 FILES 4-15: Pending

---

## [12] Folder Structure Inventory

### External References
- **None**

### Internal Cross-References
- Section [1] Overview (file locations)
- Section [2] Meta (folder naming convention)

### File System References
- **Root**: `BG3Mods/`
- **Data**: `Data/Mods/` and `Data/Public/`
- **Documentation**: `Documentation/` (13 subfolders)
- **Transformation Templates**: `Transformation_Templates/`
- **Tests**: `Tests/` (backups, test scripts, example mods)
- **Package**: `Package/` (built .pak files)
- **Scripts**: `Scripts/`
- **Reports**: `Reports/`
- **LsLib**: `LsLib/` (packaging tools)
- **Backups**: `Backups/` (5 timestamped backups)
- **Archive**: `Archive/` (old/outdated files)

### Recent Organization (October 20, 2025)
- **Documentation/05_SessionReports/**: 10 completion reports
- **Documentation/07_DesignDocuments/**: 6 design/feature reports
- **Documentation/10_SessionSummaries/**: 5 handover documents
- **Documentation/11_ValidationReports/**: 2 validation reports
- **Documentation/04_Organization-Reports/**: 4 organization reports

---

## [13] Master Ability Database

### External WoW References
**Icy-Veins Guides** (Official, Authoritative):
- **Arms**: https://www.icy-veins.com/wow/arms-warrior-pve-dps-spell-summary
- **Protection**: https://www.icy-veins.com/wow/protection-warrior-pve-tank-spell-summary
- **Fury**: https://www.icy-veins.com/wow/fury-warrior-pve-dps-spell-summary

**Wowhead Database**:
- **Main**: https://www.wowhead.com/warrior-abilities
- **Individual Spells**: `https://www.wowhead.com/spell={spell_id}`
  - Example: Execute - https://www.wowhead.com/spell=5308
  - Example: Mortal Strike - https://www.wowhead.com/spell=12294

### Internal Cross-References
- Section [3.2] Core Mechanics (Rage system, resources)
- Section [4] Subclasses (ability lists per spec)
- Section [5] Hero Classes (hero talent abilities)
- Section [6] Progression (when abilities unlock)
- Section [7] Lists - Spells (spell stat files)
- Section [9] Lists - Passive (passive stat files)

### File References
- **Primary Database**: `Documentation/00_SourcesOfTruth/AbilityDatabase_Warrior_FullyEnriched.csv`
  - **Statistics**: 215 abilities (clean), 31 columns
  - **Enriched**: 62 abilities with full WoW + BG3 data (corrected from 46 documented)
- **Original**: `Documentation/00_SourcesOfTruth/AbilityDatabase_Warrior.csv` (pre-enrichment)
- **User Guide**: `Documentation/00_SourcesOfTruth/AbilityDatabase_README.md`
- **Review Queue**: `Documentation/00_SourcesOfTruth/ABILITIES_NEEDING_REVIEW.md` (90 abilities)
- **Completion Summary**: `ENRICHMENT_COMPLETE_SUMMARY.md`
- **Planning**: `Documentation/00_SourcesOfTruth/ABILITY_DATABASE_PLANNING.md`

### Excel/CSV References
- **Progression CSV**: `Documentation/00_SourcesOfTruth/Warrior Progression for all subclasses.csv`
  - Source data for ability extraction

### WoW Extraction Documents
Located in `Documentation/08_WoWSourceMaterial/`:
- `FURY_WARRIOR_ICYVEINS_EXTRACTION.md` (Fury abilities/talents)
- `COLOSSUS_ICYVEINS_EXTRACTION.md` (Colossus hero talents)
- Additional extraction documents for other specs/trees

### Supporting Documents
- **WoW References**: `Documentation/00_SourcesOfTruth/WOW_SOURCE_REFERENCES.md`
- **Charge Resources**: `CHARGE_RESOURCES_DEEP_DIVE.md`
- **Rage Combat**: `RAGE_COMBAT_SIMULATION.md`

### Database Columns (31 Total)
**Core Identification**: ability_id, ability_name, ability_abbreviation, description_short, description_full

**Classification**: ability_type, ability_subtype, archetype_tags

**Progression**: unlock_level, unlock_source, subclass_filter, warrior_unlock, arms_unlock, fury_unlock, protection_unlock

**Dependencies**: requires_ability, unlocks_ability, replaces_ability, modified_by

**Resources**: wow_cost_rage, bg3_action_cost, bg3_resource_cost, bg3_cooldown

**BG3 Implementation**: bg3_file_type, bg3_spell_type, bg3_spell_success, bg3_target_conditions, damage_formula_bg3, status_applied

**Tracking**: implementation_status, implementation_priority, implementation_notes

### Enrichment Scripts
- `COMPREHENSIVE_WOW_ENRICHMENT.ps1` (Phase 3 enrichment)
- Runtime: ~5 seconds for 46 abilities

---

## Cross-Document Reference Map

### Most Referenced Documents
1. **Excel CSV**: Referenced in Sections [3.3], [4.1], [4.2], [4.3], [5], [6], [13]
2. **Section Cross-References**: Nearly every section references multiple other sections
3. **Template Files**: Referenced in Sections [2], [3.1], [4], [11]
4. **WoW Sources**: Referenced only in Section [13] (concentrated authority)

### Most Referenced Sections (Internal)
- **Section [3.3]**: Referenced by [4.1], [4.2], [4.3], [5], [6]
- **Section [6]**: Referenced by [4.1], [4.2], [4.3] (progression blueprint)
- **Section [13]**: Referenced by [6], [7], [9] (ability definitions)

### Documentation Gaps (TBD Sections)
- Section [7] Lists - Spells (needs Excel reference, EXCEL_ABILITY_COUNT_SUMMARY.md)
- Section [8] Lists - Status (needs implementation)
- Section [9] Lists - Passive (needs Excel reference, EXCEL_ABILITY_COUNT_SUMMARY.md)
- Section [11] File Transformation Status (needs FILES 4-15 status)

---

## External URL Summary

### Official WoW Resources (Authoritative)
1. **Icy-Veins Guides** (3 URLs):
   - https://www.icy-veins.com/wow/arms-warrior-pve-dps-spell-summary
   - https://www.icy-veins.com/wow/protection-warrior-pve-tank-spell-summary
   - https://www.icy-veins.com/wow/fury-warrior-pve-dps-spell-summary

2. **Wowhead Database** (base + individual spells):
   - https://www.wowhead.com/warrior-abilities
   - https://www.wowhead.com/spell={spell_id} (pattern for 215 abilities)

### Tools/External Dependencies
- **None documented in SOURCE_OF_TRUTH.md** (tools like LSLib, BG3 Mod Manager mentioned but no URLs)

---

## File Path Summary (Frequently Referenced)

### Primary Data Files
1. `Documentation/00_SourcesOfTruth/Warrior Progression for all subclasses and Default hero structure.csv`
2. `Documentation/00_SourcesOfTruth/AbilityDatabase_Warrior_FullyEnriched.csv`
3. `Documentation/00_SourcesOfTruth/SOURCE_OF_TRUTH.md` (this file)

### Template/Reference Files
1. `Tests/02_ExampleMods/ExampleMod_WoWWarlock/` (entire mod)
2. `Transformation_Templates/FILE_##_*.md` (15 templates)
3. `Transformation_Templates/Tests/Test-*.ps1` (validation scripts)

### Actual Game Files (Implementation)
1. `Data/Mods/Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7/meta.lsx`
2. `Data/Public/Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7/ClassDescriptions/ClassDescriptions.lsx`
3. `Data/Public/Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7/ActionResourceDefinitions/ActionResourceDefinitions.lsx`
4. `Data/Public/Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7/Stats/Generated/Data/*.txt`

### Backup Files
1. `Tests/WARRIOR_BACKUP_BEFORE_TEMPLATE_20251018_183829/`
2. `Tests/WARRIOR_STATS_BACKUP_20251018_183829/`

---

## UUID Reference Summary

### Critical UUIDs (Must Match Everywhere)
- **Warrior Mod UUID**: `78fe4967-4e62-5491-d981-dd781acca4d7`
  - Used in: meta.lsx, folder names, ClassDescriptions.lsx, all documentation

### Template UUIDs (Reference Only)
- **WoWWarlock UUID**: `bdb3fa73-401b-4979-f02e-485422dd8d9c`
  - Used as: Transformation template, pattern reference

### Resource UUIDs
- **Rage UUID**: `8fe271a3-3f3c-4170-8c6a-a6eb9b597894`
  - Used in: ActionResourceDefinitions.lsx

### Placeholder UUIDs (To Be Replaced)
- **SpellList UUID**: `32879c22-4858-48ef-8f8d-22e6d395b396` (dummy from Warlock, keep until FILE 12)
- **ProgressionTableUUID**: `a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d` (placeholder, replace in FILE 4)

---

## Validation Protocols

### Pre-Change Protocol (Every Section References This)
1. Read `Documentation/00_SourcesOfTruth/SOURCE_OF_TRUTH.md` relevant section
2. Use it as baseline for current state
3. Cross-reference with design documents if needed
4. Proceed with change

### Post-Change Protocol (Every Section Must Update)
1. Update SOURCE_OF_TRUTH.md with new information
2. Update "Last Updated" timestamp in changed section
3. Add change log entry with date and reason
4. If creating new files, update [12] Folder Structure Inventory
5. If changing UUIDs/names, update all relevant sections

---

## Summary Statistics

### External URLs
- **Total**: 5 unique URLs (3 Icy-Veins + 2 Wowhead patterns)
- **Most Critical**: Icy-Veins spell summaries (authoritative WoW data)

### Internal Section Cross-References
- **Total**: ~150+ cross-references across 13 sections
- **Most Cross-Referenced Section**: [6] Progression (referenced by 6+ other sections)
- **Most Self-Contained Section**: [1] Overview (fewest external refs)

### File References
- **Primary Data**: 2 files (Progression CSV + Ability Database CSV)
- **Template Files**: 15+ files (FILE_##_*.md templates)
- **Test Scripts**: 10+ files (Test-*.ps1 validation)
- **Supporting Docs**: 50+ files (analysis, reports, guides)

### Excel Column References
- **Most Frequently Referenced**: Columns 4-10 (baseline abilities) across multiple sections
- **Hero Talents**: Columns 56-64 (Section [5] only)
- **Spec Talents**: Columns 24-55 (Sections [4.1], [4.2], [4.3])

---

## Maintenance Notes

### When Adding New Sections
1. Add external URL references (if any)
2. Add internal cross-references to related sections
3. Add file references (Excel, templates, actual files)
4. Add supporting document references
5. Update this reference inventory document

### When Updating Existing Sections
1. Check if new references added → update this document
2. Check if URLs changed → update all occurrences
3. Check if file paths changed → update all occurrences
4. Maintain "Last Updated" timestamps

### Archive Protocol
- **DO NOT** use references from `Archive/` folders
- Always use current references from active documentation
- If historical context needed, explicitly note "Archive" in reference

---

**End of Reference Inventory**
