# BG3Wow - Project Index

**Baldur's Gate 3 Warrior Class Mod**  
**Current Version**: 1.0.1.0  
**Last Updated**: October 17, 2025

---

## 🚀 Quick Start

### 📌 SOURCE OF TRUTH - Read First!
**Before making ANY changes, consult these files:**

1. **[SOURCE_OF_TRUTH.md](Documentation/00_SourcesOfTruth/SOURCE_OF_TRUTH.md)**  
   Master documentation - Current project state (always up-to-date)

2. **[AbilityDatabase_Warrior_FullyEnriched.csv](Documentation/00_SourcesOfTruth/AbilityDatabase_Warrior_FullyEnriched.csv)**  
   Production ability database - 215 abilities, 100% complete with BG3 mechanics

3. **[Warrior Progression for all subclasses.xlsx](Documentation/00_SourcesOfTruth/Warrior%20Progression%20for%20all%20subclasses.xlsx)**  
   Excel source data - Level progression tables and formulas

4. **[00_SourcesOfTruth/README.md](Documentation/00_SourcesOfTruth/README.md)**  
   Folder maintenance policy - "4 files only" rule

**See Also**: [.github/copilot-instructions.md](.github/copilot-instructions.md) - SOURCE OF TRUTH PROTOCOL section

---

### New Here? Start With These (In Order):
1. **[START_HERE.md](Documentation/Setup-Guides/START_HERE.md)** - 5-minute setup guide
2. **[QUICK_REFERENCE.md](QUICK_REFERENCE.md)** - Keyboard shortcuts cheat sheet
3. Press `Ctrl+Shift+B` to build your first PAK!

### Essential Files (Keep Open):
- **[QUICK_REFERENCE.md](QUICK_REFERENCE.md)** - Daily workflow reference
- **[pre_package_checklist.md](pre_package_checklist.md)** - Pre-build validation
- **[.vscode/README.md](.vscode/README.md)** - Build system documentation

---

## 📁 Project Structure

```
BG3Mods/
├── 📄 README.md                       ← Project overview
├── 📄 INDEX.md (this file)           ← Project navigation hub
├── 📄 BG3Mods.code-workspace         ← VS Code workspace
├── 📄 settings.json                  ← Project settings
├── � CLEANUP_SOURCE_OF_TRUTH.ps1    ← Reusable folder cleanup utility
├── � CLEANUP_ROOT_DIRECTORY.ps1     ← Root directory cleanup utility
│
├── 📂 Data/                           ← Mod source files
│   ├── Mods/BG3Wow_*/                ← meta.lsx, ScriptExtender
│   └── Public/BG3Wow_*/              ← Class data, spells, progressions
│
├── 📂 Documentation/                  ← All project documentation
│   ├── 00_SourcesOfTruth/            ← SOURCE OF TRUTH (4 files + Archive/)
│   │   ├── SOURCE_OF_TRUTH.md        ← Master living document (1,297 lines)
│   │   ├── AbilityDatabase_Warrior_FullyEnriched.csv ← Production DB (215 abilities)
│   │   ├── Warrior Progression.xlsx  ← Excel source data
│   │   ├── README.md                 ← Folder maintenance policy
│   │   └── Archive/                  ← Historical files (5 subfolders)
│   ├── 01_Reference-Guides/          ← Reference documentation
│   ├── 02_Setup-Guides/              ← Setup & onboarding
│   ├── 03_Workflows/                 ← Workflow guides
│   ├── 04_Organization-Reports/      ← Organization documents
│   ├── 05_SessionReports/            ← Completion reports
│   ├── 06_ProjectDocuments/          ← Implementation guides
│   ├── 07_DesignDocuments/           ← Class blueprints
│   ├── 08_WoWSourceMaterial/         ← WoW reference material
│   ├── 09_ResearchFindings/          ← Research notes
│   ├── 10_SessionSummaries/          ← Session summaries
│   ├── 11_ValidationReports/         ← Validation results
│   ├── 12_ReferenceMods/             ← Reference mod examples
│   └── 13_Assets/                    ← Project assets
│
├── 📂 Scripts/                        ← Development scripts (organized!)
│   ├── Database/                     ← Database scripts (3 scripts)
│   │   ├── CREATE_ABILITY_DATABASE.ps1
│   │   ├── CLEANUP_ABILITY_DATABASE.ps1
│   │   └── FIX_CLASSIFICATION.ps1
│   ├── Enrichment/                   ← Enrichment scripts (10 scripts)
│   │   ├── AUTO_ENRICH_PASSIVES.ps1
│   │   ├── COMPREHENSIVE_WOW_ENRICHMENT.ps1
│   │   ├── ENRICH_*.ps1              ← Batch enrichment scripts
│   │   └── PARSE_ICYVEINS_*.ps1      ← HTML parsing scripts
│   ├── ModUpdateCheck/               ← Installed-mod updates, load order fix, add-ons, new-mod checks
│   ├── Extract-SlayerTalents.ps1     ← Extraction utilities
│   ├── View_Logs.ps1                 ← Log viewer
│   ├── validate_spell_references.ps1 ← Spell validation
│   └── validate_mod_structure.ps1    ← Mod structure validation
│
├── 📂 Package/                        ← Built PAK files (output)
│   ├── BG3Wow_Latest.pak             ← Most recent build
│   └── BG3Wow_v*.pak                 ← Versioned releases
│
├── 📂 .vscode/                        ← VS Code build system
│   ├── build-pak.ps1                 ← Main packaging script
│   ├── unpack-pak.ps1                ← PAK unpacker
│   ├── tasks.json                    ← Ctrl+Shift+B configuration
│   └── launch.json                   ← F5 debug menu
│
├── 📂 Tests/                          ← Validation & testing
│   ├── RUN_ALL_TESTS.ps1             ← Test runner
│   └── 04_Tools/                     ← Test migration tools
│
├── 📂 Transformation_Templates/       ← Warlock template reference
│   ├── Tests/                        ← Template test scripts
│   │   ├── Test-MetaLsx.ps1          ← FILE 1 validation
│   │   ├── Test-ClassDescriptions.ps1 ← FILE 2 validation
│   │   └── Test-AllFiles.ps1         ← Master test runner
│   └── README.md                     ← Template documentation
│
├── 📂 Reports/                        ← Analysis reports
│   ├── 01_Analysis/                  ← Analysis documents
│   ├── 02_Transformation/            ← Transformation plans
│   └── 03_Progress/                  ← Progress tracking
│
├── 📂 LsLib/                          ← LSLib tools (fallback)
│   └── Tools/                        ← LSLib binaries
│
├── � Backups/                        ← Project backups (5 timestamped)
└── � Archive/                        ← Archived content
```

