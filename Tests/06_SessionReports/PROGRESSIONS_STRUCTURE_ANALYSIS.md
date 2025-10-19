# 🔍 PROGRESSIONS STRUCTURE ANALYSIS - Critical Differences

**Date**: 2025-10-18  
**Status**: ⚠️ **POTENTIAL ISSUE IDENTIFIED**

---

## 🎯 Key Discovery: AddSpells Location

### **Working Mods Structure**

Both Warlock and DeathKnight put **AddSpells INSIDE the Selectors attribute**:

#### **Warlock Level 1**:
```xml
<node id="Progression">
    <attribute id="Boosts" type="LSString" value="..."/>
    <attribute id="Level" type="uint8" value="1"/>
    <attribute id="Name" type="LSString" value="WoWWarlock"/>
    <attribute id="PassivesAdded" type="LSString" value="..."/>
    <attribute id="ProgressionType" type="uint8" value="0"/>
    <attribute id="Selectors" type="LSString" value="SelectSkills(UUID,2);SelectAbilityBonus(UUID,AbilityBonus,2,1);AddSpells(UUID)"/>
    <attribute id="TableUUID" type="guid" value="..."/>
    <attribute id="UUID" type="guid" value="..."/>
    <children>
        <node id="SubClasses">...</node>
    </children>
</node>
```

**Key**: `AddSpells(UUID)` is **INSIDE the Selectors attribute** as a semicolon-separated value.

#### **Warlock Level 2**:
```xml
<node id="Progression">
    <attribute id="Level" type="uint8" value="2"/>
    <attribute id="Name" type="LSString" value="WoWWarlock"/>
    <attribute id="PassivesAdded" type="LSString" value="..."/>
    <attribute id="ProgressionType" type="uint8" value="0"/>
    <attribute id="Selectors" type="LSString" value="AddSpells(UUID);SelectPassives(UUID,1,tag)"/>
    <attribute id="TableUUID" type="guid" value="..."/>
    <attribute id="UUID" type="guid" value="..."/>
</node>
```

**Again**: AddSpells is **inside Selectors**, not a separate attribute or child node.

#### **DeathKnight Level 1**:
```xml
<node id="Progression">
    <attribute id="Boosts" type="LSString" value="..."/>
    <attribute id="Level" type="uint8" value="1"/>
    <attribute id="Name" type="LSString" value="WoWDeathKnight"/>
    <attribute id="PassivesAdded" type="LSString" value="..."/>
    <attribute id="ProgressionType" type="uint8" value="0"/>
    <attribute id="Selectors" type="LSString" value="SelectSkills(UUID,2);SelectAbilityBonus(UUID,AbilityBonus,2,1);AddSpells(UUID,,,,AlwaysPrepared)"/>
    <attribute id="TableUUID" type="guid" value="..."/>
    <attribute id="UUID" type="guid" value="..."/>
    <children>
        <node id="SubClasses">...</node>
    </children>
</node>
```

**Same pattern**: `AddSpells(UUID,,,,AlwaysPrepared)` is **inside Selectors attribute**.

---

## ❌ Our Warrior Mod Structure (WRONG?)

### **Our Level 1**:
```xml
<node id="Progression">
    <attribute id="Boosts" type="LSString" value="..."/>
    <attribute id="Level" type="uint8" value="1"/>
    <attribute id="Name" type="LSString" value="Warrior"/>
    <attribute id="PassivesAdded" type="LSString" value="..."/>
    <attribute id="ProgressionType" type="uint8" value="0"/>
    <attribute id="TableUUID" type="guid" value="..."/>
    <attribute id="UUID" type="guid" value="..."/>
    <children>
        <node id="SubClasses">...</node>
        <attribute id="Selectors" type="LSString" value="SelectSkills(UUID,2);SelectAbilityBonus(UUID,AbilityBonus,2,1)"/>
        <attribute id="AddSpells" type="LSString" value="WAR_Charge;WAR_HeroicStrike"/>
    </children>
</node>
```

**PROBLEMS**:
1. ❌ `Selectors` attribute is **INSIDE `<children>` node** (should be direct child of Progression)
2. ❌ `AddSpells` is a **SEPARATE attribute** (should be inside Selectors string)
3. ❌ Using direct spell names instead of SpellList UUID

### **Our Level 2**:
```xml
<node id="Progression">
    <attribute id="Level" type="uint8" value="2"/>
    <attribute id="Name" type="LSString" value="Warrior"/>
    <attribute id="ProgressionType" type="uint8" value="0"/>
    <attribute id="TableUUID" type="guid" value="..."/>
    <attribute id="UUID" type="guid" value="..."/>
    <children>
        <attribute id="AddSpells" type="LSString" value="WAR_BattleShout"/>
    </children>
</node>
```

**PROBLEM**: `AddSpells` is inside `<children>` node, not as direct attribute of Progression.

---

## ✅ CORRECT Structure (What We Should Have)

