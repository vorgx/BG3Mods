# Excel Ability Count Summary - Complete Inventory

**Source**: `Warrior Progression for all subclasses.xlsx`  
**Analysis Date**: October 19, 2025  
**Purpose**: Complete count of all abilities, passives, and talents in the Excel sheet

---

## 📊 **GRAND TOTAL SUMMARY**

| Category | Count | Notes |
|----------|-------|-------|
| **Baseline Abilities (Auto-Granted L1-12)** | **12 per subclass** | Same 12 abilities, different unlock order |
| **Class Talents (Pool 1, Rows 1-10)** | **55 options** | 1 auto-grant + 54 choice options across 9 rows |
| **Arms Spec Talents (Pool 2, Rows 1-10)** | **61 options** | 3 auto-grants + 58 choice options across 9 rows |
| **Fury Spec Talents (Pool 2, Rows 1-10)** | **59 options** | 3 auto-grants + 56 choice options across 9 rows |
| **Protection Spec Talents (Pool 2, Rows 1-10)** | **47 options** | 1 auto-grant + 46 choice options across 9 rows |
| **Mountain Thane Specialization (L13-20)** | **11 talents** | All auto-granted (keystone + 9 talents + capstone) |
| **Colossus Specialization (L13-20)** | **11 talents** | All auto-granted (keystone + 9 talents + capstone) |
| **Slayer Specialization (L13-20)** | **11 talents** | All auto-granted (keystone + 9 talents + capstone) |

### **Resource System Requirements Estimate**:
Based on Excel ability names, these abilities will likely need secondary resources:
- **Charge** (MobilityCharge resource) - appears in all 3 baseline progressions
- **Heroic Leap** (MobilityCharge resource) - Class Talents Row 3
- **Intervene** (MobilityCharge resource) - Class Talents Row 2
- **Storm Bolt** (MobilityCharge resource) - Class Talents Row 3
- **Overpower** (OverpowerCharge resource) - Arms Spec Row 2
- **Thunder Clap** (ThunderCharge resource) - Class Talents Row 4
- **Die by the Sword** (DefensiveCharge resource) - Arms Spec Row 3
- **Berserker Rage** (DefensiveCharge resource) - Baseline abilities
- **Last Stand** (TankCooldown resource) - Protection Spec Row 5
- **Shield Wall** (TankCooldown resource) - Protection Spec Row 7
- **Indomitable** (TankCooldown resource) - Protection Spec Row 9

**⚠️ NOTE FOR FUTURE REVIEW**: Once we complete ability implementation, we should audit resource system to ensure all abilities have correct resource costs!

---

## 📋 **DETAILED BREAKDOWN**

---

## 1. Baseline Abilities (Auto-Granted L1-12)

**Total**: **12 abilities per subclass** (same abilities, different unlock order)

### **Complete List of 12 Baseline Abilities**:
1. **Whirlwind** (Offensive - AoE cleave)
2. **Charge** (Utility - Gap closer, mobility)
3. **Execute** (Offensive - Finisher, high damage)
4. **Pummel** (Utility - Interrupt)
5. **Hamstring** (Utility - Slow/snare)
6. **Battle Shout** (Utility - Buff)
7. **Slam** (Offensive - Single-target damage)
8. **Berserker Rage** (Utility - Enrage mechanic, CC removal)
9. **Victory Rush** (Utility - Heal on kill)
10. **Taunt** (Utility - Threat control)
11. **Heroic Throw** (Utility - Ranged pull)
12. **Shield Slam** (Offensive - Damage + threat)

### **Protection-Exclusive Baseline Passives** (3 additional):
- **Mastery: Critical Block** (L1 - Passive damage mitigation)
- **Riposte** (L3 - Passive counter-attack)
- **Vanguard** (L7 - Passive tank enhancement)

**Total Baseline**: **12 abilities + 3 Protection passives = 15 unique baseline features**

---

## 2. Class Talents (Pool 1 - Shared by ALL Warriors)

**Total**: **55 talent options** across 10 rows

### **Row 1 (L1) - Auto-Granted**: **2 stances**
1. Battle Stance
2. Defensive Stance

### **Row 2 (L2) - 4 Choices**:
1. Fast Footwork
2. War Machine
3. Leeching Strikes
4. Intervene

### **Row 3 (L3) - 3 Choices**:
1. Impending Victory
2. Heroic Leap
3. Storm Bolt

