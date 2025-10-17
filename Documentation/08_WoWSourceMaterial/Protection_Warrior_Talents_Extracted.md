# Protection Warrior - Full Talent Extraction for BG3 Mod

**Extracted from Wowhead Guide - The War Within 11.2**

---

## PASSIVES (Auto-granted)

### Mastery: Critical Block
- **Type**: Passive
- **Effect**: Increases block chance and critical block chance, plus attack power
- **BG3 Implementation**: +4% chance to block attacks, +12% chance to critically block (double damage prevented), +8% Attack Power

### Vanguard
- **Type**: Passive  
- **Effect**: Hardened by battle - increased Stamina and Armor based on Strength
- **BG3 Implementation**: +40% Maximum HP, Armor increased by 70% of Strength modifier (so if Str is 18 (+4), gain +2.8 AC, rounds to +3 AC)

---

## SUBCLASS SPEC TALENTS (10 Rows - Protection Talent Tree)

### Row 1
**Ignore Pain (IP)**
- **Type**: Action (Core Defensive Skill)
- **Effect**: Fight through the pain, ignoring damage taken
- **BG3 Implementation**:
  - Bonus Action, Self-buff
  - Effect: Gain damage absorption shield preventing up to 50% of damage taken (max absorption: 30% of max HP)
  - Costs: 40 Rage
  - Duration: Until shield is depleted
  - Multiple casts stack up to 30% max HP total
  - Tags: Defensive, SelfBuff, DamageAbsorption

### Row 2
**Revenge**
- **Type**: Action (Core Offensive AoE Rage Spender)
- **Effect**: Swing in a wide arc dealing Physical damage to all enemies in front
- **BG3 Implementation**:
  - Action, Melee Weapon Attack (cone 3m, 120° arc)
  - Damage: 2d8 + Strength modifier to all targets
  - Costs: 20 Rage (or 0 Rage if you recently dodged/parried)
  - On Dodge/Parry: Chance to make next Revenge cost 0 Rage
  - Tags: MeleeWeapon, AoE, Cone

**Demoralizing Shout (Demo/DS)**
- **Type**: Action (Minor Defensive Cooldown)
- **Effect**: Reduces enemy attack power
- **BG3 Implementation**:
  - Action, AoE Debuff (6m radius)
  - Effect: All enemies deal -20% damage for 4 turns
  - Tags: Debuff, AoE, Intimidation
  - Recharge: Short Rest

### Row 3
**Brace For Impact (BFI)**
- **Type**: Passive (Stacking Buff)
- **Effect**: Block grants stacking buff increasing Shield Slam damage and Block Value
- **BG3 Implementation**: When you block an attack, gain +10% Shield Slam damage and +5% Block Value per stack (max 3 stacks, lasts 5 turns)

**Armor Specialization**
- **Type**: Passive
- **Effect**: Wearing heavy armor increases stats
- **BG3 Implementation**: While wearing Heavy Armor, gain +5% AC

**Best Served Cold (BSC)**
- **Type**: Passive
- **Effect**: Revenge damage increased after dodge/parry
- **BG3 Implementation**: When you dodge or parry an attack, your next Revenge within 2 turns deals +30% damage

**Improved Heroic Throw**
- **Type**: Passive Enhancement
- **Effect**: Heroic Throw can now hit additional targets
- **BG3 Implementation**: Heroic Throw now hits up to 3 targets in a line

### Row 4
**Shield Specialization**
- **Type**: Passive
- **Effect**: Increase block value
- **BG3 Implementation**: Damage reduced from blocked attacks increased by +10%

**Shield Block (Additional Charge)**
- **Type**: Passive
- **Effect**: Grants Shield Block a second charge
- **BG3 Implementation**: Shield Block ability gains +1 charge

**Riposte**
- **Type**: Passive
- **Effect**: Convert Critical Strike to Parry
- **BG3 Implementation**: Gain Parry chance equal to 100% of your Critical Strike chance from equipment

**Seismic Reverberation (Seismic)**
- **Type**: Passive
- **Effect**: Revenge strikes additional time against 3+ targets
- **BG3 Implementation**: When Revenge hits 3 or more targets, it hits all targets a second time for 30% damage

