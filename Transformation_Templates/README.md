# Transformation Templates - File-by-File Documentation

## Purpose

This folder contains **detailed transformation templates** documenting how to convert working WoWWarlock mod files into Warrior (and future class) implementations. Each template captures:

- **Side-by-side comparisons** (Warlock vs Warrior values)
- **Decision rationale** (why specific choices were made)
- **Attribute mapping** (what changed, what stayed the same)
- **Critical discoveries** (SpellList UUID mystery, etc.)
- **Validation checklists** (pre-deployment verification)
- **Troubleshooting guides** (common issues & fixes)
- **Future implementation notes** (for additional classes/subclasses)

These templates serve as **sources of truth** for future modding work, eliminating guesswork and preserving institutional knowledge.

## Template Index

### ✅ Completed Templates

| File # | Template | Source File | Status | Notes |
|--------|----------|-------------|--------|-------|
| **1** | [FILE_01_meta.lsx_TEMPLATE.md](FILE_01_meta.lsx_TEMPLATE.md) | `Data/Mods/.../meta.lsx` | ✅ COMPLETE | Mod metadata, dependencies, version management |
| **2** | [FILE_02_ClassDescriptions.lsx_TEMPLATE.md](FILE_02_ClassDescriptions.lsx_TEMPLATE.md) | `Public/.../ClassDescriptions/ClassDescriptions.lsx` | ✅ COMPLETE | Class attributes, HP, abilities, subclass relationships |

### 📋 Pending Templates (FILES 3-15)

| File # | Target File | Priority | Complexity | Description |
|--------|-------------|----------|------------|-------------|
| **3** | ActionResourceDefinitions.lsx | HIGH | Medium | Rage resource definition (100 max, regeneration) |
| **4** | Spell_Target.txt | HIGH | High | Single-target abilities (Execute, Shield Slam, etc.) |
| **5** | Spell_Shout.txt | HIGH | Medium | Self-buff abilities (Battle Shout, Commanding Shout) |
| **6** | Spell_Jump.txt | HIGH | Medium | Gap closers (Charge, Heroic Leap) |
| **7** | Spell_Zone.txt | HIGH | High | AoE ground-targeted (Whirlwind, Shockwave) |
| **8** | Spell_Projectile.txt | MEDIUM | Low | Ranged attacks (Heroic Throw) |
| **9** | Status_BOOST.txt | HIGH | Very High | Buffs/debuffs (Enrage, Shield Block, etc.) |
| **10** | Passive.txt | HIGH | Very High | Passive abilities & hero talent keystones |
| **11** | Progressions.lsx | CRITICAL | Very High | Level progression tables (L1-20, 3 subclasses) |
| **12** | Localization/English.loca.xml | MEDIUM | Medium | User-facing text (ability names, descriptions) |
| **13** | Lists.lsx | LOW | Low | Spell lists (may be optional) |
| **14** | SpellLists.lsx | LOW | Low | Spell list definitions (may be optional) |
| **15** | ScriptExtender configs | LOW | Low | Debugging tools (optional) |

## How to Use These Templates

### For Continuing Warrior Mod Development:
1. **Reference completed templates** (FILES 1-2) to understand what's been done
2. **Follow transformation methodology** for FILES 3-15
3. **Document new discoveries** as they arise
4. **Update templates** if better patterns emerge

### For Creating New Custom Classes:
1. **Start with FILE 1** (meta.lsx) to establish mod identity
2. **Use transformation mappings** to convert Warlock → YourClass
3. **Adapt attribute values** (HP, abilities, equipment) to your class fantasy
4. **Follow validation checklists** to catch errors early
5. **Reference troubleshooting sections** when issues arise

### For Understanding Existing Warrior Mod:
1. **Read template rationale sections** to understand "why" decisions were made
2. **Check "Critical Discoveries"** for important findings (like SpellList UUID mystery)
3. **Review validation checklists** to audit existing implementations
4. **Use troubleshooting guides** to diagnose problems

## Key Patterns Established

