# Charge Resources Deep Dive: How They Work

**Date**: October 18, 2025  
**Purpose**: Detailed breakdown of 5 proposed charge-based resources for Warrior class  
**Context**: FILE 3 transformation decision - comparing charge system vs Rage-only

---

## 📊 CHARGE RESOURCE #1: DefensiveCharge

**Resource Name**: `DefensiveCharge`  
**Max Charges**: 1  
**Replenish**: Rest (Long Rest)  
**Shared By**: 2 abilities  
**Specialization**: All Warriors

### Abilities Using DefensiveCharge

| Ability | Type | Action Cost | Current Cooldown | Effect Duration | What It Does |
|---------|------|-------------|------------------|-----------------|--------------|
| **Die by the Sword** | Bonus Action | 1 Bonus Action | OncePerLongRest | 3 turns | Parry all incoming attacks for 3 turns (you dodge/deflect everything) |
| **Berserker Rage** | Bonus Action | 1 Bonus Action | OncePerShortRest | 2 turns | Immunity to Frightened, Charmed, break free from existing CC |

### How It Works

**Current System** (Cooldown-based):
- Die by the Sword: Use once, wait until Long Rest to use again
- Berserker Rage: Use once, wait until Short Rest to use again
- **Problem**: Separate cooldowns, can't choose which to use strategically

**Charge System** (Proposed):
1. Start combat with **1 DefensiveCharge**
2. Player decides: "Do I use it on Die by the Sword (stronger, longer) OR Berserker Rage (shorter but breaks CC)?"
3. After using either ability, charge is spent
4. Refills on Long Rest

**Benefits**:
- **Player agency**: Choose when to spend defensive cooldown
- **Strategic depth**: Save charge for critical moment (boss attack, mass CC)
- **Visual clarity**: UI shows "1 DefensiveCharge available" vs. checking 2 separate cooldowns

**Implementation**:
```
// In ActionResourceDefinitions.lsx
<node id="ActionResourceDefinition">
    <attribute id="Name" value="DefensiveCharge"/>
    <attribute id="MaxValue" value="1"/>
    <attribute id="ReplenishType" value="Rest"/>
</node>

// In Spell_Target.txt - Die by the Sword
data "UseCosts" "BonusActionPoint:1;DefensiveCharge:1"  // Remove cooldown
data "Cooldown" "None"  // Changed from OncePerLongRest

// In Spell_Target.txt - Berserker Rage
data "UseCosts" "BonusActionPoint:1;DefensiveCharge:1"  // Remove cooldown
data "Cooldown" "None"  // Changed from OncePerShortRest
```

---

## 🛡️ CHARGE RESOURCE #2: TankCooldown

**Resource Name**: `TankCooldown`  
**Max Charges**: 1  
**Replenish**: Rest (Long Rest)  
**Shared By**: 3 abilities  
**Specialization**: Protection Warriors only

### Abilities Using TankCooldown

| Ability | Type | Action Cost | Current Cooldown | Effect Duration | What It Does |
|---------|------|-------------|------------------|-----------------|--------------|
| **Last Stand** | Bonus Action | 1 Bonus Action | OncePerShortRest | 3 turns | Gain 30% of max HP as temporary HP for 3 turns (emergency health) |
| **Shield Wall** | Bonus Action | 1 Bonus Action | OncePerShortRest | 2 turns | Reduce all incoming damage by 40% for 2 turns (major mitigation) |
| **Indomitable** | Bonus Action | 1 Bonus Action | OncePerShortRest | 1 turn | Automatically succeed on all saves for 1 turn (immunity to spells) |

### How It Works

**Current System** (Cooldown-based):
- 3 separate cooldowns (all OncePerShortRest)
- Can theoretically use all 3 in same fight
- **Problem**: Too many panic buttons, trivializes tank difficulty

**Charge System** (Proposed):
1. Protection Warriors get **1 TankCooldown charge** at start of combat
2. Must choose which ultimate survival ability to use:
   - **Last Stand**: Low HP? Get emergency temporary HP buffer
   - **Shield Wall**: Taking heavy sustained damage? Reduce it by 40%
   - **Indomitable**: Enemy casting disintegrate? Auto-pass the save
3. Once spent, no more tank cooldowns until Long Rest

**Benefits**:
- **High-stakes decisions**: "Which cooldown do I save for the boss mechanic?"
- **Balance**: Prevents spamming all 3 cooldowns in one fight
- **Meaningful choice**: Each ability is powerful, but you only get ONE use

**Fantasy**: You're a tank with ONE "oh shit" button per fight. Use it wisely.