**Concussive Blows**
- **Type**: Passive
- **Effect**: Shield Slam causes additional effects
- **BG3 Implementation**: Shield Slam applies Dazed status (-2 to attack rolls) for 2 turns

**Disrupting Shout**
- **Type**: Passive Enhancement  
- **Effect**: Increases Pummel range
- **BG3 Implementation**: Pummel (interrupt) can now be used at 6m range (instead of melee)

### Row 5
**Last Stand (LS)**
- **Type**: Action (Basic Defensive Cooldown)
- **Effect**: Grants bonus health for duration
- **BG3 Implementation**:
  - Action, Self-buff
  - Effect: Gain Temporary HP equal to 30% of max HP for 5 turns
  - Recharge: Long Rest
  - Tags: Defensive, SelfBuff, TempHP

**Instigate**
- **Type**: Passive
- **Effect**: Demoralizing Shout generates Rage
- **BG3 Implementation**: When you use Demoralizing Shout, gain +20 Rage

**Impending Victory (IV)**
- **Type**: Action (Primary Healing Tool)
- **Effect**: Attack that heals based on missing health
- **BG3 Implementation**:
  - Action, Melee Weapon Attack
  - Damage: 1d10 + Strength modifier
  - Healing: 10% of max HP (or 15% if below 35% HP)
  - Costs: 10 Rage
  - Recharge: Short Rest

**Spell Reflection**
- **Type**: Action (Defensive Cooldown)
- **Effect**: Reflect harmful spells back to caster
- **BG3 Implementation**:
  - Reaction (when targeted by spell)
  - Effect: Reflect spell back to caster, you take no damage
  - Recharge: Short Rest

**Brutal Vitality (BrV)**
- **Type**: Passive
- **Effect**: Grants Leech while Ignore Pain is active
- **BG3 Implementation**: While you have Ignore Pain active, gain Leech 8% (heal for 8% of damage you deal)

**Unnerving Focus**
- **Type**: Passive
- **Effect**: Increases Rage generation while Last Stand active
- **BG3 Implementation**: While Last Stand is active, generate +50% more Rage from all sources

**Bolster**
- **Type**: Passive
- **Effect**: Reduces Last Stand cooldown and grants Shield Block
- **BG3 Implementation**: Last Stand cooldown reduced to 2 minutes (Short Rest), and when used grants 1 charge of Shield Block

**Thunderlord**
- **Type**: Passive
- **Effect**: Thunder Clap slows and costs less
- **BG3 Implementation**: Thunder Clap movement speed reduction increased to 40% (from 20%) and Rage cost reduced by 5

### Row 6
**Heavy Repercussions (HR)**
- **Type**: Passive
- **Effect**: Shield Slam generates more Rage and extends Shield Block duration
- **BG3 Implementation**: Shield Slam generates +2 Rage and extends Shield Block duration by 1 turn (can result in near-permanent Shield Block uptime)

**Into the Fray**
- **Type**: Passive
- **Effect**: Haste buff based on nearby enemies
- **BG3 Implementation**: Gain +2% Haste per enemy within 3m (max +10% from 5 enemies)

**Punish**
- **Type**: Passive
- **Effect**: Shield Slam increases damage and reduces enemy damage
- **BG3 Implementation**: Shield Slam deals +10% damage and causes target to deal -3% damage to you for 3 turns

**Hunker Down / Enduring Alacrity (Choice Node)**
- **Hunker Down**: Passive - Gain +15% damage reduction for 4 turns after using Last Stand
- **Enduring Alacrity**: Passive - Gain +10% Haste for 4 turns after using Last Stand

**Violent Outburst**
- **Type**: Passive
- **Effect**: Shield Slam critical hits create damage explosion
- **BG3 Implementation**: When Shield Slam critically hits, deal 50% of the damage to all enemies within 2m of target

**Strategist**
- **Type**: Passive
- **Effect**: Chance for abilities to reset Shield Slam cooldown
- **BG3 Implementation**: Devastate, Thunder Clap, Revenge, and Execute have 30% chance to reset Shield Slam cooldown

### Row 7
**Enduring Defenses (ED)**
- **Type**: Passive
- **Effect**: Grants 33% more Shield Block uptime
- **BG3 Implementation**: Shield Block duration increased by +2 turns (from 6 to 8 turns)

