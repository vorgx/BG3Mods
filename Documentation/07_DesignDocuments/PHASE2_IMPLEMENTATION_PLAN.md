# PHASE 2: Hero Talent Tree Choice Implementation Plan

**Goal**: Implement L13 tree choice so player picks 1 of 2 compatible trees  
**Current Status**: All 22 talents auto-granted (both trees)  
**Target Status**: Only 11 talents granted based on player choice at L13

---

## Implementation Approach: Feat-Based Selection

### Why This Approach?
- Uses BG3's native feat selection UI
- No Script Extender required
- Permanent choice (can change via respec)
- Clean conditional logic with status effects

---

## Files That Need Updates

### 1. ClassDescriptions.lsx ⚠️ CRITICAL
**Location**: `Data/Public/Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7/ClassDescriptions/ClassDescriptions.lsx`

**Changes Needed**:
Add 6 new feat definitions (2 per subclass) that grant at L13:

```xml
<!-- Arms Subclass L13 Feat Choices -->
<node id="ClassDescription">
    <attribute id="Name" type="LSString" value="FEAT_Arms_Choose_Colossus"/>
    <attribute id="DisplayName" type="TranslatedString" handle="hFEAT001" version="1"/>
    <attribute id="Description" type="TranslatedString" handle="hFEAT002" version="1"/>
    <attribute id="ParentGuid" type="guid" value="d3c5a4f2-8b6e-4a1d-9c7f-2e8b5a3c1d9f"/> <!-- Arms UUID -->
    <attribute id="ProgressionTableUUID" type="guid" value="NEW_UUID_FOR_FEAT"/>
</node>

<node id="ClassDescription">
    <attribute id="Name" type="LSString" value="FEAT_Arms_Choose_Slayers"/>
    <attribute id="DisplayName" type="TranslatedString" handle="hFEAT003" version="1"/>
    <attribute id="Description" type="TranslatedString" handle="hFEAT004" version="1"/>
    <attribute id="ParentGuid" type="guid" value="d3c5a4f2-8b6e-4a1d-9c7f-2e8b5a3c1d9f"/>
    <attribute id="ProgressionTableUUID" type="guid" value="NEW_UUID_FOR_FEAT"/>
</node>

<!-- Repeat for Fury (Mountain Thane/Slayers) and Protection (Mountain Thane/Colossus) -->
```

**Feats to Create**:
1. `FEAT_Arms_Choose_Colossus` → Applies `STATUS_CHOSEN_COLOSSUS`
2. `FEAT_Arms_Choose_Slayers` → Applies `STATUS_CHOSEN_SLAYERS`
3. `FEAT_Fury_Choose_MountainThane` → Applies `STATUS_CHOSEN_MOUNTAIN_THANE`
4. `FEAT_Fury_Choose_Slayers` → Applies `STATUS_CHOSEN_SLAYERS`
5. `FEAT_Protection_Choose_MountainThane` → Applies `STATUS_CHOSEN_MOUNTAIN_THANE`
6. `FEAT_Protection_Choose_Colossus` → Applies `STATUS_CHOSEN_COLOSSUS`

---

### 2. Progressions.lsx ⚠️ CRITICAL
**Location**: `Data/Public/Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7/Progressions/Progressions.lsx`

**Changes Needed**:
Modify L13 nodes for each subclass to grant feat selection instead of passives:

**BEFORE (Current - Auto-grants all passives)**:
```xml
<!-- Arms Level 13 -->
<node id="Progression">
    <attribute id="Level" type="uint8" value="13"/>
    <attribute id="Name" type="LSString" value="Arms"/>
    <attribute id="PassivesAdded" type="LSString" value="WAR_Demolish;WAR_Slayer_s_Dominance"/>
</node>
```

**AFTER (Feat Selection)**:
```xml
<!-- Arms Level 13 -->
<node id="Progression">
    <attribute id="Level" type="uint8" value="13"/>
    <attribute id="Name" type="LSString" value="Arms"/>
    <children>
        <node id="Selectors">
            <children>
                <node id="SelectPassives">
                    <attribute id="UUID" type="guid" value="NEW_PASSIVELIST_UUID"/>
                </node>
            </children>
        </node>
    </children>
</node>
```

