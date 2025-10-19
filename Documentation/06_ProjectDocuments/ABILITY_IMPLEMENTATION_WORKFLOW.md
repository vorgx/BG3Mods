# Ability Implementation Workflow

**Date:** October 17, 2025  
**Purpose:** Detailed step-by-step process for implementing each BG3 ability  
**Audience:** Implementation guide for consistent ability creation

---

## Overview

Every ability requires **5-8 distinct steps** depending on complexity. This workflow ensures consistency, reduces errors, and speeds up implementation through templating.

---

## The 8-Step Ability Implementation Process

### Step 1: Design Analysis (5-10 minutes per ability)

**Goal:** Understand WoW source ability and plan BG3 conversion

**Questions to Answer:**
1. What type of ability is this? (Single-target attack, AoE, buff, debuff, passive modifier)
2. What file type does it need? (Spell_Target.txt, Spell_Zone.txt, Status_BOOST.txt, Passive.txt)
3. Does it need supporting entries? (Status effects, proc mechanics, passive wrappers)
4. What are the core mechanics? (Damage formula, duration, cooldown, resource cost)
5. Are there BG3 equivalents I can reference? (Similar vanilla abilities)

**Example: Mortal Strike**
- **Type:** Single-target melee attack with debuff
- **File:** Spell_Target.txt (main spell) + Status_BOOST.txt (Mortal Wounds debuff)
- **Support:** Passive wrapper for talent selection
- **Mechanics:** 2d12 damage + 50% healing reduction for 6 turns
- **Reference:** Divine Smite (damage + status), Hex (debuff application)

**Output:** Design notes document or mental checklist

---

### Step 2: File Type Determination (1-2 minutes)

**Decision Tree:**

```
Is it targeting a specific creature/object?
├─ YES → Spell_Target.txt
│   ├─ Melee attack: Mortal Strike, Overpower, Execute
│   ├─ Ranged attack: Heroic Throw, Storm Bolt
│   └─ Buff/Heal on target: Intervene (shield on ally)
│
└─ NO → Is it an AoE effect?
    ├─ YES → What shape?
    │   ├─ Circle/Sphere → Spell_Zone.txt (Whirlwind, Bladestorm, Thunder Clap)
    │   ├─ Cone → Spell_Zone.txt with AreaRadius + cone shape (Shockwave)
    │   └─ Line → Spell_Projectile.txt (if projectile-based)
    │
    └─ NO → Is it a self-buff/shout?
        ├─ YES → Spell_Shout.txt (Battle Shout, Avatar, Recklessness)
        │
        └─ NO → Is it a gap closer/teleport?
            ├─ YES → Spell_Jump.txt (Charge, Heroic Leap)
            │
            └─ NO → Is it passive/always-on?
                └─ YES → Passive.txt (Deep Wounds, Sudden Death, talent wrappers)
```

**Common Patterns:**
- **Attacks with debuffs:** Spell_Target.txt + Status_BOOST.txt
- **Buffs with effects:** Spell_Shout.txt + Status_BOOST.txt
- **Passive modifiers:** Passive.txt only (unless unlocking spells)
- **Talent choices:** Passive.txt wrapper + underlying spell/status

---

### Step 3: WoW → BG3 Conversion (5-10 minutes)

**Use Conversion Guide (WOW_TO_BG3_ABILITY_CONVERSION_GUIDE.md)**

#### Damage Conversion
**Formula:** `WoW % weapon damage ÷ 50 = BG3 dice average`

**Example: Mortal Strike (175% weapon damage in WoW)**
- 175 ÷ 50 = 3.5 dice average
- **BG3 equivalent:** 2d12 (avg 13) or 3d8 (avg 13.5) or 4d6 (avg 14)
- **Choose:** 2d12 (feels like a big two-handed hit)

**WoW Damage Table:**
| WoW % | BG3 Equivalent | Notes |
|-------|----------------|-------|
| 50% | 1d8 | Light hit |
| 100% | 2d8 | Standard attack |
| 150% | 2d12 or 3d8 | Heavy hit |
| 200% | 4d10 | Very heavy |
| 300% | 6d10 | Massive (Execute, Avatar) |

