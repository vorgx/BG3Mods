# Sources of Truth - Project Authority Documents

This folder contains the **authoritative sources** for the BG3Wow Warrior mod project.

## 📌 Priority Order

### **#1 SOURCE_OF_TRUTH.md** ← START HERE
- **The** living document with current project state
- Always up-to-date, never outdated
- 12 comprehensive sections covering all aspects
- Updated after every change with timestamps

### **#2 WARLOCK_REVERSE_ENGINEERING.md**
- Reference material from proven WoWWarlock mod (13K+ downloads)
- Template patterns and structure guide
- **Use for**: Understanding BG3 modding patterns
- **Don't use for**: Current Warrior mod state (use SOURCE_OF_TRUTH.md)

## 🚨 Critical Rules

### For AI Agents:
1. **ALWAYS** read SOURCE_OF_TRUTH.md relevant section BEFORE making changes
2. **ALWAYS** update SOURCE_OF_TRUTH.md AFTER changes + tests pass
3. **NEVER** use Archive/ folder information unless explicitly asked
4. **NEVER** skip cross-reference validation when moving files

### For Users:
- Bookmark `SOURCE_OF_TRUTH.md` for quick reference
- Check "Last Updated" timestamps to verify freshness
- If information conflicts, SOURCE_OF_TRUTH.md wins

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

✅ **Belongs in this folder**:
- SOURCE_OF_TRUTH.md (living document)
- Reference materials from proven mods (Warlock, etc.)
- Core design specifications (if not in DesignDocuments/)

❌ **Does NOT belong here**:
- Session summaries (→ `Documentation/05_SessionReports/`)
- Implementation guides (→ `Documentation/06_ProjectDocuments/`)
- Analysis reports (→ `Reports/04_Analysis/`)
- Old/outdated docs (→ `Archive/`)

## 🎯 Why This Matters

**Problem**: Previous sessions had conflicting information across 30+ scattered documents  
**Solution**: Single source of truth with automated enforcement  
**Result**: No more confusion about current state, no more old data being used

---

**Last Updated**: October 19, 2025  
**Folder Created**: October 19, 2025 (Phase 2 of restructure)
