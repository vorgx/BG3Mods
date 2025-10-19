# 🎯 UPDATED ANALYSIS: Warlock Hero Talents Structure (COMPLETE PICTURE)

**Date:** October 18, 2024  
**Critical Discovery:** Warlock Hero Talents is a **SEPARATE MOD** that extends the base Warlock mod!  
**Impact:** Changes our entire strategy!

---

## 🔍 THE COMPLETE WARLOCK SYSTEM

### **2-MOD ARCHITECTURE:**

**MOD 1: WoWWarlock (Base Mod)**
- **UUID:** `bdb3fa73-401b-4979-f02e-485422dd8d9c`
- **Levels:** 1-12 (ends at L12)
- **Content:** 3 subclasses (Demonology, Destruction, Affliction)
- **Structure:** Talent rows L1-L12 per subclass

**MOD 2: WoWWarlockHeroTalents (Extension Mod)**
- **UUID:** `5c6e0bb5-2a35-dd6e-9b7b-72b9f8ae941e`
- **Levels:** 1-9 (actually represents L13-L21 in-game!)
- **Dependencies:** REQUIRES base WoWWarlock mod
- **Content:** 6 hero talent subclasses (2 per base spec)
  - Demonology → Diabolist / Soul Harvester
  - Destruction → Diabolist / Hellcaller
  - Affliction → Soul Harvester / Hellcaller

**How They Work Together:**
```
Player Level 1-12: WoWWarlock mod (base class + spec)
Player Level 13+: WoWWarlockHeroTalents mod takes over (hero spec choice)
```

---

## 📊 HERO TALENTS MOD STRUCTURE BREAKDOWN

### **meta.lsx Dependencies:**

```xml
<node id="ModuleShortDesc">
    <attribute id="Folder" value="Warlock_WoW_bdb3fa73-401b-4979-f02e-485422dd8d9c"/>
    <attribute id="Name" value="WoWWarlock"/>
    <attribute id="UUID" value="bdb3fa73-401b-4979-f02e-485422dd8d9c"/>  <!-- Base mod required! -->
    <attribute id="Version64" value="72339069014638688"/>
</node>

<node id="ModuleInfo">
    <attribute id="Name" value="WoWWarlockHeroTalents"/>
    <attribute id="Description" value="Implementing WoW Warlock Hero talents as Level 20 progression. My other mod WoW Warlock Required to work properly."/>
    <attribute id="UUID" value="5c6e0bb5-2a35-dd6e-9b7b-72b9f8ae941e"/>
</node>
```

---

### **Progressions.lsx Structure:**

**Base Class "WoWWarlockHero" (L1-9):**
```xml
<node id="Progression">
    <attribute id="Level" value="1"/>
    <attribute id="Name" value="WoWWarlockHero"/>
    <attribute id="ProgressionType" value="0"/>  <!-- 0 = Base class -->
    <attribute id="TableUUID" value="a414b3bf-4982-4df2-a392-958ac16d9f34"/>
    <children>
        <node id="SubClasses">
            <children>
                <!-- 6 hero talent subclasses! -->
                <node id="SubClass">
                    <attribute id="Object" value="440a3263-c7f6-4aa5-9b3d-ef42ea4f316b"/>  <!-- DemoDiabolist -->
                </node>
                <node id="SubClass">
                    <attribute id="Object" value="2b08637f-32e9-44c0-a240-6db81693ccba"/>  <!-- DemoSoulHarvester -->
                </node>
                <node id="SubClass">
                    <attribute id="Object" value="1a0c98de-4282-4ad2-b897-a54df7af0544"/>  <!-- DestroHellcaller -->
                </node>
                <node id="SubClass">
                    <attribute id="Object" value="5fabf07c-3871-48b4-a376-f7984e1069e8"/>  <!-- DestroDiabolist -->
                </node>
                <node id="SubClass">
                    <attribute id="Object" value="33a596f6-a59f-445a-b720-1a64b4262f84"/>  <!-- AffSoulHarvester -->
                </node>
                <node id="SubClass">
                    <attribute id="Object" value="aa2a4e31-c8f1-4a8d-a0d9-7159463fc137"/>  <!-- AffHellcaller -->
                </node>
            </children>
        </node>
    </children>
</node>

<node id="Progression">
    <attribute id="Level" value="2"/>
    <attribute id="Name" value="WoWWarlockHero"/>
    <attribute id="ProgressionType" value="0"/>
    <!-- Empty - just level progression -->
</node>

<!-- L3-L9 continue as empty base class progressions -->
```