**Alternative**: Use feat selection mechanism (need to research exact syntax for optional feat grants)

---

### 3. Status_BOOST.txt
**Location**: `Data/Public/Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7/Stats/Generated/Data/Status_BOOST.txt`

**Changes Needed**:
Add 3 new permanent status effects (one per tree):

```
new entry "STATUS_CHOSEN_MOUNTAIN_THANE"
type "StatusData"
data "StatusType" "BOOST"
data "DisplayName" "hSTATUS001;1"
data "Description" "hSTATUS002;1"
data "Icon" "TODO_GenericIcon"
data "StackId" "CHOSEN_HERO_TREE"
data "StackPriority" "100"
data "RemoveEvents" "Never"
data "RemoveConditions" ""
data "StatusPropertyFlags" "DisableOverhead;DisableCombatlog;DisablePortraitIndicator"

new entry "STATUS_CHOSEN_COLOSSUS"
type "StatusData"
data "StatusType" "BOOST"
data "DisplayName" "hSTATUS003;1"
data "Description" "hSTATUS004;1"
data "Icon" "TODO_GenericIcon"
data "StackId" "CHOSEN_HERO_TREE"
data "StackPriority" "100"
data "RemoveEvents" "Never"
data "RemoveConditions" ""
data "StatusPropertyFlags" "DisableOverhead;DisableCombatlog;DisablePortraitIndicator"

new entry "STATUS_CHOSEN_SLAYERS"
type "StatusData"
data "StatusType" "BOOST"
data "DisplayName" "hSTATUS005;1"
data "Description" "hSTATUS006;1"
data "Icon" "TODO_GenericIcon"
data "StackId" "CHOSEN_HERO_TREE"
data "StackPriority" "100"
data "RemoveEvents" "Never"
data "RemoveConditions" ""
data "StatusPropertyFlags" "DisableOverhead;DisableCombatlog;DisablePortraitIndicator"
```

**Key Properties**:
- `StackId`: Ensures only 1 tree can be chosen (choosing another removes first)
- `RemoveEvents`: "Never" makes choice permanent (until respec)
- `StatusPropertyFlags`: Hides from UI (internal tracking only)

---

### 4. Passive.txt ⚠️ CRITICAL - BULK UPDATE
**Location**: `Data/Public/Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7/Stats/Generated/Data/Passive.txt`

**Changes Needed**:
Update ALL 33 hero talent passives with conditional checks:

**BEFORE (Current - Always active)**:
```
new entry "WAR_Lightning_Strikes"
type "PassiveData"
data "DisplayName" "h123abc01;1"
data "Description" "h123abc02;1"
data "Icon" "TODO_GenericIcon"
data "Properties" "Highlighted"
data "Boosts" "UnlockSpell(Spell_WAR_Lightning_Strike_Attack)"
```

**AFTER (Conditional on tree choice)**:
```
new entry "WAR_Lightning_Strikes"
type "PassiveData"
data "DisplayName" "h123abc01;1"
data "Description" "h123abc02;1"
data "Icon" "TODO_GenericIcon"
data "Properties" "Highlighted"
data "Boosts" "UnlockSpell(Spell_WAR_Lightning_Strike_Attack)"
data "EnabledConditions" "HasStatus('STATUS_CHOSEN_MOUNTAIN_THANE',context.Source)"
```

**Passives to Update** (33 total):

**Mountain Thane (11)**:
- WAR_Lightning_Strikes → Add condition: `HasStatus('STATUS_CHOSEN_MOUNTAIN_THANE')`
- WAR_Crashing_Thunder → Add condition: `HasStatus('STATUS_CHOSEN_MOUNTAIN_THANE')`
- WAR_Ground_Current → Add condition: `HasStatus('STATUS_CHOSEN_MOUNTAIN_THANE')`
- WAR_Strength_of_the_Mountain → Add condition: `HasStatus('STATUS_CHOSEN_MOUNTAIN_THANE')`
- WAR_Thunder_Blast → Add condition: `HasStatus('STATUS_CHOSEN_MOUNTAIN_THANE')`
- WAR_Storm_Bolts → Add condition: `HasStatus('STATUS_CHOSEN_MOUNTAIN_THANE')`
- WAR_Keep_your_feet_on_the_Ground → Add condition: `HasStatus('STATUS_CHOSEN_MOUNTAIN_THANE')`
- WAR_Flashing_Skies → Add condition: `HasStatus('STATUS_CHOSEN_MOUNTAIN_THANE')`
- WAR_Thorim_s_Might → Add condition: `HasStatus('STATUS_CHOSEN_MOUNTAIN_THANE')`
- WAR_Burst_of_Power → Add condition: `HasStatus('STATUS_CHOSEN_MOUNTAIN_THANE')`
- WAR_Avatar_of_the_Storm → Add condition: `HasStatus('STATUS_CHOSEN_MOUNTAIN_THANE')`

