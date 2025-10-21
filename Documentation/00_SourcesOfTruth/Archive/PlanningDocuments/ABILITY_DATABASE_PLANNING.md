# Ability Database System - Planning Document

**Date**: October 20, 2025  
**Purpose**: Design comprehensive ability library for BG3 Warrior mod  
**Status**: 🎯 PLANNING PHASE  
**Goal**: Create single source of truth for all abilities, enable cross-class mapping, simplify documentation

---

## 🎯 Core Concept

Create a **master ability database (CSV)** that serves as the authoritative reference for every ability in the mod. This database will:

1. **Eliminate duplication** - Define each ability once, reference everywhere
2. **Enable cross-referencing** - Track dependencies, prerequisites, unlocks
3. **Simplify implementation** - Clear BG3 translation for each ability
4. **Support validation** - Easy to spot missing/incomplete abilities
5. **Future-proof** - Extensible for future classes/specs

---

## 📊 Proposed CSV Schema (v1.0)

### Core Identification Columns

| Column Name | Type | Description | Example |
|-------------|------|-------------|---------|
| `ability_id` | String (PK) | Unique identifier, format: `WAR_AbilityName` | `WAR_Charge` |
| `ability_name` | String | Display name | `Charge` |
| `ability_name_variant` | String | Alt names (WoW vs BG3) | `Gap Closer` |
| `wow_source` | String | WoW expansion/patch | `The War Within 11.2` |
| `spell_id` | Integer | WoW spell ID (if applicable) | `100` |
| `description_short` | String | One-line summary | `Sprint towards enemy, generate Rage` |
| `description_full` | Text | Complete tooltip text | `Sprint towards an enemy within 25 yards, generating 20 Rage...` |
| `lore_flavor` | Text | Flavor text (optional) | `A warrior's fury begins with the charge` |

### Classification Columns

| Column Name | Type | Description | Example Values |
|-------------|------|-------------|----------------|
| `ability_type` | Enum | Primary category | `Offensive`, `Defensive`, `Utility`, `Passive`, `Resource`, `Mobility` |
| `ability_subtype` | Enum | Secondary category | `Single-Target`, `AoE`, `Buff`, `Debuff`, `Heal`, `CC` |
| `damage_type` | Enum | Damage dealt (if any) | `Physical`, `Thunder`, `Fire`, `Bleed`, `None` |
| `school` | Enum | WoW school mapping | `Martial`, `Nature`, `Arcane`, `None` |
| `archetype_tags` | String (CSV) | Build archetype relevance | `Execute,Bleed,AoE` |

### Resource & Cost Columns

| Column Name | Type | Description | Example Values |
|-------------|------|-------------|----------------|
| `wow_cost_rage` | Integer | WoW Rage cost | `20`, `0` |
| `wow_cost_special` | String | Other WoW costs | `1 Charge`, `Requires Shield` |
| `bg3_action_cost` | Enum | BG3 action economy | `Action`, `Bonus Action`, `Reaction`, `Free Action`, `None` |
| `bg3_resource_cost` | String | BG3 resource cost | `ActionPoint:1;Rage:20`, `None` |
| `bg3_cooldown` | String | BG3 cooldown format | `OncePerTurn`, `OncePerShortRest`, `OncePerCombat`, `3Turns` |
| `wow_cooldown` | String | WoW cooldown (reference) | `20 seconds`, `None`, `1.5 minutes` |

### Progression & Dependencies

| Column Name | Type | Description | Example Values |
|-------------|------|-------------|----------------|
| `unlock_level` | Integer | First available level | `1`, `3`, `13` |
| `unlock_source` | Enum | How obtained | `Baseline`, `Class Talent`, `Spec Talent`, `Hero Talent` |
| `subclass_filter` | String (CSV) | Which specs can use | `All`, `Arms`, `Fury`, `Protection`, `Arms,Fury` |
| `requires_ability` | String (CSV) | Prerequisite ability IDs | `WAR_Charge`, `WAR_Avatar,WAR_Recklessness` |
| `requires_passive` | String (CSV) | Prerequisite passive IDs | `WAR_Tactician` |
| `unlocks_ability` | String (CSV) | What this unlocks | `WAR_DoubleTime,WAR_Intervene` |
| `replaces_ability` | String | What this replaces | `WAR_VictoryRush` (for Impending Victory) |
| `modified_by` | String (CSV) | Passives that enhance it | `WAR_ImprovedExecute,WAR_CriticalThinking` |