---

## 🎯 Common Tasks

### Build Your Mod
```
Press: Ctrl+Shift+B
```
**See**: [QUICK_REFERENCE.md](QUICK_REFERENCE.md) → Build Mod

### Validate Before Building
```
Press: F5 → Select "Validate Mod Structure"
```
**See**: [pre_package_checklist.md](pre_package_checklist.md)

### Install to BG3
```
Press: Ctrl+Shift+P → "Tasks: Run Task" → "Install Mod to BG3"
```
**See**: [SETUP_COMPLETE.md](SETUP_COMPLETE.md) → Install to BG3

### View All Keyboard Shortcuts
**Open**: [QUICK_REFERENCE.md](QUICK_REFERENCE.md)

### Check Installed Mods for Updates and Load Order
```
.\Scripts\ModUpdateCheck\Run-ModCheck.ps1
```
**See**: [Scripts/ModUpdateCheck/README.md](Scripts/ModUpdateCheck/README.md)

---

## 📚 Documentation by Purpose

### Setup & Configuration
| Document | Purpose | Read When |
|----------|---------|-----------|
| [START_HERE.md](Documentation/Setup-Guides/START_HERE.md) | 5-minute quick setup | First time setup |
| [MULTITOOL_SETUP.md](Documentation/Setup-Guides/MULTITOOL_SETUP.md) | Detailed setup guide | Need more details |
| [SETUP_COMPLETE.md](Tests/SessionReports/SETUP_COMPLETE.md) | Setup confirmation | After initial setup |
| [VSCODE_INTEGRATION_COMPLETE.md](Tests/SessionReports/VSCODE_INTEGRATION_COMPLETE.md) | Full VS Code integration docs | Deep dive into build system |

### Daily Reference
| Document | Purpose | Read When |
|----------|---------|-----------|
| [QUICK_REFERENCE.md](QUICK_REFERENCE.md) | Keyboard shortcuts & workflows | Daily/constantly |
| [pre_package_checklist.md](pre_package_checklist.md) | Pre-build validation | Before every build |
| [.vscode/README.md](.vscode/README.md) | Build system features | Learning build system |

### Implementation Guides
| Document | Purpose | Read When |
|----------|---------|-----------|
| [My Documentation/01_ProjectDocuments/GETTING_STARTED.md](My%20Documentation/01_ProjectDocuments/GETTING_STARTED.md) | 4-week implementation roadmap | Planning development |
| [My Documentation/01_ProjectDocuments/FILE_REFERENCE.md](My%20Documentation/01_ProjectDocuments/FILE_REFERENCE.md) | BG3 file format reference | Writing mod files |
| [My Documentation/01_ProjectDocuments/ABILITY_IMPLEMENTATION_INVENTORY.md](My%20Documentation/01_ProjectDocuments/ABILITY_IMPLEMENTATION_INVENTORY.md) | Track ability completion | Managing development |

