# Warlock vs Warrior Hero Talents: Framework Comparison

**Created**: October 20, 2025  
**Purpose**: Compare WoWWarlock Hero Talents implementation with planned Warrior system  
**Sources**: 
- `Tests/02_ExampleMods/WoWWarlockHeroTalents/` (actual mod files)
- `Documentation/00_SourcesOfTruth/EXCEL_WARRIOR_PROGRESSION_ANALYSIS.md`
- `Documentation/00_SourcesOfTruth/Warrior Progression for all subclasses.xlsx`

---

## 🎯 Executive Summary

| Aspect | WoWWarlock Hero Talents | WoWWarrior Hero Talents (Excel Plan) | Match? |
|--------|------------------------|--------------------------------------|--------|
| **Architecture** | Separate ClassDescription nodes per hero talent | Same (3 specializations planned) | ✅ YES |
| **Subclass Count** | 3 (Demonology, Destruction, Affliction) | 3 (Arms, Fury, Protection) | ✅ YES |
| **Hero Talent Count** | 6 (2 per subclass) | 3 (shared across 2 subclasses each) | ⚠️ DIFFERENT |
| **L13 Selection** | Auto-granted (no player choice) | Pick 1 of 2-3 options | ⚠️ DIFFERENT |
| **L1 Grants** | All 11-14 passives at L1 | Keystone at L13, spread over L13-L20 | ❌ DIFFERENT |
| **Player Choices** | 6 choices (L2-L7, SelectPassives) | 1 choice (L13 pick specialization) | ❌ DIFFERENT |
| **Talent Spread** | L1-L8 (8 levels) | L13-L20 (5 levels: 13,15,17,19,20) | ❌ DIFFERENT |

**Key Finding**: ⚠️ **DIFFERENT SYSTEMS** - Warlock uses early-game auto-grant model, Warrior uses late-game progression model

---

## 🏗️ Architecture Comparison

### WoWWarlock Hero Talents Structure

**ClassDescriptions.lsx** (7 nodes total):
1. **Base Class**: WoWWarlockHero (UUID: `f69b6654-66e9-4ae8-9a49-689ced735265`)
2. **Diabolist (Demonology)**: DemoDiabolist (UUID: `440a3263...`)
3. **Diabolist (Destruction)**: DestroDiabolist (UUID: `5fabf07c...`)
4. **Soul Harvester (Affliction)**: AffSoulHarvester (UUID: `33a596f6...`)
5. **Soul Harvester (Demonology)**: DemoSoulHarvester (UUID: `2b08637f...`)
6. **Hellcaller (Destruction)**: DestroHellcaller (UUID: `1a0c98de...`)
7. **Hellcaller (Affliction)**: AffHellcaller (UUID: `aa2a4e31...`)

**Pattern**: 1 base + 6 hero talents (2 per subclass, each hero talent unique)

**ParentGuid**: ALL 6 hero talents reference base class UUID (`f69b6654...`)

---

### Warrior Hero Talents Structure (Planned)

**ClassDescriptions.lsx** (TBD - likely 7 nodes):
1. **Base Class**: WoWWarrior (UUID: `78fe4967-4e62-5491-d981-dd781acca4d7`)
2. **Arms**: ArmsWarrior (UUID: TBD)
3. **Fury**: FuryWarrior (UUID: TBD) 
4. **Protection**: ProtectionWarrior (UUID: TBD)
5. **Mountain Thane** (Fury + Protection): MountainThane (UUID: TBD)
6. **Colossus** (Arms + Protection): Colossus (UUID: TBD)
7. **Slayer** (Arms + Fury): Slayer (UUID: TBD)

**Pattern**: 1 base + 3 subclasses + 3 hero talents (shared across 2 subclasses each)

**Key Difference**: Warlock has 6 hero talents (unique per subclass), Warrior has 3 (shared)

---

## 📊 Progression Comparison

### WoWWarlock Hero Talents Progression

**Example: DemoDiabolist**

