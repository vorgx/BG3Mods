# Warrior SpellList Breakdown (Warlock-Style Structure)

**Created**: October 20, 2025  
**Purpose**: Show what Warrior's SpellLists would look like if using Warlock's per-level approach  
**Based On**: Excel "Warrior Progression for all subclasses.xlsx" + Warlock SpellList patterns  
**Note**: This is for **comparison only** - Warrior currently uses zero SpellLists (recommended approach)

---

## 📊 Total SpellList Count (If Using Warlock Approach)

| Category | Count | Notes |
|----------|-------|-------|
| **Base Warrior (L1-L20)** | 21 | 1 organizational + 20 levels |
| **Arms (L1-L12)** | 13 | 1 organizational + 12 levels |
| **Fury (L1-L12)** | 13 | 1 organizational + 12 levels |
| **Protection (L1-L12)** | 13 | 1 organizational + 12 levels |
| **Mountain Thane (L13-L20)** | 9 | 1 organizational + 8 levels |
| **Colossus (L13-L20)** | 9 | 1 organizational + 8 levels |
| **Slayer (L13-L20)** | 9 | 1 organizational + 8 levels |
| **TOTAL** | **87 SpellList nodes** | vs Warlock's 53 |

**Why More Than Warlock?**
- Warlock stops at L13 (base class L1-12 + empty L13)
- Warrior continues to L20 (base class L1-20)
- Hero talents add L13-L20 progression

---

## 📋 SpellList Breakdown by Category

### 1. Base Warrior SpellLists (21 nodes)

**Purpose**: Abilities ALL Warriors get regardless of subclass (Warrior Class Talents only - no baseline abilities)

| Level | SpellList Name | UUID | Spells Granted | Notes |
|-------|---------------|------|----------------|-------|
| - | Warrior_Class_SpellLists | `[UUID_ORG_BASE]` | Empty | Organizational node |
| **L1** | WoW_Warrior_Class_Level_1 | `[UUID_BASE_L1]` | Empty | Row 1 stances granted via PassivesAdded |
| **L2** | WoW_Warrior_Class_Level_2 | `[UUID_BASE_L2]` | Empty | Row 2 talents granted via SelectPassives |
| **L3** | WoW_Warrior_Class_Level_3 | `[UUID_BASE_L3]` | Empty | Row 3 talents granted via SelectPassives |
| **L4** | WoW_Warrior_Class_Level_4 | `[UUID_BASE_L4]` | Empty | Row 4 talents granted via SelectPassives |
| **L5** | WoW_Warrior_Class_Level_5 | `[UUID_BASE_L5]` | Empty | Row 5 talents granted via SelectPassives |
| **L6** | WoW_Warrior_Class_Level_6 | `[UUID_BASE_L6]` | Empty | Row 6 talents granted via SelectPassives |
| **L7** | WoW_Warrior_Class_Level_7 | `[UUID_BASE_L7]` | Empty | Row 7 talents granted via SelectPassives |
| **L8** | WoW_Warrior_Class_Level_8 | `[UUID_BASE_L8]` | Empty | Row 8 talents granted via SelectPassives |
| **L9** | WoW_Warrior_Class_Level_9 | `[UUID_BASE_L9]` | Empty | Row 9 talents granted via SelectPassives |
| **L10** | WoW_Warrior_Class_Level_10 | `[UUID_BASE_L10]` | Empty | Row 10 talents granted via SelectPassives |
| **L11** | WoW_Warrior_Class_Level_11 | `[UUID_BASE_L11]` | Empty | No class talents this level |
| **L12** | WoW_Warrior_Class_Level_12 | `[UUID_BASE_L12]` | Empty | Feat/ASI only |
| **L13** | WoW_Warrior_Class_Level_13 | `[UUID_BASE_L13]` | Empty | Hero talent selection via SubClasses |
| **L14** | WoW_Warrior_Class_Level_14 | `[UUID_BASE_L14]` | Empty | No grants (hero talents handle) |
| **L15** | WoW_Warrior_Class_Level_15 | `[UUID_BASE_L15]` | Empty | No grants (hero talents handle) |
| **L16** | WoW_Warrior_Class_Level_16 | `[UUID_BASE_L16]` | Empty | Feat/ASI only |
| **L17** | WoW_Warrior_Class_Level_17 | `[UUID_BASE_L17]` | Empty | No grants (hero talents handle) |
| **L18** | WoW_Warrior_Class_Level_18 | `[UUID_BASE_L18]` | Empty | No grants |
| **L19** | WoW_Warrior_Class_Level_19 | `[UUID_BASE_L19]` | Empty | No grants (hero talents handle) |
| **L20** | WoW_Warrior_Class_Level_20 | `[UUID_BASE_L20]` | Empty | Feat/ASI only (hero talents handle capstone) |

