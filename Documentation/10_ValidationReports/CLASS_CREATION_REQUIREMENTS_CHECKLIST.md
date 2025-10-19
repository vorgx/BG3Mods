# BG3 Class Creation Requirements Checklist

**Source**: https://wiki.bg3.community/Tutorials/Classes/Basic-Class-Creation  
**Purpose**: Validation checklist based on official BG3 class creation tutorial  
**Created**: October 18, 2025  
**Status**: ⚠️ **SCAN THIS BEFORE ANY CLASS-RELATED CHANGES**

---

## ⚠️ **CRITICAL: AI Agent Protocol**

**BEFORE making ANY changes to class files:**
1. ✅ Read this checklist FIRST
2. ✅ Verify ALL required files exist
3. ✅ Check file structure matches official guide
4. ✅ Validate file contents against requirements below

---

## 📁 **Required Folder Structure**

Based on official tutorial, the minimum folder structure is:

### **🔑 CRITICAL DEPENDENCY ORDER (from official guide):**

**Phase 1: Basic Class (INDEPENDENT - No dependencies)**
1. meta.lsx
2. ClassDescriptions.lsx
3. Progressions.lsx (basic, without Selectors)
4. AbilityDistributionPresets.lsx ✅ **INDEPENDENT - Only needs ClassUUID**

**Phase 2: Skills/Abilities (REQUIRES Lists + DefaultValues)**
5. Lists/AbilityLists.lsx (only if using SelectAbilityBonus selector)
6. Lists/SkillLists.lsx (only if using SelectSkills selector)
7. DefaultValues/Abilities.lsx (only if using SelectAbilityBonus selector)
8. DefaultValues/Skills.lsx (only if using SelectSkills selector)
9. Progressions.lsx UPDATE: Add Selectors attribute referencing Lists UUIDs

---

```
Data/
├── Mods/
│   └── BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7/
│       └── meta.lsx                           ✅ EXISTS (Phase 1)
│
└── Public/
    └── BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7/
        ├── ClassDescriptions/
        │   └── ClassDescriptions.lsx          ✅ EXISTS (Phase 1)
        │
        ├── Progressions/
        │   ├── Progressions.lsx               ✅ EXISTS (Phase 1 + Phase 2 updates)
        │   └── ProgressionDescriptions.lsx    ✅ EXISTS (Optional but recommended)
        │
        ├── CharacterCreationPresets/
        │   └── AbilityDistributionPresets.lsx ✅ FIXED (Phase 1 - INDEPENDENT)
        │
        ├── DefaultValues/                     ❌ MISSING (Phase 2 - only needed if using Selectors)
        │   ├── Abilities.lsx                  ❌ MISSING (only if SelectAbilityBonus)
        │   └── Skills.lsx                     ❌ MISSING (only if SelectSkills)
        │
        ├── Lists/                             ❌ MISSING (Phase 2 - only needed if using Selectors)
        │   ├── AbilityLists.lsx               ❌ MISSING (only if SelectAbilityBonus)
        │   └── SkillLists.lsx                 ❌ MISSING (only if SelectSkills)
        │
        ├── Stats/
        │   └── Generated/
        │       └── Data/
        │           ├── Spell_*.txt            ✅ EXISTS (multiple)
        │           ├── Status_BOOST.txt       ✅ EXISTS
        │           └── Passive.txt            ✅ EXISTS
        │
        └── ActionResourceDefinitions/
            └── ActionResourceDefinitions.lsx  ✅ EXISTS
```

---

## 📋 **File-by-File Requirements**

### 1️⃣ **meta.lsx** (Mods folder)
- [x] **EXISTS**: `Data/Mods/BG3Wow_.../meta.lsx`
- [x] **Type="Add-on"**: REQUIRED attribute (added in v1.0.0.3)
- [x] **UUID matches folder name**: `78fe4967-4e62-5491-d981-dd781acca4d7`
- [x] **Author and Description**: Metadata populated

