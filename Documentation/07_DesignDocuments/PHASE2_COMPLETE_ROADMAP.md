# PHASE 2 IMPLEMENTATION: Complete Action Plan + FILE 11 Review Results

**Date**: October 24, 2025  
**Status**: FILE 11 functional (Phase 1), ready for Phase 2 implementation  
**Estimated Time**: 8-10 hours for full Phase 2 completion

---

## FILE 11 REVIEW RESULTS

### ✅ What's Working (Phase 1)
- **74 progression nodes** total (expected 66+ with overrides)
- **Base class (L1-12)**: 12/12 levels ✅ COMPLETE
- **Arms subclass (L3-20)**: 18/18 levels ✅ COMPLETE
- **Fury subclass (L3-20)**: 18/18 levels ✅ COMPLETE
- **Protection subclass (L3-20)**: 18/18 levels ✅ COMPLETE
- **30 unique spell list UUIDs** (one per level)
- **91 unique passives** granted across all levels
- **12 boost entries** (Rage scaling, ability increases, proficiencies)

### ⚠️ Current Limitations (Phase 1 Implementation)
1. **All 22 hero talents auto-granted** (both compatible trees granted simultaneously)
   - Arms: Gets Colossus + Slayers (20-22 talents granted)
   - Fury: Gets Mountain Thane + Slayers (20-25 talents granted)
   - Protection: Gets Mountain Thane + Colossus (18-22 talents granted)

2. **No tree choice mechanism at L13** (should offer 2 feats, player picks 1)

3. **Duplicate passive grants** (39 passives granted multiple times):
   - Hero talent keystones granted 2x each (both trees)
   - Some base passives granted to multiple specs (intended)

4. **L13 node analysis issue**:
   - Currently shows: `WAR_Fast_Footwork;WAR_War_Machine;WAR_Leeching_Strikes`
   - Should show: Hero talent keystones (WAR_Demolish, WAR_Lightning_Strikes, etc.)
   - **ACTION REQUIRED**: Verify L13 passives are correct in actual file

### 🔍 Discovered Issues
1. **Regex pattern may be mismatching L13** - shows L2 passives instead of hero talent keystones
2. **Mountain Thane name mismatch** - Script uses underscores (`Mountain_Thane`), tree uses spaces
3. **Partial talent counts** - Some trees showing 9-10/11 instead of 11/11 (likely counting issue)

---

## PHASE 2 IMPLEMENTATION ROADMAP

### Step 1: Research & Verification (1-2 hours) ⚠️ START HERE
**Goal**: Understand BG3's feat selection syntax

**Actions**:
1. Check WoWWarlock mod for feat-based selections:
   ```powershell
   cd C:\Users\tenod\source\repos\BG3Mods\Documentation\12_ReferenceMods
   # Search Warlock files for feat patterns
   ```

2. Read BG3 modding documentation for:
   - Feat definition syntax in ClassDescriptions.lsx
   - How feats apply status effects
   - Selector syntax for feat choices in Progressions.lsx

3. Verify current L13 nodes in Progressions.lsx:
   ```powershell
   # Extract actual L13 content for each spec
   Select-String -Path "...\Progressions.lsx" -Pattern 'Level.*value="13"' -Context 0,15
   ```

**Expected Output**: Clear understanding of feat implementation pattern

---

### Step 2: Create Status Effects (30 minutes)
**File**: `Data/Public/Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7/Stats/Generated/Data/Status_BOOST.txt`

**Add 3 status entries**:

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

**Validation**:
- Package mod, test that statuses can be manually applied via Script Extender console
- Verify StackId prevents multiple statuses (choosing 2nd removes 1st)

---

### Step 3: Update 33 Passive Entries (2 hours)
**File**: `Data/Public/Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7/Stats/Generated/Data/Passive.txt`

**Create bulk update script**:
```powershell
# Update_HeroTalent_Passives_Conditional.ps1
# Add EnabledConditions to all 33 hero talent passives

$PassivePath = "...\Passive.txt"
$PassiveContent = Get-Content $PassivePath -Raw

# Mountain Thane talents (11)
$MountainThanePassives = @(
    "WAR_Lightning_Strikes", "WAR_Crashing_Thunder", "WAR_Ground_Current",
    "WAR_Strength_of_the_Mountain", "WAR_Thunder_Blast", "WAR_Storm_Bolts",
    "WAR_Keep_your_feet_on_the_Ground", "WAR_Flashing_Skies", "WAR_Thorim_s_Might",
    "WAR_Burst_of_Power", "WAR_Avatar_of_the_Storm"
)

foreach ($passive in $MountainThanePassives) {
    # Find passive entry and add condition if not present
    $Pattern = '(new entry "' + $passive + '"[\s\S]*?)((?=new entry)|$)'
    $PassiveContent = $PassiveContent -replace $Pattern, {
        param($match)
        $Entry = $match.Groups[1].Value
        if ($Entry -notmatch 'EnabledConditions') {
            # Insert before last line of entry
            $Entry = $Entry -replace '(data "Properties"[^\r\n]+)', 
                '$1`r`ndata "EnabledConditions" "HasStatus(''STATUS_CHOSEN_MOUNTAIN_THANE'',context.Source)"'
        }
        $Entry
    }
}

# Repeat for Colossus (11 passives) → STATUS_CHOSEN_COLOSSUS
# Repeat for Slayers (11 passives) → STATUS_CHOSEN_SLAYERS

Set-Content -Path $PassivePath -Value $PassiveContent
```