**Unyielding Stance**
- **Type**: Passive
- **Effect**: Defensive Stance more powerful
- **BG3 Implementation**: While in Defensive Stance, gain additional -5% damage taken

**Defender's Aegis**
- **Type**: Passive
- **Effect**: Shield Wall charges gained from Shield Slam
- **BG3 Implementation**: Each Shield Slam grants 1 stack of Shield Wall (max 3), consuming all stacks reduces next damage taken by 5% per stack

**Focused Vigor (FV)**
- **Type**: Passive
- **Effect**: Rage generation and reduction boost
- **BG3 Implementation**: Generate +15% more Rage from all sources and take -5% damage

**Battering Ram**
- **Type**: Passive
- **Effect**: Charge causes knockdown
- **BG3 Implementation**: Charge now knocks target Prone (Strength Save DC 8 + Prof + Str)

**Barbaric Training**
- **Type**: Passive
- **Effect**: Slam becomes Slam Fury, stronger and Rage efficient  
- **BG3 Implementation**: Slam deals +50% damage and costs -5 Rage

**Show of Force**
- **Type**: Passive
- **Effect**: Pummel instant 3-Rage generation
- **BG3 Implementation**: Successfully interrupting with Pummel generates +3 Rage instantly

### Row 8
**Devastator**
- **Type**: Passive (Replaces Devastate)
- **Effect**: Shield Slam also triggers Devastate automatically
- **BG3 Implementation**: When you use Shield Slam, automatically trigger Devastate (1d6 + Str damage) on the same target at no action cost

**Massacre**
- **Type**: Passive
- **Effect**: Execute available earlier
- **BG3 Implementation**: Execute can be used when target is below 35% HP (instead of 20%)

**Booming Voice**
- **Type**: Passive
- **Effect**: Demoralizing Shout cooldown reduced and generates Rage
- **BG3 Implementation**: Demoralizing Shout cooldown reduced by 30 seconds and generates +20 Rage when used

**Challenging Shout Reduction**
- **Type**: Passive
- **Effect**: Reduces Challenging Shout cooldown to AoE taunt/interrupt
- **BG3 Implementation**: Challenging Shout becomes 90s cooldown AoE taunt (6m radius) with interrupt effect (Wisdom Save DC 8 + Prof + Str)

**Storm of Steel**
- **Type**: Passive
- **Effect**: Ravager second charge
- **BG3 Implementation**: Ravager gains +1 charge

**Sudden Death**
- **Type**: Passive
- **Effect**: Chance to reset Execute and make it free
- **BG3 Implementation**: Auto-attacks have 10% chance to reset Execute cooldown and make next Execute cost 0 Rage

**Juggernaut**
- **Type**: Passive
- **Effect**: Execute reduces armor on target
- **BG3 Implementation**: Execute applies Sundered Armor (-2 AC) for 3 turns

### Row 9
**Shield Charge (SC)**
- **Type**: Action (Offensive Cooldown)
- **Effect**: Charge with shield dealing heavy damage
- **BG3 Implementation**:
  - Action, Charge attack (12m range)
  - Damage: 3d10 + Strength modifier
  - Effect: Knock target back 3m (Strength Save DC 8 + Prof + Str)
  - Generate +20 Rage on hit
  - Recharge: Short Rest

**Ravager (Rav)**
- **Type**: Action
- **Effect**: Summon spinning weapon at location
- **BG3 Implementation**:
  - Action, Summon (9m range, 4m radius AoE)
  - Duration: 5 turns
  - Damage: 2d6 + Strength modifier per turn to all enemies in area
  - Recharge: Long Rest

**Demolish** (Shared with Colossus Specialization - see below)

### Row 10 (Capstone Talents)
**Disrupting Fury**
- **Type**: Passive
- **Effect**: Pummel cooldown reduced
- **BG3 Implementation**: Pummel cooldown reduced by 3 seconds (or gains +1 charge)

**Tough As Nails**
- **Type**: Passive
- **Effect**: Permanent defensive bonus
- **BG3 Implementation**: +5% maximum HP and -5% damage taken from all sources

**Unbreakable Wall**
- **Type**: Passive
- **Effect**: Shield Wall buff from Shield Block
- **BG3 Implementation**: While Shield Block is active, gain Shield Wall effect (-20% damage taken)

