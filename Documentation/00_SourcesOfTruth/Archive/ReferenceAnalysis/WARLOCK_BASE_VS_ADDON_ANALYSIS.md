# Warlock Mod Analysis: Base vs Hero Talents

**Created**: October 20, 2025  
**Purpose**: Analyze the relationship between WoWWarlock base mod and Hero Talents addon  
**Key Discovery**: ⚠️ **TWO SEPARATE MODS** - Hero Talents is an ADDON, not part of base progression

---

## 🎯 Executive Summary

| Mod | UUID | Levels | Purpose | ClassDescriptions |
|-----|------|--------|---------|-------------------|
| **Base WoWWarlock** | `bdb3fa73...` | L1-L13 | Core class (3 subclasses) | 4 nodes (1 base + 3 subclasses) |
| **Hero Talents Addon** | `5c6e0bb5...` | L1-L8 (hero talent levels) | **OPTIONAL** hero talent system | 7 nodes (1 base + 6 hero talents) |

**Critical Finding**: The Hero Talents mod is a **DEPENDENCY-BASED ADDON** that requires the base Warlock mod, NOT an integrated L13-L20 system!

---

## 📊 Base WoWWarlock Mod Analysis

### File Structure
```
Tests/02_ExampleMods/ExampleMod_WoWWarlock/
├── Mods/Warlock_WoW_bdb3fa73.../
│   └── meta.lsx (base mod metadata)
└── Public/Warlock_WoW_bdb3fa73.../
    ├── ClassDescriptions/ClassDescriptions.lsx (4 nodes)
    ├── Progressions/Progressions.lsx (L1-L13, 50 nodes)
    ├── Stats/
    └── Lists/
```

### ClassDescriptions.lsx (4 nodes)

1. **WoWWarlock** (Base Class)
   - UUID: `a417135a-918e-4acf-9ab9-e1e72ef50afb`
   - ProgressionTableUUID: `95fff39d-c6ae-4a85-a0d8-98553fb5bd8e`

2. **Demonology** (Subclass)
   - UUID: `6e4f6936-18e7-4981-8b26-4ad249c71164` (ProgressionTableUUID)
   - ParentGuid: `a417135a...` (base class)

3. **Destruction** (Subclass)
   - ParentGuid: `a417135a...` (base class)

4. **Affliction** (Subclass)
   - ParentGuid: `a417135a...` (base class)

**Pattern**: Standard 1 base + 3 subclasses

---

### Progressions.lsx Analysis

**Level Range**: L1-L13

#### Base Class (WoWWarlock) Progression

```xml
<!-- L1: Initial grants -->
<node id="Progression">
    <attribute id="Level" type="uint8" value="1"/>
    <attribute id="Name" type="LSString" value="WoWWarlock"/>
    <attribute id="PassivesAdded" type="LSString" value="WoWWarlock_Unlock_SoulShard;WoWWarlock_BlackHarvest"/>
</node>

<!-- L2: Passives + talent choices -->
<node id="Progression">
    <attribute id="Level" type="uint8" value="2"/>
    <attribute id="Name" type="LSString" value="WoWWarlock"/>
    <attribute id="Selectors" type="LSString" value="AddSpells(...);SelectPassives(...,1,WarlockClassTalentRow1);SelectPassives(...,1,WarlockClassTalentRow2)"/>
</node>

<!-- L3-L12: Similar pattern with SelectPassives -->
<!-- L13: EMPTY (just placeholder) -->
<node id="Progression">
    <attribute id="Level" type="uint8" value="13"/>
    <attribute id="Name" type="LSString" value="WoWWarlock"/>
    <attribute id="ProgressionType" type="uint8" value="0"/>
    <attribute id="TableUUID" type="guid" value="95fff39d-c6ae-4a85-a0d8-98553fb5bd8e"/>
    <attribute id="UUID" type="guid" value="c070ff6b-0eaa-4eaf-b900-d841e0d6c5a0"/>
</node>
```

**Key Observation**: L13 is **EMPTY** in base mod (no abilities, passives, or choices)

#### Subclass (Demonology) Progression

```xml
<!-- L1: Subclass identity + passives -->
<node id="Progression">
    <attribute id="Level" type="uint8" value="1"/>
    <attribute id="Name" type="LSString" value="Demonology"/>
    <attribute id="PassivesAdded" type="LSString" value="WoWWarlock_Demo"/>
    <attribute id="Selectors" type="LSString" value="AddSpells(aedc2c38...)"/>
</node>

<!-- L2: More passives -->
<node id="Progression">
    <attribute id="Level" type="uint8" value="2"/>
    <attribute id="Name" type="LSString" value="Demonology"/>
    <attribute id="PassivesAdded" type="LSString" value="WoWWarlock_Demo_SouLeech_Shadowbolt;WoWWarlock_Demo_SouLeech_HandOfGuldan;..."/>
</node>

<!-- L3: Talent choices -->
<node id="Progression">
    <attribute id="Level" type="uint8" value="3"/>
    <attribute id="Name" type="LSString" value="Demonology"/>
    <attribute id="Selectors" type="LSString" value="AddSpells(...);SelectPassives(...,1,WarlockDemoTalentRow1);SelectPassives(...,1,WarlockDemoTalentRow2);SelectPassives(...,1,WarlockDemoTalentRow3)"/>
</node>

<!-- L4-L12: More auto-grants and talent rows -->
```

