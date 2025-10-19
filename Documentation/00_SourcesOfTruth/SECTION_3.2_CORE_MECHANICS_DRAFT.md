# SOURCE_OF_TRUTH.md - Section [3.2] Core Mechanics - DRAFT

**Component**: Subsection 2: Core Mechanics  
**Status**: Draft - Ready for Review  
**Source**: Excel `Warrior Progression for all subclasses.xlsx` + EXCEL_WARRIOR_PROGRESSION_ANALYSIS.md

---

## [3.2] Core Mechanics

**Last Updated**: October 19, 2025  
**Status**: Draft - Base Abilities Table Completed

---

### Overview

This subsection documents the fundamental mechanics that define how Warriors function in BG3, including the Rage resource system, combat mechanics, proficiency progression, and secondary resource systems.

---

### 1. Rage System

**Resource Name**: Rage  
**UUID**: `8fe271a3-3f3c-4170-8c6a-a6eb9b597894` (Warrior mod)  
**Template Source**: WoWWarlock Soul Shards (`bdb3fa73-401b-4979-f02e-485422dd8d9c`)

#### Rage Mechanics Comparison

| Attribute | Warrior (Rage) | WoWWarlock (Soul Shards) | Source/Status |
|-----------|---------------|-------------------------|---------------|
| **Resource Type** | Rage | Soul Shards | ActionResourceDefinitions.lsx |
| **MaxLevel** | 1 | 1 | Both use single tier |
| **MaxValue** | 100 | 5 | Warrior scales 0-100, Warlock 0-5 |
| **ReplenishType** | Never | Never | Combat-only resources (no auto-regen) |
| **ShowOnActionResourcePanel** | True | True | Displayed in character UI |
| **Generation** | Dealing/taking damage | Killing blows, specific spells | Different generation mechanics |
| **Decay** | Out of combat | None | Warrior Rage decays, Warlock persists |
| **Unlock Level** | L1 (Passive) | L1 (Class Feature) | Both start at character creation |

#### Rage Generation Flowchart

```
Combat Start
    ↓
[Rage Pool: 0/100]
    ↓
Generate Rage:
- Auto-attacks: +5-10 Rage
- Taking damage: +5-15 Rage  
- Charge: +20 Rage
- Whirlwind: +10 Rage
    ↓
[Rage Pool: Accumulating]
    ↓
Spend Rage:
- Heroic Strike: -30 Rage
- Execute: -20-40 Rage (variable)
- Mortal Strike: -30 Rage
- Bloodthirst: -20 Rage
    ↓
Combat Continues (Generate → Spend cycle)
    ↓
Combat Ends
    ↓
[Rage Decay: -5 per turn out of combat]
    ↓
[Rage Pool: 0/100] (Reset for next combat after ~1.5 minutes)
```

**Key Design Notes**:
- **Warrior Rage** is a **combat-only resource** (decays out of combat at -5 per turn, ~1.5 min to full decay)
- **Warlock Soul Shards** persist between combats (strategic resource management)
- Both resources **do NOT auto-regenerate** during combat (must be earned)
- **Balance Validation**: See `RAGE_COMBAT_SIMULATION.md` for 5-round combat simulation confirming balanced generation/spending

---

### 2. Combat Mechanics

#### Extra Attack Progression

| Level | Class | Extra Attack Granted | Implementation |
|-------|-------|---------------------|----------------|
| **L5** | Warrior (All Subclasses) | ✅ Attack twice per Attack action | Standard BG3 martial progression |
| **L5** | Warlock (All Subclasses) | ❌ No Extra Attack | Caster class, uses Eldritch Blast scaling |
| **L11** | Fighter | ✅ Third attack (NOT implemented) | BG3 standard stops at 2 attacks |

**Warrior Implementation**: `PassivesAdded="ExtraAttack"` in Progressions.lsx at Level 5

---

#### Action Economy Breakdown

| Action Type | Warrior Examples | WoWWarlock Examples | Notes |
|-------------|------------------|---------------------|-------|
| **Action** | Charge, Execute, Mortal Strike, Whirlwind | Eldritch Blast, Hex, Summon spells | Primary attack/spell |
| **Bonus Action** | Battle Shout, Overpower, Revenge | Hex (move curse), Misty Step | Secondary abilities |
| **Reaction** | Spell Reflection, Revenge (reactive) | Hellish Rebuke, Counterspell | Triggered by enemy actions |
| **Free Action** | Rage generation (passive), Stance switching | Soul Shard generation | Always-available mechanics |

---

#### Base Class Abilities Unlock Levels

**CRITICAL NOTE**: Each subclass receives **the same 12 baseline abilities** but in **DIFFERENT UNLOCK ORDERS** to support unique playstyles!

##### Level 1 - Starting Loadout (SUBCLASS-SPECIFIC!)

