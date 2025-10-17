# RESEARCH FINDINGS: Death Knight Mod Analysis

**Source:** WoWDeathKnightClass mod  
**Comparison:** vs WoWPriest mod  
**Date:** 2025-10-15

---

## EXECUTIVE SUMMARY

Death Knight mod provides **additional insights** beyond the Priest mod:
- ✅ **3 subclasses** in one mod (Blood, Frost, Unholy)
- ✅ **Multiple resource types** (RunicPower + 3 different Rune types)
- ✅ **Subclass selection at Level 1** (via SubClasses node)
- ✅ **Progressive resource scaling** (resources gained at multiple levels)
- ✅ **ActionResourceGroupDefinitions** folder (new discovery)

---

## KEY STRUCTURES COMPARED

### 1. ClassDescriptions.lsx - CONFIRMED Simple Structure

**WoWPriest (1 class, no subclasses shown):**
```xml
<node id="ClassDescription">
    <attribute id="BaseHp" type="int32" value="6"/>
    <attribute id="HpPerLevel" type="int32" value="4"/>
    <attribute id="PrimaryAbility" type="uint8" value="5"/> <!-- Wisdom -->
    <attribute id="Name" type="FixedString" value="WoWPriest"/>
    <attribute id="UUID" type="guid" value="2c681f5a-0d52-4fe6-a8ec-27f4ce2d8541"/>
    <attribute id="ProgressionTableUUID" type="guid" value="c3a5e9aa-35a4-4fad-9fae-8977363b6e8c"/>
    <!-- No resources, no proficiencies -->
</node>
```

**WoWDeathKnight (1 base + 3 subclasses):**
```xml
<!-- BASE CLASS -->
<node id="ClassDescription">
    <attribute id="BaseHp" type="int32" value="12"/>
    <attribute id="HpPerLevel" type="int32" value="7"/>
    <attribute id="PrimaryAbility" type="uint8" value="1"/> <!-- Strength -->
    <attribute id="Name" type="FixedString" value="WoWDeathKnight"/>
    <attribute id="UUID" type="guid" value="79046310-7183-42f4-9ce6-4ffdb8d65e9b"/>
    <attribute id="ProgressionTableUUID" type="guid" value="4a0e24b1-5866-4ae1-9815-aa9a3db1c1bb"/>
    <attribute id="Icon" type="FixedString" value="Icon_DK_Frost"/>
</node>

<!-- SUBCLASS - Blood -->
<node id="ClassDescription">
    <attribute id="Name" type="FixedString" value="BloodDeathKnight"/>
    <attribute id="ParentGuid" type="guid" value="79046310-7183-42f4-9ce6-4ffdb8d65e9b"/>
    <attribute id="UUID" type="guid" value="d846a33f-3bfd-43c7-ab78-ff4e8b65619a"/>
    <attribute id="ProgressionTableUUID" type="guid" value="ec00a440-e871-4412-84f7-5e3ab6a234fc"/>
    <!-- Each subclass gets UNIQUE progression table -->
</node>

<!-- SUBCLASS - Frost -->
<node id="ClassDescription">
    <attribute id="Name" type="FixedString" value="FrostDeathKnight"/>
    <attribute id="ParentGuid" type="guid" value="79046310-7183-42f4-9ce6-4ffdb8d65e9b"/>
    <attribute id="UUID" type="guid" value="b2650fe7-4a44-4981-aa65-e0b12caaf96d"/>
    <attribute id="ProgressionTableUUID" type="guid" value="cbef6b7c-80fb-4f84-a78c-bff32c1a1439"/>
</node>

<!-- SUBCLASS - Unholy -->
<node id="ClassDescription">
    <attribute id="Name" type="FixedString" value="UnholyDeathKnight"/>
    <attribute id="ParentGuid" type="guid" value="79046310-7183-42f4-9ce6-4ffdb8d65e9b"/>
    <attribute id="UUID" type="guid" value="4684a93e-9047-4f3f-b3e7-a2d17453551d"/>
    <attribute id="ProgressionTableUUID" type="guid" value="17dc1093-4340-4023-9002-c2edb2dfb9e2"/>
</node>
```