**Pattern**: L1-L12 full progression with talent choices

**No L13-L20 in base mod!**

---

## 📊 Hero Talents Addon Mod Analysis

### File Structure
```
Tests/02_ExampleMods/WoWWarlockHeroTalents/
├── Mods/Warlock_WoW_Hero_Talents_20_Progression_5c6e0bb5.../
│   └── meta.lsx (DEPENDS ON base Warlock mod!)
└── Public/Warlock_WoW_Hero_Talents_20_Progression_5c6e0bb5.../
    ├── ClassDescriptions/ClassDescriptions.lsx (7 nodes)
    ├── Progressions/Progressions.lsx (L1-L8 for hero talents)
    └── Stats/
```

### meta.lsx Dependency

```xml
<node id="ModuleShortDesc">
    <attribute id="Folder" type="LSString" value="Warlock_WoW_bdb3fa73-401b-4979-f02e-485422dd8d9c"/>
    <attribute id="Name" type="LSString" value="WoWWarlock"/>
    <attribute id="UUID" type="guid" value="bdb3fa73-401b-4979-f02e-485422dd8d9c"/>
    <attribute id="Version64" type="int64" value="36169534507777024"/>
</node>
```

**Critical**: Hero Talents mod **REQUIRES** base Warlock mod as dependency!

---

### ClassDescriptions.lsx (7 nodes)

1. **WoWWarlockHero** (Base Class - NEW)
   - UUID: `f69b6654-66e9-4ae8-9a49-689ced735265`
   - Name: "WoWWarlockHero"
   - ProgressionTableUUID: `a414b3bf-4982-4df2-a392-958ac16d9f34`

2. **DemoDiabolist** (Hero Talent)
   - UUID: `440a3263-c7f6-4aa5-9b3d-ef42ea4f316b`
   - ParentGuid: `f69b6654...` (WoWWarlockHero base)
   - Name: "DemoDiabolist"

3. **DestroDiabolist** (Hero Talent)
   - ParentGuid: `f69b6654...`

4. **AffSoulHarvester** (Hero Talent)
   - ParentGuid: `f69b6654...`

5. **DemoSoulHarvester** (Hero Talent)
   - ParentGuid: `f69b6654...`

6. **DestroHellcaller** (Hero Talent)
   - ParentGuid: `f69b6654...`

7. **AffHellcaller** (Hero Talent)
   - ParentGuid: `f69b6654...`

**Pattern**: 1 NEW base class + 6 hero talent "subclasses"

**Critical**: This creates a **SEPARATE CLASS** with its own progression table!

---

### Progressions.lsx Analysis

#### Base Class (WoWWarlockHero) Progression

```xml
<!-- L1: Points to 6 hero talent options -->
<node id="Progression">
    <attribute id="Level" type="uint8" value="1"/>
    <attribute id="Name" type="LSString" value="WoWWarlockHero"/>
    <children>
        <node id="SubClasses">
            <children>
                <node id="SubClass">
                    <attribute id="Object" type="guid" value="440a3263..."/> <!-- DemoDiabolist -->
                </node>
                <node id="SubClass">
                    <attribute id="Object" type="guid" value="2b08637f..."/> <!-- DemoSoulHarvester -->
                </node>
                <!-- ... 4 more hero talent options -->
            </children>
        </node>
    </children>
</node>

<!-- L2-L12: Empty or minimal grants -->
```

#### Hero Talent (DemoDiabolist) Progression

