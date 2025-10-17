# Quick Reference: BG3 Warrior Mod Files

## Core Files You'll Create

### 1. ClassDescriptions.lsx
Location: `Public/BG3Wow_.../ClassDescriptions/ClassDescriptions.lsx`

Basic structure:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<save>
    <version major="4" minor="0" revision="9" build="331"/>
    <region id="ClassDescriptions">
        <node id="ClassDescriptions">
            <children>
                <!-- WARRIOR CLASS -->
                <node id="ClassDescription">
                    <attribute id="BaseHp" type="int32" value="10"/>
                    <attribute id="CanLearnSpells" type="bool" value="False"/>
                    <attribute id="CharacterCreationPose" type="guid" value="0f07ec6e-4ef0-4d33-beb7-eba73f524ad8"/>
                    <attribute id="ClassEquipment" type="FixedString" value="EQP_CC_Warrior"/>
                    <attribute id="Description" type="TranslatedString" handle="h_WARRIOR_DESC" version="1"/>
                    <attribute id="DisplayName" type="TranslatedString" handle="h_WARRIOR_NAME" version="1"/>
                    <attribute id="HpPerLevel" type="int32" value="6"/>
                    <attribute id="LearningStrategy" type="uint8" value="1"/>
                    <attribute id="MulticlassSpellcasterModifier" type="float" value="0"/>
                    <attribute id="MustPrepareSpells" type="bool" value="False"/>
                    <attribute id="Name" type="FixedString" value="CLASS_VORGX_WARRIOR"/>
                    <attribute id="PrimaryAbility" type="uint8" value="1"/> <!-- Strength -->
                    <attribute id="ProgressionTableUUID" type="guid" value="GENERATE_NEW_UUID_HERE"/>
                    <attribute id="SoundClassType" type="FixedString" value="Barbarian"/>
                    <attribute id="SpellCastingAbility" type="uint8" value="0"/>
                    <attribute id="UUID" type="guid" value="GENERATE_NEW_UUID_HERE"/>
                </node>

                <!-- ARMS SUBCLASS -->
                <node id="ClassDescription">
                    <attribute id="BaseHp" type="int32" value="0"/>
                    <attribute id="CanLearnSpells" type="bool" value="False"/>
                    <attribute id="Description" type="TranslatedString" handle="h_SUBCLASS_ARMS_DESC" version="1"/>
                    <attribute id="DisplayName" type="TranslatedString" handle="h_SUBCLASS_ARMS_NAME" version="1"/>
                    <attribute id="Name" type="FixedString" value="SUBCLASS_VORGX_WAR_ARMS"/>
                    <attribute id="ParentGuid" type="guid" value="UUID_OF_WARRIOR_CLASS"/>
                    <attribute id="ProgressionTableUUID" type="guid" value="GENERATE_NEW_UUID_HERE"/>
                    <attribute id="UUID" type="guid" value="GENERATE_NEW_UUID_HERE"/>
                </node>

                <!-- FURY SUBCLASS -->
                <node id="ClassDescription">
                    <attribute id="Name" type="FixedString" value="SUBCLASS_VORGX_WAR_FURY"/>
                    <attribute id="ParentGuid" type="guid" value="UUID_OF_WARRIOR_CLASS"/>
                    <!-- ... similar to Arms -->
                </node>

                <!-- PROTECTION SUBCLASS -->
                <node id="ClassDescription">
                    <attribute id="Name" type="FixedString" value="SUBCLASS_VORGX_WAR_PROT"/>
                    <attribute id="ParentGuid" type="guid" value="UUID_OF_WARRIOR_CLASS"/>
                    <!-- ... similar to Arms -->
                </node>
            </children>
        </node>
    </region>