**Colossus (11)**:
- WAR_Demolish → Add condition: `HasStatus('STATUS_CHOSEN_COLOSSUS')`
- WAR_Martial_Expert → Add condition: `HasStatus('STATUS_CHOSEN_COLOSSUS')`
- WAR_Colossal_Might → Add condition: `HasStatus('STATUS_CHOSEN_COLOSSUS')`
- WAR_Earthquake → Add condition: `HasStatus('STATUS_CHOSEN_COLOSSUS')`
- WAR_Arterial_Bleed → Add condition: `HasStatus('STATUS_CHOSEN_COLOSSUS')`
- WAR_Tide_of_Battle → Add condition: `HasStatus('STATUS_CHOSEN_COLOSSUS')`
- WAR_No_Stranger_to_Pain → Add condition: `HasStatus('STATUS_CHOSEN_COLOSSUS')`
- WAR_Practiced_Strikes → Add condition: `HasStatus('STATUS_CHOSEN_COLOSSUS')`
- WAR_Precise_Might → Add condition: `HasStatus('STATUS_CHOSEN_COLOSSUS')`
- WAR_Mountain_of_Muscle_and_Scars → Add condition: `HasStatus('STATUS_CHOSEN_COLOSSUS')`
- WAR_Dominance_of_the_Colossus → Add condition: `HasStatus('STATUS_CHOSEN_COLOSSUS')`

**Slayers (11)**:
- WAR_Slayer_s_Dominance → Add condition: `HasStatus('STATUS_CHOSEN_SLAYERS')`
- WAR_Imminent_Demise → Add condition: `HasStatus('STATUS_CHOSEN_SLAYERS')`
- WAR_Overwhelming_Blades → Add condition: `HasStatus('STATUS_CHOSEN_SLAYERS')`
- WAR_Relentless_Pursuit → Add condition: `HasStatus('STATUS_CHOSEN_SLAYERS')`
- WAR_Death_Drive → Add condition: `HasStatus('STATUS_CHOSEN_SLAYERS')`
- WAR_Brutal_Finish → Add condition: `HasStatus('STATUS_CHOSEN_SLAYERS')`
- WAR_Opportunist → Add condition: `HasStatus('STATUS_CHOSEN_SLAYERS')`
- WAR_Show_No_Mercy → Add condition: `HasStatus('STATUS_CHOSEN_SLAYERS')`
- WAR_Reap_the_Storm → Add condition: `HasStatus('STATUS_CHOSEN_SLAYERS')`
- WAR_Slayer_s_Malice → Add condition: `HasStatus('STATUS_CHOSEN_SLAYERS')`
- WAR_Unrelenting_Onslaught → Add condition: `HasStatus('STATUS_CHOSEN_SLAYERS')`

---

### 5. Localization (English.loca.xml)
**Location**: `Data/Public/Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7/Localization/English/English.loca.xml`

**Changes Needed**:
Add localization handles for:
- 6 feat names (`hFEAT001`, `hFEAT003`, `hFEAT005`, `hFEAT007`, `hFEAT009`, `hFEAT011`)
- 6 feat descriptions (`hFEAT002`, `hFEAT004`, `hFEAT006`, `hFEAT008`, `hFEAT010`, `hFEAT012`)
- 3 status names (`hSTATUS001`, `hSTATUS003`, `hSTATUS005`)
- 3 status descriptions (`hSTATUS002`, `hSTATUS004`, `hSTATUS006`)