### 1. UUID Management
- **Base class**: Use mod's primary UUID (`78fe4967...`)
- **Subclasses**: Generate new UUIDs, set ParentGuid = base UUID
- **Hero talents**: Generate new UUIDs, set ParentGuid = subclass UUID
- **SpellList dummy**: KEEP `32879c22-4858-48ef-8f8d-22e6d395b396` across all ClassDescriptions

### 2. Naming Conventions
- **Folder naming**: `ClassIdentifier_ModPrefix_UUID` (e.g., `Warrior_Wow_78fe4967...`)
- **Class names**: `WoWClassName` (e.g., `WoWWarrior`)
- **Subclass names**: `SubclassNameClassName` (e.g., `ArmsWarrior`)
- **Ability prefixes**: `WAR_AbilityName` (e.g., `WAR_Charge`)

### 3. Attribute Retention Strategy
From Warlock template, we preserve:
- `CanLearnSpells` = `false` (non-spellcaster classes)
- Hotbar columns (5, 9, 2) - proven layout
- `CharacterCreationPose` - generic pose works universally
- `LearningStrategy` = `1` - BG3 standard
- `MustPrepareSpells` = `false` - abilities always available
- `Tags` - CLASS tag (`5804f55a...`)
- **SpellList UUID** - dummy UUID (`32879c22...`)

### 4. Warrior-Specific Values
- **BaseHp**: `10` (d10 hit die)
- **HpPerLevel**: `10` (d10 per level)
- **PrimaryAbility**: `1` (Strength)
- **SpellCastingAbility**: `1` (Strength scaling for damage)
- **ClassEquipment**: `EQP_CC_Barbarian` (heavy armor)
- **SoundClassType**: `Barbarian` (aggressive grunts)

### 5. Version Management
- **Initial release**: `36028797018963968` (v1.0.0.0)
- **Increment pattern**: MAJOR.MINOR.REVISION.BUILD
- **Both fields match**: `Version64` = `PublishVersion`

## Critical Discoveries & Lessons

### Discovery 1: SpellList UUID Mystery (RESOLVED)
**Finding**: UUID `32879c22-4858-48ef-8f8d-22e6d395b396` is referenced in ClassDescriptions but never defined anywhere in mod files.

**Investigation**:
- Searched entire WoWWarlock mod ✅
- Checked SpellLists.lsx ✅
- Checked Progressions.lsx ✅
- Found same UUID in WoWWarlock Hero Talents mod (7 nodes) ✅

**Conclusion**: Dummy/ghost reference ignored by BG3 engine. Spells granted via Progressions.lsx using different UUIDs.

**Decision**: KEEP this UUID unchanged in all ClassDescription nodes (proven working pattern).

### Discovery 2: Folder Naming Critical for Load Order
**Finding**: Folder names MUST exactly match UUID and Folder attribute in meta.lsx.

**Impact**: Mod won't appear in Mod Manager if mismatch exists.

**Validation**: Triple-check UUID in 3 locations:
1. `meta.lsx` → `<attribute id="UUID" ...>`
2. `Data/Mods/FolderName/`
3. `Data/Public/FolderName/`

### Discovery 3: Dependencies Must Be Preserved
**Finding**: All 13 Warlock dependencies kept intact (not just Gustav base).

**Rationale**:
- Gustav/GustavDev required for base game compatibility
- Shared/SharedDev enable asset reuse
- DLC dependencies ensure mod works across all game versions

**Decision**: Keep all 13 dependencies in Warrior mod (proven compatibility).

### Discovery 4: Attribute Retention Matters
**Finding**: Initial plan to remove `CanLearnSpells`, hotbar columns, etc. was incorrect.

**User correction**: "keep CanLearnSpells false, keep hotbar columns, keep ShortName"

**Lesson**: Trust template patterns unless specific reason to deviate. Warlock's attribute choices are battle-tested.

### Discovery 5: Hero Talent Architecture
**Finding**: Project has 10 total ClassDescription nodes (not 4 like Warlock).

**Structure**:
- 1 base class (Warrior)
- 3 subclasses (Arms, Fury, Protection)
- 6 hero talents (Colossus, Slayer, Mountain Thane × 2 paths each)

**Implication**: All 10 nodes will use same SpellList dummy UUID (validated by Hero Talents mod precedent).

