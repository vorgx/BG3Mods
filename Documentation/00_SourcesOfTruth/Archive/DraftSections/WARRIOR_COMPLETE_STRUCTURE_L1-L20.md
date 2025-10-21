# Warrior Mod Complete Structure: ClassDescriptions + Progressions (L1-L20)

**Created**: October 20, 2025  
**Purpose**: Show complete mod structure with separate ProgressionTableUUIDs per class/subclass/hero talent  
**Based On**: Excel data + Warlock framework patterns

---

## 📊 Complete Structure Overview

### Totals Summary

| Component | Count | Notes |
|-----------|-------|-------|
| **ClassDescription Nodes** | 7 | 1 base + 3 subclasses + 3 hero talents |
| **ProgressionTableUUIDs** | 7 | One per ClassDescription node |
| **SpellLists** | 1 | Dummy UUID shared by all nodes |
| **Total Progression Nodes** | ~150-200 | All levels L1-L20 for all tables |

---

## 🏗️ ClassDescriptions.lsx Structure (7 Nodes)

### File: `ClassDescriptions/ClassDescriptions.lsx`

```xml
<?xml version="1.0" encoding="UTF-8"?>
<save>
    <version major="4" minor="7" revision="1" build="3"/>
    <region id="ClassDescriptions">
        <node id="root">
            <children>
                
                <!-- ========== NODE 1: BASE CLASS ========== -->
                <node id="ClassDescription">
                    <attribute id="BaseHp" type="int32" value="10"/>
                    <attribute id="CanLearnSpells" type="bool" value="false"/>
                    <attribute id="CharacterCreationPose" type="guid" value="0f07ec6e-4ef0-434e-9a51-1353260ccff8"/>
                    <attribute id="ClassEquipment" type="FixedString" value="EQP_CC_Barbarian"/>
                    <attribute id="ClassHotbarColumns" type="int32" value="5"/>
                    <attribute id="CommonHotbarColumns" type="int32" value="9"/>
                    <attribute id="Description" type="TranslatedString" handle="h[WARRIOR_DESC]" version="1"/>
                    <attribute id="DisplayName" type="TranslatedString" handle="h[WARRIOR_NAME]" version="1"/>
                    <attribute id="HpPerLevel" type="int32" value="10"/>
                    <attribute id="ItemsHotbarColumns" type="int32" value="2"/>
                    <attribute id="LearningStrategy" type="uint8" value="1"/>
                    <attribute id="MustPrepareSpells" type="bool" value="false"/>
                    <attribute id="Name" type="FixedString" value="WoWWarrior"/>
                    <attribute id="PrimaryAbility" type="uint8" value="1"/>
                    <attribute id="ProgressionTableUUID" type="guid" value="[UUID_1_BASE_WARRIOR]"/>
                    <attribute id="ShortName" type="TranslatedString" handle="h[WARRIOR_SHORT]" version="1"/>
                    <attribute id="SoundClassType" type="FixedString" value="Barbarian"/>
                    <attribute id="SpellCastingAbility" type="uint8" value="1"/>
                    <attribute id="SpellList" type="guid" value="32879c22-4858-48ef-8f8d-22e6d395b396"/>
                    <attribute id="UUID" type="guid" value="78fe4967-4e62-5491-d981-dd781acca4d7"/>
                    <children>
                        <node id="Tags">
                            <attribute id="Object" type="guid" value="5804f55a-93f7-4281-9512-8d548a9e2a22"/>
                        </node>
                    </children>
                </node>

                <!-- ========== NODE 2: ARMS WARRIOR (SUBCLASS) ========== -->
                <node id="ClassDescription">
                    <attribute id="BaseHp" type="int32" value="6"/>
                    <attribute id="CanLearnSpells" type="bool" value="false"/>
                    <attribute id="CharacterCreationPose" type="guid" value="0f07ec6e-4ef0-434e-9a51-1353260ccff8"/>
                    <attribute id="ClassEquipment" type="FixedString" value="EQP_CC_Barbarian"/>
                    <attribute id="ClassHotbarColumns" type="int32" value="5"/>
                    <attribute id="CommonHotbarColumns" type="int32" value="9"/>
                    <attribute id="Description" type="TranslatedString" handle="h[ARMS_DESC]" version="1"/>
                    <attribute id="DisplayName" type="TranslatedString" handle="h[ARMS_NAME]" version="1"/>
                    <attribute id="HpPerLevel" type="int32" value="6"/>
                    <attribute id="ItemsHotbarColumns" type="int32" value="2"/>
                    <attribute id="LearningStrategy" type="uint8" value="1"/>
                    <attribute id="MustPrepareSpells" type="bool" value="false"/>
                    <attribute id="Name" type="FixedString" value="ArmsWarrior"/>
                    <attribute id="ParentGuid" type="guid" value="78fe4967-4e62-5491-d981-dd781acca4d7"/>
                    <attribute id="PrimaryAbility" type="uint8" value="1"/>
                    <attribute id="ProgressionTableUUID" type="guid" value="[UUID_2_ARMS]"/>
                    <attribute id="SoundClassType" type="FixedString" value="Barbarian"/>
                    <attribute id="SpellCastingAbility" type="uint8" value="1"/>
                    <attribute id="SpellList" type="guid" value="32879c22-4858-48ef-8f8d-22e6d395b396"/>
                    <attribute id="UUID" type="guid" value="[UUID_ARMS_CLASS]"/>
                    <children>
                        <node id="Tags">
                            <attribute id="Object" type="guid" value="5804f55a-93f7-4281-9512-8d548a9e2a22"/>
                        </node>
                    </children>
                </node>

                <!-- ========== NODE 3: FURY WARRIOR (SUBCLASS) ========== -->
                <node id="ClassDescription">
                    <attribute id="BaseHp" type="int32" value="5"/>
                    <attribute id="HpPerLevel" type="int32" value="5"/>
                    <attribute id="Name" type="FixedString" value="FuryWarrior"/>
                    <attribute id="ParentGuid" type="guid" value="78fe4967-4e62-5491-d981-dd781acca4d7"/>
                    <attribute id="ProgressionTableUUID" type="guid" value="[UUID_3_FURY]"/>
                    <attribute id="SpellList" type="guid" value="32879c22-4858-48ef-8f8d-22e6d395b396"/>
                    <attribute id="UUID" type="guid" value="[UUID_FURY_CLASS]"/>
                    <!-- ... other attributes same as Arms ... -->
                </node>

                <!-- ========== NODE 4: PROTECTION WARRIOR (SUBCLASS) ========== -->
                <node id="ClassDescription">
                    <attribute id="BaseHp" type="int32" value="7"/>
                    <attribute id="HpPerLevel" type="int32" value="7"/>
                    <attribute id="Name" type="FixedString" value="ProtectionWarrior"/>
                    <attribute id="ParentGuid" type="guid" value="78fe4967-4e62-5491-d981-dd781acca4d7"/>
                    <attribute id="ProgressionTableUUID" type="guid" value="[UUID_4_PROTECTION]"/>
                    <attribute id="SpellList" type="guid" value="32879c22-4858-48ef-8f8d-22e6d395b396"/>
                    <attribute id="UUID" type="guid" value="[UUID_PROTECTION_CLASS]"/>
                    <!-- ... other attributes same as Arms ... -->
                </node>

                <!-- ========== NODE 5: MOUNTAIN THANE (HERO TALENT) ========== -->
                <node id="ClassDescription">
                    <attribute id="CharacterCreationPose" type="guid" value="0f07ec6e-4ef0-434e-9a51-1353260ccff8"/>
                    <attribute id="Description" type="TranslatedString" handle="h[MOUNTAINTHANE_DESC]" version="1"/>
                    <attribute id="DisplayName" type="TranslatedString" handle="h[MOUNTAINTHANE_NAME]" version="1"/>
                    <attribute id="LearningStrategy" type="uint8" value="1"/>
                    <attribute id="Name" type="FixedString" value="MountainThane"/>
                    <attribute id="ParentGuid" type="guid" value="78fe4967-4e62-5491-d981-dd781acca4d7"/>
                    <attribute id="PrimaryAbility" type="uint8" value="1"/>
                    <attribute id="ProgressionTableUUID" type="guid" value="[UUID_5_MOUNTAINTHANE]"/>
                    <attribute id="SoundClassType" type="FixedString" value="Barbarian"/>
                    <attribute id="SpellCastingAbility" type="uint8" value="1"/>
                    <attribute id="SpellList" type="guid" value="32879c22-4858-48ef-8f8d-22e6d395b396"/>
                    <attribute id="UUID" type="guid" value="[UUID_MOUNTAINTHANE_CLASS]"/>
                    <children>
                        <node id="Tags">
                            <attribute id="Object" type="guid" value="5804f55a-93f7-4281-9512-8d548a9e2a22"/>
                        </node>
                    </children>
                </node>

                <!-- ========== NODE 6: COLOSSUS (HERO TALENT) ========== -->
                <node id="ClassDescription">
                    <attribute id="Name" type="FixedString" value="Colossus"/>
                    <attribute id="ParentGuid" type="guid" value="78fe4967-4e62-5491-d981-dd781acca4d7"/>
                    <attribute id="ProgressionTableUUID" type="guid" value="[UUID_6_COLOSSUS]"/>
                    <attribute id="SpellList" type="guid" value="32879c22-4858-48ef-8f8d-22e6d395b396"/>
                    <attribute id="UUID" type="guid" value="[UUID_COLOSSUS_CLASS]"/>
                    <!-- ... other attributes same as Mountain Thane ... -->
                </node>

                <!-- ========== NODE 7: SLAYER (HERO TALENT) ========== -->
                <node id="ClassDescription">
                    <attribute id="Name" type="FixedString" value="Slayer"/>
                    <attribute id="ParentGuid" type="guid" value="78fe4967-4e62-5491-d981-dd781acca4d7"/>
                    <attribute id="ProgressionTableUUID" type="guid" value="[UUID_7_SLAYER]"/>
                    <attribute id="SpellList" type="guid" value="32879c22-4858-48ef-8f8d-22e6d395b396"/>
                    <attribute id="UUID" type="guid" value="[UUID_SLAYER_CLASS]"/>
                    <!-- ... other attributes same as Mountain Thane ... -->
                </node>

            </children>
        </node>
    </region>
</save>
```

