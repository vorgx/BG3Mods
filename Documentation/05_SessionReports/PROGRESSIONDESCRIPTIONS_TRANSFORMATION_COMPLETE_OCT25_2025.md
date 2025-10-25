# ProgressionDescriptions.lsx Transformation - COMPLETE ✅

**Date**: October 25, 2025  
**Status**: ✅ **TRANSFORMATION COMPLETE**  
**Files Modified**: 2 files

---

## Summary

Transformed `ProgressionDescriptions.lsx` from Warlock template (40 nodes with Warlock talent rows) to Warrior implementation (33 nodes with Warrior talent rows).

### What This File Does

`ProgressionDescriptions.lsx` provides **display names and descriptions** for talent choice screens in character creation. When a player levels up and reaches a level with `SelectPassives()` in Progressions.lsx, BG3 shows a talent choice screen. This file defines what text appears at the top of that screen.

---

## Transformation Details

### Before (Warlock Template)
- **40 ProgressionDescription nodes**
- All SelectorIds referenced Warlock talent rows:
  - `WarlockClassTalentRow1-9`
  - `WarlockDemoTalentRow1-9`
  - `WarlockDestroTalentRow1-9`
  - `WarlockAffTalentRow1-9`
  - `WarlockDestroSpecChoise`, `WarlockAffSpecChoise`

### After (Warrior Implementation)
- **33 ProgressionDescription nodes**
- All SelectorIds now reference Warrior talent rows:
  - **Warrior Class Rows (9)**: `WarriorClassTalentRow1-9` (L2-L10)
  - **Arms Spec Rows (8)**: `ArmsSpecTalentRow1-8` (L3-L10)
  - **Fury Spec Rows (8)**: `FurySpecTalentRow1-8` (L3-L10)
  - **Protection Spec Rows (8)**: `ProtectionSpecTalentRow1-8` (L2-L10)

---

## Files Modified

### 1. ProgressionDescriptions.lsx ✅
**Path**: `Data/Public/Warrior_Wow_*/Progressions/ProgressionDescriptions.lsx`  
**Lines**: 241 (reduced from 561 - Warlock had more verbose structure)  
**Changes**:
- Replaced all 40 Warlock ProgressionDescription nodes
- Created 33 new Warrior ProgressionDescription nodes
- Updated all UUIDs to Warrior mod format (`78fe4967-####-####-####-############`)
- Updated all localization handle references

**Node Structure**:
```xml
<node id="ProgressionDescription">
    <attribute id="Description" type="TranslatedString" handle="h78fe4967g0001g0001g0001g0001" version="1"/>
    <attribute id="DisplayName" type="TranslatedString" handle="h78fe4967g0001g0001g0001g0002" version="1"/>
    <attribute id="SelectorId" type="FixedString" value="WarriorClassTalentRow1"/>
    <attribute id="UUID" type="guid" value="78fe4967-0001-0001-0001-000000000001"/>
</node>
```

### 2. english.xml ✅
**Path**: `Data/Mods/Warrior_Wow_*/Localization/English/english.xml`  
**Changes**: Added 66 new localization handles (33 rows × 2 handles each)

**Handle Pattern**:
- **Warrior Class**: `h78fe4967g0001g0001g0001g####` (handles 0001-0018)
- **Arms Spec**: `h78fe4967g0002g0002g0002g####` (handles 0019-0034)
- **Fury Spec**: `h78fe4967g0003g0003g0003g####` (handles 0035-0050)
- **Protection Spec**: `h78fe4967g0004g0004g0004g####` (handles 0051-0066)

**Example Localization Entries**:
```xml
<content contentuid="h78fe4967g0001g0001g0001g0001" version="1">Choose a fundamental warrior technique to master.</content>
<content contentuid="h78fe4967g0001g0001g0001g0002" version="1">Warrior Training I</content>
```

---

## Warrior Talent Row Breakdown

