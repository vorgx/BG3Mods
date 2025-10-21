# WoWDemonHunter SpellList Analysis vs Warrior & Warlock

**Created**: October 20, 2025  
**Purpose**: Compare DemonHunter's implementation with Warrior (zero SpellLists) and Warlock (53 SpellLists)  
**Key Finding**: DemonHunter uses **HYBRID approach** - 19 SpellLists + AddSpells([UUID]) + PassivesAdded

---

## 🔍 DemonHunter's Three-Method System

### 1. ClassDescriptions.lsx (3 nodes)

**CRITICAL DIFFERENCE**: DemonHunter has **NO SpellList attribute** in ClassDescriptions!

```xml
<node id="ClassDescription"> <!-- Base DemonHunter -->
    <attribute id="Name" type="FixedString" value="WoWDemonHunter"/>
    <attribute id="ProgressionTableUUID" type="guid" value="4a0e24b1-5866-4ae1-9815-574f5744480a"/>
    <attribute id="UUID" type="guid" value="79046310-7183-42f4-9ce6-574f5744480a"/>
    <!-- NO SpellList attribute! -->
</node>

<node id="ClassDescription"> <!-- Havoc Subclass -->
    <attribute id="Name" type="FixedString" value="HavocDemonHunter"/>
    <attribute id="ParentGuid" type="guid" value="79046310-7183-42f4-9ce6-574f5744480a"/>
    <attribute id="ProgressionTableUUID" type="guid" value="ec00a440-e871-4412-84f7-574f5744480a"/>
    <attribute id="UUID" type="guid" value="d846a33f-3bfd-43c7-ab78-574f5744480a"/>
    <!-- NO SpellList attribute! -->
</node>

<node id="ClassDescription"> <!-- Vengeance Subclass -->
    <attribute id="Name" type="FixedString" value="VengeanceDemonHunter"/>
    <attribute id="ParentGuid" type="guid" value="79046310-7183-42f4-9ce6-574f5744480a"/>
    <attribute id="ProgressionTableUUID" type="guid" value="cbef6b7c-80fb-4f84-a78c-574f5744480a"/>
    <attribute id="UUID" type="guid" value="b2650fe7-4a44-4981-aa65-574f5744480a"/>
    <!-- NO SpellList attribute! -->
</node>
```

**Comparison**:
- ❌ **Warlock**: ALL 4 ClassDescriptions use dummy UUID `32879c22-4858-48ef-8f8d-22e6d395b396`
- ❌ **Warrior**: ALL 7 ClassDescriptions use dummy UUID `32879c22-4858-48ef-8f8d-22e6d395b396`
- ✅ **DemonHunter**: NO SpellList attribute at all! Completely omitted!

---

## 📊 SpellList Breakdown (19 Total Nodes)

### Structure by Category

| Category | Node Count | Levels Covered | Notes |
|----------|-----------|----------------|-------|
| **Shared DH Spells** | 5 | L3, L8, L9, L10, L11 | Base class abilities |
| **Havoc Subclass** | 7 | L1-L7 | Havoc-specific progression |
| **Vengeance Subclass** | 7 | L1-L7 | Vengeance-specific progression |

### Shared DH Spells (5 nodes)

| Level | SpellList UUID | Spells Granted |
|-------|---------------|----------------|
| **L3** | b562c1d8-1f1e-4f05-ae0b-574f5744480a | Target_DH_Torment + Projectile_DH_ThrowGlaive |
| **L8** | 2c3c622f-74e9-41c0-a032-574f5744480a | Shout_DH_ImmolationAura + Target_DH_SigilOfFlame |
| **L9** | 601f92e8-a9ab-433c-b744-574f5744480a | Empty (placeholder) |
| **L10** | d4ef1a49-e28f-4d7e-8ceb-574f5744480a | Target_DH_Disrupt + Target_DH_Imprison + Shout_DH_Blur |
| **L11** | f5e40b7d-cd81-4111-91cd-574f5744480a | Target_DH_ManaBurn + Shout_DH_ChaosNova |

### Havoc Subclass Spells (7 nodes)

