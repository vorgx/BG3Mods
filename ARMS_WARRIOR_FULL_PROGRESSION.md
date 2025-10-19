# Arms Warrior - Complete Progression (Levels 1-20)

**Class**: Warrior  
**Subclass**: Arms (Two-Handed Weapon Specialist)  
**Resource**: Rage (0-100)  
**Primary Ability**: Strength  
**Hit Die**: d10  
**Saving Throws**: Strength, Constitution

---

## Level-by-Level Breakdown

### **Level 1** - Character Creation
**From Base Warrior Class:**
- ✅ **Proficiencies**: All armor, shields, simple & martial weapons
- ✅ **Saving Throws**: Strength, Constitution
- ✅ **Rage Resource**: 100 max Rage, starts at 0
- ✅ **Passives**: 
  - `WAR_UnlockRage` - Unlocks Rage resource
  - `WAR_RageGeneration` - Generate Rage through combat
- ✅ **Abilities**:
  - `WAR_Charge` - Gap closer, generates Rage
  - `WAR_HeroicStrike` - Basic Rage spender
- ✅ **Skill Choices**: Pick 2 from Warrior skill list
- ✅ **Ability Score Improvement**: +2 points to distribute

**From Arms Subclass (chosen at creation):**
- ✅ **Passive**: `WAR_ARMS_WeaponMastery` - +1 attack/damage with two-handed weapons

**Summary**: Core warrior with Rage system + two-handed weapon specialization bonus

---

### **Level 2** - Battle Shout
**From Base Warrior:**
- ✅ **Ability**: `WAR_BattleShout` - Party-wide buff

**Summary**: Add utility/support ability

---

### **Level 3** - Execute + Arms Signature Abilities
**From Base Warrior:**
- ✅ **Ability**: `WAR_Execute` - Execute enemies below 20% HP (20 Rage)

**From Arms Subclass:**
- ✅ **Ability**: `WAR_ARMS_MortalStrike` - Signature Arms attack with healing reduction
- ✅ **Ability**: `WAR_ARMS_Overpower` - Powerful single-target strike

**Summary**: Get your subclass identity - two-handed burst damage with Mortal Strike

---

### **Level 4** - Feat
**From Base Warrior:**
- ✅ **Feat Choice**: Standard D&D 5e feat or Ability Score Improvement

**Summary**: Character customization (Great Weapon Master recommended for Arms)

---

### **Level 5** - Extra Attack
**From Base Warrior:**
- ✅ **Passive**: `ExtraAttack` - Attack twice per action

**From Arms Subclass:**
- ✅ **Passive**: `WAR_ARMS_TacticalMastery` - Tactical combat enhancements

**Summary**: Major power spike - double attacks + tactical improvements

---

### **Level 6** - Defensive Stance
**From Base Warrior:**
- ✅ **Ability**: `WAR_DefensiveStance` - Defensive toggle ability

**Summary**: Add survivability option

---

### **Level 7** - Intimidating Shout + Colossus Smash
**From Base Warrior:**
- ✅ **Ability**: `WAR_IntimidatingShout` - AoE fear/debuff

**From Arms Subclass:**
- ✅ **Ability**: `WAR_ARMS_ColossusSmash` - Armor-shredding strike (signature Arms finisher)

**Summary**: Get your armor penetration ability - core Arms mechanic

---

### **Level 8** - Feat
**From Base Warrior:**
- ✅ **Feat Choice**: Second feat or ASI

**Summary**: Further customization

---

### **Level 9** - Heroic Leap + Sweeping Strikes
**From Base Warrior:**
- ✅ **Ability**: `WAR_HeroicLeap` - AoE gap closer/escape

**From Arms Subclass:**
- ✅ **Ability**: `WAR_ARMS_SweepingStrikes` - Cleave multiple targets

**Summary**: Add AoE damage capability for multi-target fights

---

### **Level 10** - Rallying Cry
**From Base Warrior:**
- ✅ **Ability**: `WAR_RallyingCry` - Party-wide emergency heal

