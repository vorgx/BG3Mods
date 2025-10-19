# Arms Warrior - Full Talent Extraction for BG3 Mod

**Extracted from Blueprint + WoW Knowledge Base**

---

## PASSIVES (Auto-granted)

### Mastery: Deep Wounds
- **Type**: Passive
- **Effect**: Your attacks inflict Deep Wounds, dealing bleed damage over time
- **BG3 Implementation**: Passive that applies 1d6 Bleeding damage per turn for 3 turns on successful melee attacks

### Tactician
- **Type**: Passive
- **Effect**: Rage from defensive actions and critical strikes
- **BG3 Implementation**: Generate +5 Rage when you Dodge, or when you critically hit with a melee attack

---

## SUBCLASS SPEC TALENTS (10 Rows - Arms Talent Tree)

### Row 1
**Mortal Strike (MS)**
- **Type**: Action (Primary Attack)
- **Effect**: Signature Arms ability that applies Healing Reduction
- **BG3 Implementation**:
  - Action, Melee Weapon Attack
  - Damage: 2d10 + Strength modifier
  - Apply Mortal Wound: Target receives -50% healing for 2 turns
  - Costs: 30 Rage
  - Cooldown: 1 turn
  - Tags: MeleeWeapon, SingleTarget, HealingReduction

### Row 2
**Overpower (OP)**
- **Type**: Action (Secondary Attack)
- **Effect**: Overwhelm opponent's defenses with crushing blow
- **BG3 Implementation**:
  - Bonus Action, Melee Weapon Attack
  - Damage: 1d12 + Strength modifier
  - Ignore 50% of target's AC (treat as if AC is halved for this attack)
  - Costs: 20 Rage
  - Tags: MeleeWeapon, SingleTarget, ArmorPierce

**Rend**
- **Type**: Action (DoT Application)
- **Effect**: Apply strong bleed effect
- **BG3 Implementation**:
  - Action, Melee Weapon Attack
  - Damage: 1d6 + Strength modifier initial
  - Apply Rend: 2d6 Bleeding damage per turn for 5 turns
  - Costs: 10 Rage
  - Tags: MeleeWeapon, Bleed, DoT

### Row 3 (Choice Node)
**Improved Overpower**
- **Type**: Passive
- **Effect**: Overpower becomes more reliable
- **BG3 Implementation**: Overpower gains +1d6 damage and has 2 charges

**OR**

**Dreadnaught**
- **Type**: Passive
- **Effect**: Overpower becomes more powerful
- **BG3 Implementation**: Overpower deals +25% damage and reduces target's damage by -10% for 2 turns

**Additional Row 3:**

**Skullsplitter**
- **Type**: Action (Rage Generator)
- **Effect**: Powerful strike that generates Rage
- **BG3 Implementation**:
  - Bonus Action, Melee Weapon Attack
  - Damage: 1d10 + Strength modifier
  - Generate +20 Rage
  - Cooldown: 1 turn
  - Tags: MeleeWeapon, RageGenerator

**Die by the Sword**
- **Type**: Action (Defensive Cooldown)
- **Effect**: Parry all attacks for a short duration
- **BG3 Implementation**:
  - Bonus Action, Self-buff
  - Parry all melee attacks for 3 turns
  - Recharge: Long Rest
  - Tags: Defensive, SelfBuff

### Row 4 (Choice Node)
**Massacre**
- **Type**: Passive
- **Effect**: Execute becomes available earlier
- **BG3 Implementation**: Execute can be used when target is below 35% HP (instead of 20%)

**Improved Execute**
- **Type**: Passive
- **Effect**: Execute becomes more lethal
- **BG3 Implementation**: Execute deals +50% damage and costs -10 Rage

### Row 5 (Major Unlocks)
**Colossus Smash (CS)**
- **Type**: Action (Armor Debuff)
- **Effect**: Devastating strike that shatters enemy defenses
- **BG3 Implementation**:
  - Action, Melee Weapon Attack
  - Damage: 3d8 + Strength modifier
  - Apply Shattered Defenses: -3 AC for 3 turns
  - Costs: 40 Rage
  - Recharge: Short Rest
  - Tags: MeleeWeapon, SingleTarget, ArmorDebuff

