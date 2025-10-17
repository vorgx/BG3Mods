# Fury Warrior - Full Talent Extraction for BG3 Mod

**Extracted from Wowhead Guide - The War Within 11.2**

---

## PASSIVES (Auto-granted)

### Titan's Grip (TG)
- **Type**: Passive
- **Effect**: Allows dual wielding two-handed weapons
- **BG3 Implementation**: Passive granted at L1 - allows equipping 2H weapons in offhand slot

### Mastery: Unshackled Fury
- **Type**: Passive
- **Effect**: Passive bonus which scales damage with Mastery
- **BG3 Implementation**: Passive damage scaling +2% per character level

---

## SUBCLASS SPEC TALENTS (10 Rows - Fury Talent Tree)

### Row 1
**Bloodthirst (BT)**
- **Type**: Action (Primary Attack)
- **Effect**: Primary attack which forms the basis of the rotation
- **BG3 Implementation**: 
  - Action, Melee Weapon Attack, 1d10 + Strength modifier
  - On Hit: Heal self for 1d8 HP
  - Costs: 10 Rage (or 0 if using resource generation model)
  - Tags: MeleeWeapon, SingleTarget, Healing
  - Cooldown: None (can be used every turn)

### Row 2
**Raging Blow (RB)**
- **Type**: Action (Primary Attack)
- **Effect**: Primary attack which forms the basis of the rotation
- **BG3 Implementation**:
  - Action, Melee Weapon Attack, 2d8 + Strength modifier
  - Only usable while Enraged
  - Costs: 15 Rage
  - Tags: MeleeWeapon, SingleTarget, RequiresEnrage
  - Can have charges/reset mechanics via talents

### Row 3 (Choice Node)
**Frenzied Enrage**
- **Type**: Passive
- **Effect**: Greatly increases the speed of Fury gameplay
- **BG3 Implementation**: While Enraged, gain +2 Movement Speed and Haste (extra bonus action)

**OR**

**Powerful Enrage**
- **Type**: Passive
- **Effect**: Large damage increase without increasing speed of Fury gameplay
- **BG3 Implementation**: While Enraged, deal +25% weapon damage

**Additional Row 3:**

**Enraged Regeneration (ER)**
- **Type**: Action (Defensive Cooldown)
- **Effect**: Fury's primary defensive cooldown
- **BG3 Implementation**:
  - Action, Heal 3d10 + Constitution modifier over 3 turns
  - Requires Enraged status
  - Duration: 3 turns
  - Recharge: Short Rest

**Improved Execute**
- **Type**: Passive
- **Effect**: Turns Execute into a rage generator
- **BG3 Implementation**: When Execute hits, gain +20 Rage instead of spending it

### Row 4 (Choice Node)
**Improved Bloodthirst**
- **Type**: Passive
- **Effect**: Very small but worthwhile damage increase
- **BG3 Implementation**: Bloodthirst deals +1d4 damage

**OR**

**Fresh Meat**
- **Type**: Passive
- **Effect**: Useful in multi-target situations with frequent enemy deaths
- **BG3 Implementation**: When you kill an enemy, Bloodthirst's cooldown resets and costs 0 Rage for 1 turn

**Additional Row 4:**

**Meat Grinder**
- **Type**: Passive
- **Effect**: Whirlwind now stacks up to two times
- **BG3 Implementation**: Whirlwind buff can stack to 2 charges, allowing 2 cleave attacks

**Cruelty**
- **Type**: Passive
- **Effect**: Notable damage increase, though only while Enraged
- **BG3 Implementation**: While Enraged, critical hit range increased by 1 (19-20)

### Row 5 (Major Unlocks)
**Focus in Chaos**
- **Type**: Passive
- **Effect**: Removes the 19% dual wield miss penalty from auto-attacks
- **BG3 Implementation**: Gain Advantage on all melee attack rolls while dual wielding

