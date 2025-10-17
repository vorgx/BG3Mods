# Reference Mods Guide

**Purpose:** Study extracted BG3 mods to understand proper structure  
**Last Updated:** October 16, 2025

---

## 📦 Included Mods

### WoWPriest
**Folder:** `WoWPriest_f0d7e1dc-1a16-c068-9f62-684b81a1190c/`  
**ZIP:** `WoWPriest_f0d7e1dc-1a16-c068-9f62-684b81a1190c.zip`

**Purpose:** Single-class structure example  
**Format:** Patch 8 meta.lsx (`4.8.0.10`), Patch 7 data files (`4.7.1.3`)

**Key Features:**
- ✅ Single class (no subclasses)
- ✅ Holy Power resource (0-100 meter)
- ✅ Basic ActionResourceDefinitions structure
- ✅ Simple Progressions.lsx (Level 1-15+)
- ✅ Proficiency grants in Progressions Level 1

**What to Study:**
- `ActionResourceDefinitions/ActionResourceDefinitions.lsx` - Resource definition pattern
- `ClassDescriptions/ClassDescriptions.lsx` - Metadata-only class definition
- `Progressions/Progressions.lsx` - Basic progression table structure
- `Localization/English/English.loca.xml` - TranslatedString handles

**Analysis Document:** `../04_ResearchFindings/RESEARCH_FINDINGS_BG3_Structure.md`

---

### WoWDeathKnightClass
**Folder:** `WoWDeathKnightClass/`  
**ZIP:** `WoWDeathKnightClass.zip`

**Purpose:** Multi-subclass structure example  
**Format:** Patch 6 (`4.0.9.328`) - Outdated but structurally valid

**Key Features:**
- ✅ Base class + 3 subclasses (Blood/Frost/Unholy)
- ✅ 4 resources (RunicPower + BloodRune + FrostRune + UnholyRune)
- ✅ SubClasses node at Level 1 (CRITICAL FEATURE)
- ✅ Separate progression tables per subclass
- ✅ Resource scaling across levels (L7, L10, L12)

**What to Study:**
- `ClassDescriptions/ClassDescriptions.lsx` - ParentGuid usage for subclasses
- `Progressions/Progressions.lsx` - **SubClasses node structure** (most important)
- `ActionResourceDefinitions/` - Multiple resource definitions
- Progression Level 1 Boosts syntax

**Critical Learning:** SubClasses Node Structure
```xml
<node id="ProgressionDescription">
    <attribute id="Level" type="uint8" value="1"/>
    <attribute id="ProgressionType" type="uint8" value="0"/>
    <children>
        <node id="SubClasses">
            <children>
                <node id="SubClass">
                    <attribute id="Object" type="guid" value="[blood-uuid]"/>
                </node>
                <node id="SubClass">
                    <attribute id="Object" type="guid" value="[frost-uuid]"/>
                </node>
                <node id="SubClass">
                    <attribute id="Object" type="guid" value="[unholy-uuid]"/>
                </node>
            </children>
        </node>
    </children>
</node>
```

**Analysis Document:** `../04_ResearchFindings/RESEARCH_FINDINGS_DeathKnight.md`

---

### WoWDeathKnightFix
**Folder:** `WoWDeathKnightFix/`  
**ZIP:** `WoWDeathKnightFix.zip`

**Purpose:** Updated/fixed version of WoWDeathKnightClass  
**Format:** Similar to WoWDeathKnightClass

**Key Features:**
- Same structure as WoWDeathKnightClass
- Bug fixes and refinements
- Use as secondary reference if main DK mod has issues

**What to Study:**
- Compare with WoWDeathKnightClass to see what changed
- Use as validation of DK structure

---

## 📊 Comparison Matrix

| Feature | WoWPriest | WoWDeathKnight | Warrior (Our Mod) |
|---------|-----------|----------------|-------------------|
| **Base Class** | ✅ Priest | ✅ DeathKnight | ✅ Warrior |
| **Subclasses** | ❌ None | ✅ 3 specs | ✅ 3 specs (Arms/Fury/Prot) |
| **Resources** | ✅ Holy Power | ✅ 4 resources | ✅ Rage |
| **SubClasses Node** | ❌ N/A | ✅ Yes | ⏭️ To implement |
| **Patch Version** | 🟡 Mixed (8+7) | 🔴 Patch 6 | ✅ Patch 8 |
| **HP per Level** | d6 (6 HP/lvl) | d10 (7 HP/lvl) | d10 (10 HP/lvl) |
| **Primary Ability** | Wisdom (5) | Strength (1) | Strength (1) |

