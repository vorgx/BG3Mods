# Warrior Specializations - Complete Reference
**Date:** October 16, 2025  
**Status:** 📋 **DEFINED - READY FOR IMPLEMENTATION**

---

## 🎯 SPECIALIZATION SYSTEM OVERVIEW

### **Structure:**
```
Level 13: Choose ONE Specialization → Grants Keystone Ability/Passive
Level 15: Choose ONE Tier 1 Talent (3 options)
Level 17: Choose ONE Tier 2 Talent (3 options)
Level 19: Choose ONE Tier 3 Talent (3 options)
Level 20: Receive Capstone (automatic based on L13 choice)
```

### **Available Specializations Per Subclass:**

| Subclass | Specialization 1 | Specialization 2 |
|----------|-----------------|-----------------|
| **Arms** | Colossus | Slayer |
| **Fury** | Mountain Thane | Slayer |
| **Protection** | Mountain Thane | Colossus |

---

## ⚔️ ARMS WARRIOR SPECIALIZATIONS

### **COLOSSUS (Arms)**

#### **Level 13: Keystone (Automatic)**
**Demolish + Colossal Might**

**Demolish (New Ability)**
- **Type**: Action
- **Target**: Single enemy, melee range
- **Damage**: 3 rapid strikes of 3d10 + Strength modifier each
- **Cost**: 40 Rage
- **Effect**: Consumes all Colossal Might stacks for +10% damage per stack consumed
- **Recharge**: Short Rest
- **Tags**: MeleeWeapon, MultiHit, Finisher

**Colossal Might (Passive Stacking Buff)**
- **Max Stacks**: 5
- **Duration**: Until consumed by Demolish or 60 seconds out of combat
- **Grant Sources**:
  - Shield Slam: +1 stack
  - Execute: +1 stack
  - Revenge (if hits 3+ targets): +1 stack
- **Effect per Stack**: +10% Demolish damage (max +50% at 5 stacks)
- **Visual**: Growing orange/red aura around character

**Tooltip:**
```
Colossus Specialization

You become a devastating force on the battlefield, building Colossal Might through your core attacks and unleashing it with Demolish.

Grants: Demolish ability and Colossal Might passive

Unlocks Colossus talent choices at levels 15, 17, and 19, culminating in a capstone at level 20.

WARNING: Choosing this specialization locks you out of Slayer talents.
```

---

#### **Level 15: Tier 1 Choice** (Pick ONE)

**1. No Stranger to Pain** ✅ RECOMMENDED
- **Type**: Passive
- **Effect**: Ignore Pain damage prevention increased by +20%
- **Synergy**: Tank foundation, allows aggressive Colossal Might stacking
- **Build**: Defensive baseline

**2. Veteran Vitality**
- **Type**: Passive
- **Effect**: 
  - When HP drops below 35%, automatically heal for 15% max HP over 2 turns (7.5% per turn)
  - Gain temporary HP equal to 10% of damage dealt by Demolish
  - Cooldown: 90 seconds (out-of-combat timer)
- **Synergy**: Safety net for risky Demolish positioning, self-sustain for burst windows
- **Build**: Solo play survivability, high-risk aggressive tank

**3. One Against Many**
- **Type**: Passive
- **Effect**: 
  - Shockwave, Revenge, and Whirlwind deal +5% damage per target affected (max +25% at 5 targets)
  - When hitting 4+ targets with these abilities, gain 1 Colossal Might stack
- **Synergy**: AoE specialist, generates stacks from multi-target scenarios, scales better than recommended path in mass combat
- **Build**: Multi-target encounters, dungeon crawler

---

#### **Level 17: Tier 2 Choice** (Pick ONE)

**1. Practiced Strikes** ✅ RECOMMENDED
- **Type**: Passive
- **Effect**: 
  - Shield Slam damage +10%
  - Revenge damage +10%
  - Shield Slam generates +3 Rage
- **Synergy**: Enhances Colossal Might builders, faster stack generation, more Rage for Demolish
- **Build**: Core rotation enhancement