---

### 2️⃣ **ClassDescriptions.lsx** (REQUIRED)
**Location**: `Public/.../ClassDescriptions/ClassDescriptions.lsx`

#### **Required Attributes (per class/subclass):**
- [x] **BaseHp** - Starting HP (10 for Warrior)
- [x] **CharacterCreationPose** - UUID for CC pose
- [x] **ClassEquipment** - Links to Equipment.txt entry (e.g., "EQP_CC_Barbarian")
- [x] **Description** - TranslatedString handle (GUID format with 'g' separators)
- [x] **DisplayName** - TranslatedString handle (GUID format with 'g' separators)
- [x] **HpPerLevel** - HP gained per level (10 for Warrior)
- [x] **LearningStrategy** - Always 1
- [x] **Name** - FixedString (e.g., "WoWWarrior")
- [x] **PrimaryAbility** - 1=DEX, 2=STR, 3=CON, 4=INT, 5=WIS, 6=CHA
- [x] **ProgressionTableUUID** - Links to Progressions.lsx TableUUID
- [x] **SoundClassType** - FixedString (e.g., "Barbarian")
- [x] **SpellCastingAbility** - Same format as PrimaryAbility (0=none)
- [x] **UUID** - Unique class UUID (base class uses mod UUID)
- [x] **Tags** - Child node with class tag UUID

#### **Subclass Requirements:**
- [x] **ParentGuid** - UUID of parent class (REQUIRED for subclasses)
- [x] **ShortName** - TranslatedString handle (optional but recommended)

---

### 3️⃣ **Progressions.lsx** (REQUIRED)
**Location**: `Public/.../Progressions/Progressions.lsx`

#### **Required Attributes (Level 1 minimum):**
- [x] **Level** - 1 for character creation
- [x] **Name** - Class name (e.g., "WoWWarrior")
- [x] **ProgressionType** - 0=Class, 1=Subclass, 2=Race
- [x] **TableUUID** - Matches ProgressionTableUUID from ClassDescriptions
- [x] **UUID** - Unique progression UUID
- [x] **Boosts** - Proficiencies, resources (e.g., "Proficiency(HeavyArmor);ActionResource(Rage,100,0)")
- [x] **PassivesAdded** - Passive abilities granted at this level
- [x] **Selectors** - SelectSkills(), SelectAbilityBonus(), SelectSpells(), etc.

#### **Subclass Linking:**
- [x] **SubClasses child node** - Contains SubClass nodes with subclass UUIDs (at level where subclass is chosen)

---

### 4️⃣ **ProgressionDescriptions.lsx** (REQUIRED)
**Location**: `Public/.../Progressions/ProgressionDescriptions.lsx`

#### **Required Attributes:**
- [x] **Description** - TranslatedString handle (SAME as ClassDescriptions)
- [x] **DisplayName** - TranslatedString handle (SAME as ClassDescriptions)
- [x] **ProgressionTableId** - Matches ProgressionTableUUID from ClassDescriptions
- [x] **Type** - FixedString matching class Name (e.g., "WoWWarrior")
- [x] **UUID** - Unique UUID (only used in this file)

**⚠️ CRITICAL**: Handles MUST match ClassDescriptions.lsx exactly!

---

### 5️⃣ **AbilityDistributionPresets.lsx** (REQUIRED FOR CC)
**Location**: `Public/.../CharacterCreationPresets/AbilityDistributionPresets.lsx`

#### **Required Attributes:**
- [x] **Charisma** - Starting value (8-15)
- [x] **ClassUUID** - Matches class UUID from ClassDescriptions
- [x] **Constitution** - Starting value (8-15)
- [x] **Dexterity** - Starting value (8-15)
- [x] **Intelligence** - Starting value (8-15)
- [x] **Strength** - Starting value (8-15)
- [x] **UUID** - Unique preset UUID
- [x] **Wisdom** - Starting value (8-15)