**Implementation**:
```
// In ActionResourceDefinitions.lsx
<node id="ActionResourceDefinition">
    <attribute id="Name" value="TankCooldown"/>
    <attribute id="MaxValue" value="1"/>
    <attribute id="ReplenishType" value="Rest"/>
</node>

// All 3 abilities change to:
data "UseCosts" "BonusActionPoint:1;TankCooldown:1"
data "Cooldown" "None"
```

---

## 🏃 CHARGE RESOURCE #3: MobilityCharge

**Resource Name**: `MobilityCharge`  
**Max Charges**: 2  
**Replenish**: ShortRest  
**Shared By**: 3 abilities  
**Specialization**: All Warriors

### Abilities Using MobilityCharge

| Ability | Type | Action Cost | Range | Current Cooldown | What It Does |
|---------|------|-------------|-------|------------------|--------------|
| **Heroic Leap** | Action | 1 Action | 12m | OncePerShortRest | Jump to location, deal 1d8+STR AoE damage in 3m radius |
| **Intervene** | Action | 1 Action | 12m | OncePerShortRest | Jump to ally, protect them for 2 turns (redirect attacks to you) |
| **Storm Bolt** | Action | 1 Action | 18m | OncePerShortRest | Ranged attack, 2d6+STR Thunder damage + Stun 2 turns |

### How It Works

**Current System** (Cooldown-based):
- 3 separate cooldowns (all OncePerShortRest)
- Use each once per short rest
- **Problem**: Rigid - can't use 2 Heroic Leaps if you need mobility

**Charge System** (Proposed):
1. Start with **2 MobilityCharges**
2. Spend charges on any combination:
   - 2× Heroic Leap (double jump for positioning)
   - 1× Heroic Leap + 1× Intervene (engage + save ally)
   - 2× Storm Bolt (stun 2 different enemies)
   - 1× Intervene + 1× Storm Bolt (protect ally + stun caster)
3. Refills on Short Rest (2 charges back)

**Benefits**:
- **Flexibility**: Adapt to situation (need 2 gap closers? Use both charges on Leap)
- **Combo potential**: Leap in → Storm Bolt → Leap out (costs 2 charges but possible)
- **No waste**: Don't need Intervene? Spend both charges on Leap/Storm Bolt

**Example Scenarios**:
- **Scenario 1**: Ranged enemies on high ground → Use 2× Heroic Leap to jump up twice
- **Scenario 2**: Ally about to die → Intervene to protect, still have 1 charge for Storm Bolt
- **Scenario 3**: Boss fight → Save both charges for clutch Intervene + emergency Leap away

**Implementation**:
```
// In ActionResourceDefinitions.lsx
<node id="ActionResourceDefinition">
    <attribute id="Name" value="MobilityCharge"/>
    <attribute id="MaxValue" value="2"/>
    <attribute id="ReplenishType" value="ShortRest"/>
</node>

// All 3 abilities change to:
data "UseCosts" "ActionPoint:1;MobilityCharge:1"
data "Cooldown" "None"
```

---

## ⚔️ CHARGE RESOURCE #4: OverpowerCharge

**Resource Name**: `OverpowerCharge`  
**Max Charges**: 2  
**Replenish**: Never (Combat only)  
**Shared By**: 1 ability  
**Specialization**: Arms Warriors only

### Ability Using OverpowerCharge

| Ability | Type | Action Cost | Rage Cost | What It Does |
|---------|------|-------------|-----------|--------------|
| **Overpower** | Bonus Action | 1 Bonus Action | 20 Rage | 1d12+STR damage, ignores AC (auto-hit), only usable when you have charges |

### How Charges Are Gained

**Trigger Conditions** (from passive):
- Enemy **dodges** your attack → Gain 1 OverpowerCharge
- Enemy **parries** your attack → Gain 1 OverpowerCharge
- Max 2 charges stored

**Current System** (Status-based):
- Status: `WAR_OVERPOWER_PROC` applied when enemy dodges
- Status grants `UnlockSpell(Target_WAR_Overpower)` (makes button appear)
- **Problem**: Hidden proc, no visual feedback on "how many procs do I have?"