**2. Arterial Bleed**
- **Type**: Passive
- **Effect**: 
  - Melee attacks that deal Slashing damage have 30% chance to apply **Bleeding** (3 turns)
  - Bleeding: 1d6 Slashing damage per turn
  - Bleeding damage increased by +5% per Colossal Might stack (max +25%)
  - Demolish applies Bleeding to target (guaranteed)
- **Synergy**: DoT-focused build, stacks enhance bleed damage, Demolish guaranteed bleed proc
- **Build**: Sustained damage specialist, melee weapons with Slashing damage
- **Note**: Uses BG3's existing Bleeding condition

**3. Earthquaker**
- **Type**: Passive
- **Effect**: 
  - Shockwave knocks enemies **Prone** (DEX save or fall prone, lose movement)
  - Shockwave cooldown reduced by 1 turn
  - When Shockwave hits 3+ enemies, generate +5 Rage
- **Synergy**: CC specialist, more frequent AoE stuns + prone, Rage generation for Demolish
- **Build**: Control-focused tank, mass CC enabler

---

#### **Level 19: Tier 3 Choice** (Pick ONE)

**1. Martial Expert** ✅ RECOMMENDED
- **Type**: Passive
- **Effect**: Revenge damage increased by +7% per Colossal Might stack (max +35% at 5 stacks)
- **Synergy**: THE key synergy node
  - Build stacks → Revenge scales massively → Demolish consumes for burst
  - At 5 stacks: Revenge +35% damage, then Demolish deals 3×3d10×1.5 = massive burst
- **Build**: Stack-and-burst gameplay loop

**2. Tide of Battle**
- **Type**: Passive
- **Effect**: 
  - Revenge damage increased by +7% per Colossal Might stack (max +35% at 5 stacks) - SAME as Martial Expert
  - Additionally: Revenge cooldown reduced by 1 turn
- **Synergy**: Same damage scaling as Martial Expert but with faster Revenge usage
- **Build**: Revenge-spam build, faster stack generation via more frequent Revenge casts
- **Note**: Trade-off - Martial Expert for burst windows, Tide of Battle for sustained rotation

**3. Demolish: Shockwave**
- **Type**: Passive
- **Effect**:
  - Demolish cooldown reduced by 1 turn
  - After using Demolish, next Shockwave has +3m range and stuns for 1 additional turn
  - Shockwave generates +1 Colossal Might stack after using Demolish
- **Synergy**: More frequent Demolish use, AoE combo system (Demolish → empowered Shockwave → rebuild stacks)
- **Build**: Demolish-focused DPS with CC synergy, combo rotation specialist

---

#### **Level 20: Capstone (Automatic)**
**Precise Might**

- **Type**: Passive
- **Effect**: +2% critical hit chance per Colossal Might stack (max +10% at 5 stacks)
- **Synergy**: Stacks amplify everything
  - 5 stacks = +35% Revenge damage (Martial Expert) + +10% crit chance + +50% Demolish damage
- **Build**: Ultimate scaling payoff

---

#### **Colossus Build Path Summary**
```
L13: Demolish + Colossal Might (Keystone)
  ↓ [Build stack mechanic]
L15: No Stranger to Pain (+20% Ignore Pain)
  ↓ [Tank foundation for aggressive stacking]
L17: Practiced Strikes (+10% Shield Slam/Revenge, +3 Rage)
  ↓ [Build stacks faster, more Rage for Demolish]
L19: Martial Expert (+7% Revenge per stack = +35% at max)
  ↓ [Stacks empower Revenge massively]
L20: Precise Might (+2% crit per stack = +10% at max)
  ↓ [ULTIMATE: 5 stacks = +35% Revenge, +50% Demolish, +10% crit]
```

**Gameplay Loop:**
1. Shield Slam → +1 stack, generates Rage
2. Revenge (vs 3+ targets) → +1 stack, deals +7% damage per stack
3. Execute (low HP enemy) → +1 stack
4. Repeat until 5 stacks
5. Demolish → Consume all stacks for 3×3d10×1.5 damage (450% weapon damage + 15d10)
6. Rebuild stacks