**Example**:
```xml
<content contentuid="hFEAT001" version="1">Hero Talent: Colossus</content>
<content contentuid="hFEAT002" version="1">Choose the Colossus hero talent tree. Gain all Colossus talents as you level.</content>
<content contentuid="hFEAT003" version="1">Hero Talent: Slayers</content>
<content contentuid="hFEAT004" version="1">Choose the Slayers hero talent tree. Gain all Slayers talents as you level.</content>
```

---

## Step-by-Step Implementation Plan

### Step 1: Research BG3 Feat Selection Syntax ⚠️ CRITICAL
**Before implementing, we need to understand**:
- How to make feats selectable at specific level (L13)
- How feats apply status effects in BG3
- Whether feats need separate Progressions.lsx entries
- Exact XML syntax for feat selection in Progressions.lsx

**Action**: Review WoWWarlock mod to see if it has any feat-based selections we can copy

### Step 2: Create Status Effects
**Files**: `Status_BOOST.txt`
**Estimated Time**: 30 minutes
- Add 3 status entries
- Test that they can be applied
- Verify StackId prevents multiple selections

### Step 3: Create Feat Definitions
**Files**: `ClassDescriptions.lsx`
**Estimated Time**: 1 hour
- Add 6 feat entries
- Link to status effects
- Generate 6 new UUIDs for feats

### Step 4: Update Progressions.lsx L13
**Files**: `Progressions.lsx`
**Estimated Time**: 1 hour
- Modify Arms L13 node (feat selection)
- Modify Fury L13 node (feat selection)
- Modify Protection L13 node (feat selection)
- Remove auto-granted passives from L13

### Step 5: Bulk Update Passive.txt
**Files**: `Passive.txt`
**Estimated Time**: 2 hours
- Create script to add `EnabledConditions` to all 33 hero talent passives
- Verify each passive has correct status check
- Test that passives only activate with status

### Step 6: Add Localization
**Files**: `English.loca.xml`
**Estimated Time**: 30 minutes
- Add 18 new handles (6 feats + 3 statuses × 2 strings each)
- Write clear descriptions explaining tree choice

### Step 7: Testing
**Estimated Time**: 2-3 hours
- Create new character, level to 13
- Verify feat selection appears
- Pick one tree, verify only those 11 passives activate
- Verify other tree's passives do NOT activate
- Test respec to change tree choice
- Test all 3 subclasses × 2 tree choices = 6 combinations

---

## Total Estimated Time: 8-10 hours

**Breakdown**:
- Research/Planning: 1-2 hours
- Status Effects: 0.5 hours
- Feat Definitions: 1 hour
- Progressions Update: 1 hour
- Passive Bulk Update: 2 hours
- Localization: 0.5 hours
- Testing/Debugging: 2-3 hours

---

## Risks & Mitigation

### Risk 1: BG3 Feat Selection May Not Work as Expected
**Mitigation**: Research WoWWarlock mod first, have backup Option 2 (Dialogue) ready

### Risk 2: Status Conditions May Not Work on Passives
**Mitigation**: Test with 1-2 passives before bulk update

### Risk 3: Player May Pick Wrong Tree (Permanent Choice)
**Mitigation**: Very clear feat descriptions, add in-game warning text

---

## Validation Checklist

**After implementation, verify**:
- [ ] L13 presents exactly 2 feat choices per subclass
- [ ] Choosing feat applies correct status
- [ ] Only 11 passives from chosen tree activate
- [ ] Other 11 passives from non-chosen tree stay inactive
- [ ] Status persists through save/load
- [ ] Respec allows changing tree choice
- [ ] All 6 combinations work (3 specs × 2 trees)
- [ ] Feat descriptions are clear and accurate
- [ ] No console errors when selecting feats
- [ ] No console errors when passives check status

---

## Next Actions

1. **User Decision**: Approve this approach OR suggest alternative
2. **Research**: Check WoWWarlock mod for feat selection examples
3. **Create backup**: Before making changes
4. **Start with Step 2**: Create status effects (safest first step)
5. **Test incrementally**: Don't do all 33 passives at once

**Ready to proceed?** Let me know if this plan looks good or if you want to adjust the approach!
