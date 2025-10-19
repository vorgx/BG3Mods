# Warrior Specialization Tier Structures
**Date**: October 17, 2025  
**Version**: v2.0 Design Specification  
**Status**: Cross-Spec Reference Document

---

## Overview

At **Level 13**, all Warriors unlock the **Specialization system** and must choose 1 of 2 hero talent trees based on their base spec (Arms, Fury, or Protection). Each specialization has a unique tier structure that determines how many choice nodes (talent picks) players get during L13-L20.

---

## Specialization Availability Matrix

| Base Spec | Specialization Option 1 | Specialization Option 2 |
|-----------|------------------------|------------------------|
| **Arms** | **Colossus** (3 tiers) | **Slayer** (3 tiers) |
| **Fury** | **Mountain Thane** (4 tiers) | **Slayer** (3 tiers) |
| **Protection** | **Mountain Thane** (4 tiers) | **Colossus** (3 tiers) |

---

## Tier Structure Breakdown

### 3-Tier Specializations (Colossus, Slayer)

**Progression**:
- **L13**: Keystone Talent (auto-granted)
- **L14**: Passive 1 (auto-granted)
- **L15**: 🔹 **Choice Node 1** - Pick 1 of 3 options
- **L16**: Passive 2 (auto-granted)
- **L17**: 🔹 **Choice Node 2** - Pick 1 of 3 options
- **L18**: Passive 3 (auto-granted)
- **L19**: 🔹 **Choice Node 3** - Pick 1 of 3 options
- **L20**: Passive 4 + **Capstone** (auto-granted)

**Total Talents**:
- Auto-granted: 7 (1 Keystone + 1 Capstone + 4 Passives + 1 at L20)
- Player choices: 3 (from 9 possible options across 3 tiers)
- **Total acquired**: 9 talents (6 fixed + 3 chosen)

**Specializations using this structure**:
- **Colossus** (Tank/Defense hero talents) - Available to Arms & Protection
- **Slayer** (DPS/Execution hero talents) - Available to Arms & Fury

---

### 4-Tier Specializations (Mountain Thane)

**Progression**:
- **L13**: Keystone Talent (auto-granted)
- **L14**: Passive 1 (auto-granted)
- **L15**: 🔹 **Choice Node 1** - Pick 1 of 3 options
- **L16**: 🔹 **Choice Node 2** - Pick 1 of 3 options
- **L17**: Passive 2 (auto-granted)
- **L18**: 🔹 **Choice Node 3** - Pick 1 of 3 options
- **L19**: 🔹 **Choice Node 4** - Pick 1 of 3 options
- **L20**: Passive 3 + **Capstone** (auto-granted)

**Total Talents**:
- Auto-granted: 6 (1 Keystone + 1 Capstone + 3 Passives + 1 at L20)
- Player choices: 4 (from 12 possible options across 4 tiers)
- **Total acquired**: 9 talents (5 fixed + 4 chosen)

**Specializations using this structure**:
- **Mountain Thane** (Storm/Lightning hero talents) - Available to Fury & Protection

---

## Design Rationale

### Why Different Tier Counts?

**3-Tier Specializations** (Colossus, Slayer):
- **Philosophy**: Broader, more impactful choices with spacing between decisions
- **Balance**: Simpler build paths, easier to understand and balance
- **Pacing**: Talent picks at L15, L17, L19 give players time to evaluate impact
- **Complexity**: Lower complexity, focuses on 1-2 major synergies

**4-Tier Specializations** (Mountain Thane):
- **Philosophy**: More granular choices with tighter level spacing
- **Balance**: More complex build paths, offers deeper customization
- **Pacing**: Talent picks at L15, L16, L18, L19 provide frequent progression rewards
- **Complexity**: Higher complexity, enables 3+ synergy chains

**Both systems result in 9 total talents**, but distribute choices differently:
- 3-Tier: Fewer decisions, more auto-granted passives (4 vs 3)
- 4-Tier: More decisions, fewer auto-granted passives

---

## Specialization Theme Summary

### **Colossus** (3 Tiers) - Tank/Defense
- **Available to**: Arms, Protection
- **Theme**: Slow, unstoppable juggernaut with massive damage mitigation
- **Key Talent**: Demolish (channeled 3-hit combo with 99% slow)
- **Capstone**: Dominance of the Colossus (Colossal Might stacking system)
- **Build Archetypes**: Tanky DPS (Arms), Pure Tank (Protection)