---

### **SLAYER (Arms)**

#### **Level 13: Keystone (Automatic)**
**Slayer's Dominance**

- **Type**: Passive (Proc-based)
- **Trigger**: 15% chance on melee attack hit
- **Effect**: 
  - Deal 2d8 bonus damage (Slashing)
  - Apply **Marked for Execution** status to target (4 turns)
- **Marked for Execution Status**:
  - Target takes +10% damage from Execute
  - Target takes +1d6 damage from all your attacks
  - Visual: Red skull icon above target
  - Does NOT stack (reapplying refreshes duration)

**Tooltip:**
```
Slayer Specialization

You become an executioner, marking enemies for death and exploiting their weaknesses with devastating precision.

Grants: Slayer's Dominance - 15% chance on hit to mark targets for execution

Unlocks Slayer talent choices at levels 15, 17, and 19, culminating in a capstone at level 20.

WARNING: Choosing this specialization locks you out of Colossus talents.
```

---

#### **Level 15: Tier 1 Choice** (Pick ONE)

**1. Brutal Finish** ✅ RECOMMENDED
- **Type**: Passive
- **Effect**: Execute deals +50% damage against Marked for Execution targets
- **Synergy**: Defines Slayer identity - mark enemies, Execute them for massive damage
- **Math**: Execute base 4d12 → 6d12 vs Marked targets
- **Build**: Execute specialist, priority target elimination

**2. Imminent Demise**
- **Type**: Passive
- **Effect**: 
  - Mortal Strike deals +30% damage against Marked for Execution targets
  - Mortal Strike applies **Healing Reduction** (-50% healing received, 3 turns) to Marked targets
- **Synergy**: Mortal Strike-focused build, anti-heal utility for boss fights
- **Build**: Arms signature ability enhancement, Execute alternative damage path
- **Note**: Uses BG3's existing Healing Reduction mechanic (like Mortal Strike in WoW)

**3. Overwhelming Blades**
- **Type**: Passive
- **Effect**: 
  - When you apply Marked for Execution, it spreads to 1 additional nearby enemy within 4m (up from 3m)
  - When you Execute a Marked target, gain **Blood Frenzy** (2 turns): +2 melee damage, +10% movement speed
- **Synergy**: Multi-target marking, Execute rewards mobility and damage
- **Build**: Cleave specialist, Execute resets enable chain kills

---

#### **Level 17: Tier 2 Choice** (Pick ONE)

