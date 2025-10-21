# WoWWarlock SpellList Analysis vs Warrior Structure

**Created**: October 20, 2025  
**Purpose**: Analyze WoWWarlock's SpellList usage patterns and compare to Warrior implementation strategy  
**Key Finding**: Warlock uses **53 SpellLists** but **ONLY dummy UUID in ClassDescriptions**

---

## 🔍 Critical Discovery

### Warlock's Two-Tier System

**ClassDescriptions.lsx** (4 nodes):
- ✅ Base Warlock: `SpellList UUID = 32879c22-4858-48ef-8f8d-22e6d395b396`
- ✅ Demonology: `SpellList UUID = 32879c22-4858-48ef-8f8d-22e6d395b396`
- ✅ Destruction: `SpellList UUID = 32879c22-4858-48ef-8f8d-22e6d395b396`
- ✅ Affliction: `SpellList UUID = 32879c22-4858-48ef-8f8d-22e6d395b396`

**All 4 ClassDescription nodes use the SAME dummy UUID!**

**SpellLists.lsx** (53 nodes):
- Different UUIDs used in `Progressions.lsx` via `AddSpells()` selector
- These are **NOT** referenced in ClassDescriptions.lsx at all

---

## 📊 SpellList Breakdown (53 Total Nodes)

### 1. Base Class SpellLists (13 nodes)
| Level | SpellList Name | UUID | Spells Granted |
|-------|---------------|------|----------------|
| - | Class_SpellLists | 09d2d6d9-542d-488f-a51d-ea469e9d36c6 | Empty (organizational) |
| L1 | WoW_Warlock_Class_Level_1 | 9e2ec5ea-a47c-475a-b756-c0e0ca69a281 | Target_SummonDemon |
| L2 | WoW_Warlock_Class_Level_2 | 7e7c204e-0bcb-4ddb-9dd5-78a2f85cdfb2 | Empty |
| L3 | WoW_Warlock_Class_Level_3 | 59be68b9-a2e2-400a-9a2f-daae17f0c40a | Voidwalker summons (2) |
| L4 | WoW_Warlock_Class_Level_4 | 874b3746-8d60-4a90-aab0-bd656d1342d5 | Shout_UnendingResolve |
| L5 | WoW_Warlock_Class_Level_5 | dd824bd4-3afa-41e1-9120-4410f6b31e7c | Felhunter summons (2) |
| L6 | WoW_Warlock_Class_Level_6 | 6ed5c46a-61bc-431a-a3fd-16acf9081476 | Projectile_DrainLife |
| L7 | WoW_Warlock_Class_Level_7 | 99b1fb40-47da-4131-a804-16ecea4e5085 | Succubus/Incubus summons (4) |
| L8 | WoW_Warlock_Class_Level_8 | 368968fd-270d-4c05-b9c8-1495d3222a2b | Target_Fear |
| L9 | WoW_Warlock_Class_Level_9 | fe643b97-0c09-46ee-a3c6-98da8ba94ec3 | Target_CreateSoulstone |
| L10 | WoW_Warlock_Class_Level_10 | f93816a0-3639-452b-959e-e3b63ec82257 | Empty |
| L11 | WoW_Warlock_Class_Level_11 | 1cc306ed-4f58-4d00-aad8-82b8520bd6d6 | Empty |
| L12 | WoW_Warlock_Class_Level_12 | b9bec33f-fd30-4498-921c-6821529a66ba | Empty |

**Referenced In**: `Progressions.lsx` base class table via `AddSpells([UUID])`