### BG3 Implementation Columns

| Column Name | Type | Description | Example Values |
|-------------|------|-------------|----------------|
| `bg3_file_type` | Enum | Which stat file | `Spell_Target`, `Spell_Shout`, `Spell_Zone`, `Passive`, `Status_BOOST` |
| `bg3_spell_type` | Enum | Larian spell type | `Target`, `Shout`, `Zone`, `Projectile`, `Jump` |
| `bg3_target_conditions` | Text | BG3 TargetConditions | `not Dead()` |
| `bg3_spell_success` | Text | BG3 SpellSuccess functors | `DealDamage(4d12,Slashing)` |
| `bg3_use_costs` | String | BG3 UseCosts format | `ActionPoint:1;Rage:20` |
| `bg3_icon` | String | Icon path | `Action_WAR_Charge` |
| `bg3_animation` | String | Animation ID | `MeleeCharge` |
| `bg3_vfx_prepare` | String | Cast start VFX | `RS3_Fx_Spell_Cast_Charge` |
| `bg3_vfx_cast` | String | Cast launch VFX | `RS3_Fx_Charge_Trail` |
| `bg3_vfx_impact` | String | Target hit VFX | `RS3_Fx_Impact_Melee` |

### Mechanics & Balance Columns

| Column Name | Type | Description | Example Values |
|-------------|------|-------------|----------------|
| `range_yards_wow` | Integer | WoW range | `25`, `8`, `0` (melee) |
| `range_meters_bg3` | Float | BG3 range (meters) | `15`, `5`, `1.5` |
| `aoe_radius_bg3` | Float | AoE radius in meters | `3`, `0` (single-target) |
| `duration_bg3` | String | Effect duration | `6 turns`, `Permanent`, `UntilRest` |
| `damage_formula_bg3` | String | Damage calculation | `4d12+StrengthModifier`, `2d6` |
| `status_applied` | String (CSV) | Status effects applied | `WAR_ENRAGED,WAR_RAGE_GENERATOR` |
| `scaling_attribute` | Enum | Primary scaling stat | `Strength`, `Constitution`, `None` |
| `can_crit` | Boolean | Can critically hit | `TRUE`, `FALSE` |
| `interruptible` | Boolean | Can be interrupted | `TRUE`, `FALSE` |

### Documentation & Tracking Columns

| Column Name | Type | Description | Example Values |
|-------------|------|-------------|----------------|
| `implementation_status` | Enum | Current state | `Not Started`, `In Progress`, `Complete`, `Needs Testing`, `Validated` |
| `implementation_priority` | Enum | Urgency | `P0 - Critical`, `P1 - High`, `P2 - Medium`, `P3 - Low` |
| `implementation_notes` | Text | Dev notes | `Needs custom status effect for uninterruptible` |
| `wow_url_wowhead` | URL | Wowhead link | `https://www.wowhead.com/spell=100` |
| `wow_url_icyveins` | URL | Icy-Veins reference | `https://www.icy-veins.com/...` |
| `design_doc_reference` | String | Related doc section | `[4.1.3] Row 1 Baseline` |
| `test_checklist` | Text | Validation steps | `1. Cast at max range 2. Verify Rage gain 3. Check cooldown` |
| `known_issues` | Text | Bug tracking | `Icon missing, using placeholder` |
| `change_log` | Text | Version history | `v1.0.0.3: Reduced cooldown from 30s to 20s` |

---

## 🎨 Recommended Column Groups by Priority

### Phase 1: Minimum Viable Database (MVP)
**Essential for basic tracking**

✅ Core: `ability_id`, `ability_name`, `description_short`, `description_full`  
✅ Classification: `ability_type`, `ability_subtype`  
✅ Progression: `unlock_level`, `unlock_source`, `subclass_filter`  
✅ Implementation: `bg3_file_type`, `implementation_status`

**Total**: 11 columns

