# Progressions.lsx - Generation Reference
**Date:** October 16, 2025  
**Status:** 🔧 **READY TO GENERATE**

---

## ✅ ALL DECISIONS CONFIRMED

### User Answers
1. ✅ **Passive Names:** Confirmed (see PASSIVES_BREAKDOWN.md)
2. ✅ **Spell List UUID:** Option A - Placeholder now, document for later
3. ✅ **Skill List UUID:** Option A - Placeholder now, document for later  
4. ✅ **Improved Extra Attack L11:** Option A - Yes, 3 attacks like Fighter
5. ✅ **ASI Levels:** Option B - Only L20 (5 total: 4/8/12/16/20)

### Important Clarification
**ASI is a FEAT CHOICE in BG3**, not automatic!
- `AllowImprovement="true"` enables feat selection UI
- Player chooses between "Ability Score Improvement" feat or other feats
- This is different from D&D 5e where ASI is automatic

---

## 📦 PLACEHOLDER UUIDS - TO BE CREATED LATER

### SpellLists.lsx (Future File)
```xml
<!-- WARRIOR LEVEL 1 SPELL LIST -->
<node id="SpellList">
    <attribute id="Comment" type="LSString" value="Warrior Level 1 Abilities"/>
    <attribute id="Spells" type="LSString" value="Shout_WAR_Charge;Target_WAR_HeroicStrike"/>
    <attribute id="UUID" type="guid" value="bc76bcd5-b481-4cc8-8c04-4de370e9e2cf"/>
</node>
```

**Referenced in:** Base Warrior Level 1 Selectors  
**Contains:** Charge, Heroic Strike

---

### SkillLists.lsx (Future File or Use Existing)
```xml
<!-- WARRIOR SKILL LIST -->
<node id="SkillList">
    <attribute id="Skills" type="LSString" value="Athletics;Acrobatics;Intimidation;Perception;Survival;AnimalHandling"/>
    <attribute id="UUID" type="guid" value="f974ebd6-3725-4b90-bb5c-2b647d41615d"/>
</node>
```

**Referenced in:** Base Warrior Level 1 Selectors  
**Contains:** 6 Warrior skills (choose 2)

**Note:** May already exist in vanilla BG3 as a generic "Martial Skills" list - research needed

---

## 🎯 PROGRESSION STRUCTURE OVERVIEW

### Base Warrior (TableUUID: a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d)
```
Level 1  - Proficiencies, Rage, SubClasses node, starting abilities
Level 1M - Multiclass variant (no saving throws, reduced selectors)
Level 2  - Battle Shout
Level 3  - Execute
Level 4  - ASI/Feat choice
Level 5  - Extra Attack
Level 6  - (Placeholder)
Level 7  - (Placeholder)
Level 8  - ASI/Feat choice
Level 9  - (Placeholder)
Level 10 - (Placeholder)
Level 11 - Improved Extra Attack (3 attacks total)
Level 12 - ASI/Feat choice
Level 13 - (Placeholder)
Level 14 - (Placeholder)
Level 15 - (Placeholder)
Level 16 - ASI/Feat choice
Level 17 - (Placeholder)
Level 18 - (Placeholder)
Level 19 - (Placeholder)
Level 20 - ASI/Feat choice
```

### Arms Subclass (TableUUID: 2b3c4d5e-6f7a-8b9c-0d1e-2f3a4b5c6d7e)
```
Level 1 - WAR_ARMS_WeaponMastery (+1 hit/dmg with 2H)
Level 3 - Mortal Strike, full Weapon Mastery passive (if different)
Level 5 - Overpower
Level 7 - Colossus Smash
```

### Fury Subclass (TableUUID: 4c5d6e7f-8a9b-0c1d-2e3f-4a5b6c7d8e9f)
```
Level 1 - WAR_FURY_DualWieldMastery (+2 Rage/hit)
Level 3 - Rampage, Bloodthirst, Enrage passive
Level 5 - Whirlwind
```

