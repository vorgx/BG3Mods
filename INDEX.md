# BG3Wow - Project Index

**Baldur's Gate 3 Warrior Class Mod**  
**Current Version**: 1.0.1.0  
**Last Updated**: October 17, 2025

---

## 🚀 Quick Start

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
├── 📄 INDEX.md (this file)           ← Project navigation hub
├── 📄 README.md                       ← Project overview
├── 📄 START_HERE.md                   ← New user quick start
├── 📄 QUICK_REFERENCE.md              ← Daily keyboard shortcuts
│
├── 📂 Data/                           ← Mod source files
│   ├── Mods/BG3Wow_*/                ← meta.lsx, localization
│   └── Public/BG3Wow_*/              ← Class data, spells, progressions
│
├── 📂 Package/                        ← Built PAK files (output)
│   ├── BG3Wow_Latest.pak             ← Most recent build
│   └── BG3Wow_v*.pak                 ← Versioned releases
│
├── 📂 .vscode/                        ← VS Code build system
│   ├── build-pak.ps1                 ← Main packaging script
│   ├── tasks.json                    ← Ctrl+Shift+B configuration
│   ├── launch.json                   ← F5 debug menu
│   └── README.md                     ← Build system docs
│
├── 📂 My Documentation/               ← Design & implementation guides
│   ├── 01_ProjectDocuments/          ← Core documentation
│   ├── 02_DesignDocuments/           ← Class blueprints
│   └── 03_WoWSourceMaterial/         ← Reference material
│
├── 📂 Tests/                          ← Validation & testing
│   ├── 01_ValidationReports/         ← Build validation results
│   ├── SessionReports/               ← Session completion reports
│   ├── Troubleshooting/              ← Debug guides
│   └── ExampleMod_*/                 ← Reference mod examples
│
├── 📂 Documentation/                  ← Organized guides
│   ├── Setup-Guides/                 ← Setup & onboarding
│   │   ├── START_HERE.md             ← 5-minute quick start
│   │   └── MULTITOOL_SETUP.md        ← Detailed setup guide
│   └── Reference-Guides/             ← Reference documentation
│       ├── PACKAGING_GUIDE.md        ← Packaging workflows
│       ├── PROJECT_INDEX.md          ← File inventory
│       ├── DOCUMENTATION_LIBRARY.md  ← External links
│       └── FOLDER_STRUCTURE_DIAGRAM.md ← Folder layout
│
├── 📂 LsLib/                          ← LSLib tools (fallback)
│   └── ConverterApp.exe              ← LSLib PAK builder
│
├── 📄 validate_mod_structure.ps1     ← Pre-build validation script
└── 📄 pre_package_checklist.md       ← Quality assurance checklist
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
