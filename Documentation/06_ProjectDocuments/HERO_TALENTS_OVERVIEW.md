# Hero Talents System Overview (L13-L20)

**Source**: `Warrior Progression for all subclasses.xlsx` (Columns 56-64)  
**Created**: October 20, 2025  
**Status**: ✅ Validated from Excel

---

## What Are Hero Talents?

**Hero Talents** are the **Level 13-20 specialization system** for Warriors. At Level 13, players choose **ONE of THREE specializations** that grant powerful passive abilities and mechanics for the endgame.

### Key Characteristics

| Aspect | Details |
|--------|---------|
| **Unlock Level** | 13 |
| **Choice System** | Pick 1 of 3 specializations |
| **Talent Grants** | **ALL talents auto-granted** (no individual choices) |
| **Total Talents** | 11 per specialization (1 Keystone + 9 mid-tier + 1 Capstone) |
| **Levels Affected** | 13, 15, 17, 19, 20 |
| **Empty Levels** | 14, 16, 18 (no talents granted) |

---

## The Three Specializations

### 1. Mountain Thane (Protection + Fury)
**Excel Columns**: 56-58  
**Theme**: Lightning-infused warrior channeling storm power  
**Available To**: Protection and Fury Warriors

**Core Mechanic**: Thunder/Lightning damage enhancement and Avatar synergy

### 2. Colossus (Arms + Protection)
**Excel Columns**: 59-61  
**Theme**: Unstoppable juggernaut with earth-shattering might  
**Available To**: Arms and Protection Warriors

**Core Mechanic**: Demolish ability + Colossal Might stacks

### 3. Slayer (Arms + Fury)
**Excel Columns**: 62-64  
**Theme**: Relentless executioner specializing in finishing wounded foes  
**Available To**: Arms and Fury Warriors

**Core Mechanic**: Enhanced Execute mechanics and low-HP burst damage

---

## Specialization Matrix

| Specialization | Arms | Fury | Protection |
|---------------|------|------|-----------|
| **Mountain Thane** | ❌ | ✅ | ✅ |
| **Colossus** | ✅ | ❌ | ✅ |
| **Slayer** | ✅ | ✅ | ❌ |

**Protection gets 2 options** (Mountain Thane, Colossus)  
**Arms gets 2 options** (Colossus, Slayer)  
**Fury gets 2 options** (Mountain Thane, Slayer)

---

## How Talents Are Granted (CRITICAL)

### ⚠️ NO INDIVIDUAL CHOICES - ALL AUTO-GRANTED!

Unlike Class Talents (Rows 1-10 where you pick 1 per row), **Hero Talents are ALL granted automatically** based on your L13 specialization choice.

### Grant Schedule

| Level | What's Granted | Player Choices |
|-------|----------------|----------------|
| **L13** | **Keystone** (1 talent) | **Pick specialization** |
| L14 | Nothing | 0 choices |
| **L15** | **3 talents** (all granted) | 0 choices |
| L16 | Nothing (Feat/ASI only) | 1 choice (Feat) |
| **L17** | **3 talents** (all granted) | 0 choices |
| L18 | Nothing | 0 choices |
| **L19** | **3 talents** (all granted) | 0 choices |
| **L20** | **Capstone** (1 talent) + Feat/ASI | 1 choice (Feat) |

**Total Hero Talent Choices**: **1** (picking the specialization at L13)  
**Total Talents Received**: **11** (Keystone + 9 mid-tier + Capstone)

---

## Example Progression: Mountain Thane

### Level 13: Keystone
- **Lightning Strikes** (auto-granted)

### Level 15: First Tier (3 talents auto-granted)
- **Crashing Thunder**
- **Ground Current**
- **Strength of the Mountain**

### Level 17: Second Tier (3 talents auto-granted)
- **Thunder Blast**
- **Storm Bolts**
- **Keep your feet on the Ground**

### Level 19: Third Tier (3 talents auto-granted)
- **Flashing Skies**
- **Thorim's Might**
- **Burst of Power**

### Level 20: Capstone
- **Avatar of the Storm** (auto-granted)

**Total Talents**: 11 (1 + 3 + 3 + 3 + 1)

---

## Talent Naming Convention

### Excel Structure (Columns 56-64)
Each specialization has **3 columns**:

| Column | Content |
|--------|---------|
| **Column 1** | Talent option A (always granted) |
| **Column 2** | Talent option B (always granted) |
| **Column 3** | Talent option C (always granted) |

**Example - Mountain Thane (Cols 56-58)**:
- **Col 56**: Crashing Thunder, Thunder Blast, Flashing Skies
- **Col 57**: Ground Current, Storm Bolts, Thorim's Might
- **Col 58**: Strength of the Mountain, Keep your feet on the Ground, Burst of Power

**All 3 talents per tier are granted** (no picking between columns)

---

## Hero Talent Count Summary

| Specialization | Keystone (L13) | L15 Talents | L17 Talents | L19 Talents | Capstone (L20) | Total |
|---------------|---------------|-------------|-------------|-------------|---------------|-------|
| **Mountain Thane** | 1 | 3 | 3 | 3 | 1 | **11** |
| **Colossus** | 1 | 3 | 3 | 3 | 1 | **11** |
| **Slayer** | 1 | 3 | 3 | 3 | 1 | **11** |