```xml
<!-- L1: ALL TALENTS AT ONCE -->
<node id="Progression">
    <attribute id="Level" type="uint8" value="1"/>
    <attribute id="Name" type="LSString" value="DemoDiabolist"/>
    <attribute id="PassivesAdded" type="LSString" value="WoWWarlock_Unlock_DiabolicRitual_Demo;DiabolicRitual_Demo_Fellord;DiabolicRitual_Demo_MotherOfChaos;DiabolicRitual_Demo_PitLord;DiabolicRitual_Fellord_1;DiabolicRitual_MotherOfChaos_1;DiabolicRitual_PitLord_1;WoWWarlock_Diabolist_DemonicCore_HandOfGuldan_1;WoWWarlock_Diabolist_DemonicCore_HandOfGuldan_2;WoWWarlock_Diabolist_DemonicCore_HandOfGuldan_3;WoWWarlock_Diabolist_SouLeech_HandOfGuldan;WoWWarlock_Diabolist_SoulConduit_HandOfGuldan_1;WoWWarlock_Diabolist_SoulConduit_HandOfGuldan_2;WoWWarlock_Diabolist_SoulConduit_HandOfGuldan_3"/>
    <attribute id="Selectors" type="LSString" value="AddSpells(71f788ac-dced-4cdc-b718-dc506d16c283)"/>
</node>

<!-- L2: Choice Node -->
<node id="Progression">
    <attribute id="Level" type="uint8" value="2"/>
    <attribute id="Name" type="LSString" value="DemoDiabolist"/>
    <attribute id="Selectors" type="LSString" value="SelectPassives(6ec0fba1-0d0e-4c06-9f89-5f14d792d5c0,1,WoWWarlockDiabolistOfensive)"/>
</node>

<!-- L3-L6: More Choice Nodes -->
<!-- L7: Capstone -->
<node id="Progression">
    <attribute id="Level" type="uint8" value="7"/>
    <attribute id="Name" type="LSString" value="DemoDiabolist"/>
    <attribute id="PassivesAdded" type="LSString" value="Diabolist_Demo_Ruination"/>
</node>
```

**Key Observations**:
- ✅ **L1**: Grants 14 passives immediately (keystone + all base talents)
- ✅ **L2-L6**: SelectPassives choices (pick 1 per level)
- ✅ **L7**: Capstone auto-granted
- ✅ **Total**: 6 player choices (L2-L6 + capstone auto)

**Warlock Model**: **Front-loaded** (all talents at L1, choices at L2-L7)

---

### Warrior Hero Talents Progression (Excel Plan)

**Example: Mountain Thane** (from EXCEL_WARRIOR_PROGRESSION_ANALYSIS.md)

```
L13: Lightning Strikes (keystone) - auto-granted
L14: Empty
L15: Crashing Thunder + Ground Current + Strength of the Mountain (3 passives auto-granted)
L16: Empty (Feat/ASI only)
L17: Thunder Blast + Storm Bolts + Keep your feet on the Ground (3 passives auto-granted)
L18: Empty
L19: Flashing Skies + Thorim's Might + Burst of Power (3 passives auto-granted)
L20: Avatar of the Storm (capstone) - auto-granted
```

**Key Observations**:
- ✅ **L13**: Keystone only (1 passive)
- ✅ **L15/L17/L19**: 3 passives each (all granted, no choice)
- ✅ **L20**: Capstone (1 passive)
- ✅ **Total**: 0 player choices after L13 (all auto-granted)

**Warrior Model**: **Back-loaded** (progression over L13-L20, no mid-tier choices)

---

## 🔍 Key Differences

### 1. Talent Grant Timing

| System | Keystone | Mid-Tier Talents | Capstone | Total Levels |
|--------|----------|------------------|----------|--------------|
| **Warlock** | L1 (14 passives at once) | L2-L6 (choices) | L7 | 7 levels |
| **Warrior** | L13 (1 passive) | L15/L17/L19 (auto-grant) | L20 | 5 levels |

**Implication**: Warlock front-loads complexity, Warrior spreads it across endgame

---

### 2. Player Choice Model

| System | Specialization Choice | Mid-Tier Choices | Total Choices |
|--------|----------------------|------------------|---------------|
| **Warlock** | L1 (implicit via subclass pick) | 5-6 SelectPassives (L2-L6) | 6 choices |
| **Warrior** | L13 (explicit pick 1 of 2-3) | **0** (all auto-granted) | 1 choice |

**Implication**: Warlock offers more customization, Warrior offers simpler progression

---

### 3. Hero Talent Distribution

| System | Hero Talents per Subclass | Total Hero Talents | Sharing |
|--------|---------------------------|-------------------|---------|
| **Warlock** | 2 unique | 6 (3×2) | None |
| **Warrior** | 2 shared | 3 total | Each shared by 2 subclasses |

**Warlock**: Diabolist + Soul Harvester (Demonology), Diabolist + Hellcaller (Destruction), Soul Harvester + Hellcaller (Affliction)  
**Warrior**: Mountain Thane (Fury+Protection), Colossus (Arms+Protection), Slayer (Arms+Fury)