**Executioner's Precision**
- **Type**: Passive
- **Effect**: Execute strikes additional targets
- **BG3 Implementation**: Execute now cleaves to 2 additional targets for 50% damage

---

## SUBCLASS BASE ABILITIES (Baseline/Bucket - Granted at L1)

### Offensive Baseline (Choose 1 at L1, more granted as you level)

**Shield Slam (SS)**
- **Type**: Action (Main Offensive Skill)
- **Effect**: Slam target with shield
- **BG3 Implementation**:
  - Action, Melee Weapon Attack
  - Damage: 3d8 + Strength modifier
  - Generate +15 Rage
  - 30% chance to reset cooldown from Devastate/Thunder Clap/Revenge/Execute
  - Tags: MeleeWeapon, Shield, SingleTarget

**Devastate**
- **Type**: Action (Basic Damaging Skill)
- **Effect**: Direct strike with many talent interactions
- **BG3 Implementation**:
  - Action, Melee Weapon Attack
  - Damage: 1d8 + Strength modifier
  - Tags: MeleeWeapon, SingleTarget

**Execute**
- **Type**: Action (Execute Low HP Targets)
- **Effect**: Finish off foe with powerful strike
- **BG3 Implementation**:
  - Action, Melee Weapon Attack
  - Only usable on targets below 20% HP
  - Damage: 4d12 + Strength modifier (scales with Rage spent, up to 40 Rage)
  - Costs: 20-40 Rage (more spent = more damage)
  - Tags: MeleeWeapon, Execute, SingleTarget

**Thunder Clap**
- **Type**: Action (AoE Damage + Slow)
- **Effect**: Blast ground dealing damage and slowing enemies
- **BG3 Implementation**:
  - Action, AoE Attack (4m radius)
  - Damage: 2d6 + Strength modifier to all targets
  - Effect: Reduce movement speed by 20% for 3 turns
  - Costs: 10 Rage
  - If you have Rend, applies Rend to all targets
  - Tags: AoE, Slowing

**Whirlwind**
- **Type**: Action (AoE Spin Attack)
- **Effect**: Unleash whirlwind of steel
- **BG3 Implementation**:
  - Action, AoE Attack (3m radius)
  - Damage: 1d10 + Strength modifier to all targets
  - Tags: AoE, MeleeWeapon

### Defensive Baseline (Choose 1 at L1, more granted as you level)

**Shield Block (SB)**
- **Type**: Action (Primary Defensive Skill)
- **Effect**: Raise shield blocking all melee attacks
- **BG3 Implementation**:
  - Bonus Action, Self-buff
  - Duration: 6 turns (or 8 with Enduring Defenses)
  - Effect: Block all melee attacks (100% block chance), critical blocks possible
  - While active: Shield Slam deals +30% damage
  - Charges: 2 (with talent)
  - Recharge: Short Rest
  - Tags: Defensive, SelfBuff, Block

**Shockwave**
- **Type**: Action (AoE Control)
- **Effect**: Wave of force stunning enemies
- **BG3 Implementation**:
  - Action, AoE Control (cone 10 yards)
  - Effect: Stun all enemies for 2 turns (Constitution Save DC 8 + Prof + Str)
  - Damage: 1d6 + Strength modifier
  - Recharge: Short Rest
  - Tags: AoE, Stun, Control

**Taunt**
- **Type**: Bonus Action (Taunt Enemy)
- **Effect**: Force enemy to attack you
- **BG3 Implementation**:
  - Bonus Action, Single target (9m range)
  - Effect: Target must attack you for 2 turns (Wisdom Save DC 8 + Prof + Str, Disadvantage for creatures)
  - Tags: Taunt, Control

### Utility Baseline (Choose 1 at L1, more granted as you level)

**Battle Shout**
- **Type**: Bonus Action (Party Buff)
- **Effect**: Increase attack power of party
- **BG3 Implementation**:
  - Bonus Action, AoE Buff (9m radius)
  - Effect: +5% damage for all allies for 10 turns
  - Tags: Buff, AoE, Party

**Victory Rush (VR)**
- **Type**: Reaction (Self-Heal After Kill)
- **Effect**: Strike and heal after killing enemy
- **BG3 Implementation**:
  - Reaction (triggered by killing blow within last 20 seconds)
  - Damage: 1d8 + Strength modifier
  - Healing: 10% of max HP
  - Tags: Healing, Reaction