| Level | SpellList UUID | Spells Granted |
|-------|---------------|----------------|
| **L1** | bc76bcd5-b481-4cc8-8c04-574f5744480a | Projectile_Metamorphosis_Havoc + Shout_DH_SpectralSight |
| **L2** | 7e456407-36da-4600-8b67-574f5744480a | Target_DH_DemonsBite + Target_DH_ChaosStrike |
| **L3** | 0ee218d4-4bc0-4000-b20e-574f5744480a | Rush_DH_FelRush |
| **L4** | 3965f689-7190-4c29-8135-574f5744480a | Shout_DH_DemonBlades |
| **L5** | 34795224-b130-4821-ac56-574f5744480a | Zone_DH_EyeBeam |
| **L6** | b6a109ff-556d-44b8-b93b-574f5744480a | Shout_DH_Havoc_ShatteredSouls |
| **L7** | 1e741eac-a13f-4a12-844e-574f5744480a | Shout_DH_BladeDance |

### Vengeance Subclass Spells (7 nodes)

| Level | SpellList UUID | Spells Granted |
|-------|---------------|----------------|
| **L1** | 413164a2-46af-4063-a371-574f5744480a | Shout_Metamorphosis_Vengeance + Shout_DH_SpectralSight |
| **L2** | 57693590-1522-4322-a14a-574f5744480a | Target_DH_Shear + Zone_DH_SoulCleave |
| **L3** | 2f03c47a-8ec6-4abd-85bc-574f5744480a | Target_DH_InfernalStrike |
| **L4** | 7298a417-f30b-4b83-be5f-574f5744480a | Shout_DH_DemonSpikes |
| **L5** | 67b101d8-1818-44cf-918d-574f5744480a | Zone_DH_FelDevastation |
| **L6** | 2010c5fc-fd81-4ffd-b80b-574f5744480a | Target_DH_SpiritBomb |
| **L7** | b9d35ff4-6309-4728-86e0-574f5744480a | Target_DH_SigilOfChains |

---

## 🔄 How DemonHunter Grants Spells (HYBRID Method)

### Example: Havoc DemonHunter Level 2

**Progression Node**:
```xml
<node id="Progression">
    <attribute id="Level" type="uint8" value="2"/>
    <attribute id="Name" type="LSString" value="HavocDemonHunter"/>
    <attribute id="PassivesAdded" type="LSString" value="DH_Havoc_UnlockChaosStrike"/>
    <attribute id="Selectors" type="LSString" value="AddSpells(7e456407-36da-4600-8b67-574f5744480a,,,,AlwaysPrepared)"/>
    <attribute id="TableUUID" type="guid" value="ec00a440-e871-4412-84f7-574f5744480a"/>
</node>
```

**Method 1: AddSpells([UUID])** (like Warlock)
- `AddSpells(7e456407-36da-4600-8b67-574f5744480a)` references SpellLists.lsx
- SpellList contains: `Target_DH_DemonsBite;Target_DH_ChaosStrike`
- Player gets 2 spells from SpellList

**Method 2: PassivesAdded** (like Warrior)
- `DH_Havoc_UnlockChaosStrike` passive is granted
- Passive likely uses `Boosts="UnlockSpell(...)"` for special mechanics

**Result**: Player gets spells from BOTH methods at Level 2!

---

## 🆚 Three-Way Comparison Table

| Metric | Warlock | DemonHunter | Warrior |
|--------|---------|-------------|---------|
| **ClassDescription Nodes** | 4 (base + 3 specs) | 3 (base + 2 specs) | 7 (base + 3 specs + 3 heroes) |
| **SpellList Attribute in ClassDescriptions** | ✅ Dummy UUID (32879c22...) | ❌ NONE (omitted) | ✅ Dummy UUID (32879c22...) |
| **Actual SpellList Nodes** | 53 | 19 | 0 |
| **SpellList Organization** | Per-level per spec (L1-L12) | Per-level shared + per-level per spec (L1-L7) | None |
| **Grant Method 1** | AddSpells([UUID]) | AddSpells([UUID]) | PassivesAdded only |
| **Grant Method 2** | Not used | PassivesAdded (HYBRID!) | PassivesAdded |
| **Empty Placeholder SpellLists** | ~25 (organizational) | 1 (L9 shared) | 0 |
| **SpellLists.lsx File Size** | ~247 lines | ~150 lines (estimated) | Not created |
| **Complexity** | High (53 UUIDs) | Medium (19 UUIDs) | Low (1 dummy UUID) |