---

## 📋 UUID Reference Table

| Node | Name | UUID Type | Purpose |
|------|------|-----------|---------|
| **1** | WoWWarrior | `78fe4967-4e62-5491-d981-dd781acca4d7` | Base class UUID (FIXED) |
| **1** | WoWWarrior | `[UUID_1_BASE_WARRIOR]` | Base class ProgressionTableUUID |
| **2** | ArmsWarrior | `[UUID_ARMS_CLASS]` | Arms ClassDescription UUID |
| **2** | ArmsWarrior | `[UUID_2_ARMS]` | Arms ProgressionTableUUID |
| **3** | FuryWarrior | `[UUID_FURY_CLASS]` | Fury ClassDescription UUID |
| **3** | FuryWarrior | `[UUID_3_FURY]` | Fury ProgressionTableUUID |
| **4** | ProtectionWarrior | `[UUID_PROTECTION_CLASS]` | Protection ClassDescription UUID |
| **4** | ProtectionWarrior | `[UUID_4_PROTECTION]` | Protection ProgressionTableUUID |
| **5** | MountainThane | `[UUID_MOUNTAINTHANE_CLASS]` | Mountain Thane ClassDescription UUID |
| **5** | MountainThane | `[UUID_5_MOUNTAINTHANE]` | Mountain Thane ProgressionTableUUID |
| **6** | Colossus | `[UUID_COLOSSUS_CLASS]` | Colossus ClassDescription UUID |
| **6** | Colossus | `[UUID_6_COLOSSUS]` | Colossus ProgressionTableUUID |
| **7** | Slayer | `[UUID_SLAYER_CLASS]` | Slayer ClassDescription UUID |
| **7** | Slayer | `[UUID_7_SLAYER]` | Slayer ProgressionTableUUID |

