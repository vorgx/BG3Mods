# Documentation Folder Restructure Plan
**Created:** October 16, 2025  
**Purpose:** Organize scattered documentation into logical categories

---

## 📊 Current State Analysis

### Current File Count: 28 items
- **Markdown Files:** 15
- **HTML Files + Assets:** 3 HTML + 3 asset folders
- **JSON Files:** 1 (Warrior_Class_Blueprint.json)
- **ZIP Archives:** 3 (reference mods)
- **Extracted Mod Folders:** 3
- **Total Size:** ~50+ files (including asset folders)

### Current Issues
1. ❌ **No folder structure** - all files at root level
2. ❌ **Mixed content types** - source material + generated docs + reference mods
3. ❌ **Difficult navigation** - hard to find specific documentation
4. ❌ **No clear file lifecycle** - active vs archived unclear
5. ❌ **Asset folders cluttering** - Wowhead HTML files with 100+ asset files each

---

## 🎯 Proposed Folder Structure

```
My Documentation/
│
├── 📁 01_ProjectDocuments/              # Core project documentation
│   ├── README.md                        # Project overview & navigation guide
│   ├── GETTING_STARTED.md              # How to use this workspace
│   ├── TASK_TRACKER.md                 # Current tasks & progress
│   ├── FILE_REFERENCE.md               # Quick reference to all important files
│   └── RESOURCES_BOOKMARKS.md          # External resources & links (NEW)
│
├── 📁 02_DesignDocuments/               # Warrior class design specs
│   ├── Warrior_Class_Blueprint.json    # Complete class specification
│   ├── Class Blueprint Template Full v1.md
│   ├── Incomplete Blueprint.md
│   ├── Class_resources&mechanics&caps.md
│   ├── BG3_Global_Rules.md             # BG3 game mechanics reference
│   ├── Talets mechanics.md             # Talent system design
│   └── resource_kit_catalog_v_1.md     # Resource definitions
│
├── 📁 03_WoWSourceMaterial/             # WoW reference data
│   ├── Arms_Warrior_Talents_Extracted.md
│   ├── Fury_Warrior_Talents_Extracted.md
│   ├── Protection_Warrior_Talents_Extracted.md
│   ├── Wow warrior chat gpt chat.md
│   └── WoWhead_HTML/                   # Archive of Wowhead guides
│       ├── Arms Warrior Abilities and Talents Guide.html
│       ├── Arms Warrior Abilities and Talents Guide_files/
│       ├── Fury Warrior Abilities and Talents Guide.html
│       ├── Fury Warrior Abilities and Talents Guide_files/
│       ├── Protection Warrior Abilities and Talents Guide.html
│       └── Protection Warrior Abilities and Talents Guide_files/
│
├── 📁 04_ResearchFindings/              # BG3 mod structure research
│   ├── RESEARCH_FINDINGS_BG3_Structure.md
│   ├── RESEARCH_FINDINGS_DeathKnight.md
│   └── PATCH8_COMPATIBILITY_REPORT.md
│
├── 📁 05_ValidationReports/             # File validation documentation
│   ├── VALIDATION_REPORT_ActionResourceDefinitions.md
│   ├── VALIDATION_REPORT_ClassDescriptions_v2.md
│   └── VALIDATION_REPORT_ClassDescriptions.md (OLD - archive)
│
├── 📁 06_SessionSummaries/              # Development session logs
│   └── SESSION_SUMMARY_Patch8_Validation.md
│
├── 📁 07_ReferenceMods/                 # Extracted BG3 mods for study
│   ├── README_ReferenceMods.md         # What each mod demonstrates
│   ├── WoWPriest_f0d7e1dc-1a16-c068-9f62-684b81a1190c/
│   ├── WoWPriest_f0d7e1dc-1a16-c068-9f62-684b81a1190c.zip
│   ├── WoWDeathKnightClass/
│   ├── WoWDeathKnightClass.zip
│   ├── WoWDeathKnightFix/
│   └── WoWDeathKnightFix.zip
│
└── 📁 08_Assets/                        # Images, icons, resources
    └── Megapack WoW Spell Icons.zip
```

---

## 📋 Folder Descriptions

### 01_ProjectDocuments
**Purpose:** Essential project navigation and tracking  
**Access Frequency:** Daily  
**Contents:** High-level docs you reference constantly

### 02_DesignDocuments
**Purpose:** Warrior class specifications and design decisions  
**Access Frequency:** Weekly (during design phase)  
**Contents:** Blueprint files, mechanics definitions, BG3 rules