---

## 🎯 What Each Mod Teaches Us

### From WoWPriest (Simple → Complex)
1. **File Separation:**
   - ClassDescriptions = metadata only
   - ActionResourceDefinitions = resource definitions
   - Progressions = ALL grants

2. **Resource Pattern:**
   - MaxLevel=0 for meter resources (0-100)
   - ReplenishType controls regeneration
   - ShowOnActionResourcePanel=true for UI display

3. **Boosts Syntax:**
   ```
   ProficiencyBonus(SavingThrow,Wisdom);
   Proficiency(LightArmor);
   ActionResource(HolyPower,5,0)
   ```

### From WoWDeathKnight (Complex Patterns)
1. **Subclass Structure:**
   - Each subclass has ParentGuid pointing to base class
   - Each subclass has unique ProgressionTableUUID
   - SubClasses node creates character creation choice

2. **ProgressionType Values:**
   - 0 = Class progression (base class levels)
   - 1 = Subclass progression (spec-specific levels)

3. **Multiple Resources:**
   - Can have multiple ActionResourceDefinitions
   - Each resource has unique Name and UUID
   - Resources can scale at different levels

---

## 🔍 How to Use These Mods

### When Generating Progressions.lsx
1. **Open:** `WoWDeathKnightClass/Public/WoWDeathKnightClass/Progressions/Progressions.lsx`
2. **Find:** Level 1 progression with SubClasses node
3. **Copy Pattern:** Use exact node structure for SubClasses
4. **Adapt:** Replace UUIDs with our Warrior subclass UUIDs

### When Stuck on Resource Definition
1. **Open:** `WoWPriest/Public/.../ActionResourceDefinitions/ActionResourceDefinitions.lsx`
2. **Compare:** With our `Rage` resource definition
3. **Verify:** Attributes match expected pattern

### When Validating ClassDescriptions
1. **Open:** Both reference mods' ClassDescriptions files
2. **Check:** Our file matches metadata-only pattern
3. **Verify:** ParentGuid usage matches DeathKnight pattern

---

## ⚠️ Important Notes

### Version Compatibility
- **WoWPriest:** Patch 7 data files may have minor differences from Patch 8
- **WoWDeathKnight:** Patch 6 format is OLD - structure is valid, version tags are not
- **Our Approach:** Use Patch 8 version tags (`4.8.0.10`) with reference patterns

### What NOT to Copy Directly
- ❌ Version tags (use `4.8.0.10` instead)
- ❌ UUIDs (must be unique per mod)
- ❌ Class-specific values (HP, abilities, etc.)
- ❌ Localization handles (must be unique)

### What IS Safe to Copy
- ✅ Node structure (SubClasses, ProgressionDescription, etc.)
- ✅ Attribute names and types
- ✅ Boosts syntax patterns
- ✅ File organization structure

---

## 📝 Extraction Commands

If you need to re-extract these mods:

### Using LSLib ConverterApp
```powershell
# Extract .pak file
ConverterApp.exe --source "path\to\mod.pak" --destination "path\to\output" --action "extract-package"

# Convert LSF to LSX (for readability)
ConverterApp.exe --source "file.lsf" --destination "file.lsx" --action "convert-lsf-lsx"
```

### Using BG3 Multitool
1. Open BG3 Multitool
2. Go to "Pak File Manager"
3. Load .pak file
4. Extract to folder

---

## 🔗 Related Documentation

- **Research Analysis:** `../04_ResearchFindings/`
  - RESEARCH_FINDINGS_BG3_Structure.md (WoWPriest deep dive)
  - RESEARCH_FINDINGS_DeathKnight.md (WoWDeathKnight + comparison)

- **Validation Reports:** `../05_ValidationReports/`
  - Shows how our files compare to reference patterns

- **Design Docs:** `../02_DesignDocuments/`
  - Warrior_Class_Blueprint.json uses patterns learned from these mods

---

**Last Updated:** October 16, 2025  
**Status:** Reference mods cataloged and analyzed  
**Next Use:** Progressions.lsx SubClasses node implementation