**Sweeping Strikes (SS)**
- **Type**: Action (Cleave Buff)
- **Effect**: Your next attacks cleave to additional targets
- **BG3 Implementation**:
  - Bonus Action, Self-buff
  - Duration: 2 turns or 2 attacks
  - Effect: Your next 2 single-target melee attacks cleave to 1 additional nearby enemy for 50% damage
  - Recharge: Short Rest
  - Tags: Buff, Cleave, AoE

**Juggernaut**
- **Type**: Passive
- **Effect**: Execute reduces enemy armor
- **BG3 Implementation**: Execute applies Sundered Armor (-2 AC) for 3 turns

### Row 6 (Choice Node - Weapon Style)
**Crushing Force**
- **Type**: Passive
- **Effect**: Damage boost tied to Slam/Colossus Smash
- **BG3 Implementation**: After using Colossus Smash, gain +2 Strength for 4 turns

**Endurance Training**
- **Type**: Passive
- **Effect**: Stamina and armor increase
- **BG3 Implementation**: +10% Maximum HP and +1 AC

**Exhilarating Blows**
- **Type**: Passive
- **Effect**: Overpower generates Rage
- **BG3 Implementation**: Overpower generates +5 Rage when it hits

**Storm of Swords**
- **Type**: Passive
- **Effect**: Whirlwind cooldown reduced
- **BG3 Implementation**: Whirlwind costs -5 Rage and buff lasts +1 turn

### Row 7 (Advanced Mechanics)
**Warbreaker (WB)**
- **Type**: Action (Burst Damage)
- **Effect**: Powerful AoE strike that shatters armor
- **BG3 Implementation**:
  - Action, Melee Weapon Attack (cone 3m)
  - Damage: 4d10 + Strength modifier to all targets
  - Apply Sundered Armor (-2 AC) to all targets for 3 turns
  - Costs: 40 Rage
  - Recharge: Long Rest
  - Tags: MeleeWeapon, AoE, ArmorDebuff

**Bloodletting**
- **Type**: Passive
- **Effect**: Rend and Deep Wounds deal more damage
- **BG3 Implementation**: Bleeding effects you apply deal +30% damage

**Martial Prowess**
- **Type**: Passive
- **Effect**: Overpower critical strike chance increase
- **BG3 Implementation**: Overpower critical hit range increased by 2 (18-20)

**Unhinged**
- **Type**: Passive
- **Effect**: Sweeping Strikes enhancement
- **BG3 Implementation**: While Sweeping Strikes is active, deal +20% damage with all attacks

**Valor in Victory**
- **Type**: Passive
- **Effect**: Execute healing
- **BG3 Implementation**: Execute heals you for 5% of your max HP when it kills an enemy

**Honed Reflexes**
- **Type**: Passive
- **Effect**: Die by the Sword improvement
- **BG3 Implementation**: Die by the Sword duration increased to 5 turns and you gain Riposte (counterattack on parry)

### Row 8 (Cooldown Management)
**Avatar**
- **Type**: Action (Major Offensive Cooldown)
- **Effect**: Become an avatar of war, greatly increasing offensive power
- **BG3 Implementation**:
  - Bonus Action, Self-buff
  - Duration: 4 turns
  - Effect: +4 Strength, +2 AC, Immune to fear/charm, generate +50% Rage
  - Recharge: Long Rest
  - Tags: Buff, SelfBuff, Transformation

**Bladestorm (BS)**
- **Type**: Action (Premier AoE)
- **Effect**: Become a whirlwind of steel, attacking all nearby enemies
- **BG3 Implementation**:
  - Action, AoE Attack (3m radius around self)
  - Duration: 4 turns
  - Damage: 2d8 + Strength modifier per turn to all enemies within 3m
  - Cannot be interrupted
  - Recharge: Long Rest
  - Tags: AoE, Channeled

**Test of Might**
- **Type**: Passive
- **Effect**: Warbreaker grants Strength
- **BG3 Implementation**: When you use Warbreaker, gain +2 Strength for 5 turns

**Improved Sweeping Strikes**
- **Type**: Passive
- **Effect**: Sweeping Strikes becomes better
- **BG3 Implementation**: Sweeping Strikes lasts for 3 attacks (instead of 2) and cleave damage increased to 75%

