# WoW Hero Talents HTML Scraping - Session Summary

**Date**: October 20, 2025  
**Objective**: Extract Slayer hero talent data from Wowhead HTML files and document for BG3 mod implementation  
**Status**: ✅ Phase 1 Complete - Documentation Library Updated + Slayer Keystone Extracted

---

## ✅ Completed Tasks

### 1. Documentation Library Updated
**File**: `Documentation/01_Reference-Guides/DOCUMENTATION_LIBRARY.md`

Added new section **"WoW Hero Talent HTML References"** with 6 file links:
- Arms Warrior - Slayer (`c:\WowSource\Arms Warrior DPS Guide - The War Within 11.2 - Wowhead - Slayer.html`)
- Arms Warrior - Colossus (`c:\WowSource\Arms Warrior DPS Guide - The War Within 11.2 - Wowhead- Colossus.html`)
- Fury Warrior - Mountain Thane (`c:\WowSource\Fury Warrior DPS Guide - The War Within 11.2 - Wowhead - Mountain Thane.html`)
- Fury Warrior - Slayer (`c:\WowSource\Fury Warrior DPS Guide - The War Within 11.2 - Wowhead - Slayer.html`)
- Protection Warrior - Colossus (`c:\WowSource\Protection Warrior Tank Guide - The War Within 11.2 - Wowhead - Colossus.html`)
- Protection Warrior - Mountain Thane (`c:\WowSource\Protection Warrior Tank Guide - The War Within 11.2 - Wowhead - Mountain Thane.html`)

**Tag**: `[EXT-LOCAL]` - External local hard drive files (not in workspace)

---

### 2. Slayer Hero Talent Document Created
**File**: `Documentation/08_WoWSourceMaterial/SLAYER_HERO_TALENTS_COMPLETE.md`

**Content Extracted**:
- ✅ **Keystone (L13)**: Slayer's Dominance - Full description extracted from HTML
  - Spell ID: 444767
  - Mechanics: Slayer's Strike proc + Marked for Execution debuff (stacks 3x)
  - Damage: 333.5% of Attack Power
  - Execute buff: +15% per stack (up to +45%)

- 🟡 **Tier 1-3 Talents (L15, L17, L19)**: Names identified, descriptions pending
  - L15: Imminent Demise, Reap the Storm, Opportunist
  - L17: Overwhelming Blades, Vicious Agility, Death Drive
  - L19: Culling Cyclone, Brutal Finish, Slayer's Strike

- 🟡 **Capstone (L20)**: Unrelenting Onslaught - Name confirmed, description pending

**BG3 Implementation Plan Included**:
- File changes required (ClassDescriptions.lsx, Progressions.lsx, Passive.txt, etc.)
- Boosts and StatsFunctors strategy
- Localization handle estimates (22+ handles)
- Known gaps and next steps documented

---

### 3. Extraction Script Created
**File**: `Scripts/Extract-SlayerTalents.ps1`

**Status**: 🟡 PARTIAL - Script created but encountered HTML entity decoding issues

**Issue**: PowerShell 5.1 doesn't have `System.Web.HttpUtility` loaded by default

**Lessons Learned**:
- Wowhead HTML files are saved web pages with extensive ad frameworks and JavaScript
- Talent data is embedded in HTML attributes (data-row, data-column, href with spell IDs)
- Tooltip descriptions may be dynamically loaded (not always in saved HTML)
- Manual Wowhead research may be more reliable than automated scraping for tooltips

**Next Steps for Script**:
- Remove System.Web.HttpUtility dependency
- Use simpler HTML entity decoding (regex-based)
- Add better error handling
- Test with Mountain Thane and Colossus HTML files

---

## 📊 Data Extraction Summary

### Successfully Extracted
| Talent | Spell ID | Description | Position | Implementation Notes |
|--------|---------|-------------|----------|---------------------|
| **Slayer's Dominance** | 444767 | ✅ Complete | Row 1, Col 10 | Keystone, passive, triggers Slayer's Strike proc + Marked for Execution stacking debuff |
| **Imminent Demise** | 444769 | ❌ Pending | Row 2 | Likely Execute enhancement |

### Pending Manual Research (10 talents)
- Reap the Storm
- Opportunist
- Overwhelming Blades
- Vicious Agility
- Death Drive
- Culling Cyclone
- Brutal Finish
- Slayer's Strike (talent)
- Unrelenting Onslaught

**Action Required**: Visit Wowhead URLs for each talent to get:
1. Full tooltip description
2. Numerical values (damage %, proc chance, cooldowns)
3. Prerequisite chains
4. Any conditional effects

---

## 🎯 Next Steps

### Immediate (This Session or Next)
1. **Manual Wowhead Research**:
   - Open each Slayer talent on Wowhead
   - Copy full tooltip text
   - Document in SLAYER_HERO_TALENTS_COMPLETE.md
   - Note any synergies or build-around mechanics

2. **Repeat for Mountain Thane**:
   - Create `MOUNTAIN_THANE_HERO_TALENTS_COMPLETE.md`
   - Extract Lightning Strikes keystone details
   - Document all 11 Mountain Thane talents

3. **Repeat for Colossus**:
   - Create `COLOSSUS_HERO_TALENTS_COMPLETE.md`
   - Extract Demolish keystone details
   - Document all 11 Colossus talents

### Medium-Term (Section 5 Implementation)
4. **Section 5 Phase 1** (Structure Setup):
   - Add 3 ClassDescription nodes (Slayer, Mountain Thane, Colossus)
   - Add 24 Progressions nodes (8 per spec, L13-L20)
   - Test: Hero specialization choice appears at L13