#### Rage Cost Conversion
**Formula:** `WoW Rage (0-100) ÷ 9.09 = BG3 Rage (0-11 pips)`

**Example: Mortal Strike (30 Rage in WoW)**
- 30 ÷ 9.09 = 3.3 pips
- **Round to:** 30 Rage in BG3 (keep WoW values, BG3 uses 0-100 internally)

**Rage Cost Table:**
| WoW Cost | BG3 Cost | Frequency |
|----------|----------|-----------|
| 0 | 0 | Free/cooldown abilities |
| 10 | 10 | Cheap filler |
| 20 | 20 | Standard spender |
| 30 | 30 | Heavy spender |
| 40+ | 40+ | Major cooldowns |

#### Duration Conversion
**Formula:** `WoW seconds ÷ 6 = BG3 turns`

**Example: Mortal Wounds (10 seconds in WoW)**
- 10 ÷ 6 = 1.67 turns
- **Round to:** 2 turns OR extend to 6 turns for BG3 pacing

**Common Durations:**
| WoW Duration | BG3 Turns | Usage |
|--------------|-----------|-------|
| 6 sec | 1 turn | Quick debuff |
| 12 sec | 2 turns | Standard debuff |
| 18 sec | 3 turns | Short buff |
| 30 sec | 5-6 turns | Standard buff |
| 60 sec | 10 turns | Long buff |
| Permanent | -1 | Toggle stance |

#### Cooldown Conversion
**Mapping:**
| WoW Cooldown | BG3 Cooldown | BG3 Syntax |
|--------------|--------------|------------|
| None | None | (omit Cooldown line) |
| 6 sec | OncePerTurn | `data "Cooldown" "OncePerTurn"` |
| 12-30 sec | OncePerTurn | `data "Cooldown" "OncePerTurn"` |
| 45-60 sec | OncePerShortRest | `data "Cooldown" "OncePerShortRest"` |
| 2-3 min | OncePerShortRest | `data "Cooldown" "OncePerShortRest"` |
| 5+ min | OncePerLongRest | `data "Cooldown" "OncePerLongRest"` |

#### Range Conversion
**Formula:** `WoW yards = BG3 meters (1:1 conversion)`

**Example: Heroic Throw (30 yards)**
- **BG3:** 30m range
- `data "TargetRadius" "30"`

---

### Step 4: Create Spell Entry (10-30 minutes)

**Template Structure (Spell_Target.txt example):**

```
new entry "Target_WAR_MortalStrike"
type "SpellData"
data "SpellType" "Target"
data "Level" "0"
data "SpellSchool" "None"
data "AIFlags" "CanNotUse"  // Disable AI (player-only)
data "TargetRadius" "1.5"  // Melee range
data "AreaRadius" "0"
data "UseCosts" "ActionPoint:1;Rage:30"
data "SpellAnimation" "ANIMATION_ID"  // Find from vanilla animations
data "Icon" "ICON_HANDLE"  // Placeholder, replace with actual icon
data "DisplayName" "h125abc01;1"  // Localization handle
data "Description" "h125abc02;1"
data "TooltipDamageList" "DealDamage(2d12+StrengthModifier,MainMeleeWeaponDamageType,Magical)"
data "TooltipAttackSave" "MeleeWeaponAttack"
data "PrepareEffect" "PREPARE_FX"  // Wind-up effect
data "CastEffect" "CAST_FX"  // Impact effect
data "TargetEffect" "TARGET_FX"  // Debuff visual
data "CastSound" "SOUND_HANDLE"
data "TargetSound" "IMPACT_SOUND"
data "SpellSuccess" "DealDamage(2d12+StrengthModifier,MainMeleeWeaponDamageType,Magical);ApplyStatus(TARGET,WAR_MORTAL_WOUNDS,100,6)"
data "SpellFail" "IF(not HasActionResource(Rage,30,0,false,false,context.Source)):ShowError(NotEnoughRage)"
data "TargetConditions" "not Dead() and not Ally()"
data "SpellFlags" "HasVerbalComponent;HasSomaticComponent;IsAttack"
data "MemoryCost" "1"
data "SpellActionType" "Action"
```

**Key Decisions During Creation:**

