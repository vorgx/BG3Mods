# BG3 Spell Grant Approaches - Complete Guide

**Created**: October 21, 2025  
**Purpose**: Document the different methods for granting spells/abilities to custom classes in BG3 mods  
**Context**: Understanding which approach to use for different mod designs

---

## Overview

There are **4 main approaches** modders use to grant abilities to custom classes in Baldur's Gate 3. Each has different trade-offs for complexity, flexibility, and compatibility.

---

## Approach 1: Direct SpellList Reference (Traditional)

### How It Works

- `ClassDescriptions.lsx` has a `SpellListUUID` attribute pointing to a SpellList in `SpellLists.lsx`
- That SpellList contains ALL spells for the class
- Game automatically grants spells based on the SpellList's level-based entries
- No Progressions.lsx involvement for spell grants

### Example Structure

**ClassDescriptions.lsx**:
```xml
<node id="ClassDescription">
    <attribute id="Name" value="Warrior"/>
    <attribute id="SpellList" value="12345678-1234-1234-1234-123456789012"/>
</node>
```

**SpellLists.lsx**:
```xml
<node id="SpellList">
    <attribute id="UUID" value="12345678-1234-1234-1234-123456789012"/>
    <children>
        <node id="Spell">
            <attribute id="Level" value="1"/>
            <attribute id="SpellId" value="WAR_Charge"/>
        </node>
        <node id="Spell">
            <attribute id="Level" value="3"/>
            <attribute id="SpellId" value="WAR_Execute"/>
        </node>
    </children>
</node>
```

### Pros

- ✅ **Simple structure** - One SpellList per class, easy to understand
- ✅ **Easy to maintain** - All spells in one place
- ✅ **Well-documented** - Vanilla BG3 uses this pattern
- ✅ **Predictable** - Clear level → spell mapping

### Cons

- ❌ **No player choice** - All spells granted automatically (no talent trees)
- ❌ **No build customization** - Can't create "Arms vs. Fury vs. Protection" paths
- ❌ **No conditional grants** - Can't say "only if you picked Arms spec"
- ❌ **No SelectPassives** - Can't use talent row system
- ❌ **Static progression** - Same for every player

### Used By

- **Vanilla BG3 classes**: Wizard, Cleric, Sorcerer, etc. (fixed spell progressions)
- **Simple custom class mods**: Classes without talent trees or subclass differentiation

### When to Use

✅ **Good for**:
- Simple custom classes with fixed spell lists
- Spellcasting classes with automatic spell learning (like Wizard)
- Mods that don't need player choice or talent trees

❌ **Avoid for**:
- Classes with talent trees (WoW-style)
- Classes with divergent subclass progressions
- Mods requiring conditional spell grants

---

## Approach 2: Progressions-Only (Zero SpellList) ⭐ RECOMMENDED

### How It Works

- `ClassDescriptions.lsx` has a **dummy/placeholder** SpellListUUID that's **NEVER defined** in `SpellLists.lsx`
- Game ignores the ClassDescription SpellList (hence "zero SpellList")
- `Progressions.lsx` handles **ALL** spell grants via `AddSpells(UUID)` and `SelectPassives(UUID)`
- `SpellLists.lsx` contains level-specific spell lists **referenced by Progressions**, not ClassDescription
- `PassiveLists.lsx` contains talent row choices **referenced by Progressions**

### Example Structure

**ClassDescriptions.lsx**:
```xml
<node id="ClassDescription">
    <attribute id="Name" value="Warrior"/>
    <!-- DUMMY UUID - NEVER DEFINED IN SpellLists.lsx -->
    <attribute id="SpellList" value="32879c22-4858-48ef-8f8d-22e6d395b396"/> 
</node>
```

**Progressions.lsx** (Level 1):
```xml
<node id="Progression">
    <attribute id="Level" value="1"/>
    <attribute id="Name" value="Warrior"/>
    <attribute id="PassivesAdded" value="WAR_RageGeneration"/>
    <attribute id="Selectors" value="AddSpells(aaaa-bbbb-cccc-dddd);SelectAbilityBonus(...)"/>
</node>
```