### 2. Demonology SpellLists (13 nodes)
| Level | SpellList Name | UUID | Spells Granted |
|-------|---------------|------|----------------|
| - | Demonology_SpellLists | 28de3c50-3f61-4445-97b8-b24636d34d03 | Empty (organizational) |
| L1 | WoW_Warlock_Demo_Level_1 | aedc2c38-5a25-4033-bb19-f801f2e79101 | Projectile_Demo_Shadowbolt_1 |
| L2 | WoW_Warlock_Demo_Level_2 | 92355092-ac2f-48dc-8658-6ff1efa72685 | Felguard summons (2), HandOfGuldan |
| L3 | WoW_Warlock_Demo_Level_3 | c970cbf1-bc7f-4ff4-b9ae-6ee43e1b0737 | Projectile_Demo_Demonbolt_1 |
| L4 | WoW_Warlock_Demo_Level_4 | 287f33fc-9010-4a4d-b0a0-b9c7cc1b8018 | Projectile_Demo_CallDreadstalkers_1 |
| L5 | WoW_Warlock_Demo_Level_5 | 6f3563d0-88fa-4ce8-875c-4e41be8ff458 | Shout_DarkRegeneration |
| L6 | WoW_Warlock_Demo_Level_6 | b8ccbb62-9d37-454f-9abe-475067df728b | Shout_Demo_Mastery |
| L7 | WoW_Warlock_Demo_Level_7 | b8d86615-99a4-4fa8-b62b-922e7d085441 | Empty |
| L8 | WoW_Warlock_Demo_Level_8 | be391572-a846-4bcd-aae5-7917d2d87929 | Shout_DarkSoul_Knowledge |
| L9 | WoW_Warlock_Demo_Level_9 | 2a1e34a8-8545-4d41-b5cb-b5214d5e09d0 | Empty |
| L10 | WoW_Warlock_Demo_Level_10 | 2ff077a9-a3ef-40c7-bc34-e16c8dbcdef8 | Empty |
| L11 | WoW_Warlock_Demo_Level_11 | 82ca53eb-7287-4a0f-8a56-98dfe335d638 | Shout_DemonicPact |
| L12 | WoW_Warlock_Demo_Level_12 | f9e61954-a7a0-4505-ae1e-2f0a22b2bd2f | Empty |

**Referenced In**: `Progressions.lsx` Demonology subclass table via `AddSpells([UUID])`

### 3. Destruction SpellLists (14 nodes)
| Level | SpellList Name | UUID | Spells Granted |
|-------|---------------|------|----------------|
| - | Destruction_SpellLists | 633ee1ef-1e53-4ca2-ab3c-98e01ce989d9 | Empty (organizational) |
| L1 | WoW_Warlock_Destro_Level_1 | b751c5be-652a-46bc-a0f1-31d50a6fed73 | Projectile_Destro_Incinerate_1 |
| L2 | WoW_Warlock_Destro_Level_2 | fbd2ee26-1a51-4bfc-aba5-cc7388fd4417 | Projectile_Destro_Chaosbolt_1 |
| L3 | WoW_Warlock_Destro_Level_3 | aca056cc-49f0-4c6d-8ea5-086dfa64b495 | Target_Destro_Conflagrate_1 |
| L4-7 | WoW_Warlock_Destro_Level_4-7 | (4 UUIDs) | All empty |
| L8 | WoW_Warlock_Destro_Level_8 | e25ffcfa-8027-422e-9a33-9592b521a6ec | Shout_DarkSoul_Instability |
| L9-12 | WoW_Warlock_Destro_Level_9-12 | (4 UUIDs) | All empty |
| L12 Talent | WoW_Warlock_Destro_Level_12_Talent | dfc4c0cd-87da-47aa-93d4-2c0329599b54 | Empty |

**Referenced In**: `Progressions.lsx` Destruction subclass table via `AddSpells([UUID])`

### 4. Affliction SpellLists (13 nodes)
| Level | SpellList Name | UUID | Spells Granted |
|-------|---------------|------|----------------|
| - | Affliciton_SpellLists | 879bc166-b51f-4674-8c3f-a1786d34c25d | Empty (organizational) |
| L1 | WoW_Warlock_Aff_Level_1 | 185c0bd7-3da1-4dc4-94fc-a666ac4fd785 | Empty |
| L2 | WoW_Warlock_Aff_Level_2 | 0063a842-170d-4a70-b8d7-4ecfb8e1b125 | Shout_Aff_MaleficGrasp_1, Target_Aff_Agony_1 |
| L3 | WoW_Warlock_Aff_Level_3 | 8489dd2a-15a7-4935-83ae-552607ec2ad6 | Target_Aff_UnstableAffliction_1 |
| L4-5 | WoW_Warlock_Aff_Level_4-5 | (2 UUIDs) | Empty |
| L6 | WoW_Warlock_Aff_Level_6 | f7166afe-516f-4c87-92bb-f3cf8746fa98 | Shout_Aff_Mastery |
| L7 | WoW_Warlock_Aff_Level_7 | 03752c69-289b-4387-8563-24a6037b695a | Empty |
| L8 | WoW_Warlock_Aff_Level_8 | 1fdae767-57ea-414f-8026-89a05bbcbb9c | Shout_DarkSoul_Misery |
| L9-12 | WoW_Warlock_Aff_Level_9-12 | (4 UUIDs) | All empty |

**Referenced In**: `Progressions.lsx` Affliction subclass table via `AddSpells([UUID])`