**Hero Talent Subclass Example (DemoDiabolist L1-8):**
```xml
<node id="Progression">
    <attribute id="Level" value="1"/>
    <attribute id="Name" value="DemoDiabolist"/>
    <attribute id="PassivesAdded" value="WoWWarlock_Unlock_DiabolicRitual_Demo;DiabolicRitual_Demo_Fellord;DiabolicRitual_Demo_MotherOfChaos;..."/>
    <attribute id="ProgressionType" value="1"/>  <!-- 1 = Subclass -->
    <attribute id="Selectors" value="AddSpells(71f788ac-dced-4cdc-b718-dc506d16c283)"/>
    <attribute id="TableUUID" value="a93da1a5-686d-4fe4-b721-d3065b7d30d7"/>
</node>

<node id="Progression">
    <attribute id="Level" value="2"/>
    <attribute id="Name" value="DemoDiabolist"/>
    <attribute id="ProgressionType" value="1"/>
    <attribute id="Selectors" value="SelectPassives(UUID,1,WoWWarlockDiabolistOfensive)"/>
    <attribute id="TableUUID" value="a93da1a5-686d-4fe4-b721-d3065b7d30d7"/>
</node>

<node id="Progression">
    <attribute id="Level" value="3"/>
    <attribute id="Name" value="DemoDiabolist"/>
    <attribute id="ProgressionType" value="1"/>
    <attribute id="Selectors" value="SelectPassives(UUID,1,WoWWarlockDiabolistDefensive)"/>
    <attribute id="TableUUID" value="a93da1a5-686d-4fe4-b721-d3065b7d30d7"/>
</node>

<!-- L4-L8 continue with SelectPassives -->
```

---

### **PassiveLists.lsx (Hero Talent Rows):**

**Diabolist Talent Rows:**
```xml
<node id="PassiveList">
    <attribute id="Name" value="Diabolist_Demo_Offensive"/>
    <attribute id="Passives" value="Diabolist_ClovenSouls,Diabolist_Demo_AbyssialDominion,Diabolist_Demo_SecretsOfTheCoven"/>
    <attribute id="UUID" value="6ec0fba1-0d0e-4c06-9f89-5f14d792d5c0"/>
</node>

<node id="PassiveList">
    <attribute id="Name" value="Diabolist_Defensive"/>
    <attribute id="Passives" value="Diabolist_InfernalVitality,Diabolist_AnnihilansBelow"/>
    <attribute id="UUID" value="3607d9d5-a37b-43c5-9b3e-7172a3ff353a"/>
</node>
```

**Soul Harvester Talent Rows:**
```xml
<node id="PassiveList">
    <attribute id="Name" value="SoulHarvester_Demo_Offensive"/>
    <attribute id="Passives" value="WoWWarlock_SoulHarvester_NecrolyteTeachings_Demo,WoWWarlock_SoulHarvester_SatielsVolition_Demo,WoWWarlock_SoulHarvester_WickedReaping_Demo"/>
    <attribute id="UUID" value="6cc5810d-d858-4f42-b2a3-01ffa43fa44c"/>
</node>

<node id="PassiveList">
    <attribute id="Name" value="SoulHarvester_Defensive"/>
    <attribute id="Passives" value="WoWWarlock_SoulHarvester_GoreboundFortitude,WoWWarlock_SoulHarvester_FriendsinDarkPlaces"/>
    <attribute id="UUID" value="3e581fa2-deee-48e5-bd04-de419c1b1f9e"/>
</node>
```

**Hellcaller Talent Rows:**
```xml
<node id="PassiveList">
    <attribute id="Name" value="Hellcaller_Destro_Offensive"/>
    <!-- ... -->
</node>
```

---

## 🎯 CRITICAL INSIGHTS

### **1. Why 2 Separate Mods?**

**Technical Reasons:**
- BG3 base game only supports 12 class levels
- **L13-L20 is actually implemented as a SECOND "class"** that you multiclass into!
- Base mod = levels 1-12 of "Warlock" class
- Hero talents mod = levels 1-9 of "WoWWarlockHero" class (appears as L13-21 in-game)