**Anger Management (AM)**
- **Type**: Passive
- **Effect**: Reduces cooldowns by spending Rage
- **BG3 Implementation**: Spending 20 Rage reduces Avatar and Bladestorm cooldowns by 1 turn each

### Row 9 (Choice Node)
**Fatality**
- **Type**: Passive
- **Effect**: Execute critical strike bonus
- **BG3 Implementation**: Execute automatically critically hits when target is below 20% HP

**Bloodborne**
- **Type**: Passive
- **Effect**: Bleeding damage increase
- **BG3 Implementation**: Bleeding effects you apply deal +25% damage (stacks with Bloodletting for +55% total)

### Row 10 (Capstone Talents)
**Executioner's Precision**
- **Type**: Passive
- **Effect**: Execute strikes additional targets
- **BG3 Implementation**: Execute now cleaves to 2 additional nearby targets for 50% damage

**Unrelenting Assault**
- **Type**: Passive
- **Effect**: Greatly increases Arms damage during Bladestorm
- **BG3 Implementation**: During Bladestorm, all your attacks deal +30% damage

**Champion's Might**
- **Type**: Passive
- **Effect**: Avatar becomes stronger
- **BG3 Implementation**: Avatar grants +6 Strength (instead of +4) and lasts 6 turns (instead of 4)

**Deadly Calm**
- **Type**: Action (Rage Efficiency Cooldown)
- **Effect**: Your next abilities cost no Rage
- **BG3 Implementation**:
  - Bonus Action, Self-buff
  - Duration: 3 turns
  - Effect: All abilities cost 0 Rage
  - Recharge: Short Rest
  - Tags: Buff, ResourceManagement

---

## SUBCLASS BASE ABILITIES (Baseline/Bucket - Granted at L1-12)

These are abilities available when choosing Arms spec, separate from talent rows:

### Offensive Baseline

**Slam**
- **Type**: Action
- **Effect**: Simple Rage spender
- **BG3 Implementation**:
  - Action, Melee Weapon Attack
  - Damage: 2d6 + Strength modifier
  - Costs: 15 Rage
  - Tags: MeleeWeapon, BasicAttack

**Execute**
- **Type**: Action
- **Effect**: Execute low-HP targets
- **BG3 Implementation**:
  - Action, Melee Weapon Attack
  - Only usable on targets below 20% HP (or 35% with Massacre)
  - Damage: 4d12 + Strength modifier (scales with Rage spent, up to 40 Rage)
  - Costs: 20-40 Rage (more spent = more damage)
  - Tags: MeleeWeapon, Execute, SingleTarget

**Whirlwind**
- **Type**: Action
- **Effect**: AoE attack that enables cleave
- **BG3 Implementation**:
  - Action, Melee Weapon Attack (cone 3m)
  - Damage: 1d8 + Strength modifier to all targets
  - Apply Whirlwind buff: Next 2 single-target attacks cleave to 1 additional target
  - Costs: 10 Rage
  - Tags: AoE, MeleeWeapon

**Thunder Clap**
- **Type**: Action
- **Effect**: AoE damage + slow
- **BG3 Implementation**:
  - Action, AoE Attack (4m radius)
  - Damage: 2d6 + Strength modifier to all targets
  - Effect: Reduce movement speed by 20% for 3 turns
  - Costs: 10 Rage
  - Tags: AoE, Slowing

### Utility Baseline

**Battle Shout**
- **Type**: Bonus Action
- **Effect**: Party-wide damage buff
- **BG3 Implementation**:
  - Bonus Action, AoE Buff (9m radius)
  - Effect: +2 to attack rolls and damage rolls for all allies for 5 turns
  - Recharge: Short Rest
  - Tags: Buff, AoE, Party

**Rallying Cry**
- **Type**: Bonus Action
- **Effect**: Party-wide Temp HP
- **BG3 Implementation**:
  - Bonus Action, AoE Heal (9m radius)
  - All allies gain Temp HP equal to 2d8 + your level
  - Recharge: Short Rest
  - Tags: Healing, AoE, Party