---

## 🎯 Key Pattern Discoveries

### 1. **SpellList Attribute is OPTIONAL in ClassDescriptions!**

**Warlock & Warrior**: Include dummy UUID (never used)
```xml
<attribute id="SpellList" type="guid" value="32879c22-4858-48ef-8f8d-22e6d395b396"/>
```

**DemonHunter**: Completely omits the attribute!
```xml
<!-- NO SpellList attribute at all! -->
```

**Conclusion**: The SpellList attribute in ClassDescriptions is **100% optional**. BG3 doesn't require it!

### 2. **Hybrid Approach: Best of Both Worlds**

DemonHunter uses **BOTH** methods simultaneously:
- **AddSpells([UUID])**: For baseline ability grants (clean organization in SpellLists.lsx)
- **PassivesAdded**: For special mechanics, upgrades, or conditional unlocks

**Example (Havoc L3)**:
```xml
<attribute id="PassivesAdded" type="LSString" value="DH_Havoc_FelRush_DoubleCast"/>
<attribute id="Selectors" type="LSString" value="AddSpells(0ee218d4-4bc0-4000-b20e-574f5744480a,,,,AlwaysPrepared)"/>
```

- `AddSpells()` grants the spell itself (Rush_DH_FelRush)
- `PassivesAdded` grants a passive that upgrades it (double cast mechanic)

### 3. **SpellList Count Strategy**

| Mod | Total SpellLists | Strategy |
|-----|-----------------|----------|
| **Warlock** | 53 | One per level per category (L1-L12 × 4 categories + organizational) |
| **DemonHunter** | 19 | One per level with abilities (5 shared + 7 Havoc + 7 Vengeance) |
| **Warrior** | 0 | No SpellLists, all via passives |