**SpellList UUID**: `32879c22-4858-48ef-8f8d-22e6d395b396` (shared by all nodes, dummy UUID)

**Total Unique UUIDs Needed**: **14** (7 ClassDescription + 7 ProgressionTableUUID)

---

## 📚 Progressions.lsx Structure (L1-L20)

### File: `Progressions/Progressions.lsx`

```xml
<?xml version="1.0" encoding="UTF-8"?>
<save>
    <version major="4" minor="8" revision="0" build="500"/>
    <region id="Progressions">
        <node id="root">
            <children>

                <!-- ==================== TABLE 1: BASE WARRIOR (L1-L20) ==================== -->
                
                <!-- ========== LEVEL 1 ========== -->
                <node id="Progression">
                    <attribute id="Level" type="uint8" value="1"/>
                    <attribute id="Name" type="LSString" value="WoWWarrior"/>
                    <attribute id="PassivesAdded" type="LSString" value="WAR_RageGeneration;WAR_HeavyArmorProficiency"/>
                    <attribute id="ProgressionType" type="uint8" value="0"/>
                    <attribute id="TableUUID" type="guid" value="[UUID_1_BASE_WARRIOR]"/>
                    <attribute id="UUID" type="guid" value="[UNIQUE_UUID]"/>
                    <children>
                        <node id="SubClasses">
                            <children>
                                <node id="SubClass">
                                    <attribute id="Object" type="guid" value="[UUID_ARMS_CLASS]"/>
                                </node>
                                <node id="SubClass">
                                    <attribute id="Object" type="guid" value="[UUID_FURY_CLASS]"/>
                                </node>
                                <node id="SubClass">
                                    <attribute id="Object" type="guid" value="[UUID_PROTECTION_CLASS]"/>
                                </node>
                            </children>
                        </node>
                    </children>
                </node>

                <!-- Multiclass variant (IsMulticlass=true) -->
                <node id="Progression">
                    <attribute id="IsMulticlass" type="bool" value="true"/>
                    <attribute id="Level" type="uint8" value="1"/>
                    <attribute id="Name" type="LSString" value="WoWWarrior"/>
                    <attribute id="PassivesAdded" type="LSString" value="WAR_RageGeneration;WAR_HeavyArmorProficiency"/>
                    <attribute id="ProgressionType" type="uint8" value="0"/>
                    <attribute id="TableUUID" type="guid" value="[UUID_1_BASE_WARRIOR]"/>
                    <attribute id="UUID" type="guid" value="[UNIQUE_UUID]"/>
                    <children>
                        <node id="SubClasses">
                            <!-- Same subclasses -->
                        </node>
                    </children>
                </node>

                <!-- ========== LEVEL 2 ========== -->
                <node id="Progression">
                    <attribute id="Level" type="uint8" value="2"/>
                    <attribute id="Name" type="LSString" value="WoWWarrior"/>
                    <attribute id="ProgressionType" type="uint8" value="0"/>
                    <attribute id="Selectors" type="LSString" value="SelectPassives([SELECTOR_UUID],1,WarriorClassTalentRow2)"/>
                    <attribute id="TableUUID" type="guid" value="[UUID_1_BASE_WARRIOR]"/>
                    <attribute id="UUID" type="guid" value="[UNIQUE_UUID]"/>
                </node>

                <!-- ========== LEVEL 3 ========== -->
                <node id="Progression">
                    <attribute id="Level" type="uint8" value="3"/>
                    <attribute id="Name" type="LSString" value="WoWWarrior"/>
                    <attribute id="ProgressionType" type="uint8" value="0"/>
                    <attribute id="Selectors" type="LSString" value="SelectPassives([SELECTOR_UUID],1,WarriorClassTalentRow3)"/>
                    <attribute id="TableUUID" type="guid" value="[UUID_1_BASE_WARRIOR]"/>
                    <attribute id="UUID" type="guid" value="[UNIQUE_UUID]"/>
                </node>

                <!-- ========== LEVEL 4 (FEAT) ========== -->
                <node id="Progression">
                    <attribute id="AllowImprovement" type="bool" value="true"/>
                    <attribute id="Level" type="uint8" value="4"/>
                    <attribute id="Name" type="LSString" value="WoWWarrior"/>
                    <attribute id="ProgressionType" type="uint8" value="0"/>
                    <attribute id="Selectors" type="LSString" value="SelectPassives([SELECTOR_UUID],1,WarriorClassTalentRow4)"/>
                    <attribute id="TableUUID" type="guid" value="[UUID_1_BASE_WARRIOR]"/>
                    <attribute id="UUID" type="guid" value="[UNIQUE_UUID]"/>
                </node>

                <!-- ========== LEVEL 5 (EXTRA ATTACK) ========== -->
                <node id="Progression">
                    <attribute id="Level" type="uint8" value="5"/>
                    <attribute id="Name" type="LSString" value="WoWWarrior"/>
                    <attribute id="Boosts" type="LSString" value="ActionResource(Movement,3,0);ActionResource(BonusActionPoint,1,0)"/>
                    <attribute id="PassivesAdded" type="LSString" value="ExtraAttack"/>
                    <attribute id="ProgressionType" type="uint8" value="0"/>
                    <attribute id="Selectors" type="LSString" value="SelectPassives([SELECTOR_UUID],1,WarriorClassTalentRow5)"/>
                    <attribute id="TableUUID" type="guid" value="[UUID_1_BASE_WARRIOR]"/>
                    <attribute id="UUID" type="guid" value="[UNIQUE_UUID]"/>
                </node>

                <!-- ========== LEVELS 6-12 (Similar pattern) ========== -->
                <!-- L6: Row 6 talent choice -->
                <!-- L7: Row 7 talent choice -->
                <!-- L8: Row 8 talent choice + Feat -->
                <!-- L9: Row 9 talent choice -->
                <!-- L10: Row 10 talent choice -->
                <!-- L11: Empty (subclass grants baseline ability) -->
                <!-- L12: Feat only -->

                <!-- ========== LEVEL 13 (HERO TALENT SELECTION) ========== -->
                <node id="Progression">
                    <attribute id="Level" type="uint8" value="13"/>
                    <attribute id="Name" type="LSString" value="WoWWarrior"/>
                    <attribute id="ProgressionType" type="uint8" value="0"/>
                    <attribute id="TableUUID" type="guid" value="[UUID_1_BASE_WARRIOR]"/>
                    <attribute id="UUID" type="guid" value="[UNIQUE_UUID]"/>
                    <children>
                        <node id="SubClasses">
                            <children>
                                <!-- Present hero talent options based on which subclass was chosen at L1 -->
                                <!-- If Arms: Show Colossus + Slayer -->
                                <!-- If Fury: Show Mountain Thane + Slayer -->
                                <!-- If Protection: Show Mountain Thane + Colossus -->
                                <node id="SubClass">
                                    <attribute id="Object" type="guid" value="[UUID_MOUNTAINTHANE_CLASS]"/>
                                </node>
                                <node id="SubClass">
                                    <attribute id="Object" type="guid" value="[UUID_COLOSSUS_CLASS]"/>
                                </node>
                                <node id="SubClass">
                                    <attribute id="Object" type="guid" value="[UUID_SLAYER_CLASS]"/>
                                </node>
                            </children>
                        </node>
                    </children>
                </node>

                <!-- ========== LEVELS 14-20 ========== -->
                <!-- L14: Empty -->
                <!-- L15: Empty (hero talents grant) -->
                <!-- L16: Feat -->
                <!-- L17: Empty (hero talents grant) -->
                <!-- L18: Empty -->
                <!-- L19: Empty (hero talents grant) -->
                <!-- L20: Feat -->

                <node id="Progression">
                    <attribute id="Level" type="uint8" value="14"/>
                    <attribute id="Name" type="LSString" value="WoWWarrior"/>
                    <attribute id="ProgressionType" type="uint8" value="0"/>
                    <attribute id="TableUUID" type="guid" value="[UUID_1_BASE_WARRIOR]"/>
                    <attribute id="UUID" type="guid" value="[UNIQUE_UUID]"/>
                </node>

                <node id="Progression">
                    <attribute id="Level" type="uint8" value="15"/>
                    <attribute id="Name" type="LSString" value="WoWWarrior"/>
                    <attribute id="ProgressionType" type="uint8" value="0"/>
                    <attribute id="TableUUID" type="guid" value="[UUID_1_BASE_WARRIOR]"/>
                    <attribute id="UUID" type="guid" value="[UNIQUE_UUID]"/>
                </node>

                <node id="Progression">
                    <attribute id="AllowImprovement" type="bool" value="true"/>
                    <attribute id="Level" type="uint8" value="16"/>
                    <attribute id="Name" type="LSString" value="WoWWarrior"/>
                    <attribute id="ProgressionType" type="uint8" value="0"/>
                    <attribute id="TableUUID" type="guid" value="[UUID_1_BASE_WARRIOR]"/>
                    <attribute id="UUID" type="guid" value="[UNIQUE_UUID]"/>
                </node>

                <!-- L17-L20 similar pattern -->

                <!-- ==================== TABLE 2: ARMS WARRIOR (L1-L12) ==================== -->

                <!-- ========== LEVEL 1 ========== -->
                <node id="Progression">
                    <attribute id="Level" type="uint8" value="1"/>
                    <attribute id="Name" type="LSString" value="ArmsWarrior"/>
                    <attribute id="PassivesAdded" type="LSString" value="WAR_Arms_DeepWounds;WAR_Arms_TwoHandedSpecialization"/>
                    <attribute id="ProgressionType" type="uint8" value="1"/>
                    <attribute id="Selectors" type="LSString" value="AddSpells([SPELLLIST_UUID])"/>
                    <attribute id="TableUUID" type="guid" value="[UUID_2_ARMS]"/>
                    <attribute id="UUID" type="guid" value="[UNIQUE_UUID]"/>
                </node>

                <!-- ========== LEVEL 2 ========== -->
                <node id="Progression">
                    <attribute id="Level" type="uint8" value="2"/>
                    <attribute id="Name" type="LSString" value="ArmsWarrior"/>
                    <attribute id="ProgressionType" type="uint8" value="1"/>
                    <attribute id="Selectors" type="LSString" value="AddSpells([SPELLLIST_UUID]);SelectPassives([SELECTOR_UUID],1,ArmsSpecTalentRow2)"/>
                    <attribute id="TableUUID" type="guid" value="[UUID_2_ARMS]"/>
                    <attribute id="UUID" type="guid" value="[UNIQUE_UUID]"/>
                </node>

                <!-- ========== LEVEL 3 ========== -->
                <node id="Progression">
                    <attribute id="Level" type="uint8" value="3"/>
                    <attribute id="Name" type="LSString" value="ArmsWarrior"/>
                    <attribute id="PassivesAdded" type="LSString" value="WAR_Arms_MortalStrike_Unlock"/>
                    <attribute id="ProgressionType" type="uint8" value="1"/>
                    <attribute id="Selectors" type="LSString" value="AddSpells([SPELLLIST_UUID]);SelectPassives([SELECTOR_UUID],1,ArmsSpecTalentRow3)"/>
                    <attribute id="TableUUID" type="guid" value="[UUID_2_ARMS]"/>
                    <attribute id="UUID" type="guid" value="[UNIQUE_UUID]"/>
                </node>

                <!-- LEVELS 4-12 continue with Arms-specific progression -->
                <!-- L4: Row 4 choice + baseline ability -->
                <!-- L5: Row 5 choice + baseline ability (Overpower) -->
                <!-- L6: Row 6 choice -->
                <!-- L7: Row 7 choice + baseline ability (Colossus Smash) -->
                <!-- L8: Row 8 choice -->
                <!-- L9: Row 9 choice + baseline ability (Execute) -->
                <!-- L10: Row 10 choice + baseline ability (Hamstring) -->
                <!-- L11: Row 11 choice + baseline ability (Heroic Throw) -->
                <!-- L12: Row 12 choice + baseline ability (Shield Slam) -->

                <!-- ==================== TABLE 3: FURY WARRIOR (L1-L12) ==================== -->

                <!-- Similar structure to Arms, but with Fury-specific content -->
                <node id="Progression">
                    <attribute id="Level" type="uint8" value="1"/>
                    <attribute id="Name" type="LSString" value="FuryWarrior"/>
                    <attribute id="PassivesAdded" type="LSString" value="WAR_Fury_BerserkerRage;WAR_Fury_DualWielding"/>
                    <attribute id="ProgressionType" type="uint8" value="1"/>
                    <attribute id="TableUUID" type="guid" value="[UUID_3_FURY]"/>
                    <attribute id="UUID" type="guid" value="[UNIQUE_UUID]"/>
                </node>

                <!-- LEVELS 2-12 for Fury -->

                <!-- ==================== TABLE 4: PROTECTION WARRIOR (L1-L12) ==================== -->

                <!-- Similar structure, but with Protection-specific content -->
                <node id="Progression">
                    <attribute id="Level" type="uint8" value="1"/>
                    <attribute id="Name" type="LSString" value="ProtectionWarrior"/>
                    <attribute id="PassivesAdded" type="LSString" value="WAR_Protection_ShieldSpecialization;WAR_Protection_Riposte"/>
                    <attribute id="ProgressionType" type="uint8" value="1"/>
                    <attribute id="TableUUID" type="guid" value="[UUID_4_PROTECTION]"/>
                    <attribute id="UUID" type="guid" value="[UNIQUE_UUID]"/>
                </node>

                <!-- LEVELS 2-12 for Protection -->

                <!-- ==================== TABLE 5: MOUNTAIN THANE (L13-L20) ==================== -->

                <!-- ========== LEVEL 13 (KEYSTONE) ========== -->
                <node id="Progression">
                    <attribute id="Level" type="uint8" value="13"/>
                    <attribute id="Name" type="LSString" value="MountainThane"/>
                    <attribute id="PassivesAdded" type="LSString" value="WAR_MountainThane_LightningStrikes"/>
                    <attribute id="ProgressionType" type="uint8" value="1"/>
                    <attribute id="TableUUID" type="guid" value="[UUID_5_MOUNTAINTHANE]"/>
                    <attribute id="UUID" type="guid" value="[UNIQUE_UUID]"/>
                </node>

                <!-- ========== LEVEL 14 (EMPTY) ========== -->
                <node id="Progression">
                    <attribute id="Level" type="uint8" value="14"/>
                    <attribute id="Name" type="LSString" value="MountainThane"/>
                    <attribute id="ProgressionType" type="uint8" value="1"/>
                    <attribute id="TableUUID" type="guid" value="[UUID_5_MOUNTAINTHANE]"/>
                    <attribute id="UUID" type="guid" value="[UNIQUE_UUID]"/>
                </node>

                <!-- ========== LEVEL 15 (3 TALENTS) ========== -->
                <node id="Progression">
                    <attribute id="Level" type="uint8" value="15"/>
                    <attribute id="Name" type="LSString" value="MountainThane"/>
                    <attribute id="PassivesAdded" type="LSString" value="WAR_MountainThane_CrashingThunder;WAR_MountainThane_GroundCurrent;WAR_MountainThane_StrengthOfMountain"/>
                    <attribute id="ProgressionType" type="uint8" value="1"/>
                    <attribute id="TableUUID" type="guid" value="[UUID_5_MOUNTAINTHANE]"/>
                    <attribute id="UUID" type="guid" value="[UNIQUE_UUID]"/>
                </node>

                <!-- ========== LEVEL 16 (EMPTY) ========== -->
                <node id="Progression">
                    <attribute id="Level" type="uint8" value="16"/>
                    <attribute id="Name" type="LSString" value="MountainThane"/>
                    <attribute id="ProgressionType" type="uint8" value="1"/>
                    <attribute id="TableUUID" type="guid" value="[UUID_5_MOUNTAINTHANE]"/>
                    <attribute id="UUID" type="guid" value="[UNIQUE_UUID]"/>
                </node>

                <!-- ========== LEVEL 17 (3 TALENTS) ========== -->
                <node id="Progression">
                    <attribute id="Level" type="uint8" value="17"/>
                    <attribute id="Name" type="LSString" value="MountainThane"/>
                    <attribute id="PassivesAdded" type="LSString" value="WAR_MountainThane_ThunderBlast;WAR_MountainThane_StormBolts;WAR_MountainThane_KeepFeetOnGround"/>
                    <attribute id="ProgressionType" type="uint8" value="1"/>
                    <attribute id="TableUUID" type="guid" value="[UUID_5_MOUNTAINTHANE]"/>
                    <attribute id="UUID" type="guid" value="[UNIQUE_UUID]"/>
                </node>

                <!-- ========== LEVEL 18 (EMPTY) ========== -->
                <node id="Progression">
                    <attribute id="Level" type="uint8" value="18"/>
                    <attribute id="Name" type="LSString" value="MountainThane"/>
                    <attribute id="ProgressionType" type="uint8" value="1"/>
                    <attribute id="TableUUID" type="guid" value="[UUID_5_MOUNTAINTHANE]"/>
                    <attribute id="UUID" type="guid" value="[UNIQUE_UUID]"/>
                </node>

                <!-- ========== LEVEL 19 (3 TALENTS) ========== -->
                <node id="Progression">
                    <attribute id="Level" type="uint8" value="19"/>
                    <attribute id="Name" type="LSString" value="MountainThane"/>
                    <attribute id="PassivesAdded" type="LSString" value="WAR_MountainThane_FlashingSkies;WAR_MountainThane_ThorimsMight;WAR_MountainThane_BurstOfPower"/>
                    <attribute id="ProgressionType" type="uint8" value="1"/>
                    <attribute id="TableUUID" type="guid" value="[UUID_5_MOUNTAINTHANE]"/>
                    <attribute id="UUID" type="guid" value="[UNIQUE_UUID]"/>
                </node>

                <!-- ========== LEVEL 20 (CAPSTONE) ========== -->
                <node id="Progression">
                    <attribute id="Level" type="uint8" value="20"/>
                    <attribute id="Name" type="LSString" value="MountainThane"/>
                    <attribute id="PassivesAdded" type="LSString" value="WAR_MountainThane_AvatarOfStorm"/>
                    <attribute id="ProgressionType" type="uint8" value="1"/>
                    <attribute id="TableUUID" type="guid" value="[UUID_5_MOUNTAINTHANE]"/>
                    <attribute id="UUID" type="guid" value="[UNIQUE_UUID]"/>
                </node>

                <!-- ==================== TABLE 6: COLOSSUS (L13-L20) ==================== -->

                <!-- Same pattern as Mountain Thane, but with Colossus passives -->
                <node id="Progression">
                    <attribute id="Level" type="uint8" value="13"/>
                    <attribute id="Name" type="LSString" value="Colossus"/>
                    <attribute id="PassivesAdded" type="LSString" value="WAR_Colossus_Demolish"/>
                    <attribute id="ProgressionType" type="uint8" value="1"/>
                    <attribute id="TableUUID" type="guid" value="[UUID_6_COLOSSUS]"/>
                    <attribute id="UUID" type="guid" value="[UNIQUE_UUID]"/>
                </node>

                <!-- LEVELS 14-20 for Colossus -->

                <!-- ==================== TABLE 7: SLAYER (L13-L20) ==================== -->

                <!-- Same pattern as Mountain Thane, but with Slayer passives -->
                <node id="Progression">
                    <attribute id="Level" type="uint8" value="13"/>
                    <attribute id="Name" type="LSString" value="Slayer"/>
                    <attribute id="PassivesAdded" type="LSString" value="WAR_Slayer_SlayersDominance"/>
                    <attribute id="ProgressionType" type="uint8" value="1"/>
                    <attribute id="TableUUID" type="guid" value="[UUID_7_SLAYER]"/>
                    <attribute id="UUID" type="guid" value="[UNIQUE_UUID]"/>
                </node>

                <!-- LEVELS 14-20 for Slayer -->

            </children>
        </node>
    </region>
</save>
```