**Heroic Leap**
- **Type**: Action
- **Effect**: Jump to location with AoE damage
- **BG3 Implementation**:
  - Action, Jump (12m range)
  - Land at target location, deal 1d8 + Strength to all enemies within 3m
  - Recharge: Short Rest
  - Tags: Jump, AoE, Mobility

**Intimidating Shout**
- **Type**: Action
- **Effect**: Fear nearby enemies
- **BG3 Implementation**:
  - Action, AoE Control (4m radius)
  - Apply Frightened to all enemies (Wisdom Save DC 8 + Prof + Str) for 3 turns
  - Costs: 10 Rage
  - Recharge: Short Rest
  - Tags: Control, AoE, Fear

**Hamstring**
- **Type**: Action
- **Effect**: Slow enemy
- **BG3 Implementation**:
  - Action, Melee Weapon Attack
  - Damage: 1d4 + Strength modifier
  - Effect: Reduce movement speed by 50% for 5 turns
  - Tags: Slow, MeleeWeapon

**Spell Reflection**
- **Type**: Reaction
- **Effect**: Reflect harmful spells
- **BG3 Implementation**:
  - Reaction (when targeted by spell)
  - Effect: Reflect spell back to caster, you take no damage
  - Recharge: Short Rest
  - Tags: Defensive, Reaction

---

## ❌ SPECIALIZATION: Mountain Thane (NOT Available to Arms Warriors)

**Important Note**: Arms Warriors **CANNOT** choose Mountain Thane at Level 13.

**Correct Specialization Options for Arms**:
- **Colossus** (Tank/Defense hero talents) - See section below
- **Slayer** (DPS/Execution hero talents) - See section below

**Mountain Thane Availability**:
- ✅ **Fury Warriors**: Mountain Thane OR Slayer
- ✅ **Protection Warriors**: Mountain Thane OR Colossus
- ❌ **Arms Warriors**: Colossus OR Slayer (NOT Mountain Thane)

For Mountain Thane details, see:
- `Fury_Warrior_Talents_Extracted.md`
- `Protection_Warrior_Talents_Extracted.md`

---

## SPECIALIZATION: Colossus (Hero Talent - Choice at L13)

**Arms Warriors choose COLOSSUS OR SLAYER at Level 13.**

### Colossus - Keystone (Granted at L13)

**Demolish**
- **Type**: Active Ability
- **Cooldown**: Short Rest
- **Rage Cost**: 20
- **Effect**: Unleash devastating strike that demolishes armor
- **BG3 Implementation**:
  - **Base**: Deal 3d12+STR weapon damage
  - **Debuff**: Apply Demolished status (target takes +10% physical damage) for 3 turns
  - **Synergy**: Against targets with Sunder Armor, deal +2d12 damage and refresh Sunder duration to maximum
- **Tags**: Active, Keystone, Single-Target, Debuff

### Colossus - Choice Nodes (3 Tiers: L15, L17, L19)

**Choice Node 1 (L15) - Pick 1 of 3:**

**Unstoppable Force**
- **Type**: Passive
- **Effect**: Shield Slam chains to additional targets
- **BG3 Implementation**: Shield Slam bounces to 1 additional target within 6m, dealing 50% damage

**Mountain of Muscle and Scars**
- **Type**: Passive
- **Effect**: Damage reduction when using Rage
- **BG3 Implementation**: While you have 50+ Rage (5+ pips), gain resistance to physical damage (take half damage)

**Colossal Might**
- **Type**: Passive
- **Effect**: Rage generation from Shield Slam
- **BG3 Implementation**: Shield Slam generates +10 Rage (total 30 Rage generated instead of 20)

**Choice Node 2 (L17) - Pick 1 of 3:**

**Dominance of the Colossus (Choice)**
- **Type**: Passive
- **Effect**: Demolish range increase (not the capstone - this is a choice node option)
- **BG3 Implementation**: Demolish can target enemies up to 18m away (from 3m melee range), becomes a ranged slam

**One Against Many**
- **Type**: Passive
- **Effect**: Damage reduction when surrounded
- **BG3 Implementation**: For each enemy within 3m of you (max 5), gain +5% damage reduction (max +25% at 5+ enemies)