**Rampage (Ramp)**
- **Type**: Action (Core Spender)
- **Effect**: The core of Fury's rotation, converting rage into damage and Enrage
- **BG3 Implementation**:
  - Action, Melee Weapon Attack sequence (4 rapid strikes)
  - Damage: 4 attacks of 1d8 + Strength modifier each
  - Costs: 30 Rage
  - Effect: Apply Enraged for 4 turns
  - Tags: MeleeWeapon, MultiHit, AppliesEnrage

**Improved Raging Blow**
- **Type**: Passive
- **Effect**: Critical talent which enables Raging Blow resets
- **BG3 Implementation**: Raging Blow has a 20% chance per hit to reset its cooldown and cost 0 Rage

### Row 6 (Choice Node - Weapon Style)
**Single-Minded Fury**
- **Type**: Passive
- **Effect**: Allows using 1H weapons with damage bonus
- **BG3 Implementation**: When dual wielding 1H weapons, deal +15% damage with all attacks

**Odyn's Bow** (Whirlwind Enhancement)
- **Type**: Passive
- **Effect**: Bloodthirst/Raging Blow benefit from Whirlwind cleave
- **BG3 Implementation**: Bloodthirst and Raging Blow cleave to 1 additional target if Whirlwind buff is active

**Vicious Contempt (VC)**
- **Type**: Passive
- **Effect**: Promotes Bloodthirst playstyles by greatly increasing damage during execute phase
- **BG3 Implementation**: When target is below 35% HP, Bloodthirst deals +50% damage

**Frenzy**
- **Type**: Passive
- **Effect**: Semi-passive haste increase
- **BG3 Implementation**: Each Enraged stack increases attack speed (treat as +5% damage per stack, max 4 stacks)

### Row 7 (Advanced Mechanics)
**Cold Steel, Hot Blood**
- **Type**: Passive
- **Effect**: Bloodthirst critical strike bonus (always crits)
- **BG3 Implementation**: Bloodthirst automatically critical hits every 3rd use

**Hack and Slash (HnS/H&S)**
- **Type**: Passive
- **Effect**: Very important reset mechanic for Raging Blow builds
- **BG3 Implementation**: Auto-attack critical hits have 15% chance to reset Raging Blow cooldown

**Slaughtering Strikes**
- **Type**: Passive
- **Effect**: Significant damage boost for Rampage, emphasizes Raging Blow
- **BG3 Implementation**: Rampage deals +20% damage. Raging Blow grants Slaughtering Strikes status (+10% all damage) for 2 turns

**Ashen Juggernaut**
- **Type**: Passive
- **Effect**: Significant damage boost for Execute, contributes to bleed damage builds
- **BG3 Implementation**: Execute applies Ashen Juggernaut (+2d6 Fire damage per turn) for 3 turns

**Bloodcraze**
- **Type**: Passive
- **Effect**: Strong synergy between Raging Blow and Bloodthirst
- **BG3 Implementation**: Bloodthirst critical hits reduce Raging Blow cost to 0 for 1 turn

**Recklessness (Reck)**
- **Type**: Action (Primary Offensive Cooldown)
- **Effect**: Fury's primary offensive cooldown, greatly increasing rage generation and Rampage frequency
- **BG3 Implementation**:
  - Bonus Action, Self-buff
  - Duration: 3 turns
  - Effect: All attacks automatically critical hit, generate +50% Rage
  - Recharge: Long Rest (or reduced by Anger Management)

**Massacre**
- **Type**: Passive
- **Effect**: Allows more frequent use of Execute
- **BG3 Implementation**: Execute can be used when target is below 35% HP (instead of 20%)

**Wrath and Fury**
- **Type**: Passive
- **Effect**: Moderate damage and reset chance increase for Raging Blow
- **BG3 Implementation**: Raging Blow deals +10% damage and has +10% chance to reset on hit