---

## 📊 Progression Node Count by Table

| Table | Name | Levels | Nodes per Level | Total Nodes | Notes |
|-------|------|--------|----------------|-------------|-------|
| **1** | WoWWarrior (Base) | L1-L20 | 1-2 | ~25 | 2 nodes at L1 (normal + multiclass) |
| **2** | ArmsWarrior | L1-L12 | 1 | ~12 | Subclass progression |
| **3** | FuryWarrior | L1-L12 | 1 | ~12 | Subclass progression |
| **4** | ProtectionWarrior | L1-L12 | 1 | ~12 | Subclass progression |
| **5** | MountainThane | L13-L20 | 1 | ~8 | Hero talent progression |
| **6** | Colossus | L13-L20 | 1 | ~8 | Hero talent progression |
| **7** | Slayer | L13-L20 | 1 | ~8 | Hero talent progression |
| | | | **TOTAL** | **~85-90 nodes** | |

---

## 🎯 SpellList Analysis

### How Many SpellLists?

**Answer: 1 (Dummy UUID)**

**SpellList UUID**: `32879c22-4858-48ef-8f8d-22e6d395b396`

**Used By**:
- ✅ WoWWarrior (base class)
- ✅ ArmsWarrior (subclass)
- ✅ FuryWarrior (subclass)
- ✅ ProtectionWarrior (subclass)
- ✅ MountainThane (hero talent)
- ✅ Colossus (hero talent)
- ✅ Slayer (hero talent)

