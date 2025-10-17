# AI Agent Workflow Protocol

**Purpose**: Ensure consistent, accurate work by AI assistants on BG3Wow project  
**Created**: October 17, 2025  
**Status**: ⚠️ MANDATORY - Follow this protocol for ALL code/documentation changes

---

## 🚨 Critical Rule: Documentation First, Changes Second

**NEVER make changes to code or documentation without reading the design docs first.**

---

## 📋 Standard Workflow (5 Steps)

### Step 1: Understand Current Design (ALWAYS START HERE)
**Before changing ANYTHING**, read these files:

#### Design Documents (`Documentation/07_DesignDocuments/`)
- **Warrior_Class_Blueprint.md** - Complete class design, intended mechanics
- **Class Blueprint Template Full v1.md** - Framework reference
- **Warrior_Class_Blueprint.json** - Original design spec (if .md conflicts)

#### Implementation Guides (`Documentation/06_ProjectDocuments/`)
- **GETTING_STARTED.md** - Step-by-step implementation approach
- **FILE_REFERENCE.md** - BG3 file format syntax
- **PASSIVES_*.md** - Passive ability definitions and patterns
- **ABILITY_IMPLEMENTATION_INVENTORY.md** - What's implemented vs. planned

**Why**: Understand INTENDED design before making assumptions about bugs or missing features.

**Example**: If user says "check for missing abilities," read the blueprint FIRST to know what SHOULD exist, then scan implementation to see what DOES exist.

---

### Step 2: Scan Implementation Files (Verify Reality)
**Location**: `Data/Public/BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7/Stats/Generated/Data/`

#### Check ALL These File Types:
1. **Spell_Target.txt** - Single-target abilities (27 spells)
2. **Spell_Zone.txt** - AoE abilities (6 spells)
3. **Spell_Shout.txt** - Buffs/debuffs (3 spells)
4. **Spell_Projectile.txt** - Ranged attacks (2 spells)
5. **Spell_Jump.txt** - Mobility abilities (1 spell)
6. **Status_BOOST.txt** - Status effects, stances, buffs ⚠️ OFTEN MISSED
7. **Passive.txt** - Passive abilities, hero talents ⚠️ OFTEN MISSED
8. **Progressions.lsx** - Level-up grants (outside Stats folder)

**Why**: Many abilities are implemented as status effects or passives, NOT as spell entries. Grep for spell names alone will miss these.

**Example**: "Defensive Stance" is in `Status_BOOST.txt` line 150, not `Spell_Target.txt`. Searching only spell files would incorrectly report it as missing.

---

### Step 3: Compare Design vs. Implementation
**Create a comparison table**:

| Ability Name | Designed? | Implemented? | File Location | Notes |
|--------------|-----------|--------------|---------------|-------|
| Sunder Armor | Yes (as Heroic Strike replacement) | ✅ Yes | Spell_Target.txt line 311 | Design decision |
| Defensive Stance | Yes | ✅ Yes | Status_BOOST.txt line 150 | Status effect, not spell |
| Indomitable | Yes | ❌ No | N/A | Actually missing |

**Red Flags**:
- ❌ Claiming ability is missing without checking status effects
- ❌ Claiming ability exists without providing line numbers
- ❌ Contradicting user without checking design docs first

---

### Step 4: Update Documentation (MANDATORY)
**Every change requires documentation updates.**

#### If You Change Code:
1. Update relevant `.md` files in `Documentation/06_ProjectDocuments/` or `07_DesignDocuments/`
2. Update `ABILITY_IMPLEMENTATION_INVENTORY.md` if abilities added/removed
3. Add entry to validation reports if fixing bugs

#### If You Move/Rename Files:
1. Update `README.md` with new paths
2. Update `INDEX.md` with new structure
3. Update `.github/copilot-instructions.md` if folder structure changes
4. Create migration document (like `DOCUMENTATION_MERGE_COMPLETE.md`)

#### If You Discover Errors:
1. Create correction document in `Documentation/10_ValidationReports/`
2. Include evidence: line numbers, file paths, actual code snippets
3. Update affected design docs to match reality

**Example**: When discovering 3 "missing" abilities were actually implemented:
- ✅ Created `ACTUAL_MISSING_ABILITIES.md` with proof
- ✅ Updated `.github/copilot-instructions.md` with corrected status
- ✅ Created `MERGE_SUMMARY_FINAL.md` documenting the discovery

---

### Step 5: Validate & Document Changes
**Before completing any task**:

1. **Verify files exist**: Use `Test-Path` or `Get-ChildItem` to confirm
2. **Check build system**: Ensure `Ctrl+Shift+B` still works (if touching Data/ folder)
3. **Create backup files**: List all affected files before major moves
4. **Document what changed**: Create summary .md file with before/after state
5. **Update todo list**: Mark completed tasks, note any pending work

**Deliverables**:
- Summary document (e.g., `MERGE_SUMMARY_FINAL.md`)
- Evidence documents (e.g., `ACTUAL_MISSING_ABILITIES.md`)
- Backup files if applicable
- Updated key reference files (README.md, copilot-instructions.md)

---

## 🎯 Common Pitfalls to Avoid

### ❌ DON'T: Assume abilities are missing without checking status effects
**Why**: Many abilities are implemented as status effects in `Status_BOOST.txt`, not as spell entries in `Spell_*.txt` files.

**Example**: Defensive Stance, Shield Block - both in Status_BOOST.txt

**DO Instead**: Check ALL file types before claiming something is missing.

---

### ❌ DON'T: Contradict user statements without verification
**Why**: User knows their project better than AI scanning results.

**Example**: User said "I believe we converted heroic strike to sunder" - they were correct. Sunder Armor is in Spell_Target.txt line 311.

**DO Instead**: Verify user's statement by reading actual files, then confirm or ask clarifying questions.

---

### ❌ DON'T: Make changes without updating documentation
**Why**: Documentation drift causes confusion in future sessions.

**Example**: Moving files without updating INDEX.md creates broken links.

**DO Instead**: Update documentation IMMEDIATELY as part of the same change.

---

### ❌ DON'T: Rely on grep results alone
**Why**: Grep can miss implementations with different naming conventions or in unexpected file types.

**Example**: Searching for "Shield Block" in spell files won't find it in Status_BOOST.txt.

**DO Instead**: Read actual file contents to verify implementation details.

---

### ❌ DON'T: Create reports without evidence
**Why**: Claims without proof can't be verified and may be incorrect.

**Example**: "5 abilities are missing" without checking which files were scanned.

**DO Instead**: Include line numbers, file paths, and code snippets in all reports.

---

## 📚 Required Reading Before ANY Work

### First-Time Setup (Read Once)
1. `.github/copilot-instructions.md` - Project overview, architecture, conventions
2. `README.md` - Quick start, project status
3. `Documentation/01_Reference-Guides/PROJECT_INDEX.md` - Complete file inventory
4. `Documentation/06_ProjectDocuments/GETTING_STARTED.md` - Implementation approach

### Before Code Changes (Read Every Time)
1. `Documentation/07_DesignDocuments/Warrior_Class_Blueprint.md` - Intended design
2. `Documentation/06_ProjectDocuments/FILE_REFERENCE.md` - File format syntax
3. Relevant `PASSIVES_*.md` files if touching passives

### Before Documentation Changes (Read Every Time)
1. `INDEX.md` - Current navigation structure
2. `Documentation/01_Reference-Guides/PROJECT_INDEX.md` - File locations
3. Files being referenced in the documentation

---

## ✅ Success Criteria Checklist

Before marking any task complete:

- [ ] Read relevant design documents from `Documentation/07_DesignDocuments/`
- [ ] Scanned ALL implementation files (spells, status effects, passives)
- [ ] Created comparison table (design vs. implementation)
- [ ] Updated documentation for any changes made
- [ ] Created evidence-based reports with line numbers
- [ ] Verified files exist and build system works
- [ ] Created summary document for user
- [ ] Updated todo list

**If all boxes checked** → Task is complete  
**If any boxes unchecked** → Task is incomplete, do not claim completion

---

## 🔄 This Protocol Itself

**This document should be updated** whenever:
- New common pitfalls are discovered
- Workflow improvements are identified
- File structure changes significantly
- New validation requirements emerge

**Location**: `Documentation/03_Workflows/AI_AGENT_PROTOCOL.md`

**Last Updated**: October 17, 2025  
**Version**: 1.0  
**Status**: ⚠️ MANDATORY for all AI agents working on BG3Wow project

---

## 💡 Key Takeaway

> **Read design docs → Scan implementation → Compare → Document changes → Validate**

**Never skip steps. Never assume. Always verify. Always document.**

This protocol exists because previous sessions made assumptions without checking design docs or status effect files, leading to incorrect reports. Following this protocol ensures accurate, well-documented work.