**Meat Cleaver**
- **Type**: Passive
- **Effect**: Reduces amount of Whirlwind casts needed to maintain multitarget cleave
- **BG3 Implementation**: Whirlwind buff lasts 2 extra turns

### Row 8 (Cooldown Management)
**Raging Armaments**
- **Type**: Passive
- **Effect**: Minor mastery buff with important Enrage extension
- **BG3 Implementation**: Rampage extends Enrage duration by 2 turns

**Swift Strikes**
- **Type**: Passive
- **Effect**: Minor haste buff with small rage generation increase
- **BG3 Implementation**: While Enraged, gain +1 Rage per turn

**Onslaught**
- **Type**: Action (Execute Alternative)
- **Effect**: Powerful Execute-phase attack
- **BG3 Implementation**:
  - Action, Melee Weapon Attack (3 rapid strikes)
  - Only usable on targets below 35% HP
  - Damage: 3d10 + Strength modifier per strike
  - Costs: 25 Rage
  - Recharge: Short Rest

**Anger Management (AM)**
- **Type**: Passive
- **Effect**: Reduces Recklessness cooldown by spending Rage
- **BG3 Implementation**: Spending 20 Rage reduces Recklessness cooldown by 1 turn

**Reckless Abandon (RA)**
- **Type**: Passive (Recklessness Enhancement)
- **Effect**: Bloodthirst and Raging Blow become stronger during Recklessness
- **BG3 Implementation**: During Recklessness, Bloodthirst becomes Bloodbath (+2d8 damage) and Raging Blow becomes Crushing Blow (+2d10 damage)

**Bladestorm (BS)**
- **Type**: Action (Premier AoE)
- **Effect**: Premier multitarget damage ability, 4s duration, generates large Rage for Fury
- **BG3 Implementation**:
  - Action, AoE Attack
  - Attack all enemies within 3m for 4 turns
  - Damage: 2d8 + Strength modifier per turn
  - Generate +15 Rage per enemy hit per turn
  - Recharge: Long Rest

**Ravager (Rav)**
- **Type**: Action (Alternative to Bladestorm)
- **Effect**: Strong passive damage alternative to Bladestorm, more suitable for single target
- **BG3 Implementation**:
  - Action, Summon weapon at target location
  - Weapon attacks all enemies within 4m for 5 turns
  - Damage: 2d6 + Strength modifier per turn
  - Recharge: Long Rest

**Odyn's Fury (OF)**
- **Type**: Action (Burst Damage)
- **Effect**: Very powerful burst damage attack with short lingering bleed
- **BG3 Implementation**:
  - Action, AoE Attack (cone 9m)
  - Damage: 4d10 + Strength modifier
  - Apply Bleeding (1d8 damage per turn) for 3 turns
  - Costs: 25 Rage
  - Recharge: Short Rest

### Row 9 (Choice Node)
**Bloodborne**
- **Type**: Passive
- **Effect**: Bleeding damage increase
- **BG3 Implementation**: Bleeding effects you apply deal +25% damage

**Crushing Force**
- **Type**: Passive
- **Effect**: Strength boost during Rampage
- **BG3 Implementation**: After using Rampage, gain +2 Strength for 4 turns

### Row 10 (Capstone Talents)
**Tenderize**
- **Type**: Passive
- **Effect**: Greatly increases value of Onslaught and Rampage damage
- **BG3 Implementation**: Onslaught applies Tenderized status (enemies take +15% damage from all sources) for 3 turns

**Unhinged**
- **Type**: Passive
- **Effect**: Deceptively powerful bonus during Bladestorm or Ravager
- **BG3 Implementation**: During Bladestorm or Ravager, deal +30% damage with all attacks

**Storm of Steel**
- **Type**: Passive
- **Effect**: Gives Ravager a second charge
- **BG3 Implementation**: Ravager gains +1 charge (can be used twice per Long Rest)