**Why Only 1?**

Based on Warlock precedent:
- The SpellList UUID is a **dummy/placeholder** reference
- It's NEVER actually defined in `Lists/SpellLists.lsx`
- BG3 doesn't require actual SpellList implementation for custom classes
- All 7 nodes share the same dummy UUID
- Proven to work in WoWWarlock mod (13K+ downloads)

**Do We Define It?**

**NO!** Leave it undefined. The UUID is just a reference placeholder.

---

## 📋 Complete Level-by-Level Progression Summary

### Base Class (WoWWarrior)

| Level | Grants | Class Talents | Subclass Selection | Hero Talent Selection |
|-------|--------|---------------|-------------------|----------------------|
| **L1** | Rage, Heavy Armor | Auto (Charge, Heroic Strike) | Pick Arms/Fury/Protection | - |
| **L2** | - | Row 2 (1 choice) | - | - |
| **L3** | - | Row 3 (1 choice) | - | - |
| **L4** | Feat/ASI | Row 4 (1 choice) | - | - |
| **L5** | Extra Attack, Movement +3 | Row 5 (1 choice) | - | - |
| **L6** | - | Row 6 (1 choice) | - | - |
| **L7** | - | Row 7 (1 choice) | - | - |
| **L8** | Feat/ASI | Row 8 (1 choice) | - | - |
| **L9** | - | Row 9 (1 choice) | - | - |
| **L10** | - | Row 10 (1 choice) | - | - |
| **L11** | - | - | - | - |
| **L12** | Feat/ASI | - | - | - |
| **L13** | - | - | - | Pick Mountain Thane/Colossus/Slayer |
| **L14** | - | - | - | - |
| **L15** | - | - | - | - |
| **L16** | Feat/ASI | - | - | - |
| **L17** | - | - | - | - |
| **L18** | - | - | - | - |
| **L19** | - | - | - | - |
| **L20** | Feat/ASI | - | - | - |