**Charge System** (Proposed):
1. Arms Warrior starts with **0 OverpowerCharges**
2. Enemy dodges your Mortal Strike → **+1 OverpowerCharge** (visual resource bar fills)
3. Enemy parries your next attack → **+2 OverpowerCharges** (bar shows 2 charges)
4. Spend 1 charge: Use Overpower (guaranteed hit, 1d12 damage) + costs 20 Rage
5. Charges persist until spent (don't expire on rest)

**Benefits**:
- **Visual feedback**: See "You have 2 Overpower procs!" instead of checking buff bar
- **Resource tracking**: Know exactly how many charges you've stored
- **Strategic spending**: Save charges for burst damage window OR spend immediately

**Example Combat**:
```
Turn 1: Attack enemy → Miss (dodged) → +1 OverpowerCharge
Turn 2: Mortal Strike → Miss (parried) → +2 OverpowerCharges (capped)
Turn 3: Overpower (spend 1 charge, 20 Rage) → Auto-hit for 1d12+STR
Turn 4: Still have 1 OverpowerCharge left → Save for Execute phase
```

**Fantasy**: Missed attacks make you angry → Unleash guaranteed critical counter-strike

**Implementation**:
```
// In ActionResourceDefinitions.lsx
<node id="ActionResourceDefinition">
    <attribute id="Name" value="OverpowerCharge"/>
    <attribute id="MaxValue" value="2"/>
    <attribute id="ReplenishType" value="Never"/>  // Only gained via procs
</node>

// In Passive.txt - Replace status with resource grant
data "StatsFunctorContext" "OnMiss"  // When you miss
data "Conditions" "Miss()"
data "StatsFunctors" "RestoreResource(SELF,OverpowerCharge,1,0)"  // +1 charge

// In Spell_Target.txt - Overpower now costs charges
data "UseCosts" "BonusActionPoint:1;Rage:20;OverpowerCharge:1"
data "Cooldown" "None"
```

---

## ⚡ CHARGE RESOURCE #5: ThunderCharge

**Resource Name**: `ThunderCharge`  
**Max Charges**: 3  
**Replenish**: Never (Combat only)  
**Shared By**: 1 ability  
**Specialization**: Mountain Thane (L13+ Hero Talent)

### How Mountain Thane Works

**Theme**: Lightning-based proc warrior (fury or protection builds)  
**Key Mechanic**: Shield Slam has 35% chance to generate ThunderCharges

### Abilities Using ThunderCharge

| Ability | Effect | How It Uses Charges |
|---------|--------|---------------------|
| **Thunder Clap** (empowered) | AoE slow + damage | Consumes all charges, damage scales with charges spent |

### How Charges Are Gained

**From Passive** (L17 talent: Thunder Blast):
```
Passive: WAR_MountainThane_ThunderBlast
Trigger: When you cast Shield Slam
Effect: 35% chance to gain 1 ThunderCharge (max 3)
```

### How Charges Are Spent

**Thunder Clap Empowerment**:
- **Base Thunder Clap**: Rage cost, AoE slow
- **With 1 ThunderCharge**: +40% damage, +200% Rage generation
- **With 2 ThunderCharges**: +80% damage, +400% Rage generation  
- **With 3 ThunderCharges** (max): +120% damage, +600% Rage generation, consume all charges

**Current System** (Status-based):
```
// In Status_BOOST.txt
new entry "WAR_THUNDER_BLAST_CHARGE"
data "Boosts" "Damage(Increase,40,WAR_ThunderClap);ActionResourceMultiplier(Rage,200,0,WAR_ThunderClap)"
data "RemoveEvents" "OnSpellCast"
data "RemoveConditions" "HasStringInSpellRoll('Projectile(WAR_ThunderClap)')"
```
- **Problem**: Status doesn't stack visually (you see "1 stack" but not clearly)

**Charge System** (Proposed):
1. Mountain Thane with **0 ThunderCharges** at combat start
2. Cast Shield Slam (Protection ability) → 35% chance → **+1 ThunderCharge**
3. Cast Shield Slam again → Proc! → **+2 ThunderCharges**
4. Resource bar shows: **⚡⚡ 2/3 Thunder Charges**
5. Cast Thunder Clap → Spend all 2 charges → Deal +80% damage + generate +400% Rage
6. Back to 0 charges, start building again

**Benefits**:
- **Clear visual**: "I have 3 lightning charges, my next Thunder Clap will nuke"
- **Build-around gameplay**: "I'm saving charges for AoE pack"
- **Specialization identity**: Only Mountain Thane has this resource (unique feel)

**Example Combat** (Mountain Thane Protection Warrior):
```
Turn 1: Shield Slam → No proc → 0 charges
Turn 2: Shield Slam → Proc! → 1 ThunderCharge (⚡ 1/3)
Turn 3: Shield Slam → Proc! → 2 ThunderCharges (⚡⚡ 2/3)
Turn 4: Enemies grouped → Thunder Clap → Spend 2 charges → MASSIVE DAMAGE + Rage flood
Turn 5: Shield Slam → Proc! → 1 ThunderCharge (start building again)
Turn 6: Shield Slam → Proc! → 2 ThunderCharges
Turn 7: Shield Slam → Proc! → 3 ThunderCharges (⚡⚡⚡ MAXED)
Turn 8: Thunder Clap → Spend ALL 3 → ULTRA DAMAGE (+120%, +600% Rage)
```

**Fantasy**: Build up lightning energy through Shield Slams, unleash devastating Thunder Clap

**Implementation**:
```
// In ActionResourceDefinitions.lsx
<node id="ActionResourceDefinition">
    <attribute id="Name" value="ThunderCharge"/>
    <attribute id="MaxValue" value="3"/>
    <attribute id="ReplenishType" value="Never"/>  // Only via Shield Slam procs
</node>

// In Passive.txt - Replace status grant with resource grant
new entry "WAR_MountainThane_ThunderBlast"
data "StatsFunctorContext" "OnCast"
data "Conditions" "HasStringInSpellRoll('Projectile(WAR_ShieldSlam)')"
data "StatsFunctors" "IF(RandomCastOutcome(35,100)):RestoreResource(SELF,ThunderCharge,1,0)"

// In Status_BOOST.txt - Remove WAR_THUNDER_BLAST_CHARGE status (replaced by resource)

// In Spell_Zone.txt - Thunder Clap now scales with charges
data "SpellSuccess" "DealDamage(2d8+StrengthModifier,Thunder,Magical);IF(HasResource(ThunderCharge,1,0,context.Source)):DealDamage(MainMeleeWeapon*0.4,Thunder);IF(HasResource(ThunderCharge,2,0,context.Source)):DealDamage(MainMeleeWeapon*0.8,Thunder);IF(HasResource(ThunderCharge,3,0,context.Source)):DealDamage(MainMeleeWeapon*1.2,Thunder);RestoreResource(SELF,Rage,ChargeCount(ThunderCharge)*10,0);ConsumeResource(SELF,ThunderCharge,99,0)"
```

---

## 📊 SUMMARY TABLE: All 5 Charge Resources

| Resource | Max | Replenish | Specs | # Abilities | Primary Use Case | Player Decision |
|----------|-----|-----------|-------|-------------|------------------|-----------------|
| **DefensiveCharge** | 1 | Rest | All | 2 | Emergency defense | "Parry all OR break CC?" |
| **TankCooldown** | 1 | Rest | Protection | 3 | Ultimate survival | "HP, mitigation, or immunity?" |
| **MobilityCharge** | 2 | ShortRest | All | 3 | Positioning/utility | "Double leap OR leap+stun?" |
| **OverpowerCharge** | 2 | Never (proc) | Arms | 1 | Reactive damage | "Spend now or save for burst?" |
| **ThunderCharge** | 3 | Never (proc) | Mountain Thane | 1 | Scaling AoE nuke | "When to unleash lightning?" |

---

## ⚖️ COMPARISON: Charge System vs Cooldown System

### Cooldown System (Current)
```
Die by the Sword:     [Used] → Wait 8 hours (Long Rest)
Berserker Rage:       [Used] → Wait 1 hour (Short Rest)
Heroic Leap:          [Used] → Wait 1 hour (Short Rest)
Intervene:            [Available]
Storm Bolt:           [Available]
Last Stand:           [Used] → Wait 1 hour (Short Rest)
Shield Wall:          [Available]
Indomitable:          [Available]
Overpower:            [Hidden - proc status active]
Thunder Clap:         [Available, no buff shown]
```
- **Pros**: Simple, no resource tracking
- **Cons**: Rigid, can't use 2 leaps, no visual proc feedback

### Charge System (Proposed)
```
DefensiveCharge:      ⚡ 0/1  [Spent on Die by the Sword]
TankCooldown:         ⚡ 0/1  [Spent on Last Stand]
MobilityCharge:       ⚡⚡ 2/2 [Both available]
OverpowerCharge:      ⚡ 1/2  [1 proc stored, can use Overpower]
ThunderCharge:        ⚡⚡⚡ 3/3 [MAXED - Thunder Clap will NUKE]
```
- **Pros**: Flexible, visual, strategic choices, combo potential
- **Cons**: More complexity, need to track 5 additional resources

---

## 🎯 FINAL DECISION MATRIX

### Option A: Rage Only
- ⏱️ **Time**: 15 minutes
- 📊 **Complexity**: Very Low
- 🎮 **Gameplay**: Simple, classic
- ✨ **Visual Feedback**: None (cooldowns only)

### Option B: Rage + 5 Charges ⭐ RECOMMENDED
- ⏱️ **Time**: 4-6 hours
- 📊 **Complexity**: Medium
- 🎮 **Gameplay**: Tactical, engaging, high skill ceiling
- ✨ **Visual Feedback**: 5 resource bars, clear proc tracking
- 🏆 **Proven**: Warlock mod (13K downloads) uses this pattern successfully

---

## ❓ YOUR DECISION

Now that you see exactly how each charge works:

**A)** Rage Only (simple, fast)  
**B)** Rage + All 5 Charges (recommended, tactical depth)  
**C)** Rage + SOME Charges (tell me which ones to include/exclude)  
**D)** Custom modifications (tell me what you want changed)

**Which option should we implement for FILE 3?**