**⚠️ CRITICAL**: One preset per class/subclass! ClassUUID must match exactly.

---

### 6️⃣ **DefaultValues/Abilities.lsx** (REQUIRED FOR CC BONUS POINTS)
**Location**: `Public/.../DefaultValues/Abilities.lsx`

#### **Status**: ❌ **MISSING - BLOCKING CLASS VISIBILITY**

#### **Required Attributes:**
- [ ] **Add** - Default selected abilities (e.g., "Charisma;Intelligence")
- [ ] **Level** - 1 for character creation
- [ ] **TableUUID** - Matches ProgressionTableUUID
- [ ] **UUID** - Unique default UUID

**Purpose**: Sets DEFAULT selected bonus ability points (+2/+1) in CC

---

### 7️⃣ **DefaultValues/Skills.lsx** (REQUIRED FOR CC SKILLS)
**Location**: `Public/.../DefaultValues/Skills.lsx`

#### **Status**: ❌ **MISSING - BLOCKING CLASS VISIBILITY**

#### **Required Attributes:**
- [ ] **Add** - Default selected skills (e.g., "Athletics;Acrobatics")
- [ ] **Level** - 1 for character creation
- [ ] **TableUUID** - Matches ProgressionTableUUID
- [ ] **UUID** - Unique default UUID

**Purpose**: Sets DEFAULT selected skills in CC

---

### 8️⃣ **Lists/AbilityLists.lsx** (REQUIRED FOR CC)
**Location**: `Public/.../Lists/AbilityLists.lsx`

#### **Status**: ❌ **MISSING - BLOCKING CLASS VISIBILITY**

#### **Required Attributes:**
- [ ] **Abilities** - Comma-separated list: "Strength, Dexterity, Constitution, Intelligence, Wisdom, Charisma"
- [ ] **UUID** - Unique list UUID

**Purpose**: Defines which abilities CAN be selected for bonus points

**⚠️ Link to Progressions**: UUID must be referenced in `Selectors` attribute:
```
Selectors="SelectAbilityBonus(UUID_HERE,AbilityBonus,2,1)"
```

---

### 9️⃣ **Lists/SkillLists.lsx** (REQUIRED FOR CC)
**Location**: `Public/.../Lists/SkillLists.lsx`

#### **Status**: ❌ **MISSING - BLOCKING CLASS VISIBILITY**

#### **Required Attributes:**
- [ ] **Skills** - Comma-separated list of class skills (e.g., "Athletics, Acrobatics, Arcana, SleightOfHand, Perception")
- [ ] **UUID** - Unique list UUID

**Purpose**: Defines which skills are AVAILABLE for selection

**⚠️ Link to Progressions**: UUID must be referenced in `Selectors` attribute:
```
Selectors="SelectSkills(UUID_HERE,2)"
```

---

### 🔟 **ActionResourceDefinitions.lsx** (REQUIRED FOR CUSTOM RESOURCES)
**Location**: `Public/.../ActionResourceDefinitions/ActionResourceDefinitions.lsx`

#### **Status**: ✅ EXISTS (Rage resource defined)

#### **Required Attributes:**
- [x] **Description** - TranslatedString handle
- [x] **DisplayName** - TranslatedString handle
- [x] **MaxLevel** - 0 for no level scaling
- [x] **Name** - FixedString (e.g., "Rage")
- [x] **ReplenishType** - "ShortRest", "LongRest", "Rest", etc.
- [x] **IsSpellResource** - true/false
- [x] **ShowOnActionResourcePanel** - true/false
- [x] **UUID** - Unique resource UUID

**⚠️ Link to Progressions**: Reference in Boosts:
```
Boosts="ActionResource(Rage,100,0)"
```

---

## 🚨 **BLOCKING ISSUES - Why Class Not Visible**

Based on official guide, class visibility in CC requires:

### **CRITICAL MISSING FILES:**
1. ❌ **DefaultValues/Abilities.lsx** - CC expects ability defaults
2. ❌ **DefaultValues/Skills.lsx** - CC expects skill defaults
3. ❌ **Lists/AbilityLists.lsx** - CC needs ability selection options
4. ❌ **Lists/SkillLists.lsx** - CC needs skill selection options

### **Evidence from Guide:**
> "While we have a working character at this point, it is definitely lacking a lot of common options on character creation. You will see that there is no way to spec bonus ability points and that you don't have any skills or proficiencies for the class"

**Without these files, the game may not recognize the class as valid for CC!**

---

## 📝 **Linking Requirements**

### **Progressions.lsx Selectors** (Level 1)
Must reference List UUIDs:

```xml
<attribute id="Selectors" type="LSString" value="SelectSkills(SKILLIST_UUID,2);SelectAbilityBonus(ABILITYLIST_UUID,AbilityBonus,2,1)"/>
```

### **File Dependency Chain:**
```
ClassDescriptions.lsx (UUID + ProgressionTableUUID)
    ↓
Progressions.lsx (TableUUID matches, Selectors reference Lists)
    ↓
ProgressionDescriptions.lsx (ProgressionTableId matches, handles match ClassDescriptions)
    ↓
AbilityDistributionPresets.lsx (ClassUUID matches ClassDescriptions UUID)
    ↓
Lists/*.lsx (UUIDs referenced in Progressions Selectors)
    ↓
DefaultValues/*.lsx (TableUUID matches Progressions, sets defaults)
```

---

## ✅ **Validation Steps**

Before packaging, verify:

1. **File Existence**:
   - [ ] All 9 required files exist
   - [ ] Folder structure matches official guide

2. **UUID Consistency**:
   - [ ] ClassDescriptions UUID = AbilityDistributionPresets ClassUUID
   - [ ] ClassDescriptions ProgressionTableUUID = Progressions TableUUID
   - [ ] Progressions TableUUID = ProgressionDescriptions ProgressionTableId
   - [ ] Progressions TableUUID = DefaultValues TableUUID

3. **Handle Consistency**:
   - [ ] ProgressionDescriptions handles EXACTLY match ClassDescriptions
   - [ ] All handles use GUID format (8-4-4-4-12 with 'g' separators)

4. **Selector Linking**:
   - [ ] Progressions Selectors reference correct List UUIDs
   - [ ] All List UUIDs exist in Lists/*.lsx files

5. **Subclass Configuration**:
   - [ ] Subclasses have ParentGuid attribute
   - [ ] Subclasses have separate ProgressionTableUUIDs
   - [ ] Subclasses have separate AbilityDistributionPresets

---

## 🎯 **Next Actions**

To make Warrior class visible in CC:

1. **Create DefaultValues/Abilities.lsx**:
   - Default bonus points: STR +2, CON +1 (or user choice)
   - TableUUID = `a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d`

2. **Create DefaultValues/Skills.lsx**:
   - Default skills: Athletics, Intimidation (or appropriate warrior skills)
   - TableUUID = `a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d`

3. **Create Lists/AbilityLists.lsx**:
   - All abilities available: "Strength, Dexterity, Constitution, Intelligence, Wisdom, Charisma"
   - Generate new UUID

4. **Create Lists/SkillLists.lsx**:
   - Warrior skills: "Athletics, Intimidation, Acrobatics, AnimalHandling, Perception, Survival" (example)
   - Generate new UUID

5. **Update Progressions.lsx Selectors**:
   - Add SelectSkills() with SkillLists UUID
   - Add SelectAbilityBonus() with AbilityLists UUID

6. **Package and test**

---

## 📚 **Reference**

- **Official Guide**: https://wiki.bg3.community/Tutorials/Classes/Basic-Class-Creation
- **Our Implementation**: See files in `Data/Public/BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7/`
- **Working Example**: Tests/ExampleMod_WoWWarlock/ (has all required files)

---

**Last Validated**: October 18, 2025  
**Status**: 5/9 required files present - **INCOMPLETE**