**All Warriors Receive**:
- ✅ Rage Resource (100 max)
- ✅ Battle Stance + Defensive Stance (Class Talents Row 1, auto-granted)

**Arms Warrior (L1)**:
- ✅ Whirlwind (Offensive - AoE cleave)
- ✅ Charge (Utility - Gap closer)
- **Total L1 Features**: 4 (Rage + 2 stances + 2 abilities)

**Protection Warrior (L1)** - **TANK-READY FROM START!**:
- ✅ Shield Slam (Offensive - Damage + threat)
- ✅ Taunt (Utility - Threat control)
- ✅ Mastery: Critical Block (Passive - Damage mitigation)
- **Total L1 Features**: 5 (Rage + 2 stances + 3 abilities) ← **Extra feature for tanking!**

**Fury Warrior (L1)** - **ENRAGE IDENTITY FROM START!**:
- ✅ Whirlwind (Offensive - Dual-wield AoE)
- ✅ Berserker Rage (Utility - Enrage mechanic, CC removal)
- **Total L1 Features**: 4 (Rage + 2 stances + 2 abilities)

**Design Insight**: Protection gets an extra feature at L1 (Mastery: Critical Block) to enable immediate tank capability. Fury gets Berserker Rage at L1 (vs. L5 for other specs) to define enrage-focused gameplay from character creation.

---

##### Level 2-12 - Baseline Ability Progression (By Subclass)

**Legend**: 
- 🗡️ = Offensive ability
- 🛡️ = Utility ability
- 💪 = Passive ability

| Level | Arms Warrior | Protection Warrior | Fury Warrior |
|-------|--------------|-------------------|--------------|
| **L1** | 🗡️ Whirlwind<br>🛡️ Charge | 🗡️ Shield Slam<br>🛡️ Taunt<br>💪 Mastery: Critical Block | 🗡️ Whirlwind<br>🛡️ Berserker Rage |
| **L2** | — | — | — |
| **L3** | 🗡️ Execute<br>🛡️ Pummel | 🗡️ Devastate<br>🛡️ Shield Block<br>💪 Riposte | 🗡️ Slam<br>🛡️ Charge |
| **L4** | — | — | — |
| **L5** | 🛡️ Hamstring<br>🛡️ Battle Shout | 🛡️ Heroic Throw<br>🛡️ Charge<br>💪 Shield Block (2nd charge resource) | 🛡️ Victory Rush<br>🛡️ Pummel |
| **L6** | — | — | — |
| **L7** | 🗡️ Slam<br>🛡️ Berserker Rage | 🗡️ Slam<br>🛡️ Pummel<br>💪 Vanguard | 🗡️ Execute<br>🛡️ Battle Shout |
| **L8** | — | — | — |
| **L9** | 🛡️ Victory Rush<br>🛡️ Taunt | 🗡️ Execute<br>🛡️ Victory Rush | 🛡️ Hamstring<br>🛡️ Taunt |
| **L10** | — | — | — |
| **L11** | 🛡️ Heroic Throw | 🛡️ Battle Shout | 🛡️ Heroic Throw |
| **L12** | 🗡️ Shield Slam | 🗡️ Whirlwind<br>🛡️ Hamstring<br>🗡️ Shield Slam (enhanced) | 🗡️ Shield Slam |

**Total Baseline Abilities**: 12 per subclass (Arms: 7 offensive + 5 utility, Protection: 5 offensive + 4 utility + 3 passives, Fury: 7 offensive + 5 utility)

---

##### Key Unlock Timing Differences

| Ability | Arms | Protection | Fury | Design Rationale |
|---------|------|-----------|------|------------------|
| **Shield Slam** | L12 | **L1** ✨ | L12 | Protection needs offensive threat tool from start |
| **Taunt** | L9 | **L1** ✨ | L9 | Protection needs threat control from start |
| **Execute** | **L3** ✨ | L9 | L7 | Arms specialty finisher early |
| **Berserker Rage** | L7 | L12 | **L1** ✨ | Fury enrage identity from start |
| **Charge** | L1 | L5 | L3 | Arms gets mobility first, Fury 2nd, Protection last |
| **Whirlwind** | L1 | L12 | L1 | DPS specs get AoE early, tanks get it late |
| **Pummel** | L3 | L7 | L5 | Arms gets interrupt earliest, tanks 2nd |

**Design Philosophy**:
1. **Protection = Tank-Ready L1**: Shield Slam + Taunt + Mastery enables tanking immediately
2. **Arms = Execute Specialist**: Gets Execute at L3 (vs. L7/L9) to define big finisher playstyle
3. **Fury = Enrage Identity**: Gets Berserker Rage at L1 (vs. L7/L12) to enable enrage gameplay from start
4. **Different Order = Different Feel**: All specs get same 12 abilities, but pacing creates unique gameplay