### 03_WoWSourceMaterial
**Purpose:** WoW reference data for class design  
**Access Frequency:** Weekly (during design/implementation)  
**Contents:** Extracted talent data, Wowhead guides (archived)

### 04_ResearchFindings
**Purpose:** Analysis of BG3 mod structures and compatibility  
**Access Frequency:** Weekly (during implementation)  
**Contents:** Research reports on reference mods, patch compatibility

### 05_ValidationReports
**Purpose:** File-by-file validation results  
**Access Frequency:** After each file generation  
**Contents:** Detailed validation checklists and results

### 06_SessionSummaries
**Purpose:** Historical record of development sessions  
**Access Frequency:** Occasional (for reference)  
**Contents:** Session logs, decisions made, progress tracking

### 07_ReferenceMods
**Purpose:** Extracted BG3 mods used as structural references  
**Access Frequency:** Weekly (during implementation)  
**Contents:** Full mod folders + zips, comparison notes

### 08_Assets
**Purpose:** Binary assets (images, icons, archives)  
**Access Frequency:** As needed  
**Contents:** Icon packs, textures, resources

---

## 🔄 Migration Script

### PowerShell Script to Reorganize
```powershell
# Navigate to Documentation folder
cd "c:\Users\tenod\source\repos\BG3Mods\My Documentation"

# Create new folder structure
New-Item -ItemType Directory -Force -Path "01_ProjectDocuments"
New-Item -ItemType Directory -Force -Path "02_DesignDocuments"
New-Item -ItemType Directory -Force -Path "03_WoWSourceMaterial"
New-Item -ItemType Directory -Force -Path "03_WoWSourceMaterial\WoWhead_HTML"
New-Item -ItemType Directory -Force -Path "04_ResearchFindings"
New-Item -ItemType Directory -Force -Path "05_ValidationReports"
New-Item -ItemType Directory -Force -Path "06_SessionSummaries"
New-Item -ItemType Directory -Force -Path "07_ReferenceMods"
New-Item -ItemType Directory -Force -Path "08_Assets"

# Move Project Documents
Move-Item -Path "GETTING_STARTED.md" -Destination "01_ProjectDocuments\" -Force
Move-Item -Path "TASK_TRACKER.md" -Destination "01_ProjectDocuments\" -Force
Move-Item -Path "FILE_REFERENCE.md" -Destination "01_ProjectDocuments\" -Force
Move-Item -Path "RESOURCES_BOOKMARKS.md" -Destination "01_ProjectDocuments\" -Force

# Move Design Documents
Move-Item -Path "Warrior_Class_Blueprint.json" -Destination "02_DesignDocuments\" -Force
Move-Item -Path "Class Blueprint Template Full v1.md" -Destination "02_DesignDocuments\" -Force
Move-Item -Path "Incomplete Blueprint.md" -Destination "02_DesignDocuments\" -Force
Move-Item -Path "Class_resources&mechanics&caps.md" -Destination "02_DesignDocuments\" -Force
Move-Item -Path "BG3_Global_Rules.md" -Destination "02_DesignDocuments\" -Force
Move-Item -Path "Talets mechanics.md" -Destination "02_DesignDocuments\" -Force
Move-Item -Path "resource_kit_catalog_v_1.md" -Destination "02_DesignDocuments\" -Force

# Move WoW Source Material
Move-Item -Path "Fury_Warrior_Talents_Extracted.md" -Destination "03_WoWSourceMaterial\" -Force
Move-Item -Path "Protection_Warrior_Talents_Extracted.md" -Destination "03_WoWSourceMaterial\" -Force
Move-Item -Path "Wow warrior chat gpt chat.md" -Destination "03_WoWSourceMaterial\" -Force
Move-Item -Path "Arms Warrior*.html" -Destination "03_WoWSourceMaterial\WoWhead_HTML\" -Force
Move-Item -Path "Arms Warrior*_files" -Destination "03_WoWSourceMaterial\WoWhead_HTML\" -Force
Move-Item -Path "Fury Warrior*.html" -Destination "03_WoWSourceMaterial\WoWhead_HTML\" -Force
Move-Item -Path "Fury Warrior*_files" -Destination "03_WoWSourceMaterial\WoWhead_HTML\" -Force
Move-Item -Path "Protection Warrior*.html" -Destination "03_WoWSourceMaterial\WoWhead_HTML\" -Force
Move-Item -Path "Protection Warrior*_files" -Destination "03_WoWSourceMaterial\WoWhead_HTML\" -Force

# Move Research Findings
Move-Item -Path "RESEARCH_FINDINGS_BG3_Structure.md" -Destination "04_ResearchFindings\" -Force
Move-Item -Path "RESEARCH_FINDINGS_DeathKnight.md" -Destination "04_ResearchFindings\" -Force
Move-Item -Path "PATCH8_COMPATIBILITY_REPORT.md" -Destination "04_ResearchFindings\" -Force

# Move Validation Reports
Move-Item -Path "VALIDATION_REPORT_*.md" -Destination "05_ValidationReports\" -Force

# Move Session Summaries
Move-Item -Path "SESSION_SUMMARY_*.md" -Destination "06_SessionSummaries\" -Force

# Move Reference Mods
Move-Item -Path "WoWPriest*" -Destination "07_ReferenceMods\" -Force
Move-Item -Path "WoWDeathKnight*" -Destination "07_ReferenceMods\" -Force

# Move Assets
Move-Item -Path "Megapack WoW Spell Icons.zip" -Destination "08_Assets\" -Force

Write-Host "✅ Documentation reorganization complete!" -ForegroundColor Green
```

