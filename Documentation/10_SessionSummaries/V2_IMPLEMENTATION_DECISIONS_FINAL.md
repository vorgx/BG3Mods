# v2.0 Talent Tree Implementation - Final Decisions
**Date**: October 17, 2025  
**Status**: Decisions Approved - Ready for Phase 1  
**Estimated Effort**: 250 hours (revised from 300)

---

## Executive Summary

User has approved all 5 critical decisions for v2.0 WoW-style talent tree implementation. This document serves as the authoritative reference for implementation constraints and design choices.

---

## DECISION 1: SubclassBase Talents Pool Size & Content

### User Decision: **12 Abilities (Baseline Arms Warrior Abilities)**

**Pool Name**: `Baseline_Arms_Warrior_Abilities`  
**Category**: SubclassBase Talents (Bucket/Group System)  
**Source**: WoW Fury Warrior Baseline Abilities (adapted for BG3)

### Offensive Abilities (7 total)
1. ✅ **Whirlwind** - Primary multitarget attack
   - **Status**: EXISTS (`Zone_WAR_Whirlwind` in Spell_Zone.txt)
   - **Location**: Line 142, Spell_Zone.txt
   - **Mechanics**: 1d8+STR AoE damage, grants 2-turn cleave buff
   
2. ✅ **Slam** - Initial rage spender, quickly replaced by other abilities
   - **Status**: EXISTS (`Target_WAR_Slam` in Spell_Target.txt)
   - **Location**: Line 775, Spell_Target.txt
   - **Mechanics**: Basic rage spender alternative to Heroic Strike
   
3. ✅ **Shield Slam** - Early offensive ability, replaced upon specializing
   - **Status**: EXISTS (`Target_WAR_ShieldSlam` in Spell_Target.txt)
   - **Location**: Line 69, Spell_Target.txt
   - **Mechanics**: 3d8+STR damage, bonus damage with Shield Block active, generates Rage
   
4. ✅ **Hamstring** - Minor snare
   - **Status**: EXISTS (`Target_WAR_Hamstring` in Spell_Target.txt)
   - **Location**: Line 659, Spell_Target.txt
   - **Mechanics**: 1d6+STR damage, applies 3-turn snare (Bonus Action)
   
5. ✅ **Victory Rush** - Very useful free heal after getting a kill
   - **Status**: EXISTS (`Target_WAR_VictoryRush` in Spell_Target.txt + passive enabler)
   - **Location**: Line 695, Spell_Target.txt + Passive.txt line 397
   - **Mechanics**: Heal after kill, requires Victorious buff (Bonus Action)
   
6. ✅ **Execute** - Arms' version of Execute (below 20% HP)
   - **Status**: EXISTS (`Target_WAR_Execute` in Spell_Target.txt)
   - **Location**: Line 29, Spell_Target.txt
   - **Mechanics**: 4d12+STR damage to targets below 20% HP, 20 Rage cost
   
7. ✅ **Heroic Throw** - Pitifully low damage ranged attack, only appropriate for pulling from a distance
   - **Status**: EXISTS (`Projectile_WAR_HeroicThrow` in Spell_Projectile.txt)
   - **Location**: Line 9, Spell_Projectile.txt
   - **Mechanics**: Weapon throw, low damage ranged option

### Utility Abilities (5 total)
8. ✅ **Charge** - Primary mobility and gap closer
   - **Status**: EXISTS (`Target_WAR_Charge` in Spell_Target.txt + Jump spell)
   - **Location**: Line 271, Spell_Target.txt + Spell_Jump.txt
   - **Mechanics**: Gap closer with 1d4+STR damage, applies Off Balance, generates Rage
   
9. ✅ **Pummel** - Low cooldown interrupt
   - **Status**: EXISTS (`Target_WAR_Pummel` in Spell_Target.txt)
   - **Location**: Line 739, Spell_Target.txt
   - **Mechanics**: 1d4+STR damage, 1-turn interrupt (Bonus Action, melee range)
   
10. ✅ **Battle Shout** - Worth ~5% damage for melee classes and Hunters
    - **Status**: EXISTS (`Shout_WAR_BattleShout` in Spell_Shout.txt)
    - **Location**: Line 13, Spell_Shout.txt
    - **Mechanics**: Party-wide attack buff
    