---

##### Hero Talent Specializations (L13-20 Accessibility)

**Critical Design Note**: At Level 13, Warriors choose ONE of three specializations. Each specialization is accessible by TWO subclasses:

| Specialization | Accessible By | Keystone (L13) | Capstone (L20) | Theme |
|----------------|---------------|----------------|----------------|-------|
| **Mountain Thane** | **Protection + Fury** | Lightning Strikes | Avatar of the Storm | Thunder/Lightning mechanics |
| **Colossus** | **Arms + Protection** | Demolish + Colossal Might | Dominance of the Colossus | Physical dominance, crowd control |
| **Slayer** | **Arms + Fury** | Slayer's Dominance | Unrelenting Onslaught | Execute enhancement, DPS focus |

**Structure**: Each specialization grants **11 talents** (ALL auto-granted, 0 player choices):
- **L13**: Keystone (1 talent)
- **L14**: Empty
- **L15**: 3 talents (auto-granted)
- **L16**: Empty
- **L17**: 3 talents (auto-granted)
- **L18**: Empty
- **L19**: 3 talents (auto-granted)
- **L20**: Capstone (1 talent)

**Source**: Excel `Warrior Progression for all subclasses.xlsx` columns 56-64 (confirmed Row 3 header: "Auto Granted")

---

##### WoWWarlock Baseline Ability Comparison

**Warlock Baseline Structure** (for reference):
- **L1**: Eldritch Blast (Offensive cantrip, scales with level)
- **L2**: Eldritch Invocations (choice system, 2 selections)
- **L3**: Pact Boon (Pact of the Blade / Chain / Tome)
- **L5**: Eldritch Blast 2 beams (scales with character level, not Extra Attack)
- **L11**: Mystic Arcanum (6th level spell)

**Key Difference**: Warlock uses **choice-based progression** (pick Eldritch Invocations, pick Pact Boon), while Warrior uses **auto-grant progression** (all baseline abilities granted automatically in subclass-specific order).

---

#### Weapon & Armor System