**Heroic Leap**
- **Type**: Action (Jump Attack)
- **Effect**: Leap to location with AoE damage
- **BG3 Implementation**:
  - Action, Jump (12m range)
  - Damage: 1d8 + Strength to all enemies within 3m of landing
  - Recharge: Short Rest
  - Tags: Jump, AoE

**Hamstring**
- **Type**: Action (Slow Enemy)
- **Effect**: Maim enemy reducing movement
- **BG3 Implementation**:
  - Action, Melee Weapon Attack
  - Damage: 1d4 + Strength modifier
  - Effect: Reduce movement speed by 50% for 5 turns
  - Tags: Slow, MeleeWeapon

**Intervene**
- **Type**: Action (Protect Ally)
- **Effect**: Charge to ally and intercept attacks
- **BG3 Implementation**:
  - Action, Charge to ally (12m range)
  - Effect: While within 3m of target ally, you intercept all physical attacks aimed at them for 3 turns
  - Recharge: Short Rest
  - Tags: Protection, Ally

---

## SPECIALIZATION: Mountain Thane (Hero Talent - Choice at L13)

Protection warriors can choose **Mountain Thane** OR **Colossus** at Level 13.

### Mountain Thane - Key Talent (Granted at L13)

**Avatar of the Storm**
- **Type**: Passive Enhancement
- **Effect**: Casting Avatar grants Thunder Blast charges and resets Thunder Clap, plus chance to trigger Avatar from Lightning Strikes
- **BG3 Implementation**: When you activate Avatar, gain 2 charges of Thunder Blast and reset Thunder Clap cooldown. While Avatar is not active, Lightning Strikes have 10% chance to grant Avatar for 4 seconds

### Mountain Thane - Choice Nodes (Granted L13-L20)

**Lightning Strikes (L13)**
- **Type**: Passive
- **Effect**: Thunder Clap, Revenge, or Execute have chance to strike with lightning bolt
- **BG3 Implementation**: Thunder Clap, Revenge, or Execute have 25% chance to also strike one enemy with lightning bolt (1d10 Lightning damage). Occurs 30% more often during Avatar

**Thunder Blast (TB) (L15)**
- **Type**: Passive + Active Enhancement
- **Effect**: Shield Slam has chance to grant Thunder Blast charges
- **BG3 Implementation**: Shield Slam has 35% chance to grant 2 charges of Thunder Blast. Thunder Blast replaces next Thunder Clap with stronger version dealing +40% damage as Stormstrike damage and generating +2 Rage

**Keep Your Feet on the Ground (L18)**
- **Type**: Passive
- **Effect**: Physical damage reduction + Thunder Blast defensive bonus
- **BG3 Implementation**: -2% Physical damage taken. Thunder Blast also reduces damage you take by -8% for 5 turns

**Steadfast as the Peaks (L18)**
- **Type**: Passive
- **Effect**: Stamina increase + Impending Victory/Victory Rush bonus
- **BG3 Implementation**: +5% Stamina (max HP). Impending Victory/Victory Rush increases max HP by +10% for 5 turns. When this expires, heal for any excess healing

### Mountain Thane - Passives (Granted L13-L20)

**Burst of Power** (L13)
- **Type**: Passive
- **Effect**: Lightning Strikes chance to grant free Shield Slams
- **BG3 Implementation**: Lightning Strikes have 15% chance to make next 2 Shield Slams have no cooldown

**Crashing Thunder** (L15)
- **Type**: Passive
- **Effect**: Whirlwind/Revenge hits multiple times against 3+ targets
- **BG3 Implementation**: If Whirlwind or Revenge hits 3+ enemies, it hits them 1 additional time for 30% damage

**Strength of the Mountain** (L18)
- **Type**: Passive
- **Effect**: Shield Slam damage increased, Demoralizing Shout reduces damage more
- **BG3 Implementation**: +15% Shield Slam damage. Demoralizing Shout reduces damage enemies deal by additional -5%

**Gathering Storms** (L20 - Capstone)
- **Type**: Passive
- **Effect**: Lightning damage generates Rage, Revenge/Execute damage increased
- **BG3 Implementation**: Lightning Strikes generate +3 Rage. Revenge and Execute damage increased by +25%