```xml
<!-- L1: ALL 14 passives at once! -->
<node id="Progression">
    <attribute id="Level" type="uint8" value="1"/>
    <attribute id="Name" type="LSString" value="DemoDiabolist"/>
    <attribute id="PassivesAdded" type="LSString" value="WoWWarlock_Unlock_DiabolicRitual_Demo;DiabolicRitual_Demo_Fellord;DiabolicRitual_Demo_MotherOfChaos;DiabolicRitual_Demo_PitLord;DiabolicRitual_Fellord_1;DiabolicRitual_MotherOfChaos_1;DiabolicRitual_PitLord_1;WoWWarlock_Diabolist_DemonicCore_HandOfGuldan_1;WoWWarlock_Diabolist_DemonicCore_HandOfGuldan_2;WoWWarlock_Diabolist_DemonicCore_HandOfGuldan_3;WoWWarlock_Diabolist_SouLeech_HandOfGuldan;WoWWarlock_Diabolist_SoulConduit_HandOfGuldan_1;WoWWarlock_Diabolist_SoulConduit_HandOfGuldan_2;WoWWarlock_Diabolist_SoulConduit_HandOfGuldan_3"/>
    <attribute id="Selectors" type="LSString" value="AddSpells(71f788ac...)"/>
</node>

<!-- L2-L6: SelectPassives (player choices) -->
<node id="Progression">
    <attribute id="Level" type="uint8" value="2"/>
    <attribute id="Name" type="LSString" value="DemoDiabolist"/>
    <attribute id="Selectors" type="LSString" value="SelectPassives(6ec0fba1...,1,WoWWarlockDiabolistOfensive)"/>
</node>

<!-- L7: Capstone -->
<node id="Progression">
    <attribute id="Level" type="uint8" value="7"/>
    <attribute id="Name" type="LSString" value="DemoDiabolist"/>
    <attribute id="PassivesAdded" type="LSString" value="Diabolist_Demo_Ruination"/>
</node>
```

**Pattern**: L1 = keystone + all base talents, L2-L6 = choices, L7 = capstone

---

## 🔍 How It Works (Two-Mod System)

### Player Experience

1. **Install Base Warlock Mod**
   - Get WoWWarlock class
   - Pick Demonology/Destruction/Affliction at character creation
   - Play L1-L13 with standard progression

2. **Optionally Install Hero Talents Addon**
   - Get WoWWarlockHero class (SEPARATE class in character creation!)
   - Pick one of 6 hero talent variants at character creation
   - L1 = all hero talents granted immediately
   - L2-L7 = customize hero talents
   - Base Warlock L1-L13 progression still applies

### Technical Implementation

**Base Mod**:
- UUID: `bdb3fa73-401b-4979-f02e-485422dd8d9c`
- Provides: WoWWarlock class (L1-L13)
- ClassDescriptions: 4 nodes

**Hero Talents Addon**:
- UUID: `5c6e0bb5-2a35-dd6e-9b7b-72b9f8ae941e`
- Depends on: Base Warlock mod
- Provides: WoWWarlockHero class (L1-L8 for hero talents)
- ClassDescriptions: 7 nodes (SEPARATE class!)

**Result**: Two separate classes in character creation menu!

---

## ⚠️ Implications for Warrior Mod

### What This Means

**The Hero Talents mod is NOT an integrated L13-L20 system!**

It's a **separate optional addon** that creates a NEW class with its own progression.

### Three Approaches for Warrior

#### Option 1: Integrated L13-L20 (Recommended)
**Follow Excel plan** - integrate hero talents into base Warrior mod

```xml
<!-- Warrior base mod has ALL 10 nodes -->
<ClassDescriptions>
    1. WoWWarrior (base)
    2. ArmsWarrior (subclass)
    3. FuryWarrior (subclass)
    4. ProtectionWarrior (subclass)
    5. MountainThane (hero talent, ParentGuid = base Warrior)
    6. Colossus (hero talent, ParentGuid = base Warrior)
    7. Slayer (hero talent, ParentGuid = base Warrior)
</ClassDescriptions>

<!-- Progressions -->
Base Warrior: L1-L20
Arms/Fury/Protection: L1-L12
MountainThane/Colossus/Slayer: L13-L20
```

**Pros**:
- ✅ Matches Excel design
- ✅ Single mod (simpler for users)
- ✅ L13 selection integrated into progression
- ✅ No separate class needed

**Cons**:
- ❌ Deviates from Warlock's two-mod approach
- ❌ More complex single mod

---

#### Option 2: Two-Mod System (Warlock Pattern)
**Split into base + addon** (like Warlock)

**Base Warrior Mod**:
- L1-L12 progression
- 4 ClassDescription nodes
- Empty L13 placeholder

**Hero Talents Addon**:
- NEW class: "WoWWarriorHero"
- 7 ClassDescription nodes (1 base + 3 subclasses + 3 hero talents)
- L1-L8 hero talent progression
- Depends on base Warrior mod

**Pros**:
- ✅ Exact Warlock pattern (proven)
- ✅ Optional hero talents

**Cons**:
- ❌ Two separate mods
- ❌ Two separate classes in character creation
- ❌ User confusion
- ❌ Doesn't match Excel design

---

#### Option 3: Hybrid (Integrated with Warlock Structure)
**Use Warlock's ClassDescription architecture** but keep single mod