11. ✅ **Berserker Rage** - Preemptive or reactive CC removal
    - **Status**: EXISTS (`Target_WAR_BerserkerRage` in Spell_Target.txt + status)
    - **Location**: Line 814, Spell_Target.txt + Status_BOOST.txt line 635
    - **Mechanics**: CC immunity and removal (Bonus Action)
    
12. ✅ **Taunt** - Draws aggro and generally gets you killed
    - **Status**: EXISTS (`Target_WAR_Taunt` in Spell_Target.txt)
    - **Location**: Line 962, Spell_Target.txt + WAR_TAUNTED status
    - **Mechanics**: Applies Taunted status for 2 turns, forces target aggro

### Implementation Status
✅ **ALL 12 ABILITIES ALREADY EXIST** - No new spell creation needed for Decision 1!

### Passive Wrapper Architecture
**Required Work**: Create 12 passive wrappers for progression system

**Naming Convention**:
```
WAR_BaselineArms_Whirlwind      → unlocks Zone_WAR_Whirlwind
WAR_BaselineArms_Slam           → unlocks Target_WAR_Slam
WAR_BaselineArms_ShieldSlam     → unlocks Target_WAR_ShieldSlam
WAR_BaselineArms_Hamstring      → unlocks Target_WAR_Hamstring
WAR_BaselineArms_VictoryRush    → unlocks Target_WAR_VictoryRush + passive
WAR_BaselineArms_Execute        → unlocks Target_WAR_Execute
WAR_BaselineArms_HeroicThrow    → unlocks Projectile_WAR_HeroicThrow
WAR_BaselineArms_Charge         → unlocks Target_WAR_Charge + jump spell
WAR_BaselineArms_Pummel         → unlocks Target_WAR_Pummel
WAR_BaselineArms_BattleShout    → unlocks Shout_WAR_BattleShout
WAR_BaselineArms_BerserkerRage  → unlocks Target_WAR_BerserkerRage
WAR_BaselineArms_Taunt          → unlocks Target_WAR_Taunt
```

### Progression Integration
**Level 1**: Pick 1 Offensive + 1 Utility (2 choices at character creation)  
**Levels 2-19**: Pick 1 from ALL remaining baseline abilities until exhausted (~11 levels)

**Depletion Pattern**:
- L1: 12 abilities available (pick 2)
- L2: 10 abilities remaining (pick 1)
- L3: 9 abilities remaining (pick 1)
- ...
- L11: 1 ability remaining (auto-grant)
- L12+: Pool exhausted, no more baseline choices

### Cross-Spec Considerations
**Question**: Should Fury/Protection have separate baseline pools or share?
- **Current Decision**: Separate pools per spec (Decision 1 addresses Arms only)
- **Implication**: Fury and Protection will need their own 12-ability baseline pools
- **Future Work**: Define Fury and Protection baseline pools (not in scope for this decision)

---

## DECISION 2: Hero Talent Passives Count

### User Decision: **Option B - Keep Current 5-Passive System**

**Rationale**: Current implementation is already balanced and tested.

### Current Implementation (Colossus Specialization)
- **L13**: Keystone passive (unlocks specialization mechanics)
- **L15**: Choice Node 1 (pick 1 of 3 passives)
- **L17**: Choice Node 2 (pick 1 of 3 passives)
- **L19**: Choice Node 3 (pick 1 of 3 passives)
- **L20**: Automatic capstone

**Total Passives**: 5 (1 keystone + 3 choices + 1 capstone)

### Design Document Original (8 Passives)
Design called for 1 passive each level L13→L20 (8 total), but user prefers simpler current system.

### Implementation Impact
✅ **NO CHANGES NEEDED** - Keep existing hero talent structure for both Colossus and Slayer specs.

**Files Affected**: None (status quo maintained)

---

## DECISION 3: Feats - Keep or Remove

### User Decision: **Option A - Keep Feats**

**Rationale**: Familiar to BG3 players, core D&D 5e mechanic, adds more customization.

### Current Feat System
- **L4**: 1 feat choice
- **L8**: 1 feat choice
- **L12**: 1 feat choice
- **L16**: 1 feat choice
- **L20**: 1 feat choice