**Manual fallback**: If script fails, update each passive manually

**Validation**:
- Test 1 passive from each tree in-game
- Verify passive only works when status present
- Verify passive doesn't work when status absent

---

### Step 4: Create 6 Feat Definitions (1 hour)
**File**: `Data/Public/Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7/ClassDescriptions/ClassDescriptions.lsx`

**Add after existing subclass definitions** (before `</children></node></children></node></region></save>`):

```xml
<!-- Arms Hero Talent Feats -->
<node id="ClassDescription">
    <attribute id="UUID" type="guid" value="GENERATE_NEW_UUID_1"/>
    <attribute id="Name" type="LSString" value="FEAT_Arms_Choose_Colossus"/>
    <attribute id="DisplayName" type="TranslatedString" handle="hFEAT001" version="1"/>
    <attribute id="Description" type="TranslatedString" handle="hFEAT002" version="1"/>
    <attribute id="ParentGuid" type="guid" value="d3c5a4f2-8b6e-4a1d-9c7f-2e8b5a3c1d9f"/> <!-- Arms UUID -->
    <attribute id="ProgressionTableUUID" type="guid" value="GENERATE_NEW_UUID_7"/>
    <attribute id="CharacterCreationPose" type="guid" value="0f07ec6e-4ef0-4d33-beea-a21a763b8648"/>
    <attribute id="SoundClassType" type="FixedString" value="Fighter"/>
    <attribute id="PrimaryAbility" type="uint8" value="1"/> <!-- Strength -->
</node>

<!-- Repeat for 5 more feats:
- FEAT_Arms_Choose_Slayers
- FEAT_Fury_Choose_MountainThane
- FEAT_Fury_Choose_Slayers
- FEAT_Protection_Choose_MountainThane
- FEAT_Protection_Choose_Colossus
-->
```

**Generate 12 new UUIDs**:
- 6 for ClassDescription nodes (feats themselves)
- 6 for ProgressionTableUUID (feat progression tables)

**Action**:
```powershell
# Generate UUIDs
1..12 | ForEach-Object { [guid]::NewGuid().ToString() }
```

**Create 6 mini progression tables** (in same Progressions.lsx file):
```xml
<!-- Colossus Feat Progression (Applies Status) -->
<node id="Progression">
    <attribute id="UUID" type="guid" value="GENERATED_UUID_7"/>
    <attribute id="Level" type="uint8" value="0"/> <!-- Granted at feat selection -->
    <attribute id="Name" type="LSString" value="FEAT_Arms_Choose_Colossus"/>
    <attribute id="Boosts" type="LSString" value="ApplyStatus(STATUS_CHOSEN_COLOSSUS)"/>
</node>
```

---

### Step 5: Modify Progressions.lsx L13 Nodes (1 hour)
**File**: `Data/Public/Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7/Progressions/Progressions.lsx`

**BEFORE (Current - Auto-grant)**:
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
    <!-- Passives removed - now granted by feats via status conditions -->
    <children>
        <node id="Selectors">
            <children>
                <node id="SelectClasses"> <!-- OR SelectFeats - RESEARCH NEEDED -->
                    <children>
                        <node id="Class"> <!-- One choice node per feat option -->
                            <attribute id="UUID" type="guid" value="UUID_OF_FEAT_Arms_Choose_Colossus"/>
                        </node>
                        <node id="Class">
                            <attribute id="UUID" type="guid" value="UUID_OF_FEAT_Arms_Choose_Slayers"/>
                        </node>
                    </children>
                </node>
            </children>
        </node>
    </children>
</node>
```

**Repeat for Fury L13** (Mountain Thane / Slayers)  
**Repeat for Protection L13** (Mountain Thane / Colossus)

**CRITICAL**: Verify selector syntax from Step 1 research before implementing

---

### Step 6: Add Localization (30 minutes)
**File**: `Data/Public/Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7/Localization/English/English.loca.xml`

**Add 18 handles**:
```xml
<!-- Feat Names -->
<content contentuid="hFEAT001" version="1">Hero Talent: Colossus</content>
<content contentuid="hFEAT003" version="1">Hero Talent: Slayers</content>
<content contentuid="hFEAT005" version="1">Hero Talent: Mountain Thane</content>
<content contentuid="hFEAT007" version="1">Hero Talent: Slayers</content>
<content contentuid="hFEAT009" version="1">Hero Talent: Mountain Thane</content>
<content contentuid="hFEAT011" version="1">Hero Talent: Colossus</content>

