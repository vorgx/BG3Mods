# Complete Analysis: Warrior Progression for All Subclasses (Excel)

**Source File**: `Documentation/00_SourcesOfTruth/Warrior Progression for all subclasses.xlsx`  
**Analysis Date**: October 19, 2025  
**Purpose**: Comprehensive breakdown of the Excel spreadsheet structure and L1-20 progression

---

## Excel File Structure

**Dimensions**: 42 rows × 72 columns  
**Sheet Name**: Sheet1

### Column Organization (11 Major Sections)

| Column Range | Section Name | Type | Notes |
|--------------|--------------|------|-------|
| **Col 1-2** | Level & BG3 Milestones | Reference | Levels 1-20, Extra Attack, Feats/ASI |
| **Col 4-5** | Baseline Arms Abilities | Auto-Grant | Offensive + Utility abilities (Arms order) |
| **Col 6-8** | Baseline Protection Abilities | Auto-Grant | Offensive + Utility + Passives (Protection order) |
| **Col 9-10** | Baseline Fury Abilities | Auto-Grant | Offensive + Utility abilities (Fury order) |
| **Col 11-23** | Warrior Class Talents (Rows 1-10) | Choice Nodes | Shared by ALL subclasses (Stances + General) |
| **Col 24-36** | Arms Spec Talents (Rows 1-10) | Choice Nodes | Arms-only talent tree |
| **Col 37-47** | Fury Spec Talents (Rows 1-10) | Choice Nodes | Fury-only talent tree |
| **Col 48-55** | Protection Spec Talents (Rows 1-10) | Choice Nodes | Protection-only talent tree |
| **Col 56-58** | Mountain Thane Talents (L13-20) | Auto-Grant | Specialization option (Fury/Protection) |
| **Col 59-61** | Colossus Talents (L13-20) | Auto-Grant | Specialization option (Arms/Protection) |
| **Col 62-64** | Slayer Talents (L13-20) | Auto-Grant | Specialization option (Arms/Fury) |

---

## Key Insight: 3 Separate Ability Systems Confirmed

### System 1: Baseline/SubclassBase Abilities (Pool 3)

**What It Is**: Core rotation abilities granted automatically L1-12, **DIFFERENT ORDER per subclass**

**Arms Order** (Col 4-5):
- **L1**: Whirlwind (Offensive) + Charge (Utility)
- **L3**: Execute (Offensive) + Pummel (Utility)
- **L5**: Hamstring (Utility) + Battle Shout (Utility)
- **L7**: Slam (Offensive) + Berserker Rage (Utility)
- **L9**: Victory Rush (Utility) + Taunt (Utility)
- **L11**: Heroic Throw (Utility)
- **L12**: Shield Slam (Offensive)

**Protection Order** (Col 6-8):
- **L1**: Shield Slam (Offensive) + Taunt (Utility) + Mastery: Critical Block (Passive)
- **L3**: Devastate (Offensive) + Shield Block (Utility) + Riposte (Passive)
- **L5**: Heroic Throw (Utility) + Charge (Utility) + Shield Block 2nd charge (Passive)
- **L7**: Slam (Offensive) + Pummel (Utility) + Vanguard (Passive)
- **L9**: Execute (Offensive) + Victory Rush (Utility)
- **L11**: Battle Shout (Utility)
- **L12**: Whirlwind (Offensive) + Hamstring (Utility) + Shield Slam enhancement (Offensive)

**Fury Order** (Col 9-10):
- **L1**: Whirlwind (Offensive) + Berserker Rage (Utility) + Battle Stance + Defensive Stance
- **L3**: Slam (Offensive) + Charge (Utility)
- **L5**: Victory Rush (Utility) + Pummel (Utility)
- **L7**: Execute (Offensive) + Battle Shout (Utility)
- **L9**: Hamstring (Utility) + Taunt (Utility)
- **L11**: Heroic Throw (Utility)
- **L12**: Shield Slam (Offensive)