**Gameplay Flow:**
1. Player creates Warlock character (base mod)
2. Player levels 1-12 with base mod's progressions
3. **At L13, player "multiclasses" into WoWWarlockHero** (hero talents mod takes over)
4. Player chooses 1 of 6 hero talent subclasses
5. L13-L21 uses hero talents mod's progressions

---

### **2. How Multiclassing Works in BG3 Mods:**

```xml
<!-- Hero Talents Mod - Progressions.lsx -->
<node id="Progression">
    <attribute id="IsMulticlass" value="true"/>  <!-- ← THIS IS THE KEY! -->
    <attribute id="Level" value="1"/>
    <attribute id="Name" value="WoWWarlockHero"/>
    <!-- ... -->
</node>
```

**The `IsMulticlass="true"` flag tells BG3:**
- This is a multiclass option
- Players can add this as a 2nd class
- Progressions start at "Level 1" but appear as L13+ in-game

---

### **3. Hero Talent Subclass Pattern:**

Each hero talent is a **subclass of the hero talents "class"**:

**Structure:**
```
WoWWarlockHero (Base "class")
├─ DemoDiabolist (Subclass 1)
│   ├─ L1: Keystone passive
│   ├─ L2: SelectPassives (Offensive choices)
│   ├─ L3: SelectPassives (Defensive choices)
│   └─ L4-L8: More SelectPassives
├─ DemoSoulHarvester (Subclass 2)
│   ├─ L1: Keystone passive
│   ├─ L2: SelectPassives
│   └─ ...
├─ DestroHellcaller (Subclass 3)
├─ DestroDiabolist (Subclass 4)
├─ AffSoulHarvester (Subclass 5)
└─ AffHellcaller (Subclass 6)
```

**Why 6 Subclasses?**
- 3 base specs × 2 hero talent options each = 6 total combinations
- Demonology can choose: Diabolist OR Soul Harvester
- Destruction can choose: Diabolist OR Hellcaller
- Affliction can choose: Soul Harvester OR Hellcaller

---

## 🔄 REVISED OPTIONS FOR WARRIOR MOD

### **OPTION D: Two-Mod Architecture (MOST ACCURATE TO WARLOCK)**

**Create 2 separate mods:**

**Mod 1: BG3Wow (Base Warrior - L1-L12)**
- UUID: `78fe4967-4e62-5491-d981-dd781acca4d7`
- 3 subclasses: Arms, Fury, Protection
- L1-L12 progressions with talent rows
- Ends at L12

**Mod 2: BG3WowHeroTalents (Hero Talents - L13-L20)**
- UUID: New UUID (separate mod)
- Depends on: BG3Wow base mod
- 9 hero talent subclasses (3 per base spec × 3 hero talents each):
  - Arms → Mountain Thane / Colossus / Slayer
  - Fury → Mountain Thane / Colossus / Slayer
  - Protection → Mountain Thane / Colossus / Slayer
- L1-L8 progressions (appears as L13-L20 in-game)
- Uses SelectPassives for hero talent choices

**Pros:**
- ✅ EXACT match to Warlock's proven architecture
- ✅ Clean separation of concerns
- ✅ Base mod can work standalone (L1-L12)
- ✅ Hero talents optional (player installs if they want L13-L20)
- ✅ Uses proven multiclass system

**Cons:**
- ❌ Users must install 2 mods
- ❌ More complex distribution
- ❌ Need to manage dependencies

---

### **OPTION E: Single-Mod with Extended Progressions (SIMPLER)**

**Keep everything in 1 mod:**
- Base class L1-L20 progressions
- 3 subclasses for L1-L12 (Arms, Fury, Protection)
- L13-L20: Add hero talent passives directly to base/subclass progressions

**Pros:**
- ✅ Single mod installation
- ✅ Simpler for users
- ✅ No dependency management

**Cons:**
- ❌ Doesn't match Warlock structure exactly
- ❌ Can't make hero talents optional
- ❌ Might be harder to maintain

---

## 📋 COMPARISON: ALL OPTIONS