**Referenced In**: `Progressions.lsx` base Warrior table via `AddSpells([UUID])`

**Key Insight**: All base class SpellLists would be **empty** because:
- Class talents granted via `SelectPassives()`, not `AddSpells()`
- Baseline abilities granted via subclass progression, not base class

---

### 2. Arms Warrior SpellLists (13 nodes)

**Purpose**: Baseline abilities + spec talents for Arms specialization

| Level | SpellList Name | UUID | Spells Granted (from Excel) | Notes |
|-------|---------------|------|----------------------------|-------|
| - | ArmsWarrior_Spec_SpellLists | `[UUID_ORG_ARMS]` | Empty | Organizational node |
| **L1** | WoW_Warrior_Arms_Level_1 | `[UUID_ARMS_L1]` | WAR_Whirlwind; WAR_Charge | Baseline offensive + utility |
| **L2** | WoW_Warrior_Arms_Level_2 | `[UUID_ARMS_L2]` | Empty | No baseline abilities |
| **L3** | WoW_Warrior_Arms_Level_3 | `[UUID_ARMS_L3]` | WAR_Execute; WAR_Pummel; WAR_MortalStrike | Baseline + Row 1 signature |
| **L4** | WoW_Warrior_Arms_Level_4 | `[UUID_ARMS_L4]` | WAR_Overpower | Row 2 baseline |
| **L5** | WoW_Warrior_Arms_Level_5 | `[UUID_ARMS_L5]` | WAR_Hamstring; WAR_BattleShout | Baseline utility |
| **L6** | WoW_Warrior_Arms_Level_6 | `[UUID_ARMS_L6]` | Empty | Row 4 talents via SelectPassives |
| **L7** | WoW_Warrior_Arms_Level_7 | `[UUID_ARMS_L7]` | WAR_Slam; WAR_BerserkerRage; WAR_ColossusSmash | Baseline + Row 5 signature |
| **L8** | WoW_Warrior_Arms_Level_8 | `[UUID_ARMS_L8]` | Empty | Row 6 talents via SelectPassives |
| **L9** | WoW_Warrior_Arms_Level_9 | `[UUID_ARMS_L9]` | WAR_VictoryRush; WAR_Taunt | Baseline utility |
| **L10** | WoW_Warrior_Arms_Level_10 | `[UUID_ARMS_L10]` | Empty | Row 8 talents via SelectPassives |
| **L11** | WoW_Warrior_Arms_Level_11 | `[UUID_ARMS_L11]` | WAR_HeroicThrow | Baseline utility |
| **L12** | WoW_Warrior_Arms_Level_12 | `[UUID_ARMS_L12]` | WAR_ShieldSlam | Baseline offensive |

**Referenced In**: `Progressions.lsx` Arms subclass table via `AddSpells([UUID])`

**Total Abilities via SpellLists**: 12 baseline abilities across 7 levels (L1, L3, L4, L5, L7, L9, L11, L12)

---

### 3. Fury Warrior SpellLists (13 nodes)

**Purpose**: Baseline abilities + spec talents for Fury specialization