</save>
```

---

### 2. Progressions.lsx
Location: `Public/BG3Wow_.../Progressions/Progressions.lsx`

```xml
<?xml version="1.0" encoding="UTF-8"?>
<save>
    <version major="4" minor="0" revision="9" build="331"/>
    <region id="Progressions">
        <node id="Progressions">
            <children>
                <!-- WARRIOR BASE PROGRESSION -->
                <node id="Progression">
                    <attribute id="Level" type="uint8" value="1"/>
                    <attribute id="Name" type="LSString" value="Warrior"/>
                    <attribute id="ProgressionType" type="uint8" value="0"/>
                    <attribute id="TableUUID" type="guid" value="WARRIOR_PROGRESSION_UUID"/>
                    <attribute id="UUID" type="guid" value="WARRIOR_PROGRESSION_UUID"/>
                    <children>
                        <node id="SubClasses">
                            <children>
                                <node id="SubClass">
                                    <attribute id="Object" type="guid" value="ARMS_SUBCLASS_UUID"/>
                                </node>
                                <node id="SubClass">
                                    <attribute id="Object" type="guid" value="FURY_SUBCLASS_UUID"/>
                                </node>
                                <node id="SubClass">
                                    <attribute id="Object" type="guid" value="PROT_SUBCLASS_UUID"/>
                                </node>
                            </children>
                        </node>
                    </children>
                </node>

                <!-- LEVEL 1 -->
                <node id="Progression">
                    <attribute id="Level" type="uint8" value="1"/>
                    <attribute id="Name" type="LSString" value="Warrior_L1"/>
                    <attribute id="ProgressionType" type="uint8" value="0"/>
                    <attribute id="TableUUID" type="guid" value="WARRIOR_PROGRESSION_UUID"/>
                    <attribute id="UUID" type="guid" value="GENERATE_NEW_UUID"/>
                    <children>
                        <node id="PassivesAdded">
                            <children>
                                <node id="Passive">
                                    <attribute id="Object" type="guid" value="PASSIVE_VORGX_WAR_RAGE_UUID"/>
                                </node>
                            </children>
                        </node>
                        <node id="Boosts">
                            <attribute id="Boost" type="LSString" value="ActionResource(RES_VORGX_WAR_RAGE,100,0)"/>
                        </node>
                    </children>
                </node>

                <!-- More levels... -->
            </children>
        </node>
    </region>
</save>
```

---

### 3. Spell_VORGX_Warrior.txt
Location: `Public/BG3Wow_.../Stats/Generated/Data/Spell_VORGX_Warrior.txt`

```
new entry "ACTION_VORGX_WAR_CHARGE"
type "SpellData"
data "SpellType" "Target"
data "Level" "0"
data "SpellSchool" "Evocation"
data "TargetRadius" "1.5"
data "AreaRadius" "0"
data "SpellRoll" "not SavingThrow(Ability.None)"
data "SpellSuccess" "DealDamage(MainMeleeWeapon,MainMeleeWeaponDamageType);ApplyStatus(ROOT,100,1);RegainResource(RES_VORGX_WAR_RAGE,20,0)"
data "TargetConditions" "Character() and not Dead()"
data "Icon" "Action_Charge"
data "DisplayName" "h_ACTION_VORGX_WAR_CHARGE"
data "Description" "d_ACTION_VORGX_WAR_CHARGE"
data "TooltipStatusApply" "ApplyStatus(ROOT,100,1)"
data "CastSound" "Action_Cast_ShockingGrasp"
data "TargetSound" "Action_Impact_Force_Medium"
data "SpellAnimation" "83366bbd-9b67-4dce-a26e-8a5266a6b287,,;,,;aa0e0345-5152-4013-88f0-2d11b9aa989b,,;f6e058de-ba7c-40ae-a5ca-4d7c4e584324,,;57dea9b4-454e-4bdc-b0d0-3c97c21e64b7,,;,,;,,"
data "VerbalIntent" "Damage"
data "SpellFlags" "HasVerbalComponent;HasSomaticComponent;IsSpell;IsAttack"
data "MemoryCost" "1"
data "PrepareEffect" "96108ad8-7ba0-4f66-be51-0e24d4d6ac3d"
data "CastEffect" "c65ecaa0-f19f-4f85-a0b7-d5ca44eb68df"

new entry "ACTION_VORGX_WAR_HEROIC_STRIKE"
type "SpellData"
data "SpellType" "Target"
data "Level" "0"
data "SpellSchool" "Evocation"
data "TargetRadius" "1.5"
data "SpellRoll" "Attack(AttackType.MeleeWeaponAttack)"
data "SpellSuccess" "DealDamage(1d8+StrengthModifier,Slashing)"
data "UseCosts" "ActionPoint:1;RES_VORGX_WAR_RAGE:30"
data "TargetConditions" "Character() and not Dead()"
data "Icon" "Action_Attack"
data "DisplayName" "h_ACTION_VORGX_WAR_HEROIC_STRIKE"
data "Description" "d_ACTION_VORGX_WAR_HEROIC_STRIKE"
data "CastSound" "Action_Cast_MeleeWeaponAttack"
data "TargetSound" "Action_Impact_Slash"
data "SpellAnimation" "83366bbd-9b67-4dce-a26e-8a5266a6b287,,;,,;aa0e0345-5152-4013-88f0-2d11b9aa989b,,;f6e058de-ba7c-40ae-a5ca-4d7c4e584324,,;57dea9b4-454e-4bdc-b0d0-3c97c21e64b7,,;,,;,,"
data "VerbalIntent" "Damage"
data "SpellFlags" "HasVerbalComponent;HasSomaticComponent;IsSpell;IsAttack"
data "MemoryCost" "1"
```

---

### 4. Passive_VORGX_Warrior.txt
Location: `Public/BG3Wow_.../Stats/Generated/Data/Passive_VORGX_Warrior.txt`

```
new entry "PASSIVE_VORGX_WAR_RAGE"
type "PassiveData"
data "DisplayName" "h_PASSIVE_VORGX_WAR_RAGE"
data "Description" "d_PASSIVE_VORGX_WAR_RAGE"
data "Icon" "PassiveFeature_Rage"
data "Properties" "Highlighted"
data "Boosts" "ActionResource(RES_VORGX_WAR_RAGE,100,0)"