**Total**: 5 feat choices across 20 levels

### Hybrid D&D + WoW Design
By keeping feats, we create a hybrid system:
- **WoW Elements**: Talent trees (Class, SubclassSpec, SubclassBase, Specialization)
- **D&D Elements**: Feats at milestone levels (4/8/12/16/20)

### Implementation Impact
✅ **NO CHANGES NEEDED** - Keep existing feat progression nodes.

**Files Affected**: None (Progressions.lsx already has feat nodes at L4/8/12/16/20)

---

## DECISION 4: Icons - Source

### User Decision: **Option C - Use WoW Ability Icons**

**Source**: `Documentation/08_WoWSourceMaterial/[Spec]_files/` folders contain WoW icon GIFs

**Rationale**: Perfect thematic match, authentic WoW feel, icons already available.

### Icon Inventory (Arms Warrior Baseline Abilities)

**Found in**: `Documentation/08_WoWSourceMaterial/Arms Warrior Abilities and Talents Guide - The War Within 11.2 - Wowhead_files/`

#### Offensive Abilities Icons
1. ✅ **Whirlwind**: `ability_whirlwind.gif`
2. ✅ **Slam**: `ability_warrior_decisivestrike.gif` (or similar slam icon)
3. ✅ **Shield Slam**: `inv_shield_05.gif` (shield-based attack)
4. ✅ **Hamstring**: `ability_gouge.gif` (snare/cripple theme)
5. ✅ **Victory Rush**: `ability_warrior_victoryrush.gif` ⭐
6. ✅ **Execute**: `inv_sword_48.gif` (execute/finishing move)
7. ✅ **Heroic Throw**: `inv_throwingaxe_06.gif`

#### Utility Abilities Icons
8. ✅ **Charge**: `ability_warrior_charge.gif` ⭐
9. ✅ **Pummel**: `inv_gauntlets_04.gif` (interrupt/stun)
10. ✅ **Battle Shout**: `ability_warrior_battleshout.gif` ⭐
11. ✅ **Berserker Rage**: `racial_orc_berserkerstrength.gif` (or `spell_nature_shamanrage.gif`)
12. ✅ **Taunt**: `spell_nature_reincarnation.gif` (or `ability_fomor_boss_shout.gif`)

**Additional Notable Icons Available**:
- Class Talents: `warrior_talent_icon_*.gif` (Avatar, Stormbolt, Ravager, etc.)
- Spec Abilities: `ability_warrior_colossussmash.gif`, `inv_warbreaker.gif`, etc.
- Hero Talents: `inv_ability_colossuswarrior_demolish.gif`, `inv_ability_slayerwarrior_slayersdominance.gif`

### Copyright & Legal Considerations
**User Awareness**: User selected WoW icons knowing potential copyright implications.

**Recommendation**: 
- Use for personal/community mod distribution
- Include disclaimer in mod description: "Icons sourced from World of Warcraft, property of Blizzard Entertainment"
- If Blizzard requests removal, fall back to BG3 vanilla icons (Option A)

### Implementation Work Required
1. **Convert GIF → PNG**: BG3 uses PNG format for icons
2. **Resize**: BG3 icons are typically 64x64 or 128x128 pixels
3. **Rename**: Follow BG3 naming convention: `Action_[AbilityName].png`
4. **Add to Mod**: Place in `Public/BG3Wow_.../GUI/` folder (create if missing)
5. **Reference in Stats**: Update `data "Icon"` fields in spell files

**Estimated Effort**: 
- ~30 minutes per icon (convert, resize, test)
- ~12 icons for baseline abilities = 6 hours
- Additional icons for talent trees: ~40 icons = 20 hours
- **Total Icon Work**: ~26 hours

---

## DECISION 5: Testing Depth

### User Decision: **Test Top 10 Synergistic Builds**

**Approach**: Focus on archetype builds that demonstrate different playstyles and talent synergies.

### 10 Archetype Builds to Test

#### Arms Specialization (4 builds)
1. **Colossus Tank** - Maximize survivability with Colossus hero talents + defensive class talents
2. **Colossus DPS** - Offensive Colossus build with Execute synergies
3. **Slayer Bleed** - DoT-focused build using Slayer's bleed mechanics
4. **Slayer Burst** - High burst damage with Slayer's critical strike bonuses