**Dancing Blades**
- **Type**: Passive
- **Effect**: Randomly triggers Recklessness with low proc chance
- **BG3 Implementation**: 5% chance on melee hit to trigger free Recklessness for 2 turns (no cooldown consumed)

---

## SUBCLASS BASE ABILITIES (Baseline/Bucket - Granted at L1)

These are abilities available immediately when choosing Fury spec, separate from talent rows:

### Offensive Baseline (Choose 1 at L1, more granted as you level)

**Whirlwind**
- **Type**: Action
- **Effect**: AoE attack that enables cleave
- **BG3 Implementation**:
  - Action, Melee Weapon Attack (cone 3m)
  - Damage: 1d8 + Strength modifier to all targets
  - Apply Whirlwind buff: Next 2 single-target attacks cleave to 1 additional target
  - Costs: 10 Rage

**Execute**
- **Type**: Action
- **Effect**: Execute low-HP targets
- **BG3 Implementation**:
  - Action, Melee Weapon Attack
  - Only usable on targets below 20% HP
  - Damage: 4d12 + Strength modifier
  - Costs: 20 Rage

**Piercing Howl**
- **Type**: Action
- **Effect**: AoE slow/control
- **BG3 Implementation**:
  - Bonus Action, AoE Control (6m radius)
  - Apply Slowed status to all enemies (movement -50%) for 2 turns
  - Costs: 10 Rage

**Slam**
- **Type**: Action
- **Effect**: Simple damage + Rage spender
- **BG3 Implementation**:
  - Action, Melee Weapon Attack
  - Damage: 2d6 + Strength modifier
  - Costs: 15 Rage

### Utility Baseline (Choose 1 at L1, more granted as you level)

**Victory Rush**
- **Type**: Reaction
- **Effect**: Heal after killing an enemy
- **BG3 Implementation**:
  - Reaction (triggered by killing blow)
  - Heal self for 2d10 + Constitution modifier
  - Costs: 0 Rage

**Intimidating Shout**
- **Type**: Action
- **Effect**: Fear nearby enemies
- **BG3 Implementation**:
  - Action, AoE Control (4m radius)
  - Apply Frightened to all enemies (Wisdom Save DC 8 + Prof + Str) for 3 turns
  - Costs: 10 Rage
  - Recharge: Short Rest

**Rallying Cry**
- **Type**: Bonus Action
- **Effect**: Party-wide healing
- **BG3 Implementation**:
  - Bonus Action, AoE Heal (9m radius)
  - All allies gain Temp HP equal to 2d8 + your level
  - Recharge: Short Rest

**Battle Shout**
- **Type**: Bonus Action
- **Effect**: Party-wide damage buff
- **BG3 Implementation**:
  - Bonus Action, AoE Buff (9m radius)
  - All allies gain +2 to attack rolls and damage rolls for 5 turns
  - Recharge: Short Rest

**Heroic Leap**
- **Type**: Action
- **Effect**: Jump to location with AoE damage
- **BG3 Implementation**:
  - Action, Jump (12m range)
  - Land at target location, deal 1d8 + Strength to all enemies within 3m
  - Costs: 10 Rage
  - Recharge: Short Rest

---

## SPECIALIZATION: Mountain Thane (Hero Talent - Choice at L13)

Fury warriors can choose **Mountain Thane** OR **Slayer** at Level 13.

### Mountain Thane - Key Talent (Granted at L13)

**Avatar of the Storm**
- **Type**: Passive Enhancement
- **Effect**: Enhances Avatar cooldown with lightning theme
- **BG3 Implementation**: When you activate Avatar, gain Avatar of the Storm status: Lightning bursts deal 1d8 Lightning damage to all enemies within 3m every turn for Avatar's duration

### Mountain Thane - Choice Nodes (Granted L13-L20)