**KEY FINDINGS:**
- ✅ Subclasses use `ParentGuid` to reference base class UUID
- ✅ Each subclass has UNIQUE `ProgressionTableUUID`
- ✅ Icon attribute can be specified per class/subclass
- ✅ Still NO resources or proficiencies in ClassDescriptions

---

### 2. ActionResourceDefinitions.lsx - Multiple Resources

**WoWPriest (1 resource):**
```xml
<node id="ActionResourceDefinition">
    <attribute id="Name" type="FixedString" value="HolyPower"/>
    <attribute id="MaxLevel" type="uint32" value="0"/>
    <attribute id="ReplenishType" type="FixedString" value="Rest"/>
    <attribute id="ShowOnActionResourcePanel" type="bool" value="true"/>
    <attribute id="UUID" type="guid" value="3f69076a-464d-48f7-94b2-31e370f835f4"/>
</node>
```

**WoWDeathKnight (4 resources):**
```xml
<!-- RUNIC POWER (primary resource, 0-100 meter) -->
<node id="ActionResourceDefinition">
    <attribute id="Name" type="FixedString" value="RunicPower"/>
    <attribute id="MaxLevel" type="uint32" value="0"/> <!-- 0 = meter/points, >0 = max pips -->
    <attribute id="ReplenishType" type="FixedString" value="ShortRest"/>
    <attribute id="ShowOnActionResourcePanel" type="bool" value="true"/>
    <attribute id="UUID" type="guid" value="672d8944-4fff-4d42-84e9-220cce815ea8"/>
</node>

<!-- UNHOLY RUNE (pip-based, scaling) -->
<node id="ActionResourceDefinition">
    <attribute id="Name" type="FixedString" value="UnholyRune"/>
    <attribute id="MaxLevel" type="uint32" value="0"/>
    <attribute id="ReplenishType" type="FixedString" value="ShortRest"/>
    <attribute id="ShowOnActionResourcePanel" type="bool" value="true"/>
    <attribute id="UUID" type="guid" value="1323ae6b-8cfe-447e-b553-21582d18a4f2"/>
</node>

<!-- FROST RUNE -->
<node id="ActionResourceDefinition">
    <attribute id="Name" type="FixedString" value="FrostRune"/>
    <attribute id="MaxLevel" type="uint32" value="0"/>
    <attribute id="ReplenishType" type="FixedString" value="ShortRest"/>
    <attribute id="ShowOnActionResourcePanel" type="bool" value="true"/>
    <attribute id="UUID" type="guid" value="4a06a7ec-6d77-486d-b53c-a14535f0a29d"/>
</node>

<!-- BLOOD RUNE -->
<node id="ActionResourceDefinition">
    <attribute id="Name" type="FixedString" value="BloodRune"/>
    <attribute id="MaxLevel" type="uint32" value="0"/>
    <attribute id="ReplenishType" type="FixedString" value="ShortRest"/>
    <attribute id="ShowOnActionResourcePanel" type="bool" value="true"/>
    <attribute id="UUID" type="guid" value="005074a8-39a2-4d72-b496-31dfb70bac03"/>
</node>
```

**KEY FINDINGS:**
- ✅ `MaxLevel="0"` appears to be used for meter/point resources
- ✅ `ReplenishType` options: "Rest" (long), "ShortRest", possibly "Never"
- ✅ Multiple resources can coexist (Runic Power + 3 Rune types)
- ✅ All localization via TranslatedString handles