#### Fury Specialization (3 builds)
5. **Fury Berserker** - Pure DPS with rage generation and spending synergies
6. **Fury Dual-Wield** - Focus on attack speed and dual-wielding bonuses
7. **Fury AoE** - Maximize Whirlwind and cleave mechanics

#### Protection Specialization (3 builds)
8. **Protection Tank** - Maximum survivability and threat generation
9. **Protection DPS** - Offensive Protection build with Shield Slam synergies
10. **Protection Support** - Ally protection and buff-focused build

### Testing Protocol Per Build
1. **Character Creation**: Verify class/subclass selection works
2. **Level 1-5 Progression**: Test early talent choices and ability unlocks
3. **Level 6-12 Midgame**: Test talent synergies and build identity
4. **Level 13-20 Endgame**: Test hero talents and capstone interactions
5. **Combat Testing**: 
   - Solo combat (vs single target, vs group)
   - Party combat (buff interactions, ally synergies)
   - Boss combat (sustained damage, survivability)
6. **Edge Case Testing**:
   - Rage economy (generation vs spending balance)
   - Cooldown management
   - Status effect interactions
   - Passive triggers

### Testing Documentation
For each build, create:
- **Build Guide**: Talent selections L1-20
- **Synergy Report**: Which talents interact well
- **Balance Notes**: Over/underpowered abilities
- **Bug Log**: Issues encountered during testing

**Estimated Testing Effort**: 
- ~8 hours per build × 10 builds = 80 hours
- Bug fixing: ~20 hours
- **Total Testing**: ~100 hours

---

## Talent Pool Request: Future Decisions Needed

### User Offered Assistance
> "let me know if you need help with other talent pools like we did for SubclassBase Talents Pool in decision 1"

### Outstanding Talent Pools Requiring Definition

#### 1. Class Talents (10 Rows)
**Status**: ⏸️ NEEDED  
**Content**: Warrior class talents shared by all 3 specs (Arms, Fury, Protection)  
**Source**: WoW Class Talents tab  
**Estimated Abilities**: ~24 (pick 1 from each of 10 rows = 9 choices, need 2-3 options per row)

**Request**: User to provide list of Warrior Class Talents from WoW source material

#### 2. SubclassSpec Talents - Arms (10 Rows)
**Status**: ⏸️ NEEDED  
**Content**: Arms-specific spec talents (not baseline abilities)  
**Source**: WoW Arms Spec Talents tab  
**Estimated Abilities**: ~24 (pick 1 from each of 10 rows = 9 choices, need 2-3 options per row)

**Request**: User to provide list of Arms Spec Talents from WoW source material

#### 3. SubclassBase Talents - Fury
**Status**: ⏸️ NEEDED  
**Content**: Baseline Fury Warrior abilities (equivalent to Arms baseline)  
**Source**: WoW Fury baseline abilities  
**Estimated Abilities**: ~12 (similar to Arms baseline pool)

**Request**: User to provide Fury baseline ability list

#### 4. SubclassSpec Talents - Fury (10 Rows)
**Status**: ⏸️ NEEDED  
**Content**: Fury-specific spec talents  
**Source**: WoW Fury Spec Talents tab  
**Estimated Abilities**: ~24

#### 5. SubclassBase Talents - Protection
**Status**: ⏸️ NEEDED  
**Content**: Baseline Protection Warrior spells  
**Source**: WoW Protection baseline abilities  
**Estimated Abilities**: ~12

#### 6. SubclassSpec Talents - Protection (10 Rows)
**Status**: ⏸️ NEEDED  
**Content**: Protection-specific spec talents  
**Source**: WoW Protection Spec Talents tab  
**Estimated Abilities**: ~24

#### 7. Specialization - Fury Hero Talents
**Status**: ⏸️ NEEDED (but lower priority)  
**Content**: Fury's hero talent trees (2 options, e.g., Mountain Thane, other?)  
**Source**: WoW Fury hero talents  
**Decision 2 Impact**: Keep 5-passive system (keystone + 3 choices + capstone)

#### 8. Specialization - Protection Hero Talents
**Status**: ⏸️ NEEDED (but lower priority)  
**Content**: Protection's hero talent trees  
**Source**: WoW Protection hero talents  
**Decision 2 Impact**: Keep 5-passive system

