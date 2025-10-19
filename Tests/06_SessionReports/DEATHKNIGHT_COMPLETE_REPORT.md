# ⚔️ WoWDeathKnight Mod - Complete Reverse Engineering Report

**Date**: 2025-10-18  
**Mod UUID**: `WoWDeathKnightClass`  
**Status**: ✅ **WORKING** - Successfully loads in BG3

---

## 📂 File Structure

### Core Files (33 LSX files total)

```
Public/WoWDeathKnightClass/
├── ActionResourceDefinitions/
│   └── ActionResourceDefinitions.lsx (Runic Power, Runes)
├── ActionResourceGroupDefinitions/
│   └── ActionResourceGroupDefinitions.lsx (Rune groups)
├── ClassDescriptions/
│   └── ClassDescriptions.lsx (Base + 3 subclasses)
├── DefaultValues/
│   ├── Skills.lsx ✅ (Lists all available skills)
│   ├── Abilities.lsx ✅
│   └── Spells.lsx ✅
├── GUI/
│   ├── ActionResources.lsx
│   └── (additional GUI files)
├── Lists/
│   ├── PassiveLists.lsx ✅ (1 entry - minimal)
│   ├── SkillLists.lsx ✅
│   └── SpellLists.lsx ✅ (18 entries)
├── Progressions/
│   ├── ProgressionDescriptions.lsx
│   └── Progressions.lsx (706 lines)
├── RootTemplates/
│   └── (visual effect templates)
├── TooltipExtras/
│   └── (tooltip definitions)
└── Stats/Generated/Data/
    └── 12 stat files (129 KB total)
```

**Key Difference**: Has **DefaultValues folder** instead of AbilityLists.lsx

---

## 🎯 Key Architecture Patterns

### 1. **Simple Progression System**

DeathKnight uses minimal talents:
- **1 PassiveList** (minimal talent system)
- **18 SpellLists** (spell pools)
- **Only 1 SelectPassives per subclass at L2**

### 2. **Selector Format (CORRECT)**

```xml
<attribute id="Selectors" type="LSString" value="SelectSkills(UUID,2);SelectAbilityBonus(UUID,AbilityBonus,2,1);AddSpells(UUID,,,,AlwaysPrepared)"/>
```

**Notable**: Uses `AlwaysPrepared` flag for spells.

### 3. **DefaultValues Folder**

**Skills.lsx structure**:
```xml
<node id="DefaultValue">
    <attribute id="Add" type="LSString" value="Athletics;Acrobatics;Arcana;History;Investigation;Perception;Insight;Intimidation;Survival"/>
    <attribute id="Level" type="int32" value="1"/>
    <attribute id="TableUUID" type="guid" value="4a0e24b1-5866-4ae1-9815-aa9a3db1c1bb"/>
    <attribute id="UUID" type="guid" value="a50296f2-09b3-44db-9798-44f721aebb98"/>
</node>
```

**Purpose**: Lists all available skills for SelectSkills. TableUUID matches base class progression UUID.

### 4. **Sparse Progression**

Many levels have **empty progressions** (no spells/abilities):
- L2, L4, L8, L11, L12: Empty (only ASI)
- Subclasses more active than base class

---

## 📊 Level-by-Level Progression (Base Class)

### **Level 1** - Character Creation
```xml
Boosts:
  - ProficiencyBonus(SavingThrow,Wisdom)
  - ProficiencyBonus(SavingThrow,Charisma)
  - Proficiency(LightArmor/MediumArmor/HeavyArmor)
  - Proficiency(SimpleWeapons/MartialWeapons)
  - ActionResource(RunicPower,100,0)
  - ActionResource(UnholyRune,1,0)
  - ActionResource(FrostRune,1,0)
  - ActionResource(BloodRune,1,0)

PassivesAdded:
  - DK_UnlockRunicPower
  - DK_UnlockUnholyRune
  - DK_UnlockFrostRune
  - DK_UnlockBloodRune

Selectors:
  - SelectSkills(ebba66c9-ad8a-4593-a8a9-72ddb7f89d6f, 2)
  - SelectAbilityBonus(b9149c8e-52c8-46e5-9cb6-fc39301c05fe, AbilityBonus, 2, 1)
  - AddSpells(bc76bcd5-b481-4cc8-8c04-4de370e9e2cf,,,,AlwaysPrepared)

SubClasses: 3 subclass UUIDs (Blood, Frost, Unholy)
```

### **Level 1 Multiclass**
```xml
IsMulticlass: true
Same boosts/passives as L1
Selectors: Only AddSpells (no skills/ability scores)
```

### **Level 2** - Empty
```xml
Boosts: (empty)
PassivesAdded: (empty)
Selectors: (empty)
```
**Note**: Subclasses have SelectPassives at L2

### **Level 3** - Scourge Harbinger
```xml
PassivesAdded: ScourgeHarbinger

Selectors:
  - AddSpells(b562c1d8-1f1e-4f05-ae0b-4b6ac0698d6a,,,,AlwaysPrepared)
```