| Aspect | Option A (Keep Ours) | Option D (Two Mods) | Option E (Single Mod Extended) |
|--------|---------------------|---------------------|------------------------------|
| **Mods Required** | 1 | 2 | 1 |
| **Matches Warlock** | Partial | Exact | Partial |
| **L1-L12 Structure** | Current | Warlock-style | Warlock-style |
| **L13-L20 Structure** | Base class PassivesAdded | Multiclass subclasses | Base/Subclass PassivesAdded |
| **Hero Talent Choice** | No (progressive unlock) | Yes (SelectPassives) | No (progressive unlock) |
| **Implementation** | 1 hour | 6-8 hours | 3-4 hours |
| **User Experience** | Simple (1 mod) | Complex (2 mods) | Simple (1 mod) |
| **Maintenance** | Easy | Medium | Easy |
| **Distribution** | Single .pak | Two .pak files | Single .pak |
| **Base Mod Standalone** | Yes | Yes | Yes |
| **Hero Talents Optional** | No | Yes | No |

---

## 🎯 UPDATED RECOMMENDATION

Given this new information, I have **2 STRONG recommendations** depending on your priority:

### **BEST for Accuracy: OPTION D (Two-Mod Architecture)**

**Why:**
- Matches Warlock's proven L13-L20 implementation EXACTLY
- Uses BG3's multiclass system as intended
- Warlock has 13K+ downloads with this architecture - it WORKS
- Players already understand "base mod + hero talents mod" pattern from Warlock

**When to choose:**
- You want to exactly replicate Warlock's structure
- You want hero talents to be optional
- You don't mind users installing 2 mods
- You want maximum compatibility with BG3's systems

**Implementation Path:**
1. Use Warlock base mod template for BG3Wow (L1-L12)
2. Use Warlock hero talents template for BG3WowHeroTalents (L13-L20 as L1-L8 multiclass)
3. Each has its own UUID, each packages separately
4. Hero talents mod lists base mod as dependency

---

### **BEST for Simplicity: OPTION E (Single-Mod Extended)**

**Why:**
- Single installation for users
- Easier distribution (one .pak file)
- Still uses Warlock template for L1-L12
- Hero talents are hardcoded progressions (like our current system)

**When to choose:**
- You want simplest user experience
- You don't need hero talents to be optional
- You want easier maintenance
- You're okay with not matching Warlock 100%

**Implementation Path:**
1. Use Warlock base mod template (L1-L12 with talent rows)
2. Extend base class Progressions.lsx to L13-L20
3. Add hero talent PassivesAdded to L13-L20 progressions
4. Single package, single UUID

---

## ❓ DECISION NEEDED

**Critical Questions:**

1. **Two mods or one mod?**
   - Option D: Two mods (BG3Wow + BG3WowHeroTalents) - exact Warlock match
   - Option E: One mod (BG3Wow with L1-L20) - simpler

2. **Hero talent choices or progressive unlocks?**
   - If Option D: Must use SelectPassives (player choices at each level)
   - If Option E: Can use hardcoded PassivesAdded (progressive unlocks)

3. **How many hero talent subclasses?**
   - 9 total (3 per base spec × 3 hero talents)?
   - OR 3 total (1 per base spec - simpler)?

4. **Do you want hero talents to be optional?**
   - If YES: Must use Option D (two mods)
   - If NO: Option E is fine

---

## 🚀 NEXT STEPS BASED ON YOUR DECISION

### **If You Choose Option D (Two Mods):**

**Phase 1:** Create BG3Wow (Base Mod L1-L12)
1. Use Warlock base mod as template
2. Map Arms/Fury/Protection to Demonology/Destruction/Affliction structure
3. Create talent rows for each spec (L2-L12)
4. Package as `BG3Wow.pak`

**Phase 2:** Create BG3WowHeroTalents (L13-L20)
1. Use Warlock hero talents mod as template
2. Create "WarriorHero" base class with 9 subclasses
3. Map hero talents to SelectPassives rows
4. Set dependency on BG3Wow base mod
5. Package as `BG3WowHeroTalents.pak`

**Time Estimate:** 6-8 hours total

---

### **If You Choose Option E (Single Mod):**

**Phase 1:** Transform Base Mod (L1-L12)
1. Use Warlock base mod as template
2. Map Arms/Fury/Protection to Warlock spec structure
3. Create talent rows for each spec

**Phase 2:** Extend to L13-L20
1. Add base class L13-L20 progressions
2. Add hero talent PassivesAdded to each level
3. Keep our 33 hero talent passives unchanged

**Time Estimate:** 3-4 hours total

---

**Status:** ⏸️ WAITING FOR DECISION - TWO MODS OR ONE MOD?  
**Impact:** CRITICAL - Determines entire project architecture!  
**Recommendation:** Option D if you want exact Warlock match, Option E if you want simplicity