---

## Effort Estimate Revisions

### Original Estimate (300 hours)
Based on assumption of:
- Building tag system infrastructure (40 hours)
- Creating ~60 new abilities
- 8 passives per hero spec

### Revised Estimate (250 hours)
**Reductions**:
- ✅ Decision 1: All baseline abilities exist (-10 hours, no spell creation)
- ✅ Decision 2: Keep 5 passives (-10 hours, no new hero passives)
- ✅ Decision 3: Keep feats (-5 hours, no Progressions.lsx restructure)
- ✅ Tag system deferred (-25 hours, use passive wrapper workaround)

**Additions**:
- ⚠️ Decision 4: Icon conversion work (+26 hours)

**Net Change**: -24 hours

### Phase Breakdown (Revised)
- **Phase 1: Research & Design** - 30 hours (down from 40)
  - BG3 constraint research: 5 hours
  - Ability categorization: 10 hours
  - Progression mapping: 10 hours
  - Balance framework: 5 hours
  
- **Phase 2: Architecture** - 50 hours (down from 60)
  - Progressions.lsx redesign: 20 hours
  - Passive wrapper templates: 15 hours
  - Localization planning: 10 hours
  - Testing framework: 5 hours
  
- **Phase 3: Implementation** - 60 hours (down from 80)
  - Create ~40 new abilities: 30 hours
  - Create ~80 passive wrappers: 15 hours
  - Icon conversion: 15 hours
  
- **Phase 4: Testing & Balance** - 50 hours (down from 60)
  - 10 archetype builds: 40 hours
  - Bug fixing: 10 hours
  
- **Phase 5: Documentation** - 30 hours (down from 40)
  - Design docs: 10 hours
  - Player guides: 10 hours
  - Developer docs: 10 hours
  
- **Phase 6: Release** - 10 hours (down from 20)
  - Packaging: 3 hours
  - Validation: 5 hours
  - Release prep: 2 hours

**TOTAL: 230 hours** (rounded to 250 for buffer)

---

## Implementation Blockers & Next Steps

### ✅ CLEARED FOR PHASE 1
All 5 critical decisions have been made. Agent can now proceed to Phase 1: Research & Design.

### Immediate Next Steps (Phase 1 - Week 1)

#### Task 1.1: BG3 Constraint Research (5 hours)
- [ ] Test passive wrapper approach in isolated test mod
- [ ] Verify SelectPassives amount limits (can we pick 2 at L1?)
- [ ] Test Requirement chaining with 12 abilities
- [ ] Document UI/UX behavior with large choice lists
- [ ] Create BG3_TALENT_SYSTEM_CONSTRAINTS.md

#### Task 1.2: Ability Categorization (10 hours)
- [ ] **BLOCKED**: Request remaining talent pool definitions from user
  - Class Talents (10 rows, ~24 abilities)
  - SubclassSpec Talents - Arms (10 rows, ~24 abilities)
  - SubclassBase/SubclassSpec for Fury and Protection (future)
- [ ] Map existing abilities to talent tree positions
- [ ] Identify gaps (which abilities need creation)
- [ ] Create CLASS_TALENTS_DESIGN.md
- [ ] Create SUBCLASSSPEC_ARMS_DESIGN.md

#### Task 1.3: Progression Mapping (10 hours)
- [ ] Create detailed L1-20 chart for Arms Warrior
- [ ] Map all 4 talent systems to level progression
- [ ] Calculate total choices per level
- [ ] Design UI/UX flow for character creation
- [ ] Create LEVEL_BY_LEVEL_PROGRESSION_CHART.md

#### Task 1.4: Balance Framework (5 hours)
- [ ] Define power budget per ability tier
- [ ] Document intended synergies
- [ ] Establish Rage economy targets
- [ ] Set DPS/defense benchmarks vs Fighter
- [ ] Create BALANCE_FRAMEWORK.md