**Lightning Strikes (L13)**
- **Type**: Passive
- **Effect**: Auto-attacks during Avatar trigger lightning
- **BG3 Implementation**: While Avatar active, melee attacks have 30% chance to deal bonus 1d6 Lightning damage to target + all enemies within 2m

**Thunder Blast (L15)**
- **Type**: Passive Enhancement
- **Effect**: Stronger version of Thunder Clap that ignores armor
- **BG3 Implementation**: Thunder Clap ignores enemy AC bonuses from armor/shields and deals +1d6 damage

**Burst of Power (L18)**
- **Type**: Passive
- **Effect**: Makes Bloodthirst better
- **BG3 Implementation**: Bloodthirst gains +1d8 damage and heals for an additional 1d6

### Mountain Thane - Passives (Granted L13-L20)

**Crashing Thunder** (L13)
- **Type**: Passive
- **Effect**: Thunder Clap damage increase
- **BG3 Implementation**: Thunder Clap deals +50% damage

**Ground Current** (L15)
- **Type**: Passive
- **Effect**: Lightning damage spreads
- **BG3 Implementation**: When you deal Lightning damage, it chains to 1 additional nearby enemy (50% damage)

**Thorim's Might** (L18)
- **Type**: Passive
- **Effect**: Strength increase during Avatar
- **BG3 Implementation**: While Avatar active, gain +4 Strength

**Gathering Storms** (L20)
- **Type**: Passive (Capstone)
- **Effect**: Stacking damage buff during Avatar
- **BG3 Implementation**: While Avatar active, gain +5% damage per turn (stacks up to 50%)

---

## SPECIALIZATION: Slayer (Hero Talent - Alternative Choice at L13)

### Slayer - Key Talent (Granted at L13)

**Slayer's Dominance**
- **Type**: Passive
- **Effect**: Frequent random single-target damage proc that inflicts Marked for Execution
- **BG3 Implementation**: 15% chance on melee hit to deal bonus 2d8 damage and apply Marked for Execution status (target takes +10% damage from Execute and takes +1d6 damage from your attacks) for 4 turns

### Slayer - Choice Nodes (Granted L13-L20)

**Brutal Finish (L13)**
- **Type**: Passive
- **Effect**: Execute damage increase when Marked
- **BG3 Implementation**: Execute deals +50% damage against Marked for Execution targets

**Overwhelming Blades (L15)**
- **Type**: Passive
- **Effect**: Multi-target Marked for Execution spread
- **BG3 Implementation**: When you apply Marked for Execution, it spreads to 1 additional nearby enemy (within 3m)

**Opportunist (L18)**
- **Type**: Passive
- **Effect**: Low value due to relying on Raging Blow resets
- **BG3 Implementation**: When Raging Blow resets its cooldown, it deals +1d8 damage on next use

### Slayer - Passives (Granted L13-L20)

**Imminent Demise** (L13)
- **Type**: Passive
- **Effect**: Rampage damage increase against Marked targets
- **BG3 Implementation**: Rampage deals +25% damage against Marked for Execution targets

**Culling Cyclone** (L15)
- **Type**: Passive
- **Effect**: Whirlwind benefit from Marked
- **BG3 Implementation**: Whirlwind deals +1d6 damage per Marked for Execution enemy hit

**Show No Mercy** (L18)
- **Type**: Passive
- **Effect**: Damage increase tied to Marked for Execution and Sudden Death procs
- **BG3 Implementation**: Attacks against Marked for Execution targets have critical hit range increased by 1 (19-20)

**Reap the Storm** (L18)
- **Type**: Passive
- **Effect**: Minor damage contributor for Overwhelmed status
- **BG3 Implementation**: When you hit 3+ enemies with a single attack, apply Overwhelmed status on all targets (take +5% damage from you) for 3 turns

**Slayer's Malice** (L20 - Capstone)
- **Type**: Passive
- **Effect**: General damage increase further emphasizing Raging Blow
- **BG3 Implementation**: Raging Blow deals +30% damage and has +10% chance to apply Marked for Execution