### Packaging & Release
| Document | Purpose | Read When |
|----------|---------|-----------|
| [PACKAGING_GUIDE.md](Documentation/Reference-Guides/PACKAGING_GUIDE.md) | Full packaging workflow | Manual packaging needed |
| [QUICK_PACKAGE.md](Documentation/Reference-Guides/QUICK_PACKAGE.md) | Legacy LSLib packaging | Multitool not available |
| [pre_package_checklist.md](pre_package_checklist.md) | Pre-release validation | Before release |

### Troubleshooting
| Document | Purpose | Read When |
|----------|---------|-----------|
| [SE_DEBUGGING_GUIDE.md](Tests/Troubleshooting/SE_DEBUGGING_GUIDE.md) | Script Extender debugging | SE issues |
| [MULTITOOL_SETUP.md](Documentation/Setup-Guides/MULTITOOL_SETUP.md) → Troubleshooting | Build issues | Build fails |

### Session Reports (Historical)
| Document | Purpose | Read When |
|----------|---------|-----------|
| [LOCALIZATION_FIX_COMPLETE.md](Tests/SessionReports/LOCALIZATION_FIX_COMPLETE.md) | Original localization completion | Historical reference |
| [SE_INTEGRATION_COMPLETE.md](Tests/SessionReports/SE_INTEGRATION_COMPLETE.md) | Script Extender integration | Historical reference |
| [FIRST_BUILD_READY.md](Tests/SessionReports/FIRST_BUILD_READY.md) | Initial build milestone | Historical reference |
| [VSCODE_INTEGRATION_COMPLETE.md](Tests/SessionReports/VSCODE_INTEGRATION_COMPLETE.md) | VS Code build system setup | Historical reference |

### Project Management
| Document | Purpose | Read When |
|----------|---------|-----------|
| [PROJECT_INDEX.md](Documentation/Reference-Guides/PROJECT_INDEX.md) | Comprehensive file inventory | Finding specific files |
| [DOCUMENTATION_LIBRARY.md](Documentation/Reference-Guides/DOCUMENTATION_LIBRARY.md) | External resource links | Need BG3 wiki/guides |
| [FOLDER_STRUCTURE_DIAGRAM.md](Documentation/Reference-Guides/FOLDER_STRUCTURE_DIAGRAM.md) | Visual folder structure | Understanding layout |

---

## 🎓 Learning Paths

### Beginner (Total: 10 minutes)
```
1. Documentation/Setup-Guides/START_HERE.md (5 min) - Setup
   ↓
2. Press Ctrl+Shift+B (30 sec) - Test build
   ↓
3. Bookmark QUICK_REFERENCE.md - Daily use
```

### Intermediate (Total: 30 minutes)
```
1. Documentation/Setup-Guides/MULTITOOL_SETUP.md (10 min) - Understand setup
   ↓
2. .vscode/README.md (10 min) - Learn build features
   ↓
3. pre_package_checklist.md (5 min) - Quality checks
   ↓
4. Test F5 menu options (5 min) - Practice workflows
```

### Advanced (Total: 2 hours)
```
1. Tests/SessionReports/VSCODE_INTEGRATION_COMPLETE.md (30 min) - Build system deep dive
   ↓
2. My Documentation/01_ProjectDocuments/FILE_REFERENCE.md (30 min) - BG3 formats
   ↓
3. My Documentation/01_ProjectDocuments/GETTING_STARTED.md (30 min) - Implementation guide
   ↓
4. Customize build scripts (30 min) - Tailor workflow
```

---

## 🔍 Find Information By Topic

### Build System
- **Quick build**: [QUICK_REFERENCE.md](QUICK_REFERENCE.md) → Ctrl+Shift+B
- **Build options**: [.vscode/README.md](.vscode/README.md)
- **Build script**: [.vscode/build-pak.ps1](.vscode/build-pak.ps1)
- **Tasks**: [.vscode/tasks.json](.vscode/tasks.json)

### Localization
- **Original completion**: [LOCALIZATION_FIX_COMPLETE.md](Tests/SessionReports/LOCALIZATION_FIX_COMPLETE.md)
- **Handle format**: [pre_package_checklist.md](pre_package_checklist.md) → Localization Section
- **Validation**: [Tests/01_ValidationReports/LOCALIZATION_COMPLETE.md](Tests/01_ValidationReports/LOCALIZATION_COMPLETE.md)