---

## 🎯 Key Pattern Discovery

### The Dummy UUID Strategy

**In ClassDescriptions.lsx**:
```xml
<attribute id="SpellList" type="guid" value="32879c22-4858-48ef-8f8d-22e6d395b396"/>
```
- ✅ Used by ALL 4 ClassDescription nodes (base + 3 subclasses)
- ✅ This UUID is **NEVER defined** in SpellLists.lsx
- ✅ It's a placeholder that BG3 ignores

**In Progressions.lsx**:
```xml
<attribute id="Selectors" type="LSString" value="AddSpells(9e2ec5ea-a47c-475a-b756-c0e0ca69a281)"/>
```
- ✅ These UUIDs reference ACTUAL SpellList nodes from SpellLists.lsx
- ✅ This is where spells are granted at each level
- ✅ Each level can have its own SpellList with different spells

---

## 📋 Warlock Structure Summary

| Component | Count | Purpose |
|-----------|-------|---------|
| **ClassDescription Nodes** | 4 | Base + 3 subclasses |
| **ProgressionTableUUIDs** | 4 | One per ClassDescription |
| **Dummy SpellList UUID** | 1 | Used in all ClassDescriptions (placeholder) |
| **Actual SpellList Nodes** | 53 | Defined in SpellLists.lsx, referenced in Progressions |
| **Organizational SpellLists** | 4 | Empty nodes for grouping (Class, Demo, Destro, Aff) |
| **Functional SpellLists** | 49 | Actually grant spells via AddSpells() |

---

## 🔄 How Spells Are Granted (Step-by-Step)

### Example: Demonology Warlock Level 2

**Step 1**: Player selects Demonology subclass at L1
- `ClassDescription` node for Demonology is activated
- Has `SpellList = 32879c22...` (dummy, ignored)
- Has `ProgressionTableUUID = 6e4f6936...`

**Step 2**: Player reaches Level 2
- BG3 looks up Demonology's ProgressionTableUUID in `Progressions.lsx`
- Finds Level 2 node for Demonology progression

**Step 3**: Level 2 Progression Node executes
```xml
<attribute id="Selectors" type="LSString" value="AddSpells(92355092-ac2f-48dc-8658-6ff1efa72685);SelectPassives(...)"/>
```

**Step 4**: `AddSpells()` references SpellLists.lsx
- BG3 finds SpellList node with UUID `92355092...`
- This is `WoW_Warlock_Demo_Level_2`
- Contains: `Target_SummonDemon_Felguard_1;Projectile_Demo_HandOfGuldan_1;Target_SummonDemon_Felguard_2`

**Step 5**: Spells are granted to player
- Player receives 3 new spells at Level 2

---

## 🆚 Warlock vs Warrior SpellList Strategy

### Warlock Approach (53 SpellLists)
**Pros**:
- ✅ Highly organized (one SpellList per level per subclass)
- ✅ Easy to find which spells grant at which level
- ✅ Clean separation of class vs spec spells
- ✅ Can update L3 spells without touching L4 code

**Cons**:
- ❌ 53 UUIDs to manage
- ❌ Larger SpellLists.lsx file (~250 lines)
- ❌ More nodes to maintain

**Structure**:
- Base class: 13 SpellLists (L1-L12 + organizational)
- Demonology: 13 SpellLists (L1-L12 + organizational)
- Destruction: 14 SpellLists (L1-L12 + L12 talent + organizational)
- Affliction: 13 SpellLists (L1-L12 + organizational)

### Warrior Approach (1 Dummy UUID)
**Pros**:
- ✅ Minimal UUID management (just 1 dummy)
- ✅ No SpellLists.lsx file needed
- ✅ Simpler structure (fewer files)
- ✅ Proven to work (Warlock uses same dummy in ClassDescriptions)

**Cons**:
- ❌ All spells must be granted via other methods:
  - `PassivesAdded` for baseline abilities
  - `Boosts` with `UnlockSpell()` functors
  - Manual `AddSpells()` with inline spell names (not SpellList UUIDs)

**Structure**:
- ClassDescriptions: 7 nodes, all use dummy UUID `32879c22...`
- Progressions: Grant spells via PassivesAdded, not AddSpells()
- No SpellLists.lsx file

---

## 🎯 Hybrid Approach for Warrior (Recommended)

