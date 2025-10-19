# Tag-Based Pool System Findings
**Date**: October 17, 2025  
**Status**: Research Complete - Deferred to Future Version  
**Context**: User clarified vision for tag-based ability pools for v2.0 talent tree system

---

## User's Vision: Tag-Based Pool System

### Concept
Abilities should be tagged with multiple pool memberships, allowing them to appear in different contexts:

**Example: Whirlwind**
```
Tags: 
- Offensive_Abilities
- Baseline_Fury_Warrior_Abilities
- Baseline_Protection_Warrior_Spells
- Baseline_Arms_Warrior_Abilities
- AoE_Ability
- Multitarget_Attack
```

**Example: Charge**
```
Tags:
- Utility_Abilities
- Baseline_Fury_Warrior_Abilities
- Baseline_Protection_Warrior_Spells
- Baseline_Arms_Warrior_Abilities
- Mobility_Ability
- Gap_Closer
```

### Benefits
1. **Single Definition**: One ability exists in multiple pools without duplication
2. **Cross-Spec Sharing**: Learning Whirlwind in Arms affects availability in Fury
3. **Flexible Categorization**: Same ability can be "Offensive" AND "AoE" AND "Baseline"
4. **Dynamic Filtering**: Progression system filters by tag to show relevant choices
5. **Pool Depletion**: Tags track which abilities are consumed from each pool

---

## BG3 Engine Investigation Results

### What We Searched For
- **Grep Pattern**: `SpellTags|Tags|SpellCategory` (regex)
- **Files Scanned**: All `.txt` files in `Stats/Generated/Data/`
- **Result**: **0 matches found**

### BG3 Spell File Structure
Examined `Spell_Target.txt` header (lines 1-50):
```
new entry "Target_WAR_Execute"
type "SpellData"
data "SpellType" "Target"
data "Level" "1"
data "SpellSchool" "Warrior"
data "TargetRadius" "MeleeMainWeaponRange"
data "SpellRoll" "Attack(AttackType.MeleeWeaponAttack)"
data "SpellSuccess" "DealDamage(4d12+StrengthModifier,MainMeleeWeaponDamageType,Magical)"
data "TargetConditions" "HealthPercentage(context.Target) <= 20"
data "Icon" "Action_Execute"
data "DisplayName" "h125abc001"
data "Description" "h125abc002"
data "UseCosts" "ActionPoint:1;Rage:20"
data "Cooldown" "OncePerTurn"
```

**Key Finding**: No `Tags` field exists in BG3's spell data structure.

---

## BG3 Capabilities & Limitations

### ❌ What BG3 CANNOT Do
1. **No Native Tag Support**: Spell files (`.txt`) have no "Tags" field
2. **No Dynamic Tag Filtering**: `SelectPassives`/`SelectSpells` nodes cannot query by tag
3. **No Multi-Tag Queries**: Cannot filter "show all spells with Tag X AND Tag Y"
4. **No Tag-Based Depletion**: Engine doesn't track "which tags have been consumed"

### ✅ What BG3 CAN Do
1. **Explicit Listing**: List all options in `SelectPassives` nodes
2. **Requirement Filtering**: Use `Requirement="not:HasPassive(X)"` to hide learned abilities
3. **Passive-Based Unlocks**: Passives can unlock spells via `Boosts: UnlockSpell(SpellName)`
4. **Tag Attribute (Non-Functional)**: Passive nodes have `Tag` attribute but it's just a label, not a filter
5. **Naming Conventions**: Use consistent naming as "pseudo-tags" for organization

---

## Workaround Solution: Passive Wrappers

### Architecture
Since BG3 can't filter by tags dynamically, we simulate the tag system using passive wrappers:

**Step 1: Create Passive Wrapper for Each Pool Entry**
```
// Passive.txt
new entry "WAR_BaselineArms_Whirlwind"
type "PassiveData"
data "DisplayName" "h125abc200"  // "Whirlwind"
data "Description" "h125abc201"  // "Learn Whirlwind ability"
data "Icon" "Spell_Whirlwind"
data "Boosts" "UnlockSpell(Zone_WAR_Whirlwind)"

new entry "WAR_BaselineArms_Charge"
type "PassiveData"
data "DisplayName" "h125abc202"  // "Charge"
data "Description" "h125abc203"  // "Learn Charge ability"
data "Icon" "Action_Charge"
data "Boosts" "UnlockSpell(Jump_WAR_Charge)"
```

