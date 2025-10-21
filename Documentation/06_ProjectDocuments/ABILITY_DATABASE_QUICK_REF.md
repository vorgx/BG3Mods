# Ability Database Quick Reference

**Created**: October 20, 2025  
**Purpose**: Quick access to all ability database outputs

---

## 📁 Primary Files

### Enriched Database (USE THIS ONE)
```
Documentation/00_SourcesOfTruth/AbilityDatabase_Warrior_FullyEnriched.csv
```
- **215 abilities** (clean)
- **46 fully enriched** with WoW + BG3 data
- **90 flagged for review**
- **79 ready for basic implementation**

### Review Queue
```
Documentation/00_SourcesOfTruth/ABILITIES_NEEDING_REVIEW.md
```
- **90 abilities** requiring research
- Resource usage breakdown
- Next steps action plan

### Original Database (Archive)
```
Documentation/00_SourcesOfTruth/AbilityDatabase_Warrior.csv
```
- Pre-enrichment version
- Keep for reference only

---

## 📚 Documentation

### User Guide
```
Documentation/00_SourcesOfTruth/AbilityDatabase_README.md
```
- Schema explanation
- PowerShell usage examples
- Workflow guides

### WoW Research Links
```
Documentation/00_SourcesOfTruth/WOW_SOURCE_REFERENCES.md
```
- 3 Icy-Veins URLs (Arms/Fury/Protection)
- Wowhead spell IDs
- Extraction workflow

### Source of Truth
```
Documentation/00_SourcesOfTruth/SOURCE_OF_TRUTH.md
```
- Section [13]: Master Ability Database
- Phase 3 enrichment results
- Resource analysis

### Session Summary
```
ENRICHMENT_COMPLETE_SUMMARY.md (root)
```
- Complete enrichment statistics
- Example conversions
- Next steps recommendations

### Handover Document
```
HANDOVER_ABILITY_DATABASE_OCT20.md (root)
```
- Session summary
- 3 strategic options
- Decision point guidance

---

## 🛠️ Scripts

### Enrichment Script (Reusable)
```
COMPREHENSIVE_WOW_ENRICHMENT.ps1 (root)
```
- 1,100+ lines
- 46 ability library
- Can be extended for remaining abilities

**Usage**:
```powershell
.\COMPREHENSIVE_WOW_ENRICHMENT.ps1
```

### Database Creation Pipeline (Archive)
```
CREATE_ABILITY_DATABASE.ps1 (root)
CLEANUP_ABILITY_DATABASE.ps1 (root)
FIX_CLASSIFICATION.ps1 (root)
```
- Historical - already executed
- Keep for reference/reproducibility

---

## 📊 Key Statistics (Memorize These)

| Metric | Value |
|--------|-------|
| **Total abilities (clean)** | 215 |
| **Fully enriched** | 46 (21.4%) |
| **Review queue** | 90 (41.9%) |
| **Ready to implement** | 46 core + 79 simple = 125 (58.1%) |
| **Existing resources** | 6 (Rage, MobilityCharge, ShieldBlockCharge, EnrageState, ExecuteWindow, RiposteCharge) |
| **New resources needed** | 0 ❌ (All 215 abilities work with current system!) |

---

## 🎯 Next Steps (Choose One)

### Option 1: Complete Enrichment (90 abilities)
```bash
# Research from Icy-Veins
# Convert to BG3 functors
# Populate database
# Time: 8-10 hours
```

### Option 2: Start Implementation (FILES 4-10)
```bash
# Use 46 enriched abilities as reference
# Transform stat files
# Build working mod
# Time: Ongoing
```

### Option 3: Build Dependencies (3-4 hours)
```bash
# Map requires_ability, unlocks_ability, modified_by
# Parse SOURCE_OF_TRUTH.md Section [4]
# Complete relationship graph
# Time: 3-4 hours
```

---

## 🔍 How to Find Things

### "Where's the enriched database?"
→ `Documentation/00_SourcesOfTruth/AbilityDatabase_Warrior_FullyEnriched.csv`

### "Which abilities need research?"
→ `Documentation/00_SourcesOfTruth/ABILITIES_NEEDING_REVIEW.md`

### "Where are the Icy-Veins URLs?"
→ `Documentation/00_SourcesOfTruth/WOW_SOURCE_REFERENCES.md`

### "How do I use the database?"
→ `Documentation/00_SourcesOfTruth/AbilityDatabase_README.md`

### "What's the current status?"
→ `Documentation/00_SourcesOfTruth/SOURCE_OF_TRUTH.md` Section [13]

### "What happened this session?"
→ `HANDOVER_ABILITY_DATABASE_OCT20.md` (root)

---

## ✅ Quick Wins Available

These 46 abilities are **fully enriched and ready to implement**:

**Core Attacks**: Mortal Strike, Execute, Bloodthirst, Rampage, Raging Blow, Shield Slam, Revenge, Overpower, Slam, Onslaught, Devastate, Cleave

**Mobility**: Charge, Heroic Leap, Intervene

**Cooldowns**: Avatar, Bladestorm, Recklessness, Shield Wall, Last Stand, Die by the Sword, Enraged Regeneration, Colossus Smash

**Utilities**: Battle Shout, Rallying Cry, Pummel, Taunt, Hamstring, Heroic Throw, Victory Rush, Storm Bolt, Spell Reflection, Thunder Clap, Shockwave, Whirlwind

**AoE**: Thunderous Roar, Odyn's Fury

**Defensives**: Ignore Pain, Shield Block, Berserker Rage

**Stances**: Battle Stance, Defensive Stance

**Passives**: Mastery: Deep Wounds, Mastery: Critical Block, Titan's Grip, Riposte

---

**Total**: 46 abilities with complete WoW mechanics + BG3 conversion data!

---

*Last updated: October 20, 2025*
