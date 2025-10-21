# WoW Source References - Documentation Complete

**Date**: October 20, 2025  
**Status**: ✅ Complete  
**Purpose**: Document official WoW Warrior source material for ability data enrichment

---

## 🎯 Objective

User provided 3 Icy-Veins URLs with request:
> "here are the 3 icy veins links, document them we can always use them for getting warrior data from online"

**Goal**: Create permanent reference documentation for WoW Warrior ability data sources

---

## 📚 URLs Documented

### Official Icy-Veins Spell Summaries

1. **Arms Warrior**: https://www.icy-veins.com/wow/arms-warrior-pve-dps-spell-summary
   - Mortal Strike, Execute, Colossus Smash, Bladestorm
   - Arms-specific talents and rotations
   - Author commentary on gameplay value

2. **Protection Warrior**: https://www.icy-veins.com/wow/protection-warrior-pve-tank-spell-summary
   - Shield Slam, Revenge, Shield Block, Shield Wall
   - Tank-specific mechanics and mitigation
   - Rage generation vs spending balance

3. **Fury Warrior**: https://www.icy-veins.com/wow/fury-warrior-pve-dps-spell-summary
   - Rampage, Bloodthirst, Raging Blow, Recklessness
   - Enrage mechanics and dual-wield gameplay
   - Fast-paced rotation priorities

---

## 📁 Files Created

### 1. WOW_SOURCE_REFERENCES.md
**Location**: `Documentation/08_WoWSourceMaterial/WOW_SOURCE_REFERENCES.md`

**Contents** (2,600+ words):
- ✅ All 3 Icy-Veins URLs with detailed descriptions
- ✅ Hero Talent Tree references (Mountain Thane, Colossus, Slayer)
- ✅ Wowhead database links and spell ID patterns
- ✅ Data usage guidelines (when to use each source)
- ✅ Extraction workflow (5-step process)
- ✅ Extraction status table (6 documents tracked)
- ✅ Quick reference table (15 core abilities with Wowhead IDs)
- ✅ WoW vs BG3 differences documentation
- ✅ Data freshness tracking (TWW Season 1, Patch 11.0.5)

**Sections**:
1. Primary Sources (Icy-Veins spell summaries)
2. Hero Talent Trees (Level 71+ content)
3. Wowhead Database (individual spell pages)
4. Data Usage Guidelines (when to use each source)
5. Extraction Workflow (step-by-step process)
6. Extraction Status (tracking completed docs)
7. Quick Reference Table (core abilities)
8. Related BG3Wow Documents
9. Notes (WoW vs BG3 differences, data freshness)

---

### 2. SOURCE_OF_TRUTH.md Updates
**Location**: `Documentation/00_SourcesOfTruth/SOURCE_OF_TRUTH.md`

**Changes**:
- ✅ Added "WoW Source References" subsection to [13] Master Ability Database
- ✅ Included all 3 Icy-Veins URLs with usage notes
- ✅ Cross-referenced extraction documents in `Documentation/08_WoWSourceMaterial/`
- ✅ Added Wowhead database reference
- ✅ Updated Change Log with entry

**New Section Content**:
```markdown
### WoW Source References

**Official Icy-Veins Guides** (Live WoW TWW Season 1 - Authoritative ability data):

- **Arms Warrior**: https://www.icy-veins.com/wow/arms-warrior-pve-dps-spell-summary
- **Protection Warrior**: https://www.icy-veins.com/wow/protection-warrior-pve-tank-spell-summary
- **Fury Warrior**: https://www.icy-veins.com/wow/fury-warrior-pve-dps-spell-summary
```

---

## 📊 Reference Data Cataloged

### Spell IDs Documented (15 Core Abilities)
| Ability | Wowhead ID | Spec | Rage Cost |
|---------|------------|------|-----------|
| Mortal Strike | 12294 | Arms | 30 |
| Execute | 5308 | All | 20 |
| Bloodthirst | 23881 | Fury | 20 |
| Rampage | 184367 | Fury | 80 |
| Shield Slam | 23922 | Protection | 0 (gen 15) |
| Revenge | 6572 | Protection | 30 |
| Whirlwind | 1680 | All | 0 (gen 10) |
| Charge | 100 | All | 0 (gen 20) |
| Avatar | 107574 | All | 0 |
| Bladestorm | 227847 | Arms | 0 |
| Thunderous Roar | 384318 | Arms | 0 |
| Recklessness | 1719 | Fury | 0 |
| Shield Wall | 871 | Protection | 0 |
| Last Stand | 12975 | Protection | 0 |
| Ignore Pain | 190456 | Protection | 40 |