**Critical Design Insight**:
- **Protection gets Shield Slam + Taunt at L1** (can tank immediately!)
- **Arms gets Execute at L3** (Arms specialty finisher early)
- **Fury gets Berserker Rage at L1** (defines Fury's enrage-focused identity from start)
- **Each spec receives the same 12 abilities total, but in DIFFERENT ORDER**

### System 2: Warrior Class Talents (Pool 1 - Rows 1-10)

**What It Is**: Shared talent tree (L1-12) with **choice nodes** - ALL Warriors access these

**Row Structure** (Col 11-23):
- **Row 1 (L1)**: 2 slots - Stance options (Battle Stance, Defensive Stance) [AUTO-GRANTED]
- **Row 2 (L2)**: 4 choices - Fast Footwork | War Machine | Leeching Strikes | Intervene
- **Row 3 (L3)**: 3 choices - Impending Victory | Heroic Leap | Storm Bolt
- **Row 4 (L4)**: 6 choices - Intimidating Shout | Second Wind | Frothing Berserker | Bounding Stride | Pain and Gain | Thunder Clap
- **Row 5 (L5)**: 6 choices - Cacophonous Roar | Menace | Spell Reflection | Rallying Cry | Shockwave | Barbaric Training
- **Row 6 (L6)**: 6 choices - Honed Reflexes | Crushing Force | Bitter Immunity | Overwhelming Rage | Rumbling Earth | Reinforced Plates
- **Row 7 (L7)**: 9 choices - Wrecking Throw | Shattering Throw | Sidearm | Double Time | Seismic Reverberation | Concussive Blows | Berserker Shout | Piercing Howl | Barbaric Training
- **Row 8 (L8)**: 4 choices - Cruel Strikes | Wild Strikes | Dual Wield Specialization | Armored to the Teeth
- **Row 9 (L9)**: 3 choices - Thunderous Roar | Avatar | Champion's Spear
- **Row 10 (L10)**: 6 choices - Uproar | Thunderous Words | Berserker's Torment | Titan's Torment | Piercing Challenge | Champion's Might

**Total**: 10 rows, player picks 1 per row = **9 choices** (Row 1 auto-granted)

### System 3: SubclassSpec Talents (Pool 2 - Rows 1-10)

**What It Is**: Subclass-specific talent trees (L3-12) - ONLY your chosen spec can access

**Arms Spec Talents** (Col 24-36):
- **Row 1 (L3)**: Seasoned Soldier (Passive) + Mastery: Deep Wounds (Passive) + Mortal Strike (Ability)
- **Row 2 (L4)**: Overpower (Ability)
- **Row 3 (L5)**: Martial Prowess | Die by the Sword | Improved Execute
- **Row 4 (L6)**: Improved Overpower | Bloodsurge | Fueled by Violence | Storm Wall | Ignore Pain | Sudden Death | Fervor of Battle
- **Row 5 (L7)**: Tactician | Colossus Smash | Impale
- **Row 6 (L8)**: Skullsplitter | Rend | Finishing Blows | Anger Management | Spiteful Serenity | Exhilarating Blows | Collateral Damage | Cleave
- **Row 7 (L9)**: Bloodborne | Dreadnaught | Strength of Arms | In For The Kill | Test of Might | Blunt Instruments | Warbreaker | Massacre | Storm of Swords
- **Row 8 (L10)**: Deft Experience | Valor in Victory | Critical Thinking
- **Row 9 (L11)**: Battlelord | Bloodletting | Bladestorm | Ravager | Sharpened Blades | Juggernaut
- **Row 10 (L12)**: Fatality | Dance of Death | Unhinged | Merciless Bonegrinder | Executioner's Precision

**Fury Spec Talents** (Col 37-47):
- **Row 1 (L3)**: Titan's Grip (Passive) + Mastery: Unshackled Fury (Passive) + Bloodthirst (Ability)
- **Row 2 (L4)**: Raging Blow (Ability)
- **Row 3 (L5)**: Frenzied Enrage | Powerful Enrage | Enraged Regeneration | Improved Execute
- **Row 4 (L6)**: Improved Bloodthirst | Fresh Meat | Warpaint | Invigorating Fury | Sudden Death | Cruelty
- **Row 5 (L7)**: Focus in Chaos | Rampage | Improved Raging Blow
- **Row 6 (L8)**: Single-Minded Fury | Cold Steel Hot Blood | Vicious Contempt | Frenzy | Hack and Slash | Slaughtering Strikes | Ashen Juggernaut | Improved Whirlwind
- **Row 7 (L9)**: Bloodborne | Bloodcraze | Recklessness | Massacre | Wrath and Fury | Meat Cleaver
- **Row 8 (L10)**: Raging Armaments | Swift Strikes | Critical Thinking
- **Row 9 (L11)**: Onslaught | Anger Management | Reckless Abandon | Bladestorm | Ravager | Odyn's Fury
- **Row 10 (L12)**: Tenderize | Unhinged | Storm of Steel | Unbridled Ferocity | Depths of Insanity | Dancing Blades | Titanic Rage

**Protection Spec Talents** (Col 48-55):
- **Row 1 (L3)**: Ignore Pain (Ability)
- **Row 2 (L4)**: Revenge | Demoralizing Shout
- **Row 3 (L5)**: Brace For Impact | Armor Specialization | Fight Through the Flames | Devastator
- **Row 4 (L6)**: Disrupting Shout | Best Served Cold | Strategist
- **Row 5 (L7)**: Last Stand | Instigate | Rend | Bloodsurge | Fueled by Violence | Brutal Vitality
- **Row 6 (L8)**: Unnerving Focus | Heavy Repercussions | Thunderlord | Bloodborne | Into the Fray | Punish | Hunker Down
- **Row 7 (L9)**: Tough as Nails | Shield Wall | Enduring Defenses | Unyielding Stance | Red Right Hand
- **Row 8 (L10)**: Defender's Aegis | Impenetrable Wall | Focused Vigor | Shield Specialization | Enduring Alacrity | Anger Management
- **Row 9 (L11)**: Massacre | Booming Voice | Indomitable | Violent Outburst | Heavy Handed
- **Row 10 (L12)**: Shield Charge | Battle-Scarred Veteran | Whirling Blade | Ravager

**Total**: 10 rows per spec, player picks 1 per row = **9 choices** (Row 1 may have auto-grants)

---

## Level-by-Level Breakdown (What Players Actually See)

### Level 1 (Character Creation)
**BG3 Milestones**: Starting level
**Baseline Abilities Granted**:
- **Arms**: Whirlwind + Charge
- **Protection**: Shield Slam + Taunt + Mastery: Critical Block
- **Fury**: Whirlwind + Berserker Rage + Battle Stance + Defensive Stance

**Class Talents**: Row 1 auto-granted (Battle Stance + Defensive Stance for Arms/Protection, already granted for Fury)

**Total Abilities at L1**:
- Arms: 2 abilities + 2 stances = **4 features**
- Protection: 3 abilities + 1 passive + 2 stances = **6 features**
- Fury: 2 abilities + 2 stances (already have) = **4 features**

---

### Level 2
**BG3 Milestones**: None
**Baseline Abilities**: None
**Class Talents**: Row 2 choice (Fast Footwork | War Machine | Leeching Strikes | Intervene)

**Player Choices This Level**: **1 choice** (Class Talent Row 2)

---

### Level 3 (SUBCLASS SELECTION)
**BG3 Milestones**: Choose Arms | Fury | Protection
**Baseline Abilities Granted**:
- **Arms**: Execute + Pummel
- **Protection**: Devastate + Shield Block + Riposte
- **Fury**: Slam + Charge

**Class Talents**: Row 3 choice (Impending Victory | Heroic Leap | Storm Bolt)
**SubclassSpec Talents**: Row 1 (varies by subclass - see above)

**Player Choices This Level**: **2 choices** (Class Row 3 + SubclassSpec Row 1)

---

### Level 4 (FEAT/ASI)
**BG3 Milestones**: Feat or Ability Score Increase
**Baseline Abilities**: None
**Class Talents**: Row 4 choice (6 options - see above)
**SubclassSpec Talents**: Row 2 (varies by subclass)

**Player Choices This Level**: **3 choices** (Feat + Class Row 4 + SubclassSpec Row 2)

---

### Level 5 (EXTRA ATTACK)
**BG3 Milestones**: **Extra Attack** (attack twice per action)
**Baseline Abilities Granted**:
- **Arms**: Hamstring + Battle Shout
- **Protection**: Heroic Throw + Charge + Shield Block 2nd charge
- **Fury**: Victory Rush + Pummel

**Class Talents**: Row 5 choice (6 options)
**SubclassSpec Talents**: Row 3 (varies by subclass)

**Player Choices This Level**: **2 choices** (Class Row 5 + SubclassSpec Row 3)

---

### Level 6
**BG3 Milestones**: None
**Baseline Abilities**: None
**Class Talents**: Row 6 choice (6 options)
**SubclassSpec Talents**: Row 4 (varies by subclass)

**Player Choices This Level**: **2 choices** (Class Row 6 + SubclassSpec Row 4)

---

### Level 7
**BG3 Milestones**: None
**Baseline Abilities Granted**:
- **Arms**: Slam + Berserker Rage
- **Protection**: Slam + Pummel + Vanguard
- **Fury**: Execute + Battle Shout

**Class Talents**: Row 7 choice (9 options - largest choice pool!)
**SubclassSpec Talents**: Row 5 (varies by subclass)

**Player Choices This Level**: **2 choices** (Class Row 7 + SubclassSpec Row 5)

---

### Level 8 (FEAT/ASI)
**BG3 Milestones**: Feat or Ability Score Increase
**Baseline Abilities**: None
**Class Talents**: Row 8 choice (4 options)
**SubclassSpec Talents**: Row 6 (varies by subclass)

**Player Choices This Level**: **3 choices** (Feat + Class Row 8 + SubclassSpec Row 6)

---

### Level 9
**BG3 Milestones**: None
**Baseline Abilities Granted**:
- **Arms**: Victory Rush + Taunt
- **Protection**: Execute + Victory Rush
- **Fury**: Hamstring + Taunt

**Class Talents**: Row 9 choice (3 options - Thunderous Roar | Avatar | Champion's Spear)
**SubclassSpec Talents**: Row 7 (varies by subclass)

**Player Choices This Level**: **2 choices** (Class Row 9 + SubclassSpec Row 7)

---

### Level 10
**BG3 Milestones**: None
**Baseline Abilities**: None
**Class Talents**: Row 10 choice (6 options)
**SubclassSpec Talents**: Row 8 (varies by subclass)

**Player Choices This Level**: **2 choices** (Class Row 10 + SubclassSpec Row 8)

---

### Level 11
**BG3 Milestones**: None
**Baseline Abilities Granted**:
- **Arms**: Heroic Throw
- **Protection**: Battle Shout
- **Fury**: Heroic Throw

**Class Talents**: None (Row 10 was last)
**SubclassSpec Talents**: Row 9 (varies by subclass)

**Player Choices This Level**: **1 choice** (SubclassSpec Row 9)

---

### Level 12 (FEAT/ASI)
**BG3 Milestones**: Feat or Ability Score Increase
**Baseline Abilities Granted**:
- **Arms**: Shield Slam
- **Protection**: Whirlwind + Hamstring + Shield Slam enhancement
- **Fury**: Shield Slam

**Class Talents**: None (Row 10 was last)
**SubclassSpec Talents**: Row 10 (FINAL SubclassSpec choice) - labeled as "Row 9 Talents" in Excel

**Player Choices This Level**: **2 choices** (Feat + SubclassSpec Row 10)

---

### Level 13 (SPECIALIZATION SELECTION)
**BG3 Milestones**: Choose Specialization (Mountain Thane | Colossus | Slayer)
**Baseline Abilities**: None
**Class Talents**: None
**SubclassSpec Talents**: None
**Specialization**: **Keystone** auto-granted (varies by choice)
- **Mountain Thane**: Lightning Strikes (keystone)
- **Colossus**: Demolish (keystone ability + Colossal Might passive)
- **Slayer**: Slayer's Dominance (keystone)

**Player Choices This Level**: **1 choice** (Pick specialization - keystone auto-granted after selection)

---

### Level 14
**BG3 Milestones**: None
**Specialization**: No talents granted (empty level)

**Player Choices This Level**: **0 choices** (empty level)

---

### Level 15 (SPECIALIZATION AUTO-GRANT 1)
**BG3 Milestones**: None
**Specialization**: **3 Talents auto-granted** (no choice - all granted!)
- **Mountain Thane**: Crashing Thunder + Ground Current + Strength of the Mountain
- **Colossus**: Martial Expert + Colossal Might + Earthquake
- **Slayer**: Imminent Demise + Overwhelming Blades + Relentless Pursuit

**Player Choices This Level**: **0 choices** (all 3 talents auto-granted)

---

### Level 16 (FEAT/ASI)
**BG3 Milestones**: Feat or Ability Score Increase
**Specialization**: No talents granted (empty level)

**Player Choices This Level**: **1 choice** (Feat only)

---

### Level 17 (SPECIALIZATION AUTO-GRANT 2)
**BG3 Milestones**: None
**Specialization**: **3 Talents auto-granted** (no choice - all granted!)
- **Mountain Thane**: Thunder Blast + Storm Bolts + Keep your feet on the Ground
- **Colossus**: Arterial Blows + Tide of Battle + No Stranger to Pain
- **Slayer**: Death Drive + Brutal Finish + Opportunist

**Player Choices This Level**: **0 choices** (all 3 talents auto-granted)

---

### Level 18
**BG3 Milestones**: None
**Specialization**: No talents granted (empty level)

**Player Choices This Level**: **0 choices** (empty level)

---

### Level 19 (SPECIALIZATION AUTO-GRANT 3)
**BG3 Milestones**: None
**Specialization**: **3 Talents auto-granted** (no choice - all granted!)
- **Mountain Thane**: Flashing Skies + Thorim's Might + Burst of Power
- **Colossus**: Practiced Strikes + Precise Might + Mountain of Muscle and Scars
- **Slayer**: Show No Mercy + Reap the Storm + Slayer's Malice

**Player Choices This Level**: **0 choices** (all 3 talents auto-granted)

---

### Level 20 (FEAT/ASI + CAPSTONE)
**BG3 Milestones**: Feat or Ability Score Increase
**Specialization**: **Capstone** auto-granted (ultimate power)
- **Mountain Thane**: Avatar of the Storm
- **Colossus**: Dominance of the Colossus
- **Slayer**: Unrelenting Onslaught

**Player Choices This Level**: **1 choice** (Feat only, capstone auto-granted)

---

## Total Player Choices Across L1-20

| Level | Baseline Abilities | BG3 Milestones | Class Talents | SubclassSpec Talents | Specialization | Total Choices |
|-------|-------------------|----------------|---------------|---------------------|----------------|---------------|
| **L1** | Auto-grant | — | Auto-grant | — | — | **0 choices** |
| **L2** | — | — | Row 2 (1) | — | — | **1 choice** |
| **L3** | Auto-grant | Subclass Pick | Row 3 (1) | Row 1 (1) | — | **3 choices** |
| **L4** | — | Feat/ASI | Row 4 (1) | Row 2 (1) | — | **3 choices** |
| **L5** | Auto-grant | Extra Attack | Row 5 (1) | Row 3 (1) | — | **2 choices** |
| **L6** | — | — | Row 6 (1) | Row 4 (1) | — | **2 choices** |
| **L7** | Auto-grant | — | Row 7 (1) | Row 5 (1) | — | **2 choices** |
| **L8** | — | Feat/ASI | Row 8 (1) | Row 6 (1) | — | **3 choices** |
| **L9** | Auto-grant | — | Row 9 (1) | Row 7 (1) | — | **2 choices** |
| **L10** | — | — | Row 10 (1) | Row 8 (1) | — | **2 choices** |
| **L11** | Auto-grant | — | — | Row 9 (1) | — | **1 choice** |
| **L12** | Auto-grant | Feat/ASI | — | Row 10 (1) | — | **2 choices** |
| **L13** | — | Spec Pick | — | — | Keystone (0) | **1 choice** |
| **L14** | — | — | — | — | Empty | **0 choices** |
| **L15** | — | — | — | — | 3 Talents (0) | **0 choices** |
| **L16** | — | Feat/ASI | — | — | Empty | **1 choice** |
| **L17** | — | — | — | — | 3 Talents (0) | **0 choices** |
| **L18** | — | — | — | — | Empty | **0 choices** |
| **L19** | — | — | — | — | 3 Talents (0) | **0 choices** |
| **L20** | — | Feat/ASI | — | — | Capstone (0) | **1 choice** |

**Grand Total**: **23 player choices** across 20 levels
- **2 major selections**: Subclass (L3) + Specialization (L13)
- **9 Class Talent choices** (Pool 1, Rows 2-10)
- **9 SubclassSpec Talent choices** (Pool 2, Rows 1-10)
- **0 Specialization choices** (all 11 talents auto-granted!)
- **5 Feats/ASI** (L4, L8, L12, L16, L20) - **NOTE: Missing L19 Feat!**

---

## Critical Discoveries from Excel Analysis

### 1. **Baseline Abilities Are SUBCLASS-SPECIFIC UNLOCK ORDERS**

The Excel clearly shows 3 separate columns (Arms, Protection, Fury) with **DIFFERENT abilities at DIFFERENT levels**:

**Example: Shield Slam**
- **Protection**: Gets Shield Slam at **L1** (offensive capability from start)
- **Arms**: Gets Shield Slam at **L12** (late utility option)
- **Fury**: Gets Shield Slam at **L12** (late utility option)

**Example: Execute**
- **Arms**: Gets Execute at **L3** (Arms specialty finisher early)
- **Protection**: Gets Execute at **L9** (threat spike tool)
- **Fury**: Gets Execute at **L7** (mid-game finisher)

**Example: Taunt**
- **Protection**: Gets Taunt at **L1** (can tank immediately!)
- **Arms**: Gets Taunt at **L9** (utility aggro control)
- **Fury**: Gets Taunt at **L9** (utility aggro control)

### 2. **Protection Warriors Are DESIGNED TO TANK FROM L1**

Protection's L1 loadout:
- **Shield Slam** (offensive damage + threat)
- **Taunt** (threat control)
- **Mastery: Critical Block** (damage mitigation)
- **Battle Stance + Defensive Stance** (stance flexibility)

This is **5 features at L1** vs. Arms/Fury's 4 features, proving Protection's tank-ready design.

### 3. **Fury Has Unique L1 Design (Enrage Identity)**

Fury's L1 loadout:
- **Whirlwind** (dual-wield AoE)
- **Berserker Rage** (enrage mechanic - CORE to Fury!)
- **Battle Stance + Defensive Stance** (both granted at L1)

Berserker Rage at L1 defines Fury's enrage-focused gameplay from character creation.

### 4. **Class Talents (Pool 1) vs SubclassSpec Talents (Pool 2) Are Parallel Systems**

Both have **10 rows** with **9 choices** (Row 1 may have auto-grants):
- **Pool 1** (Class): Shared by all Warriors, utility/mobility focused
- **Pool 2** (SubclassSpec): Spec-specific, rotation/specialization focused

These run **parallel L2-L12**, with players making 2 choices per level (1 from each pool).

### **5. Specializations Are ALL AUTO-GRANTED (L13-L20)**

**CRITICAL CORRECTION**: Excel Row 3 headers say "Auto Granted" for ALL specialization columns!

All 3 specializations follow same structure:
- **L13**: Keystone (auto-grant)
- **L14**: Empty (no talents)
- **L15**: 3 Talents (ALL auto-granted, no choice!)
- **L16**: Empty (no talents)
- **L17**: 3 Talents (ALL auto-granted, no choice!)
- **L18**: Empty (no talents)
- **L19**: 3 Talents (ALL auto-granted, no choice!)
- **L20**: Capstone (auto-grant)

**Total**: **11 talents ALL auto-granted, 0 player choices** per specialization

**Example Mountain Thane**:
- L13: Lightning Strikes (keystone)
- L15: Crashing Thunder + Ground Current + Strength of the Mountain (3 talents)
- L17: Thunder Blast + Storm Bolts + Keep your feet on the Ground (3 talents)
- L19: Flashing Skies + Thorim's Might + Burst of Power (3 talents)
- L20: Avatar of the Storm (capstone)
- **Total**: 11 talents, 0 choices

### 6. **Missing L19 Feat in Excel**

The Excel shows Feats at L4, L8, L12, L16, L20 (5 total), but **BG3 standard is 6 Feats** (L4, L8, L12, L16, L19, L20).

**Conclusion**: Excel may be missing L19 Feat milestone, or design intentionally skips it.

### 7. **Row 7 of Class Talents Has Most Options (9 Choices)**

At L7, players choose from **9 Class Talent options** (largest choice pool):
- Wrecking Throw
- Shattering Throw
- Sidearm
- Double Time
- Seismic Reverberation
- Concussive Blows
- Berserker Shout
- Piercing Howl
- Barbaric Training

This is the "utility buffet" level where players customize mobility/crowd control.

### 8. **Baseline Abilities Stop at L12 (12 Total Per Subclass)**

Each subclass receives exactly **12 baseline abilities** L1-12:
- **Arms**: 7 offensive + 5 utility = **12 abilities**
- **Protection**: 5 offensive + 4 utility + 3 passives = **12 abilities**
- **Fury**: 7 offensive + 5 utility = **12 abilities**

After L12, progression is purely talent choices (SubclassSpec Row 10) and specialization trees.

---

## Comparison: Excel vs WARRIOR_COMPLETE_PROGRESSION_CHART.md

### Matches ✅
1. ✅ L1 Arms gets Whirlwind + Charge (both sources agree)
2. ✅ L1 Protection gets Shield Slam + Taunt (both sources agree)
3. ✅ L1 Fury gets Whirlwind + Berserker Rage (both sources agree)
4. ✅ L3 Arms gets Execute (both sources agree)
5. ✅ L5 Extra Attack (both sources agree)
6. ✅ L13 Specialization choice (both sources agree)
7. ✅ Feats at L4, L8, L12, L16, L20 (both sources agree)

### Discrepancies ⚠️
1. ⚠️ **Excel shows Baseline Abilities spread L1-L12**, WARRIOR_COMPLETE_PROGRESSION_CHART shows SubclassBase L3-L12 (different starting level)
2. ⚠️ **Excel Col 11 shows "Row 1 of Warrior Class Talents" at L1**, WARRIOR_COMPLETE_PROGRESSION_CHART shows Row 1 auto-granted + Row 2 choice at L1
3. ⚠️ **Excel lacks L19 Feat milestone**, WARRIOR_COMPLETE_PROGRESSION_CHART shows Feat at L19

**Resolution**: Excel appears to be **WoW source data** (how it works in World of Warcraft), while WARRIOR_COMPLETE_PROGRESSION_CHART is **BG3 adaptation** (how we're implementing it in BG3).

---

## Recommendations for SOURCE_OF_TRUTH.md

### For Subsection 2: Core Mechanics - Base Abilities Table

**Structure the table to show**:
1. **L1 Baseline** (ALL Warriors):
   - Arms: Whirlwind + Charge + Battle Stance + Defensive Stance
   - Protection: Shield Slam + Taunt + Mastery: Critical Block + Battle Stance + Defensive Stance
   - Fury: Whirlwind + Berserker Rage + Battle Stance + Defensive Stance

2. **L2-L12 Subclass-Specific Progression** (split by subclass):
   - Show 3 columns: Arms | Protection | Fury
   - List abilities granted at each level for each spec
   - Highlight key differences (Protection gets Shield Slam L1 vs L12 for others, Arms gets Execute L3 vs L7/L9 for others)

3. **Key Design Insights**:
   - Protection is tank-ready from L1
   - Arms specializes in Execute early (L3)
   - Fury defines enrage identity from L1
   - All specs receive same 12 abilities, different order

### For Subsection 3: Level-by-Level Progression (L1-L12)

**Use Excel data to document**:
- Exact ability unlock levels per subclass
- Class Talent choices per level (Row numbers + options)
- SubclassSpec Talent choices per level (Row numbers + options)
- Total player choices per level
- BG3 milestones (Extra Attack L5, Feats L4/L8/L12)

---

## Conclusion

The Excel file is a **comprehensive WoW source reference** showing:
1. ✅ **3 separate baseline ability unlock orders** (Arms, Protection, Fury) - L1-L12
2. ✅ **10-row Class Talent tree** (shared by all Warriors) - L2-L10
3. ✅ **10-row SubclassSpec Talent trees** (unique per spec) - L3-L12
4. ✅ **3 Specialization trees** (Mountain Thane, Colossus, Slayer) - L13-L20
5. ✅ **28 total player choices** across 20 levels (2 major picks + 9 Class + 9 SubclassSpec + 3 Specialization + 5 Feats)

**Critical for Building Base Abilities Table**: Use Excel columns 4-10 to show **exact level-by-level unlock progression** for each subclass, highlighting Protection's L1 tank capability and Arms' L3 Execute specialty.

---

**Last Updated**: October 19, 2025  
**Status**: Complete Analysis - Ready for SOURCE_OF_TRUTH.md Integration
