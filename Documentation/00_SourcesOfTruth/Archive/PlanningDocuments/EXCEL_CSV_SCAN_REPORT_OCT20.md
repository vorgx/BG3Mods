# Excel CSV Scan Report - With Parsing Rule Applied

**Generated**: October 20, 2025  
**Source**: `Documentation/00_SourcesOfTruth/Warrior Progression for all subclasses.csv`  
**Parsing Rule**: Extract ONLY text BEFORE the "-" (dash) for ability names  
**Note**: Hero Talents (BD-BL) have NO descriptions (no dashes)

---

## CRITICAL FINDINGS

### ✅ VERIFIED: Fury L1 Does NOT Include Stances in Baseline

**Fury Baseline L1 (Columns I-J, Row 4)**:
- Column I: `Whirlwind`
- Column J: `Berserker Rage`

**Class Talents Row 1 (Columns K-L, Row 4)**:
- Column K: `Battle Stance`
- Column L: `Defensive Stance`

**CORRECTION NEEDED**: EXCEL_WARRIOR_PROGRESSION_ANALYSIS.md INCORRECTLY states:
> - **Fury L1**: Whirlwind + Berserker Rage + Battle Stance + Defensive Stance

**SHOULD BE**:
> - **Fury Baseline L1**: Whirlwind + Berserker Rage
> - **Class Talents Row 1** (ALL Warriors): Battle Stance + Defensive Stance

---

### ✅ VERIFIED: Colossus L13 is "Demolish" (NOT "Colossal Might")

**Colossus Hero Talents (Columns BG-BI)**:
- **L13 (Row 16)**: `Demolish` (Column BG only)
- **L15 (Row 18)**: `Martial Expert` + `Colossal Might` + `Earthquake`

**CORRECTION NEEDED**: Documents should NOT say "Demolish + Colossal Might passive" at L13

**CORRECT SEQUENCE**:
1. **L13**: Demolish (keystone ability)
2. **L15**: Martial Expert + Colossal Might + Earthquake (3 talents auto-granted)

Colossal Might is a **separate talent at L15**, not part of Demolish at L13.

---

### ✅ VERIFIED: L19 Now Has Feat

**Row 22 (L19), Column B**: `Add Feat`

The Excel has been updated - L19 now correctly shows a Feat milestone!

---

## Complete Ability Scan (With Parsing Rule Applied)

### Baseline Arms Abilities (Columns D-E)

| Level | Column D | Column E |
|-------|----------|----------|
| **L1** | Whirlwind | Charge |
| **L3** | Execute | Pummel |
| **L5** | Hamstring | Battle Shout |
| **L7** | Slam | Berserker Rage |
| **L9** | Victory Rush | Taunt |
| **L11** | Heroic Throw | *(empty)* |
| **L12** | Shield Slam | *(empty)* |

**Total**: 12 abilities

---

### Baseline Protection Abilities (Columns F-H)

| Level | Column F | Column G | Column H |
|-------|----------|----------|----------|
| **L1** | Shield Slam | Taunt | Mastery: Critical Block |
| **L3** | Devastate | Shield Block | Riposte |
| **L5** | Heroic Throw | Charge | Shield Block *(2nd charge note)* |
| **L7** | Slam | Pummel | Vanguard |
| **L9** | Victory Rush | *(empty)* | *(empty)* |
| **L10** | Execute | *(empty)* | *(empty)* |
| **L11** | Hamstring | Battle Shout | *(empty)* |
| **L12** | Whirlwind | *(empty)* | *(empty)* |

**Total**: 12 abilities (+ 1 note about 2nd charge)

---

### Baseline Fury Abilities (Columns I-J)

| Level | Column I | Column J |
|-------|----------|----------|
| **L1** | Whirlwind | Berserker Rage |
| **L3** | Slam | Charge |
| **L5** | Victory Rush | Pummel |
| **L7** | Execute | Battle Shout |
| **L9** | Hamstring | Taunt |
| **L11** | Heroic Throw | *(empty)* |
| **L12** | Shield Slam | *(empty)* |

**Total**: 12 abilities

**❌ NO STANCES IN FURY BASELINE** - Stances come from Class Talents Row 1!

---

### Warrior Class Talents (Columns K-L for Row 1, then multiple columns for Rows 2-10)

**Row 1 (L1)** - Auto-Granted:
- Battle Stance
- Defensive Stance

**Row 2 (L2)** - Choose 1:
- Fast Footwork
- War Machine
- Leeching Strikes
- Intervene

**Row 3 (L3)** - Choose 1:
- Impending Victory
- Heroic Leap
- Storm Bolt

**Row 4 (L4)** - Choose 1:
- Intimidating Shout
- Second Wind
- Frothing Berserker
- Bounding Stride
- Pain and Gain
- Thunder Clap

**Row 5 (L5)** - Choose 1:
- Cacophonous Roar
- Menace
- Spell Reflection
- Rallying Cry
- Shockwave
- Barbaric Training