**Total Class Talent Choices**: 9 (Rows 2-10)  
**Total Feats/ASI**: 5 (L4, L8, L12, L16, L20)

---

### Subclass Example: Arms Warrior

| Level | Baseline Abilities | Spec Talents | Notes |
|-------|-------------------|--------------|-------|
| **L1** | Deep Wounds, 2H Specialization | Auto-grant | Subclass identity |
| **L2** | Battle Shout | Row 2 (1 choice) | First spec talent choice |
| **L3** | Mortal Strike | Row 3 (1 choice) | Signature ability |
| **L4** | Slam | Row 4 (1 choice) | - |
| **L5** | Overpower | Row 5 (1 choice) | - |
| **L6** | Pummel | Row 6 (1 choice) | - |
| **L7** | Colossus Smash | Row 7 (1 choice) | Big ability |
| **L8** | Thunder Clap | Row 8 (1 choice) | - |
| **L9** | Execute | Row 9 (1 choice) | - |
| **L10** | Hamstring | Row 10 (1 choice) | - |
| **L11** | Heroic Throw | - | Auto-grant |
| **L12** | Shield Slam | - | Auto-grant |

**Total Baseline Abilities**: 15 (12 different abilities)  
**Total Spec Talent Choices**: 9 (Rows 2-10)