**Choice Node Themes**:
- **L15**: Offensive vs Defensive vs Hybrid options
- **L17**: DoT vs Sustained DPS vs Survivability options
- **L19**: AoE vs Single-Target vs Utility options

---

### **Slayer** (3 Tiers) - DPS/Execution
- **Available to**: Arms, Fury
- **Theme**: Relentless executioner, thrives in low-HP execute phase
- **Key Talent**: Slayer's Dominance (15% proc to apply Marked for Execution)
- **Capstone**: Slayer's Malice (Overpower +30% damage for Arms, Bloodthirst for Fury)
- **Build Archetypes**: Burst Execute (Arms), Multi-Target Cleave (Fury)

**Choice Node Themes**:
- **L15**: Execute Enhancement vs Multi-Target vs Rage Efficiency options
- **L17**: Crit vs AoE vs Mobility options
- **L19**: AoE Debuff vs Attack Speed vs Execute Range options

---

### **Mountain Thane** (4 Tiers) - Storm/Lightning
- **Available to**: Fury, Protection
- **Theme**: Storm-infused warrior channeling lightning and thunder
- **Key Talent**: Avatar of the Storm (Avatar gains lightning aura)
- **Capstone**: Gathering Storms (stacking damage during Avatar)
- **Build Archetypes**: Lightning Burst (Fury), Thunder Tank (Protection)

**Choice Node Themes**:
- **L15**: Lightning Proc vs Cooldown Reduction vs Sustain options
- **L16**: AoE Enhancement vs Single-Target vs Defense options
- **L17**: Thunder Clap Enhancement vs Movement vs Rage options
- **L19**: Avatar Enhancement vs Utility vs Defensive options

**Note**: Mountain Thane has 4 choice nodes due to its more complex storm-stacking mechanics requiring finer tuning.

---

## Implementation Considerations

### BG3 Progressions.lsx Structure

**3-Tier Specialization Example** (Colossus at L15):
```xml
<node id="Progression">
    <attribute id="Level" type="uint8" value="15"/>
    <attribute id="Name" type="LSString" value="Warrior"/>
    <attribute id="ProgressionType" type="uint8" value="1"/>
    <attribute id="TableUUID" type="guid" value="78fe4967-4e62-5491-d981-dd781acca4d7"/>
    <children>
        <node id="SubClasses">
            <children>
                <node id="SubClass">
                    <attribute id="Object" type="guid" value="[ArmsSubclassUUID]"/>
                    <children>
                        <node id="AddSpells"/> <!-- Empty, only passives at this level -->
                        <node id="SelectPassives">
                            <attribute id="Amount" type="int32" value="1"/>
                            <children>
                                <node id="Passive">
                                    <attribute id="PassiveId" type="guid" value="[WAR_Colossus_Boneshaker_UUID]"/>
                                </node>
                                <node id="Passive">
                                    <attribute id="PassiveId" type="guid" value="[WAR_Colossus_ColossalMight_UUID]"/>
                                </node>
                                <node id="Passive">
                                    <attribute id="PassiveId" type="guid" value="[WAR_Colossus_OneHandedSpec_UUID]"/>
                                </node>
                            </children>
                        </node>
                    </children>
                </node>
            </children>
        </node>
    </children>
</node>
```

**4-Tier Specialization Example** (Mountain Thane at L15 and L16):
```xml
<!-- L15 -->
<node id="Progression">
    <attribute id="Level" type="uint8" value="15"/>
    <children>
        <node id="SelectPassives">
            <attribute id="Amount" type="int32" value="1"/>
            <children>
                <node id="Passive">
                    <attribute id="PassiveId" type="guid" value="[WAR_MountainThane_LightningStrikes_UUID]"/>
                </node>
                <node id="Passive">
                    <attribute id="PassiveId" type="guid" value="[WAR_MountainThane_ThunderBlast_UUID]"/>
                </node>
                <node id="Passive">
                    <attribute id="PassiveId" type="guid" value="[WAR_MountainThane_CrashingWave_UUID]"/>
                </node>
            </children>
        </node>
    </children>
</node>

<!-- L16 -->
<node id="Progression">
    <attribute id="Level" type="uint8" value="16"/>
    <children>
        <node id="SelectPassives">
            <attribute id="Amount" type="int32" value="1"/>
            <children>
                <node id="Passive">
                    <attribute id="PassiveId" type="guid" value="[WAR_MountainThane_StormForge_UUID]"/>
                </node>
                <node id="Passive">
                    <attribute id="PassiveId" type="guid" value="[WAR_MountainThane_ThunderousBlows_UUID]"/>
                </node>
                <node id="Passive">
                    <attribute id="PassiveId" type="guid" value="[WAR_MountainThane_GroundCurrent_UUID]"/>
                </node>
            </children>
        </node>
    </children>
</node>
```

