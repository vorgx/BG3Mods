# Warrior Ability Database - User Guide

**File**: `AbilityDatabase_Warrior.csv`  
**Created**: October 20, 2025  
**Version**: 1.0 (Phase 2 - Full Feature Set)  
**Total Abilities**: 236  
**Total Columns**: 28

---

## 📋 Overview

This is the **master ability database** for the BG3 Warrior mod. It serves as the single source of truth for all abilities across all Warrior subclasses (Arms, Fury, Protection) and hero talent trees (Mountain Thane, Colossus, Slayer).

### Purpose
- **Eliminate duplication** - Define each ability once, reference everywhere
- **Enable cross-referencing** - Track dependencies, prerequisites, unlocks
- **Simplify implementation** - Clear BG3 translation for each ability
- **Support validation** - Easy to spot missing/incomplete abilities
- **Future-proof** - Extensible for future classes/specs

---

## 📊 Database Schema (28 Columns)

### Core Identification (5 columns)
| Column | Description | Example |
|--------|-------------|---------|
| `ability_id` | Unique identifier | `WAR_Charge` |
| `ability_name` | Display name | `Charge` |
| `ability_abbreviation` | Short form | `MS` (for Mortal Strike) |
| `description_short` | One-line summary (max 100 chars) | `Sprint towards enemy, generate Rage` |
| `description_full` | Complete tooltip | `Sprint towards an enemy...` |

### Classification (3 columns)
| Column | Description | Values |
|--------|-------------|--------|
| `ability_type` | Primary category | `Offensive`, `Defensive`, `Utility`, `Passive` |
| `ability_subtype` | Secondary category | `Single-Target`, `AoE`, `Buff`, `Debuff`, `Heal`, `CC` |
| `archetype_tags` | Build relevance | `Execute,Bleed,AoE` (comma-separated) |

### Progression (3 columns)
| Column | Description | Values |
|--------|-------------|--------|
| `unlock_level` | First available level | `1`, `3`, `13` |
| `unlock_source` | How obtained | `Baseline`, `Class Talent`, `Spec Talent`, `Hero Talent` |
| `subclass_filter` | Which specs can use | `All`, `Arms`, `Fury`, `Protection`, `Arms,Fury` |

### Dependencies (4 columns)
| Column | Description | Example |
|--------|-------------|---------|
| `requires_ability` | Prerequisite ability IDs | `WAR_Charge` (comma-separated) |
| `unlocks_ability` | What this unlocks | `WAR_DoubleTime,WAR_Intervene` |
| `replaces_ability` | What this replaces | `WAR_VictoryRush` |
| `modified_by` | Passives that enhance it | `WAR_ImprovedExecute` |

### Resources & Costs (4 columns)
| Column | Description | Example |
|--------|-------------|---------|
| `wow_cost_rage` | WoW Rage cost | `20` |
| `bg3_action_cost` | BG3 action economy | `Action`, `Bonus Action`, `Reaction`, `None` |
| `bg3_resource_cost` | BG3 resource cost | `ActionPoint:1;Rage:20` |
| `bg3_cooldown` | BG3 cooldown format | `OncePerTurn`, `OncePerShortRest` |

### BG3 Implementation (9 columns)
| Column | Description | Example |
|--------|-------------|---------|
| `bg3_file_type` | Which stat file | `Spell_Target`, `Passive`, `Status_BOOST` |
| `bg3_spell_type` | Larian spell type | `Target`, `Shout`, `Zone` |
| `bg3_spell_success` | SpellSuccess functors | `DealDamage(4d12,Slashing)` |
| `bg3_target_conditions` | BG3 TargetConditions | `not Dead()` |
| `damage_formula_bg3` | Damage calculation | `4d12+StrengthModifier` |
| `status_applied` | Status effects applied | `WAR_ENRAGED` (comma-separated) |
| `bg3_vfx_prepare` | Cast start VFX | `RS3_Fx_Spell_Cast_Charge` |
| `bg3_vfx_cast` | Cast launch VFX | `RS3_Fx_Charge_Trail` |
| `bg3_vfx_impact` | Target hit VFX | `RS3_Fx_Impact_Melee` |

*Note: VFX columns added in Phase 3, currently empty*

### Tracking (3 columns)
| Column | Description | Values |
|--------|-------------|--------|
| `implementation_status` | Current state | `Not Started`, `In Progress`, `Complete`, `Needs Testing` |
| `implementation_priority` | Urgency | `P0 - Critical`, `P1 - High`, `P2 - Medium`, `P3 - Low` |
| `implementation_notes` | Dev notes | `Needs custom status effect` |

---

## 📈 Database Statistics

### By Unlock Source
- **Baseline**: 217 abilities (auto-granted at specific levels)
- **Hero Talent**: 15 abilities (L13-L20 specializations)
- **Spec Talent**: 3 abilities (subclass-specific)
- **Class Talent**: 1 ability (shared by all)

### By Subclass Filter
- **All**: 210 abilities (usable by all specs)
- **Protection,Fury**: 5 abilities (Mountain Thane hero talents)
- **Arms,Protection**: 5 abilities (Colossus hero talents)
- **Arms,Fury**: 5 abilities (Slayer hero talents)
- **Arms**: 4 abilities
- **Protection**: 4 abilities
- **Fury**: 3 abilities