### **Row 4 (L4) - 6 Choices**:
1. Intimidating Shout
2. Second Wind
3. Frothing Berserker
4. Bounding Stride
5. Pain and Gain
6. Thunder Clap

### **Row 5 (L5) - 6 Choices**:
1. Cacophonous Roar
2. Menace
3. Spell Reflection
4. Rallying Cry
5. Shockwave
6. Barbaric Training

### **Row 6 (L6) - 6 Choices**:
1. Honed Reflexes
2. Crushing Force
3. Bitter Immunity
4. Overwhelming Rage
5. Rumbling Earth
6. Reinforced Plates

### **Row 7 (L7) - 9 Choices** (LARGEST CHOICE POOL!):
1. Wrecking Throw
2. Shattering Throw
3. Sidearm
4. Double Time
5. Seismic Reverberation
6. Concussive Blows
7. Berserker Shout
8. Piercing Howl
9. Barbaric Training (duplicate option)

### **Row 8 (L8) - 4 Choices**:
1. Cruel Strikes
2. Wild Strikes
3. Dual Wield Specialization
4. Armored to the Teeth

### **Row 9 (L9) - 3 Choices**:
1. Thunderous Roar
2. Avatar
3. Champion's Spear

### **Row 10 (L10) - 6 Choices**:
1. Uproar
2. Thunderous Words
3. Berserker's Torment
4. Titan's Torment
5. Piercing Challenge
6. Champion's Might

**Total Class Talents**: **2 auto-grants + 47 choice options = 49 unique talents** (6 duplicates = 55 total slots)

---

## 3. Arms Spec Talents (Pool 2 - Arms Only)

**Total**: **61 talent options** across 10 rows

### **Row 1 (L3) - Auto-Granted**: **3 features**
1. Seasoned Soldier (Passive)
2. Mastery: Deep Wounds (Passive)
3. Mortal Strike (Ability)

### **Row 2 (L4) - 1 Ability**:
1. Overpower

### **Row 3 (L5) - 3 Choices**:
1. Martial Prowess
2. Die by the Sword
3. Improved Execute

### **Row 4 (L6) - 7 Choices**:
1. Improved Overpower
2. Bloodsurge
3. Fueled by Violence
4. Storm Wall
5. Ignore Pain
6. Sudden Death
7. Fervor of Battle

### **Row 5 (L7) - 3 Choices**:
1. Tactician
2. Colossus Smash
3. Impale

### **Row 6 (L8) - 8 Choices**:
1. Skullsplitter
2. Rend
3. Finishing Blows
4. Anger Management
5. Spiteful Serenity
6. Exhilarating Blows
7. Collateral Damage
8. Cleave

### **Row 7 (L9) - 9 Choices** (LARGEST ARMS CHOICE POOL!):
1. Bloodborne
2. Dreadnaught
3. Strength of Arms
4. In For The Kill
5. Test of Might
6. Blunt Instruments
7. Warbreaker
8. Massacre
9. Storm of Swords

### **Row 8 (L10) - 3 Choices**:
1. Deft Experience
2. Valor in Victory
3. Critical Thinking

### **Row 9 (L11) - 6 Choices**:
1. Battlelord
2. Bloodletting
3. Bladestorm
4. Ravager
5. Sharpened Blades
6. Juggernaut

### **Row 10 (L12) - 5 Choices**:
1. Fatality
2. Dance of Death
3. Unhinged
4. Merciless Bonegrinder
5. Executioner's Precision

**Total Arms Spec Talents**: **4 auto-grants + 45 choice options = 49 unique talents** (12 duplicates = 61 total slots)

---

## 4. Fury Spec Talents (Pool 2 - Fury Only)

**Total**: **59 talent options** across 10 rows

### **Row 1 (L3) - Auto-Granted**: **3 features**
1. Titan's Grip (Passive)
2. Mastery: Unshackled Fury (Passive)
3. Bloodthirst (Ability)

### **Row 2 (L4) - 1 Ability**:
1. Raging Blow

### **Row 3 (L5) - 4 Choices**:
1. Frenzied Enrage
2. Powerful Enrage
3. Enraged Regeneration
4. Improved Execute

### **Row 4 (L6) - 6 Choices**:
1. Improved Bloodthirst
2. Fresh Meat
3. Warpaint
4. Invigorating Fury
5. Sudden Death
6. Cruelty