### Warrior Class Talent Rows (Shared by All Specs)
| Level | Row | SelectorId | DisplayName | Choices (from CSV) |
|-------|-----|------------|-------------|---------------------|
| 2 | 1 | `WarriorClassTalentRow1` | Warrior Training I | Fast Footwork / War Machine / Leeching Strikes / Intervene |
| 3 | 2 | `WarriorClassTalentRow2` | Warrior Training II | Impending Victory / Heroic Leap / Storm Bolt |
| 4 | 3 | `WarriorClassTalentRow3` | Warrior Training III | Intimidating Shout / Second Wind / Frothing Berserker / Bounding Stride / Pain and Gain / Thunder Clap |
| 5 | 4 | `WarriorClassTalentRow4` | Warrior Training IV | Cacophonous Roar / Menace / Spell Reflection / Rallying Cry / Shockwave / Barbaric Training |
| 6 | 5 | `WarriorClassTalentRow5` | Warrior Training V | Honed Reflexes / Crushing Force / Bitter Immunity / Overwhelming Rage / Rumbling Earth / Reinforced Plates |
| 7 | 6 | `WarriorClassTalentRow6` | Warrior Training VI | Wrecking Throw / Shattering Throw / Sidearm / Double Time / Seismic Reverberation / Concussive Blows / Berserker Shout / Piercing Howl |
| 8 | 7 | `WarriorClassTalentRow7` | Warrior Training VII | Cruel Strikes / Wild Strikes / Dual Wield Specialization / Armored to the Teeth |
| 9 | 8 | `WarriorClassTalentRow8` | Warrior Training VIII | Thunderous Roar / Avatar / Champion's Spear |
| 10 | 9 | `WarriorClassTalentRow9` | Warrior Training IX | Uproar / Thunderous Words / Berserker's Torment / Titan's Torment / Piercing Challenge / Champion's Might |

### Arms Specialization Talent Rows
| Level | Row | SelectorId | DisplayName | Note |
|-------|-----|------------|-------------|------|
| 3 | 1 | `ArmsSpecTalentRow1` | Arms Specialization I | 3 choices per row |
| 4 | 2 | `ArmsSpecTalentRow2` | Arms Specialization II | 4-5 choices per row |
| 5 | 3 | `ArmsSpecTalentRow3` | Arms Specialization III | 2-3 choices per row |
| 6 | 4 | `ArmsSpecTalentRow4` | Arms Specialization IV | 4-5 choices per row |
| 7 | 5 | `ArmsSpecTalentRow5` | Arms Specialization V | 5-6 choices per row |
| 8 | 6 | `ArmsSpecTalentRow6` | Arms Specialization VI | 3 choices per row |
| 9 | 7 | `ArmsSpecTalentRow7` | Arms Specialization VII | 4-5 choices per row |
| 10 | 8 | `ArmsSpecTalentRow8` | Arms Specialization VIII | 4-5 choices per row |

### Fury Specialization Talent Rows
| Level | Row | SelectorId | DisplayName | Note |
|-------|-----|------------|-------------|------|
| 3 | 1 | `FurySpecTalentRow1` | Fury Specialization I | 4 choices per row |
| 4 | 2 | `FurySpecTalentRow2` | Fury Specialization II | 4-5 choices per row |
| 5 | 3 | `FurySpecTalentRow3` | Fury Specialization III | 3 choices per row |
| 6 | 4 | `FurySpecTalentRow4` | Fury Specialization IV | 6 choices per row |
| 7 | 5 | `FurySpecTalentRow5` | Fury Specialization V | 5-6 choices per row |
| 8 | 6 | `FurySpecTalentRow6` | Fury Specialization VI | 3 choices per row |
| 9 | 7 | `FurySpecTalentRow7` | Fury Specialization VII | 5 choices per row |
| 10 | 8 | `FurySpecTalentRow8` | Fury Specialization VIII | 6 choices per row |

### Protection Specialization Talent Rows
| Level | Row | SelectorId | DisplayName | Note |
|-------|-----|------------|-------------|------|
| 2 | 1 | `ProtectionSpecTalentRow1` | Protection Specialization I | 2 choices per row |
| 3 | 2 | `ProtectionSpecTalentRow2` | Protection Specialization II | 4 choices per row |
| 4 | 3 | `ProtectionSpecTalentRow3` | Protection Specialization III | 3-4 choices per row |
| 5 | 4 | `ProtectionSpecTalentRow4` | Protection Specialization IV | 5-6 choices per row |
| 6 | 5 | `ProtectionSpecTalentRow5` | Protection Specialization V | 6 choices per row |
| 7 | 6 | `ProtectionSpecTalentRow6` | Protection Specialization VI | 4-5 choices per row |
| 8 | 7 | `ProtectionSpecTalentRow7` | Protection Specialization VII | 5-6 choices per row |
| 9 | 8 | `ProtectionSpecTalentRow8` | Protection Specialization VIII | 4-5 choices per row |