1. **Animation IDs:** Search existing BG3 abilities for similar animations
   - Melee attacks: Use greatsword/battleaxe animations
   - Check vanilla Fighter/Barbarian abilities
   - Placeholder: `"ANIMATION_MELEE_ATTACK"` (replace later)

2. **Icon Handles:** Use placeholders initially
   - Format: `"Icon_[AbilityName]"` (e.g., `"Icon_MortalStrike"`)
   - Find WoW icons later or commission custom art

3. **Visual Effects:** Reference vanilla abilities
   - Divine Smite effects for big hits
   - Hex visuals for debuffs
   - Placeholder: `"FX_PLACEHOLDER"` (test without FX first)

4. **Damage Formula:**
   - Always include `+StrengthModifier` for weapon attacks
   - Use `MainMeleeWeaponDamageType` (inherits equipped weapon type)
   - Add `Magical` tag to bypass resistance

5. **TargetConditions:**
   - Basic: `"not Dead() and not Ally()"`
   - Execute-style: `"HealthPercentage(context.Target) <= 20 and not Dead()"`
   - Proc-based: `"HasStatus('WAR_OVERPOWER_PROC') and not Dead()"`

**Time Estimate:**
- Simple attack: 10-15 minutes
- Attack with conditions: 20-25 minutes
- Complex multi-effect: 30-45 minutes

---

### Step 5: Create Status Effects (10-20 minutes each)

**Template Structure (Status_BOOST.txt example):**

```
new entry "WAR_MORTAL_WOUNDS"
type "StatusData"
data "StatusType" "BOOST"
data "DisplayName" "h125abc03;1"  // Status name
data "Description" "h125abc04;1"  // Status description
data "Icon" "Icon_MortalWounds"
data "StackId" "WAR_MORTAL_WOUNDS"  // Unique stack ID
data "TickType" "StartTurn"  // When it ticks (StartTurn, EndTurn, None)
data "OnApplyFunctors" "ApplyStatus(SELF,SG_Debuff,100,-1)"  // Tag as debuff for UI
data "Boosts" "IncomingHealing(-50)"  // 50% healing reduction
data "StatusEffect" "FX_STATUS_MORTAL_WOUNDS"  // Visual effect on afflicted
data "StatusSoundStart" "STATUS_SOUND_START"
data "StatusSoundLoop" "STATUS_SOUND_LOOP"
data "StatusSoundStop" "STATUS_SOUND_END"
data "StatusPropertyFlags" "DisableOverhead;DisableCombatlog;DisablePortraitIndicator"  // UI flags
data "RemoveEvents" "OnDeath"  // Remove on death
data "RemoveConditions" "Dead()"
```

**Common Status Types:**

#### Debuffs (Damage Reduction, Healing Reduction, etc.)
```
data "StatusType" "BOOST"
data "Boosts" "IncomingHealing(-50)"  // Mortal Wounds
data "Boosts" "AC(-2)"  // Sunder Armor
data "Boosts" "Disadvantage(AttackRoll)"  // Concussive Blows
```

#### DoT Effects (Bleeds, Poisons)
```
data "StatusType" "BOOST"
data "TickType" "StartTurn"
data "TickFunctors" "DealDamage(1d6,Slashing)"  // Rend bleed
```

#### Buffs (Damage Increase, AC Increase)
```
data "StatusType" "BOOST"
data "Boosts" "Damage(Increase,1d4,All)"  // Colossal Might (per stack)
data "Boosts" "AC(2);Advantage(SavingThrow,All)"  // Avatar
data "StackType" "Additive"  // Allow stacking
data "StackPriority" "1"
```

#### Proc Mechanics (Overpower Proc, Sudden Death)
```
data "StatusType" "BOOST"
data "Boosts" "UnlockSpell(Target_WAR_Overpower)"  // Unlock ability temporarily
data "RemoveEvents" "OnSpellCast"  // Remove after use
data "RemoveConditions" "HasStringInSpellRoll('Target_WAR_Overpower')"
```

**Time Estimate:**
- Simple buff/debuff: 10-15 minutes
- DoT effect: 15-20 minutes
- Stacking buff: 20-25 minutes
- Proc mechanic: 25-30 minutes

---

### Step 6: Create Passive Wrapper (5-10 minutes)

