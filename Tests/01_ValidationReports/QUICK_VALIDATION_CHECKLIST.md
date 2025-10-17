# Quick Validation Checklist
**Use this before creating/modifying any ability**

---

## PRE-IMPLEMENTATION (2 minutes)

### 1. WoW Source Check ✓
- [ ] Read WoW source documentation
- [ ] Note: Damage values, effects, cooldown, cost
- [ ] Identify: Primary purpose (damage/healing/utility/defensive)

### 2. Category Tags ✓
```
Primary: [DAMAGE | HEALING | UTILITY | DEFENSIVE | GENERATOR | SPENDER]
Delivery: [SingleTarget | AoE | Cone | Line | SelfBuff | PartyBuff]
Action: [Action | BonusAction | Reaction | Passive]
Cooldown: [None | OncePerTurn | ShortRest | LongRest]
Secondary: [List applicable: MeleeWeapon, Ranged, Bleed, Stun, etc.]
```

### 3. BG3 Conversion ✓
```
Damage: _____d_____ + _____ (compare to similar abilities)
WoW Cooldown: _____ → BG3: _____ (use cooldown mapping)
Rage Cost: [10 | 15 | 20 | 25 | 30 | 40]
Duration: _____ turns (if buff/debuff)
Range: _____ m
```

---

## IMPLEMENTATION (5-10 minutes)

### 4. Spell File ✓
- [ ] Create entry in appropriate .txt file (Spell_Target, Spell_Zone, etc.)
- [ ] Set: SpellType, Level, SpellSchool
- [ ] Add: DealDamage() with correct dice
- [ ] Add: ApplyStatus() for effects
- [ ] Set: TargetConditions and Requirements
- [ ] Set: UseCosts (ActionPoint, Rage if applicable)
- [ ] Set: Cooldown value
- [ ] Add: All Tooltip fields (TooltipDamageList, TooltipStatusApply, etc.)

### 5. Localization ✓
- [ ] Allocate handles: h125abc### for DisplayName, Description
- [ ] Write DisplayName: `[Name] ([Primary Category])`
- [ ] Write Description:
  ```
  [Action Type] • [Range/Targets]
  
  [Primary Effect with [1] [2] params]
  [Secondary Effects]
  [Conditions/Requirements]
  
  [Resource Cost] • [Cooldown]
  ```
- [ ] Set DescriptionParams: Match placeholders [1] [2] [3]

---

## POST-IMPLEMENTATION (5 minutes)

### 6. In-Game Testing ✓
- [ ] Ability appears in character sheet
- [ ] Damage rolls correctly (check combat log)
- [ ] Rage cost deducts properly
- [ ] Cooldown functions (check next turn availability)
- [ ] Status effects apply with correct duration
- [ ] Tooltips show accurate info
- [ ] Action/Bonus Action cost correct

### 7. Documentation ✓
- [ ] Add entry to WARRIOR_ABILITIES_VALIDATION_REPORT.md
- [ ] Format:
  ```markdown
  #### ##. [Ability Name] ✅ VERIFIED
  **WoW Source**: "[Quote from source]"
  **WoW Cooldown**: [X seconds]
  **Implementation**:
  - Type: [Action/BonusAction]
  - Damage: [Dice formula]
  - Effect: [What it does]
  - Cost: [Rage cost]
  - Cooldown: [BG3 cooldown]
  - Tags: [All applicable tags]
  
  **Validation**:
  - ✅ WoW Fidelity: [Match to source]
  - ✅ Cooldown: [BG3 conversion reasoning]
  - ✅ [Other validation points]
  
  **Status**: CORRECT
  ```

---

## COOLDOWN QUICK REFERENCE

```
WoW None/GCD     → BG3 None          (Rage cost gates it)
WoW ≤6s          → BG3 OncePerTurn   (Pummel 15s, Heroic Throw 6s)
WoW 6-45s        → BG3 ShortRest     (Storm Bolt 30s, Colossus Smash 45s)
WoW 45s-3min     → BG3 LongRest      (Avatar 90s, Bladestorm 90s)
```

---

## TAG QUICK REFERENCE

### Must Have (3 tags minimum)
1. **Primary**: DAMAGE, HEALING, UTILITY, DEFENSIVE, GENERATOR, or SPENDER
2. **Delivery**: SingleTarget, AoE, Cone, Line, SelfBuff, or PartyBuff
3. **Action**: Action, BonusAction, Reaction, or Passive
4. **Cooldown**: None, OncePerTurn, ShortRest, or LongRest

### Common Combinations
- **Basic Generator**: GENERATOR, SingleTarget, BonusAction, None, MeleeWeapon
- **Rage Spender**: SPENDER, DAMAGE, SingleTarget, Action, [Cooldown], MeleeWeapon
- **AoE Burst**: SPENDER, DAMAGE, AoE, Action, LongRest, MeleeWeapon
- **Utility CC**: UTILITY, SingleTarget, Action, ShortRest, Stun
- **Self Buff**: UTILITY, SelfBuff, BonusAction, LongRest

---

## COMMON MISTAKES TO AVOID

❌ **Forgetting Cooldown**: Always set cooldown field (even if "None")  
❌ **Wrong Action Type**: Verify Action vs BonusAction  
❌ **Missing Tooltip**: TooltipDamageList and TooltipStatusApply improve UX  
❌ **Inconsistent Rage**: Generators (+10 to +20), Spenders (-10 to -40)  
❌ **No DescriptionParams**: Dynamic values need params for tooltips  
❌ **Skipping Tags**: Every ability needs minimum 4 tags  
❌ **No WoW Comparison**: Always verify against source material

---

## RAGE COST GUIDELINES

```
Generators (produce Rage):
- Basic: +15 (Heroic Strike)
- Minor: +10 (Charge)
- Major: +20 (Skullsplitter)

Spenders (consume Rage):
- Cheap: -10 (Whirlwind, Thunder Clap, Rend)
- Standard: -15 (Slam)
- Medium: -20 (Overpower)
- Heavy: -30 (Mortal Strike)
- Ultimate: -40 (Colossus Smash, Warbreaker)
```

---

## EXAMPLES

### Example 1: Simple Damage Ability
**Victory Rush** (Healing, SingleTarget, BonusAction, None)
- Damage: 1d8+STR, Heal: 2d8+CON
- Requirement: WAR_VICTORIOUS status (from kill)
- No Rage cost, no cooldown (kill-gated)
- Tags: HEALING, SingleTarget, BonusAction, None, OnKill, MeleeWeapon

### Example 2: Major Cooldown
**Avatar** (Utility, SelfBuff, BonusAction, LongRest)
- Effect: +4 STR, +2 AC, +50% Rage gen, Immune Fear/Charm
- Duration: 4 turns
- No Rage cost
- Tags: UTILITY, SelfBuff, BonusAction, LongRest, GENERATOR

### Example 3: Conditional Ability
**Execute** (Spender, SingleTarget, Action, None)
- Damage: 4d12+STR (massive)
- Condition: Target below 20% HP
- Cost: 20-40 Rage (scales)
- Tags: SPENDER, DAMAGE, SingleTarget, Action, None, Execute, MeleeWeapon

---

**Print this and keep it handy when implementing abilities!**