---

## SPECIALIZATION: Colossus (Hero Talent - Alternative Choice at L13)

### Colossus - Key Talent (Granted at L13)

**Demolish**
- **Type**: Action (Key Ability)
- **Effect**: Unleash series of precise powerful strikes
- **BG3 Implementation**:
  - Action, Single target melee attack (3 rapid strikes)
  - Damage: 3 strikes of 3d10 + Strength modifier each
  - Costs: 40 Rage
  - Consumes all stacks of Colossal Might for bonus damage
  - Recharge: Short Rest
  - Tags: MeleeWeapon, MultiHit, SingleTarget

**Colossal Might**
- **Type**: Passive (Stacking Mechanic)
- **Effect**: Increases Demolish damage by 10% per stack (max 5 stacks)
- **BG3 Implementation**: Shield Slam grants 1 stack. Execute grants 1 stack. Revenge grants 1 stack if it hits 3+ targets

### Colossus - Choice Nodes (Granted L13-L20)

**One Against Many (L13)**
- **Type**: Passive
- **Effect**: Shockwave, Revenge, and Whirlwind deal more damage per target affected
- **BG3 Implementation**: Shockwave, Revenge, and Whirlwind deal +3% damage per target affected (max 5 targets = +15%)

**Arterial Bleed (L15)**
- **Type**: Passive
- **Effect**: Colossal Might increases Rend and Deep Wounds damage
- **BG3 Implementation**: +3% Rend and Deep Wounds damage per stack of Colossal Might

**Earthquaker (L15)**
- **Type**: Passive Enhancement
- **Effect**: Shockwave knocks enemies airborne and reduced cooldown
- **BG3 Implementation**: Shockwave also knocks enemies airborne (grants Prone) and cooldown reduced by 5 seconds

**Martial Expert (L18)**
- **Type**: Passive
- **Effect**: Colossal Might increases Revenge damage
- **BG3 Implementation**: +7% Revenge damage per stack of Colossal Might

**Tide of Battle (L18)**
- **Type**: Passive
- **Effect**: Revenge damage scales with Colossal Might stacks
- **BG3 Implementation**: +5% Revenge damage per stack of Colossal Might

### Colossus - Passives (Granted L13-L20)

**No Stranger to Pain** (L13)
- **Type**: Passive
- **Effect**: Ignore Pain prevents more damage
- **BG3 Implementation**: Ignore Pain damage prevention increased by +20%

**Veteran Vitality** (L13)
- **Type**: Passive
- **Effect**: Gain Second Wind when health drops low
- **BG3 Implementation**: When HP drops below 35%, gain Second Wind (heal 12% max HP over 2 turns). Once per 60 seconds

**Practiced Strikes** (L15)
- **Type**: Passive
- **Effect**: Shield Slam and Revenge damage increased
- **BG3 Implementation**: +10% Shield Slam damage, +10% Revenge damage, Shield Slam generates +3 Rage

**Precise Might** (L18)
- **Type**: Passive
- **Effect**: Shield Slam critical strikes grant extra Colossal Might stack
- **BG3 Implementation**: Shield Slam critical hits grant 2 stacks of Colossal Might (instead of 1)

**Mountain of Muscle and Scars** (L20 - Capstone)
- **Type**: Passive
- **Effect**: Deal more damage, take less damage, increased size
- **BG3 Implementation**: +4% damage dealt, -2.5% damage taken, size increased by 5%

---

## NOTES FOR BG3 IMPLEMENTATION

### Core Protection Mechanics:
1. **Tank Role**: Protection is designed as defensive tank
   - Shield Block = primary mitigation tool (6-8 turn duration, near-100% uptime possible)
   - Ignore Pain = absorb shield (stacks up to 30% max HP)
   - Last Stand = emergency HP boost
   - Demoralizing Shout = damage reduction debuff

2. **Rage Economy**:
   - Shield Slam generates Rage (+15, or +17 with talents)
   - Revenge spends Rage (20 cost, or 0 on proc)
   - Ignore Pain spends Rage (40 cost)
   - Execute spends variable Rage (20-40 for scaling damage)
   - Heavy Repercussions enables near-infinite Shield Block by extending duration