**Why Wrappers?**
- BG3 talent system uses `SelectPassives` nodes in Progressions.lsx
- Passives can unlock spells, grant boosts, or modify abilities
- Creates clean separation: Passive (talent choice) → Spell (actual ability)

**Template Structure (Passive.txt):**

```
new entry "WAR_ARMS_ROW1_MORTAL_STRIKE"
type "PassiveData"
data "DisplayName" "h125abc01;1"  // Same as spell (reuse handle)
data "Description" "h125abc02;1"  // Same as spell
data "Icon" "Icon_MortalStrike"  // Same as spell
data "Properties" "IsHidden"  // Hide from passive list (it unlocks a spell)
data "Boosts" "UnlockSpell(Target_WAR_MortalStrike)"  // Unlock the spell
data "PassiveFlags" ""
```

**Variants:**

#### Simple Unlock (Most Common)
```
data "Boosts" "UnlockSpell(Target_WAR_MortalStrike)"
```

#### Unlock + Passive Effect
```
data "Boosts" "UnlockSpell(Target_WAR_Overpower);UnlockPassive(WAR_ARMS_OVERPOWER_PROC)"
```

#### Pure Passive (No Spell)
```
new entry "WAR_ARMS_DEEP_WOUNDS"
type "PassiveData"
data "DisplayName" "h125abc05;1"
data "Description" "h125abc06;1"
data "Icon" "Icon_DeepWounds"
data "Properties" ""  // Visible in passive list
data "StatsFunctorContext" "OnAttack"
data "Conditions" "IsCriticalHit()"
data "StatsFunctors" "ApplyStatus(TARGET,WAR_DEEP_WOUNDS,100,6)"
```

#### Conditional Boost
```
new entry "WAR_COLOSSUS_MOUNTAIN_OF_STEEL"
type "PassiveData"
data "DisplayName" "h125abc07;1"
data "Description" "h125abc08;1"
data "Icon" "Icon_MountainOfSteel"
data "Properties" ""
data "Boosts" "IF(StatusStackCount(WAR_COLOSSAL_MIGHT)>=3):AC(2)"
```

**Time Estimate:** 5-10 minutes per passive

---

### Step 7: Create Localization Handles (3-5 minutes per ability)

**Process:**

1. **Generate Unique Handle IDs**
   - Format: `h[8 hex chars][2 digit counter]`
   - Example: `h125abc01`, `h125abc02`, `h125abc03`...
   - Use sequential counter for each ability (01, 02, 03, 04)

2. **Write DisplayName (Short)**
   - Ability name only (2-4 words)
   - Example: `"Mortal Strike"`

3. **Write Description (Detailed)**
   - Mechanics explanation (1-2 sentences)
   - Include: Damage, cost, duration, conditions
   - Example: `"A vicious strike that deals 2d12 weapon damage and reduces healing by 50% for 6 turns. Costs 30 Rage."`

4. **Create Status Handles (if applicable)**
   - DisplayName for buff/debuff name
   - Description for tooltip

**Template (English.loca.xml):**

```xml
<!-- Mortal Strike -->
<content contentuid="h125abc01" version="1">Mortal Strike</content>
<content contentuid="h125abc02" version="1">A vicious strike that deals 2d12 weapon damage and reduces healing by 50% for 6 turns. Costs 30 Rage.</content>

<!-- Mortal Wounds Status -->
<content contentuid="h125abc03" version="1">Mortal Wounds</content>
<content contentuid="h125abc04" version="1">Healing received reduced by 50%.</content>
```

**Handles Per Ability:**
- Spell only: 2 handles (DisplayName + Description)
- Spell + Status: 4 handles (Spell Name + Desc + Status Name + Desc)
- Passive only: 2 handles
- Complex (spell + multiple statuses): 6-8 handles

**Time Estimate:** 3-5 minutes per ability (2-4 handles)

---

### Step 8: Integration & Testing (Variable time)

**Integration Steps:**

1. **Add to Progressions.lsx** (5-10 minutes)
   - Determine which level grants this ability
   - Add to appropriate pool (Pool 1, Pool 2, Pool 3, Pool 4/5)
   - Create SelectPassives node (if choice) or add to Boosts (if auto-grant)