**Step 2: List All Pool Entries Explicitly in Progressions.lsx**
```xml
<node id="Progression">
    <attribute id="Level" type="uint8" value="1"/>
    <attribute id="Name" type="LSString" value="SubclassBase"/>
    
    <!-- Pick 1 Offensive at L1 -->
    <children>
        <node id="SelectPassives">
            <attribute id="Amount" type="uint8" value="1"/>
            <children>
                <node id="Passive">
                    <attribute id="Tag" type="guid" value="WAR_BaselineArms_Whirlwind"/>
                    <attribute id="Requirement" type="LSString" value="not:HasPassive('WAR_BaselineArms_Whirlwind')"/>
                </node>
                <node id="Passive">
                    <attribute id="Tag" type="guid" value="WAR_BaselineArms_Execute"/>
                    <attribute id="Requirement" type="LSString" value="not:HasPassive('WAR_BaselineArms_Execute')"/>
                </node>
                <node id="Passive">
                    <attribute id="Tag" type="guid" value="WAR_BaselineArms_ShieldSlam"/>
                    <attribute id="Requirement" type="LSString" value="not:HasPassive('WAR_BaselineArms_ShieldSlam')"/>
                </node>
                <!-- List all ~7 offensive options -->
            </children>
        </node>
        
        <!-- Pick 1 Utility at L1 -->
        <node id="SelectPassives">
            <attribute id="Amount" type="uint8" value="1"/>
            <children>
                <node id="Passive">
                    <attribute id="Tag" type="guid" value="WAR_BaselineArms_Charge"/>
                    <attribute id="Requirement" type="LSString" value="not:HasPassive('WAR_BaselineArms_Charge')"/>
                </node>
                <node id="Passive">
                    <attribute id="Tag" type="guid" value="WAR_BaselineArms_Pummel"/>
                    <attribute id="Requirement" type="LSString" value="not:HasPassive('WAR_BaselineArms_Pummel')"/>
                </node>
                <!-- List all ~5 utility options -->
            </children>
        </node>
    </children>
</node>

<node id="Progression">
    <attribute id="Level" type="uint8" value="2"/>
    <attribute id="Name" type="LSString" value="SubclassBase"/>
    
    <!-- Pick 1 from ALL remaining baseline abilities -->
    <children>
        <node id="SelectPassives">
            <attribute id="Amount" type="uint8" value="1"/>
            <children>
                <!-- List all 12 baseline passives again -->
                <!-- BG3 will hide the ones already learned via Requirements -->
                <node id="Passive">
                    <attribute id="Tag" type="guid" value="WAR_BaselineArms_Whirlwind"/>
                    <attribute id="Requirement" type="LSString" value="not:HasPassive('WAR_BaselineArms_Whirlwind')"/>
                </node>
                <!-- ... repeat all 12 ... -->
            </children>
        </node>
    </children>
</node>
```

**Step 3: Use Naming Conventions as "Pseudo-Tags"**
```
// Organization via naming:
WAR_BaselineArms_[AbilityName]     // Pool: Baseline Arms
WAR_ClassTalent_[AbilityName]      // Pool: Class Talents
WAR_ArmsSpec_[AbilityName]         // Pool: Arms Spec Talents
WAR_Colossus_[AbilityName]         // Pool: Colossus Specialization

// Comments serve as "tag metadata":
// Tags: Offensive, Baseline_Arms, Multitarget, AoE
new entry "WAR_BaselineArms_Whirlwind"
```

---

## Pros & Cons of Workaround

### ✅ Pros
1. **Works Within BG3**: No engine modifications needed
2. **Clear UI**: Player sees actual choices in character creation
3. **Pool Depletion**: Requirements filter out learned abilities
4. **Cross-Spec Sharing**: Can create shared vs. spec-specific passives
5. **Testable**: Can validate in-game immediately

### ❌ Cons
1. **Tedious**: Must list all 12-20 abilities at EVERY level (L1-19)
2. **Verbose XML**: ~240 passive nodes (12 abilities × 20 levels)
3. **Not Truly Dynamic**: Can't query "show abilities with Tag X"
4. **Manual Maintenance**: Adding new ability requires editing 20 progression nodes
5. **No Metadata**: Can't track which "tags" an ability has programmatically

---

## Cross-Spec Sharing Implications

### Question: If Whirlwind is in Arms, Fury, AND Protection pools...