### Phase 1 Deliverables (Due: Week 1 End)
1. ✅ BG3_TALENT_SYSTEM_CONSTRAINTS.md
2. ⏸️ CLASS_TALENTS_DESIGN.md (blocked on user input)
3. ⏸️ SUBCLASSSPEC_ARMS_DESIGN.md (blocked on user input)
4. ✅ SUBCLASSBASE_ARMS_DESIGN.md (complete from Decision 1)
5. ✅ SPECIALIZATION_DESIGN.md (complete from Decision 2)
6. ✅ LEVEL_BY_LEVEL_PROGRESSION_CHART.md
7. ✅ BALANCE_FRAMEWORK.md

**Current Status**: 3 of 7 deliverables complete, 2 blocked on user input

---

## Decision Summary Table

| Decision | Option | Impact | Work Saved/Added | Status |
|----------|--------|--------|------------------|--------|
| **1. SubclassBase Pool** | 12 abilities | All exist, need wrappers | -10 hours (no spell creation) | ✅ Ready |
| **2. Hero Passives** | Option B (5) | Keep current system | -10 hours (no new passives) | ✅ Ready |
| **3. Feats** | Option A (Keep) | Hybrid D&D+WoW design | -5 hours (no restructure) | ✅ Ready |
| **4. Icons** | Option C (WoW) | Icon conversion needed | +26 hours (conversion work) | ⏸️ Phase 3 |
| **5. Testing** | 10 builds | Focused archetype testing | Baseline (100 hours) | ⏸️ Phase 4 |

**Total Effort Adjustment**: -24 hours + 26 hours = **+2 hours net** (250 hours total)

---

## Appendix A: File Inventory - Existing Abilities

### Spell Files
- ✅ `Spell_Target.txt` - 9 target spells (Execute, Shield Slam, Charge, Hamstring, Victory Rush, Pummel, Slam, Berserker Rage, Taunt)
- ✅ `Spell_Zone.txt` - AoE spells (Whirlwind)
- ✅ `Spell_Projectile.txt` - Ranged spells (Heroic Throw)
- ✅ `Spell_Shout.txt` - Shout abilities (Battle Shout)
- ✅ `Spell_Jump.txt` - Gap closers (Charge jump component)

### Status Files
- ✅ `Status_BOOST.txt` - 11 statuses (Whirlwind buff, Shield Slam rage gen, Victory Rush, Berserker Rage, Taunt, etc.)

### Passive Files
- ✅ `Passive.txt` - Victory Rush enabler passive

### Localization
- ✅ `English.loca.xml` - 178 handles (h125abc001-178)
- ⚠️ **Need ~80 new handles** for passive wrappers

---

## Appendix B: WoW Icon Resources

### Icon Folders Available
1. `Arms Warrior Abilities and Talents Guide - The War Within 11.2 - Wowhead_files/`
2. `Fury Warrior Abilities and Talents Guide - The War Within 11.2 - Wowhead_files/`
3. `Protection Warrior Abilities and Talents Guide - The War Within 11.2 - Wowhead_files/`

**Total Icons Available**: ~200+ GIF files covering:
- Baseline abilities
- Class talents
- Spec talents
- Hero talents
- Racial abilities
- Generic warrior icons

**Icon Types**:
- `ability_*.gif` - Active abilities
- `warrior_talent_icon_*.gif` - Talent tree icons
- `inv_*.gif` - Items/weapons (often used for passive abilities)
- `spell_*.gif` - Spell effects
- `racial_*.gif` - Racial abilities (some repurposed for warrior abilities)

---

## Conclusion

All 5 critical decisions have been made. User has provided clear direction:

1. ✅ **SubclassBase**: 12 baseline Arms abilities (all already implemented)
2. ✅ **Hero Passives**: Keep current 5-passive system
3. ✅ **Feats**: Keep D&D feats for hybrid design
4. ✅ **Icons**: Use WoW icons from source material folders
5. ✅ **Testing**: Focus on 10 synergistic archetype builds

**Next Actions**:
1. Agent begins Phase 1: Research & Design
2. User provides Class Talents and SubclassSpec Talents lists when available
3. Agent creates BG3 constraint testing mod to validate passive wrapper approach
4. Phase 1 deliverables due: End of Week 1 (~30 hours)

**v2.0 Release Target**: ~3 months (250 hours part-time)

---

**Session**: October 17, 2025  
**Approved By**: User (vorgx)  
**Agent**: GitHub Copilot  
**Document Status**: Final - Implementation Authority