---

## 📝 Additional Files to Create

### 01_ProjectDocuments/README.md
```markdown
# WoW Warrior Class Mod - Documentation Index

## Quick Navigation
- **Getting Started:** See `GETTING_STARTED.md`
- **Current Tasks:** See `TASK_TRACKER.md`
- **Resources:** See `RESOURCES_BOOKMARKS.md`
- **File Locations:** See `FILE_REFERENCE.md`

## Folder Guide
- `01_ProjectDocuments/` - You are here (project navigation)
- `02_DesignDocuments/` - Class design specs
- `03_WoWSourceMaterial/` - WoW reference data
- `04_ResearchFindings/` - BG3 mod research
- `05_ValidationReports/` - File validation results
- `06_SessionSummaries/` - Development logs
- `07_ReferenceMods/` - Extracted BG3 mods
- `08_Assets/` - Icons and resources
```

### 07_ReferenceMods/README_ReferenceMods.md
```markdown
# Reference Mods Guide

## WoWPriest
- **Purpose:** Single-class structure example
- **Key Features:** Holy Power resource, basic Progressions
- **Format:** Patch 8 meta.lsx, Patch 7 data files
- **What to Study:** ActionResourceDefinitions, basic progression tables

## WoWDeathKnightClass
- **Purpose:** Multi-subclass structure example
- **Key Features:** 3 subclasses (Blood/Frost/Unholy), 4 resources
- **Format:** Patch 6 (outdated but structurally valid)
- **What to Study:** SubClasses node, multiple progression tables, resource scaling

## WoWDeathKnightFix
- **Purpose:** Updated version of WoWDeathKnightClass
- **Differences:** Bug fixes, possibly updated structure
```

---

## ✅ Benefits of New Structure

### 1. **Improved Navigation**
- Clear folder hierarchy matches mental model
- Numbered folders show priority/access frequency
- README files guide navigation

### 2. **Reduced Clutter**
- HTML asset folders hidden in subfolder
- ZIP archives grouped with extracted versions
- Binary assets isolated from documentation

### 3. **Clear File Lifecycle**
- Active docs in top-level folders (01-04)
- Historical/reference in lower folders (05-07)
- Easy to identify what's current vs archived

### 4. **Better Organization**
- Related files grouped together
- Easy to find validation reports
- Session summaries chronologically accessible

### 5. **Scalability**
- Easy to add new validation reports (just drop in 05)
- Session summaries accumulate without clutter
- New research findings have clear home

---

## 🚨 Migration Checklist

Before running migration script:
1. ✅ Commit current state to git (backup)
2. ✅ Review folder structure proposal
3. ✅ Test script on small subset first
4. ✅ Verify no files left at root level
5. ✅ Update FILE_REFERENCE.md with new paths
6. ✅ Create README files for each folder
7. ✅ Test that all links in markdown files still work

---

## 🔄 Maintenance Plan

### Weekly
- Move new validation reports to `05_ValidationReports/`
- Move session summaries to `06_SessionSummaries/`

### Monthly
- Archive old session summaries (if >10 files)
- Review and clean up WoW source material
- Update TASK_TRACKER.md

### As Needed
- Add new research findings to `04_ResearchFindings/`
- Update RESOURCES_BOOKMARKS.md when discovering new resources

---

**Status:** ⏸️ Awaiting Approval  
**Next Step:** Run migration script  
**Estimated Time:** 2 minutes