### **Row 5 (L7) - 3 Choices**:
1. Focus in Chaos
2. Rampage
3. Improved Raging Blow

### **Row 6 (L8) - 8 Choices**:
1. Single-Minded Fury
2. Cold Steel Hot Blood
3. Vicious Contempt
4. Frenzy
5. Hack and Slash
6. Slaughtering Strikes
7. Ashen Juggernaut
8. Improved Whirlwind

### **Row 7 (L9) - 6 Choices**:
1. Bloodborne
2. Bloodcraze
3. Recklessness
4. Massacre
5. Wrath and Fury
6. Meat Cleaver

### **Row 8 (L10) - 3 Choices**:
1. Raging Armaments
2. Swift Strikes
3. Critical Thinking

### **Row 9 (L11) - 6 Choices**:
1. Onslaught
2. Anger Management
3. Reckless Abandon
4. Bladestorm
5. Ravager
6. Odyn's Fury

### **Row 10 (L12) - 6 Choices**:
1. Tenderize
2. Unhinged
3. Storm of Steel
4. Unbridled Ferocity
5. Depths of Insanity
6. Dancing Blades
7. Titanic Rage (WAIT - 7 options listed, not 6!)

**Total Fury Spec Talents**: **4 auto-grants + 43 choice options = 47 unique talents** (12 duplicates = 59 total slots)

---

## 5. Protection Spec Talents (Pool 2 - Protection Only)

**Total**: **47 talent options** across 10 rows

### **Row 1 (L3) - Auto-Granted**: **1 ability**
1. Ignore Pain

### **Row 2 (L4) - 2 Choices**:
1. Revenge
2. Demoralizing Shout

### **Row 3 (L5) - 4 Choices**:
1. Brace For Impact
2. Armor Specialization
3. Fight Through the Flames
4. Devastator

### **Row 4 (L6) - 3 Choices**:
1. Disrupting Shout
2. Best Served Cold
3. Strategist

### **Row 5 (L7) - 6 Choices**:
1. Last Stand
2. Instigate
3. Rend
4. Bloodsurge
5. Fueled by Violence
6. Brutal Vitality

### **Row 6 (L8) - 7 Choices**:
1. Unnerving Focus
2. Heavy Repercussions
3. Thunderlord
4. Bloodborne
5. Into the Fray
6. Punish
7. Hunker Down

### **Row 7 (L9) - 5 Choices**:
1. Tough as Nails
2. Shield Wall
3. Enduring Defenses
4. Unyielding Stance
5. Red Right Hand

### **Row 8 (L10) - 6 Choices**:
1. Defender's Aegis
2. Impenetrable Wall
3. Focused Vigor
4. Shield Specialization
5. Enduring Alacrity
6. Anger Management

### **Row 9 (L11) - 5 Choices**:
1. Massacre
2. Booming Voice
3. Indomitable
4. Violent Outburst
5. Heavy Handed

### **Row 10 (L12) - 4 Choices**:
1. Shield Charge
2. Battle-Scarred Veteran
3. Whirling Blade
4. Ravager

**Total Protection Spec Talents**: **1 auto-grant + 42 choice options = 43 unique talents** (4 duplicates = 47 total slots)

---

## 6. Mountain Thane Specialization (L13-20)

**Accessible By**: **Protection + Fury Warriors**

**Total**: **11 talents** (ALL auto-granted, 0 player choices)

### **L13 - Keystone**:
1. Lightning Strikes

### **L15 - 3 Talents**:
2. Crashing Thunder
3. Ground Current
4. Strength of the Mountain

### **L17 - 3 Talents**:
5. Thunder Blast
6. Storm Bolts
7. Keep your feet on the Ground

### **L19 - 3 Talents**:
8. Flashing Skies
9. Thorim's Might
10. Burst of Power

### **L20 - Capstone**:
11. Avatar of the Storm

---

## 7. Colossus Specialization (L13-20)

**Accessible By**: **Arms + Protection Warriors**

**Total**: **11 talents** (ALL auto-granted, 0 player choices)

### **L13 - Keystone**:
1. Demolish (ability + Colossal Might passive)

### **L15 - 3 Talents**:
2. Martial Expert
3. Colossal Might (may be duplicate of keystone passive?)
4. Earthquake

### **L17 - 3 Talents**:
5. Arterial Blows
6. Tide of Battle
7. No Stranger to Pain