**1. Culling Cyclone** ✅ RECOMMENDED
- **Type**: Passive
- **Effect**: Whirlwind deals +1d6 damage per Marked for Execution enemy hit
- **Synergy**: Bridges single-target (Execute) with AoE
  - Mark multiple enemies (Slayer's Dominance procs or Overwhelming Blades)
  - Whirlwind hits all marked enemies for bonus damage
- **Build**: AoE/cleave synergy with Mark system

**2. Opportunist**
- **Type**: Passive
- **Effect**: 
  - Attacks against Marked for Execution targets have **Advantage**
  - When you critically hit a Marked target, reduce Execute cooldown by 1 turn
- **Synergy**: Crit fishing enables Execute spam, Advantage increases crit rate
- **Build**: Crit-focused Execute machine, synergizes with Show No Mercy (19-20 crit range)
- **Note**: Pure synergy with Slayer's crit-scaling identity

**3. Overwhelming Blades** (if not picked at L15)
- **Type**: Passive
- **Effect**: Mark spreading (same as L15 option)
- **Synergy**: Second chance to pick if you chose Brutal Finish at L15

---

#### **Level 19: Tier 3 Choice** (Pick ONE)

**1. Show No Mercy** ✅ RECOMMENDED
- **Type**: Passive
- **Effect**: Critical hit range increased by 1 (19-20 instead of 20) against Marked for Execution targets
- **Math**: 10% crit chance increase on Marked targets
- **Synergy**: More crits = more Execute opportunities (enemies drop to low HP faster)
- **Build**: Crit-focused Execute machine

**2. Reap the Storm**
- **Type**: Passive
- **Effect**: 
  - When you hit 3+ enemies with Whirlwind or Revenge, apply **Overwhelmed** status on all targets (3 turns)
  - Overwhelmed: Target takes +8% damage from you (up from +5%)
  - Overwhelmed stacks with Marked for Execution
- **Synergy**: Multi-target encounters, stacks with Marked for Execution (+10% Execute + +1d6 + +8% Overwhelmed = +18% total + 1d6)
- **Build**: AoE damage amplification, mass debuff applicator

**3. Imminent Demise** (if not picked at L15)
- **Type**: Passive
- **Effect**: 
  - Mortal Strike deals +30% damage against Marked for Execution targets
  - Mortal Strike applies Healing Reduction (-50% healing received, 3 turns) to Marked targets
- **Synergy**: Second chance if you skipped it earlier, anti-heal utility
- **Build**: Mortal Strike specialist

---

#### **Level 20: Capstone (Automatic)**
**Slayer's Malice**

- **Type**: Passive
- **Effect**:
  - Raging Blow deals +30% damage
  - Raging Blow has +10% chance to apply Marked for Execution
- **Synergy**: Turns Raging Blow into a Mark engine
  - Base 15% chance (Slayer's Dominance) + 10% (Slayer's Malice) = 25% total Mark chance
  - Raging Blow hits frequently → constant Mark uptime
- **Build**: Mark application machine, Execute/crit engine

---

#### **Slayer Build Path Summary**
```
L13: Slayer's Dominance (15% chance to Mark on hit)
  ↓ [Mark for Execution system established]
L15: Brutal Finish (Execute +50% vs Marked)
  ↓ [Execute becomes primary finisher]
L17: Culling Cyclone (Whirlwind +1d6 per Marked enemy)
  ↓ [AoE synergy with Mark system]
L19: Show No Mercy (Crit range 19-20 vs Marked = +10% crit)
  ↓ [More crits = more low-HP targets for Execute]
L20: Slayer's Malice (Raging Blow +30% damage, +10% Mark chance)
  ↓ [ULTIMATE: 25% total Mark chance, Execute +50%, crit 19-20]
```

**Gameplay Loop:**
1. Attack enemies → 15-25% chance to Mark for Execution
2. Execute Marked targets → +50% damage (6d12 instead of 4d12)
3. Whirlwind multiple Marked enemies → +1d6 per target
4. Crits more often (19-20 range) → enemies drop to Execute threshold faster
5. Raging Blow applies Marks → constant uptime
6. Repeat with near-permanent Mark coverage

---

## 🔥 FURY WARRIOR SPECIALIZATIONS

### **MOUNTAIN THANE (Fury)**

#### **Level 13: Keystone (Automatic)**
**Avatar of the Storm**

- **Type**: Passive Enhancement (modifies Avatar ability)
- **Effect**: When you activate Avatar, gain **Avatar of the Storm** status:
  - Duration: Same as Avatar (depends on Avatar implementation, typically 6-10 turns)
  - Every turn while active: Deal 1d8 Lightning damage to all enemies within 3m
  - Lightning bursts occur at start of your turn
  - Damage ignores resistance (Lightning damage type)
- **Visual**: Lightning crackling around character, periodic AoE bursts
- **Synergy**: Avatar becomes offensive zone control ability

**Tooltip:**
```
Mountain Thane Specialization

You channel the fury of the storm, becoming a lightning-wreathed warrior whose Avatar pulses with destructive energy.

Grants: Avatar of the Storm - Avatar gains lightning burst damage

Unlocks Mountain Thane talent choices at levels 15, 17, and 19, culminating in a capstone at level 20.

WARNING: Choosing this specialization locks you out of Slayer talents.
```

---

#### **Level 15: Tier 1 Choice** (Pick ONE)

**1. Lightning Strikes** ✅ RECOMMENDED
- **Type**: Passive (Proc-based)
- **Trigger**: Thunder Clap, Revenge, or Execute
- **Effect**: 25% chance to strike one enemy with lightning bolt (1d10 Lightning damage)
  - Occurs 30% more often during Avatar (32.5% chance)
- **Synergy**: Core proc mechanic, frequent lightning triggers
- **Build**: Lightning theme foundation

**2. Burst of Power**
- **Type**: Passive (Proc-based)
- **Trigger**: Lightning Strikes (25% of those procs → 6.25% overall)
- **Effect**: 
  - Gain **Burst of Power** (2 turns): Next 2 Shield Slams cost no Action (Bonus Action instead)
  - Shield Slams during Burst of Power generate +2 Rage each
- **Synergy**: Chaining procs (Lightning → free Shield Slams → more Rage for big spenders)
- **Build**: Shield Slam spam during proc windows, explosive burst rotation
- **Note**: High skill ceiling - maximize value during proc window

**3. Crashing Thunder**
- **Type**: Passive
- **Trigger**: Whirlwind or Revenge hits 3+ enemies
- **Effect**: 
  - Hit all targets 1 additional time for 40% weapon damage (up from 30%)
  - Generate +3 Rage when this effect triggers
  - Additional hits can proc Lightning Strikes (25% chance each)
- **Synergy**: AoE damage amplification, Rage generation, proc multiplication
- **Build**: Multi-target specialist, maximizes value in mass combat

---

#### **Level 17: Tier 2 Choice** (Pick ONE)

**1. Thunder Blast** ✅ RECOMMENDED
- **Type**: Passive (Proc-based + Enhancement)
- **Trigger**: Shield Slam (35% chance)
- **Effect**: Gain Thunder Blast charges (stacks up to 2)
- **Thunder Blast Mechanic**:
  - Replaces next Thunder Clap with empowered version
  - Thunder Clap damage +40%
  - Generates +2 Rage
  - Visual: Blue lightning effect instead of normal Thunder Clap
- **Synergy**: Proc chain system
  - Lightning Strikes procs → Thunder Blast charges → Empowered Thunder Clap → More Lightning Strikes chances
- **Build**: Offensive proc engine

**2. Ground Current**
- **Type**: Passive
- **Effect**: 
  - When you deal Lightning damage, it chains to 1 additional nearby enemy within 5m (60% damage, up from 50%)
  - Chained lightning can proc Lightning Strikes (25% chance)
  - Avatar of the Storm lightning bursts can chain
- **Synergy**: Lightning Strikes spread, Avatar of the Storm spreads, Thunder Blast spreads, proc chain multiplication
- **Build**: Lightning AoE specialist, maximizes storm coverage

**3. Thorim's Might**
- **Type**: Passive (Conditional)
- **Trigger**: While Avatar is active
- **Effect**: 
  - +4 Strength (affects attack rolls and damage)
  - +2 AC (storm aura deflects attacks)
  - Lightning damage you deal ignores resistance
- **Math**: +2 to attack rolls, +2 to damage rolls (all melee attacks), better survivability
- **Synergy**: Universal damage increase during Avatar, defensive boost, resistance bypass
- **Build**: Simple power spike during Avatar windows, no proc management needed

---

#### **Level 19: Tier 3 Choice** (Pick ONE)

**1. Strength of the Mountain** ✅ RECOMMENDED
- **Type**: Passive
- **Effect**:
  - Shield Slam damage +15%
  - Demoralizing Shout reduces enemy damage by additional -5%
- **Synergy**: Bridges offense (Shield Slam) with ultimate (Gathering Storms)
  - Thunder Blast procs → Empowered Thunder Clap → Lightning Strikes → Execute/Revenge benefit from capstone
- **Build**: Final damage amp before capstone

**2. Keep Your Feet on the Ground**
- **Type**: Passive
- **Effect**:
  - Physical damage reduction: -3% (up from -2%, permanent)
  - Thunder Blast reduces physical damage you take by -10% (up from -8%) for 5 turns
  - Cannot be knocked Prone while Thunder Blast damage reduction is active
- **Synergy**: Defensive layer tied to Thunder Blast procs, immunity to prone during defensive window
- **Build**: Tank survivability with proc-based DR, anti-CC utility

**3. Steadfast as the Peaks**
- **Type**: Passive
- **Effect**:
  - +8% maximum HP (up from +5%, permanent)
  - When you drop below 50% HP, gain **Steadfast** (until end of combat):
    - +2 to all Saving Throws
    - Heal for 2% max HP at the start of each of your turns
    - +1 AC
- **Synergy**: HP scaling with defensive comeback mechanic when bloodied
- **Build**: Survivability specialist, last-stand tank
- **Note**: Uses BG3's existing HP percentage trigger mechanics (like Relentless Endurance)

---

#### **Level 20: Capstone (Automatic)**
**Gathering Storms**

- **Type**: Passive
- **Effect**:
  - Lightning Strikes generate +3 Rage per proc
  - Revenge damage +25%
  - Execute damage +25%
- **Synergy**: Lightning procs fuel Rage economy, major finisher damage boost
- **Math Example**:
  - Lightning Strikes proc 25% of the time on Thunder Clap/Revenge/Execute
  - Each proc: 1d10 Lightning + 3 Rage
  - Over 10 ability uses: ~2.5 procs = 7.5 Rage generated
  - Revenge and Execute hit 25% harder
- **Build**: Ultimate storm warrior - lightning fuels Rage, finishers devastate

---

#### **Mountain Thane Build Path Summary (Fury)**
```
L13: Avatar of the Storm (1d8 Lightning/turn to 3m during Avatar)
  ↓ [Storm theme established]
L15: Lightning Strikes (25% chance on abilities → 1d10 Lightning)
  ↓ [Proc system foundation]
L17: Thunder Blast (Shield Slam 35% → Thunder Blast charges)
  ↓ [Proc chain: Shield Slam → Thunder Blast → Empowered Thunder Clap]
L19: Strength of the Mountain (Shield Slam +15%, Shout -5% enemy damage)
  ↓ [Final damage amp]
L20: Gathering Storms (Lightning Strikes +3 Rage, Revenge/Execute +25%)
  ↓ [ULTIMATE: Lightning economy, finisher devastation]
```

**Gameplay Loop:**
1. Activate Avatar → 1d8 Lightning/turn to nearby enemies
2. Use Thunder Clap/Revenge/Execute → 25% chance for Lightning Strikes (1d10 + 3 Rage at L20)
3. Shield Slam → 35% chance for Thunder Blast charge
4. Thunder Clap with Thunder Blast → +40% damage, +2 Rage, triggers more Lightning Strikes
5. Revenge/Execute → +25% damage from capstone
6. Repeat with Avatar uptime maximized

---

### **SLAYER (Fury)**

*[Same as Arms Slayer - talents are identical across specs]*

#### **Level 13: Keystone (Automatic)**
**Slayer's Dominance**
- 15% chance on melee hit: 2d8 bonus damage + Marked for Execution (4 turns)
- Marked targets: +10% Execute damage, +1d6 from your attacks

#### **Level 15: Tier 1 - Brutal Finish** ✅
- Execute +50% damage vs Marked (4d12 → 6d12)

#### **Level 17: Tier 2 - Culling Cyclone** ✅
- Whirlwind +1d6 per Marked enemy hit

#### **Level 19: Tier 3 - Show No Mercy** ✅
- Crit range 19-20 vs Marked (+10% crit chance)

#### **Level 20: Capstone**
**Slayer's Malice**
- Raging Blow +30% damage, +10% chance to apply Marked
- Total Mark chance: 25% (15% base + 10% Slayer's Malice)

---

## 🛡️ PROTECTION WARRIOR SPECIALIZATIONS

### **MOUNTAIN THANE (Protection)**

*[Same talents as Fury Mountain Thane, but Protection context]*

#### **Level 13: Keystone (Automatic)**
**Avatar of the Storm**
- Avatar gains 1d8 Lightning/turn to 3m

#### **Level 15: Tier 1 - Lightning Strikes** ✅
- Thunder Clap/Revenge/Execute: 25% chance → 1d10 Lightning

#### **Level 17: Tier 2 - Thunder Blast** ✅
- Shield Slam 35% chance → Thunder Blast charges
- Thunder Clap becomes +40% damage, +2 Rage

#### **Level 19: Tier 3 - Strength of the Mountain** ✅
- Shield Slam +15% damage
- Demoralizing Shout -5% enemy damage

#### **Level 20: Capstone**
**Gathering Storms**
- Lightning Strikes +3 Rage
- Revenge/Execute +25% damage

**Protection Context:** Tank with lightning zone control, Rage generation from procs, Shield Slam as primary builder benefits greatly.

---

### **COLOSSUS (Protection)**

*[Same talents as Arms Colossus, but Protection context]*

#### **Level 13: Keystone (Automatic)**
**Demolish + Colossal Might**
- Demolish: 3×3d10+STR, 40 Rage, consumes stacks
- Colossal Might: Shield Slam/Execute/Revenge(3+) grant stacks, max 5

#### **Level 15: Tier 1 - No Stranger to Pain** ✅
- Ignore Pain +20% damage prevention

#### **Level 17: Tier 2 - Practiced Strikes** ✅
- Shield Slam +10% damage, Revenge +10% damage, Shield Slam +3 Rage

#### **Level 19: Tier 3 - Martial Expert** ✅
- Revenge +7% damage per stack (max +35%)

#### **Level 20: Capstone**
**Precise Might**
- +2% crit per stack (max +10% at 5 stacks)

**Protection Context:** Tank with burst finisher, stack management adds skill ceiling, Revenge becomes scaling powerhouse.

---

## 📊 SPECIALIZATION COMPARISON TABLE

### **Playstyle Summary**

| Specialization | Primary Mechanic | Build Identity | Skill Ceiling |
|----------------|-----------------|----------------|---------------|
| **Mountain Thane** | Lightning procs | Storm warrior, Avatar-focused | Medium (proc management) |
| **Colossus** | Stack & burst | Might accumulator, finisher burst | High (stack optimization) |
| **Slayer** | Mark & Execute | Executioner, priority targets | Medium (Mark tracking) |

### **Subclass Availability**

| Specialization | Arms | Fury | Protection |
|----------------|------|------|------------|
| **Mountain Thane** | ❌ No | ✅ Yes | ✅ Yes |
| **Colossus** | ✅ Yes | ❌ No | ✅ Yes |
| **Slayer** | ✅ Yes | ✅ Yes | ❌ No |

### **Talent Tier Choices (Recommended Path)**

| Level | Mountain Thane | Colossus | Slayer |
|-------|----------------|----------|--------|
| **L13** | Avatar of the Storm | Demolish + Colossal Might | Slayer's Dominance |
| **L15** | Lightning Strikes | No Stranger to Pain | Brutal Finish |
| **L17** | Thunder Blast | Practiced Strikes | Culling Cyclone |
| **L19** | Strength of the Mountain | Martial Expert | Show No Mercy |
| **L20** | Gathering Storms | Precise Might | Slayer's Malice |

---

## 🎮 IMPLEMENTATION NOTES

### **Progressions.lsx Structure**

Each specialization requires:
1. **L13 SelectPassives node**: 2 options (keystone passives)
   - Each keystone passive sets a flag (e.g., `WAR_ARMS_Colossus_Keystone`)
   - Flag is checked by L15/17/19 nodes via `Requirement` attribute

2. **L15/17/19 Conditional SelectPassives nodes**: 3 options each
   - `Requirement="HasPassive('WAR_ARMS_Colossus_Keystone')"` gates choices
   - 2 sets of SelectPassives per level (one per specialization)

3. **L20 Automatic Capstone**: 
   - `PassivesAdded="IF(HasPassive('KEYSTONE')):ApplyStatus(SELF,CAPSTONE)"`
   - Conditional passive grant based on L13 choice

### **Passive Definitions Required**

**Per Specialization:**
- 1 Keystone passive (L13)
- 9 Tier choice passives (3 per tier × 3 tiers)
- 1 Capstone passive (L20)
- **Total per spec**: 11 passives

**Total Across All Specs:**
- Mountain Thane: 11 passives (shared by Fury + Protection)
- Colossus: 11 passives (shared by Arms + Protection)
- Slayer: 11 passives (shared by Arms + Fury)
- **Grand Total**: 33 unique passive definitions

### **Localization Handles Required**

**Per Passive:**
- 1 Display Name handle
- 1 Description handle (with specialization warning in keystone)

**Total Handles:**
- 33 passives × 2 handles = **66 TranslatedString handles**

### **Status Definitions Required**

- **Marked for Execution**: 1 status (Slayer keystone - +10% Execute damage, +1d6 from your attacks, 4 turns)
- **Colossal Might**: 1 status (Colossus keystone - stacking buff, max 5, +10% Demolish per stack)
- **Overwhelmed**: 1 status (Slayer L19 choice - +8% damage from you, 3 turns)
- **Avatar of the Storm**: 1 status (Mountain Thane keystone - 1d8 Lightning/turn to 3m)
- **Thunder Blast**: 1 status (Mountain Thane L17 choice - charge system, empowered Thunder Clap)
- **Burst of Power**: 1 status (Mountain Thane L15 alternative - Shield Slam costs Bonus Action, 2 charges)
- **Blood Frenzy**: 1 status (Slayer L15 alternative - +2 melee damage, +10% movement, 2 turns)
- **Bleeding**: Already exists in vanilla BG3 (used by Arterial Bleed talent)
- **Steadfast**: 1 status (Mountain Thane L19 alternative - +2 saves, +2% HP regen/turn, +1 AC)
- **Healing Reduction**: Already exists in vanilla BG3 (used by Imminent Demise talent)
- **Off Balance**: Already exists in vanilla BG3 (used by Charge ability)
- **Prone**: Already exists in vanilla BG3 (used by Earthquaker talent)
- **Total New Statuses**: 7 (5 original + 2 new from buffed alternatives)

### **New Abilities Required**

- **Demolish**: 1 spell (Colossus keystone, shared across Arms/Protection)
- **Total New Spells**: 1

---

## ✅ VALIDATION CHECKLIST

### **Pre-Implementation**
- [x] All 3 specializations defined with 5-tier structure
- [x] Recommended talent paths identified for each spec
- [x] Synergies documented between tiers
- [x] Build paths explained with gameplay loops
- [x] Subclass availability matrix created
- [x] Implementation requirements tallied

### **During Implementation**
- [ ] Create 33 passive definitions in Passive_Warrior.txt
- [ ] Create 5 status definitions in Status_Warrior.txt
- [ ] Create 1 spell definition (Demolish) in Spell_Warrior.txt
- [ ] Generate 66 localization handles in English.loca.xml
- [ ] Verify Progressions.lsx conditional logic (HasPassive requirements)
- [ ] Test L13 specialization choice UI (2 options display correctly)
- [ ] Test L15/17/19 tier choices gated correctly per specialization
- [ ] Test L20 capstone auto-grant based on L13 choice

### **Post-Implementation**
- [ ] Test Mountain Thane build path (all 3 tiers + capstone)
- [ ] Test Colossus build path (stacking + Demolish + crit)
- [ ] Test Slayer build path (Mark application + Execute scaling)
- [ ] Verify specialization tooltips explain talent tree locking
- [ ] Verify capstone grants correctly at L20
- [ ] Test multiclass interactions (specialization carries over)
- [ ] Test respec behavior (can change specialization choice?)

---

## 📝 NEXT STEPS

1. **Update Progressions.lsx**: ✅ COMPLETE (specialization nodes added L13/15/17/19/20)
2. **Create Passive Definitions Document**: Next (detail all 33 passives for Stats files)
3. **Create Status Definitions**: After passives (5 new statuses)
4. **Create Demolish Spell**: After statuses (1 new spell)
5. **Generate Localization Handles**: After all definitions (66 handles)

---

**Last Updated**: October 16, 2025  
**Status**: Specialization system fully defined, ready for Stats file implementation  
**Progressions.lsx**: Updated with all specialization nodes