---

### Phase 2: Full Feature Set
**Enables complete implementation**

✅ Everything from Phase 1, plus:  
✅ Resource: `wow_cost_rage`, `bg3_action_cost`, `bg3_resource_cost`, `bg3_cooldown`  
✅ Dependencies: `requires_ability`, `unlocks_ability`, `modified_by`  
✅ BG3 Implementation: `bg3_spell_type`, `bg3_spell_success`, `bg3_use_costs`  
✅ Mechanics: `range_meters_bg3`, `damage_formula_bg3`, `status_applied`

**Total**: 22 columns

---

### Phase 3: Production Quality
**Professional-grade documentation**

✅ Everything from Phase 2, plus:  
✅ All VFX columns (`bg3_vfx_prepare`, `bg3_vfx_cast`, `bg3_vfx_impact`)  
✅ All tracking columns (`implementation_notes`, `test_checklist`, `known_issues`, `change_log`)  
✅ All reference columns (`wow_url_wowhead`, `design_doc_reference`)  
✅ All balance columns (`can_crit`, `interruptible`, `scaling_attribute`)

**Total**: 40+ columns

---

## 🗂️ Proposed File Structure

```
Documentation/00_SourcesOfTruth/
├── SOURCE_OF_TRUTH.md                              # Master doc (unchanged)
├── Warrior Progression for all subclasses.csv      # Existing progression table
├── AbilityDatabase_Warrior.csv                     # NEW: Master ability DB
├── AbilityDatabase_Warrior_Changelog.md            # NEW: Track DB changes
└── AbilityDatabase_README.md                       # NEW: How to use the DB
```

---

## 📋 Database Population Strategy

### Option A: Bottom-Up (Recommended)
**Start with what we know is complete**

