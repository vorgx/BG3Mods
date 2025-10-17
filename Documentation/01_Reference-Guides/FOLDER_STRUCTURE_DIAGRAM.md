# BG3Wow - Folder Structure Diagram

**Purpose**: Visual reference for BG3Mods project organization after October 2025 restructuring.  
**Last Updated**: October 17, 2025  
**Related Docs**: `PROJECT_INDEX.md`, `DOCUMENTATION_LIBRARY.md`

---

## 📂 **Complete Folder Tree (Post-Restructure)**

```
BG3Mods/  (c:\Users\tenod\source\repos\BG3Mods\)
│
├── 📄 BG3Mods.code-workspace          # VS Code workspace config
├── 📄 settings.json                   # Project settings
├── 📄 README.md                       # Core class blueprint (128 lines)
│
├── 📄 PACKAGING_GUIDE.md              # LSLib workflow (208 lines)
├── 📄 QUICK_PACKAGE.md                # Quick reference (74 lines)
├── 📄 DEBUGGING_CRASHES.md            # Crash diagnosis
├── 📄 SE_DEBUGGING_GUIDE.md           # SE log analysis
├── 📄 SE_INTEGRATION_COMPLETE.md      # SE integration status
├── 📄 LOCALIZATION_FIX_COMPLETE.md    # Localization fixes
├── 📄 FIRST_BUILD_READY.md            # Build milestone
│
├── 📄 validate_mod_structure.ps1      # ✨ NEW: Automated validation (270+ lines)
├── 📄 pre_package_checklist.md        # ✨ NEW: 6-phase release workflow (500+ lines)
├── 📄 PROJECT_INDEX.md                # ✨ NEW: Comprehensive project inventory (350+ lines)
├── 📄 DOCUMENTATION_LIBRARY.md        # ✨ NEW: Topic-based doc index (370+ lines)
│
├── 📄 initialize_new_mod.py           # Mod structure generator (474 lines)
│
├── 📁 .github/
│   └── 📄 copilot-instructions.md     # AI agent onboarding (185 lines)
│
├── 📁 Data/  ⚠️ DO NOT RESTRUCTURE - BG3-Modders-Multitool Standard
│   ├── 📁 Mods/
│   │   └── 📁 BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7/
│   │       ├── 📄 meta.lsx            # Mod metadata (UUID, version, dependencies)
│   │       ├── 📁 Localization/
│   │       │   └── 📁 English/
│   │       │       └── 📄 English.loca.xml  # Localization handles (h[8hex][2digit])
│   │       └── 📁 ScriptExtender/
│   │           ├── 📄 Config.json     # SE configuration
│   │           └── 📁 Lua/
│   │               ├── 📄 BootstrapClient.lua  # Client-side logging
│   │               └── 📄 BootstrapServer.lua  # Server-side logging
│   │
│   └── 📁 Public/
│       └── 📁 BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7/
│           ├── 📁 ClassDescriptions/
│           │   └── 📄 ClassDescriptions.lsx  # Class/subclass definitions
│           │
│           ├── 📄 Progressions.lsx    # Level progression (1292 lines, L1-20)
│           │
│           ├── 📁 Stats/
│           │   └── 📁 Generated/
│           │       └── 📁 Data/
│           │           ├── 📄 Spell_Target.txt      # Single-target abilities (21 entries)
│           │           ├── 📄 Spell_Shout.txt       # AoE buffs (3 entries)
│           │           ├── 📄 Spell_Jump.txt        # Gap closers (1 entry)
│           │           ├── 📄 Spell_Zone.txt        # Ground-targeted AoEs (6 entries)
│           │           ├── 📄 Spell_Projectile.txt  # Ranged attacks (2 entries)
│           │           ├── 📄 Status_BOOST.txt      # Buffs/debuffs (45 entries)
│           │           └── 📄 Passive.txt           # Passive abilities (34 entries)
│           │
│           └── 📁 ActionResourceDefinitions/
│               └── 📄 ActionResourceDefinitions.lsx  # Rage resource definition
│
├── 📁 LsLib/  (v1.20.3+, Package v18)
│   ├── 📄 ConverterApp.exe            # CLI packaging tool
│   ├── 📄 ConverterApp.dll.config
│   ├── 📄 ConverterApp.runtimeconfig.json
│   └── 📁 Tools/
│       ├── 📄 Divine.exe              # GUI packaging tool
│       ├── 📄 Divine.dll.config
│       └── [other DLL configs...]
│
├── 📁 My Documentation/
│   ├── 📁 01_ProjectDocuments/
│   │   ├── 📄 GETTING_STARTED.md              # 4-week roadmap
│   │   ├── 📄 FILE_REFERENCE.md               # BG3 file format syntax
│   │   ├── 📄 ABILITY_IMPLEMENTATION_INVENTORY.md  # Tracks 9 incomplete abilities
│   │   ├── 📄 PASSIVES_BREAKDOWN.md           # Passive ability definitions
│   │   ├── 📄 PASSIVES_COLOSSUS.md            # Colossus spec passives (L13-20)
│   │   ├── 📄 CHARGE_IMPLEMENTATION_NOTES.md  # Gap closer mechanics
│   │   └── 📄 DOCUMENTATION_RESTRUCTURE_PLAN.md  # This project's plan
│   │
│   ├── 📁 02_DesignDocuments/
│   │   └── 📄 Class Blueprint Template Full v1.md  # Master WoW→BG3 template
│   │
│   ├── 📁 03_WoWSourceMaterial/       # WoW Warrior source data
│   ├── 📁 04_ResearchFindings/        # BG3 modding research
│   ├── 📁 05_ValidationReports/       # Validation reports (duplicate of Tests/01?)
│   ├── 📁 06_SessionSummaries/        # Development history
│   │
│   ├── 📁 07_ReferenceMods/
│   │   ├── 📁 WoWPriest/              # Reference WoW Priest mod
│   │   ├── 📁 WoWDeathKnight/         # Reference WoW Death Knight mod
│   │   └── 📁 WoWWarlock/             # Reference WoW Warlock mod
│   │
│   └── 📁 08_Assets/                  # Class icons, ability icons, textures
│
├── 📁 Package/  ✅ REORGANIZED (Oct 2025)
│   ├── 📄 BG3Wow_Latest.pak           # Current stable (v1.0.0.3 copy)
│   ├── 📄 Package.pak                 # Legacy package file (deprecated)
│   │
│   ├── 📄 CHANGELOG.md                # ✨ NEW: Version history (v1.0.0.0 → v1.0.0.3)
│   ├── 📄 RETENTION_POLICY.md         # ✨ NEW: Archival rules + cleanup
│   ├── 📄 ARCHIVE_PACKAGES.ps1        # ✨ NEW: Automated archival script
│   ├── 📄 INSTALL_GUIDE.md            # User installation instructions
│   ├── 📄 README.md                   # Package folder documentation
│   │
│   └── 📁 Archive/                    # ✨ NEW: Historical versions
│       ├── 📁 v1.0.0.0/
│       │   └── 📄 BG3Wow_v1.0.0.0.pak        # Initial release (milestone)
│       ├── 📁 v1.0.0.1/
│       │   └── 📄 BG3Wow_v1.0.0.1_FIXED.pak  # Bug fixes
│       ├── 📁 v1.0.0.2/
│       │   └── 📄 BG3Wow_v1.0.0.2_SE.pak     # SE integration (milestone)
│       └── 📁 v1.0.0.3/
│           └── 📄 BG3Wow_v1.0.0.3_LOCFIX.pak # Localization fixes (current stable)
│
└── 📁 Tests/  ✅ REORGANIZED (Oct 2025)
    ├── 📄 MIGRATE_TESTS.ps1           # ✨ NEW: Migration automation script
    │
    ├── 📁 01_ValidationReports/  ✨ NEW SUBFOLDER
    │   ├── 📄 README.md                     # Subfolder documentation (workflows, status)
    │   ├── 📄 ABILITY_DESIGN_FRAMEWORK.md   # Ability design patterns
    │   ├── 📄 ANALYSIS_SUMMARY.md           # Mod analysis
    │   ├── 📄 COMPREHENSIVE_VALIDATION_REPORT.md  # Full checklist
    │   ├── 📄 COOLDOWN_VERIFICATION_REPORT.md     # Cooldown syntax
    │   ├── 📄 CRASH_DIAGNOSIS_SUMMARY.md          # Crash diagnosis
    │   ├── 📄 DECISION_SUMMARY.md                 # Design decisions
    │   ├── 📄 LOCALIZATION_COMPLETE.md            # Localization status
    │   ├── 📄 QUICK_VALIDATION_CHECKLIST.md       # Quick checks
    │   ├── 📄 SUNDER_ARMOR_COMPLETION.md          # Sunder Armor status
    │   ├── 📄 SUNDER_ARMOR_IMPLEMENTATION.md      # Sunder Armor guide
    │   ├── 📄 SUNDER_ARMOR_LOCALIZATION.md        # Sunder Armor localization
    │   ├── 📄 VALIDATION_STATUS_FINAL.md          # ✅ 95% ready (100 lines)
    │   ├── 📄 VALIDATION_SUMMARY.md               # Summary
    │   ├── 📄 WARRIOR_ABILITIES_VALIDATION_REPORT.md  # Abilities validation
    │   └── 📄 WARRIOR_VALIDATION_RESULTS.md       # Warrior validation results
    │
    ├── 📁 02_ExampleMods/  ✨ NEW SUBFOLDER
    │   ├── 📄 README.md                     # Subfolder documentation (comparison table)
    │   ├── 📁 ExampleMod_5eSpells/          # 5e spells reference
    │   ├── 📁 ExampleMod_WoWWarlock/        # WoW Warlock reference (critical)
    │   └── 📁 MinimalMod/                   # Minimal template
    │
    └── 📁 03_ExtractedContent/  ✨ NEW SUBFOLDER
        ├── 📄 README.md                     # Subfolder documentation (extraction workflows)
        ├── 📁 ExtractedPak/                 # Vanilla BG3 content
        ├── 📁 InstalledPackageCheck/        # BG3Wow installed state
        ├── 📁 NewPackage/                   # Experimental builds
        ├── 📁 WoWWarrior_BACKUP/            # Backup folder (rollback)
        └── 📄 WoWWarrior_BACKUP.pak         # Backup .pak (quick rollback)
```