<!-- Feat Descriptions (2-3 sentences explaining tree) -->
<content contentuid="hFEAT002" version="1">Choose the Colossus hero talent tree. Become an unstoppable juggernaut, smashing through enemies with devastating power and unbreakable resilience. Gain 11 Colossus talents as you level to 20.</content>
<content contentuid="hFEAT004" version="1">Choose the Slayers hero talent tree. Become a relentless executor, striking down wounded enemies with brutal precision. Gain 11 Slayers talents as you level to 20.</content>
<!-- ... (4 more descriptions) -->

<!-- Status Names (hidden, but required) -->
<content contentuid="hSTATUS001" version="1">Mountain Thane Hero Tree</content>
<content contentuid="hSTATUS003" version="1">Colossus Hero Tree</content>
<content contentuid="hSTATUS005" version="1">Slayers Hero Tree</content>

<!-- Status Descriptions (hidden, but required) -->
<content contentuid="hSTATUS002" version="1">You have chosen the Mountain Thane hero talent tree.</content>
<content contentuid="hSTATUS004" version="1">You have chosen the Colossus hero talent tree.</content>
<content contentuid="hSTATUS006" version="1">You have chosen the Slayers hero talent tree.</content>
```

---

### Step 7: Testing Protocol (2-3 hours)
**Full validation cycle**:

1. **Package mod** with all Phase 2 changes
2. **Install** to BG3 Mods folder
3. **Create new character** (L1 Warrior)
4. **Level to 13** (console command: `oe levelup` or cheat engine)
5. **Verify feat selection appears** at L13 with 2 choices per spec
6. **Pick one tree** (e.g., Arms → Colossus)
7. **Check character sheet**:
   - Status present: `STATUS_CHOSEN_COLOSSUS`
   - Passive list: Only 11 Colossus talents visible
   - Passive list: Slayers talents NOT visible
8. **Test passive functionality** (cast abilities modified by tree)
9. **Level to 20**, verify all 11 talents from chosen tree activate
10. **Test respec** - verify can change tree choice
11. **Repeat for all 6 combinations** (3 specs × 2 trees each)

**Critical validation**:
- [ ] Feat selection UI appears at L13
- [ ] Can only choose 1 of 2 feats
- [ ] Choosing feat applies correct status
- [ ] Only chosen tree's 11 talents activate
- [ ] Non-chosen tree's 11 talents stay inactive
- [ ] Status persists through save/load
- [ ] Respec allows changing tree
- [ ] No console errors or crashes

---

## FILES TO UPDATE - CHECKLIST

- [ ] **Status_BOOST.txt** - Add 3 status entries (Step 2)
- [ ] **Passive.txt** - Update 33 passives with EnabledConditions (Step 3)
- [ ] **ClassDescriptions.lsx** - Add 6 feat definitions (Step 4)
- [ ] **Progressions.lsx** - Add 6 feat progression tables (Step 4)
- [ ] **Progressions.lsx** - Modify 3 L13 nodes (Arms, Fury, Protection) (Step 5)
- [ ] **English.loca.xml** - Add 18 handles (Step 6)

---

## ESTIMATED TIME BREAKDOWN

| Step | Task | Time | Difficulty |
|------|------|------|------------|
| 1 | Research feat syntax | 1-2 hours | Medium |
| 2 | Create statuses | 30 min | Easy |
| 3 | Update 33 passives | 2 hours | Medium |
| 4 | Create 6 feats | 1 hour | Hard |
| 5 | Modify L13 nodes | 1 hour | Hard |
| 6 | Localization | 30 min | Easy |
| 7 | Testing | 2-3 hours | Critical |
| **TOTAL** | | **8-10 hours** | |

---

## RISKS & MITIGATION

### Risk 1: Feat Selection Syntax Unknown
**Mitigation**: Research WoWWarlock mod first (Step 1), have backup Option 2 (Dialogue) ready

### Risk 2: Status Conditions May Not Work on Passives
**Mitigation**: Test with 1-2 passives before bulk update (Step 3 validation)

### Risk 3: Player Confusion About Permanent Choice
**Mitigation**: Very clear feat descriptions with warning text

### Risk 4: Respec May Not Clear Status
**Mitigation**: Test respec in Step 7, add manual status clear if needed

---

## BACKUP STRATEGY (If Feat Approach Fails)

**Option 2: Dialogue-Based Selection**
- Create dialogue file with 2-choice options at L13
- Dialogue grants status based on choice
- Estimated time: 6-8 hours
- Less elegant but guaranteed to work

**Option 3: Separate Subclass Options**
- Create 6 subclasses instead of 3 (Arms_Colossus, Arms_Slayers, etc.)
- Player commits at L1 instead of L13 (not WoW-accurate)
- Estimated time: 4-6 hours
- Simplest but changes class design

---

## NEXT ACTIONS

1. **User approval**: Confirm Phase 2 approach (feat-based selection)
2. **Research**: Check WoWWarlock mod for feat patterns (Step 1)
3. **Backup**: Create full backup before changes
4. **Implement**: Follow steps 2-7 sequentially
5. **Test**: Full validation cycle
6. **Document**: Update SOURCE_OF_TRUTH.md after success

**Ready to start Phase 2?** Recommend beginning with Step 1 (Research) to verify feat syntax before making changes.