5. **Section 5 Phase 2-7** (Talent Implementation):
   - Implement 33 hero talent passives
   - Create new spells/abilities as needed
   - Add status effects
   - Test each tier as it's implemented

6. **Section 5 Phase 8** (Localization & Testing):
   - Generate 70-80 localization handles
   - Full playthrough testing all 3 specs L13-L20

---

## 🔧 Technical Challenges Encountered

### Challenge 1: HTML Complexity
- **Problem**: Wowhead HTML files contain massive amounts of ad framework code, cookie consent JavaScript, and minified code
- **Impact**: Makes regex parsing fragile and prone to false matches
- **Solution**: Focus on specific HTML attribute patterns (data-row, data-column, spell ID in hrefs)

### Challenge 2: Tooltip Embedding
- **Problem**: Tooltip descriptions may be loaded dynamically via JavaScript, not embedded in saved HTML
- **Impact**: Can't reliably extract full descriptions without visiting live Wowhead
- **Solution**: Combine automated extraction (spell IDs, names, positions) with manual research (descriptions)

### Challenge 3: PowerShell Type Loading
- **Problem**: System.Web.HttpUtility not available in PowerShell 5.1 by default
- **Impact**: HTML entity decoding fails (e.g., `&#39;` for apostrophes)
- **Solution**: Use regex-based entity decoding or upgrade to PowerShell 7+

---

## 📚 Documentation Updates Made

1. **DOCUMENTATION_LIBRARY.md**:
   - Added "WoW Hero Talent HTML References" section
   - Updated "Last Updated" timestamp to October 20, 2025
   - Added description for all 6 HTML files

2. **SLAYER_HERO_TALENTS_COMPLETE.md** (NEW):
   - Complete Slayer talent tree structure (11 talents)
   - Full description for keystone (Slayer's Dominance)
   - BG3 implementation plan with file changes
   - Visual grid showing talent positions
   - Known gaps and next steps documented

3. **Extract-SlayerTalents.ps1** (NEW):
   - Automated extraction script (needs fixes)
   - Documented for future improvement

---

## 🎓 Key Learnings

### About WoW Hero Talents
1. **Slayer Focus**: Single-target burst damage through Execute amplification
2. **Keystone Mechanic**: Slayer's Strike (automatic procs) + Marked for Execution (stacking debuff)
3. **Scaling**: Up to +45% Execute damage with 3 stacks of Marked for Execution
4. **Tree Structure**: Linear progression (Keystone → 3 tiers → Capstone), all auto-granted in our implementation

### About HTML Scraping for BG3 Mods
1. **Wowhead Structure**: Uses `dragonflight-talent-tree-grid` classes with data attributes
2. **Spell IDs**: Embedded in href attributes (`https://www.wowhead.com/spell=444767/...`)
3. **Grid Positions**: `data-row` and `data-column` attributes define talent tree layout
4. **Tooltips**: May require live web requests or manual copying

### About BG3 Hero Talent Implementation
1. **Zero SpellLists**: Use PassivesAdded exclusively (confirmed strategy)
2. **UnlockSpell Boosts**: Passives can grant new spells via Boost syntax
3. **Stacking Debuffs**: Use Status_BOOST with `StackId` and `StackPriority`
4. **Proc Mechanics**: Use StatsFunctors with Conditions to trigger effects

---

## 📊 Session Statistics

- **Files Created**: 3
  - SLAYER_HERO_TALENTS_COMPLETE.md
  - Extract-SlayerTalents.ps1
  - WOWSOURCE_HERO_TALENTS_SESSION_SUMMARY.md (this file)

- **Files Modified**: 1
  - DOCUMENTATION_LIBRARY.md

- **HTML Files Cataloged**: 6 (all 3 hero specs × 2 subclass perspectives)

- **Talents Documented**: 11 (Slayer tree)
  - Fully documented: 1 (Slayer's Dominance)
  - Partially documented: 10 (names only, descriptions pending)

- **Time Spent**: ~45 minutes
  - Documentation Library update: 5 min
  - HTML exploration: 15 min
  - Script creation: 10 min
  - Manual document creation: 10 min
  - Summary writing: 5 min

---

## 🚀 Recommended Next Session Workflow

### Option A: Complete Slayer Research (30-45 min)
1. Open Slayer document: `SLAYER_HERO_TALENTS_COMPLETE.md`
2. Visit Wowhead for each of 10 pending talents
3. Copy tooltip descriptions
4. Update document with full details
5. Mark Slayer as ✅ COMPLETE

### Option B: Extract All 3 Hero Specs (60-90 min)
1. Repeat Slayer extraction for Mountain Thane
2. Repeat Slayer extraction for Colossus
3. Create 2 new documents (MOUNTAIN_THANE_..., COLOSSUS_...)
4. Visit Wowhead for keystones only (3 talents)
5. Leave tier talents for later batch research

### Option C: Proceed to Section 5 Implementation (2-3 hours)
1. Assume we'll research talents as needed during implementation
2. Start Section 5 Phase 1 (ClassDescriptions + Progressions structure)
3. Implement keystones only (Slayer's Dominance + 2 others)
4. Test hero spec choice at L13
5. Pause at Phase 2 for full talent research

**Recommendation**: **Option B** - Extract all 3 keystones now (highest priority data), defer tier talent research until just before implementation. This unblocks Section 5 Phase 1-2 while keeping research manageable.

---

**Document Created**: October 20, 2025  
**Next Update**: After completing hero talent research or Section 5 implementation  
**Related Documents**:
- `Documentation/01_Reference-Guides/DOCUMENTATION_LIBRARY.md`
- `Documentation/08_WoWSourceMaterial/SLAYER_HERO_TALENTS_COMPLETE.md`
- `Scripts/Extract-SlayerTalents.ps1`