### Option 1: Minimal SpellLists (7 nodes)
Create ONE SpellList per ClassDescription node:
- `WoWWarrior_BaseSpells` (baseline abilities all classes get)
- `ArmsWarrior_SpecSpells` (Arms-specific abilities)
- `FuryWarrior_SpecSpells` (Fury-specific abilities)
- `ProtectionWarrior_SpecSpells` (Protection-specific abilities)
- `MountainThane_HeroSpells` (Mountain Thane abilities)
- `Colossus_HeroSpells` (Colossus abilities)
- `Slayer_HeroSpells` (Slayer abilities)

**Total**: 7 SpellList nodes (vs Warlock's 53)

**Usage**:
```xml
<!-- In Progressions.lsx, Arms L3 -->
<attribute id="Selectors" type="LSString" value="AddSpells([ARMS_SPELLLIST_UUID])"/>
```

**Pros**:
- ✅ All abilities in one place per class/spec/hero talent
- ✅ Only 7 UUIDs to manage
- ✅ Cleaner than 53 SpellLists
- ✅ More structured than 0 SpellLists

**Cons**:
- ❌ Can't easily separate L1 vs L3 vs L5 spells
- ❌ All abilities for that spec granted at once (need to control via Progressions)

### Option 2: Zero SpellLists (Current Warrior Approach)
**Keep using dummy UUID only**, grant spells via:
- `PassivesAdded` (e.g., `WAR_Arms_MortalStrike_Unlock`)
- Passives that use `Boosts="UnlockSpell(WAR_MortalStrike)"`

**Pros**:
- ✅ Already implemented in current Warrior mod
- ✅ No SpellLists.lsx needed
- ✅ Proven to work

**Cons**:
- ❌ Requires passive for every ability unlock
- ❌ Slightly less organized than Warlock's approach

### Option 3: Per-Level SpellLists (Full Warlock Clone)
Create 7 tables × 20 levels = **140 SpellList nodes**

**DO NOT RECOMMEND** - overkill for Warrior mod

---

## 💡 Recommendation for Warrior

### Use **Option 2: Zero SpellLists** (Current Approach)

**Why?**
1. ✅ Already implemented and working
2. ✅ Warrior abilities are primarily granted via passives (class talent system)
3. ✅ No additional file management overhead
4. ✅ Warlock proves dummy UUID works perfectly in ClassDescriptions
5. ✅ Simpler for users to understand (all ability grants in Progressions.lsx)

**When to Use AddSpells()**:
- If you later add spells that need to be learned (not auto-granted)
- If you want to organize baseline abilities separately
- Not needed for current talent-based system

**Example Progression Pattern**:
```xml
<!-- Level 3: Grant Mortal Strike via passive -->
<node id="Progression">
    <attribute id="Level" type="uint8" value="3"/>
    <attribute id="PassivesAdded" type="LSString" value="WAR_Arms_MortalStrike_Unlock"/>
    <!-- Passive uses: Boosts="UnlockSpell(WAR_MortalStrike)" -->
</node>
```

---

## 📊 Final Comparison Table

| Metric | Warlock (Base + 3 Specs) | Warrior (Base + 3 Specs + 3 Heroes) |
|--------|-------------------------|-------------------------------------|
| **ClassDescription Nodes** | 4 | 7 |
| **ProgressionTableUUIDs** | 4 | 7 |
| **Dummy SpellList UUID in ClassDescriptions** | 1 (shared) | 1 (shared) |
| **Actual SpellList Nodes** | 53 | 0 (recommended) |
| **Total SpellLists.lsx File** | 247 lines | Not created |
| **Spell Grant Method** | AddSpells([UUID]) | PassivesAdded="WAR_Passive" |
| **Ability Organization** | SpellLists.lsx | Passive.txt + Progressions.lsx |

---

## 🔑 Key Takeaway

**Warlock's 53 SpellLists are NOT required for a working mod.**

The dummy UUID `32879c22-4858-48ef-8f8d-22e6d395b396` in ClassDescriptions is sufficient. Warlock uses extensive SpellLists for organizational purposes and to grant multiple demons/spells at once, but Warrior's passive-based system works just as well (if not better) without them.

**Both approaches are valid:**
- Warlock: Organized spell grants via SpellLists
- Warrior: Direct ability grants via passives

**Warrior should stick with current zero-SpellList approach** unless there's a specific need for AddSpells() functionality.

---

**Last Updated**: October 20, 2025  
**Status**: ✅ Analysis complete - Warlock uses 53 SpellLists but dummy UUID in ClassDescriptions  
**Recommendation**: Warrior continues with zero SpellLists (current approach)