1. **Extract from existing implementations** (Stats/Generated/Data/*.txt)
   - Scan `Spell_Target.txt`, `Spell_Zone.txt`, `Passive.txt`, etc.
   - Parse existing entries into CSV rows
   - Mark as `implementation_status: Complete`
   - **Estimated**: 135 abilities already implemented

2. **Cross-reference with design docs**
   - Fill in missing metadata from markdown files
   - Add WoW descriptions from Icy-Veins extractions
   - Link to design doc sections

3. **Identify gaps**
   - Mark missing abilities as `Not Started`
   - Prioritize based on dependencies

**Pros**: Accurate reflection of current state  
**Cons**: More manual work upfront

---

### Option B: Top-Down
**Start with complete design, then map to implementation**

1. **Extract from Excel progression table**
   - Parse all ability names from CSV
   - Extract level/tier assignments
   - Add to database with metadata

2. **Enrich with WoW source data**
   - Add descriptions from Icy-Veins
   - Add Wowhead spell IDs
   - Add mechanics from design docs

3. **Map to implementation files**
   - Cross-reference with existing stat files
   - Mark implementation status

**Pros**: Complete picture from start  
**Cons**: May include abilities not yet implemented

---

### Option C: Hybrid (RECOMMENDED)
**Combine both approaches**

1. **Start with Excel as skeleton** (all ability names + progression)
2. **Mark existing implementations** (scan stat files)
3. **Enrich with WoW data** (Icy-Veins + Wowhead)
4. **Add BG3 implementation details** (from existing files)
5. **Document gaps and priorities**

**Pros**: Best of both worlds  
**Cons**: Most time-intensive (but worth it)

---

## 🔗 Integration with Existing Systems

### Source of Truth Updates
**After DB is created, update SOURCE_OF_TRUTH.md:**

```markdown
## [13] Master Ability Database

**File**: `Documentation/00_SourcesOfTruth/AbilityDatabase_Warrior.csv`  
**Last Updated**: October 20, 2025  
**Total Abilities**: 189 (135 implemented, 54 planned)

### Quick Stats
- Baseline (L1-L12): 35 abilities
- Class Talents: 50 abilities
- Spec Talents (Arms): 35 abilities
- Spec Talents (Fury): 34 abilities
- Spec Talents (Protection): 35 abilities
- Hero Talents (3 specs): 33 abilities
- Passives: 67 total

### Column Schema
- **Phase 1 (MVP)**: 11 core columns
- **Phase 2 (Full)**: 22 columns
- **Phase 3 (Production)**: 40+ columns

### Usage
1. **For Implementation**: Check `bg3_file_type`, `bg3_spell_success`, `implementation_status`
2. **For Documentation**: Use `description_full`, `design_doc_reference`
3. **For Testing**: Review `test_checklist`, `known_issues`
4. **For Design**: Filter by `subclass_filter`, `unlock_level`, `archetype_tags`
```

---

## 🛠️ Tooling Recommendations

### CSV Editor Options

**Option 1: Excel/LibreOffice Calc**
- ✅ Pros: Powerful filtering, formulas, pivot tables
- ❌ Cons: Not git-friendly, merge conflicts

**Option 2: VS Code + Rainbow CSV Extension**
- ✅ Pros: Git-friendly, syntax highlighting, inline editing
- ❌ Cons: Limited sorting/filtering vs spreadsheets

**Option 3: Hybrid Approach (RECOMMENDED)**
- Use Excel for bulk editing/analysis
- Export to CSV for git commits
- Use VS Code for quick edits

---

### Validation Scripts

**Create PowerShell validation scripts:**

```powershell
# Scripts/Validate-AbilityDatabase.ps1
- Check for duplicate ability_ids
- Verify required fields are populated
- Validate foreign key references (requires_ability, unlocks_ability)
- Check implementation_status consistency
- Generate summary report
```

---

## 🎯 Recommended Additional Columns

### Your Original Ideas ✅
- [x] `id` → `ability_id` ✅
- [x] `name` → `ability_name` ✅
- [x] `description` → `description_short`, `description_full` ✅
- [x] `ability_type` ✅ (Passive, Offensive, Utility, etc.)
- [x] `resource_cost` → `wow_cost_rage`, `bg3_resource_cost` ✅
- [x] `bg3_cost` → `bg3_action_cost` ✅ (Action, Bonus Action, Reaction)
- [x] `requires` → `requires_ability`, `requires_passive` ✅
- [x] `unlocks` → `unlocks_ability` ✅
- [x] `mechanics` → `bg3_spell_success`, `bg3_target_conditions` ✅

### My Additional Recommendations

#### Absolutely Essential
1. **`subclass_filter`** - Critical for knowing which specs can use ability
2. **`bg3_file_type`** - Required for knowing where to implement
3. **`implementation_status`** - Track progress
4. **`unlock_level`** - When player gets ability

#### Highly Valuable
5. **`modified_by`** - Track passive enhancements (e.g., "Improved Execute")
6. **`replaces_ability`** - For talents that replace baseline abilities
7. **`status_applied`** - Link to status effects (crucial for BG3)
8. **`damage_formula_bg3`** - Exact BG3 damage calculation
9. **`archetype_tags`** - Filter by build (Execute, Bleed, Tank, etc.)
10. **`bg3_cooldown`** - Critical BG3 mechanic

#### Nice to Have
11. **`wow_url_wowhead`** - Quick reference link
12. **`test_checklist`** - QA validation steps
13. **`change_log`** - Version tracking
14. **`bg3_vfx_*`** - Visual polish columns
15. **`lore_flavor`** - Immersion/RP text

---

## 📊 Example Database Rows

### Example 1: Simple Baseline Ability
```csv
ability_id,ability_name,description_short,ability_type,unlock_level,subclass_filter,bg3_action_cost,bg3_resource_cost,bg3_file_type,implementation_status
WAR_Charge,Charge,"Sprint to enemy, gain 20 Rage",Mobility,1,All,Bonus Action,Rage:20,Spell_Jump,Complete
```

### Example 2: Complex Spec Talent
```csv
ability_id,ability_name,description_short,ability_type,unlock_level,subclass_filter,requires_ability,unlocks_ability,modified_by,bg3_file_type,damage_formula_bg3,status_applied,implementation_status
WAR_Execute,Execute,"Finish low-HP enemies for massive damage",Offensive,3,All,,WAR_ImprovedExecute,"WAR_ImprovedExecute,WAR_CriticalThinking",Spell_Target,4d12+StrengthModifier,WAR_EXECUTE_BUFF,Complete
```

### Example 3: Hero Talent Passive
```csv
ability_id,ability_name,description_short,ability_type,unlock_level,subclass_filter,requires_ability,modified_by,bg3_file_type,implementation_status,implementation_priority
WAR_Slayer_Keystone,Slayer's Dominance,"Execute procs mark enemies for extra damage",Passive,13,Arms;Fury,WAR_Execute,,Passive.txt,Not Started,P0 - Critical
```

---

## 🚀 Implementation Roadmap

### Week 1: Database Creation (8-12 hours)
1. ✅ Design schema (1 hour) ← **WE ARE HERE**
2. Create empty CSV with Phase 1 columns (30 min)
3. Extract abilities from Excel progression (2 hours)
4. Scan existing stat files for implementation status (2 hours)
5. Add WoW descriptions from Icy-Veins extractions (3 hours)
6. Create validation script (1 hour)
7. Initial testing and corrections (2 hours)

### Week 2: Phase 2 Enrichment (6-8 hours)
1. Add Phase 2 columns (all resource/cost/dependency columns)
2. Fill in BG3 implementation details from existing files
3. Add prerequisite chains (requires/unlocks)
4. Tag build archetypes
5. Add test checklists

### Week 3: Production Polish (4-6 hours)
1. Add Phase 3 columns (VFX, tracking, references)
2. Link to design documents
3. Add Wowhead/Icy-Veins URLs
4. Create comprehensive README
5. Update SOURCE_OF_TRUTH.md with new section

### Week 4: Integration & Validation (4-6 hours)
1. Cross-reference all design docs against DB
2. Generate missing ability reports
3. Create implementation priority queue
4. Update project workflows to use DB
5. Train AI agents on new system

**Total Estimated Time**: 22-32 hours over 4 weeks

---

## 🎯 Immediate Next Steps (Choose One)

### Option 1: Full Commitment (RECOMMENDED)
**Create Phase 1 MVP database NOW**

1. I create `AbilityDatabase_Warrior.csv` with 11 core columns
2. Populate with all 189 ability names from Excel
3. Mark implementation status from existing stat files
4. Add short descriptions
5. **Deliverable**: Working MVP database in 3-4 hours

### Option 2: Prototype First
**Test with small subset**

1. Create database with just L1-L3 baseline abilities (~15 abilities)
2. Fully populate all Phase 2 columns
3. Validate approach before scaling up
4. **Deliverable**: Proof of concept in 1 hour

### Option 3: Design Only
**Complete planning before execution**

1. Finalize column schema (any additions/changes?)
2. Create detailed population instructions
3. Create validation script
4. Schedule implementation
5. **Deliverable**: Complete spec document in 30 min

---

## 💡 Your Feedback Needed

1. **Schema approval**: Any columns you want to add/remove/rename?
2. **Phase preference**: Start with Phase 1 (11 cols), Phase 2 (22 cols), or Phase 3 (40+ cols)?
3. **Population strategy**: Bottom-Up, Top-Down, or Hybrid?
4. **Timeline**: Do this now, or park it for later?
5. **Scope**: Just Warrior class, or design for future classes too?

---

## ✅ Why This Is Worth It

### Short-Term Benefits
- ✅ Eliminate duplicate documentation work
- ✅ Spot missing implementations instantly
- ✅ Easy cross-reference system
- ✅ Clear implementation priorities

### Long-Term Benefits
- ✅ Consistent ability design across all classes
- ✅ Rapid implementation of new specs
- ✅ Easy balance adjustments (change once, update everywhere)
- ✅ Professional-grade documentation
- ✅ Foundation for future mod expansions

### ROI Calculation
**Time Investment**: 22-32 hours  
**Time Saved**: 100+ hours over project lifetime  
**Quality Improvement**: Massive (single source of truth)  
**Verdict**: 🎯 **ABSOLUTELY WORTH IT**

---

**Status**: ✅ PLANNING COMPLETE - Awaiting user decision  
**Next Action**: User chooses Option 1, 2, or 3 above  
**Estimated Start Time**: Immediately upon approval  
**Estimated Completion Time**: 3-4 hours for Phase 1 MVP
