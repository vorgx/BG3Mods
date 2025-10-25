# Hero Talent Tree Choice Implementation - Design Challenge

**Date**: October 24, 2025  
**Status**: ⚠️ AWAITING IMPLEMENTATION  
**Priority**: P1 - High (affects hero talent gameplay)

---

## Current Situation

### What's Working ✅
- **Database**: All 33 hero talents correctly assigned to 2 specs each (represents tree availability)
- **Progressions.lsx**: All 22 talents auto-granted per spec (temporary workaround)
- **Validation**: 100% pass rate for all progressions

### What's Missing ⚠️
- **L13 Tree Choice UI**: Player has no way to choose between 2 compatible trees
- **Conditional Granting**: No mechanism to grant only 1 tree's talents (currently grants both)

---

## Design Intent (WoW Hero Talents)

**Level 13 Experience**:
1. Player reaches L13
2. UI presents **2 hero talent tree choices** based on subclass:
   - Protection: Mountain Thane OR Colossus
   - Fury: Mountain Thane OR Slayers
   - Arms: Colossus OR Slayers
3. Player **picks 1 tree** (permanent choice)
4. As player levels, automatically receives **all 11 talents** from chosen tree:
   - L13: Keystone (1 talent)
   - L15: Choice tier 1 (3 talents)
   - L17: Choice tier 2 (3 talents)
   - L19: Choice tier 3 (3 talents)
   - L20: Capstone (1 talent)
5. Player **never receives** talents from the other tree

**Example**: Protection Warrior at L13
- **Option A**: Mountain Thane → Get Lightning Strikes (L13), then Crashing Thunder/Ground Current/Strength of Mountain (L15), etc.
- **Option B**: Colossus → Get Demolish (L13), then Martial Expert/Colossal Might/Earthquake (L15), etc.
- **Cannot have both**

---

## Current Implementation (Temporary Workaround)

**What Happens Now**:
- Protection Warrior at L13 gets **BOTH** Lightning Strikes (Mountain Thane) AND Demolish (Colossus)
- At L15, gets **ALL 6 talents**: Crashing Thunder + Ground Current + Strength of Mountain + Martial Expert + Colossal Might + Earthquake
- At L17, gets **ALL 6 talents** from both trees
- At L19, gets **ALL 6 talents** from both trees
- At L20, gets **BOTH capstones**: Avatar of the Storm + Dominance of the Colossus

**Result**: Player gets 22 talents instead of 11 (overpowered, not intended design)

---

## Implementation Challenges

### BG3 Limitations
1. **No Native Hero Talent UI**: BG3's character creation doesn't have WoW-style talent tree UI
2. **No Conditional Progression**: Progressions.lsx grants abilities automatically - no built-in "choose A or B" system
3. **No Talent Point System**: BG3 uses feat/spell selection, not WoW's spend-points-in-trees model

### Potential Solutions

#### Option 1: Feat-Based Selection (Most BG3-Native)
**Mechanism**:
- At L13, grant 2 "keystone feats" as selectable options:
  - `FEAT_Choose_Mountain_Thane` (replaces all Colossus passives with Mountain Thane)
  - `FEAT_Choose_Colossus` (replaces all Mountain Thane passives with Colossus)
- Feats add `HeroTalentTree_MountainThane` or `HeroTalentTree_Colossus` status
- Passives have `Conditions: HasStatus('HeroTalentTree_X',context.Source)` to only activate if tree chosen

**Pros**: Uses BG3's existing feat selection UI  
**Cons**: Requires creating 6 keystone feats (2 per spec), complex status/condition system

#### Option 2: Dialogue Choice (Easiest Implementation)
**Mechanism**:
- At L13, trigger one-time dialogue: "Choose your hero talent path"
- Dialogue options grant a permanent status: `CHOSEN_HERO_TREE_X`
- All hero talent passives check for status in conditions

**Pros**: Simple, uses BG3 dialogue system  
**Cons**: Immersion-breaking (why is character talking to themselves?), harder to trigger at exact level

#### Option 3: Two Separate Subclass Options (Clean but Rigid)
**Mechanism**:
- At character creation, offer 6 total subclasses instead of 3:
  - Arms (Colossus)
  - Arms (Slayers)
  - Fury (Mountain Thane)
  - Fury (Slayers)
  - Protection (Mountain Thane)
  - Protection (Colossus)
- Each subclass has L13-20 progression with only 1 tree

**Pros**: Clean, no conditional logic needed  
**Cons**: Commits player at L1 (not L13), 6 subclasses instead of 3, doesn't match WoW experience

#### Option 4: Mod Configuration Menu (External Choice)
**Mechanism**:
- Use BG3 Script Extender mod config menu
- Player selects tree before starting game or via respec
- Mod adjusts Progressions.lsx on the fly

**Pros**: Clean UI, flexible  
**Cons**: Requires Script Extender, can't change mid-playthrough easily

---

## Recommended Approach

### Phase 1 (Current - Playable but Overpowered): ✅ DONE
- Grant all 22 talents (both trees)
- Document as known issue
- Focus on getting core mod functional

### Phase 2 (Post-Release - Balanced): ⚠️ TODO
**Implement Option 1 (Feat-Based Selection)**:
1. Create 6 keystone feats (2 per spec) granting at L13
2. Each feat applies permanent status: `CHOSEN_HERO_TREE_X`
3. Update all 33 hero talent passives with condition:
   ```
   data "Conditions" "HasStatus('CHOSEN_HERO_TREE_MountainThane',context.Source)"
   ```
4. Only talents from chosen tree will activate

**Estimated Work**: 4-6 hours
- 6 feat definitions (ClassDescriptions.lsx)
- 3 status effects (Status_BOOST.txt)
- Update 33 passives with conditions (Passive.txt)
- Testing/validation

---

## User Experience Notes

### Current UX (v1.0 - Phase 1)
**Pros**:
- Player gets to try all hero talents
- Good for testing/feedback
- No complex UI needed yet

**Cons**:
- Not balanced (22 talents instead of 11)
- Doesn't match WoW design
- May confuse players expecting choice

### Future UX (v2.0 - Phase 2)
**Pros**:
- Balanced (11 talents only)
- Matches WoW hero talent design
- Clear choice moment at L13

**Cons**:
- Choice is permanent (can only change via respec)
- BG3 feat UI isn't ideal for "tree selection"

---

## Documentation Updates Needed

**When implementing choice system**:
1. Update `Progressions.lsx` to grant keystone feats at L13
2. Update `ClassDescriptions.lsx` with feat definitions
3. Update `Passive.txt` with status conditions on all hero talents
4. Update `Status_BOOST.txt` with tree choice statuses
5. Update SOURCE_OF_TRUTH.md Section [11] with implementation status
6. Create user guide explaining tree choice

---

## Related Files

**Current Implementation**:
- `Progressions.lsx` - Grants all 22 talents (both trees)
- `AbilityDatabase_Warrior_FullyEnriched.csv` - Correct dual-spec assignments
- `Warrior Progression LINKED - Main.csv` - Authoritative tree structure

**Future Implementation**:
- `ClassDescriptions.lsx` - Add keystone feats (TBD)
- `Status_BOOST.txt` - Add tree choice statuses (TBD)
- `Passive.txt` - Update with conditions (TBD)

---

## Status

**Current**: ✅ Functional but overpowered (grants both trees)  
**Goal**: ⚠️ Implement tree choice (grants 1 of 2 trees)  
**Blocker**: None (Phase 1 sufficient for initial release)  
**Priority**: P1 - High (should be done before v2.0 "balanced" release)