**Progressions.lsx** (Level 2 with talents):
```xml
<node id="Progression">
    <attribute id="Level" value="2"/>
    <attribute id="Name" value="Warrior"/>
    <attribute id="Selectors" value="AddSpells(eeee-ffff-1111-2222);SelectPassives(3333-4444-5555-6666,1,WarriorRow2)"/>
</node>
```

**SpellLists.lsx** (referenced by Progressions L1):
```xml
<node id="SpellList">
    <!-- Referenced by Progressions AddSpells(), NOT ClassDescription -->
    <attribute id="UUID" value="aaaa-bbbb-cccc-dddd"/>
    <children>
        <node id="Spell"><attribute id="SpellId" value="WAR_Charge"/></node>
        <node id="Spell"><attribute id="SpellId" value="WAR_Whirlwind"/></node>
    </children>
</node>
```

**PassiveLists.lsx** (referenced by Progressions L2):
```xml
<node id="PassiveList">
    <!-- Referenced by Progressions SelectPassives(), talent choices -->
    <attribute id="UUID" value="3333-4444-5555-6666"/>
    <children>
        <node id="Passive"><attribute id="PassiveId" value="WAR_Talent_Option1"/></node>
        <node id="Passive"><attribute id="PassiveId" value="WAR_Talent_Option2"/></node>
        <node id="Passive"><attribute id="PassiveId" value="WAR_Talent_Option3"/></node>
    </children>
</node>
```

### Key Mechanisms

**1. AddSpells(UUID)** - Grant baseline abilities:
```xml
<attribute id="Selectors" value="AddSpells(UUID)"/>
```
- UUID references a SpellList in `SpellLists.lsx`
- All spells in that list are granted automatically
- Use for baseline abilities (non-choice spells)

**2. SelectPassives(UUID, amount, RowName)** - Grant talent choices:
```xml
<attribute id="Selectors" value="SelectPassives(UUID,1,WarriorClassTalentRow2)"/>
```
- UUID references a PassiveList in `PassiveLists.lsx`
- Player picks `amount` talents from that list
- Use for talent trees (player choice system)

**3. PassivesAdded** - Auto-grant passives:
```xml
<attribute id="PassivesAdded" value="WAR_Arms_Row1_Talent1;WAR_Arms_Row1_Talent2"/>
```
- Semicolon-separated passive IDs
- Granted automatically (no player choice)
- Use for subclass foundation (e.g., Arms Row 1 auto-grants at L3)

### Pros

- ✅ **Player choice/talent trees** - Full `SelectPassives()` support for talent rows
- ✅ **Conditional grants** - Different spells per subclass (Arms/Fury/Protection get different AddSpells UUIDs)
- ✅ **Fine-grained control** - Level-by-level customization per subclass
- ✅ **Proven at scale** - WoWWarlock mod: **13,000+ downloads, no major bugs**
- ✅ **BG3 native** - Uses vanilla Progressions.lsx system (no Script Extender)
- ✅ **Flexible** - Can mix auto-grants (PassivesAdded) with choices (SelectPassives)
- ✅ **Subclass support** - Each subclass can have different Progressions

### Cons

- ❌ **Complex structure** - 50+ UUIDs for full talent tree implementation (Warrior: 58 UUIDs)
- ❌ **Harder to debug** - Spell grants split across 3 files (Progressions, SpellLists, PassiveLists)
- ❌ **More XML boilerplate** - Verbose Progressions.lsx with many nodes
- ❌ **Requires planning** - Must map out SpellList/PassiveList UUIDs ahead of time

### Used By (Proven Mods)

- ✅ **WoWWarlock** (13,000+ downloads) - 3 subclasses, 10+ talent rows
- ✅ **WoWPriest** (4,000+ downloads) - 3 subclasses, talent trees
- ✅ **WoWDeathKnight** (6,000+ downloads) - 3 subclasses, rune system
- ✅ **Our Warrior mod** (current implementation) - 3 subclasses, hero talents

### When to Use ⭐

✅ **BEST FOR**:
- WoW-style classes with talent trees
- Classes with divergent subclass progressions (Arms/Fury/Protection get different abilities)
- Mods requiring player choice at multiple levels
- Large-scale mods with 50+ abilities and 20+ talents
- Production mods (proven stable)