3. **Block Mechanics**:
   - Shield Block = 100% block chance while active
   - Critical blocks possible (double mitigation)
   - Talents increase block value, duration, charges
   - Shield Slam damage +30% while Shield Block active

4. **Shield Slam Reset System**:
   - Strategist: 30% chance for Devastate/Thunder Clap/Revenge/Execute to reset Shield Slam
   - This creates reactive gameplay loop

### Talent Progression Recommendations:
- **Early (L1-7)**: Ignore Pain → Revenge → Brace for Impact → Last Stand
- **Mid (L8-12)**: Heavy Repercussions, Enduring Defenses, Shield Charge/Ravager
- **Late (L13-20)**: Specialization choice (Mountain Thane vs Colossus) + capstones

### Key Differences from Other Specs:
- Protection focuses on **defense and mitigation**
- Arms focuses on **big single hits and bleeds**
- Fury focuses on **speed and multi-hit DPS**
- Protection has **Shield Block and Ignore Pain** as core survival tools
- Protection has **Shield Slam as primary Rage generator** (opposite of other specs)
- Protection excels at **AoE threat and control** (Revenge, Thunder Clap, Shockwave)

---

## LOCALIZATION HANDLES NEEDED

### Actions (Spell_Warrior.txt entries):
- ACTION_VORGX_PROT_SHIELDSLAM
- ACTION_VORGX_PROT_DEVASTATE
- ACTION_VORGX_PROT_REVENGE
- ACTION_VORGX_PROT_IGNOREPAIN
- ACTION_VORGX_PROT_DEMOSHOUT
- ACTION_VORGX_PROT_LASTSTAND
- ACTION_VORGX_PROT_IMPENDINGVICTORY
- ACTION_VORGX_PROT_SHIELDBLOCK
- ACTION_VORGX_PROT_SHOCKWAVE
- ACTION_VORGX_PROT_TAUNT
- ACTION_VORGX_PROT_EXECUTE
- ACTION_VORGX_PROT_THUNDERCLAP
- ACTION_VORGX_PROT_WHIRLWIND
- ACTION_VORGX_PROT_BATTLESHOUT
- ACTION_VORGX_PROT_VICTORYRUSH
- ACTION_VORGX_PROT_HEROICLEAP
- ACTION_VORGX_PROT_HAMSTRING
- ACTION_VORGX_PROT_INTERVENE
- ACTION_VORGX_PROT_SPELLREFLECTION
- ACTION_VORGX_PROT_SHIELDCHARGE
- ACTION_VORGX_PROT_RAVAGER
- ACTION_VORGX_PROT_DEMOLISH

### Passives (Passive_Warrior.txt entries):
- PASSIVE_VORGX_PROT_MASTERYCRITICALBLOCK
- PASSIVE_VORGX_PROT_VANGUARD
- PASSIVE_VORGX_PROT_BRACEFORIMPACT
- PASSIVE_VORGX_PROT_ARMORSPECIALIZATION
- PASSIVE_VORGX_PROT_BESTSERVEDCOLD
- PASSIVE_VORGX_PROT_IMPROVEDHEROICTHROW
- PASSIVE_VORGX_PROT_SHIELDSPECIALIZATION
- PASSIVE_VORGX_PROT_SHIELDBLOCKCHARGE
- PASSIVE_VORGX_PROT_RIPOSTE
- PASSIVE_VORGX_PROT_SEISMICREVERBERATION
- PASSIVE_VORGX_PROT_CONCUSSIVEBLOWS
- PASSIVE_VORGX_PROT_DISRUPTINGSHOUT
- PASSIVE_VORGX_PROT_INSTIGATE
- PASSIVE_VORGX_PROT_BRUTALVITALITY
- PASSIVE_VORGX_PROT_UNNERVINGFOCUS
- PASSIVE_VORGX_PROT_BOLSTER
- PASSIVE_VORGX_PROT_THUNDERLORD
- PASSIVE_VORGX_PROT_HEAVYREPERCUSSIONS
- PASSIVE_VORGX_PROT_INTOTHEFRAY
- PASSIVE_VORGX_PROT_PUNISH
- PASSIVE_VORGX_PROT_HUNKERDOWN
- PASSIVE_VORGX_PROT_ENDURINGALACRITY
- PASSIVE_VORGX_PROT_VIOLENTOUTBURST
- PASSIVE_VORGX_PROT_STRATEGIST
- PASSIVE_VORGX_PROT_ENDURINGDEFENSES
- PASSIVE_VORGX_PROT_UNYIELDINGSTANCE
- PASSIVE_VORGX_PROT_DEFENDERSAEGIS
- PASSIVE_VORGX_PROT_FOCUSEDVIGOR
- PASSIVE_VORGX_PROT_BATTERINGRAM
- PASSIVE_VORGX_PROT_BARBARICTRAINING
- PASSIVE_VORGX_PROT_SHOWOFFORCE
- PASSIVE_VORGX_PROT_DEVASTATOR
- PASSIVE_VORGX_PROT_MASSACRE
- PASSIVE_VORGX_PROT_BOOMINGVOICE
- PASSIVE_VORGX_PROT_CHALLENGINGSHOUT
- PASSIVE_VORGX_PROT_STORMOFSTEEL
- PASSIVE_VORGX_PROT_SUDDENDEATH
- PASSIVE_VORGX_PROT_JUGGERNAUT
- PASSIVE_VORGX_PROT_DISRUPTINGFURY
- PASSIVE_VORGX_PROT_TOUGHASNAILS
- PASSIVE_VORGX_PROT_UNBREAKABLEWALL
- PASSIVE_VORGX_PROT_EXECUTIONERSPRECISION