---

### Hero Talent Example: Mountain Thane

| Level | Talents Granted | Count |
|-------|----------------|-------|
| **L13** | Lightning Strikes (Keystone) | 1 |
| **L14** | - | 0 |
| **L15** | Crashing Thunder, Ground Current, Strength of Mountain | 3 |
| **L16** | - | 0 |
| **L17** | Thunder Blast, Storm Bolts, Keep Feet on Ground | 3 |
| **L18** | - | 0 |
| **L19** | Flashing Skies, Thorim's Might, Burst of Power | 3 |
| **L20** | Avatar of Storm (Capstone) | 1 |

**Total Talents**: 11 (1 + 3 + 3 + 3 + 1)  
**Player Choices**: 0 (all auto-granted after L13 selection)

---

## 🎯 Implementation Checklist

### ClassDescriptions.lsx
- [ ] ✅ 7 ClassDescription nodes created
- [ ] ✅ All nodes use same SpellList UUID (`32879c22...`)
- [ ] ✅ Each node has unique ProgressionTableUUID (7 total)
- [ ] ✅ Subclasses have ParentGuid = base Warrior UUID
- [ ] ✅ Hero talents have ParentGuid = base Warrior UUID
- [ ] ✅ HP per level differentiated (Arms=6, Fury=5, Protection=7)