## Documentation Standards

### When Creating New Templates:
1. **Side-by-side comparison table** (Warlock vs New Class)
2. **Rationale for each change** (why this value?)
3. **Final target state** (complete XML/code snippet)
4. **Validation checklist** (pre-deployment checks)
5. **Troubleshooting section** (common issues & fixes)
6. **Future implementation notes** (for next developer)

### Markdown Formatting:
- Use `## Purpose` section at top
- Use tables for attribute mappings
- Use code blocks for XML/code examples
- Use **bold** for critical warnings
- Use ✅/❌ for decision outcomes
- Include line numbers for file references

### Version Control:
- Date templates when created
- Note source mod version
- Mark as "PROVEN WORKING" if from successful mod
- Update if patterns evolve

## File Transformation Methodology

### Phase 1: Analysis (Current FILE, never next)
1. Read source file (Warlock template)
2. Read target file (Warrior backup, if exists)
3. Identify ALL attributes/elements
4. Create side-by-side comparison
5. Note differences and patterns

### Phase 2: Review (Wait for USER approval)
1. Present comparison to user
2. Discuss critical decisions
3. Resolve any ambiguities
4. Get explicit approval before changes

### Phase 3: Transformation (Only AFTER approval)
1. Apply replacements systematically
2. Use replace_string_in_file tool
3. Validate each change
4. Check for XML/syntax errors

### Phase 4: Documentation (Immediately after)
1. Create template in this folder
2. Document all changes made
3. Capture decision rationale
4. Include validation steps

### Phase 5: Verification (Before moving to next FILE)
1. Run get_errors tool
2. Check file opens correctly
3. Verify critical UUIDs/references
4. Test in-game if possible

## Progress Tracking

### Session: January 2025 - File-by-File Transformation

**Completed**:
- ✅ FILE 1 (meta.lsx): Fully transformed & validated
- ✅ FILE 2 (ClassDescriptions.lsx): Nodes 1-2 transformed, 3-4 commented

**Current Status**: Ready for FILE 3 (ActionResourceDefinitions.lsx)

**Next Steps**:
1. Analyze FILE 3 (Rage resource definition)
2. Compare Warlock Soul Shards vs Warrior Rage
3. Transform resource mechanics
4. Document in FILE_03 template

## Related Documentation

### Project Documentation:
- `HANDOVER_FILE_BY_FILE_START.md` - Session handover context
- `Reports/FILE_BY_FILE_TRANSFORMATION_PLAN.md` - Detailed 15-file plan
- `Documentation/07_DesignDocuments/` - Class blueprints & design specs
- `Documentation/06_ProjectDocuments/` - Implementation guides

### BG3 Modding References:
- `Documentation/01_Reference-Guides/FILE_REFERENCE.md` - BG3 file formats
- `Documentation/01_Reference-Guides/PROJECT_INDEX.md` - Full file inventory
- `Documentation/01_Reference-Guides/PACKAGING_GUIDE.md` - Mod packaging workflow

### Validation Reports:
- `Documentation/10_ValidationReports/ACTUAL_MISSING_ABILITIES.md` - Current implementation status
- `Tests/VALIDATION_STATUS_FINAL.md` - Last successful build validation

## Contribution Guidelines

### If You Update a Template:
1. Add dated changelog entry at bottom
2. Increment "Template Version" number
3. Note what changed and why
4. Update index table if new template added

### If You Find an Error:
1. Document error with evidence (line numbers, file paths)
2. Create correction in template
3. Update validation checklist to catch similar errors
4. Consider if error pattern affects other files

### If You Discover New Pattern:
1. Add to "Key Patterns Established" section
2. Update relevant templates to reflect pattern
3. Document in troubleshooting if it solves an issue
4. Share finding in project documentation

---

**Created**: January 2025  
**Purpose**: Capture transformation knowledge for Warrior mod and future class implementations  
**Source**: WoWWarlock mod (bdb3fa73-401b-4979-f02e-485422dd8d9c, 13K+ downloads)  
**Status**: Active documentation (FILES 1-2 complete, 3-15 pending)
