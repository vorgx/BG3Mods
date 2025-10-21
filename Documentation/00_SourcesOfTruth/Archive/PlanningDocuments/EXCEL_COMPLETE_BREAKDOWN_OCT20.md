# Excel Complete Breakdown - Warrior Progression Verification

**Generated**: October 20, 2025  
**Purpose**: Verify Excel data matches SOURCE_OF_TRUTH.md and confirm we're using correct structure  
**Source**: `Documentation/00_SourcesOfTruth/Warrior Progression for all subclasses.xlsx`

---

## Excel File Structure Overview

**Dimensions**: 42 rows × 72 columns (actual data ends around column 64)  
**Sheet Name**: Sheet1

---

## Column-by-Column Breakdown

### Section 1: Reference Columns (1-3)
| Column | Letter | Content | Purpose |
|--------|--------|---------|---------|
| **1** | A | Level (1-20) | Row labels for all progression |
| **2** | B | BG3 Milestones | Extra Attack (L5), Feats (L4/L8/L12/L16/L20) |
| **3** | C | *(Empty/Notes)* | Separator column |

---

### Section 2: Baseline Abilities - SUBCLASS-SPECIFIC UNLOCK ORDERS (4-10)

**CRITICAL**: These are NOT "base warrior" abilities - they're **subclass-specific rotation skills** granted in **different orders** per spec!

#### Arms Baseline (Columns 4-5 = D-E)
| Level | Column D (Offensive) | Column E (Utility) |
|-------|---------------------|-------------------|
| **L1** | Whirlwind | Charge |
| **L3** | Execute | Pummel |
| **L5** | Hamstring | Battle Shout |
| **L7** | Slam | Berserker Rage |
| **L9** | Victory Rush | Taunt |
| **L11** | Heroic Throw | *(empty)* |
| **L12** | Shield Slam | *(empty)* |

**Total**: 12 abilities (7 offensive + 5 utility)

#### Protection Baseline (Columns 6-8 = F-H)
| Level | Column F (Offensive) | Column G (Utility) | Column H (Passive) |
|-------|---------------------|-------------------|-------------------|
| **L1** | Shield Slam | Taunt | Mastery: Critical Block |
| **L3** | Devastate | Shield Block | Riposte |
| **L5** | Heroic Throw | Charge | Shield Block 2nd charge |
| **L7** | Slam | Pummel | Vanguard |
| **L9** | Victory Rush | *(empty)* | *(empty)* |
| **L10** | Execute | *(empty)* | *(empty)* |
| **L11** | Hamstring | Battle Shout | *(empty)* |
| **L12** | Whirlwind | *(empty)* | *(empty)* |

**Total**: 12 abilities (5 offensive + 4 utility + 3 passives)

**KEY INSIGHT**: Protection gets **Shield Slam + Taunt at L1** → Tank-ready from character creation!

#### Fury Baseline (Columns 9-10 = I-J)
| Level | Column I (Offensive) | Column J (Utility/Passive) |
|-------|---------------------|---------------------------|
| **L1** | Whirlwind | Berserker Rage + Battle Stance + Defensive Stance |
| **L3** | Slam | Charge |
| **L5** | Victory Rush | Pummel |
| **L7** | Execute | Battle Shout |
| **L9** | Hamstring | Taunt |
| **L11** | Heroic Throw | *(empty)* |
| **L12** | Shield Slam | *(empty)* |

**Total**: 12 abilities (7 offensive + 5 utility)

**KEY INSIGHT**: Fury gets **Berserker Rage at L1** → Enrage identity from start!

---

### Section 3: Warrior Class Talents - SHARED BY ALL SPECS (11-23 = K-W)

**Type**: Choice nodes (player picks 1 per row)  
**Levels**: L1-L10 (Row 1 auto-granted, Rows 2-10 are choices)  
**Total Rows**: 10 rows  
**Total Choices**: 9 (Row 1 auto-grants Battle Stance + Defensive Stance)