| Level | SpellList Name | UUID | Spells Granted (from Excel) | Notes |
|-------|---------------|------|----------------------------|-------|
| - | FuryWarrior_Spec_SpellLists | `[UUID_ORG_FURY]` | Empty | Organizational node |
| **L1** | WoW_Warrior_Fury_Level_1 | `[UUID_FURY_L1]` | WAR_Whirlwind; WAR_BerserkerRage; WAR_BattleStance; WAR_DefensiveStance | Baseline + stances |
| **L2** | WoW_Warrior_Fury_Level_2 | `[UUID_FURY_L2]` | Empty | No baseline abilities |
| **L3** | WoW_Warrior_Fury_Level_3 | `[UUID_FURY_L3]` | WAR_Slam; WAR_Charge; WAR_Bloodthirst | Baseline + Row 1 signature |
| **L4** | WoW_Warrior_Fury_Level_4 | `[UUID_FURY_L4]` | WAR_RagingBlow | Row 2 baseline |
| **L5** | WoW_Warrior_Fury_Level_5 | `[UUID_FURY_L5]` | WAR_VictoryRush; WAR_Pummel | Baseline utility |
| **L6** | WoW_Warrior_Fury_Level_6 | `[UUID_FURY_L6]` | Empty | Row 4 talents via SelectPassives |
| **L7** | WoW_Warrior_Fury_Level_7 | `[UUID_FURY_L7]` | WAR_Execute; WAR_BattleShout; WAR_Rampage | Baseline + Row 5 signature |
| **L8** | WoW_Warrior_Fury_Level_8 | `[UUID_FURY_L8]` | Empty | Row 6 talents via SelectPassives |
| **L9** | WoW_Warrior_Fury_Level_9 | `[UUID_FURY_L9]` | WAR_Hamstring; WAR_Taunt; WAR_Recklessness | Baseline + Row 7 signature |
| **L10** | WoW_Warrior_Fury_Level_10 | `[UUID_FURY_L10]` | Empty | Row 8 talents via SelectPassives |
| **L11** | WoW_Warrior_Fury_Level_11 | `[UUID_FURY_L11]` | WAR_HeroicThrow | Baseline utility |
| **L12** | WoW_Warrior_Fury_Level_12 | `[UUID_FURY_L12]` | WAR_ShieldSlam | Baseline offensive |

**Referenced In**: `Progressions.lsx` Fury subclass table via `AddSpells([UUID])`

**Total Abilities via SpellLists**: 14 baseline abilities across 7 levels

---

### 4. Protection Warrior SpellLists (13 nodes)

**Purpose**: Baseline abilities + spec talents for Protection specialization

| Level | SpellList Name | UUID | Spells Granted (from Excel) | Notes |
|-------|---------------|------|----------------------------|-------|
| - | ProtectionWarrior_Spec_SpellLists | `[UUID_ORG_PROT]` | Empty | Organizational node |
| **L1** | WoW_Warrior_Prot_Level_1 | `[UUID_PROT_L1]` | WAR_ShieldSlam; WAR_Taunt; WAR_Mastery_CriticalBlock | Baseline + passive |
| **L2** | WoW_Warrior_Prot_Level_2 | `[UUID_PROT_L2]` | Empty | No baseline abilities |
| **L3** | WoW_Warrior_Prot_Level_3 | `[UUID_PROT_L3]` | WAR_Devastate; WAR_ShieldBlock; WAR_Riposte; WAR_IgnorePain | Baseline + passives + Row 1 |
| **L4** | WoW_Warrior_Prot_Level_4 | `[UUID_PROT_L4]` | Empty | Row 2 choice nodes |
| **L5** | WoW_Warrior_Prot_Level_5 | `[UUID_PROT_L5]` | WAR_HeroicThrow; WAR_Charge; WAR_ShieldBlock_2ndCharge | Baseline + passive |
| **L6** | WoW_Warrior_Prot_Level_6 | `[UUID_PROT_L6]` | Empty | Row 4 talents via SelectPassives |
| **L7** | WoW_Warrior_Prot_Level_7 | `[UUID_PROT_L7]` | WAR_Slam; WAR_Pummel; WAR_Vanguard | Baseline + Row 5 passive |
| **L8** | WoW_Warrior_Prot_Level_8 | `[UUID_PROT_L8]` | Empty | Row 6 talents via SelectPassives |
| **L9** | WoW_Warrior_Prot_Level_9 | `[UUID_PROT_L9]` | WAR_VictoryRush | Baseline offensive |
| **L10** | WoW_Warrior_Prot_Level_10 | `[UUID_PROT_L10]` | WAR_Execute | Baseline offensive |
| **L11** | WoW_Warrior_Prot_Level_11 | `[UUID_PROT_L11]` | WAR_Hamstring; WAR_BattleShout | Baseline utility |
| **L12** | WoW_Warrior_Prot_Level_12 | `[UUID_PROT_L12]` | WAR_Whirlwind | Baseline offensive |