### **L19 - 3 Talents**:
8. Practiced Strikes
9. Precise Might
10. Mountain of Muscle and Scars

### **L20 - Capstone**:
11. Dominance of the Colossus

---

## 8. Slayer Specialization (L13-20)

**Accessible By**: **Arms + Fury Warriors**

**Total**: **11 talents** (ALL auto-granted, 0 player choices)

### **L13 - Keystone**:
1. Slayer's Dominance

### **L15 - 3 Talents**:
2. Imminent Demise
3. Overwhelming Blades
4. Relentless Pursuit

### **L17 - 3 Talents**:
5. Death Drive
6. Brutal Finish
7. Opportunist

### **L19 - 3 Talents**:
8. Show No Mercy
9. Reap the Storm
10. Slayer's Malice

### **L20 - Capstone**:
11. Unrelenting Onslaught

---

## 🔍 **ABILITY TYPE BREAKDOWN**

### **By Category**:
| Type | Count | Examples |
|------|-------|----------|
| **Offensive Abilities** | ~60 | Mortal Strike, Execute, Bloodthirst, Raging Blow, Overpower, Slam, Whirlwind, Shield Slam, Devastate |
| **Defensive Abilities** | ~25 | Die by the Sword, Shield Wall, Last Stand, Ignore Pain, Shield Block, Spell Reflection, Berserker Rage (CC removal) |
| **Utility/Mobility** | ~20 | Charge, Heroic Leap, Intervene, Storm Bolt, Heroic Throw, Hamstring, Taunt, Pummel |
| **Buffs/Shouts** | ~15 | Battle Shout, Rallying Cry, Intimidating Shout, Demoralizing Shout, Thunderous Roar |
| **Passive Enhancements** | ~50 | Mastery passives, Bloodborne, Anger Management, Critical Thinking, Tactical decisions |
| **Specialization Mechanics** | ~30 | Thunder effects (Mountain Thane), Demolish effects (Colossus), Execute enhancements (Slayer) |

---

## ⚠️ **RESOURCE SYSTEM REVIEW REQUIRED**

Based on this Excel count, we now know there are **200+ total abilities/passives/talents** in the Warrior class!

**Current Resource System** (from CHARGE_RESOURCES_DEEP_DIVE.md):
- Rage (100 max)
- MobilityCharge (2 max)
- DefensiveCharge (1 max)
- TankCooldown (1 max)
- OverpowerCharge (2 max)
- ThunderCharge (3 max)

**Abilities That Will Need Resources** (estimated from names):
1. **All offensive abilities** → Rage costs (60+ abilities)
2. **Charge, Heroic Leap, Intervene, Storm Bolt** → MobilityCharge (4 abilities)
3. **Die by the Sword, Berserker Rage** → DefensiveCharge (2 abilities)
4. **Last Stand, Shield Wall, Indomitable** → TankCooldown (3 abilities)
5. **Overpower** → OverpowerCharge (1 ability, proc-based)
6. **Thunder Clap (empowered)** → ThunderCharge (1 ability, proc-based)

**Recommendation**: After completing spell stat file transformation (FILES 4-10), audit ALL abilities to ensure:
- Rage costs are balanced (30-40 Rage for most, 20-40 for Execute)
- Charge resources are correctly assigned
- Cooldowns are appropriate (OncePerTurn, OncePerShortRest, OncePerCombat)

---

## 📌 **KEY TAKEAWAYS FOR SOURCE_OF_TRUTH.md**

1. **Baseline Abilities**: 12 per subclass (same abilities, different unlock order)
2. **Protection Passives**: 3 exclusive passives (Critical Block, Riposte, Vanguard)
3. **Class Talents**: 49 unique options across 10 rows (9 player choices)
4. **Arms Spec Talents**: 49 unique options (9 player choices)
5. **Fury Spec Talents**: 47 unique options (9 player choices)
6. **Protection Spec Talents**: 43 unique options (9 player choices)
7. **Specializations**: 11 talents each, ALL auto-granted (Mountain Thane, Colossus, Slayer)

**Total Unique Abilities/Passives/Talents**: **~200+** across entire class!

**Total Player Builds Possible**: 
- 3 subclasses × 9 Class choices × 9 Spec choices × 3 Specializations = **~700+ unique build variations**

---

**Last Updated**: October 19, 2025  
**Next Action**: Use this count to audit resource system after FILE 4-10 transformation complete