| Row | Level | Columns | Options Available |
|-----|-------|---------|-------------------|
| **Row 1** | L1 | K-L | Battle Stance + Defensive Stance *(AUTO-GRANTED)* |
| **Row 2** | L2 | M-P | Fast Footwork \| War Machine \| Leeching Strikes \| Intervene *(4 choices)* |
| **Row 3** | L3 | Q-S | Impending Victory \| Heroic Leap \| Storm Bolt *(3 choices)* |
| **Row 4** | L4 | T-Y | Intimidating Shout \| Second Wind \| Frothing Berserker \| Bounding Stride \| Pain and Gain \| Thunder Clap *(6 choices)* |
| **Row 5** | L5 | Z-AE | Cacophonous Roar \| Menace \| Spell Reflection \| Rallying Cry \| Shockwave \| Barbaric Training *(6 choices)* |
| **Row 6** | L6 | AF-AK | Honed Reflexes \| Crushing Force \| Bitter Immunity \| Overwhelming Rage \| Rumbling Earth \| Reinforced Plates *(6 choices)* |
| **Row 7** | L7 | AL-AT | Wrecking Throw \| Shattering Throw \| Sidearm \| Double Time \| Seismic Reverberation \| Concussive Blows \| Berserker Shout \| Piercing Howl \| Barbaric Training *(9 choices)* |
| **Row 8** | L8 | AU-AX | Cruel Strikes \| Wild Strikes \| Dual Wield Specialization \| Armored to the Teeth *(4 choices)* |
| **Row 9** | L9 | AY-BA | Thunderous Roar \| Avatar \| Champion's Spear *(3 choices)* |
| **Row 10** | L10 | BB-BG | Uproar \| Thunderous Words \| Berserker's Torment \| Titan's Torment \| Piercing Challenge \| Champion's Might *(6 choices)* |

**Total**: 13 columns (K-W)  
**Player Choices**: 9 (1 per row, Row 1 auto-granted)

---

### Section 4: Arms Spec Talents (24-36 = X-AJ)

**Type**: Choice nodes (Arms Warriors only)  
**Levels**: L3-L12 (Row 1 has auto-grants, Rows 2-10 are choices)  
**Total Rows**: 10 rows  
**Total Choices**: 9 (Row 1 auto-grants Seasoned Soldier + Mastery: Deep Wounds + Mortal Strike)

| Row | Level | Notable Talents |
|-----|-------|----------------|
| **Row 1** | L3 | Seasoned Soldier (Passive) + Mastery: Deep Wounds (Passive) + Mortal Strike (Ability) *(AUTO-GRANTED)* |
| **Row 2** | L4 | Overpower (Ability) *(AUTO-GRANTED)* |
| **Row 3** | L5 | Martial Prowess \| Die by the Sword \| Improved Execute *(3 choices)* |
| **Row 4** | L6 | Improved Overpower \| Bloodsurge \| Fueled by Violence \| Storm Wall \| Ignore Pain \| Sudden Death \| Fervor of Battle *(7 choices)* |
| **Row 5** | L7 | Tactician \| Colossus Smash \| Impale *(3 choices)* |
| **Row 6** | L8 | Skullsplitter \| Rend \| Finishing Blows \| Anger Management \| Spiteful Serenity \| Exhilarating Blows \| Collateral Damage \| Cleave *(8 choices)* |
| **Row 7** | L9 | Bloodborne \| Dreadnaught \| Strength of Arms \| In For The Kill \| Test of Might \| Blunt Instruments \| Warbreaker \| Massacre \| Storm of Swords *(9 choices)* |
| **Row 8** | L10 | Deft Experience \| Valor in Victory \| Critical Thinking *(3 choices)* |
| **Row 9** | L11 | Battlelord \| Bloodletting \| Bladestorm \| Ravager \| Sharpened Blades \| Juggernaut *(6 choices)* |
| **Row 10** | L12 | Fatality \| Dance of Death \| Unhinged \| Merciless Bonegrinder \| Executioner's Precision *(5 choices)* |

**Total**: 13 columns (X-AJ)  
**Player Choices**: 9 (Rows 3-10, Row 1-2 auto-grant)

---