**Row 6 (L6)** - Choose 1:
- Honed Reflexes
- Crushing Force
- Bitter Immunity
- Overwhelming Rage
- Rumbling Earth
- Reinforced Plates

**Row 7 (L7)** - Choose 1:
- Wrecking Throw
- Shattering Throw
- Sidearm
- Double Time
- Seismic Reverberation
- Concussive Blows
- Berserker Shout
- Piercing Howl
- Barbaric Training

**Row 8 (L8)** - Choose 1:
- Cruel Strikes
- Wild Strikes
- Dual Wield Specialization
- Armored to the Teeth

**Row 9 (L9)** - Choose 1:
- Thunderous Roar
- Avatar
- Champion's Spear

**Row 10 (L10)** - Choose 1:
- Uproar
- Thunderous Words
- Berserker's Torment
- Titan's Torment
- Piercing Challenge
- Champion's Might

---

### Arms Spec Talents (Columns vary)

**Row 1 (L3)** - Auto-Granted:
- Seasoned Soldier
- Mastery: Deep Wounds
- Mortal Strike

**Row 2 (L4)** - Auto-Granted:
- Overpower

**Row 3 (L5)** - Choose 1:
- Martial Prowess
- Die by the Sword
- Improved Execute

**Row 4 (L6)** - Choose 1:
- Improved Overpower
- Bloodsurge
- Fueled by Violence
- Storm Wall
- Ignore Pain
- Sudden Death
- Fervor of Battle

**Row 5 (L7)** - Choose 1:
- Tactician
- Colossus Smash
- Impale

**Row 6 (L8)** - Choose 1:
- Skullsplitter
- Rend
- Finishing Blows
- Anger Management
- Spiteful Serenity
- Exhilarating Blows
- Collateral Damage
- Cleave

**Row 7 (L9)** - Choose 1:
- Bloodborne
- Dreadnaught
- Strength of Arms
- In For The Kill
- Test of Might
- Blunt Instruments
- Warbreaker
- Massacre
- Storm of Swords

**Row 8 (L10)** - Choose 1:
- Deft Experience
- Valor in Victory
- Critical Thinking

**Row 9 (L11)** - Choose 1:
- Battlelord
- Bloodletting
- Bladestorm
- Ravager
- Sharpened Blades
- Juggernaut

**Row 10 (L12)** - Choose 1:
- Fatality
- Dance of Death
- Unhinged
- Merciless Bonegrinder
- Executioner's Precision

---

### Fury Spec Talents (Columns vary)

**Row 1 (L3)** - Auto-Granted:
- Titan's Grip
- Mastery: Unshackled Fury
- Bloodthirst

**Row 2 (L4)** - Auto-Granted:
- Raging Blow

**Row 3 (L5)** - Choose 1:
- Frenzied Enrage
- Powerful Enrage
- Enraged Regeneration
- Improved Execute

**Row 4 (L6)** - Choose 1:
- Improved Bloodthirst
- Fresh Meat
- Warpaint
- Invigorating Fury
- Sudden Death
- Cruelty

**Row 5 (L7)** - Choose 1:
- Focus in Chaos
- Rampage
- Improved Raging Blow

**Row 6 (L8)** - Choose 1:
- Single-Minded Fury
- Cold Steel, Hot Blood
- Vicious Contempt
- Frenzy
- Hack and Slash
- Slaughtering Strikes
- Ashen Juggernaut
- Improved Whirlwind

**Row 7 (L9)** - Choose 1:
- Bloodborne
- Bloodcraze
- Recklessness
- Massacre
- Wrath and Fury
- Meat Cleaver

**Row 8 (L10)** - Choose 1:
- Raging Armaments
- Swift Strikes
- Critical Thinking

**Row 9 (L11)** - Choose 1:
- Onslaught
- Anger Management
- Reckless Abandon
- Bladestorm
- Ravager
- Odyn's Fury

**Row 10 (L12)** - Choose 1:
- Tenderize
- Unhinged
- Storm of Steel
- Unbridled Ferocity
- Depths of Insanity
- Dancing Blades
- Titanic Rage

---

### Protection Spec Talents (Columns vary)

**Row 1 (L3)** - Auto-Granted:
- Ignore Pain

**Row 2 (L4)** - Choose 1:
- Revenge
- Demoralizing Shout

**Row 3 (L5)** - Choose 1:
- Brace For Impact
- Armor Specialization
- Fight Through the Flames
- Devastator

**Row 4 (L6)** - Choose 1:
- Disrupting Shout
- Best Served Cold
- Strategist

**Row 5 (L7)** - Choose 1:
- Last Stand
- Instigate
- Rend
- Bloodsurge
- Fueled by Violence
- Brutal Vitality

**Row 6 (L8)** - Choose 1:
- Unnerving Focus
- Heavy Repercussions
- Thunderlord
- Bloodborne
- Into the Fray
- Punish
- Hunker Down

**Row 7 (L9)** - Choose 1:
- Tough as Nails
- Shield Wall
- Enduring Defenses
- Unyielding Stance
- Red Right Hand