**Arterial Bleed**
- **Type**: Passive
- **Effect**: Shield Slam causes bleeding
- **BG3 Implementation**: Shield Slam applies Bleeding status (2d4 damage per turn) for 3 turns

**Choice Node 3 (L19) - Pick 1 of 3:**

**Boneshaker**
- **Type**: Passive
- **Effect**: Demolish stuns low-health enemies
- **BG3 Implementation**: Demolish stuns enemies below 30% HP for 1 turn (Constitution save DC 15 negates)

**Practiced Strikes**
- **Type**: Passive
- **Effect**: Shield Slam cooldown reduction
- **BG3 Implementation**: Shield Slam recharge time reduced by 50% (recharges every 2 turns instead of 4)

**Martial Expert**
- **Type**: Passive
- **Effect**: General damage increase with shields
- **BG3 Implementation**: +15% damage with all abilities while wielding a shield

### Colossus - Passives (Auto-Granted)

**Tide of Battle** (L14)
- **Type**: Passive
- **Effect**: Revenge enhances next Shield Slam
- **BG3 Implementation**: When you use Revenge, your next Shield Slam within 2 turns deals +1d8 damage and generates +5 Rage

**Earthen Tenacity** (L16)
- **Type**: Passive
- **Effect**: Damage reduction while Rage is high
- **BG3 Implementation**: When you are above 80 Rage (8+ pips), gain +2 AC

**Disrupting Shout** (L18)
- **Type**: Passive
- **Effect**: Thunder Clap reduces enemy damage
- **BG3 Implementation**: Enemies hit by Thunder Clap deal -10% damage for 2 turns

**Titanic Fury** (L20)
- **Type**: Passive
- **Effect**: Shield Slam empowerment at high Rage
- **BG3 Implementation**: When you have 80+ Rage (8+ pips), Shield Slam automatically critically hits

### Colossus - Capstone (L20)

**Dominance of the Colossus (Capstone)**
- **Type**: Passive
- **Effect**: Demolish becomes even more devastating
- **BG3 Implementation**:
  - **Damage Increase**: Demolish deals +50% damage (4d12+1d6+STR instead of 3d12+STR)
  - **AoE Effect**: Demolish now hits all enemies in a 3m radius around the primary target for 50% damage
  - **Debuff Enhancement**: Demolished status now also reduces target's AC by -2
- **Tags**: Passive, Enhancement, Capstone

---

## SPECIALIZATION: Slayer (Hero Talent - Choice at L13)

**Arms Warriors choose SLAYER OR COLOSSUS at Level 13.**

### Slayer - Key Talent (Granted at L13)

**Slayer's Dominance**
- **Type**: Passive
- **Effect**: Frequent random single-target damage proc that inflicts Marked for Execution
- **BG3 Implementation**: 15% chance on melee hit to deal bonus 2d8 damage and apply Marked for Execution status (target takes +10% damage from Execute and takes +1d6 damage from your attacks) for 4 turns

### Slayer - Choice Nodes (3 Tiers: L15, L17, L19)

**Choice Node 1 (L15) - Pick 1 of 3:**

**Brutal Finish**
- **Type**: Passive
- **Effect**: Execute damage increase when Marked
- **BG3 Implementation**: Execute deals +50% damage against Marked for Execution targets

**Opportunist**
- **Type**: Passive
- **Effect**: Mortal Strike enhancement
- **BG3 Implementation**: When Mortal Strike hits a Marked for Execution target, it deals +1d8 damage and refunds 10 Rage

**Overwhelming Blades**
- **Type**: Passive
- **Effect**: Multi-target Marked for Execution spread
- **BG3 Implementation**: When you apply Marked for Execution, it spreads to 1 additional nearby enemy (within 3m) at half effectiveness (duration 2 turns instead of 4)

**Choice Node 2 (L17) - Pick 1 of 3:**

**Show No Mercy**
- **Type**: Passive
- **Effect**: Critical strike bonus tied to Marked for Execution
- **BG3 Implementation**: Attacks against Marked for Execution targets have critical hit range increased by 1 (19-20, or 18-20 if combined with other crit talents)

**Culling Cyclone**
- **Type**: Passive
- **Effect**: Whirlwind benefit from Marked
- **BG3 Implementation**: Whirlwind deals +1d6 damage per Marked for Execution enemy hit (stacks multiplicatively, 3 marked enemies = +3d6)