**Summary**: Utility cooldown for party support

---

### **Level 11** - Improved Extra Attack + Warbreaker
**From Base Warrior:**
- ✅ **Passive**: `ImprovedExtraAttack` - Attack 3 times per action (replaces Extra Attack)

**From Arms Subclass:**
- ✅ **Ability**: `WAR_ARMS_Warbreaker` - Powerful AoE finisher

**Summary**: Massive damage increase - triple attacks + AoE burst

---

### **Level 12** - Feat
**From Base Warrior:**
- ✅ **Feat Choice**: Third feat or ASI

**Summary**: More customization

---

### **Level 13** - Inspiring Presence + Hero Talent Choice ⚠️
**From Base Warrior:**
- ✅ **Passive**: `WAR_InspiringPresence` - Leadership aura

**From Arms Subclass - MAJOR CHOICE:**
Choose your specialization path (Hero Talent Tree):

#### **Option A: Colossus** (Tank/Sustained Damage)
- ✅ **Keystone Passive**: `WAR_Colossus_Keystone`
  - Unlocks `WAR_Demolish` ability
  - Passives trigger on Shield Slam casts
  - Focus: Defense, crowd control, sustained damage

#### **Option B: Slayer** (Burst Damage/Execute)
- ✅ **Keystone Passive**: `WAR_Slayer_Keystone`
  - Unlocks `WAR_Slaughterhouse` passive
  - Execute-focused playstyle
  - Focus: Burst damage, execute mechanics, aggression

**⚠️ THIS CHOICE IS PERMANENT** - Cannot be changed later!

**Summary**: Define your playstyle for levels 13-20

---

### **Level 14** - Hamstring
**From Base Warrior:**
- ✅ **Ability**: `WAR_Hamstring` - Slow/immobilize enemy

**Summary**: Utility ability for kiting/control

---

### **Level 15** - Spell Reflection + Hero Talent Tier 1 ⚠️
**From Base Warrior:**
- ✅ **Ability**: `WAR_SpellReflection` - Reflect spells back at casters

**From Arms Subclass - Choice depends on Level 13 selection:**

#### **If you chose Colossus at L13:**
Pick **1** of these passives:
1. ✅ `WAR_Colossus_NoStrangerToPain` - Damage reduction improvements
2. ✅ `WAR_Colossus_VeteranVitality` - Healing/sustain improvements
3. ✅ `WAR_Colossus_OneAgainstMany` - AoE damage improvements

#### **If you chose Slayer at L13:**
Pick **1** of these passives:
1. ✅ `WAR_Slayer_BrutalFinish` - Execute damage boost
2. ✅ `WAR_Slayer_ImminentDemise` - Mortal Strike improvements
3. ✅ `WAR_Slayer_OverwhelmingBlades` - Multi-target enhancements

**Summary**: First customization within your hero talent tree

---

### **Level 16** - Feat
**From Base Warrior:**
- ✅ **Feat Choice**: Fourth feat or ASI

**Summary**: More customization

---

### **Level 17** - Die by the Sword + Hero Talent Tier 2 ⚠️
**From Base Warrior:**
- ✅ **Ability**: `WAR_DiebytheSword` - Defensive cooldown (parry)

**From Arms Subclass - Choice depends on Level 13 selection:**

#### **If you chose Colossus at L13:**
Pick **1** of these passives:
1. ✅ `WAR_Colossus_PracticedStrikes` - Attack speed/efficiency
2. ✅ `WAR_Colossus_ArterialBleed` - Bleed damage enhancements
3. ✅ `WAR_Colossus_Earthquaker` - Ground slam improvements

#### **If you chose Slayer at L13:**
Pick **1** of these passives:
1. ✅ `WAR_Slayer_CullingCyclone` - Whirlwind improvements
2. ✅ `WAR_Slayer_Opportunist` - Critical strike bonuses
3. ✅ `WAR_Slayer_OverwhelmingBlades2` - Advanced cleave mechanics