### **Level 4** - ASI Only
```xml
AllowImprovement: true (ASI/Feat choice)
(No spells or abilities)
```

### **Level 5** - Extra Attack
```xml
PassivesAdded: ExtraAttack
(No spells added)
```

### **Level 6** - Anti-Magic Shell
```xml
PassivesAdded: AntiMagicShell_Passive

Selectors:
  - AddSpells(601f92e8-a9ab-433c-b744-682e04208d11,,,,AlwaysPrepared)
```

### **Level 7** - Runic Power Increase
```xml
Boosts: ActionResource(RunicPower,20,0) → +20 max RP
PassivesAdded: DK_UnlockRunicPower_2
```

### **Level 8** - ASI Only
```xml
AllowImprovement: true
(No spells or abilities)
```

### **Level 9** - New Ability
```xml
Selectors:
  - AddSpells(2c3c622f-74e9-41c0-a032-d28f66c7cd17,,,,AlwaysPrepared)
```

### **Level 10** - Additional Runes
```xml
Boosts:
  - ActionResource(UnholyRune,1,0) → +1 rune
  - ActionResource(FrostRune,1,0) → +1 rune
  - ActionResource(BloodRune,1,0) → +1 rune

PassivesAdded:
  - DK_UnlockUnholyRune
  - DK_UnlockFrostRune
  - DK_UnlockBloodRune
```

### **Level 11-12** - Empty/ASI
```xml
L11: Empty progression
L12: AllowImprovement (ASI)
```

---

## 🔑 Critical Requirements

### **1. Three Lists Files + DefaultValues**
- ❌ No AbilityLists.lsx
- ✅ PassiveLists.lsx (1 entry - minimal)
- ✅ SkillLists.lsx
- ✅ SpellLists.lsx (18 entries)
- ✅ **DefaultValues/** folder (Skills, Abilities, Spells)

### **2. Selector Format**
```xml
<!-- CORRECT (LSString with AlwaysPrepared flag) -->
<attribute id="Selectors" type="LSString" value="AddSpells(UUID,,,,AlwaysPrepared)"/>
```

### **3. DefaultValues Structure**
Lists all available options for character creation:
- **Skills.lsx**: All skill options
- **Abilities.lsx**: Ability score options (if needed)
- **Spells.lsx**: Starting spell options (if needed)

### **4. ActionResourceGroupDefinitions**
Defines rune groups (Blood, Frost, Unholy) - not present in Warlock mod.

---

## 📦 Stats Files (12 files, 129 KB)

```
Passive.txt
Spell_Projectile.txt
Spell_Shout.txt
Spell_Target.txt
Spell_Zone.txt
Status_BOOST.txt
(additional stat files)
```

---

## 🎨 Additional Features

### **Visual Effects**
- RootTemplates/ folder with visual effect definitions
- More extensive GUI integration

### **Tooltip Extras**
- TooltipExtras/ folder for enhanced descriptions

---

## ✅ Success Factors

1. **3 Lists files present** (no AbilityLists)
2. **DefaultValues folder** with Skills/Abilities/Spells
3. **Correct LSString Selector format**
4. **AlwaysPrepared flag** for spell grants
5. **ActionResourceGroupDefinitions** for rune system
6. **Sparse progression** (many empty levels)

---

## 🔍 Comparison with Our Warrior Mod

| Feature | DeathKnight | Our Warrior | Status |
|---------|-------------|-------------|--------|
| SkillLists.lsx | ✅ | ✅ | MATCH |
| SpellLists.lsx | ✅ (18) | ❌ | **MISSING** |
| PassiveLists.lsx | ✅ (1) | ❌ | **MISSING** |
| AbilityLists.lsx | ❌ | ✅ | DIFFERENT |
| DefaultValues/ | ✅ | ❌ (deleted) | **DIFFERENT** |
| Selector format | LSString | LSString | MATCH |
| Multiclass entry | ✅ | ✅ | MATCH |
| AlwaysPrepared flag | Yes | No | DIFFERENT |

**Key Differences**:
1. DeathKnight uses **DefaultValues** instead of AbilityLists
2. We deleted DefaultValues folder (may not be needed if we have AbilityLists)
3. Still missing SpellLists.lsx and PassiveLists.lsx

---

## 🎯 Two Valid Approaches

### **Approach A: Warlock Style**
- Use AbilityLists.lsx ✅
- No DefaultValues folder ✅
- Requires PassiveLists.lsx + SpellLists.lsx ❌

### **Approach B: DeathKnight Style**
- No AbilityLists.lsx
- Use DefaultValues/ folder
- Requires PassiveLists.lsx + SpellLists.lsx ❌

**Recommendation**: Stick with Approach A (Warlock style) since we already have AbilityLists.lsx. Just add the 2 missing Lists files.

---

**Next Step**: Create SpellLists.lsx and PassiveLists.lsx to match the working pattern.
