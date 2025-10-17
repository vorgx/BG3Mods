# WoW Warrior Class Mod - Documentation Index

**Project:** Baldur's Gate 3 - WoW Warrior Class Mod  
**Last Updated:** October 16, 2025

---

## 🚀 Quick Start

**New to this project?** Start here:
1. Read `GETTING_STARTED.md` for project overview
2. Check `TASK_TRACKER.md` for current tasks and progress
3. Review `RESOURCES_BOOKMARKS.md` for all external links

---

## 📁 Folder Navigation

### **01_ProjectDocuments** _(You are here)_
High-level project documentation and navigation guides.
- `README.md` - This file (documentation index)
- `GETTING_STARTED.md` - Project overview and workspace setup
- `TASK_TRACKER.md` - Current tasks, progress tracking
- `FILE_REFERENCE.md` - Quick reference to important files
- `RESOURCES_BOOKMARKS.md` - External resources and links
- `DOCUMENTATION_RESTRUCTURE_PLAN.md` - How this folder structure was created

### **02_DesignDocuments**
Warrior class specifications and game mechanics.
- `Warrior_Class_Blueprint.json` - Complete class specification
- `Class Blueprint Template Full v1.md` - Template structure
- `BG3_Global_Rules.md` - BG3 game mechanics reference
- `Talets mechanics.md` - Talent system design
- And more design documents...

### **03_WoWSourceMaterial**
WoW reference data for authentic class design.
- Talent extraction files for Arms/Fury/Protection
- `WoWhead_HTML/` - Archived Wowhead ability guides
- Chat logs with design discussions

### **04_ResearchFindings**
Analysis of BG3 mod structures and compatibility.
- `RESEARCH_FINDINGS_BG3_Structure.md` - WoWPriest mod analysis
- `RESEARCH_FINDINGS_DeathKnight.md` - WoWDeathKnight mod analysis
- `PATCH8_COMPATIBILITY_REPORT.md` - Patch 8 migration research

### **05_ValidationReports**
File-by-file validation results.
- `VALIDATION_REPORT_ActionResourceDefinitions.md` - Rage resource validation (100%)
- `VALIDATION_REPORT_ClassDescriptions_v2.md` - Class definitions validation (100%)

### **06_SessionSummaries**
Development session logs and historical record.
- `SESSION_SUMMARY_Patch8_Validation.md` - Patch 8 compatibility session

### **07_ReferenceMods**
Extracted BG3 mods used as structural references.
- `README_ReferenceMods.md` - Guide to what each mod demonstrates
- `WoWPriest_*/` - Single-class example
- `WoWDeathKnightClass/` - Multi-subclass example

### **08_Assets**
Binary assets, icons, and resources.
- `Megapack WoW Spell Icons.zip` - Icon pack for abilities

---

## 🎯 Current Status

**Core Files Progress:** 2/5 Complete (40%)

| File | Status | Validation |
|------|--------|------------|
| ✅ ActionResourceDefinitions.lsx | Complete | 100% |
| ✅ ClassDescriptions.lsx | Complete | 100% |
| ⏭️ Progressions.lsx | **Next** | Pending |
| ⏸️ Stats files | Pending | Pending |
| ⏸️ English.loca.xml | Pending | Pending |

**Last Session:** Patch 8 compatibility validation (Oct 16, 2025)  
**Next Milestone:** Progressions.lsx generation (SubClasses node + Level 1-20)

---

## 📋 Important Files Quick Reference

### Project Management
- **Current Tasks:** `01_ProjectDocuments/TASK_TRACKER.md`
- **Getting Started:** `01_ProjectDocuments/GETTING_STARTED.md`
- **External Links:** `01_ProjectDocuments/RESOURCES_BOOKMARKS.md`

### Design
- **Main Blueprint:** `02_DesignDocuments/Warrior_Class_Blueprint.json`
- **BG3 Rules:** `02_DesignDocuments/BG3_Global_Rules.md`

### Research
- **Patch 8 Info:** `04_ResearchFindings/PATCH8_COMPATIBILITY_REPORT.md`
- **Mod Structure:** `04_ResearchFindings/RESEARCH_FINDINGS_BG3_Structure.md`

### Validation
- **Latest Reports:** `05_ValidationReports/` (all files)

---

## 🔗 External Resources

Quick links (full list in `RESOURCES_BOOKMARKS.md`):
- **BG3 Wiki:** https://bg3.wiki/wiki/Modding:Creating_mods
- **BG3 Community Library:** https://github.com/BG3-Community-Library-Team/BG3-Community-Library
- **LSLib:** https://github.com/Norbyte/lslib
- **bg3se (Script Extender):** https://github.com/Norbyte/bg3se

---

## 📝 How to Use This Documentation

### For Daily Work
1. Check `TASK_TRACKER.md` for today's tasks
2. Reference `02_DesignDocuments/` for class specs
3. Review validation reports in `05_ValidationReports/` after generating files

### For Research
1. Browse `04_ResearchFindings/` for BG3 mod analysis
2. Check `07_ReferenceMods/` for example implementations
3. Visit external links in `RESOURCES_BOOKMARKS.md`

### For Debugging
1. Check `05_ValidationReports/` for validation results
2. Review `06_SessionSummaries/` for past decisions
3. Compare against reference mods in `07_ReferenceMods/`

---

## 🔄 Maintenance

This documentation structure is maintained by GitHub Copilot.

**Weekly:**
- Update `TASK_TRACKER.md` with progress
- Add new validation reports to `05_ValidationReports/`
- Archive session summaries to `06_SessionSummaries/`

**As Needed:**
- Update `RESOURCES_BOOKMARKS.md` when finding new resources
- Add research findings to `04_ResearchFindings/`
- Update this README when folder structure changes

---

**Need Help?** Start with `GETTING_STARTED.md` or check `TASK_TRACKER.md` for current context.
