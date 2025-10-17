# Warrior Ability Design Framework
**Version**: 2.0  
**Date**: October 16, 2025  
**Purpose**: Complete reference for ability design, validation, and tagging

---

## TABLE OF CONTENTS
1. [Ability Categories & Tags](#ability-categories--tags)
2. [WoW Cooldown Reference](#wow-cooldown-reference)
3. [Validation Checklist](#validation-checklist)
4. [Tooltip Enhancement Guide](#tooltip-enhancement-guide)
5. [Heroic Strike Analysis](#heroic-strike-analysis)

---

## ABILITY CATEGORIES & TAGS

### Tag System Overview
Every ability should have multiple tags for filtering, tooltips, and gameplay clarity:

#### Primary Category (Required - Choose ONE)
- **DAMAGE** - Primary purpose is dealing damage
- **HEALING** - Primary purpose is healing/recovery
- **UTILITY** - Primary purpose is utility (movement, control, buffs)
- **DEFENSIVE** - Primary purpose is damage reduction/survival
- **GENERATOR** - Primary purpose is Rage generation
- **SPENDER** - Primary purpose is Rage spending

#### Delivery Method (Required - Choose ONE)
- **SingleTarget** - Affects one enemy
- **AoE** - Affects multiple enemies in area
- **Cone** - Cone-shaped AoE
- **Line** - Line-shaped AoE
- **SelfBuff** - Affects only self
- **PartyBuff** - Affects allies

#### Damage Type (If applicable)
- **MeleeWeapon** - Uses weapon damage
- **Ranged** - Ranged attack
- **Magical** - Magical damage
- **Bleed** - Bleeding damage over time
- **Thunder** - Thunder/Lightning damage

#### Special Mechanics (Optional - Multiple allowed)
- **HealingReduction** - Reduces healing received
- **ArmorPierce** - Ignores armor
- **ArmorReduction** - Reduces target AC
- **Slow** - Reduces movement
- **Stun** - Stuns target
- **Fear** - Causes fear
- **Silence** - Silences target
- **Execute** - Only usable on low HP targets
- **Cleave** - Hits additional targets
- **DoT** - Damage over time
- **Channel** - Channeled ability
- **Jump** - Movement via jump
- **Charge** - Movement via charge/rush
- **RequiresEnrage** - Only usable while Enraged
- **OnKill** - Triggers on kill

#### Action Economy (Required - Choose ONE)
- **Action** - Costs main Action
- **BonusAction** - Costs Bonus Action
- **Reaction** - Costs Reaction
- **Passive** - Always active

#### Cooldown Band (Required)
- **None** - No cooldown (spammable)
- **OncePerTurn** - Can use once per turn
- **ShortRest** - Recharges on Short Rest
- **LongRest** - Recharges on Long Rest

---

## ABILITY CATEGORIZATION MATRIX

### Baseline Warrior Abilities (19 Total)

| Ability | Primary | Delivery | Action | Cooldown | Secondary Tags |
|---------|---------|----------|--------|----------|----------------|
| **Heroic Strike** | GENERATOR | SingleTarget | BonusAction | None | MeleeWeapon |
| **Slam** | SPENDER | SingleTarget | Action | OncePerTurn | MeleeWeapon, DAMAGE |
| **Charge** | UTILITY | SingleTarget | Action | None | MeleeWeapon, Charge |
| **Execute** | SPENDER | SingleTarget | Action | None | MeleeWeapon, Execute, DAMAGE |
| **Whirlwind** | SPENDER | AoE | Action | None | MeleeWeapon, Cleave, DAMAGE |
| **Thunder Clap** | SPENDER | AoE | Action | None | Thunder, Slow, DAMAGE |
| **Shockwave** | UTILITY | Cone | Action | ShortRest | Stun, DAMAGE |
| **Hamstring** | UTILITY | SingleTarget | BonusAction | None | MeleeWeapon, Slow |
| **Victory Rush** | HEALING | SingleTarget | BonusAction | None | MeleeWeapon, OnKill, DAMAGE |
| **Pummel** | UTILITY | SingleTarget | BonusAction | OncePerTurn | MeleeWeapon, Silence |
| **Heroic Throw** | UTILITY | SingleTarget | Action | OncePerTurn | Ranged, MeleeWeapon |
| **Storm Bolt** | UTILITY | SingleTarget | Action | ShortRest | Ranged, Stun, Thunder, DAMAGE |
| **Berserker Rage** | UTILITY | SelfBuff | BonusAction | ShortRest | Defensive |
| **Die by the Sword** | DEFENSIVE | SelfBuff | BonusAction | LongRest | |
| **Spell Reflection** | DEFENSIVE | SelfBuff | BonusAction | LongRest | |
| **Battle Shout** | UTILITY | PartyBuff | BonusAction | None | |
| **Rallying Cry** | HEALING | PartyBuff | Action | None | |
| **Intimidating Shout** | UTILITY | AoE | Action | None | Fear, SPENDER |
| **Heroic Leap** | UTILITY | AoE | Action | LongRest | Jump, DAMAGE |

### Arms Warrior Abilities (10 Total)

| Ability | Primary | Delivery | Action | Cooldown | Secondary Tags |
|---------|---------|----------|--------|----------|----------------|
| **Mortal Strike** | SPENDER | SingleTarget | Action | OncePerTurn | MeleeWeapon, HealingReduction, DAMAGE |
| **Overpower** | SPENDER | SingleTarget | BonusAction | None | MeleeWeapon, ArmorPierce, DAMAGE |
| **Rend** | SPENDER | SingleTarget | Action | None | MeleeWeapon, Bleed, DoT, DAMAGE |
| **Skullsplitter** | GENERATOR | SingleTarget | BonusAction | OncePerTurn | MeleeWeapon, DAMAGE |
| **Colossus Smash** | SPENDER | SingleTarget | Action | ShortRest | MeleeWeapon, ArmorReduction, DAMAGE |
| **Warbreaker** | SPENDER | Cone | Action | LongRest | MeleeWeapon, ArmorReduction, DAMAGE |
| **Bladestorm** | SPENDER | AoE | Action | LongRest | MeleeWeapon, Channel, DAMAGE |
| **Avatar** | UTILITY | SelfBuff | BonusAction | LongRest | GENERATOR |
| **Sweeping Strikes** | UTILITY | SelfBuff | BonusAction | ShortRest | Cleave |
| **Deadly Calm** | UTILITY | SelfBuff | BonusAction | ShortRest | |

### Fury Warrior Abilities (8 Planned)

| Ability | Primary | Delivery | Action | Cooldown | Secondary Tags |
|---------|---------|----------|--------|----------|----------------|
| **Bloodthirst** | GENERATOR | SingleTarget | Action | None | MeleeWeapon, HEALING, DAMAGE |
| **Raging Blow** | SPENDER | SingleTarget | Action | None | MeleeWeapon, RequiresEnrage, DAMAGE |
| **Rampage** | SPENDER | SingleTarget | Action | None | MeleeWeapon, MultiStrike, DAMAGE |
| **Recklessness** | UTILITY | SelfBuff | BonusAction | LongRest | GENERATOR |
| **Enraged Regeneration** | HEALING | SelfBuff | Action | ShortRest | RequiresEnrage, DoT |
| **Onslaught** | SPENDER | SingleTarget | Action | ShortRest | MeleeWeapon, Execute, MultiStrike, DAMAGE |
| **Ravager** | SPENDER | AoE | Action | LongRest | Summon, DoT, DAMAGE |
| **Odyn's Fury** | SPENDER | Cone | Action | ShortRest | Thunder, Bleed, DAMAGE |

### Protection Warrior Abilities (9 Planned)

| Ability | Primary | Delivery | Action | Cooldown | Secondary Tags |
|---------|---------|----------|--------|----------|----------------|
| **Shield Slam** | GENERATOR | SingleTarget | Action | None | MeleeWeapon, DAMAGE |
| **Devastate** | SPENDER | SingleTarget | Action | None | MeleeWeapon, ArmorReduction, DAMAGE |
| **Revenge** | SPENDER | Cone | Action | None | MeleeWeapon, DAMAGE |
| **Shield Block** | DEFENSIVE | SelfBuff | BonusAction | ShortRest | |
| **Ignore Pain** | DEFENSIVE | SelfBuff | BonusAction | None | SPENDER |
| **Demoralizing Shout** | UTILITY | AoE | Action | ShortRest | Debuff |
| **Last Stand** | DEFENSIVE | SelfBuff | BonusAction | LongRest | HEALING |
| **Taunt** | UTILITY | SingleTarget | BonusAction | OncePerTurn | |
| **Shield Charge** | UTILITY | SingleTarget | Action | ShortRest | Charge, Stun, DAMAGE |

---

## WOW COOLDOWN REFERENCE

### Cooldown Conversion Guide
**WoW → BG3 Mapping**:
- **No CD / GCD only** → None (spammable in BG3)
- **≤6 seconds** → Once per Turn
- **6-45 seconds** → Once per Short Rest
- **45+ seconds / 1-3 minutes** → Once per Long Rest

### Complete Cooldown List from WoW Sources

#### Baseline Abilities
| Ability | WoW Cooldown | BG3 Cooldown | Source |
|---------|--------------|--------------|--------|
| Charge | 20s (can have charges) | None | Gap closer spam OK in BG3 |
| Heroic Strike | None (auto-attack replacement) | None | Rage generator |
| Slam | None (GCD only) | Once per Turn | Prevent spam |
| Execute | None (GCD only) | None | Conditional usage |
| Whirlwind | None (GCD only) | None | Rage cost gates it |
| Thunder Clap | 6s | None | Rage cost sufficient |
| Shockwave | 40s | Short Rest | Major CC |
| Hamstring | None (GCD only) | None | Minor utility |
| Victory Rush | 20s (kill trigger) | None (kill trigger) | Kill-gated |
| Pummel | 15s | Once per Turn | Interrupt |
| Heroic Throw | 6s | Once per Turn | Ranged poke |
| Storm Bolt | 30s | Short Rest | Ranged stun |
| Berserker Rage | 60s | Short Rest | CC break |
| Die by the Sword | 3 min | Long Rest | Major defensive |
| Spell Reflection | 25s | Long Rest | Powerful in BG3 |
| Battle Shout | 60s | None | Long duration justifies |
| Rallying Cry | 3 min | None | Action cost sufficient |
| Intimidating Shout | 90s | None | Rage cost + Action |
| Heroic Leap | 45s | Long Rest | Major mobility |

#### Arms Spec Abilities
| Ability | WoW Cooldown | BG3 Cooldown | Source |
|---------|--------------|--------------|--------|
| Mortal Strike | 6s | Once per Turn | Arms_Warrior line 32 |
| Overpower | 12s (charges) | None | Rage cost gates |
| Rend | None (GCD only) | None | DoT application |
| Skullsplitter | 21s | Once per Turn | Arms_Warrior line 78 |
| Colossus Smash | 45s | Short Rest | Arms_Warrior line 110 |
| Warbreaker | 45s | Long Rest | Arms_Warrior line 120 |
| Bladestorm | 90s | Long Rest | Arms_Warrior line 158 |
| Avatar | 90s | Long Rest | Arms_Warrior line 194 |
| Sweeping Strikes | 30s | Short Rest | Burst window |
| Deadly Calm | 60s | Short Rest | Arms_Warrior line 257 |

#### Fury Spec Abilities
| Ability | WoW Cooldown | BG3 Cooldown | Source |
|---------|--------------|--------------|--------|
| Bloodthirst | 4.5s | None | Fury_Warrior - primary rotation |
| Raging Blow | None (GCD only) | None | Fury_Warrior - primary rotation |
| Rampage | None (GCD only) | None | Rage cost + requires Enrage |
| Recklessness | 90s | Long Rest | Major offensive CD |
| Enraged Regeneration | 120s | Short Rest | Major defensive CD |
| Onslaught | 12s | Short Rest | Execute-phase burst |
| Ravager | 45s | Long Rest | AoE ultimate |
| Odyn's Fury | 45s | Short Rest | AoE burst |

#### Protection Spec Abilities
| Ability | WoW Cooldown | BG3 Cooldown | Source |
|---------|--------------|--------------|--------|
| Shield Slam | 9s | None | Prot primary attack |
| Devastate | None (GCD only) | None | Filler attack |
| Revenge | None (GCD only) | None | Rage spender |
| Shield Block | 16s (charges) | Short Rest | Major defensive |
| Ignore Pain | None (GCD only) | None | Rage spender |
| Demoralizing Shout | 60s | Short Rest | Debuff CD |
| Last Stand | 3 min | Long Rest | Major defensive |
| Taunt | 8s | Once per Turn | Tank mechanic |
| Shield Charge | 45s | Short Rest | Gap closer + stun |

---

## VALIDATION CHECKLIST

### Pre-Implementation Checklist
Use this BEFORE creating any ability:

#### 1. WoW Source Verification ✓
- [ ] Read WoW source documentation for ability
- [ ] Note exact damage values, costs, and effects
- [ ] Record cooldown from WoW (if any)
- [ ] Identify primary purpose (damage, healing, utility, defensive)
- [ ] List all secondary effects (debuffs, buffs, movement)

#### 2. Category Assignment ✓
- [ ] Assign Primary Category (DAMAGE/HEALING/UTILITY/DEFENSIVE/GENERATOR/SPENDER)
- [ ] Assign Delivery Method (SingleTarget/AoE/Cone/Line/SelfBuff/PartyBuff)
- [ ] Assign Action Economy (Action/BonusAction/Reaction/Passive)
- [ ] Assign Cooldown Band (None/OncePerTurn/ShortRest/LongRest)
- [ ] List all applicable Secondary Tags

#### 3. BG3 Adaptation Planning ✓
- [ ] Convert damage to BG3 dice format (compare to similar abilities)
- [ ] Convert cooldown using WoW→BG3 mapping
- [ ] Determine Rage cost (10/15/20/25/30/40)
- [ ] Plan status effects and durations
- [ ] Consider action economy balance

#### 4. Implementation ✓
- [ ] Create spell entry in Spell_Target.txt / Spell_Zone.txt / etc.
- [ ] Set SpellType, Level, SpellSchool
- [ ] Configure damage with DealDamage()
- [ ] Add status effects with ApplyStatus()
- [ ] Set TargetConditions and Requirements
- [ ] Configure UseCosts (ActionPoint, Rage)
- [ ] Set Cooldown value
- [ ] Add all tooltip fields (TooltipDamageList, TooltipStatusApply, etc.)

#### 5. Localization ✓
- [ ] Allocate localization handles (DisplayName, Description)
- [ ] Write DisplayName with category tag in parentheses
- [ ] Write Description with mechanics and numbers
- [ ] Use DescriptionParams for dynamic values
- [ ] Include action economy in description

#### 6. Testing ✓
- [ ] Ability appears in character sheet
- [ ] Damage rolls correctly
- [ ] Rage cost deducts properly
- [ ] Cooldown functions correctly
- [ ] Status effects apply and last correct duration
- [ ] Tooltips show accurate information
- [ ] Action/Bonus Action cost is correct

#### 7. Validation Documentation ✓
- [ ] Add entry to validation report
- [ ] Mark WoW fidelity status
- [ ] Note any BG3 adaptations
- [ ] Document any known limitations
- [ ] Add to testing checklist

---

## TOOLTIP ENHANCEMENT GUIDE

### Current Tooltip Structure
BG3 tooltips use these fields in Spell data:

```
data "DisplayName" "h125abc05;1"
data "Description" "h125abc06;3"
data "DescriptionParams" "DealDamage(2d10+StrengthModifier,MainMeleeWeaponDamageType);50;2"
data "TooltipDamageList" "DealDamage(2d10+StrengthModifier,MainMeleeWeaponDamageType)"
data "TooltipStatusApply" "ApplyStatus(WAR_MORTAL_WOUND,100,2)"
data "TooltipAttackSave" "MeleeWeaponAttack"
data "TooltipOnMiss" "5d5f4487-0434-4dfc-8d60-c21948149dc8"
data "TooltipOnSave" "5d5f4487-0434-4dfc-8d60-c21948149dc8"
```

### Enhanced DisplayName Format
**Recommendation**: Add category tag to ability names for clarity

**Format**: `[Ability Name] ([Category])`

**Examples**:
- `Mortal Strike (Damage)` - Primary damage dealer
- `Victory Rush (Healing)` - Primary healing ability
- `Heroic Leap (Utility)` - Primary utility/movement
- `Die by the Sword (Defensive)` - Primary defensive
- `Heroic Strike (Generator)` - Rage generator
- `Colossus Smash (Burst)` - Major cooldown

**Alternative Format**: Use icons or color codes if engine supports:
- 🗡️ Mortal Strike (Damage)
- 💚 Victory Rush (Healing)
- ⚙️ Hamstring (Utility)
- 🛡️ Shield Block (Defensive)

### Enhanced Description Format
**Recommendation**: Structure descriptions consistently

**Template**:
```
[Action Type] [Range/Targets]

[Primary Effect]
[Secondary Effects]
[Conditions/Requirements]

[Resource Cost] • [Cooldown]
```

**Example - Mortal Strike**:
```
Action • Melee Weapon Attack

Deal 2d10 + Strength modifier damage.
Apply Mortal Wound: Target receives -50% healing for 2 turns.

30 Rage • Once per Turn
```

**Example - Victory Rush**:
```
Bonus Action • Melee Weapon Attack
[Requires recent kill]

Deal 1d8 + Strength modifier damage.
Heal yourself for 2d8 + Constitution modifier.

Available for 2 turns after killing an enemy with a weapon attack.
```

### Tag Implementation Ideas

#### Option 1: Add to Description
Modify English.loca.xml entries to include tags at the bottom:

```xml
<content contentuid="h125abc05" version="1">Mortal Strike (Damage)</content>
<content contentuid="h125abc06" version="3">Action • Melee Weapon Attack

Deal [1] damage.
Apply Mortal Wound: Target receives -[2]% healing for [3] turns.

Tags: Damage, Single-Target, Healing Reduction, Melee Weapon
</content>
```

#### Option 2: Use ExtraDescription Field
If available, use a separate field for metadata:

```
data "ExtraDescription" "h125abc07;1"
```

Where h125abc07 = "Tags: Damage, Single-Target, Healing Reduction"

#### Option 3: Status Icons
Create status effects that display category:
- Apply invisible "CATEGORY_DAMAGE" status when ability granted
- Status has icon showing category
- Tooltip automatically includes it

---

## HEROIC STRIKE ANALYSIS

### Current Status
**Issue Identified**: Heroic Strike feels like a normal WoW auto-attack, not a deliberate ability

### WoW Context

**What is Heroic Strike in WoW?**
- **Classic/Vanilla**: Special attack that replaced next auto-attack, added flat damage, cost Rage
- **Modern WoW**: **REMOVED** - No longer exists in retail WoW
- **Purpose**: Rage dump when at high Rage, prevented capping
- **Feel**: "Press button to make next swing hit harder"

**Why it feels wrong in BG3**:
1. BG3 has no auto-attacks - every attack is deliberate
2. Heroic Strike was a **Rage spender** in WoW, not a generator
3. It was a filler ability, not a core part of rotation
4. Warriors need a basic Rage generator in BG3 (no auto-attacks)

### Analysis: Do We Need Heroic Strike?

#### Arguments FOR Keeping (Modified)
1. **Rage Generation Need**: BG3 Warriors need basic Rage generation without auto-attacks
2. **Bonus Action Efficiency**: Gives Warriors something to do with Bonus Action
3. **WoW Flavor**: Name recognition from Classic WoW players
4. **Simple Rotation**: Provides straightforward generator for new players

#### Arguments AGAINST Keeping
1. **Not in Modern WoW**: Removed from retail, feels dated
2. **Name Confusion**: "Strike" implies big hit, but it's just basic attack
3. **Generic Feel**: Doesn't have warrior flavor
4. **Better Alternatives Exist**: Could use something more thematic

### Recommended Solutions

#### Option A: Rename to "Weapon Strike" ✅ RECOMMENDED
**Rationale**: Generic name matches generic function
- Keep exact same mechanics (Bonus Action, 1d8+STR, +15 Rage)
- Rename to "Weapon Strike" or "Basic Strike"
- Position as: "Your basic weapon attack when not using special abilities"
- DisplayName: `Weapon Strike (Generator)`

**Pros**:
- Honest about what it does
- No false expectations from WoW name
- Still functional as Rage generator
- Minimal implementation change

**Cons**:
- Loses WoW name recognition
- Still feels generic (but at least it's honest)

#### Option B: Replace with "Sunder Armor" ✅ ALTERNATIVE
**Rationale**: Classic Warrior ability with actual flavor
- **WoW Heritage**: Sunder Armor was THE warrior tank ability
- **Mechanics**: Bonus Action, 1d6+STR damage, -1 AC per stack (max 3), +15 Rage
- **Feel**: Debuffing enemy armor while generating Rage
- **Gameplay**: Rewards consistent application, synergy with big hits

**Implementation**:
```
Bonus Action, Melee Weapon Attack
Damage: 1d6 + Strength modifier
Generate: 15 Rage
Effect: Reduce target AC by -1 for 5 turns (stacks up to 3 times)
DisplayName: Sunder Armor (Generator)
Tags: Generator, SingleTarget, MeleeWeapon, ArmorReduction
```

**Pros**:
- Classic Warrior ability with history
- Unique mechanic (stacking armor reduction)
- Rewards setup and planning
- Makes big hits (Mortal Strike, Execute) stronger

**Cons**:
- More complex than current Heroic Strike
- Overlaps with Colossus Smash/Warbreaker armor reduction
- Needs additional status tracking

#### Option C: Replace with "Battle Strike" ⚠️ CONSIDERATION
**Rationale**: Fury Warrior ability from Legion/BFA
- **WoW Context**: Fury used this as basic generator
- **Mechanics**: Bonus Action, 1d8+STR, +15 Rage, 10% chance to grant extra attack
- **Feel**: Fast strikes that occasionally proc extra damage

**Pros**:
- More modern WoW reference
- Proc mechanic adds excitement
- Name sounds warrior-like

**Cons**:
- Extra attack proc hard to implement in BG3
- Not universally known like Sunder
- Still fundamentally a basic generator

#### Option D: Remove Entirely ❌ NOT RECOMMENDED
**Rationale**: Use only Charge and Skullsplitter for Rage generation
- **Charge**: +10 Rage (no cooldown, but requires gap)
- **Skullsplitter**: +20 Rage (Once per Turn, Arms only)
- **Theory**: Warriors should use abilities, not basic attacks

**Pros**:
- Forces engagement with actual abilities
- No "filler" button
- More tactical Rage management

**Cons**:
- Warriors would struggle to generate Rage consistently
- Bonus Action has no basic use
- Downtime feels bad in turn-based game
- Rage economy collapses without baseline generator

### Final Recommendation

**Primary**: **Option A - Rename to "Weapon Strike"**
- Honest, functional, minimal change
- Solves the "feels generic" problem by admitting it IS generic
- Keeps Rage economy working

**Secondary**: **Option B - Replace with "Sunder Armor"**
- More flavorful and tactical
- Classic Warrior fantasy
- Requires more implementation work but adds depth

**Implementation Note**:
If choosing Option A, update localization:
```
DisplayName: "Weapon Strike (Generator)"
Description: "Bonus Action • Melee Weapon Attack

Strike your enemy with your weapon.
Generate 15 Rage.

Your basic attack for building Rage when other abilities are unavailable."
```

If choosing Option B, see implementation details above.

---

## NEXT STEPS

### Immediate Actions
1. ✅ Review Heroic Strike decision (Options A or B)
2. ⏳ Implement ability category tags in tooltips
3. ⏳ Update all ability descriptions with enhanced format
4. ⏳ Add cooldown verification to validation reports
5. ⏳ Create tag filtering system for character sheet

### Future Enhancements
1. Color-coded ability icons by category
2. Filterable ability list by tag
3. In-game ability builder/planner
4. Rage calculator tool
5. Rotation helper UI

---

**Document Status**: Ready for Implementation  
**Next Update**: After Heroic Strike decision and tooltip enhancements