---

## NOTES FOR BG3 IMPLEMENTATION

### Core Fury Mechanics:
1. **Enrage System**: Central to Fury rotation
   - Applied by Rampage (30 Rage cost, 4-turn duration)
   - Many abilities require or benefit from Enrage
   - Talents extend/enhance Enrage

2. **Dual Wield Focus**: Fury is designed around dual wielding
   - Titan's Grip allows 2H weapons in both hands
   - Single-Minded Fury allows 1H dual wield alternative
   - Focus in Chaos removes dual wield penalties

3. **Rage Economy**:
   - Rampage is the primary Rage spender (30 Rage)
   - Bloodthirst generates Rage (or heals)
   - Raging Blow spends Rage (15) but has reset mechanics
   - Cooldowns like Bladestorm generate massive Rage

4. **Execute Phase**: Special mechanics when enemies are low HP
   - Massacre extends Execute range to 35% HP
   - Vicious Contempt boosts Bloodthirst damage during execute
   - Onslaught provides alternative execute option

### Talent Progression Recommendations:
- **Early (L1-7)**: Bloodthirst → Raging Blow → Rampage unlocks
- **Mid (L8-12)**: Recklessness, Bladestorm/Ravager/Odyn's Fury
- **Late (L13-20)**: Specialization choice (Mountain Thane vs Slayer) + capstones

### Key Differences from Arms:
- Fury focuses on **speed and multi-hit** (Rampage, Bladestorm)
- Arms focuses on **big single hits** (Mortal Strike, Overpower)
- Fury has **Enrage mechanic** as core resource
- Arms has **Rage generation on defensive actions**
- Fury has **2H dual wield** option
- Arms has **shield/2H single weapon** focus

---

## LOCALIZATION HANDLES NEEDED

### Actions (Spell_Warrior.txt entries):
- ACTION_VORGX_FURY_BLOODTHIRST
- ACTION_VORGX_FURY_RAGINGBLOW
- ACTION_VORGX_FURY_RAMPAGE
- ACTION_VORGX_FURY_RECKLESSNESS
- ACTION_VORGX_FURY_BLADESTORM
- ACTION_VORGX_FURY_RAVAGER
- ACTION_VORGX_FURY_ODYNSFURY
- ACTION_VORGX_FURY_ONSLAUGHT
- ACTION_VORGX_FURY_WHIRLWIND
- ACTION_VORGX_FURY_EXECUTE
- ACTION_VORGX_FURY_PIERCINHOWL
- ACTION_VORGX_FURY_SLAM
- ACTION_VORGX_FURY_VICTORYRUSH
- ACTION_VORGX_FURY_INTIMIDATINGSHOUT
- ACTION_VORGX_FURY_RALLYINGCRY
- ACTION_VORGX_FURY_BATTLESHOUT
- ACTION_VORGX_FURY_HEROICLEAP
- ACTION_VORGX_FURY_ENRAGEDREGENERATION