### By Ability Type
- **Offensive**: Majority (primary damage dealers)
- **Passive**: 67 abilities (always-active effects)
- **Defensive**: Mitigation and survivability
- **Utility**: Mobility, CC, support

---

## 🎯 Usage Examples

### Finding All L1 Baseline Abilities
```powershell
$db = Import-Csv "AbilityDatabase_Warrior.csv"
$db | Where-Object { $_.unlock_level -eq 1 -and $_.unlock_source -eq "Baseline" } | 
      Select-Object ability_name, subclass_filter, ability_type
```

### Finding All Hero Talents
```powershell
$db | Where-Object { $_.unlock_source -eq "Hero Talent" } |
      Select-Object ability_name, unlock_level, subclass_filter, archetype_tags
```

### Finding All Unimplemented Abilities
```powershell
$db | Where-Object { $_.implementation_status -eq "Not Started" } |
      Group-Object unlock_source | 
      Select-Object Name, Count
```

### Finding All Passives
```powershell
$db | Where-Object { $_.ability_type -eq "Passive" } |
      Select-Object ability_name, description_short, subclass_filter
```

### Export Abilities Needing Implementation (By Priority)
```powershell
$db | Where-Object { $_.implementation_status -eq "Not Started" } |
      Sort-Object unlock_level |
      Export-Csv "abilities_todo.csv" -NoTypeInformation
```

---

## 🔧 Maintenance Workflow

### Adding a New Ability
1. Add new row to CSV
2. Ensure `ability_id` is unique (format: `WAR_AbilityName`)
3. Fill all required columns (at minimum: id, name, description, type, level, source, subclass)
4. Mark `implementation_status` as `Not Started`
5. Run validation script (see below)

### Updating Implementation Status
1. Open CSV in Excel/VS Code
2. Find ability by `ability_id`
3. Update `implementation_status` to `In Progress` or `Complete`
4. Add notes to `implementation_notes` if needed
5. Save and commit

### Adding Dependencies
1. Find ability that requires/unlocks others
2. Update `requires_ability` with comma-separated IDs
3. Update `unlocks_ability` with comma-separated IDs
4. Ensure bidirectional relationships are consistent
5. Run validation script

---

## ✅ Validation Rules

### Required Fields (Must Not Be Empty)
- `ability_id` - Unique, format `WAR_*`
- `ability_name` - Display name
- `ability_type` - Must be valid enum value
- `unlock_level` - Must be 1-20
- `unlock_source` - Must be valid enum value
- `subclass_filter` - Must be valid subclass or `All`
- `implementation_status` - Must be valid enum value

### Data Integrity Checks
- No duplicate `ability_id` values
- All `requires_ability` IDs must exist in database
- All `unlocks_ability` IDs must exist in database
- All `modified_by` IDs must exist in database
- `unlock_level` must be between 1 and 20
- `subclass_filter` must match valid patterns

### BG3 Implementation Checks
- If `ability_type` is `Passive`, then `bg3_file_type` should be `Passive`
- If `ability_type` is `Passive`, then `bg3_action_cost` should be `None`
- `bg3_spell_type` should match `bg3_file_type` pattern

---

## 🛠️ Validation Script

**File**: `Scripts/Validate-AbilityDatabase.ps1`

```powershell
# Run validation
.\Scripts\Validate-AbilityDatabase.ps1

# Check specific ability
.\Scripts\Validate-AbilityDatabase.ps1 -AbilityID "WAR_Charge"

# Export validation report
.\Scripts\Validate-AbilityDatabase.ps1 -ExportReport
```

---

## 📚 Related Documents

- **Source of Truth**: `Documentation/00_SourcesOfTruth/SOURCE_OF_TRUTH.md` - Master project documentation
- **Progression Table**: `Documentation/00_SourcesOfTruth/Warrior Progression for all subclasses.csv` - Level-by-level progression
- **Planning Document**: `Documentation/00_SourcesOfTruth/ABILITY_DATABASE_PLANNING.md` - Design decisions and schema rationale

---

## 🚀 Future Enhancements (Phase 3)

### Planned Columns
- `wow_url_wowhead` - Wowhead link
- `wow_url_icyveins` - Icy-Veins reference
- `design_doc_reference` - Related doc section
- `test_checklist` - Validation steps
- `known_issues` - Bug tracking
- `change_log` - Version history
- `range_meters_bg3` - BG3 range
- `aoe_radius_bg3` - AoE radius
- `duration_bg3` - Effect duration
- `can_crit` - Can critically hit
- `interruptible` - Can be interrupted
- `scaling_attribute` - Primary scaling stat

---

## 📝 Change Log

### v1.0 (October 20, 2025)
- Initial creation with Phase 2 schema (28 columns)
- Extracted 236 abilities from progression CSV
- All abilities marked as `Not Started`
- Ready for enrichment with WoW source data

---

**Last Updated**: October 20, 2025  
**Maintainer**: Project Team  
**Status**: ✅ Phase 2 Complete - Ready for enrichment