---

## Next Steps

### ✅ COMPLETE:
1. Transform ProgressionDescriptions.lsx (33 nodes created)
2. Add localization handles to english.xml (66 handles added)

### ⏳ TODO (for full talent system implementation):
3. **Create PassiveLists.lsx** with 33 PassiveList nodes matching the ProgressionDescription SelectorIds
4. **Update Progressions.lsx** to use `SelectPassives(UUID,1,SelectorId)` for talent choice levels
5. **Verify in-game** that talent choice screens appear correctly

---

## Validation

### File Structure Check ✅
- [x] ProgressionDescriptions.lsx exists in correct path
- [x] XML structure is valid (241 lines, proper nesting)
- [x] All 33 nodes have unique UUIDs
- [x] All SelectorId values follow Warrior naming pattern
- [x] All localization handles follow consistent format

### Localization Check ✅
- [x] 66 handles added to english.xml (33 rows × 2 handles)
- [x] Handle format matches ProgressionDescriptions references
- [x] No duplicate contentuid values
- [x] All DisplayName and Description pairs present

### Cross-Reference Check ⚠️
- [ ] **TODO**: Verify SelectorIds match Progressions.lsx (need to update Progressions.lsx first)
- [ ] **TODO**: Verify PassiveLists.lsx exists with matching UUIDs (need to create PassiveLists.lsx)

---

## Why This File Is Needed

Your initial assessment was correct! The Warrior mod DOES use talent choices:

1. **Warrior Class Abilities (L2-L10)**: Shared talent choices for all Warriors
2. **Arms Spec Abilities (L3-L10)**: Arms-specific talent choices
3. **Fury Spec Abilities (L3-L10)**: Fury-specific talent choices
4. **Protection Spec Abilities (L2-L10)**: Protection-specific talent choices

**Total Talent Choices**: 33 choice nodes across 20 levels

This is similar to Warlock but with simpler structure:
- **Warlock**: 40 ProgressionDescription nodes (4 subclasses × 9 rows + extras)
- **Warrior**: 33 ProgressionDescription nodes (1 shared class + 3 subclass talent trees)

---

## Scripts Created

1. **Transform_ProgressionDescriptions.ps1** - Generates ProgressionDescriptions.lsx from scratch
2. **Add_ProgressionDescriptions_Localization.ps1** - Adds 66 localization handles to english.xml

Both scripts are reusable if you need to regenerate the file or add more talent rows.

---

## Comparison: Warrior vs Warlock Approach

### Similarities:
- ✅ Both use `ProgressionDescriptions.lsx` for talent choice screens
- ✅ Both use `SelectPassives()` in Progressions.lsx
- ✅ Both use PassiveLists.lsx to define talent pools

### Differences:
- **Warrior**: 33 talent rows (less choice-heavy than Warlock's 40+)
- **Warrior**: Simpler talent structure (1 choice per level, not 3-4 like Warlock)
- **Warrior**: Hero talents (L13-20) are AUTO-GRANTED not choices (Warlock has hero talent choices too)

### Your Implementation = Hybrid Approach ✅
- **L1-12**: Mix of auto-grants (baseline abilities) + talent choices (class/spec abilities)
- **L13-20**: Auto-grants only (hero talents with 3 options per tier, all granted)

This is the BEST OF BOTH WORLDS:
- Simpler than Warlock (fewer choices = less overwhelming)
- More flexible than pure auto-grant (some player agency)
- Matches modern WoW design (spec abilities with choices, hero talents simplified)

---

**Status**: ✅ ProgressionDescriptions.lsx transformation COMPLETE! File ready for use once Progressions.lsx and PassiveLists.lsx are updated with `SelectPassives()` selectors.