❌ **Avoid for**:
- Simple classes with fixed spell lists (use Approach 1 instead)
- Mods without talent trees (unnecessary complexity)

---

## Approach 3: Hybrid (SpellList + Progressions)

### How It Works

- `ClassDescriptions.lsx` has a **REAL** SpellListUUID for auto-granted base spells
- `Progressions.lsx` adds **ADDITIONAL** spells/talents via `AddSpells()` and `SelectPassives()`
- Combines benefits of both Approach 1 (simple base spells) and Approach 2 (talent choices)

### Example Structure

**ClassDescriptions.lsx**:
```xml
<node id="ClassDescription">
    <attribute id="Name" value="Warrior"/>
    <!-- REAL UUID - DOES exist in SpellLists.lsx -->
    <attribute id="SpellList" value="12345678-real-uuid-here"/>
</node>
```

**SpellLists.lsx** (referenced by ClassDescription):
```xml
<node id="SpellList">
    <attribute id="UUID" value="12345678-real-uuid-here"/>
    <children>
        <!-- Auto-granted base spells for ALL Warriors -->
        <node id="Spell"><attribute id="Level" value="1"/><attribute id="SpellId" value="WAR_Charge"/></node>
        <node id="Spell"><attribute id="Level" value="1"/><attribute id="SpellId" value="WAR_Taunt"/></node>
        <node id="Spell"><attribute id="Level" value="5"/><attribute id="SpellId" value="WAR_BattleShout"/></node>
    </children>
</node>
```

**Progressions.lsx** (adds talents on top of base spells):
```xml
<node id="Progression">
    <attribute id="Level" value="2"/>
    <!-- ClassDescription SpellList already granted L1 spells, now add choices -->
    <attribute id="Selectors" value="SelectPassives(TalentRowUUID,1,WarriorRow2)"/>
</node>

<node id="Progression">
    <attribute id="Level" value="3"/>
    <!-- Subclass-specific additional spells via Progressions -->
    <attribute id="Selectors" value="AddSpells(ArmsSubclassSpellListUUID);SelectPassives(TalentRowUUID,1,WarriorRow3)"/>
</node>
```

### Pros

- ✅ **Simpler than pure Progressions** - Fewer SpellList UUIDs (base spells in ClassDescription, only subclass differences in Progressions)
- ✅ **Still supports talent trees** - `SelectPassives()` for player choice
- ✅ **Clear separation** - Base spells (ClassDescription) vs. talents (Progressions)
- ✅ **Easier to debug** - Base spells in one place (ClassDescription SpellList)

### Cons

- ❌ **Less flexible than pure Progressions** - Base spells can't be conditional per subclass (all Warriors get same L1 spells)
- ❌ **Two sources of truth** - Must check ClassDescription SpellList AND Progressions for full spell list
- ❌ **Potential conflicts** - If ClassDescription grants a spell and Progressions tries to grant it again
- ❌ **Untested at scale** - No major mods use this pattern (unknown stability)
- ❌ **Harder to maintain** - Must synchronize ClassDescription SpellList with Progressions

### Used By

- ⚠️ Some smaller custom class mods (not widely documented)
- ⚠️ No major mods (< 1,000 downloads) confirmed to use this approach

### When to Use

✅ **Consider for**:
- Classes with many shared base spells (all subclasses get same L1-L5 spells)
- Mods with simpler talent trees (fewer than 5 talent rows)
- Prototyping/experimentation (easier to add base spells without Progressions XML)

❌ **Avoid for**:
- Production mods (untested at scale)
- Classes with subclass-specific baseline abilities (Arms/Fury/Protection get different L1 spells)
- Large-scale mods (50+ abilities) - Approach 2 is proven

---

## Approach 4: ScriptExtender Lua (Dynamic)

### How It Works

- Uses **BG3 Script Extender (SE)** to grant spells via Lua scripts
- Scripts run on level-up events and dynamically add spells to characters
- Most flexible but requires players to install Script Extender
- Can use ANY conditional logic (feats taken, multiclass, equipment, story flags, etc.)

### Example Structure