### Section 5: Fury Spec Talents (37-47 = AK-AU)

**Type**: Choice nodes (Fury Warriors only)  
**Levels**: L3-L12 (Row 1 has auto-grants, Rows 2-10 are choices)  
**Total Rows**: 10 rows  
**Total Choices**: 9 (Row 1 auto-grants Titan's Grip + Mastery: Unshackled Fury + Bloodthirst)

| Row | Level | Notable Talents |
|-----|-------|----------------|
| **Row 1** | L3 | Titan's Grip (Passive) + Mastery: Unshackled Fury (Passive) + Bloodthirst (Ability) *(AUTO-GRANTED)* |
| **Row 2** | L4 | Raging Blow (Ability) *(AUTO-GRANTED)* |
| **Row 3** | L5 | Frenzied Enrage \| Powerful Enrage \| Enraged Regeneration \| Improved Execute *(4 choices)* |
| **Row 4** | L6 | Improved Bloodthirst \| Fresh Meat \| Warpaint \| Invigorating Fury \| Sudden Death \| Cruelty *(6 choices)* |
| **Row 5** | L7 | Focus in Chaos \| Rampage \| Improved Raging Blow *(3 choices)* |
| **Row 6** | L8 | Single-Minded Fury \| Cold Steel Hot Blood \| Vicious Contempt \| Frenzy \| Hack and Slash \| Slaughtering Strikes \| Ashen Juggernaut \| Improved Whirlwind *(8 choices)* |
| **Row 7** | L9 | Bloodborne \| Bloodcraze \| Recklessness \| Massacre \| Wrath and Fury \| Meat Cleaver *(6 choices)* |
| **Row 8** | L10 | Raging Armaments \| Swift Strikes \| Critical Thinking *(3 choices)* |
| **Row 9** | L11 | Onslaught \| Anger Management \| Reckless Abandon \| Bladestorm \| Ravager \| Odyn's Fury *(6 choices)* |
| **Row 10** | L12 | Tenderize \| Unhinged \| Storm of Steel \| Unbridled Ferocity \| Depths of Insanity \| Dancing Blades \| Titanic Rage *(7 choices)* |

**Total**: 11 columns (AK-AU)  
**Player Choices**: 9 (Rows 3-10, Row 1-2 auto-grant)

---

### Section 6: Protection Spec Talents (48-55 = AV-BC)

**Type**: Choice nodes (Protection Warriors only)  
**Levels**: L3-L12 (Row 1 has auto-grants, Rows 2-10 are choices)  
**Total Rows**: 10 rows  
**Total Choices**: 9 (Row 1 auto-grants Ignore Pain)

| Row | Level | Notable Talents |
|-----|-------|----------------|
| **Row 1** | L3 | Ignore Pain (Ability) *(AUTO-GRANTED)* |
| **Row 2** | L4 | Revenge \| Demoralizing Shout *(2 choices)* |
| **Row 3** | L5 | Brace For Impact \| Armor Specialization \| Fight Through the Flames \| Devastator *(4 choices)* |
| **Row 4** | L6 | Disrupting Shout \| Best Served Cold \| Strategist *(3 choices)* |
| **Row 5** | L7 | Last Stand \| Instigate \| Rend \| Bloodsurge \| Fueled by Violence \| Brutal Vitality *(6 choices)* |
| **Row 6** | L8 | Unnerving Focus \| Heavy Repercussions \| Thunderlord \| Bloodborne \| Into the Fray \| Punish \| Hunker Down *(7 choices)* |
| **Row 7** | L9 | Tough as Nails \| Shield Wall \| Enduring Defenses \| Unyielding Stance \| Red Right Hand *(5 choices)* |
| **Row 8** | L10 | Defender's Aegis \| Impenetrable Wall \| Focused Vigor \| Shield Specialization \| Enduring Alacrity \| Anger Management *(6 choices)* |
| **Row 9** | L11 | Massacre \| Booming Voice \| Indomitable \| Violent Outburst \| Heavy Handed *(5 choices)* |
| **Row 10** | L12 | Shield Charge \| Battle-Scarred Veteran \| Whirling Blade \| Ravager *(4 choices)* |

**Total**: 8 columns (AV-BC)  
**Player Choices**: 9 (Rows 2-10, Row 1 auto-grant)

---

### Section 7: Hero Talents - Mountain Thane (56-58 = BD-BF)

**Type**: Auto-granted talents (NO choices!)  
**Levels**: L13-L20  
**Available To**: Fury + Protection Warriors only

| Level | Column BD | Column BE | Column BF |
|-------|-----------|-----------|-----------|
| **L13** | Lightning Strikes (Keystone) | *(empty)* | *(empty)* |
| **L14** | *(empty)* | *(empty)* | *(empty)* |
| **L15** | Crashing Thunder | Ground Current | Strength of the Mountain |
| **L16** | *(empty)* | *(empty)* | *(empty)* |
| **L17** | Thunder Blast | Storm Bolts | Keep your feet on the Ground |
| **L18** | *(empty)* | *(empty)* | *(empty)* |
| **L19** | Flashing Skies | Thorim's Might | Burst of Power |
| **L20** | Avatar of the Storm (Capstone) | *(empty)* | *(empty)* |

**Total Talents**: 11 (1 keystone + 9 talents + 1 capstone)  
**Player Choices**: 0 (all auto-granted!)

---

### Section 8: Hero Talents - Colossus (59-61 = BG-BI)

**Type**: Auto-granted talents (NO choices!)  
**Levels**: L13-L20  
**Available To**: Arms + Protection Warriors only

| Level | Column BG | Column BH | Column BI |
|-------|-----------|-----------|-----------|
| **L13** | Demolish (Keystone Ability) | *(empty)* | *(empty)* |
| **L14** | *(empty)* | *(empty)* | *(empty)* |
| **L15** | Martial Expert | Colossal Might | Earthquake |
| **L16** | *(empty)* | *(empty)* | *(empty)* |
| **L17** | Arterial Blows | Tide of Battle | No Stranger to Pain |
| **L18** | *(empty)* | *(empty)* | *(empty)* |
| **L19** | Practiced Strikes | Precise Might | Mountain of Muscle and Scars |
| **L20** | Dominance of the Colossus (Capstone) | *(empty)* | *(empty)* |

**Total Talents**: 11 (1 keystone ability + 9 talents + 1 capstone)  
**Player Choices**: 0 (all auto-granted!)

---

### Section 9: Hero Talents - Slayer (62-64 = BJ-BL)

**Type**: Auto-granted talents (NO choices!)  
**Levels**: L13-L20  
**Available To**: Arms + Fury Warriors only

| Level | Column BJ | Column BK | Column BL |
|-------|-----------|-----------|-----------|
| **L13** | Slayer's Dominance (Keystone) | *(empty)* | *(empty)* |
| **L14** | *(empty)* | *(empty)* | *(empty)* |
| **L15** | Imminent Demise | Overwhelming Blades | Relentless Pursuit |
| **L16** | *(empty)* | *(empty)* | *(empty)* |
| **L17** | Death Drive | Brutal Finish | Opportunist |
| **L18** | *(empty)* | *(empty)* | *(empty)* |
| **L19** | Show No Mercy | Reap the Storm | Slayer's Malice |
| **L20** | Unrelenting Onslaught (Capstone) | *(empty)* | *(empty)* |

**Total Talents**: 11 (1 keystone + 9 talents + 1 capstone)  
**Player Choices**: 0 (all auto-granted!)

---

## Summary Statistics

### Total Columns Used
- **Reference**: 3 columns (A-C)
- **Baseline Abilities**: 7 columns (D-J)
- **Class Talents**: 13 columns (K-W)
- **Arms Spec Talents**: 13 columns (X-AJ)
- **Fury Spec Talents**: 11 columns (AK-AU)
- **Protection Spec Talents**: 8 columns (AV-BC)
- **Mountain Thane**: 3 columns (BD-BF)
- **Colossus**: 3 columns (BG-BI)
- **Slayer**: 3 columns (BJ-BL)
- **Total**: ~64 columns (A-BL)

### Total Abilities/Talents
- **Baseline Abilities**: 12 per subclass × 3 subclasses = **36 total** (but same 12, different unlock orders)
- **Class Talents**: 49 unique talents (9 rows of choices + 2 auto-grants)
- **Arms Spec Talents**: 52 unique talents (9 rows of choices + 4 auto-grants)
- **Fury Spec Talents**: 50 unique talents (9 rows of choices + 4 auto-grants)
- **Protection Spec Talents**: 45 unique talents (9 rows of choices + 1 auto-grant)
- **Hero Talents**: 11 per specialization × 3 specializations = **33 total**

**GRAND TOTAL**: **~265 unique abilities/talents** across all content

### Player Choices Per Level (L1-L20)
| Level | Baseline | BG3 Milestones | Class Talents | SubclassSpec Talents | Hero Talents | **Total Choices** |
|-------|----------|----------------|---------------|---------------------|--------------|-------------------|
| **L1** | Auto | — | Auto | — | — | **0** |
| **L2** | — | — | 1 | — | — | **1** |
| **L3** | Auto | **Pick Subclass** | 1 | 1 | — | **3** |
| **L4** | — | Feat/ASI | 1 | 1 | — | **3** |
| **L5** | Auto | Extra Attack | 1 | 1 | — | **2** |
| **L6** | — | — | 1 | 1 | — | **2** |
| **L7** | Auto | — | 1 | 1 | — | **2** |
| **L8** | — | Feat/ASI | 1 | 1 | — | **3** |
| **L9** | Auto | — | 1 | 1 | — | **2** |
| **L10** | — | — | 1 | 1 | — | **2** |
| **L11** | Auto | — | — | 1 | — | **1** |
| **L12** | Auto | Feat/ASI | — | 1 | — | **2** |
| **L13** | — | **Pick Hero Spec** | — | — | Auto | **1** |
| **L14** | — | — | — | — | — | **0** |
| **L15** | — | — | — | — | Auto (3) | **0** |
| **L16** | — | Feat/ASI | — | — | — | **1** |
| **L17** | — | — | — | — | Auto (3) | **0** |
| **L18** | — | — | — | — | — | **0** |
| **L19** | — | Feat/ASI | — | — | Auto (3) | **1** |
| **L20** | — | Feat/ASI | — | — | Auto (Capstone) | **1** |

**Total Player Choices**: **29 decisions**
- **2 Major Picks**: Subclass (L3) + Hero Specialization (L13)
- **9 Class Talent Choices**: Rows 2-10 (L2-L10)
- **9 SubclassSpec Talent Choices**: Rows 2-10 (L4-L12)
- **0 Hero Talent Choices**: All 11 auto-granted
- **6 Feats/ASI**: L4, L8, L12, L16, L19, L20

---

## Key Terminology Clarifications

### ❌ INCORRECT TERMS (Do Not Use)
- ~~"Base Warrior abilities"~~ → Implies ALL Warriors get same abilities at same levels
- ~~"Base class"~~ → Confusing - use specific terms instead

### ✅ CORRECT TERMS (Use These)

1. **"Baseline Abilities"** = Subclass-specific rotation skills (columns D-J)
   - Example: "Arms Baseline gets Execute at L3, Protection Baseline gets it at L10"
   - These are the SAME 12 abilities but granted in DIFFERENT ORDER per spec

2. **"Class Talents"** = Shared talent tree for ALL Warriors (columns K-W, Rows 1-10)
   - Example: "Row 7 Class Talents offer 9 utility options at L7"
   - Includes auto-granted stances (Row 1) + 9 choice rows (Rows 2-10)

3. **"SubclassSpec Talents"** = Spec-specific talent trees (columns X-BC, Rows 1-10)
   - Example: "Arms Spec Talents Row 5 offers Tactician, Colossus Smash, or Impale"
   - Includes auto-granted abilities (Row 1-2) + 8 choice rows (Rows 3-10)

4. **"Hero Talents"** = L13-L20 specialization trees (columns BD-BL)
   - Example: "Mountain Thane Hero Talents are all auto-granted, no choices"
   - 11 talents total per specialization (keystone + 9 talents + capstone)

5. **"Auto-Grant"** = Abilities/talents given automatically, no player choice
   - Example: "L1 Baseline abilities are auto-granted (Whirlwind + Charge for Arms)"

6. **"Choice Node"** = Player picks 1 option from multiple talents
   - Example: "Class Talents Row 2 is a choice node with 4 options"

---

## Critical Discrepancies to Investigate

### 1. ⚠️ Fury L1 shows 4 items (Whirlwind + Berserker Rage + Battle Stance + Defensive Stance)
**Excel shows**: Fury L1 baseline = Whirlwind + Berserker Rage (2 abilities), Battle/Defensive Stance from Class Talents Row 1  
**Resolution**: Stances are **NOT** part of Fury's baseline - they come from Class Talents Row 1 (columns K-L) granted to **ALL** Warriors at L1

---

## Validation Checklist

Compare this Excel breakdown against:

- [ ] **SOURCE_OF_TRUTH.md Section [2]**: Base Abilities Table
  - Verify baseline ability unlock orders match (Arms/Fury/Prot)
  - Confirm Protection gets Shield Slam + Taunt at L1
  - Verify each spec gets same 12 abilities in different order

- [ ] **SOURCE_OF_TRUTH.md Section [3]**: Level-by-Level Progression (L1-L12)
  - Verify Class Talents rows/options match
  - Verify SubclassSpec Talents rows/options match
  - Confirm player choice counts per level

- [ ] **SOURCE_OF_TRUTH.md Section [5]**: Hero Talents (L13-L20)
  - Verify all 11 talents per specialization
  - Confirm all are auto-granted (no choices)
  - Verify keystone/capstone labels

- [ ] **Progressions.lsx**: Implementation file
  - Verify AddSpells() calls match baseline ability levels
  - Verify SelectPassives() calls match talent choice levels
  - Verify PassivesAdded match auto-grant levels

---

## Recommendations for SOURCE_OF_TRUTH.md Updates

### Update Section [2]: Core Mechanics - Base Abilities Table

**Replace with**:
```markdown
### 2.2 Base Abilities by Subclass

**CRITICAL**: Baseline abilities are granted in DIFFERENT ORDERS per subclass!

#### Arms Baseline Progression (L1-L12)
L1: Whirlwind + Charge
L3: Execute + Pummel
L5: Hamstring + Battle Shout
L7: Slam + Berserker Rage
L9: Victory Rush + Taunt
L11: Heroic Throw
L12: Shield Slam

#### Protection Baseline Progression (L1-L12)
L1: Shield Slam + Taunt + Mastery: Critical Block ← **TANK-READY FROM START**
L3: Devastate + Shield Block + Riposte
L5: Heroic Throw + Charge + Shield Block 2nd charge
L7: Slam + Pummel + Vanguard
L9: Victory Rush
L10: Execute
L11: Hamstring + Battle Shout
L12: Whirlwind

#### Fury Baseline Progression (L1-L12)
L1: Whirlwind + Berserker Rage + Battle Stance + Defensive Stance ← **ENRAGE IDENTITY FROM START**
L3: Slam + Charge
L5: Victory Rush + Pummel
L7: Execute + Battle Shout
L9: Hamstring + Taunt
L11: Heroic Throw
L12: Shield Slam
```

### Update Section [3]: Level-by-Level Progression

Add column ranges to each level's description:
```markdown
**L2 Choices**:
- Class Talents Row 2 (Columns M-P): Fast Footwork | War Machine | Leeching Strikes | Intervene
```

### Update Section [5]: Hero Talents

Confirm all 11 talents per spec with exact names from Excel.

---

**Next Steps**:
1. User reviews this breakdown for accuracy
2. Identify any discrepancies between Excel and SOURCE_OF_TRUTH.md
3. Update SOURCE_OF_TRUTH.md with corrected data
4. Verify Progressions.lsx implementation matches Excel structure

**Last Updated**: October 20, 2025  
**Status**: ✅ Complete - Awaiting User Verification