### **Level 1 (Character Creation)**:
```xml
<node id="Progression">
    <attribute id="Boosts" type="LSString" value="..."/>
    <attribute id="Level" type="uint8" value="1"/>
    <attribute id="Name" type="LSString" value="Warrior"/>
    <attribute id="PassivesAdded" type="LSString" value="..."/>
    <attribute id="ProgressionType" type="uint8" value="0"/>
    <attribute id="Selectors" type="LSString" value="SelectSkills(f974ebd6-3725-4b90-bb5c-2b647d41615d,2);SelectAbilityBonus(b9149c8e-52c8-46e5-9cb6-fc39301c05fe,AbilityBonus,2,1);AddSpells(a1b2c3d4-5e6f-7a8b-9c0d-1e2f3a4b5c6d)"/>
    <attribute id="TableUUID" type="guid" value="..."/>
    <attribute id="UUID" type="guid" value="..."/>
    <children>
        <node id="SubClasses">...</node>
    </children>
</node>
```

**Changes**:
- ✅ `Selectors` is **direct attribute** of Progression node
- ✅ `AddSpells(UUID)` is **inside Selectors string**, pointing to SpellLists.lsx
- ✅ No separate `<attribute id="AddSpells">`

### **Level 2+ (Simple Spell Grants)**:
```xml
<node id="Progression">
    <attribute id="Level" type="uint8" value="2"/>
    <attribute id="Name" type="LSString" value="Warrior"/>
    <attribute id="ProgressionType" type="uint8" value="0"/>
    <attribute id="Selectors" type="LSString" value="AddSpells(UUID-of-level-2-spells)"/>
    <attribute id="TableUUID" type="guid" value="..."/>
    <attribute id="UUID" type="guid" value="..."/>
</node>
```

**OR** (if using direct spell names - need to verify if this works):
```xml
<node id="Progression">
    <attribute id="Level" type="uint8" value="2"/>
    <attribute id="Name" type="LSString" value="Warrior"/>
    <attribute id="AddSpells" type="LSString" value="WAR_BattleShout"/>
    <attribute id="ProgressionType" type="uint8" value="0"/>
    <attribute id="TableUUID" type="guid" value="..."/>
    <attribute id="UUID" type="guid" value="..."/>
</node>
```

**BUT**: `AddSpells` must be **direct attribute**, NOT inside `<children>`.

---

## 🔍 Two Valid Approaches

### **Approach A: Use SpellLists UUIDs** (Warlock/DeathKnight method)

1. Create SpellLists.lsx with entries for each level:
```xml
<node id="SpellList">
    <attribute id="Comment" type="LSString" value="Level 1 spells"/>
    <attribute id="Spells" type="LSString" value="WAR_Charge;WAR_HeroicStrike"/>
    <attribute id="UUID" type="guid" value="uuid1"/>
</node>
<node id="SpellList">
    <attribute id="Comment" type="LSString" value="Level 2 spells"/>
    <attribute id="Spells" type="LSString" value="WAR_BattleShout"/>
    <attribute id="UUID" type="guid" value="uuid2"/>
</node>
```

2. Reference in Progressions.lsx Selectors:
```xml
<attribute id="Selectors" type="LSString" value="AddSpells(uuid1)"/>
<attribute id="Selectors" type="LSString" value="AddSpells(uuid2)"/>
```

### **Approach B: Direct Spell Names** (Simpler, but needs verification)

Use `AddSpells` as **direct attribute** (not in children):
```xml
<node id="Progression">
    <attribute id="Level" type="uint8" value="2"/>
    <attribute id="AddSpells" type="LSString" value="WAR_BattleShout"/>
    ...
</node>
```

**Critical**: `AddSpells` must be **sibling to Level/Name**, NOT child of `<children>`.

---

## 🚨 CRITICAL FIX NEEDED

**Our current structure has TWO major errors**:

### **Error 1: Selectors Inside Children**
```xml
<!-- WRONG -->
<children>
    <attribute id="Selectors" type="LSString" value="..."/>
</children>

<!-- CORRECT -->
<attribute id="Selectors" type="LSString" value="..."/>
<children>
    <node id="SubClasses">...</node>
</children>
```

### **Error 2: AddSpells Inside Children**
```xml
<!-- WRONG -->
<children>
    <attribute id="AddSpells" type="LSString" value="..."/>
</children>

<!-- CORRECT (Option A: Direct attribute) -->
<attribute id="AddSpells" type="LSString" value="..."/>

<!-- CORRECT (Option B: Inside Selectors) -->
<attribute id="Selectors" type="LSString" value="AddSpells(UUID)"/>
```

---

## 🎯 Recommended Fix

**WAIT for test results first!** 

If the test fails with the Lists fix, we need to:

1. **Move all `Selectors` attributes out of `<children>` blocks**
2. **Move all `AddSpells` attributes out of `<children>` blocks**
3. **Either**:
   - Keep direct spell names as separate `AddSpells` attributes (simpler)
   - OR convert to SpellList UUIDs inside Selectors (more consistent with working mods)

---

## 📝 Testing Priority

1. **Test current build first** (with Lists fix)
2. **If it crashes**, fix the Selectors/AddSpells location issue
3. **Then decide**: Direct spell names vs SpellList UUIDs

---

**Status**: Documentation ready for next fix iteration if needed.