new entry "PASSIVE_VORGX_WAR_ARMS_WEAPONMASTER"
type "PassiveData"
data "DisplayName" "h_PASSIVE_VORGX_WAR_ARMS_WEAPONMASTER"
data "Description" "d_PASSIVE_VORGX_WAR_ARMS_WEAPONMASTER"
data "Icon" "PassiveFeature_WeaponMaster"
data "Boosts" "IF(IsTwoHandedWeapon()):RollBonus(Attack,1);IF(IsTwoHandedWeapon()):RollBonus(Damage,1)"
data "Properties" "Highlighted"
```

---

### 5. English.loca.xml
Location: `Localization/English/English.loca.xml`

```xml
<?xml version="1.0" encoding="utf-8"?>
<contentList>
    <content contentuid="h_WARRIOR_NAME" version="1">Warrior</content>
    <content contentuid="h_WARRIOR_DESC" version="1">Masters of martial combat who harness rage to fuel devastating attacks.</content>
    
    <content contentuid="h_SUBCLASS_ARMS_NAME" version="1">Arms</content>
    <content contentuid="h_SUBCLASS_ARMS_DESC" version="1">Masters of two-handed weapons and tactical warfare.</content>
    
    <content contentuid="h_ACTION_VORGX_WAR_CHARGE" version="1">Charge</content>
    <content contentuid="d_ACTION_VORGX_WAR_CHARGE" version="1">Charge to a target, dealing weapon damage and generating 20 Rage. Roots target for 1 turn.</content>
    
    <content contentuid="h_ACTION_VORGX_WAR_HEROIC_STRIKE" version="1">Heroic Strike</content>
    <content contentuid="d_ACTION_VORGX_WAR_HEROIC_STRIKE" version="1">A powerful strike that costs 30 Rage. Deal 1d8 + Strength modifier damage.</content>
    
    <content contentuid="h_PASSIVE_VORGX_WAR_RAGE" version="1">Rage</content>
    <content contentuid="d_PASSIVE_VORGX_WAR_RAGE" version="1">Your fury in battle fuels your attacks. Generate and spend Rage on powerful abilities.</content>
</contentList>
```

---

## Key Stats.txt Syntax Reference

### Common Properties:

**Spells (Abilities):**
- `SpellType` - "Target", "Projectile", "Zone", "Shout"
- `UseCosts` - "ActionPoint:1;RES_VORGX_WAR_RAGE:30"
- `SpellRoll` - "Attack(AttackType.MeleeWeaponAttack)" or "SavingThrow(Ability.Strength)"
- `SpellSuccess` - What happens on hit (damage, status, etc.)
- `TargetConditions` - Who can be targeted
- `TargetRadius` - Range in meters

**Damage Functions:**
- `DealDamage(1d8,Slashing)` - Fixed dice
- `DealDamage(MainMeleeWeapon,MainMeleeWeaponDamageType)` - Weapon damage
- `DealDamage(1d8+StrengthModifier,Slashing)` - Dice + ability mod

**Resource Functions:**
- `RegainResource(RES_VORGX_WAR_RAGE,20,0)` - Add 20 Rage
- `ActionResource(RES_VORGX_WAR_RAGE,100,0)` - Set max to 100

**Status Functions:**
- `ApplyStatus(PRONE,100,1)` - Apply prone for 1 turn
- `ApplyStatus(ROOT,100,1)` - Root for 1 turn
- `RemoveStatus(BURNING)` - Remove status

---

## UUID Generation

You'll need unique UUIDs for:
- Class definition
- Each subclass
- Progression tables
- Each ability/passive

**Generate UUIDs:**
- Online: https://www.uuidgenerator.net/
- PowerShell: `[guid]::NewGuid()`
- Python: `import uuid; print(uuid.uuid4())`

**Keep track of them!** Save them in a reference doc.

---

## Testing Checklist

Before testing in-game:
1. ✅ All LSX files are valid XML (no syntax errors)
2. ✅ All Stats.txt entries have proper syntax
3. ✅ All UUIDs are unique
4. ✅ All localization handles exist in English.loca.xml
5. ✅ Progressions reference correct ability UUIDs
6. ✅ .pak file was created successfully

**Common validation:**
- Open .lsx files in browser (validates XML)
- Check logs: `%LOCALAPPDATA%\Larian Studios\Baldur's Gate 3\ScriptExtender\Logs`

---

**This is your cheat sheet. Keep it handy while building in the Mod Kit!** 📝
