# RESEARCH FINDINGS: BG3 Class Mod Structure

**Source:** WoWPriest mod analysis  
**Date:** 2025-10-15

---

## KEY DISCOVERIES

### 1. ClassDescriptions.lsx is MINIMAL - Metadata Only

**What it contains:**
- ✅ Basic class metadata (name, UUID, display name, description)
- ✅ HP values (BaseHp, HpPerLevel)
- ✅ Primary ability (PrimaryAbility = 5 for Wisdom)
- ✅ Spell casting ability (if applicable)
- ✅ Equipment reference (ClassEquipment)
- ✅ Character creation pose
- ✅ Hotbar column configuration
- ✅ ProgressionTableUUID reference

**What it does NOT contain:**
- ❌ NO resource definitions (Rage, Holy Power, etc.)
- ❌ NO proficiencies (weapons, armor, saves)
- ❌ NO ability grants
- ❌ NO subclass definitions (in this single-class example)

### 2. ActionResourceDefinitions.lsx Defines Resources

**Example from WoWPriest (Holy Power):**
```xml
<node id="ActionResourceDefinition">
    <attribute id="Description" type="TranslatedString" handle="h16bacd22g11bagd747ge092gcac4816399c3" version="1"/>
    <attribute id="DisplayName" type="TranslatedString" handle="h4f9348e9g8d07gf6e4g07eegb20916369fce" version="1"/>
    <attribute id="MaxLevel" type="uint32" value="0"/>
    <attribute id="Name" type="FixedString" value="HolyPower"/>
    <attribute id="ReplenishType" type="FixedString" value="Rest"/>
    <attribute id="ShowOnActionResourcePanel" type="bool" value="true"/>
    <attribute id="UUID" type="guid" value="3f69076a-464d-48f7-94b2-31e370f835f4"/>
</node>
```

**For Warrior Rage, we need:**
- Name: "Rage"
- MaxLevel: 100 (for 0-100 meter)
- ReplenishType: "Rest" or "Never" (since Rage doesn't regen passively)
- ShowOnActionResourcePanel: true

### 3. Progressions.lsx Grants Everything at Level 1

**Example from WoWPriest Level 1:**
```xml
<node id="Progression">
    <attribute id="Level" type="uint8" value="1"/>
    <attribute id="Name" type="LSString" value="WoWPriest"/>
    <attribute id="ProgressionType" type="uint8" value="0"/>
    <attribute id="TableUUID" type="guid" value="c3a5e9aa-35a4-4fad-9fae-8977363b6e8c"/>
    <attribute id="UUID" type="guid" value="673866b5-fe9f-48de-8afb-ffd0861506ad"/>
    
    <!-- THE IMPORTANT PART -->
    <attribute id="Boosts" type="LSString" value="ActionResource(HolyPower,5,0);ProficiencyBonus(SavingThrow,Wisdom);ProficiencyBonus(SavingThrow,Charisma);Proficiency(SimpleWeapons);Proficiency(MartialWeapons);Proficiency(LightArmor)"/>
    
    <attribute id="PassivesAdded" type="LSString" value="Priest_Unlock_HolyPower;Priest_Bonus_As_Action"/>
    
    <attribute id="Selectors" type="LSString" value="SelectAbilityBonus(b9149c8e-52c8-46e5-9cb6-fc39301c05fe,AbilityBonus,2,1);SelectSkills(a21cf159-9658-4f5e-8e34-7aa48c89274f,2);AddSpells(c96ac0de-fee9-44dc-a5bc-310af34463a4);"/>
</node>
```

**Boosts string breakdown:**
- `ActionResource(HolyPower,5,0)` - Grants 5 Holy Power points at start
- `ProficiencyBonus(SavingThrow,Wisdom)` - Wisdom save proficiency
- `ProficiencyBonus(SavingThrow,Charisma)` - Charisma save proficiency
- `Proficiency(SimpleWeapons)` - Simple weapons proficiency
- `Proficiency(MartialWeapons)` - Martial weapons proficiency
- `Proficiency(LightArmor)` - Light armor proficiency

**For Warrior, we need:**
```
ActionResource(Rage,100,0);
ProficiencyBonus(SavingThrow,Strength);
ProficiencyBonus(SavingThrow,Constitution);
Proficiency(SimpleWeapons);
Proficiency(MartialWeapons);
Proficiency(LightArmor);
Proficiency(MediumArmor);
Proficiency(HeavyArmor);
Proficiency(Shields)
```

### 4. File Structure Summary

```
Mods/
  [ModName]/
    meta.lsx                    # Mod metadata, dependencies
    mod_publish_logo.png
    
Public/
  [ModName]/
    ActionResourceDefinitions/
      ActionResourceDefinitions.lsx   # Define Rage resource here
    
    ClassDescriptions/
      ClassDescriptions.lsx           # MINIMAL: just metadata
    
    Progressions/
      Progressions.lsx                # ALL grants happen here (Level 1-20)
      ProgressionDescriptions.lsx     # ?
    
    Stats/
      [Stats files for abilities]
    
    Localization/
      [.loca.xml files]
```

---

## CORRECTED PLAN FOR WARRIOR MOD

### Step 1: Create ActionResourceDefinitions.lsx
Define Rage resource (0-100 meter)

### Step 2: Simplify ClassDescriptions.lsx
- Remove all resource/proficiency attempts
- Keep ONLY: name, UUID, HP, abilities, progression UUID
- Create 4 entries: Base Warrior + 3 subclasses (Arms/Fury/Protection)

### Step 3: Create Progressions.lsx
Level 1 progression grants:
- ActionResource(Rage,100,0)
- All proficiencies (weapons, armor, saves)
- Passive for Rage generation mechanics
- Skill selection
- Subclass choice

Levels 2-20: Ability grants, feats, tier unlocks

### Step 4: Stats files
Spell_Warrior.txt, Passive_Warrior.txt, Status_Warrior.txt

### Step 5: Localization
English.loca.xml with all handles

---

## IMMEDIATE ACTION REQUIRED

1. ✅ Create ActionResourceDefinitions.lsx for Rage
2. ✅ Rewrite ClassDescriptions.lsx (MUCH simpler)
3. ✅ Create Progressions.lsx starting with Level 1 grants
4. ⏳ Proceed with Stats files
5. ⏳ Proceed with Localization

---

**Next Step:** Generate corrected files based on this real-world structure.