### Mountain Thane Specialization:
- PASSIVE_VORGX_PROT_MT_AVATAROFTHESTORM
- PASSIVE_VORGX_PROT_MT_LIGHTNINGSTRIKES
- PASSIVE_VORGX_PROT_MT_THUNDERBLAST
- PASSIVE_VORGX_PROT_MT_KEEPYOURFEETONTHEGROUND
- PASSIVE_VORGX_PROT_MT_STEADFASTASTHEPEAKS
- PASSIVE_VORGX_PROT_MT_BURSTOFPOWER
- PASSIVE_VORGX_PROT_MT_CRASHINGTHUNDER
- PASSIVE_VORGX_PROT_MT_STRENGTHOFTHEMOUNTAIN
- PASSIVE_VORGX_PROT_MT_GATHERINGSTORMS

### Colossus Specialization:
- ACTION_VORGX_PROT_COL_DEMOLISH
- PASSIVE_VORGX_PROT_COL_COLOSSALMIGHT
- PASSIVE_VORGX_PROT_COL_ONEAGAINSTMANY
- PASSIVE_VORGX_PROT_COL_ARTERIALBLEED
- PASSIVE_VORGX_PROT_COL_EARTHQUAKER
- PASSIVE_VORGX_PROT_COL_MARTIALEXPERT
- PASSIVE_VORGX_PROT_COL_TIDEOFBATTLE
- PASSIVE_VORGX_PROT_COL_NOSTRANGERTOPAIN
- PASSIVE_VORGX_PROT_COL_VETERANVITALITY
- PASSIVE_VORGX_PROT_COL_PRACTICEDSTRIKES
- PASSIVE_VORGX_PROT_COL_PRECISEMIGHT
- PASSIVE_VORGX_PROT_COL_MOUNTAINOFMUSCLEANDSCARS

### Statuses (Status_Warrior.txt entries):
- STATUS_VORGX_PROT_IGNOREPAIN
- STATUS_VORGX_PROT_SHIELDBLOCK
- STATUS_VORGX_PROT_LASTSTAND
- STATUS_VORGX_PROT_DEMOSHOUT
- STATUS_VORGX_PROT_BRACEFORIMPACT
- STATUS_VORGX_PROT_DAZED
- STATUS_VORGX_PROT_STUNNED
- STATUS_VORGX_PROT_SUNDER
- STATUS_VORGX_PROT_TAUNT
- STATUS_VORGX_PROT_HAMSTRING
- STATUS_VORGX_PROT_INTERVENING
- STATUS_VORGX_PROT_COLOSSALMIGHT
- STATUS_VORGX_PROT_MT_AVATAROFTHESTORM
- STATUS_VORGX_PROT_MT_THUNDERBLAST
- STATUS_VORGX_PROT_COL_SECONDWIND

---

**END OF PROTECTION WARRIOR TALENT EXTRACTION**