**Example (Auto-grant at L4):**
```xml
<node id="Progression">
    <attribute id="Level" type="uint8" value="4"/>
    <attribute id="Boosts" type="LSString" value="UnlockSpell(Target_WAR_MortalStrike)"/>
</node>
```

**Example (Choice node at L3):**
```xml
<node id="Progression">
    <attribute id="Level" type="uint8" value="3"/>
    <children>
        <node id="SelectPassives">
            <attribute id="UUID" type="guid" value="[GENERATE_UUID]"/>
            <attribute id="Amount" type="uint8" value="1"/>
            <attribute id="Passives" type="LSString" value="WAR_ARMS_ROW1_MORTAL_STRIKE;WAR_ARMS_ROW1_OVERPOWER;WAR_ARMS_ROW1_REND"/>
        </node>
    </children>
</node>
```

2. **Cross-Reference Validation** (2-3 minutes)
   - Verify all spell names match across files
   - Check all handle references exist
   - Confirm UUID consistency

3. **Syntax Validation** (1-2 minutes)
   - Open files in text editor, check for missing quotes
   - Validate XML structure (Progressions.lsx, English.loca.xml)
   - Run find/replace to catch common errors

4. **In-Game Testing** (5-30 minutes per ability)
   - Package mod → Install → Launch game
   - Create test character, level to appropriate level
   - Verify ability appears in UI
   - Test casting: Does it consume resources? Deal damage? Apply status?
   - Test edge cases: What if target dies? What if out of Rage?
   - Check localization: Does text display correctly?

**Testing Checklist per Ability:**
- [ ] Ability appears at correct level
- [ ] Icon displays (or placeholder shows)
- [ ] Name/description text correct (no "h125abc01" raw handles)
- [ ] Casts successfully
- [ ] Resource cost deducted correctly (Action Point + Rage)
- [ ] Damage dealt (if attack)
- [ ] Status applied (if applicable)
- [ ] Duration correct (check turn count)
- [ ] Cooldown works (if applicable)
- [ ] Visual/audio effects play (or no crash if missing)
- [ ] No console errors in SE logs

**Time Estimate:**
- Integration: 5-10 minutes per ability
- Testing: 5-30 minutes per ability (depending on complexity)

---

## Complete Example: Mortal Strike

**Total Time: ~45-60 minutes**

### Step 1: Design Analysis (5 min)
- **Type:** Single-target melee attack with healing debuff
- **Files:** Spell_Target.txt + Status_BOOST.txt + Passive.txt
- **Mechanics:** 175% weapon damage (WoW) = 2d12 (BG3), 30 Rage cost, applies 50% healing reduction for 6 turns
- **Reference:** Divine Smite (damage delivery), Hex (debuff application)

### Step 2: File Type (1 min)
- **Primary:** Spell_Target.txt
- **Supporting:** Status_BOOST.txt (Mortal Wounds), Passive.txt (talent wrapper)

### Step 3: Conversion (5 min)
- **Damage:** 175% WoW → 2d12 BG3
- **Cost:** 30 Rage (same in BG3)
- **Duration:** 10 sec WoW → 6 turns BG3 (extended for turn-based pacing)
- **Range:** Melee (1.5m)

### Step 4: Spell Entry (15 min)
```
new entry "Target_WAR_MortalStrike"
type "SpellData"
data "SpellType" "Target"
data "Level" "0"
data "TargetRadius" "1.5"
data "UseCosts" "ActionPoint:1;Rage:30"
data "DisplayName" "h125abc01;1"
data "Description" "h125abc02;1"
data "TooltipDamageList" "DealDamage(2d12+StrengthModifier,MainMeleeWeaponDamageType,Magical)"
data "SpellSuccess" "DealDamage(2d12+StrengthModifier,MainMeleeWeaponDamageType,Magical);ApplyStatus(TARGET,WAR_MORTAL_WOUNDS,100,6)"
data "TargetConditions" "not Dead() and not Ally()"
data "SpellFlags" "IsAttack"
data "Icon" "Icon_MortalStrike"
```