**Implication**: Warrior has fewer unique hero talents (3 vs 6) but more cross-spec synergy

---

### 4. ClassDescription Node Architecture

| System | ClassDescription Nodes | ParentGuid Structure |
|--------|----------------------|---------------------|
| **Warlock** | 7 (1 base + 6 hero talents) | All 6 hero talents → base class |
| **Warrior** | 7 (1 base + 3 subclasses + 3 hero talents) | 3 subclasses → base, 3 hero talents → ??? |

**Critical Question**: Do Warrior hero talents have ParentGuid = base class OR subclass?

**Warlock Precedent**: Hero talents reference **base class** UUID, not subclass UUID

**Implication**: Warrior hero talents should likely reference base Warrior UUID (`78fe4967...`)

---

## ⚙️ Implementation Implications for Warrior

### Option A: Follow Warlock Model Exactly
- Grant all 11 talents at L13 (same as Warlock L1)
- Add SelectPassives choices at L14-L19
- Capstone at L20
- **Pro**: Proven working model
- **Con**: Excel plan expects L13/15/17/19/20 spread

### Option B: Follow Excel Plan (Current)
- Keystone at L13
- Auto-grant 3 talents at L15, L17, L19
- Capstone at L20
- **Pro**: Matches Excel design
- **Con**: Deviates from Warlock proven model

### Option C: Hybrid Model
- Keystone + tier 1 (4 passives) at L13
- Tier 2 (3 passives) at L15
- Tier 3 (3 passives) at L17
- Tier 4 (1-2 passives) at L19
- Capstone at L20
- **Pro**: Front-loads more like Warlock, follows Excel levels
- **Con**: More complexity

---

## 🎯 Recommendation

**Follow Excel Plan (Option B)** with Warlock structural patterns:

### Structural (Warlock-aligned):
✅ Use 7 ClassDescription nodes (1 base + 3 subclasses + 3 hero talents)  
✅ Hero talent ParentGuid = base Warrior UUID (`78fe4967...`)  
✅ Use same dummy SpellList UUID (`32879c22...`)  
✅ Separate Progressions.lsx entries per hero talent

### Progression (Excel-aligned):
✅ L13: Keystone only (1 passive)  
✅ L15: 3 passives auto-granted  
✅ L17: 3 passives auto-granted  
✅ L19: 3 passives auto-granted  
✅ L20: Capstone (1 passive)

### Rationale:
- Excel plan is user-approved design
- Warlock's structural patterns are proven to work
- Progression timing differences won't cause crashes (just different UX)
- Simpler for players (1 choice at L13, then auto-progression)

---

## 📋 Validation Checklist

When implementing Warrior hero talents:

- [ ] ✅ 7 ClassDescription nodes total (1 base + 3 subclasses + 3 hero talents)
- [ ] ✅ Hero talent ParentGuid = base Warrior UUID
- [ ] ✅ All hero talents use dummy SpellList UUID
- [ ] ✅ Each hero talent has unique ProgressionTableUUID
- [ ] ✅ Separate progression entries for each hero talent
- [ ] ✅ L13 grants keystone passive only
- [ ] ✅ L15/L17/L19 grant 3 passives each (semicolon-separated in PassivesAdded)
- [ ] ✅ L20 grants capstone passive
- [ ] ✅ Empty progressions at L14, L16, L18 (no attributes except Level, Name, TableUUID, UUID)
- [ ] ✅ All passives follow naming convention: `WAR_[SpecName]_[TalentName]`

---

## 🔗 Cross-References

### Warlock Files Examined:
- `Tests/02_ExampleMods/WoWWarlockHeroTalents/Public/.../ClassDescriptions/ClassDescriptions.lsx`
- `Tests/02_ExampleMods/WoWWarlockHeroTalents/Public/.../Progressions/Progressions.lsx`

### Warrior Design Documents:
- `Documentation/00_SourcesOfTruth/EXCEL_WARRIOR_PROGRESSION_ANALYSIS.md` (L13-L20 details)
- `Documentation/00_SourcesOfTruth/Warrior Progression for all subclasses.xlsx` (Cols 56-64)
- `Documentation/00_SourcesOfTruth/HERO_TALENTS_OVERVIEW.md` (this session's overview)

### Implementation Templates:
- `Transformation_Templates/FILE_02_ClassDescriptions.lsx_TEMPLATE.md` (structure reference)

---

**Last Updated**: October 20, 2025  
**Status**: ✅ Comparison complete, ready for Section [5] documentation with hybrid approach