**Summary**: Second tier of hero talent customization

---

### **Level 18** - Indomitable
**From Base Warrior:**
- ✅ **Ability**: `Target_WAR_Indomitable` - Advantage on saves + 1d4 bonus (1 turn, once per short rest)

**Summary**: Powerful defensive utility

---

### **Level 19** - Avatar + Hero Talent Tier 3 ⚠️
**From Base Warrior:**
- ✅ **Ability**: `WAR_Avatar` - Ultimate transformation cooldown

**From Arms Subclass - Choice depends on Level 13 selection:**

#### **If you chose Colossus at L13:**
Pick **1** of these passives:
1. ✅ `WAR_Colossus_MartialExpert` - Weapon mastery bonuses
2. ✅ `WAR_Colossus_TideOfBattle` - Combat flow improvements
3. ✅ `WAR_Colossus_DemolishShockwave` - Enhanced Demolish/Shockwave synergy

#### **If you chose Slayer at L13:**
Pick **1** of these passives:
1. ✅ `WAR_Slayer_ShowNoMercy` - Execute improvements
2. ✅ `WAR_Slayer_ReapTheStorm` - Whirlwind synergy
3. ✅ `WAR_Slayer_ImminentDemise2` - Advanced Mortal Strike mechanics

**Summary**: Final hero talent choice + ultimate ability

---

### **Level 20** - Feat + Hero Talent Capstone (Automatic)
**From Base Warrior:**
- ✅ **Feat Choice**: Fifth feat or ASI

**From Arms Subclass - Automatic based on Level 13 choice:**

#### **If you chose Colossus at L13:**
- ✅ **Auto-Granted Status**: `WAR_Colossus_PreciseMight`
  - Permanent capstone buff
  - Enhances all Colossus mechanics
  - No choice required

#### **If you chose Slayer at L13:**
- ✅ **Auto-Granted Status**: `WAR_Slayer_Malice`
  - Permanent capstone buff
  - Enhances all Slayer mechanics
  - No choice required

**Summary**: Maximum power - final feat + automatic capstone passive

---

## Complete Ability List (Arms Warrior at Level 20)

### **Core Warrior Abilities (All Specializations Get These)**
1. `WAR_Charge` - Gap closer (L1)
2. `WAR_HeroicStrike` - Basic Rage spender (L1)
3. `WAR_BattleShout` - Party buff (L2)
4. `WAR_Execute` - Execute <20% HP (L3)
5. `WAR_DefensiveStance` - Defensive toggle (L6)
6. `WAR_IntimidatingShout` - AoE fear (L7)
7. `WAR_HeroicLeap` - AoE gap closer (L9)
8. `WAR_RallyingCry` - Party heal (L10)
9. `WAR_Hamstring` - Slow enemy (L14)
10. `WAR_SpellReflection` - Reflect spells (L15)
11. `WAR_DiebytheSword` - Parry (L17)
12. `Target_WAR_Indomitable` - Save advantage (L18)
13. `WAR_Avatar` - Ultimate form (L19)

### **Arms-Specific Abilities**
14. `WAR_ARMS_MortalStrike` - Signature strike with healing reduction (L3)
15. `WAR_ARMS_Overpower` - Powerful attack (L3)
16. `WAR_ARMS_ColossusSmash` - Armor shred (L7)
17. `WAR_ARMS_SweepingStrikes` - Cleave (L9)
18. `WAR_ARMS_Warbreaker` - AoE finisher (L11)

### **Hero Talent Abilities (Depends on L13 Choice)**
**If Colossus:**
19. `WAR_Demolish` - Unlocked by Colossus Keystone (L13)

**If Slayer:**
19. `WAR_Slaughterhouse` - Unlocked by Slayer Keystone (L13)