```xml
<!-- All in one mod -->
<ClassDescriptions>
    <!-- Same 10 nodes as Option 1 -->
</ClassDescriptions>

<Progressions>
    <!-- Base Warrior: L1-L20 -->
    <!-- Subclasses: L1-L12 -->
    <!-- Hero Talents: L13-L20 (integrated, not L1!) -->
</Progressions>
```

**Use Warlock's structure patterns**:
- ✅ 10 ClassDescription nodes
- ✅ Hero talent ParentGuid = base Warrior
- ✅ Separate ProgressionTableUUID per hero talent

**But adapt progression timing**:
- ✅ L13 = hero talent selection (not L1 multiclass pick)
- ✅ L13-L20 = hero talent grants (not L1-L8)
- ✅ Single integrated mod (not addon)

**Pros**:
- ✅ Warlock's proven structure
- ✅ Excel's integrated progression
- ✅ Single mod (user-friendly)
- ✅ L13 selection (matches Excel)

**Cons**:
- ⚠️ Deviates from Warlock's two-mod approach
- ⚠️ Unique progression timing

---

## 🎯 Recommendation: Option 3 (Hybrid)

**Use Warlock's STRUCTURE, adapt PROGRESSION for single mod**

### Why This Works

1. **Warlock's ClassDescription Architecture** = proven structure (7-10 nodes)
2. **Warlock's ParentGuid Pattern** = proven relationship (hero talents → base)
3. **Excel's Progression Timing** = user-approved design (L13-L20)
4. **Single Mod** = simpler for users (no addon confusion)

### Implementation

**ClassDescriptions.lsx**:
```xml
<!-- 10 nodes total -->
1. WoWWarrior (base, UUID: 78fe4967...)
2. ArmsWarrior (ParentGuid: 78fe4967...)
3. FuryWarrior (ParentGuid: 78fe4967...)
4. ProtectionWarrior (ParentGuid: 78fe4967...)
5. MountainThane (ParentGuid: 78fe4967...) ← Hero talent
6. Colossus (ParentGuid: 78fe4967...)
7. Slayer (ParentGuid: 78fe4967...)
8. MountainThane_Alt (ParentGuid: 78fe4967...) ← If needed for Fury variant
9. Colossus_Alt (ParentGuid: 78fe4967...)
10. Slayer_Alt (ParentGuid: 78fe4967...)
```

**Progressions.lsx**:
```xml
<!-- Base Warrior: L1-L20 -->
<node id="Progression">
    <attribute id="Level" type="uint8" value="13"/>
    <attribute id="Name" type="LSString" value="WoWWarrior"/>
    <children>
        <node id="SubClasses">
            <!-- Present hero talent options based on subclass -->
        </node>
    </children>
</node>

<!-- Hero Talents: L13-L20 (NOT L1-L8!) -->
<node id="Progression">
    <attribute id="Level" type="uint8" value="13"/>
    <attribute id="Name" type="LSString" value="MountainThane"/>
    <attribute id="PassivesAdded" type="LSString" value="WAR_MountainThane_LightningStrikes"/>
</node>

<node id="Progression">
    <attribute id="Level" type="uint8" value="15"/>
    <attribute id="Name" type="LSString" value="MountainThane"/>
    <attribute id="PassivesAdded" type="LSString" value="WAR_MountainThane_CrashingThunder;WAR_MountainThane_GroundCurrent;WAR_MountainThane_StrengthOfMountain"/>
</node>

<!-- Continue L17, L19, L20 -->
```

---

## 📋 Key Takeaways

1. ⚠️ **Warlock Hero Talents = ADDON MOD**, not integrated L13-L20
2. ⚠️ **Creates SEPARATE CLASS** (WoWWarlockHero), not subclass selection
3. ⚠️ **L1 front-loading** in addon, not L13-L20 progression
4. ✅ **Warrior should use integrated approach** (Option 3)
5. ✅ **Use Warlock's structure, adapt progression timing**
6. ✅ **10 ClassDescription nodes in single mod**
7. ✅ **L13-L20 hero talent progression** (matches Excel)

---

## 🔗 Cross-References

### Files Analyzed:
- `Tests/02_ExampleMods/ExampleMod_WoWWarlock/` (base mod, L1-L13)
- `Tests/02_ExampleMods/WoWWarlockHeroTalents/` (addon mod, separate class)

### Warrior Design Documents:
- `Documentation/00_SourcesOfTruth/EXCEL_WARRIOR_PROGRESSION_ANALYSIS.md`
- `Documentation/00_SourcesOfTruth/HERO_TALENTS_OVERVIEW.md`
- `Documentation/00_SourcesOfTruth/WARLOCK_VS_WARRIOR_HERO_TALENTS_COMPARISON.md`

---

**Last Updated**: October 20, 2025  
**Status**: ✅ Analysis complete - Recommend Option 3 (Hybrid: Warlock structure + Excel progression)