**DemonHunter's Logic**:
- **Shared abilities** (L3, L8, L10, L11): 4 functional SpellLists + 1 empty (L9)
- **Subclass abilities** (L1-L7): 7 SpellLists per spec × 2 specs = 14 SpellLists
- **Total**: 19 SpellLists (vs Warlock's 53)

### 4. **Why DemonHunter Uses Hybrid**

**AddSpells([UUID]) For**:
- ✅ Baseline rotation abilities (Demon's Bite, Chaos Strike, Shear, Soul Cleave)
- ✅ Multiple spells granted at same level (L10: 3 spells at once)
- ✅ Clean organization in SpellLists.lsx with comments

**PassivesAdded For**:
- ✅ Resource mechanics (DH_UnlockDemonicFury, DH_UnlockDemonicFury_2, DH_UnlockDemonicFury_3)
- ✅ Ability upgrades (DH_Havoc_FelRush_DoubleCast)
- ✅ Conditional unlocks (DH_Havoc_UnlockChaosStrike - probably has requirements)
- ✅ Mastery passives (DH_Mastery_DemonicPresence)

---

## 💡 What This Means for Warrior

### Discovery: You Can Mix Both Methods!

**Current Warrior Approach (Zero SpellLists)**:
```xml
<!-- L3 Arms: Grant Execute via passive -->
<attribute id="PassivesAdded" type="LSString" value="WAR_Arms_Execute_Unlock"/>
```

**DemonHunter Alternative (Hybrid)**:
```xml
<!-- L3 Arms: Grant Execute via SpellList + passive for upgrade -->
<attribute id="Selectors" type="LSString" value="AddSpells([ARMS_L3_SPELLLIST_UUID],,,,AlwaysPrepared)"/>
<attribute id="PassivesAdded" type="LSString" value="WAR_Arms_ExecuteMastery"/>
```

Where SpellList contains:
```xml
<node id="SpellList">
    <attribute id="Comment" type="LSString" value="Arms Level 3 Abilities"/>
    <attribute id="Spells" type="LSString" value="WAR_Execute;WAR_Pummel"/>
    <attribute id="UUID" type="guid" value="[ARMS_L3_SPELLLIST_UUID]"/>
</node>
```

### Should Warrior Switch to Hybrid?

**Pros of Hybrid**:
- ✅ Clean separation: SpellLists.lsx shows which spells grant at which level
- ✅ PassivesAdded handles special mechanics (hero talent keystones, upgrades)
- ✅ Easier to see "base rotation" vs "enhancement passives"
- ✅ Can grant 3+ spells at once without 3+ unlock passives

**Cons of Hybrid**:
- ❌ Need to create 19+ SpellList nodes (per DemonHunter's pattern)
- ❌ More UUIDs to manage
- ❌ More files to maintain (SpellLists.lsx)

**Current Warrior Pros** (Zero SpellLists):
- ✅ Already implemented and working
- ✅ Simpler (fewer files, fewer UUIDs)
- ✅ All spell grants in one place (Progressions.lsx + Passive.txt)

**Recommendation**: **Stick with Zero SpellLists** unless you want the organizational benefits of DemonHunter's approach.

---

## 📋 Summary of Three Approaches

### Approach 1: Warlock (53 SpellLists)
**Strategy**: One SpellList per level per category
**Pros**: Highly organized, easy to find abilities by level
**Cons**: 53 UUIDs, larger file, many empty placeholders
**Best For**: Mods with many summons/variants per level (demons, pets)

### Approach 2: DemonHunter (19 SpellLists + Hybrid)
**Strategy**: SpellLists for baseline abilities, PassivesAdded for upgrades
**Pros**: Best of both worlds, clean separation of concerns
**Cons**: Need to manage both systems, medium complexity
**Best For**: Mods with clear baseline rotation + enhancement passives

### Approach 3: Warrior (Zero SpellLists)
**Strategy**: All grants via PassivesAdded with UnlockSpell() boosts
**Pros**: Simplest, fewest files, one system to maintain
**Cons**: All abilities in Passive.txt (larger file), no SpellList organization
**Best For**: Mods with talent-based unlocks, simpler ability progression

---

## 🔑 Key Takeaway for Warrior

**DemonHunter proves THREE things**:

1. ✅ **SpellList attribute in ClassDescriptions is OPTIONAL** (can be completely omitted!)
2. ✅ **You can MIX AddSpells([UUID]) + PassivesAdded in same progression node**
3. ✅ **19 SpellLists is "medium complexity"** (between Warlock's 53 and Warrior's 0)

**Your zero-SpellList approach is 100% valid** - DemonHunter shows you don't even need the dummy UUID in ClassDescriptions!

If you want organizational benefits, you could adopt DemonHunter's hybrid approach:
- Use SpellLists for baseline abilities (Execute, Shield Slam, Mortal Strike grants)
- Use PassivesAdded for hero talents, keystones, and upgrades

**But there's no functional advantage** - it's purely organizational preference.

---

## 📊 Final Comparison: All Three Mods

| Feature | Warlock | DemonHunter | Warrior |
|---------|---------|-------------|---------|
| **ClassDescriptions** | 4 nodes | 3 nodes | 7 nodes |
| **SpellList Attribute** | Dummy UUID | NONE (omitted) | Dummy UUID |
| **SpellLists.lsx Nodes** | 53 | 19 | 0 |
| **Grant Method** | AddSpells([UUID]) only | AddSpells([UUID]) + PassivesAdded | PassivesAdded only |
| **Organization** | Per-level per category | Hybrid baseline + upgrades | All in Progressions + Passive.txt |
| **Complexity** | High | Medium | Low |
| **Flexibility** | Low (SpellLists only) | High (both methods) | Medium (PassivesAdded only) |
| **File Count** | More (SpellLists.lsx) | More (SpellLists.lsx) | Fewer (no SpellLists.lsx) |
| **Best Use Case** | Many variants per level | Baseline + upgrades split | Talent-based unlocks |

---

**Last Updated**: October 20, 2025  
**Status**: ✅ Analysis complete - DemonHunter uses HYBRID approach (19 SpellLists + PassivesAdded)  
**Key Discovery**: SpellList attribute in ClassDescriptions is **OPTIONAL** (DemonHunter omits it entirely!)  
**Recommendation**: Warrior should **continue with zero SpellLists** unless organizational benefits of hybrid approach are desired