**Referenced In**: `Progressions.lsx` Protection subclass table via `AddSpells([UUID])`

**Total Abilities via SpellLists**: 15 baseline abilities + 4 passives across 9 levels

---

### 5. Mountain Thane SpellLists (9 nodes)

**Purpose**: Hero talent passives for Mountain Thane (Fury/Protection specialization)

| Level | SpellList Name | UUID | Spells Granted (from Excel) | Notes |
|-------|---------------|------|----------------------------|-------|
| - | MountainThane_Hero_SpellLists | `[UUID_ORG_MT]` | Empty | Organizational node |
| **L13** | WoW_Warrior_MT_Level_13 | `[UUID_MT_L13]` | WAR_MountainThane_LightningStrikes | Keystone passive |
| **L14** | WoW_Warrior_MT_Level_14 | `[UUID_MT_L14]` | Empty | No grants |
| **L15** | WoW_Warrior_MT_Level_15 | `[UUID_MT_L15]` | WAR_MT_CrashingThunder; WAR_MT_GroundCurrent; WAR_MT_StrengthOfMountain | 3 passives auto-granted |
| **L16** | WoW_Warrior_MT_Level_16 | `[UUID_MT_L16]` | Empty | No grants |
| **L17** | WoW_Warrior_MT_Level_17 | `[UUID_MT_L17]` | WAR_MT_ThunderBlast; WAR_MT_StormBolts; WAR_MT_KeepFeetOnGround | 3 passives auto-granted |
| **L18** | WoW_Warrior_MT_Level_18 | `[UUID_MT_L18]` | Empty | No grants |
| **L19** | WoW_Warrior_MT_Level_19 | `[UUID_MT_L19]` | WAR_MT_FlashingSkies; WAR_MT_ThorimsMight; WAR_MT_BurstOfPower | 3 passives auto-granted |
| **L20** | WoW_Warrior_MT_Level_20 | `[UUID_MT_L20]` | WAR_MT_AvatarOfStorm | Capstone passive |

**Referenced In**: `Progressions.lsx` Mountain Thane table via `AddSpells([UUID])`

**Total Passives via SpellLists**: 11 (1 + 3 + 3 + 3 + 1)

---

### 6. Colossus SpellLists (9 nodes)

**Purpose**: Hero talent passives for Colossus (Arms/Protection specialization)

| Level | SpellList Name | UUID | Spells Granted (from Excel) | Notes |
|-------|---------------|------|----------------------------|-------|
| - | Colossus_Hero_SpellLists | `[UUID_ORG_COL]` | Empty | Organizational node |
| **L13** | WoW_Warrior_Col_Level_13 | `[UUID_COL_L13]` | WAR_Colossus_Demolish | Keystone passive |
| **L14** | WoW_Warrior_Col_Level_14 | `[UUID_COL_L14]` | Empty | No grants |
| **L15** | WoW_Warrior_Col_Level_15 | `[UUID_COL_L15]` | WAR_Col_MountainsWillFall; WAR_Col_OnehandedWeaponSpec; WAR_Col_TitanicRage | 3 passives auto-granted |
| **L16** | WoW_Warrior_Col_Level_16 | `[UUID_COL_L16]` | Empty | No grants |
| **L17** | WoW_Warrior_Col_Level_17 | `[UUID_COL_L17]` | WAR_Col_ColossalMight; WAR_Col_Boneshaker; WAR_Col_FuriousBlows | 3 passives auto-granted |
| **L18** | WoW_Warrior_Col_Level_18 | `[UUID_COL_L18]` | Empty | No grants |
| **L19** | WoW_Warrior_Col_Level_19 | `[UUID_COL_L19]` | WAR_Col_Earthquaker; WAR_Col_ApexTotem; WAR_Col_ImmovableObject | 3 passives auto-granted |
| **L20** | WoW_Warrior_Col_Level_20 | `[UUID_COL_L20]` | WAR_Col_DominanceOfColossus | Capstone passive |