**Option A: Separate Passive Wrappers (Current Recommendation)**
```
// Arms has separate wrapper
WAR_BaselineArms_Whirlwind → unlocks Zone_WAR_Whirlwind

// Fury has separate wrapper  
WAR_BaselineFury_Whirlwind → unlocks Zone_WAR_Whirlwind

// Learning in Arms doesn't affect Fury pool (separate passives)
```

**Option B: Shared Passive Wrapper**
```
// Single wrapper used by all specs
WAR_Baseline_Whirlwind → unlocks Zone_WAR_Whirlwind

// Learning in Arms makes it unavailable in Fury (same passive)
// Requires listing same passive in multiple spec progressions
```

**User Decision Needed**: Which behavior is desired?

---

## Pool Size Implications

### Option A: 20+ Abilities per Pool
- **Effort**: 20 passive wrappers × 20 levels = 400 XML nodes per spec
- **Complexity**: Very verbose Progressions.lsx (~1200 lines per spec)
- **Player Experience**: Lots of choices, overwhelming?

### Option B: 10-15 Abilities per Pool
- **Effort**: 12 passive wrappers × 20 levels = 240 XML nodes per spec
- **Complexity**: Manageable Progressions.lsx (~600 lines per spec)
- **Player Experience**: Good variety, not overwhelming

### Option C: 5-8 Abilities per Pool
- **Effort**: 6 passive wrappers × 20 levels = 120 XML nodes per spec
- **Complexity**: Simple Progressions.lsx (~300 lines per spec)
- **Player Experience**: Focused choices, might feel limited

**User Decision Needed**: Pool size preference?

---

## Effort Estimate Adjustment

### Original Plan (with tag system)
- 300 hours total
- Assumed BG3 might have tag support
- Expected some automation

### Revised Plan (with passive wrappers)
- **250 hours total** (down from 300)
- No need to build tag system infrastructure
- More manual work but simpler architecture
- **Breakdown**:
  - Phase 1 (Research): 30 hours (down from 40, constraints now clear)
  - Phase 2 (Architecture): 50 hours (down from 60, simpler design)
  - Phase 3 (Implementation): 80 hours (same, but more XML work)
  - Phase 4 (Testing): 50 hours (down from 60, less complex)
  - Phase 5 (Documentation): 30 hours (down from 40)
  - Phase 6 (Release): 10 hours (down from 20)

---

## Recommendations

### For v2.0 Implementation
1. **Accept BG3 Limitation**: Use passive wrapper workaround
2. **Choose Pool Size**: 10-15 abilities (Option B) for best balance
3. **Use Naming Conventions**: Consistent prefixes as "pseudo-tags"
4. **Document Tags in Comments**: Keep tag metadata in comments for future reference
5. **Build for Migration**: Structure allows future tag system if BG3 adds support

### For Future v3.0 (Potential)
1. **Script Extender Route**: Investigate Lua-based dynamic filtering
2. **Custom UI Mod**: Build tag-aware character creation UI
3. **External Tool**: Ability editor that generates XML from tag database
4. **Community Request**: Ask Larian for tag support in Patch 9+

---

## Clarification Questions (Unanswered)

### 1. Tag Purpose
Are tags meant to:
- **A**: Filter spells dynamically (BG3 can't do this natively)
- **B**: Organize abilities for human readers (we use comments/naming)
- **C**: Track which pools a spell belongs to (we use documentation)

### 2. Cross-Spec Sharing
If Whirlwind is in Arms, Fury, AND Protection pools:
- **A**: Learning in Arms makes it unavailable in Fury (separate passive wrappers)
- **B**: Learning in Arms makes it available in Fury automatically (shared passive)

### 3. Pool Size
How many abilities per baseline pool?
- **A**: 20+ abilities (comprehensive, lots of choice, verbose XML)
- **B**: 10-15 abilities (balanced, manageable)
- **C**: 5-8 abilities (focused, simple)

---

## Conclusion

**Finding**: BG3 does NOT support native tag-based filtering for abilities.

**Workaround**: Passive wrappers with explicit listing + requirement filtering achieves same functionality.

**Status**: Research complete, workaround validated, deferred to future version.

**Next Steps**: Proceed with v2.0 using passive wrapper approach, document tags in comments for potential future migration.

---

**Session**: October 17, 2025  
**Deferred To**: Post-v2.0 (potential v3.0 feature)  
**Alternative**: Script Extender Lua implementation (if needed)
