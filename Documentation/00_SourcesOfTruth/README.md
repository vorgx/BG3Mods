# Sources of Truth - Project Authority Documents

This folder contains the **authoritative sources** for the BG3Wow Warrior mod project.

## � Current Folder Structure

**Root (4 essential files only)**:
1. `SOURCE_OF_TRUTH.md` - Master living document (current project state)
2. `AbilityDatabase_Warrior_FullyEnriched.csv` - Production ability database (215 abilities, 100% complete)
3. `Warrior Progression for all subclasses.xlsx` - Excel source data
4. `README.md` - This file (folder documentation)

**Archive/** (historical/reference only):
- `Archive/OldVersions/` - Previous database versions (6 files)
- `Archive/EnrichmentBatches/` - Research tracking CSVs (4 files)
- `Archive/PlanningDocuments/` - Analysis and planning docs (12 files)
- `Archive/DraftSections/` - Section drafts now finalized (7 files)
- `Archive/ReferenceAnalysis/` - Warlock comparison docs (8 files)

## �📌 Priority Order

### **#1 SOURCE_OF_TRUTH.md** ← START HERE
- **The** living document with current project state
- Always up-to-date, never outdated
- 12 comprehensive sections covering all aspects
- Updated after every change with timestamps

### **#2 AbilityDatabase_Warrior_FullyEnriched.csv**
- Production-ready ability database
- 215 abilities fully enriched with BG3 mechanics
- Single source of truth for ability implementation
- Includes: ability_id, name, type, bg3_file_type, archetype_tags, implementation_notes

### **#3 Warrior Progression for all subclasses.xlsx**
- Excel source data for level progression
- Contains formulas and calculations
- Reference when updating progression tables

## 🚨 Critical Rules

### For AI Agents:
1. **ALWAYS** read SOURCE_OF_TRUTH.md relevant section BEFORE making changes
2. **ALWAYS** update SOURCE_OF_TRUTH.md AFTER changes + tests pass
3. **NEVER** use Archive/ folder information unless explicitly asked
4. **NEVER** skip cross-reference validation when moving files
5. **ALWAYS** use AbilityDatabase_Warrior_FullyEnriched.csv as single source for ability data

### For Users:
- Bookmark `SOURCE_OF_TRUTH.md` for quick reference
- Check "Last Updated" timestamps to verify freshness
- If information conflicts, SOURCE_OF_TRUTH.md wins
- Use Archive/ folders only for historical reference

### Folder Maintenance:
- **Keep only 4 files in root** (see folder structure above)
- Move analysis/temporary files to Archive/ when done
- Run `CLEANUP_SOURCE_OF_TRUTH.ps1` if folder gets messy
- Principle: Root should only contain active, essential files

## 🔄 Feedback Loop Enforcement

All changes must follow this protocol (enforced in `.github/copilot-instructions.md`):

**Pre-Change**:
1. Read SOURCE_OF_TRUTH.md section
2. Use as baseline
3. Proceed with change

**Post-Change**:
1. Update SOURCE_OF_TRUTH.md
2. Update timestamp
3. Add change log entry
4. Confirm accuracy

## 📁 What Goes Here?

✅ **Belongs in root** (ONLY 4 files):
- SOURCE_OF_TRUTH.md (living document)
- AbilityDatabase_Warrior_FullyEnriched.csv (production database)
- Warrior Progression for all subclasses.xlsx (Excel source)
- README.md (this file)

✅ **Belongs in Archive/** (historical/reference):
- Old database versions (Archive/OldVersions/)
- Research tracking CSVs (Archive/EnrichmentBatches/)
- Planning and analysis docs (Archive/PlanningDocuments/)
- Finalized section drafts (Archive/DraftSections/)
- Warlock comparison docs (Archive/ReferenceAnalysis/)

❌ **Does NOT belong here**:
- Session summaries (→ `Documentation/10_SessionSummaries/`)
- Implementation guides (→ `Documentation/06_ProjectDocuments/`)
- Analysis reports (→ `Reports/04_Analysis/`)
- New analysis files (create in Archive/ or move after completion)

## 🎯 Why This Matters

**Problem**: Previous sessions had conflicting information across 30+ scattered documents  
**Solution**: Single source of truth with automated enforcement + clean folder structure  
**Result**: No more confusion about current state, no more old data being used

**October 21, 2025 Cleanup**:
- Reduced folder from 41 files to 4 essential files (90% reduction)
- Organized 36 files into 5 Archive/ subfolders
- Established "4 files only" maintenance policy
- Created automated cleanup script for future use

---

**Last Updated**: October 21, 2025  
**Folder Created**: October 19, 2025 (Phase 2 of restructure)  
**Major Cleanup**: October 21, 2025 (Reduced 41 files → 4 files + Archive/)