**ScriptExtender/Lua/BootstrapServer.lua**:
```lua
-- Register listener for level-up events
Ext.Osiris.RegisterListener("LeveledUp", 2, "after", function(character, level)
    local characterGuid = GetUUID(character)
    
    -- Check if character is a Warrior
    if HasClass(character, "Warrior") then
        -- Grant spells based on level
        if level == 1 then
            Osi.AddSpell(characterGuid, "WAR_Charge")
            Osi.AddSpell(characterGuid, "WAR_Whirlwind")
        elseif level == 3 then
            -- Check subclass
            if HasSubclass(character, "Arms") then
                Osi.AddSpell(characterGuid, "WAR_Execute")
                Osi.AddSpell(characterGuid, "WAR_Pummel")
            elseif HasSubclass(character, "Fury") then
                Osi.AddSpell(characterGuid, "WAR_Bloodthirst")
                Osi.AddSpell(characterGuid, "WAR_RagingBlow")
            end
        end
    end
end)
```

**ClassDescriptions.lsx** (minimal):
```xml
<node id="ClassDescription">
    <attribute id="Name" value="Warrior"/>
    <!-- No SpellList needed, Lua handles everything -->
    <attribute id="SpellList" value="00000000-0000-0000-0000-000000000000"/>
</node>
```

### Pros

- ✅ **Maximum flexibility** - ANY conditional logic (feats, multiclass, story flags, equipment, companion approval, etc.)
- ✅ **React to game events** - Level-up, subclass choice, long rest, combat start, etc.
- ✅ **Easy to patch/update** - Just edit Lua file, no XML regeneration
- ✅ **Dynamic calculations** - Can calculate spell damage based on stats, equipment, etc.
- ✅ **Cross-mod integration** - Can check for other mods and adjust behavior

### Cons

- ❌ **Requires Script Extender** - Not all players have SE installed (compatibility barrier)
- ❌ **Compatibility issues** - SE updates can break mods, BG3 patches may break SE
- ❌ **Performance concerns** - Lua scripts run every level-up (can lag on slower systems)
- ❌ **No UI integration** - Can't use vanilla talent picker UI (must grant spells silently or create custom UI)
- ❌ **Harder to validate** - No XML schema checking, runtime errors only
- ❌ **Debugging difficulty** - Must check SE logs, Lua errors, Osiris console
- ❌ **Less discoverable** - Players don't see talent choices in character sheet

### Used By

- ⚠️ **WoWDeathKnight** (uses SE for rune mechanics, not for all spell grants)
- ⚠️ **Advanced feature mods** (dynamic spell scaling, conditional effects)
- ⚠️ Few full-class mods rely entirely on SE for spell grants

### When to Use

✅ **Consider for**:
- Advanced features that can't be done in XML (dynamic scaling, story integration)
- Companion mods (conditional approval bonuses)
- Prototype/experimentation (faster iteration than XML)
- Optional enhancements to existing mod (SE as addon, not requirement)

❌ **Avoid for**:
- Primary spell grant system (use Approach 2 instead)
- Production mods targeting wide audience (SE = smaller player base)
- Mods without SE developer experience (steep learning curve)

---

## Comparison Table

| Feature | Direct SpellList | **Zero SpellList** ⭐ | Hybrid | ScriptExtender |
|---------|------------------|----------------------|--------|----------------|
| **Player Choice (Talents)** | ❌ No | ✅ **Yes** | ✅ Yes | ✅ Yes |
| **Subclass Differences** | ❌ Hard | ✅ **Easy** | ⚠️ Medium | ✅ Easy |
| **Complexity** | ✅ Simple | ⚠️ **Complex (58 UUIDs)** | ⚠️ Medium | ❌ Very Complex |
| **Proven at Scale** | ✅ Vanilla BG3 | ✅ **WoWWarlock (13K+)** | ❌ Untested | ⚠️ Few mods |
| **SE Dependency** | ✅ No | ✅ **No** | ✅ No | ❌ **Yes** |
| **Debugging** | ✅ Easy | ⚠️ **Medium** | ⚠️ Medium | ❌ Hard |
| **Player Base** | ✅ All BG3 players | ✅ **All BG3 players** | ✅ All | ❌ SE users only |
| **XML Boilerplate** | ✅ Minimal | ❌ **Verbose** | ⚠️ Medium | ✅ Minimal |
| **Maintenance** | ✅ Easy | ⚠️ **Moderate** | ⚠️ Moderate | ❌ Hard |
| **Dynamic Logic** | ❌ No | ❌ **No** | ❌ No | ✅ **Yes** |
| **Production Ready** | ✅ Yes | ✅ **Yes** | ⚠️ Unknown | ⚠️ Risky |