**FOR WARRIOR:**
- Rage should use `MaxLevel="0"` (it's a 0-100 meter)
- `ReplenishType="Never"` (Rage doesn't regen, only builds)
- `ShowOnActionResourcePanel="true"`

---

### 3. Progressions.lsx - CRITICAL INSIGHTS

#### A. Level 1 Base Class Progression (Subclass Selection)

**WoWDeathKnight Level 1:**
```xml
<node id="Progression">
    <attribute id="Level" type="uint8" value="1"/>
    <attribute id="Name" type="LSString" value="WoWDeathKnight"/>
    <attribute id="ProgressionType" type="uint8" value="0"/> <!-- 0 = class, 1 = subclass -->
    <attribute id="TableUUID" type="guid" value="4a0e24b1-5866-4ae1-9815-aa9a3db1c1bb"/>
    
    <!-- PROFICIENCIES + INITIAL RESOURCES -->
    <attribute id="Boosts" type="LSString" 
               value="ProficiencyBonus(SavingThrow,Wisdom);
                      ProficiencyBonus(SavingThrow,Charisma);
                      Proficiency(LightArmor);
                      Proficiency(MediumArmor);
                      Proficiency(HeavyArmor);
                      Proficiency(SimpleWeapons);
                      Proficiency(MartialWeapons);
                      ActionResource(RunicPower,100,0);
                      ActionResource(UnholyRune,1,0);
                      ActionResource(FrostRune,1,0);
                      ActionResource(BloodRune,1,0)"/>
    
    <!-- PASSIVE UNLOCKS -->
    <attribute id="PassivesAdded" type="LSString" 
               value="DK_UnlockRunicPower;
                      DK_UnlockUnholyRune;
                      DK_UnlockFrostRune;
                      DK_UnlockBloodRune"/>
    
    <!-- SELECTORS (skills, abilities, spells) -->
    <attribute id="Selectors" type="LSString" 
               value="SelectSkills(ebba66c9-ad8a-4593-a8a9-72ddb7f89d6f,2);
                      SelectAbilityBonus(b9149c8e-52c8-46e5-9cb6-fc39301c05fe,AbilityBonus,2,1);
                      AddSpells(bc76bcd5-b481-4cc8-8c04-4de370e9e2cf,,,,AlwaysPrepared)"/>
    
    <!-- SUBCLASS CHOICE NODE -->
    <children>
        <node id="SubClasses">
            <children>
                <node id="SubClass">
                    <attribute id="Object" type="guid" value="d846a33f-3bfd-43c7-ab78-ff4e8b65619a"/> <!-- Blood -->
                </node>
                <node id="SubClass">
                    <attribute id="Object" type="guid" value="b2650fe7-4a44-4981-aa65-e0b12caaf96d"/> <!-- Frost -->
                </node>
                <node id="SubClass">
                    <attribute id="Object" type="guid" value="4684a93e-9047-4f3f-b3e7-a2d17453551d"/> <!-- Unholy -->
                </node>
            </children>
        </node>
    </children>
</node>
```

**CRITICAL DISCOVERY:**
- ✅ `<node id="SubClasses">` with child `<node id="SubClass">` entries
- ✅ Each SubClass node references the **subclass UUID from ClassDescriptions.lsx**
- ✅ This creates the subclass choice at Level 1
- ✅ Player selects one of the three at character creation

#### B. Multiclass Support (Optional but Present)

```xml
<node id="Progression">
    <attribute id="Level" type="uint8" value="1"/>
    <attribute id="Name" type="LSString" value="WoWDeathKnight"/>
    <attribute id="IsMulticlass" type="bool" value="true"/> <!-- KEY FLAG -->
    <attribute id="ProgressionType" type="uint8" value="0"/>
    
    <!-- Fewer proficiencies, same resources -->
    <attribute id="Boosts" type="LSString" 
               value="Proficiency(LightArmor);
                      Proficiency(MediumArmor);
                      Proficiency(HeavyArmor);
                      Proficiency(SimpleWeapons);
                      Proficiency(MartialWeapons);
                      ActionResource(RunicPower,100,0);
                      ActionResource(UnholyRune,1,0);
                      ActionResource(FrostRune,1,0);
                      ActionResource(BloodRune,1,0)"/>
    
    <!-- NO SelectSkills, NO SelectAbilityBonus (multiclass rules) -->
    
    <!-- SAME subclass choice -->
    <children>
        <node id="SubClasses">
            <!-- ... same 3 subclasses ... -->
        </node>
    </children>
</node>
```

#### C. Subclass Progression (Blood Example)

```xml
<node id="Progression">
    <attribute id="Level" type="uint8" value="1"/>
    <attribute id="Name" type="LSString" value="BloodDeathKnight"/>
    <attribute id="ProgressionType" type="uint8" value="1"/> <!-- 1 = SUBCLASS progression -->
    <attribute id="TableUUID" type="guid" value="ec00a440-e871-4412-84f7-5e3ab6a234fc"/>
    
    <!-- SUBCLASS-SPECIFIC RESOURCES -->
    <attribute id="Boosts" type="LSString" value="ActionResource(BloodRune,1,0)"/>
    
    <!-- SUBCLASS-SPECIFIC PASSIVES -->
    <attribute id="PassivesAdded" type="LSString" value="Mastery_BloodShield;Mastery_BloodShield_Counter"/>
</node>
```

**KEY FINDINGS:**
- ✅ `ProgressionType="0"` = Class progression
- ✅ `ProgressionType="1"` = Subclass progression
- ✅ Subclass progressions use their own TableUUID (from ClassDescriptions)
- ✅ Subclasses can grant additional resources (Blood gets extra BloodRune)

#### D. Resource Scaling Over Levels

**Level 7 (Base Class):**
```xml
<attribute id="Boosts" type="LSString" value="ActionResource(RunicPower,20,0)"/>
<attribute id="PassivesAdded" type="LSString" value="DK_UnlockRunicPower_2"/>
```
- Grants +20 more Runic Power (total now 120)

**Level 10 (Base Class):**
```xml
<attribute id="Boosts" type="LSString" 
           value="ActionResource(UnholyRune,1,0);
                  ActionResource(FrostRune,1,0);
                  ActionResource(BloodRune,1,0)"/>
```
- Each rune type gains +1 (total now 2 per type)

**Level 12 (Base Class):**
```xml
<attribute id="Boosts" type="LSString" value="ActionResource(RunicPower,30,0)"/>
```
- Grants +30 more Runic Power (total now 150)

**FOR WARRIOR:**
- Rage could start at 100 max at L1
- Could scale to 120 at L7, 150 at L12, etc.
- OR stay at 100 and provide other benefits

---

### 4. Boosts Syntax Reference

**From both mods, confirmed Boosts patterns:**

```
ProficiencyBonus(SavingThrow,<Ability>)
    Examples: Wisdom, Charisma, Strength, Constitution
    
Proficiency(<Type>)
    Types: LightArmor, MediumArmor, HeavyArmor, Shields
           SimpleWeapons, MartialWeapons
           
ActionResource(<ResourceName>,<Amount>,<Unknown>)
    ResourceName: Must match Name in ActionResourceDefinitions.lsx
    Amount: Starting/additional amount
    Unknown: Always 0 in examples (possibly max override?)
    
SelectSkills(<UUID>,<Count>)
    UUID: References a skill list (unknown structure)
    Count: Number of skills to choose
    
SelectAbilityBonus(<UUID>,AbilityBonus,<Points>,<Count>)
    Standard ability score improvement selector
    
AddSpells(<UUID>,,,,AlwaysPrepared)
    UUID: References spell list
    AlwaysPrepared: Optional flag for always-prepared spells
```

---

### 5. Folder Structure Differences

**WoWPriest:**
```
Public/WoWPriest_[UUID]/
  ├── ActionResourceDefinitions/
  ├── ClassDescriptions/
  ├── Progressions/
  └── Stats/
```

**WoWDeathKnight (MORE COMPLETE):**
```
Public/WoWDeathKnightClass/
  ├── ActionResourceDefinitions/
  ├── ActionResourceGroupDefinitions/  ← NEW
  ├── Assets/
  ├── CharacterCreationPresets/
  ├── ClassDescriptions/
  ├── Content/
  ├── DefaultValues/
  ├── GUI/
  ├── Levelmaps/
  ├── Lists/
  ├── Progressions/
  ├── RootTemplates/
  ├── Stats/
  └── TooltipExtras/
```

**NEW FOLDER DISCOVERED:**
- `ActionResourceGroupDefinitions/` - possibly groups resources together (e.g., all Runes)
- `TooltipExtras/` - custom tooltip formatting
- `DefaultValues/` - unknown purpose
- `CharacterCreationPresets/` - pre-made character templates

---

## WARRIOR MOD IMPLEMENTATION PLAN (REVISED)

### File 1: ActionResourceDefinitions.lsx

```xml
<node id="ActionResourceDefinition">
    <attribute id="Description" type="TranslatedString" handle="h[rage-desc]" version="1"/>
    <attribute id="DisplayName" type="TranslatedString" handle="h[rage-display]" version="1"/>
    <attribute id="MaxLevel" type="uint32" value="0"/>
    <attribute id="Name" type="FixedString" value="Rage"/>
    <attribute id="ReplenishType" type="FixedString" value="Never"/>
    <attribute id="ShowOnActionResourcePanel" type="bool" value="true"/>
    <attribute id="UUID" type="guid" value="[generate-new-uuid]"/>
</node>
```

### File 2: ClassDescriptions.lsx

```xml
<!-- BASE WARRIOR CLASS -->
<node id="ClassDescription">
    <attribute id="BaseHp" type="int32" value="10"/>
    <attribute id="HpPerLevel" type="int32" value="10"/>
    <attribute id="PrimaryAbility" type="uint8" value="1"/> <!-- Strength -->
    <attribute id="Name" type="FixedString" value="WoWWarrior"/>
    <attribute id="UUID" type="guid" value="78fe4967-4e62-5491-d981-dd781acca4d7"/>
    <attribute id="ProgressionTableUUID" type="guid" value="[warrior-prog-uuid]"/>
    <attribute id="Icon" type="FixedString" value="Icon_Warrior"/>
    <!-- ... other attributes ... -->
</node>

<!-- ARMS SUBCLASS -->
<node id="ClassDescription">
    <attribute id="Name" type="FixedString" value="ArmsWarrior"/>
    <attribute id="ParentGuid" type="guid" value="78fe4967-4e62-5491-d981-dd781acca4d7"/>
    <attribute id="UUID" type="guid" value="[arms-uuid]"/>
    <attribute id="ProgressionTableUUID" type="guid" value="[arms-prog-uuid]"/>
    <!-- ... -->
</node>

<!-- FURY SUBCLASS -->
<node id="ClassDescription">
    <attribute id="Name" type="FixedString" value="FuryWarrior"/>
    <attribute id="ParentGuid" type="guid" value="78fe4967-4e62-5491-d981-dd781acca4d7"/>
    <attribute id="UUID" type="guid" value="[fury-uuid]"/>
    <attribute id="ProgressionTableUUID" type="guid" value="[fury-prog-uuid]"/>
    <!-- ... -->
</node>

<!-- PROTECTION SUBCLASS -->
<node id="ClassDescription">
    <attribute id="Name" type="FixedString" value="ProtectionWarrior"/>
    <attribute id="ParentGuid" type="guid" value="78fe4967-4e62-5491-d981-dd781acca4d7"/>
    <attribute id="UUID" type="guid" value="[prot-uuid]"/>
    <attribute id="ProgressionTableUUID" type="guid" value="[prot-prog-uuid]"/>
    <!-- ... -->
</node>
```

### File 3: Progressions.lsx - Level 1

```xml
<!-- WARRIOR BASE CLASS LEVEL 1 -->
<node id="Progression">
    <attribute id="Level" type="uint8" value="1"/>
    <attribute id="Name" type="LSString" value="WoWWarrior"/>
    <attribute id="ProgressionType" type="uint8" value="0"/>
    <attribute id="TableUUID" type="guid" value="[warrior-prog-uuid]"/>
    
    <attribute id="Boosts" type="LSString" 
               value="ProficiencyBonus(SavingThrow,Strength);
                      ProficiencyBonus(SavingThrow,Constitution);
                      Proficiency(LightArmor);
                      Proficiency(MediumArmor);
                      Proficiency(HeavyArmor);
                      Proficiency(Shields);
                      Proficiency(SimpleWeapons);
                      Proficiency(MartialWeapons);
                      ActionResource(Rage,100,0)"/>
    
    <attribute id="PassivesAdded" type="LSString" value="WAR_UnlockRage;WAR_RageGeneration"/>
    
    <attribute id="Selectors" type="LSString" 
               value="SelectSkills([skill-list-uuid],2);
                      SelectAbilityBonus([ability-uuid],AbilityBonus,2,1);
                      AddSpells([warrior-base-spells],,,,AlwaysPrepared)"/>
    
    <children>
        <node id="SubClasses">
            <children>
                <node id="SubClass">
                    <attribute id="Object" type="guid" value="[arms-uuid]"/>
                </node>
                <node id="SubClass">
                    <attribute id="Object" type="guid" value="[fury-uuid]"/>
                </node>
                <node id="SubClass">
                    <attribute id="Object" type="guid" value="[prot-uuid]"/>
                </node>
            </children>
        </node>
    </children>
</node>
```

---

## COMPARISON MATRIX

| Feature | WoWPriest | WoWDeathKnight | Warrior Plan |
|---------|-----------|----------------|--------------|
| **Subclasses** | Not visible in ClassDescriptions | 3 (Blood/Frost/Unholy) | 3 (Arms/Fury/Protection) |
| **Resources** | 1 (HolyPower) | 4 (RunicPower + 3 Runes) | 1 (Rage) |
| **Resource Type** | Pips/Points | Meter + Pips | Meter (0-100) |
| **Subclass Level** | Unknown | Level 1 | Level 1 |
| **Resource Scaling** | Not observed | Yes (L7, L10, L12) | Optional (TBD) |
| **Multiclass Support** | Yes (separate progression) | Yes (separate progression) | Yes (recommended) |
| **HP Dice** | d6 (4 HP/level) | d12 (7 HP/level) | d10 (10 HP/level) |
| **Primary Ability** | Wisdom (5) | Strength (1) | Strength (1) |
| **Saves** | Wis/Cha | Wis/Cha | Str/Con |
| **Icon Customization** | No | Yes | Yes |

---

## CRITICAL TAKEAWAYS FOR WARRIOR MOD

1. **SubClasses node is MANDATORY** for Level 1 subclass choice
2. **Each subclass needs unique ProgressionTableUUID**
3. **ProgressionType="0"** for class, **"1"** for subclass
4. **Rage definition in ActionResourceDefinitions** with `MaxLevel="0"`
5. **All proficiencies in Level 1 Progression Boosts**
6. **PassivesAdded** needed to "unlock" resource UI display
7. **Multiclass progression** recommended for completeness
8. **Icon attribute** can customize class/subclass icons

---

## NEXT STEPS

1. ✅ Generate corrected ActionResourceDefinitions.lsx
2. ✅ Generate corrected ClassDescriptions.lsx (with 3 subclasses)
3. ✅ Generate corrected Progressions.lsx (with SubClasses node)
4. ⏳ Create Stats files (Spell/Passive/Status)
5. ⏳ Create Localization files
6. ⏳ Test SubClass selection at character creation

---

**End of Death Knight Research Findings**