### Hero Talent Tree URLs
- **Mountain Thane** (Protection + Fury) - Documented
- **Colossus** (Arms + Protection) - Documented
- **Slayer** (Arms + Fury) - Documented

### Extraction Status
- ✅ Fury Warrior: Complete
- ✅ Colossus: Complete
- 🟡 Arms Warrior: Pending
- 🟡 Protection Warrior: Pending
- 🟡 Mountain Thane: Pending
- 🟡 Slayer: Pending

---

## 🎯 Usage Benefits

### For Ability Database Enrichment
1. **Rage Costs**: Pull from Icy-Veins spell summaries → populate `wow_cost_rage` column
2. **Descriptions**: Copy ability descriptions → populate `description_full` column
3. **Wowhead URLs**: Use spell IDs → populate `implementation_notes` or future `wow_url_wowhead` column
4. **Author Notes**: Extract gameplay commentary → inform `implementation_priority`
5. **Mechanics**: Parse formulas → populate `bg3_spell_success`, `damage_formula_bg3`

### For Design Decisions
1. **Rotation Priority**: Identify "must-have" vs "skip" talents
2. **Synergies**: Map talent interactions for `modified_by` column
3. **Build Archetypes**: Determine archetype tags from spec-specific abilities
4. **Balance**: Compare WoW rage costs to ensure BG3 adaptation is balanced

### For Implementation
1. **Visual Effects**: Watch Wowhead videos for VFX inspiration
2. **Tooltip Wording**: Use exact WoW tooltips for authenticity
3. **Historical Context**: Check Wowhead for ability changes across patches
4. **Community Feedback**: Read comments for hidden mechanics

---

## 🔗 Cross-References

### Related Documents
- `SOURCE_OF_TRUTH.md [13]` - Master Ability Database section
- `AbilityDatabase_Warrior.csv` - 215 abilities ready for WoW data enrichment
- `AbilityDatabase_README.md` - Database usage guide
- `ABILITY_DATABASE_PLANNING.md` - Schema design rationale

### Extraction Documents
- `FURY_WARRIOR_ICYVEINS_EXTRACTION.md` ✅ (Complete)
- `COLOSSUS_ICYVEINS_EXTRACTION.md` ✅ (Complete)
- `ARMS_WARRIOR_ICYVEINS_EXTRACTION.md` 🟡 (Pending)
- `PROTECTION_WARRIOR_ICYVEINS_EXTRACTION.md` 🟡 (Pending)
- `MOUNTAIN_THANE_ICYVEINS_EXTRACTION.md` 🟡 (Pending)
- `SLAYER_ICYVEINS_EXTRACTION.md` 🟡 (Pending)

---

## 📋 Next Steps

### Immediate (Current Session)
- ✅ Document Icy-Veins URLs in permanent reference
- ✅ Create WOW_SOURCE_REFERENCES.md
- ✅ Update SOURCE_OF_TRUTH.md with links
- 🔄 Continue with Steps 2-4 of enrichment plan

### Future Sessions
1. **Extract Arms Data** - Parse Arms Warrior spell summary
2. **Extract Protection Data** - Parse Protection Warrior spell summary
3. **Extract Hero Talents** - Parse Mountain Thane and Slayer trees
4. **Enrich Database** - Populate all WoW data columns from extractions
5. **Add Wowhead URLs** - Generate spell URLs for all abilities

---

## ✅ Success Metrics

**Quantitative**:
- ✅ 3 Icy-Veins URLs documented
- ✅ 15 Wowhead spell IDs cataloged
- ✅ 6 extraction documents tracked
- ✅ 2,600+ word reference document created
- ✅ SOURCE_OF_TRUTH.md updated with cross-references

**Qualitative**:
- ✅ Permanent reference for WoW ability data
- ✅ Clear extraction workflow documented
- ✅ Data usage guidelines established
- ✅ WoW vs BG3 differences explained
- ✅ Future-proof for additional classes (Warlock, Death Knight, etc.)

---

**Status**: ✅ Complete - WoW sources documented and ready for use  
**Next Action**: Continue with ability database enrichment (Steps 2-4)