### Testing Priorities

**3-Tier Specializations**:
1. Validate choice nodes at L15, L17, L19 work correctly
2. Test auto-granted passives at L14, L16, L18, L20
3. Verify 3 talents selected from 9 possible (no duplicates)

**4-Tier Specializations**:
1. Validate choice nodes at L15, L16, L18, L19 work correctly
2. Test auto-granted passives at L14, L17, L20
3. Verify 4 talents selected from 12 possible (no duplicates)
4. Ensure UI handles consecutive choice levels (L15→L16) gracefully

---

## Balance Considerations

### Power Budget per Tier

**3-Tier Specializations**:
- Each choice node = ~15% power increase (assuming balanced options)
- Total specialization power = Keystone (25%) + Capstone (25%) + 3 Choices (45%) + 4 Passives (30%) = **125% power increase** over L13-L20

**4-Tier Specializations**:
- Each choice node = ~12% power increase (slightly lower per choice, but more choices)
- Total specialization power = Keystone (25%) + Capstone (25%) + 4 Choices (48%) + 3 Passives (27%) = **125% power increase** over L13-L20

**Both systems target ~125% power increase**, just distributed differently.

### Synergy Complexity

**3-Tier Specializations**:
- Synergies: 1-2 major chains (e.g., Colossus: Demolish → Boneshaker → Arterial Bleed)
- Easier to balance, fewer edge cases
- Recommended for players new to talent systems

**4-Tier Specializations**:
- Synergies: 2-3 major chains (e.g., Mountain Thane: Avatar → Lightning Strikes → Thunder Blast → Gathering Storms)
- More complex balancing, more edge cases
- Recommended for experienced players seeking depth

---

## Player Guidance

### Choosing a Specialization

**Arms Warriors (Colossus vs Slayer)**:
- **Choose Colossus if**: You want to tank, prefer survivability, like slow methodical combat
- **Choose Slayer if**: You want pure DPS, prefer burst damage, like execute phase gameplay

**Fury Warriors (Mountain Thane vs Slayer)**:
- **Choose Mountain Thane if**: You want AoE burst, prefer cooldown-based play, like Avatar gameplay
- **Choose Slayer if**: You want sustained DPS, prefer execute phase, like Bloodthirst spam

**Protection Warriors (Mountain Thane vs Colossus)**:
- **Choose Mountain Thane if**: You want offensive tank, prefer lightning burst, like active cooldown management
- **Choose Colossus if**: You want defensive tank, prefer passive mitigation, like Demolish combo

---

## Future Expansion Notes

If future patches add more specializations, consider:
- **3-Tier Structure**: For straightforward, impactful themes (e.g., bleed-focused spec)
- **4-Tier Structure**: For complex, synergy-heavy themes (e.g., stance-dancing spec)
- **5-Tier Structure**: If extremely complex mechanics require very fine tuning (not recommended due to UI clutter)

---

**Document Cross-References**:
- Full talent breakdowns: `ARMS_WARRIOR_5_POOL_TALENT_SYSTEM.md`, `FURY_WARRIOR_5_POOL_TALENT_SYSTEM.md`, `PROTECTION_WARRIOR_5_POOL_TALENT_SYSTEM.md`
- Specialization implementations: `PASSIVES_COLOSSUS.md`, `PASSIVES_SLAYER.md`, `PASSIVES_MOUNTAIN_THANE.md`
- Progression system: `WOW_TALENT_TREE_IMPLEMENTATION_PLAN_v2.md`

---

**END OF SPECIALIZATION TIER STRUCTURES DOCUMENT**