### Class Implementation
- **Getting started**: [My Documentation/01_ProjectDocuments/GETTING_STARTED.md](My%20Documentation/01_ProjectDocuments/GETTING_STARTED.md)
- **File formats**: [My Documentation/01_ProjectDocuments/FILE_REFERENCE.md](My%20Documentation/01_ProjectDocuments/FILE_REFERENCE.md)
- **Ability tracking**: [My Documentation/01_ProjectDocuments/ABILITY_IMPLEMENTATION_INVENTORY.md](My%20Documentation/01_ProjectDocuments/ABILITY_IMPLEMENTATION_INVENTORY.md)
- **Passive abilities**: [My Documentation/01_ProjectDocuments/PASSIVES_*.md](My%20Documentation/01_ProjectDocuments/)

### Validation & Testing
- **Validation script**: [validate_mod_structure.ps1](validate_mod_structure.ps1)
- **Pre-package checks**: [pre_package_checklist.md](pre_package_checklist.md)
- **Validation reports**: [Tests/01_ValidationReports/](Tests/01_ValidationReports/)

### External Resources
- **BG3 Wiki links**: [DOCUMENTATION_LIBRARY.md](DOCUMENTATION_LIBRARY.md)
- **Multitool GitHub**: https://github.com/ShinyHobo/BG3-Modders-Multitool
- **LSLib GitHub**: https://github.com/Norbyte/lslib

---

## ⚡ Keyboard Shortcuts Quick Reference

```
Ctrl+Shift+B    Build PAK (default - fastest!)
F5              Open debug menu (4 configurations)
Ctrl+Shift+P    Command palette (run any task)
Ctrl+`          Open/close terminal
```

**Full list**: [QUICK_REFERENCE.md](QUICK_REFERENCE.md)

---

## 🎮 Daily Workflow

```
1. Edit mod files (abilities, spells, localization, etc.)
2. Press Ctrl+Shift+B
3. Wait ~10 seconds
4. PAK is ready!
5. Test in game
6. Repeat
```

---

## 📊 Project Status

### Version: 1.0.1.0
**Date**: October 17, 2025

**Features Complete**:
- ✅ Base Warrior class (levels 1-20)
- ✅ 3 specializations (Arms, Fury, Protection)
- ✅ Rage resource system (0-100)
- ✅ 19 baseline abilities
- ✅ 10 Arms abilities
- ✅ Hero talents (levels 13-20)
- ✅ 146 localization entries
- ✅ Full progression tables
- ✅ Script Extender integration
- ✅ VS Code build system (Ctrl+Shift+B)

**Build System**:
- ✅ BG3 Modders Multitool integration
- ✅ One-keystroke builds (~10 seconds)
- ✅ Validation automation
- ✅ LSLib fallback available

**Documentation**:
- ✅ 50+ documentation files
- ✅ Implementation guides
- ✅ Validation reports
- ✅ Setup guides
- ✅ Quick reference cards

---

## 🆘 Need Help?

### Quick Issues
→ [QUICK_REFERENCE.md](QUICK_REFERENCE.md) → Troubleshooting

### Setup Problems
→ [MULTITOOL_SETUP.md](MULTITOOL_SETUP.md) → Troubleshooting

### Build Errors
→ Run validation: `F5` → "Validate Mod Structure"

### General Questions
→ [.github/copilot-instructions.md](.github/copilot-instructions.md) (Project conventions)

---

## 🗂️ File Organization Standards

### Root Level (Keep Minimal)
- ✅ README.md, INDEX.md
- ✅ START_HERE.md, QUICK_REFERENCE.md
- ✅ Essential scripts (validate_mod_structure.ps1)
- ✅ Session reports (temporary, move to Tests/ when archived)

### Organized Folders
- 📂 **Data/** - Mod source files (DO NOT MOVE)
- 📂 **Package/** - Build output (DO NOT MOVE)
- 📂 **.vscode/** - Build system (DO NOT MOVE)
- 📂 **My Documentation/** - Design docs & guides
- 📂 **Tests/** - Validation & testing
- 📂 **LsLib/** - Tools

---

## 📞 External Links

- **BG3 Modders Multitool**: https://github.com/ShinyHobo/BG3-Modders-Multitool
- **LSLib**: https://github.com/Norbyte/lslib
- **BG3 Modding Wiki**: https://bg3.wiki/wiki/Modding:Modding_resources
- **Full link library**: [DOCUMENTATION_LIBRARY.md](DOCUMENTATION_LIBRARY.md)

---

## ✅ Quick Health Check

Run this to verify everything is set up:

```powershell
# From project root
.\validate_mod_structure.ps1 -Verbose
```

Expected output: `=== VALIDATION PASSED ===`

---

**Last Updated**: October 17, 2025  
**Mod Version**: 1.0.1.0  
**Build System**: BG3 Modders Multitool + VS Code  
**Status**: ✅ Production Ready

**Quick Start**: Open [START_HERE.md](Documentation/Setup-Guides/START_HERE.md) and follow the 5-minute setup!