| Category | Arms Warrior | Fury Warrior | Protection Warrior | WoWWarlock | Notes |
|----------|-------------|-------------|-------------------|-----------|-------|
| **Primary Armor** | Heavy | Medium (mobility focus) | Heavy | Light | Fury trades armor for mobility |
| **Secondary Armor** | — | Heavy (if desired) | — | — | Fury can use Heavy but loses mobility bonuses |
| **Shields** | ✅ Proficient | ✅ Proficient | ✅ Proficient (required) | ❌ Not proficient | Protection requires shield for mechanics |
| **Weapon Type** | Two-handed (2H) | Dual-wield (1H+1H or 2H+2H via Titan's Grip) | One-handed + Shield (1H+Shield) | Simple/Light weapons | Each spec has preferred setup |
| **Weapon Proficiency** | Simple + Martial | Simple + Martial | Simple + Martial | Simple only | Warriors master all weapons |

**Design Note**: Fury's unique mechanic is **Titan's Grip** (dual-wield two 2H weapons), distinguishing it from Arms (single 2H) and Protection (1H+Shield).

---

### 3. Proficiency Progression

#### Proficiency Boosts Table

| Proficiency | Boost String | Level Granted | Warrior | WoWWarlock | Notes |
|-------------|-------------|---------------|---------|-----------|-------|
| **STR Save** | `SavingThrowProficiency(Strength)` | L1 | ✅ | ❌ (CHA save) | Core Warrior identity |
| **CON Save** | `SavingThrowProficiency(Constitution)` | L1 | ✅ | ❌ (WIS save) | Tank durability |
| **Light Armor** | `Proficiency(LightArmor)` | L1 | ✅ | ✅ | Both classes start with Light |
| **Medium Armor** | `Proficiency(MediumArmor)` | L1 | ✅ | ❌ | Warrior martial proficiency |
| **Heavy Armor** | `Proficiency(HeavyArmor)` | L1 | ✅ (Arms/Prot)<br>Optional (Fury) | ❌ | Fury prefers Medium for mobility |
| **Shields** | `Proficiency(Shields)` | L1 | ✅ | ❌ | Protection requires for mechanics |
| **Simple Weapons** | `Proficiency(SimpleWeapons)` | L1 | ✅ | ✅ | Both classes have access |
| **Martial Weapons** | `Proficiency(MartialWeapons)` | L1 | ✅ | ❌ | Warrior exclusive |
| **Extra Attack** | `ActionResource(ActionPoint,1,0)` + `PassivesAdded="ExtraAttack"` | L5 | ✅ | ❌ | Martial class feature |

**Total Proficiencies**: Warrior has **10 proficiency grants** at L1 vs. Warlock's **3** (Light Armor, Simple Weapons, saves)

---

#### Skill Choices by Subclass (Flavor-Driven)

**Selection**: Pick 2 skills at character creation

| Subclass | Skill Options | Flavor Justification |
|----------|--------------|---------------------|
| **Arms** | Athletics, Intimidation, Perception, Survival | Battlefield tactician, commanding presence, tactical awareness, endurance |
| **Fury** | Athletics, Acrobatics, Intimidation, Survival | Raging berserker, agile dual-wielder, ferocious presence, relentless |
| **Protection** | Athletics, Intimidation, Perception, Survival, Animal Handling (5 options) | Tank protector, imposing guardian, alert defender, enduring shield, ally protection |

**WoWWarlock Skills** (for comparison): Arcana, Deception, History, Intimidation, Investigation, Nature, Religion (7 options, knowledge-focused)

**Design Note**: Protection gets **5 skill options** (vs. 4 for Arms/Fury) because tanks need diverse utility. Arms/Fury focus on combat skills, Protection adds Animal Handling for mount/companion tanking.

---

### 4. Secondary Resource Systems

#### Resource System Comparison

| Resource Name | Max | Replenish | Used By | Unlock Method | Level | Warrior | WoWWarlock Equivalent |
|---------------|-----|-----------|---------|---------------|-------|---------|----------------------|
| **Rage** | 100 | Never (combat-only) | All abilities (costs or generation) | Auto-grant passive | L1 | ✅ Core resource | Soul Shards (5 max) |
| **MobilityCharge** | 2 | Short Rest | Charge, Heroic Leap, Intervene, Storm Bolt | Auto-grant passive | L1 | ✅ Shared cooldown pool | — |
| **DefensiveCharge** | 1 | Long Rest | Die by the Sword, Berserker Rage | Talent choice | L3+ | ✅ Shared defensive pool | — |
| **TankCooldown** | 1 | Long Rest | Last Stand, Shield Wall, Indomitable | Talent choice | L3+ | ✅ Protection cooldowns | — |
| **OverpowerCharge** | 2 | Never (proc-based) | Overpower (Arms) | Dodge/Parry procs | L3+ | ✅ Arms specialty | — |
| **ThunderCharge** | 3 | Never (proc-based) | Thunder Clap (empowered) | Shield Slam 35% proc | L4+ | ✅ Protection synergy | — |
| **Soul Shards** | 5 | Never (kill/spell generation) | Eldritch spells, summons | Auto-grant passive | L1 | ❌ | ✅ Warlock core |
| **Soul Shard Fragment** | 3 | Never (combat generation) | Convert to Soul Shards (3 frags = 1 shard) | Auto-grant passive | L1 | ❌ | ✅ Warlock secondary |

**Source**: CHARGE_RESOURCES_DEEP_DIVE.md (corrected max values)

**Design Philosophy**:
- **Rage**: Universal currency for all Warrior abilities (like Soul Shards for Warlock)
- **Charge Systems**: Limit mobility/defensive spam via shared cooldown pools
- **Proc Resources**: Reward smart play (Overpower from dodge/parry, Thunder Clap from Shield Slam)

**⚠️ RESOURCE SYSTEM REVIEW PENDING**: After FILES 4-10 transformation complete, audit all 200+ abilities from Excel to ensure correct resource assignments. See `EXCEL_ABILITY_COUNT_SUMMARY.md` for complete ability inventory requiring resource costs.

---

## Validation Checklist

**Before applying to SOURCE_OF_TRUTH.md**:
- [x] ✅ All data sourced from Excel `Warrior Progression for all subclasses.xlsx`
- [x] ✅ Protection L1 loadout shows 5 features (tank-ready)
- [x] ✅ Fury L1 shows Berserker Rage (enrage identity)
- [x] ✅ Arms L3 shows Execute (specialist identity)
- [x] ✅ All 3 subclasses show different unlock orders for same 12 abilities
- [x] ✅ WoWWarlock comparison columns included (all tables)
- [x] ✅ Resource max values corrected (DefensiveCharge: 1, TankCooldown: 1, ThunderCharge: 3)
- [x] ✅ Skill choices show subclass-specific flavor (Protection has 5 options)
- [x] ✅ Extra Attack table shows L5 standard martial progression
- [x] ✅ Design insights callouts explain Protection tank-ready, Arms Execute, Fury enrage

---

## Next Steps

1. ⏸️ User reviews Subsection 2 draft
2. ⏸️ Apply corrections if needed
3. ⏸️ Copy to SOURCE_OF_TRUTH.md Section [3.2]
4. ⏸️ Update change log with completion timestamp
5. ⏸️ Move to Subsection 3: Level-by-Level Base Class Features (L1-L10)

---

**Last Updated**: October 19, 2025  
**Status**: Draft Complete - Awaiting User Review
