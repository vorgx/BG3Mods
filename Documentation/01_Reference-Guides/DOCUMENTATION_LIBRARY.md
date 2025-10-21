# BG3Wow - Documentation Library

**Purpose**: Comprehensive topic-based index categorizing all internal documentation + external resources (18+ URLs) with source location tags.  
**Last Updated**: October 17, 2025  
**Usage**: Use Ctrl+F to search by topic, tool name, or file type.

---

## 📚 **Topic Categories**

1. [BG3 Modding Fundamentals](#bg3-modding-fundamentals)
2. [File Format Syntax](#file-format-syntax)
3. [Packaging & Distribution](#packaging--distribution)
4. [Localization & Translation](#localization--translation)
5. [Dependencies & Compatibility](#dependencies--compatibility)
6. [Validation & Testing](#validation--testing)
7. [Class & Ability Design](#class--ability-design)
8. [Race & Character Creation](#race--character-creation)
9. [Script Extender (SE) Integration](#script-extender-se-integration)
10. [LSLib & Tooling](#lslib--tooling)
11. [Community Resources](#community-resources)
12. [WoW→BG3 Conversion Patterns](#wowbg3-conversion-patterns)
13. [Project Management](#project-management)

---

## 🧭 **Source Location Tags**

- **[INT]** = Internal Documentation (My Documentation/, Tests/, Root .md files)
- **[EXT]** = External URL (bg3.wiki, GitHub, etc.)
- **[TOOL]** = Tool-specific documentation (LSLib, Multitool, etc.)
- **[CODE]** = Python scripts, automation tools

---

## 1. BG3 Modding Fundamentals

### **Getting Started**
| Topic | Source | Location | Description |
|-------|--------|----------|-------------|
| BG3 Modding Overview | [INT] | `My Documentation/01_ProjectDocuments/GETTING_STARTED.md` | 4-week roadmap for building WoW class mods |
| ⭐ **Basic Class Creation Guide** | [EXT] | https://wiki.bg3.community/Tutorials/Classes/Basic-Class-Creation | **REQUIRED READING** - Complete step-by-step class creation tutorial with ALL required files |
| Modding Resources Hub | [EXT] | https://bg3.wiki/wiki/Modding:Modding_resources | Official BG3 wiki modding homepage (tools, paths, sites) |
| Creating Mods Guide | [EXT] | https://bg3.wiki/wiki/Modding:Creating_mods | Step-by-step tutorials for creating BG3 mods |
| Getting Started with BG3 Modding | [EXT] | https://bg3.wiki/wiki/Modding:Getting_Started_with_BG3_Modding | Official beginner's guide |
| Tutorials Hub | [EXT] | https://bg3.wiki/wiki/Modding:Tutorials | Comprehensive tutorial index (hair, heads, armor, races) |

### **Folder Structure**
| Topic | Source | Location | Description |
|-------|--------|----------|-------------|
| Mod Folder Structure | [EXT] | https://bg3.wiki/wiki/Understanding_Mod_Folder_Structure | Official folder hierarchy documentation |
| BG3-Modders-Multitool Workspace Structure | [EXT] | https://github.com/ShinyHobo/BG3-Modders-Multitool/wiki/Mod-Workspace-Structure | **MANDATORY** Data/ folder structure (DO NOT MODIFY) |
| File Reference Guide | [INT] | `My Documentation/01_ProjectDocuments/FILE_REFERENCE.md` | BG3 file format syntax examples (.lsx, .txt, .loca.xml) |

---

## 2. File Format Syntax

### **LSX Files (XML-Editable)**
| Topic | Source | Location | Description |
|-------|--------|----------|-------------|
| Working with LSX Files | [EXT] | https://bg3.wiki/wiki/Modding:Working_with_LSX_files | LSX file structure, node hierarchy, attribute types |
| Unpacking & Converting Files | [EXT] | https://bg3.wiki/wiki/Modding:Unpacking_and_converting_files | .lsf ↔ .lsx conversions, .gr2 ↔ .dae conversions |
| meta.lsx Creation Guide | [EXT] | https://bg3.wiki/wiki/Modding:Creating_meta.lsx | UUID generation, Version64 format, folder naming rules |
| File Reference (Internal) | [INT] | `My Documentation/01_ProjectDocuments/FILE_REFERENCE.md` | BG3Wow-specific file syntax examples |

### **TXT Files (Stats Format)**
| Topic | Source | Location | Description |
|-------|--------|----------|-------------|
| Spell_*.txt Format | [INT] | `Data/Public/.../Stats/Generated/Data/*.txt` | Larian's custom key-value format (`data "key" "value"`) |
| Ability Implementation Inventory | [INT] | `My Documentation/01_ProjectDocuments/ABILITY_IMPLEMENTATION_INVENTORY.md` | Tracks complete vs. missing abilities (9 incomplete) |
| Sunder Armor Implementation | [INT] | `Tests/01_ValidationReports/SUNDER_ARMOR_IMPLEMENTATION.md` | Full ability implementation workflow example |

### **LOCA.XML Files (Localization)**
| Topic | Source | Location | Description |
|-------|--------|----------|-------------|
| Localization Guide | [EXT] | https://bg3.wiki/wiki/Modding:Localization | Handle format (h[8hex][2digit]), translation patches |
| Localization Fix Complete | [INT] | `LOCALIZATION_FIX_COMPLETE.md` (root) | Resolved missing handle issues |
| Sunder Armor Localization | [INT] | `Tests/01_ValidationReports/SUNDER_ARMOR_LOCALIZATION.md` | Example localization workflow |

---

## 3. Packaging & Distribution

### **LSLib Packaging**
| Topic | Source | Location | Description |
|-------|--------|----------|-------------|
| Packaging Guide | [INT] | `PACKAGING_GUIDE.md` (root) | LSLib packaging workflow (208 lines), PowerShell scripts |
| Quick Package Reference | [INT] | `QUICK_PACKAGE.md` (root) | 3 packaging methods quick reference (74 lines) |
| Packaging Mods | [EXT] | https://bg3.wiki/wiki/Modding:Packaging_mods | Multitool vs. LSLIB packaging methods |
| LSLib GitHub | [EXT] [TOOL] | https://github.com/Norbyte/lslib | LSLib v1.20.3+ (REQUIRED for Patch 8) |

### **Installation**
| Topic | Source | Location | Description |
|-------|--------|----------|-------------|
| Installing Mods Guide | [EXT] | https://bg3.wiki/wiki/Modding:Installing_mods | BG3 Mod Manager, modsettings.lsx, load order |
| Install Guide | [INT] | `Package/INSTALL_GUIDE.md` | Installation instructions for BG3Wow |

---

## 4. Localization & Translation

### **Creating Localizations**
| Topic | Source | Location | Description |
|-------|--------|----------|-------------|
| Localization Guide | [EXT] | https://bg3.wiki/wiki/Modding:Localization | contentuid handles, version increments, language folders |
| English.loca.xml Format | [INT] | `Data/Public/.../Localization/English/English.loca.xml` | User-facing text with h[8hex][2digit] handles |
| Localization Complete | [INT] | `Tests/LOCALIZATION_COMPLETE.md` | Localization completion status |

### **Handle Format**
- **Pattern**: `h[8 hex chars][2 digit counter]` (e.g., `h125abc01`, `h125abc02`)
- **Increment**: `h125abc01` → `h125abc02` → `h125abc03`
- **Location**: `<content contentuid="h125abc01" version="1">Text Here</content>`

---

## 5. Dependencies & Compatibility

### **Mod Dependencies**
| Topic | Source | Location | Description |
|-------|--------|----------|-------------|
| Dependencies Guide | [EXT] | https://bg3.wiki/wiki/Modding:Dependencies | Vanilla dependencies (Shared, SharedDev, Gustav, GustavDev) |
| Compatibility Framework | [EXT] | https://bg3.wiki/wiki/Modding:Compatibility_Framework | JSON vs. Lua methods for race compatibility |
| Community Library Wiki | [EXT] | https://github.com/BG3-Community-Library-Team/BG3-Community-Library/wiki | Shared spells, scripts, items, races, passives |

### **Compatibility Framework**
- **JSON Method**: `Mods/YourShared/ScriptExtender/CompatibilityFrameworkConfig.json`
- **Lua Method**: `Mods/YourShared/ScriptExtender/Lua/BootstrapClient.lua`
- **Load Order**: Compatibility Framework MUST be at bottom of load order

---

## 6. Validation & Testing

### **Automated Validation** ✨ NEW
| Topic | Source | Location | Description |
|-------|--------|----------|-------------|
| **validate_mod_structure.ps1** | [CODE] | `validate_mod_structure.ps1` (root) | **Automated mod structure validation** (270+ lines): UUID consistency, XML syntax, localization handles, stat file format, cross-references. Run before packaging: `powershell -ExecutionPolicy Bypass -File .\validate_mod_structure.ps1 -Verbose` |
| **pre_package_checklist.md** | [INT] | `pre_package_checklist.md` (root) | **6-phase release workflow** (500+ lines): Pre-Validation, Cross-Reference, Packaging, Testing, Archival, Distribution. Step-by-step with PowerShell commands and troubleshooting. |
| Package Archival Script | [CODE] | `Package/ARCHIVE_PACKAGES.ps1` | Automated .pak archival to version subfolders. Run with `-WhatIf` for dry-run. |
| Tests Migration Script | [CODE] | `Tests/MIGRATE_TESTS.ps1` | Automated Tests/ folder reorganization (15 validation reports, 3 example mods, 5 extracted content items). |

### **Validation Reports** (Moved to Tests/01_ValidationReports/)
| Topic | Source | Location | Description |
|-------|--------|----------|-------------|
| Validation Status (Final) | [INT] | `Tests/01_ValidationReports/VALIDATION_STATUS_FINAL.md` | ✅ 95% ready for in-game testing (100 lines) |
| Comprehensive Validation Report | [INT] | `Tests/01_ValidationReports/COMPREHENSIVE_VALIDATION_REPORT.md` | Full validation checklist |
| Cooldown Verification Report | [INT] | `Tests/01_ValidationReports/COOLDOWN_VERIFICATION_REPORT.md` | Cooldown syntax verification |
| Quick Validation Checklist | [INT] | `Tests/01_ValidationReports/QUICK_VALIDATION_CHECKLIST.md` | Quick pre-flight checks |
| Warrior Abilities Validation | [INT] | `Tests/01_ValidationReports/WARRIOR_ABILITIES_VALIDATION_REPORT.md` | Abilities validation report |

### **Testing Workflows**
| Topic | Source | Location | Description |
|-------|--------|----------|-------------|
| Testing Workflow | [INT] | `PROJECT_INDEX.md` (this project) | Package → Install → BG3MM → Launch → SE logs |
| Debugging Crashes | [INT] | `DEBUGGING_CRASHES.md` (root) | Crash diagnosis procedures |
| SE Debugging Guide | [INT] | `SE_DEBUGGING_GUIDE.md` (root) | Script Extender log analysis |

### **Example Mods** (Moved to Tests/02_ExampleMods/)
| Topic | Source | Location | Description |
|-------|--------|----------|-------------|
| Example Mods Folder | [INT] | `Tests/02_ExampleMods/` | Reference implementations: ExampleMod_5eSpells, ExampleMod_WoWWarlock (critical for WoW patterns), MinimalMod (bootstrapping template) |
| Example Mods README | [INT] | `Tests/02_ExampleMods/README.md` | Comparison table, integration workflows, UUID warnings |

---

## 7. Class & Ability Design

### **Class Creation**
| Topic | Source | Location | Description |
|-------|--------|----------|-------------|
| Building a Class Mod | [EXT] | https://github.com/BG3-Community-Library-Team/BG3-Community-Library/wiki/Building-a-Class-Mod | Community Library class mod tutorial (ClassDescriptions, Progressions, Abilities) |
| Class Blueprint Template | [INT] | `My Documentation/02_DesignDocuments/Class Blueprint Template Full v1.md` | Master WoW→BG3 class conversion template |
| Ability Design Framework | [INT] | `Tests/ABILITY_DESIGN_FRAMEWORK.md` | Ability design patterns |

### **Ability Implementation**
| Topic | Source | Location | Description |
|-------|--------|----------|-------------|
| Ability Implementation Inventory | [INT] | `My Documentation/01_ProjectDocuments/ABILITY_IMPLEMENTATION_INVENTORY.md` | Tracks complete vs. missing abilities (9 incomplete) |
| Charge Implementation Notes | [INT] | `My Documentation/01_ProjectDocuments/CHARGE_IMPLEMENTATION_NOTES.md` | Gap closer mechanics |
| Sunder Armor Implementation | [INT] | `Tests/SUNDER_ARMOR_IMPLEMENTATION.md` | Full ability implementation workflow |

### **Passives**
| Topic | Source | Location | Description |
|-------|--------|----------|-------------|
| Passives Breakdown | [INT] | `My Documentation/01_ProjectDocuments/PASSIVES_BREAKDOWN.md` | Passive ability definitions |
| Passives Colossus | [INT] | `My Documentation/01_ProjectDocuments/PASSIVES_COLOSSUS.md` | Colossus spec passives (L13-20), copy-paste ready |

---

## 8. Race & Character Creation

### **Race Creation**
| Topic | Source | Location | Description |
|-------|--------|----------|-------------|
| Building a Race Mod | [EXT] | https://github.com/BG3-Community-Library-Team/BG3-Community-Library/wiki/Building-a-Race-Mod | Community Library race mod tutorial (RaceEntry, RootTemplates, Visuals, Progressions) |
| Race UUID Reference | [EXT] | https://bg3.wiki/wiki/Modding:Race_UUID | Race UUIDs (Humanoid: 899d275e-9893-490a-9cd5-be856794929f) |
| Editing Character Creation Preset | [EXT] | https://bg3.wiki/wiki/Modding:Editing_a_Character_Creation_Preset | Character creation preset modifications |

### **Code Snippets**
| Topic | Source | Location | Description |
|-------|--------|----------|-------------|
| Code Snippets | [EXT] | https://bg3.wiki/wiki/Modding:Code_Snippets | Race UUIDs, item UUIDs, enemy types, treasure tables, RootTemplate IDs |

---

## 9. Script Extender (SE) Integration

### **Setup & Configuration**
| Topic | Source | Location | Description |
|-------|--------|----------|-------------|
| Script Extender GitHub | [EXT] [TOOL] | https://github.com/Norbyte/bg3se | BG3 Script Extender main repo |
| SE API Documentation | [EXT] [TOOL] | https://github.com/Norbyte/bg3se/blob/main/Docs/API.md | Lua/Osiris API documentation (1464 lines), ECS system |
| SE Lua Setup Guide | [EXT] [TOOL] | https://github.com/Norbyte/bg3se/blob/main/Docs/LuaSetup.md | Config.json, Bootstrap scripts, BootstrapServer/Client.lua |
| SE Integration Complete | [INT] | `SE_INTEGRATION_COMPLETE.md` (root) | SE integration validation |
| SE Debugging Guide | [INT] | `SE_DEBUGGING_GUIDE.md` (root) | Log analysis patterns |

### **Lua Scripting**
| Topic | Source | Location | Description |
|-------|--------|----------|-------------|
| Bootstrap Scripts | [INT] | `Data/Mods/.../ScriptExtender/Lua/Bootstrap*.lua` | BG3Wow SE debugging scripts |
| SE Logs | [TOOL] | `%LOCALAPPDATA%\Larian Studios\Baldur's Gate 3\ScriptExtender\Logs\` | Runtime logs (search for `[BG3WOW]`) |

---

## 10. LSLib & Tooling

### **LSLib**
| Topic | Source | Location | Description |
|-------|--------|----------|-------------|
| LSLib GitHub | [EXT] [TOOL] | https://github.com/Norbyte/lslib | LSLib v1.20.3+ (REQUIRED for Patch 8) |
| Divine.exe (GUI) | [TOOL] | `LsLib/Tools/Divine.exe` | GUI packaging tool |
| ConverterApp.exe (CLI) | [TOOL] | `LsLib/ConverterApp.exe` | CLI packaging tool |

### **BG3-Modders-Multitool**
| Topic | Source | Location | Description |
|-------|--------|----------|-------------|
| Multitool GitHub | [EXT] [TOOL] | https://github.com/ShinyHobo/BG3-Modders-Multitool | Asset unpacking, PAK creation, indexing |
| Multitool Workspace Structure | [EXT] [TOOL] | https://github.com/ShinyHobo/BG3-Modders-Multitool/wiki/Mod-Workspace-Structure | **MANDATORY** Data/ folder structure |

### **BG3 Tools Wiki**
| Topic | Source | Location | Description |
|-------|--------|----------|-------------|
| Modding Tools | [EXT] | https://bg3.wiki/wiki/Modding:Tools | LSLib, Multitool, BG3 Mini Tool, Creator's Cauldron, Blender plugins |

---

## 11. Community Resources

### **BG3 Community Library**
| Topic | Source | Location | Description |
|-------|--------|----------|-------------|
| Community Library Wiki | [EXT] | https://github.com/BG3-Community-Library-Team/BG3-Community-Library/wiki | Shared spells, scripts, items, races, passives for compatibility |
| Contributing to CL | [EXT] | https://github.com/BG3-Community-Library-Team/BG3-Community-Library/wiki/Making-Contributions | How to contribute to Community Library |
| Using CL Content | [EXT] | https://github.com/BG3-Community-Library-Team/BG3-Community-Library/wiki/Using-Community-Library-Content | How to use Community Library in your mod |

### **Visual Effects**
| Topic | Source | Location | Description |
|-------|--------|----------|-------------|
| Creating Custom VFX | [EXT] | https://github.com/ImmortalRDI/BG3-Community-Library/wiki | ImmortalRDI's in-depth VFX guide (Effects, MultiEffectInfos, RootTemplates, LSFX) |

---

## 12. WoW→BG3 Conversion Patterns

### **Class Blueprint**
| Topic | Source | Location | Description |
|-------|--------|----------|-------------|
| Class Blueprint Template | [INT] | `My Documentation/02_DesignDocuments/Class Blueprint Template Full v1.md` | Master WoW→BG3 conversion template |
| WoW Source Material | [INT] | `My Documentation/03_WoWSourceMaterial/` | WoW Warrior class source data |
| README.md | [INT] | `README.md` (root) | WoW Warrior class blueprint (128 lines) |

### **WoW Hero Talent HTML References** ✨ NEW
| Topic | Source | Location | Description |
|-------|--------|----------|-------------|
| **Arms Warrior - Slayer** | [EXT-LOCAL] | `c:\WowSource\Arms Warrior DPS Guide - The War Within 11.2 - Wowhead - Slayer.html` | Slayer hero talents (Arms+Fury) with tooltips, tree structure, prerequisites |
| **Arms Warrior - Colossus** | [EXT-LOCAL] | `c:\WowSource\Arms Warrior DPS Guide - The War Within 11.2 - Wowhead- Colossus.html` | Colossus hero talents (Arms+Protection) with tooltips, tree structure, prerequisites |
| **Fury Warrior - Mountain Thane** | [EXT-LOCAL] | `c:\WowSource\Fury Warrior DPS Guide - The War Within 11.2 - Wowhead - Mountain Thane.html` | Mountain Thane hero talents (Protection+Fury) with tooltips, tree structure, prerequisites |
| **Fury Warrior - Slayer** | [EXT-LOCAL] | `c:\WowSource\Fury Warrior DPS Guide - The War Within 11.2 - Wowhead - Slayer.html` | Slayer hero talents (Arms+Fury) with tooltips, tree structure, prerequisites |
| **Protection Warrior - Colossus** | [EXT-LOCAL] | `c:\WowSource\Protection Warrior Tank Guide - The War Within 11.2 - Wowhead - Colossus.html` | Colossus hero talents (Arms+Protection) with tooltips, tree structure, prerequisites |
| **Protection Warrior - Mountain Thane** | [EXT-LOCAL] | `c:\WowSource\Protection Warrior Tank Guide - The War Within 11.2 - Wowhead - Mountain Thane.html` | Mountain Thane hero talents (Protection+Fury) with tooltips, tree structure, prerequisites |

### **Reference Mods**
| Topic | Source | Location | Description |
|-------|--------|----------|-------------|
| WoWPriest | [INT] | `My Documentation/07_ReferenceMods/WoWPriest/` | Reference implementation for WoW class conversion |
| WoWDeathKnight | [INT] | `My Documentation/07_ReferenceMods/WoWDeathKnight/` | Reference implementation |
| WoWWarlock | [INT] | `My Documentation/07_ReferenceMods/WoWWarlock/` | Reference implementation |
| ExampleMod_WoWWarlock | [INT] | `Tests/ExampleMod_WoWWarlock/` | Example WoW Warlock mod in Tests/ |

---

## 13. Project Management

### **Project Restructuring**
| Topic | Source | Location | Description |
|-------|--------|----------|-------------|
| Documentation Restructure Plan | [INT] | `My Documentation/01_ProjectDocuments/DOCUMENTATION_RESTRUCTURE_PLAN.md` | User-approved Questions 1-6 for project onboarding |
| PROJECT_INDEX.md | [INT] | `PROJECT_INDEX.md` (root) | Comprehensive folder/file inventory (this document's companion) |
| DOCUMENTATION_LIBRARY.md | [INT] | `DOCUMENTATION_LIBRARY.md` (root) | This document - topic-based index |

### **Development History**
| Topic | Source | Location | Description |
|-------|--------|----------|-------------|
| Session Summaries | [INT] | `My Documentation/06_SessionSummaries/` | Session-by-session development logs |
| First Build Ready | [INT] | `FIRST_BUILD_READY.md` (root) | Initial build milestone |
| Decision Summary | [INT] | `Tests/DECISION_SUMMARY.md` | Design decision log |

### **Automation Tools**
| Topic | Source | Location | Description |
|-------|--------|----------|-------------|
| initialize_new_mod.py | [CODE] | `initialize_new_mod.py` (root) | Automated mod structure generator (474 lines), `generate_uuid()` function |

---

## 🔍 **Quick Topic Search**

### **By File Type**
- **.lsx Files**: [File Format Syntax](#file-format-syntax) → LSX Files
- **.txt Files**: [File Format Syntax](#file-format-syntax) → TXT Files (Stats Format)
- **.loca.xml Files**: [File Format Syntax](#file-format-syntax) → LOCA.XML Files
- **.pak Files**: [Packaging & Distribution](#packaging--distribution)

### **By Tool**
- **LSLib**: [LSLib & Tooling](#lslib--tooling) → LSLib
- **BG3-Modders-Multitool**: [LSLib & Tooling](#lslib--tooling) → BG3-Modders-Multitool
- **Script Extender**: [Script Extender (SE) Integration](#script-extender-se-integration)
- **BG3 Mod Manager**: [Packaging & Distribution](#packaging--distribution) → Installation

### **By Workflow**
- **Packaging a Mod**: [Packaging & Distribution](#packaging--distribution)
- **Testing a Mod**: [Validation & Testing](#validation--testing) → Testing Workflows
- **Creating a Class**: [Class & Ability Design](#class--ability-design) → Class Creation
- **Creating a Race**: [Race & Character Creation](#race--character-creation) → Race Creation
- **Debugging Crashes**: [Validation & Testing](#validation--testing) → Testing Workflows

### **By Common Issue**
- **Missing Localization Handles**: [Localization & Translation](#localization--translation) → Handle Format
- **UUID Consistency Errors**: [Dependencies & Compatibility](#dependencies--compatibility) → Mod Dependencies
- **Package Version Mismatch**: [Packaging & Distribution](#packaging--distribution) → LSLib Packaging
- **Mod Load Order Conflicts**: [Dependencies & Compatibility](#dependencies--compatibility) → Compatibility Framework

---

## 📊 **Documentation Coverage**

### **Internal Documentation (My Documentation/ + Tests/ + Root .md files)**
- **01_ProjectDocuments/**: 7+ implementation guides
- **02_DesignDocuments/**: Class blueprint template
- **03_WoWSourceMaterial/**: WoW class source data
- **04_ResearchFindings/**: BG3 modding research
- **05_ValidationReports/**: Quality assurance reports
- **06_SessionSummaries/**: Development history
- **07_ReferenceMods/**: 3 WoW class reference mods
- **08_Assets/**: Visual resources
- **Tests/**: 22 items (15 validation reports, 7 folders)
- **Root .md files**: 10+ guides (PACKAGING_GUIDE.md, README.md, etc.)

### **External Documentation (18+ URLs)**
1. ✅ LSLib GitHub (packaging tool)
2. ✅ BG3-Modders-Multitool (workspace structure)
3. ✅ Script Extender GitHub (main repo)
4. ✅ Script Extender API (Lua/Osiris documentation)
5. ✅ Script Extender Lua Setup (Bootstrap scripts)
6. ✅ bg3.wiki - Modding Resources Hub
7. ✅ bg3.wiki - Creating Mods Guide
8. ✅ bg3.wiki - Understanding Mod Folder Structure
9. ✅ bg3.wiki - Creating meta.lsx
10. ✅ bg3.wiki - Unpacking & Converting Files
11. ✅ bg3.wiki - Working with LSX Files
12. ✅ bg3.wiki - Localization
13. ✅ bg3.wiki - Packaging Mods
14. ✅ bg3.wiki - Installing Mods
15. ✅ bg3.wiki - Dependencies
16. ✅ bg3.wiki - Compatibility Framework
17. ✅ bg3.wiki - Tutorials Hub
18. ✅ BG3 Community Library Wiki

---

## 🚀 **Next Steps for Onboarding**

1. **Read PROJECT_INDEX.md** → Comprehensive folder/file inventory
2. **Read .github/copilot-instructions.md** → AI agent onboarding guide (185 lines)
3. **Explore My Documentation/01_ProjectDocuments/** → Implementation guides
4. **Review Tests/VALIDATION_STATUS_FINAL.md** → Current mod status (95% ready)
5. **Check Package/ folder** → Compiled .pak versions
6. **Read PACKAGING_GUIDE.md** → Learn how to package the mod

---

**Last Updated**: October 20, 2025  
**Recent Changes**: Added 6 WoW Hero Talent HTML references + Slayer extraction document  
**Maintained By**: BG3Wow Development Team  
**For Questions**: Use Ctrl+F to search this document by topic, tool name, or file type