**Relentless Pursuit**
- **Type**: Passive
- **Effect**: Movement speed increase
- **BG3 Implementation**: +3m movement speed. When you Execute a Marked enemy, gain +6m movement for 2 turns (stacks with base)

**Choice Node 3 (L19) - Pick 1 of 3:**

**Reap the Storm**
- **Type**: Passive
- **Effect**: Multi-target debuff
- **BG3 Implementation**: When you hit 3+ enemies with a single attack, apply Overwhelmed status on all targets (take +8% damage from you) for 3 turns

**Flurry of Blades**
- **Type**: Passive
- **Effect**: Overpower multi-target
- **BG3 Implementation**: Overpower cleaves to 2 additional nearby targets for 50% damage

**Death Sentence**
- **Type**: Passive
- **Effect**: Execute extends Marked for Execution
- **BG3 Implementation**: When you Execute a target, extend Marked for Execution duration by 3 turns on all marked enemies within 9m

### Slayer - Passives (Auto-Granted)

**Imminent Demise** (L14)
- **Type**: Passive
- **Effect**: Core ability damage increase against Marked targets
- **BG3 Implementation**: Mortal Strike and Overpower deal +25% damage against Marked for Execution targets

**Marked Fury** (L16)
- **Type**: Passive
- **Effect**: Rage generation from Marked targets
- **BG3 Implementation**: Gain +5 Rage when you attack a Marked for Execution target (max 3 procs per turn)

**Unrelenting Onslaught** (L18)
- **Type**: Passive
- **Effect**: Attack speed increase
- **BG3 Implementation**: +10% attack speed while at least 1 enemy is Marked for Execution

**Slayer's Focus** (L20)
- **Type**: Passive
- **Effect**: Your primary target (most recently attacked enemy) focus
- **BG3 Implementation**: Your primary target (most recently attacked enemy) takes +10% damage from you. When you apply Marked for Execution, it's automatically applied to your primary target

### Slayer - Capstone (L20)

**Slayer's Malice**
- **Type**: Passive
- **Effect**: General damage increase further emphasizing Execute and Overpower
- **BG3 Implementation**:
  - Execute deals +30% damage and has +10% chance to apply Marked for Execution
  - Overpower deals +30% damage (Arms-specific capstone effect)
- **Tags**: Passive, Enhancement, Capstone

---

## NOTES FOR BG3 IMPLEMENTATION

### Core Arms Mechanics:
1. **Two-Handed Weapon Focus**: Arms is designed around single 2H weapon
   - Weapon Mastery passive grants bonuses
   - Tactician generates Rage from defensive actions
   - Mortal Strike is primary Rage spender

2. **Rage Economy**:
   - Mortal Strike primary spender (30 Rage)
   - Execute variable spender (20-40 Rage)
   - Skullsplitter/Tactician for generation
   - Colossus Smash high-cost burst (40 Rage)

3. **Execute Phase**: Special mechanics when enemies are low HP
   - Massacre extends Execute range to 35% HP
   - Improved Execute makes it cheaper/stronger
   - Juggernaut applies armor debuff
   - Fatality makes it always crit below 20%

4. **Bleed Mechanics**: Arms has strong DoT focus
   - Mastery: Deep Wounds applies bleeds
   - Rend applies strong bleed
   - Bloodletting increases all bleed damage
   - Warbreaker spreads armor debuff

### Talent Progression Recommendations:
- **Early (L1-7)**: Mortal Strike → Overpower → Rend → Colossus Smash
- **Mid (L8-12)**: Sweeping Strikes, Avatar, Warbreaker
- **Late (L13-20)**: Specialization choice (Colossus vs Slayer) + capstones

### Key Differences from Other Specs:
- Arms focuses on **big single hits and bleeds**
- Fury focuses on **speed and multi-hit**
- Protection focuses on **defense and mitigation**
- Arms has **Mortal Strike (healing reduction)** as signature
- Arms has **tactical Rage generation** from defensive actions
- Arms excels at **sustained single-target damage**

---

**END OF ARMS WARRIOR TALENT EXTRACTION**