### Progressions.lsx
- [ ] ✅ 7 progression tables (one per ProgressionTableUUID)
- [ ] ✅ Base Warrior: L1-L20 (~25 nodes)
- [ ] ✅ Arms/Fury/Protection: L1-L12 (~12 nodes each)
- [ ] ✅ Mountain Thane/Colossus/Slayer: L13-L20 (~8 nodes each)
- [ ] ✅ L1 base class presents 3 subclass options
- [ ] ✅ L13 base class presents 2-3 hero talent options (based on subclass)
- [ ] ✅ Hero talents grant at L13, L15, L17, L19, L20
- [ ] ✅ Empty levels (L14, L16, L18) have progression nodes (for proper level tracking)

### SpellLists.lsx
- [ ] ✅ **DO NOT CREATE** - Use dummy UUID only
- [ ] ✅ Confirmed UUID `32879c22...` in all ClassDescription nodes

---

## 📊 File Size Estimates

| File | Nodes | Estimated Lines | Size |
|------|-------|----------------|------|
| **ClassDescriptions.lsx** | 7 | ~400-500 | Small |
| **Progressions.lsx** | ~85-90 | ~3,000-4,000 | Medium |
| **SpellLists.lsx** | 0 | N/A | Not created |

**Total**: ClassDescriptions.lsx (~500 lines) + Progressions.lsx (~3,500 lines) = ~4,000 lines

---

**Last Updated**: October 20, 2025  
**Status**: ✅ Complete structure defined - Ready for implementation  
**Next Step**: Generate actual UUIDs and create progression nodes from Excel data