### **Passives (Always Active)**
- `WAR_UnlockRage` - Rage resource unlocked
- `WAR_RageGeneration` - Generate Rage in combat
- `WAR_ARMS_WeaponMastery` - +1 attack/damage with 2H weapons (L1)
- `WAR_ARMS_TacticalMastery` - Tactical combat bonuses (L5)
- `ExtraAttack` → `ImprovedExtraAttack` - 3 attacks per action (L11)
- `WAR_InspiringPresence` - Leadership aura (L13)
- **3 Hero Talent Passives** (chosen at L15, L17, L19)
- **1 Hero Talent Capstone** (automatic at L20)

---

## Major Decision Points Summary

### **Level 1 (Character Creation)**
- ✅ Choose 2 skills
- ✅ Distribute +2 ability points
- ✅ Choose Arms as subclass

### **Level 4, 8, 12, 16, 20**
- ✅ Feat or Ability Score Improvement (5 total)

### **Level 13** ⚠️ **CRITICAL CHOICE**
- ✅ Choose Colossus (tank/sustained) OR Slayer (burst/execute)
- ⚠️ **PERMANENT** - defines playstyle for L13-20

### **Level 15**
- ✅ Choose 1 of 3 Tier 1 passives (based on L13 choice)

### **Level 17**
- ✅ Choose 1 of 3 Tier 2 passives (based on L13 choice)

### **Level 19**
- ✅ Choose 1 of 3 Tier 3 passives (based on L13 choice)

### **Level 20**
- ✅ Automatic capstone passive (based on L13 choice)
- ✅ Final feat choice

---

## Build Recommendations

### **Colossus Build (Tank/Controller)**
**Playstyle**: Sustained damage, crowd control, survivability  
**Key Levels**: 13 (Demolish), 15-20 (defensive passives)  
**Recommended Stats**: STR > CON > DEX  
**Recommended Feats**: Sentinel, Tough, Heavy Armor Master  
**Best For**: Frontline tank, party protector, raid bosses

### **Slayer Build (Burst DPS)**
**Playstyle**: Execute windows, burst damage, aggressive  
**Key Levels**: 13 (Slaughterhouse), 15-20 (offensive passives)  
**Recommended Stats**: STR > DEX > CON  
**Recommended Feats**: Great Weapon Master, Savage Attacker, Mobile  
**Best For**: Boss killer, execute phase specialist, speed runs

---

## Rage Management Tips

**Rage Generation:**
- Hitting enemies generates Rage
- Critical hits generate bonus Rage
- Taking damage generates Rage
- `WAR_RageGeneration` passive handles this automatically

**Rage Spending:**
- Most powerful abilities cost 20-40 Rage
- Execute costs 20 Rage
- Mortal Strike costs Rage
- Hero talents may modify costs

**Recommended Rotation:**
1. Generate Rage with basic attacks/Charge
2. Spend on Mortal Strike/Colossus Smash
3. Save 20 Rage for Execute windows
4. Use Avatar when at high Rage for burst

---

## Frequently Asked Questions

**Q: Can I change my Level 13 hero talent choice?**  
A: No, it's permanent. Choose carefully based on your preferred playstyle.

**Q: What's the difference between Colossus and Slayer?**  
A: Colossus = tank/sustained damage/CC. Slayer = burst damage/execute focus/aggression.

**Q: Do I get all the hero talent passives?**  
A: No, you choose 1 passive from each tier (L15, L17, L19) for a total of 3 chosen + 1 automatic capstone.

**Q: Can Arms use shields?**  
A: Yes, you're proficient, but Weapon Mastery only buffs two-handed weapons.

**Q: How many attacks do I get at max level?**  
A: 3 attacks per action (Improved Extra Attack at L11).

**Q: What's the best feat for Arms?**  
A: Great Weapon Master (offense) or Sentinel (defense) are top picks.

---

**Document Version**: 1.0  
**Last Updated**: October 17, 2025  
**Mod Version**: v1.0.1.0 (100% complete)  
**Game Version**: Baldur's Gate 3 Patch 8 (v4.8.0.10+)