**Referenced In**: `Progressions.lsx` Colossus table via `AddSpells([UUID])`

**Total Passives via SpellLists**: 11 (1 + 3 + 3 + 3 + 1)

---

### 7. Slayer SpellLists (9 nodes)

**Purpose**: Hero talent passives for Slayer (Arms/Fury specialization)

| Level | SpellList Name | UUID | Spells Granted (from Excel) | Notes |
|-------|---------------|------|----------------------------|-------|
| - | Slayer_Hero_SpellLists | `[UUID_ORG_SLY]` | Empty | Organizational node |
| **L13** | WoW_Warrior_Sly_Level_13 | `[UUID_SLY_L13]` | WAR_Slayer_SlayersDominance | Keystone passive |
| **L14** | WoW_Warrior_Sly_Level_14 | `[UUID_SLY_L14]` | Empty | No grants |
| **L15** | WoW_Warrior_Sly_Level_15 | `[UUID_SLY_L15]` | WAR_Sly_CullingCyclone; WAR_Sly_Opportunist; WAR_Sly_OverwhelmingBlades | 3 passives auto-granted |
| **L16** | WoW_Warrior_Sly_Level_16 | `[UUID_SLY_L16]` | Empty | No grants |
| **L17** | WoW_Warrior_Sly_Level_17 | `[UUID_SLY_L17]` | WAR_Sly_ViciousAgility; WAR_Sly_Bloodletting; WAR_Sly_MarkedForExecution | 3 passives auto-granted |
| **L18** | WoW_Warrior_Sly_Level_18 | `[UUID_SLY_L18]` | Empty | No grants |
| **L19** | WoW_Warrior_Sly_Level_19 | `[UUID_SLY_L19]` | WAR_Sly_FierceFollowthrough; WAR_Sly_Reap; WAR_Sly_DeathDrive | 3 passives auto-granted |
| **L20** | WoW_Warrior_Sly_Level_20 | `[UUID_SLY_L20]` | WAR_Sly_UnrelentingOnslaught | Capstone passive |

**Referenced In**: `Progressions.lsx` Slayer table via `AddSpells([UUID])`

**Total Passives via SpellLists**: 11 (1 + 3 + 3 + 3 + 1)

---

## 📊 Summary Comparison

### Warlock vs Warrior SpellList Structure

| Metric | Warlock (L1-L13) | Warrior (L1-L20) |
|--------|------------------|------------------|
| **Base Class SpellLists** | 13 nodes (L1-12 + org) | 21 nodes (L1-20 + org) |
| **Subclass 1 SpellLists** | 13 nodes (Demo) | 13 nodes (Arms) |
| **Subclass 2 SpellLists** | 14 nodes (Destro) | 13 nodes (Fury) |
| **Subclass 3 SpellLists** | 13 nodes (Aff) | 13 nodes (Protection) |
| **Hero Talent 1 SpellLists** | N/A | 9 nodes (Mountain Thane) |
| **Hero Talent 2 SpellLists** | N/A | 9 nodes (Colossus) |
| **Hero Talent 3 SpellLists** | N/A | 9 nodes (Slayer) |
| **TOTAL** | **53 nodes** | **87 nodes** |
| **Empty SpellLists** | ~25 (48%) | ~45 (52%) |
| **Functional SpellLists** | ~28 | ~42 |

---

## 🎯 Key Insights

### Why So Many Empty SpellLists?

**Base Warrior (21 nodes)**:
- **ALL empty** because class talents granted via `SelectPassives()`, not `AddSpells()`
- Baseline abilities granted via subclass SpellLists, not base class