### Step 5: Status Effect (10 min)
```
new entry "WAR_MORTAL_WOUNDS"
type "StatusData"
data "StatusType" "BOOST"
data "DisplayName" "h125abc03;1"
data "Description" "h125abc04;1"
data "Icon" "Icon_MortalWounds"
data "StackId" "WAR_MORTAL_WOUNDS"
data "Boosts" "IncomingHealing(-50)"
data "RemoveEvents" "OnDeath"
```

### Step 6: Passive Wrapper (5 min)
```
new entry "WAR_ARMS_ROW1_MORTAL_STRIKE"
type "PassiveData"
data "DisplayName" "h125abc01;1"
data "Description" "h125abc02;1"
data "Icon" "Icon_MortalStrike"
data "Properties" "IsHidden"
data "Boosts" "UnlockSpell(Target_WAR_MortalStrike)"
```

### Step 7: Localization (5 min)
```xml
<content contentuid="h125abc01" version="1">Mortal Strike</content>
<content contentuid="h125abc02" version="1">A vicious strike that deals 2d12 weapon damage and reduces healing by 50% for 6 turns. Costs 30 Rage.</content>
<content contentuid="h125abc03" version="1">Mortal Wounds</content>
<content contentuid="h125abc04" version="1">Healing received reduced by 50%.</content>
```

### Step 8: Integration (15 min)
```xml
<!-- In Progressions.lsx at Level 3 -->
<node id="SelectPassives">
    <attribute id="UUID" type="guid" value="12345678-1234-1234-1234-123456789abc"/>
    <attribute id="Amount" type="uint8" value="1"/>
    <attribute id="Passives" type="LSString" value="WAR_ARMS_ROW1_MORTAL_STRIKE;WAR_ARMS_ROW1_OVERPOWER;WAR_ARMS_ROW1_REND"/>
</node>
```

**Testing:** Package, install, create Arms Warrior, level to 3, select Mortal Strike, test casting on enemy.

---

## Time Estimates by Ability Type

| Ability Type | Example | Total Time | Breakdown |
|--------------|---------|------------|-----------|
| **Simple Attack** | Slam, Heroic Strike | 30-40 min | Spell (15m) + Passive (5m) + Loc (5m) + Integration (10m) |
| **Attack + Debuff** | Mortal Strike, Sunder Armor | 45-60 min | Spell (15m) + Status (10m) + Passive (5m) + Loc (5m) + Integration (15m) |
| **DoT Attack** | Rend, Deep Wounds | 50-65 min | Spell (20m) + Status (15m) + Passive (5m) + Loc (5m) + Integration (15m) |
| **Self-Buff** | Battle Shout, Avatar | 40-55 min | Spell (15m) + Status (12m) + Passive (5m) + Loc (5m) + Integration (10m) |
| **AoE Attack** | Whirlwind, Bladestorm | 45-60 min | Spell (20m) + Status (10m, if debuff) + Passive (5m) + Loc (5m) + Integration (15m) |
| **Gap Closer** | Charge, Heroic Leap | 50-65 min | Spell (25m) + Status (10m, if buff) + Passive (5m) + Loc (5m) + Integration (15m) |
| **Complex Passive** | Sudden Death, Overpower Proc | 40-55 min | Passive (20m) + Status (15m, proc mechanic) + Loc (5m) + Integration (15m) |
| **Stacking Buff** | Colossal Might, Frenzy | 55-70 min | Spell (20m) + Status (20m, stacking) + Passive (5m) + Loc (5m) + Integration (15m) |

**Average:** ~45-60 minutes per ability (including testing)

---

## Efficiency Improvements

### Templating (Saves ~30% time)
After implementing 5-10 abilities, create templates:

1. **Copy-Paste Template** (from similar ability)
2. **Find-Replace** (change names, IDs, damage values)
3. **Adjust Mechanics** (tweak specific formulas)
4. **Test** (verify no copy-paste errors)

**Example:** After creating Mortal Strike, use as template for:
- Overpower (change damage to 2d10, add proc condition)
- Colossus Smash (change debuff to -2 AC instead of healing reduction)
- Sunder Armor (similar to Colossus Smash, different values)

**Time Saved:** 15-20 minutes per ability after template created

### Batch Localization (Saves ~40% time)
Instead of writing handles per ability:

1. **List all abilities** (in spreadsheet or doc)
2. **Generate all handle IDs** (sequential: h125abc01 through h125abc99)
3. **Write all DisplayNames** (quick pass, just names)
4. **Write all Descriptions** (longer pass, full mechanics)
5. **Copy to English.loca.xml** (single paste operation)

**Time Saved:** 5-10 minutes per batch of 10+ abilities

### Pre-Testing Validation (Saves crash time)
Before packaging:

1. **Run grep search** for common errors:
   - Missing quotes: `grep -E 'data "[^"]+" [^"]' Spell_*.txt`
   - Duplicate entry names: `grep "^new entry" Spell_*.txt | sort | uniq -d`
   - Missing handles: `grep -E 'h[0-9a-f]{8}[0-9]{2}' Spell_*.txt | sort | uniq`

2. **XML validation** (use VS Code XML extension or online validator)

**Time Saved:** 10-30 minutes per testing iteration (avoid crash-repackage-test loops)

---

## Parallelization Strategy

**If working with team or AI assistance:**

### Parallel Track 1: Spells (Main Implementation)
- Create all Spell_*.txt entries
- **Time:** 60% of total

### Parallel Track 2: Statuses (Can be done simultaneously)
- Create all Status_BOOST.txt entries
- **Time:** 30% of total

### Parallel Track 3: Localization (Can be done simultaneously)
- Write all English.loca.xml handles
- **Time:** 20% of total

### Sequential Track: Integration (Must be done after above)
- Create Passive wrappers
- Add to Progressions.lsx
- Test
- **Time:** 40% of total

**Total Time with Parallelization:** ~60-70% of sequential time (if 2-3 people working)

---

## Quality Checklist (Per Ability)

Before moving to next ability:

- [ ] Spell entry uses correct file type (Target/Zone/Shout/Jump/Projectile)
- [ ] Damage formula includes `+StrengthModifier` (if weapon attack)
- [ ] Resource costs are reasonable (ActionPoint:1;Rage:X)
- [ ] Status effects have proper StackId (prevents conflicts)
- [ ] Passive wrapper references correct spell name
- [ ] Localization handles are unique (no duplicates)
- [ ] All handles referenced in code exist in English.loca.xml
- [ ] Progressions.lsx entry uses correct UUID format
- [ ] Ability appears at intended level (L3 for Arms Row 1, etc.)
- [ ] No syntax errors (missing quotes, unclosed tags)

---

## Common Pitfalls & Solutions

### Pitfall 1: Copy-Paste Errors
**Problem:** Copying ability, forgetting to change entry name  
**Result:** Duplicate entry names crash mod loader  
**Solution:** Use Find-Replace on entry name FIRST before editing mechanics

### Pitfall 2: Missing Status Definitions
**Problem:** Spell references `WAR_STATUS_X` but status not created  
**Result:** Ability casts but doesn't apply effect  
**Solution:** Create status BEFORE spell, or use placeholder `SG_Restrained` to test

### Pitfall 3: Handle Typos
**Problem:** Spell uses `h125abc01` but English.loca.xml has `h125abc10`  
**Result:** Raw handle displays in-game instead of ability name  
**Solution:** Copy-paste handles, never type manually

### Pitfall 4: Wrong SpellType
**Problem:** AoE ability in Spell_Target.txt instead of Spell_Zone.txt  
**Result:** Only hits one target instead of area  
**Solution:** Use decision tree (Step 2) BEFORE creating entry

### Pitfall 5: Malformed Progressions.lsx
**Problem:** Missing closing `</node>` tag or wrong nesting  
**Result:** Mod fails to load, crash on character creation  
**Solution:** Use XML validator after every Progressions.lsx edit

---

## Conclusion

**Systematic approach ensures:**
- ✅ Consistency across all abilities
- ✅ Reduced errors (fewer crashes, faster testing)
- ✅ Faster implementation (templates, batching)
- ✅ Complete documentation (every ability has localization, integration)

**Average time per ability: ~45-60 minutes** (includes testing)  
**With templates: ~30-40 minutes** (after first 5-10 abilities)  
**With parallelization: ~20-30 minutes** (if working with team)

**For 47-53 Arms abilities:** 85-120 hours total (matches roadmap estimate)

---

**Last Updated:** October 17, 2025  
**Status:** Workflow documentation complete, ready for implementation