**Grand Total**: **33 unique hero talents** across all 3 specializations

---

## Comparison to Subclass Talents (L3-L12)

| System | Levels | Choice Type | Talents per Row | Player Choices |
|--------|--------|-------------|-----------------|----------------|
| **Class Talents** | L1-L12 | Pick 1 per row | 3 options | 9 choices |
| **SubclassSpec Talents** | L3-L12 | Pick 1 per row | 3 options | 9 choices |
| **Hero Talents** | L13-L20 | Pick specialization, all granted | 3 per tier (all granted) | **1 choice** |

**Key Difference**: Subclass talents = **player choice per row**. Hero talents = **ONE choice (specialization), then all talents auto-granted**.

---

## Design Philosophy

### Why Auto-Grant All Talents?

1. **Simplicity**: One major decision at L13, then focus on gameplay
2. **Power Scaling**: Guaranteed progression without choice paralysis
3. **Build Identity**: Each specialization has a complete, coherent kit
4. **WoW Authenticity**: Matches WoW's hero talent system (choose tree, get all talents)

### Empty Levels (14, 16, 18)
- **L16**: Feat/ASI still granted (player choice for character customization)
- **L14/L18**: True empty levels (prevents talent overload, spacing for balance)

---

## Implementation Notes

### Progressions.lsx Structure
Each specialization needs a **separate progression** that grants talents at specific levels:

```xml
<!-- Mountain Thane Example -->
<node id="Progression">
    <attribute id="UUID" value="[MOUNTAIN_THANE_UUID]"/>
    <attribute id="Level" value="13"/>
    <attribute id="PassivesAdded" value="WAR_MountainThane_LightningStrikes"/>
</node>
<node id="Progression">
    <attribute id="UUID" value="[MOUNTAIN_THANE_UUID]"/>
    <attribute id="Level" value="15"/>
    <attribute id="PassivesAdded" value="WAR_MountainThane_CrashingThunder;WAR_MountainThane_GroundCurrent;WAR_MountainThane_StrengthOfMountain"/>
</node>
<!-- etc. for L17, L19, L20 -->
```

### Passive Files
All hero talents are **passives** (not active abilities), stored in:
- `Data/Public/.../Stats/Generated/Data/Passive.txt`

**Naming Convention**: `WAR_[SpecName]_[TalentName]`
- `WAR_MountainThane_LightningStrikes`
- `WAR_Colossus_Demolish`
- `WAR_Slayer_SlayersDominance`

---

## Validation Checklist

When documenting/implementing hero talents:

- [ ] ✅ All 3 specializations have exactly 11 talents each
- [ ] ✅ Keystone grants at L13
- [ ] ✅ 3 talents grant at L15, L17, L19 (all auto-granted, no choices)
- [ ] ✅ Capstone grants at L20
- [ ] ✅ L14, L18 are empty levels (no talents)
- [ ] ✅ L16 grants Feat/ASI only
- [ ] ✅ Each specialization available to exactly 2 subclasses
- [ ] ✅ Protection gets 2 options (Mountain Thane, Colossus)
- [ ] ✅ Arms gets 2 options (Colossus, Slayer)
- [ ] ✅ Fury gets 2 options (Mountain Thane, Slayer)

---

## Cross-References

### Source Documents
- **Excel File**: `Documentation/00_SourcesOfTruth/Warrior Progression for all subclasses.xlsx`
- **Analysis**: `Documentation/00_SourcesOfTruth/EXCEL_WARRIOR_PROGRESSION_ANALYSIS.md` (lines 280-400)

### Section [5] Details (To Be Created)
- **[5.1] Mountain Thane**: Lightning Strikes, Crashing Thunder, Thunder Blast, Flashing Skies, Avatar of the Storm (+ 6 more)
- **[5.2] Colossus**: Demolish, Martial Expert, Arterial Blows, Practiced Strikes, Dominance of the Colossus (+ 6 more)
- **[5.3] Slayer**: Slayer's Dominance, Imminent Demise, Death Drive, Show No Mercy, Unrelenting Onslaught (+ 6 more)

---

## Next Steps for Section [5] Documentation

For each specialization, document:

1. **Identity** (theme, playstyle, core mechanic)
2. **Availability** (which subclasses can pick it)
3. **Keystone** (L13 - name, effect, mechanical impact)
4. **Tier 1** (L15 - 3 talents, all granted)
5. **Tier 2** (L17 - 3 talents, all granted)
6. **Tier 3** (L19 - 3 talents, all granted)
7. **Capstone** (L20 - ultimate power)
8. **Synergies** (how talents work together, which builds benefit most)
9. **Cross-References** (Excel rows, passive names, Progressions.lsx entries)
10. **Validation Checklist** (11 talents total, correct levels, proper naming)

---

**Last Updated**: October 20, 2025  
**Validated**: ✅ Excel columns 56-64, EXCEL_WARRIOR_PROGRESSION_ANALYSIS.md