**Arms/Fury/Protection (13 nodes each)**:
- **~6-7 empty per spec** (levels with no baseline abilities)
- Only levels with baseline ability grants need populated SpellLists
- Talent choices still use `SelectPassives()`, not `AddSpells()`

**Hero Talents (9 nodes each)**:
- **5 empty per hero talent** (L14, L16, L18 always empty)
- Only L13, L15, L17, L19, L20 grant passives

### Efficiency Analysis

**Warlock Approach**:
- 53 SpellList nodes
- 25 empty (placeholder structure)
- 28 functional (actually grant spells)
- **Efficiency**: 53% functional

**Warrior (If Using Warlock Approach)**:
- 87 SpellList nodes
- 45 empty (placeholder structure)
- 42 functional (actually grant abilities/passives)
- **Efficiency**: 48% functional

**Current Warrior Approach (Zero SpellLists)**:
- 0 SpellList nodes
- All grants via `PassivesAdded` or `SelectPassives()` in Progressions.lsx
- **Efficiency**: 100% (no placeholder nodes)

---

## 💡 Recommendation: Stick with Zero SpellLists

### Why Current Warrior Approach is Better

**Warlock uses SpellLists because**:
- Grants multiple demon summons at once (4 variants of Succubus/Incubus at L7)
- Organizational preference (one SpellList per level)
- Easier to see "what spells grant at L5" in one place

**Warrior doesn't need SpellLists because**:
- Baseline abilities granted via passives (e.g., `WAR_Arms_MortalStrike_Unlock`)
- Class/spec talents use `SelectPassives()` (player choice, not auto-grant)
- Hero talents are all passives (granted via `PassivesAdded`)
- **52% of SpellLists would be empty placeholders**

### Current Implementation Pattern (Recommended)

**Progressions.lsx**:
```xml
<!-- Arms Level 3: Grant baseline abilities + spec Row 1 -->
<node id="Progression">
    <attribute id="Level" type="uint8" value="3"/>
    <attribute id="Name" type="LSString" value="ArmsWarrior"/>
    <attribute id="PassivesAdded" type="LSString" value="WAR_Arms_Execute_Unlock;WAR_Arms_Pummel_Unlock;WAR_Arms_MortalStrike_Unlock"/>
    <attribute id="ProgressionType" type="uint8" value="1"/>
    <attribute id="Selectors" type="LSString" value="SelectPassives([UUID],1,ArmsSpecTalentRow1)"/>
    <attribute id="TableUUID" type="guid" value="[UUID_2_ARMS]"/>
    <attribute id="UUID" type="guid" value="[UNIQUE_UUID]"/>
</node>
```

**Passive.txt**:
```
new entry "WAR_Arms_MortalStrike_Unlock"
type "PassiveData"
data "Boosts" "UnlockSpell(WAR_MortalStrike)"
```

**Result**: Same functionality as SpellList approach, but without 87 UUID management overhead.

---

## 📋 If You Ever Need SpellLists (Future Use Cases)

### When to Create SpellLists.lsx

**Use Case 1**: Granting multiple ability variants at once
- Example: Arms gets 3 different Execute variants based on talent choices
- Create SpellList with all 3, reference via `AddSpells([UUID])`

**Use Case 2**: Learnable spells (not auto-granted)
- Example: Warrior Grimoire system (learn abilities from items)
- Create SpellList of learnable abilities

**Use Case 3**: Organizational preference
- If you prefer seeing "all L5 grants" in one SpellList node
- Easier to update in future (change SpellList, not Progressions.lsx)

**How to Implement**:
1. Create `Lists/SpellLists.lsx` with 87 nodes (use structure above)
2. Update `Progressions.lsx` to use `AddSpells([UUID])` instead of `PassivesAdded`
3. Remove unlock passives from `Passive.txt`

**Effort**: ~4-6 hours to refactor from current approach

---

**Last Updated**: October 20, 2025  
**Status**: ✅ Complete Warlock-style breakdown created for comparison  
**Recommendation**: Continue using zero SpellLists (current approach more efficient for Warrior)