**Row 8 (L10)** - Choose 1:
- Defender's Aegis
- Impenetrable Wall
- Focused Vigor
- Shield Specialization
- Enduring Alacrity
- Anger Management

**Row 9 (L11)** - Choose 1:
- Massacre
- Booming Voice
- Thunderlord *(duplicate from Row 6?)* - **⚠️ POTENTIAL ERROR**
- Indomitable
- Violent Outburst
- Heavy Handed

**ISSUE FOUND**: CSV shows "Thunderlord, especially in AoE..." at Row 9, but Thunderlord already appears at Row 6 (L8). This might be a parsing error or duplicate talent name.

**Row 10 (L12)** - Choose 1:
- Shield Charge
- Battle-Scarred Veteran
- Whirling Blade
- Ravager

---

### Mountain Thane Hero Talents (Columns BD-BF, 56-58)

**NO DESCRIPTIONS** - Names only (no dashes)

- **L13**: Lightning Strikes
- **L14**: *(empty)*
- **L15**: Crashing Thunder + Ground Current + Strength of the Mountain
- **L16**: *(empty)*
- **L17**: Thunder Blast + Storm Bolts + Keep your feet on the Ground
- **L18**: *(empty)*
- **L19**: Flashing Skies + Thorim's Might + Burst of Power
- **L20**: Avatar of the Storm

**Total**: 11 talents (1 keystone + 9 talents + 1 capstone)

---

### Colossus Hero Talents (Columns BG-BI, 59-61)

**NO DESCRIPTIONS** - Names only (no dashes)

- **L13**: Demolish *(keystone - NOTE: NOT "Colossal Might")*
- **L14**: *(empty)*
- **L15**: Martial Expert + Colossal Might + Earthquake
- **L16**: *(empty)*
- **L17**: Arterial Bleed + Tide of Battle + No Stranger to Pain
- **L18**: *(empty)*
- **L19**: Practiced Strikes + Precise Might + Mountain of Muscle and Scars
- **L20**: Dominance of the Colossus

**Total**: 11 talents (1 keystone + 9 talents + 1 capstone)

**✅ VERIFIED**: Colossal Might is at L15, NOT L13!

---

### Slayer Hero Talents (Columns BJ-BL, 62-64)

**NO DESCRIPTIONS** - Names only (no dashes)

- **L13**: Slayer's Dominance
- **L14**: *(empty)*
- **L15**: Imminent Demise + Overwhelming Blades + Relentless Pursuit
- **L16**: *(empty)*
- **L17**: Death Drive + Brutal Finish + Opportunist
- **L18**: *(empty)*
- **L19**: Show No Mercy + Reap the Storm + Slayer's Malice
- **L20**: Unrelenting Onslaught

**Total**: 11 talents (1 keystone + 9 talents + 1 capstone)

---

## Issues to Report to User

### ⚠️ Potential Duplicate in Protection Row 9 (L11)

**CSV shows**: "Thunderlord, especially in AoE..." in Protection Row 9 cell

**But**: Thunderlord already appears in Protection Row 6 (L8)

**Question**: Is this a:
- A) **Different talent** with similar name?
- B) **Duplicate entry error**?
- C) **Parsing issue** where description text was included?

**Location**: CSV Row 12 (L11), columns for Protection Spec Row 9

---

## Summary of Corrections Needed

### 1. EXCEL_WARRIOR_PROGRESSION_ANALYSIS.md

**Lines to fix**:
- Line 58: Remove "Battle Stance + Defensive Stance" from Fury L1 baseline
- Line 141: Remove stances from Fury L1 abilities list
- Line 143: Remove "already granted for Fury" text
- Line 294: Change "Demolish (keystone ability + Colossal Might passive)" to just "Demolish"
- Line 313: Confirm "Colossal Might" is at L15 (correct)
- All references to "6 Feats" should note L19 Feat is now included

### 2. EXCEL_COMPLETE_BREAKDOWN_OCT20.md

**Sections to fix**:
- Fury L1 Baseline table (remove stances)
- Colossus L13 description (remove "Colossal Might")
- Update Feat count to 6 (L4, L8, L12, L16, L19, L20)

### 3. Any Other Documents

Search for:
- "Fury L1.*Battle Stance.*Defensive Stance"
- "Colossus.*L13.*Colossal Might"
- "5 Feats" or "missing L19"

---

## Verified Data Ready for SOURCE_OF_TRUTH.md Update

All ability names have been extracted using the parsing rule (text before "-" only).

Hero Talents confirmed to have NO descriptions (names only).

Fury L1 baseline confirmed to have NO stances.

Colossus L13 confirmed to be "Demolish" only (Colossal Might is L15).

L19 Feat confirmed present in Excel.

**Status**: ✅ Ready to create correction documents and update all references

---

**Next Steps**:
1. User confirms Protection Row 9 "Thunderlord" issue
2. Create comprehensive correction document
3. Update all affected documentation files
4. Verify no other discrepancies exist

**Last Updated**: October 20, 2025