---

## Recommendations by Mod Type

### Simple Custom Class (No Talents)
**Use**: **Approach 1 (Direct SpellList)**
- Example: Artificer with fixed spell list
- Why: Simplest, no unnecessary complexity

### WoW-Style Class (Talent Trees)
**Use**: **Approach 2 (Zero SpellList)** ⭐ RECOMMENDED
- Example: Warrior (Arms/Fury/Protection), Warlock (Demo/Destro/Affl)
- Why: Proven at scale (13K+ downloads), supports full talent trees

### Class with Shared Base + Subclass Choices
**Use**: **Approach 3 (Hybrid)** (experimental)
- Example: Paladin (all specs get same Holy spells, different auras)
- Why: Simpler than pure Progressions for shared base spells
- **Warning**: Untested at scale, validate thoroughly

### Advanced Dynamic Features
**Use**: **Approach 4 (ScriptExtender)** (as addon to Approach 2)
- Example: Dynamic spell scaling based on equipment/story
- Why: Maximum flexibility
- **Warning**: SE dependency reduces player base

---

## Our Warrior Mod Choice

**We use Approach 2 (Zero SpellList)** for these reasons:

1. ✅ **Proven Template**: WoWWarlock mod (13K+ downloads) uses this pattern successfully
2. ✅ **Talent Trees**: We need `SelectPassives()` for 9 Class Talent rows + 8 SubclassSpec rows per subclass
3. ✅ **Subclass Differences**: Arms/Fury/Protection get different baseline abilities at L1-L12
4. ✅ **No SE Dependency**: Works without Script Extender (broader player base)
5. ✅ **BG3 Native**: Uses vanilla Progressions.lsx system (core game mechanic)
6. ✅ **Hero Talents**: Supports L13-20 hero talent auto-grants (PassivesAdded)

**Trade-off we accept**: More complex XML structure (58 UUIDs) in exchange for full talent tree support and proven stability.

---

## Evidence: WoWWarlock Mod Uses Approach 2

**Verification** (from actual WoWWarlock mod files):

**ClassDescriptions.lsx** (line 27):
```xml
<attribute id="SpellList" type="guid" value="32879c22-4858-48ef-8f8d-22e6d395b396"/>
```

**SpellLists.lsx**:
- ❌ UUID `32879c22-4858-48ef-8f8d-22e6d395b396` **DOES NOT EXIST** (ghost/dummy reference)

**Progressions.lsx** (line 13):
```xml
<attribute id="Selectors" type="LSString" value="AddSpells(9e2ec5ea-a47c-475a-b756-c0e0ca69a281)"/>
```

**SpellLists.lsx** (line 14):
```xml
<attribute id="UUID" type="guid" value="9e2ec5ea-a47c-475a-b756-c0e0ca69a281"/>
```
- ✅ This UUID **DOES EXIST** (referenced by Progressions, NOT ClassDescription)

**Conclusion**: WoWWarlock uses **Zero SpellList approach** (Approach 2).

---

## Related Documentation

- **Section [6.8] Progressions.lsx Implementation Notes** - Our Warrior mod's Zero SpellList implementation details
- **FILE_BY_FILE_TRANSFORMATION_PLAN.md** - Transformation strategy for FILES 11-13 (Progressions, SpellLists, PassiveLists)
- **HANDOVER_FILE_BY_FILE_START.md** - Current file transformation status

---

## Change Log

| Date | Change | Reason |
|------|--------|--------|
| October 21, 2025 | Initial creation | Document spell grant approaches after Section [6] work revealed Zero SpellList complexity |
| October 21, 2025 | Added WoWWarlock evidence | User requested verification of which approach Warlock mod uses |

---

**Last Updated**: October 21, 2025