---

## 🔑 **Key Organization Principles**

### **Root Level**
- **Configuration**: `.code-workspace`, `settings.json`
- **Core Docs**: `README.md`, `PACKAGING_GUIDE.md`, `QUICK_PACKAGE.md`
- **Debugging**: `DEBUGGING_CRASHES.md`, `SE_DEBUGGING_GUIDE.md`
- **✨ New Automation**: `validate_mod_structure.ps1`, `pre_package_checklist.md`
- **✨ New Indexes**: `PROJECT_INDEX.md`, `DOCUMENTATION_LIBRARY.md`
- **Python Tooling**: `initialize_new_mod.py`

### **Data/ Folder** ⚠️ UNTOUCHABLE
- Follows **BG3-Modders-Multitool** mandatory structure
- `Mods/BG3Wow_.../` for meta.lsx, localization, SE scripts
- `Public/BG3Wow_.../` for ClassDescriptions, Progressions, Stats, ActionResourceDefinitions
- **UUID must match everywhere**: `78fe4967-4e62-5491-d981-dd781acca4d7`

### **LsLib/ Folder**
- **ConverterApp.exe** for CLI packaging (PowerShell scripts)
- **Divine.exe** for GUI packaging (double-click)
- Version v1.20.3+ required for Patch 8 (package version v18)