### Protection Subclass (TableUUID: 6d7e8f9a-0b1c-2d3e-4f5a-6b7c8d9e0f1a)
```
Level 1 - WAR_PROT_ShieldSpecialization (+2 AC with shield)
Level 3 - Shield Slam, Shield Block
Level 5 - Taunt
```

---

## 🔧 KEY ATTRIBUTES REFERENCE

### ProgressionType Values
- `0` = Class progression (base class levels)
- `1` = Subclass progression (spec-specific grants)

### AllowImprovement (Feat Selection)
- `true` = Player gets feat choice UI
- `false` or omitted = No feat choice

**Feat Levels:** 4, 8, 12, 16, 20 (5 total)

### Boosts Syntax
```
ProficiencyBonus(SavingThrow,Strength)
ProficiencyBonus(SavingThrow,Constitution)
Proficiency(LightArmor)
Proficiency(MediumArmor)
Proficiency(HeavyArmor)
Proficiency(Shields)
Proficiency(SimpleWeapons)
Proficiency(MartialWeapons)
ActionResource(Rage,100,0)
```

### Selectors Syntax
```
SelectSkills(<skill-list-uuid>,2)
SelectAbilityBonus(b9149c8e-52c8-46e5-9cb6-fc39301c05fe,AbilityBonus,2,1)
AddSpells(<spell-list-uuid>,,,,AlwaysPrepared)
```

### PassivesAdded Syntax
```
WAR_UnlockRage;WAR_RageGeneration
WAR_ARMS_WeaponMastery
WAR_FURY_DualWieldMastery
WAR_PROT_ShieldSpecialization
ExtraAttack
ImprovedExtraAttack
```

---

## 📋 VALIDATION CHECKLIST (Post-Generation)

### XML Structure
- [ ] Valid XML (well-formed, closes all tags)
- [ ] Version tag: `<version major="4" minor="8" revision="0" build="10"/>`
- [ ] Root region: `<region id="Progressions">`

### Base Warrior
- [ ] Level 1 has SubClasses node with 3 SubClass children
- [ ] Level 1 Boosts include all proficiencies + ActionResource(Rage,100,0)
- [ ] Level 1 PassivesAdded: WAR_UnlockRage;WAR_RageGeneration
- [ ] Level 1 Selectors: SelectSkills, SelectAbilityBonus, AddSpells
- [ ] Level 1 Multiclass variant exists (IsMulticlass="true")
- [ ] Levels 4/8/12/16/20 have AllowImprovement="true"
- [ ] Level 5 grants ExtraAttack passive
- [ ] Level 11 grants ImprovedExtraAttack passive
- [ ] All progression UUIDs are unique
- [ ] All progressions reference TableUUID: a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d

### Arms Subclass
- [ ] Level 1 grants WAR_ARMS_WeaponMastery
- [ ] Level 3 grants major abilities
- [ ] All progressions reference TableUUID: 2b3c4d5e-6f7a-8b9c-0d1e-2f3a4b5c6d7e
- [ ] ProgressionType="1" on all nodes

### Fury Subclass
- [ ] Level 1 grants WAR_FURY_DualWieldMastery
- [ ] Level 3 grants major abilities
- [ ] All progressions reference TableUUID: 4c5d6e7f-8a9b-0c1d-2e3f-4a5b6c7d8e9f
- [ ] ProgressionType="1" on all nodes

### Protection Subclass
- [ ] Level 1 grants WAR_PROT_ShieldSpecialization
- [ ] Level 3 grants major abilities
- [ ] All progressions reference TableUUID: 6d7e8f9a-0b1c-2d3e-4f5a-6b7c8d9e0f1a
- [ ] ProgressionType="1" on all nodes

### Cross-References
- [ ] SubClasses node UUIDs match ClassDescriptions.lsx UUIDs
- [ ] TableUUIDs match ProgressionTableUUID in ClassDescriptions.lsx
- [ ] Spell list UUID documented for future SpellLists.lsx
- [ ] Skill list UUID documented for future SkillLists.lsx

---

## 🚀 READY TO GENERATE

All decisions made, all references documented. Ready to create complete Progressions.lsx file!

**Next Command:** Generate Progressions.lsx with full Level 1-20 progression for base class and all 3 subclasses.