### Passives (Passive_Warrior.txt entries):
- PASSIVE_VORGX_FURY_TITANSGRIP
- PASSIVE_VORGX_FURY_MASTERYUNSHACKLEDFURY
- PASSIVE_VORGX_FURY_FRENZIEDENRAGE
- PASSIVE_VORGX_FURY_POWERFULENRAGE
- PASSIVE_VORGX_FURY_IMPROVEDEXECUTE
- PASSIVE_VORGX_FURY_IMPROVEDBLOODTHIRST
- PASSIVE_VORGX_FURY_FRESHMEAT
- PASSIVE_VORGX_FURY_MEATGRINDER
- PASSIVE_VORGX_FURY_CRUELTY
- PASSIVE_VORGX_FURY_FOCUSINCHAOS
- PASSIVE_VORGX_FURY_IMPROVEDRAGINGBLOW
- PASSIVE_VORGX_FURY_SINGLEMINDEDFURY
- PASSIVE_VORGX_FURY_VICIOUSCONTEMPT
- PASSIVE_VORGX_FURY_FRENZY
- PASSIVE_VORGX_FURY_COLDSTEELHOTBLOOD
- PASSIVE_VORGX_FURY_HACKANDSLASH
- PASSIVE_VORGX_FURY_SLAUGHTERINGSTRIKES
- PASSIVE_VORGX_FURY_ASHENJUGGERNAUT
- PASSIVE_VORGX_FURY_BLOODCRAZE
- PASSIVE_VORGX_FURY_MASSACRE
- PASSIVE_VORGX_FURY_VRATHANDFURY
- PASSIVE_VORGX_FURY_MEATCLEAVER
- PASSIVE_VORGX_FURY_RAGINGARMAMENTS
- PASSIVE_VORGX_FURY_SWIFTSTRIKES
- PASSIVE_VORGX_FURY_ANGERMANAGEMENT
- PASSIVE_VORGX_FURY_RECKLESSABANDON
- PASSIVE_VORGX_FURY_BLOODBORNE
- PASSIVE_VORGX_FURY_CRUSHINGFORCE
- PASSIVE_VORGX_FURY_TENDERIZE
- PASSIVE_VORGX_FURY_UNHINGED
- PASSIVE_VORGX_FURY_STORMOFSTEEL
- PASSIVE_VORGX_FURY_DANCINGBLADES

### Mountain Thane Specialization:
- PASSIVE_VORGX_FURY_MT_AVATAROFTHESTORM
- PASSIVE_VORGX_FURY_MT_LIGHTNINGSTRIKES
- PASSIVE_VORGX_FURY_MT_THUNDERBLAST
- PASSIVE_VORGX_FURY_MT_BURSTOFPOWER
- PASSIVE_VORGX_FURY_MT_CRASHINGTHUNDER
- PASSIVE_VORGX_FURY_MT_GROUNDCURRENT
- PASSIVE_VORGX_FURY_MT_THORIMSMIGHT
- PASSIVE_VORGX_FURY_MT_GATHERINGSTORMS

### Slayer Specialization:
- PASSIVE_VORGX_FURY_SLAYER_SLAYERSDOMINANCE
- PASSIVE_VORGX_FURY_SLAYER_BRUTALFINISH
- PASSIVE_VORGX_FURY_SLAYER_OVERWHELMINGBLADES
- PASSIVE_VORGX_FURY_SLAYER_OPPORTUNIST
- PASSIVE_VORGX_FURY_SLAYER_IMMINENTDEMISE
- PASSIVE_VORGX_FURY_SLAYER_CULLINGCYCLONE
- PASSIVE_VORGX_FURY_SLAYER_SHOWNOMERCY
- PASSIVE_VORGX_FURY_SLAYER_REAPTHESTORM
- PASSIVE_VORGX_FURY_SLAYER_SLAYERSMALICE

### Statuses (Status_Warrior.txt entries):
- STATUS_VORGX_FURY_ENRAGED
- STATUS_VORGX_FURY_RECKLESSNESS
- STATUS_VORGX_FURY_WHIRLWIND
- STATUS_VORGX_FURY_SLAUGHTERINGSTRIKES
- STATUS_VORGX_FURY_ASHENJUGGERNAUT
- STATUS_VORGX_FURY_BLOODBATH (Reckless Abandon version)
- STATUS_VORGX_FURY_CRUSHINGBLOW (Reckless Abandon version)
- STATUS_VORGX_FURY_TENDERIZED
- STATUS_VORGX_FURY_MT_AVATAROFTHESTORM
- STATUS_VORGX_FURY_SLAYER_MARKEDFOREXECUTION
- STATUS_VORGX_FURY_SLAYER_OVERWHELMED

---

**END OF FURY WARRIOR TALENT EXTRACTION**