### **My Documentation/**
- 8 organized categories (01-08)
- **01_ProjectDocuments**: Implementation guides, ability tracking
- **02_DesignDocuments**: Class blueprint template
- **07_ReferenceMods**: 3 WoW class mods for comparison

### **Package/ Folder** ✅ Reorganized
- **Root**: `BG3Wow_Latest.pak` (current), `CHANGELOG.md`, `RETENTION_POLICY.md`, automation scripts
- **Archive/**: Version subfolders (v1.0.0.0/, v1.0.0.1/, v1.0.0.2/, v1.0.0.3/)
- **Retention Policy**: Keep last 2 in root, archive older versions

### **Tests/ Folder** ✅ Reorganized
- **01_ValidationReports/**: 15 .md validation files + README
- **02_ExampleMods/**: 3 example mod folders + README
- **03_ExtractedContent/**: 4 folders + 1 .pak backup + README
- **MIGRATE_TESTS.ps1**: Automated migration script (already executed)

---

## 📊 **File Count Summary**

| Category | File Count | Notable Items |
|----------|------------|---------------|
| **Root Level** | 14 files | 4 new files (validate, checklist, indexes) |
| **Data/** | 20+ files | meta.lsx, Progressions.lsx (1292 lines), 7 Spell_*.txt files |
| **LsLib/** | 15+ files | ConverterApp.exe, Divine.exe |
| **My Documentation/** | 50+ files | 8 organized folders |
| **Package/** | 7 root files + 4 archived .pak | Archive/ structure with version subfolders |
| **Tests/** | 23 items | 15 validation reports, 3 example mods, 5 extracted items |
| **.github/** | 1 file | copilot-instructions.md (185 lines) |
| **Total** | 130+ core files | Excludes extracted content and example mod internals |

---

## 🚦 **Critical Path for New Contributors**

### **1. Read First** (Context Building)
1. `README.md` (root) - Core class blueprint
2. `.github/copilot-instructions.md` - BG3 modding patterns
3. `PROJECT_INDEX.md` - Comprehensive folder/file inventory
4. `DOCUMENTATION_LIBRARY.md` - Topic-based documentation index

### **2. Before Making Changes** (Validation)
1. `pre_package_checklist.md` - 6-phase release workflow
2. Run `validate_mod_structure.ps1` - Automated validation

### **3. Implementing Abilities** (Development)
1. `My Documentation/01_ProjectDocuments/ABILITY_IMPLEMENTATION_INVENTORY.md` - Track progress
2. `My Documentation/01_ProjectDocuments/FILE_REFERENCE.md` - BG3 file syntax
3. `Tests/01_ValidationReports/SUNDER_ARMOR_IMPLEMENTATION.md` - Example workflow

### **4. Packaging & Distribution** (Release)
1. `PACKAGING_GUIDE.md` - LSLib workflow
2. `Package/RETENTION_POLICY.md` - Archival rules
3. `Package/CHANGELOG.md` - Update version history

---

## 🔗 **Related Documentation**

- **PROJECT_INDEX.md**: Comprehensive folder/file inventory with purposes, dependencies, testing methods
- **DOCUMENTATION_LIBRARY.md**: Topic-based index with 18+ external URLs
- **.github/copilot-instructions.md**: AI agent onboarding guide with BG3 modding patterns
- **pre_package_checklist.md**: 6-phase release workflow with step-by-step commands
- **validate_mod_structure.ps1**: Automated validation script (UUID, XML, localization, stat files)

---

**Diagram Maintained By**: BG3Wow Development Team  
**Last Updated**: October 17, 2025  
**Diagram Version**: 1.0 (Post-Restructure)
