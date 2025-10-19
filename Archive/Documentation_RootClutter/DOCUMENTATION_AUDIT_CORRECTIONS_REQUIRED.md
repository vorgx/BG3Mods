# Documentation Audit & Correction Report
**Date**: October 17, 2025  
**Scope**: Complete documentation review for specialization system accuracy  
**Status**: CRITICAL CORRECTIONS REQUIRED

---

## CRITICAL ERRORS FOUND

### Error 1: Capstone Timing (WIDESPREAD)
**Incorrect**: Multiple documents state "Capstone granted at L13"  
**Correct**: **Keystone at L13 ONLY**, **Capstone at L20 ONLY**

**Affected Files**:
1. `ARMS_WARRIOR_5_POOL_TALENT_SYSTEM.md` - Lines 873, 1004
2. `SPECIALIZATION_TIER_STRUCTURES.md` - Lines 29, 52
3. `SPECIALIZATION_PROGRESSION_VISUAL_GUIDE.md` - Lines 12, 29, 48, 67, 86, 103
4. `SPECIALIZATION_TIER_DECISION.md` - Lines 31, 47
5. `Arms_Warrior_Talents_Extracted.md` - Line 465 ("L20 - Capstone" correct, but progression text ambiguous)
6. `Protection_Warrior_Talents_Extracted.md` - Needs verification
7. `Fury_Warrior_Talents_Extracted.md` - Needs verification

---

### Error 2: Extra Attack Not Documented
**Missing**: BG3 grants Extra Attack at **Level 5** for martial classes  
**Impact**: All progression charts missing this critical milestone

**Affected Files**:
- ALL progression documents lack L5 Extra Attack entry
- `BG3_Global_Rules.md` mentions it (line ~93) but not enforced in Warrior docs

---

### Error 3: WoW vs BG3 Ability Conversions Incomplete
**Issue**: New abilities from Class/SubclassSpec talents need BG3 stat file implementations  
**Status**: Only 12 baseline abilities validated, ~40+ new abilities need conversion

**Missing Conversions**:
- Class Talents: ~24 abilities (Heroic Leap, Storm Bolt, Intimidating Shout, Avatar, Champion's Spear, etc.)
- SubclassSpec Talents: ~24 Arms abilities (Mortal Strike, Overpower, Rend, Warbreaker, Bladestorm, etc.)
- Specialization talents: ~30 abilities across Colossus/Slayer/Mountain Thane

---

### Error 4: Specialization Choice Structure Ambiguous
**Issue**: Old documents reference "Mountain Thane vs Slayer" for Arms (incorrect)  
**Correct**: Arms chooses **Colossus OR Slayer** (no Mountain Thane)

**Affected Files**:
- `Arms_Warrior_Talents_Extracted.md` - Line 395 mentions Mountain Thane (should be removed/corrected)

---

## REQUIRED CORRECTIONS BY FILE

### 1. ARMS_WARRIOR_5_POOL_TALENT_SYSTEM.md

#### Section: Pool 4 - Colossus
**Line 873 - WRONG**:
```markdown
### Capstone Talent (Granted at L13)
```

**CORRECTION**:
```markdown
### Capstone Talent (Granted at L20)
```

**Additional Fix**: Update progression chart at line ~1123 to show:
- L13: Keystone ONLY (Demolish for Colossus, Slayer's Dominance for Slayer)
- L20: Capstone ONLY (Dominance of the Colossus, Slayer's Malice)

#### Section: Pool 5 - Slayer
**Line 1004 - WRONG**:
```markdown
### Capstone Talent (Granted at L13)
```

**CORRECTION**:
```markdown
### Capstone Talent (Granted at L20)
```

#### NEW SECTION NEEDED: Level 5 Extra Attack
**Insert after Row 4 (L7) in progression chart**:
```markdown
| **L5** | Row 3 choice | Row 3 choice | - | **Extra Attack** (2 attacks per Attack action) | **FEAT** |
```

---

### 2. SPECIALIZATION_TIER_STRUCTURES.md

#### Section: 3-Tier Specializations
**Lines 29-36 - WRONG**:
```markdown
- **L13**: Keystone Talent (auto-granted) + Capstone Talent (auto-granted)
```

**CORRECTION**:
```markdown
- **L13**: Keystone Talent (auto-granted)
```

**Lines to add after L19**:
```markdown
- **L20**: Capstone Talent (auto-granted)
```

#### Section: 4-Tier Specializations
**Lines 52-59 - WRONG**:
```markdown
- **L13**: Keystone Talent (auto-granted) + Capstone Talent (auto-granted)
```

**CORRECTION**:
```markdown
- **L13**: Keystone Talent (auto-granted)
```

**Lines to add after L19**:
```markdown
- **L20**: Capstone Talent (auto-granted)
```

#### Section: Total Talents Calculation
**WRONG**: "Total: 2 auto-keystones + X passives + Y choices = 9 talents"

**CORRECTION**: 
- 3-Tier: "Total: 1 keystone (L13) + 1 capstone (L20) + 4 passives + 3 choices = **9 talents**"
- 4-Tier: "Total: 1 keystone (L13) + 1 capstone (L20) + 3 passives + 4 choices = **9 talents**"

---

### 3. SPECIALIZATION_PROGRESSION_VISUAL_GUIDE.md

#### All Specialization Charts (Lines 12, 29, 48, 67, 86, 103)
**WRONG**:
```
L13: ⭐ Demolish (Keystone)              🏆 Dominance of the Colossus (Capstone)
```

**CORRECTION**:
```
L13: ⭐ Demolish (Keystone)              [Capstone comes at L20]
...
L20: 🟢 Titanic Fury (Passive)           🏆 Dominance of the Colossus (Capstone)
```

**Apply this pattern to ALL specialization charts**:
- Colossus (Arms/Protection)
- Slayer (Arms/Fury) 
- Mountain Thane (Fury/Protection)

#### Table Updates (Lines 123, 140)
**WRONG**:
```
| L13 | Keystone + Capstone | None (auto-granted) |
```

**CORRECTION**:
```
| L13 | Keystone | None (auto-granted) |
| ... | ... | ... |
| L20 | Passive + Capstone | None (auto-granted) |
```

---

### 4. SPECIALIZATION_TIER_DECISION.md

#### All Progression Examples (Lines 31, 47)
**WRONG**:
```
- L13: Keystone + Capstone (auto-granted)
```

**CORRECTION**:
```
- L13: Keystone (auto-granted)
- L20: Passive 4 + Capstone (auto-granted)
```

---

### 5. Arms_Warrior_Talents_Extracted.md

#### Section: SPECIALIZATION: Mountain Thane (Line ~330)
**WRONG**: Entire Mountain Thane section listed for Arms

**CORRECTION**: 
```markdown
## ❌ REMOVED: Mountain Thane is NOT available to Arms Warriors

**Note**: Arms Warriors choose between **Colossus** OR **Slayer** at Level 13.  
Mountain Thane is available to **Fury** and **Protection** Warriors only.

See `Fury_Warrior_Talents_Extracted.md` or `Protection_Warrior_Talents_Extracted.md` for Mountain Thane details.
```

#### Section: SPECIALIZATION: Slayer (Lines 418-465)
**Line 465 - VERIFY**:
```markdown
**Slayer's Malice** (L20 - Capstone)
```
✅ This is **CORRECT** - Keep as is

**Lines 424-453 - VERIFY Choice Node Levels**:
Current shows:
- Brutal Finish (L13) ❌ WRONG - should be L15
- Overwhelming Blades (L15) ✅ Correct
- Opportunist (L18) ❌ WRONG - should be L17 or L19

**CORRECTION**: Apply 3-tier structure (L15, L17, L19):
```markdown
### Slayer - Choice Nodes (3 Tiers: L15, L17, L19)

**Choice Node 1 (L15) - Pick 1 of 3:**
- **Brutal Finish**: Execute +50% damage vs Marked
- **Opportunist**: Mortal Strike +1d8 vs Marked, refund 10 Rage
- **Overwhelming Blades**: Marked spreads to 1 additional enemy

**Choice Node 2 (L17) - Pick 1 of 3:**
- **Show No Mercy**: Crit range +1 vs Marked
- **Culling Cyclone**: Whirlwind +1d6 per Marked enemy
- **Relentless Pursuit**: +3m move, Execute grants +6m for 2 turns

**Choice Node 3 (L19) - Pick 1 of 3:**
- **Reap the Storm**: Hit 3+ enemies → apply Overwhelmed
- **Flurry of Blades**: Overpower hits 2 additional targets
- **Death Sentence**: Execute extends Marked duration
```

#### Section: SPECIALIZATION: Colossus
**STATUS**: Not in Arms_Warrior_Talents_Extracted.md, needs to be added

**ADD NEW SECTION** (after Slayer):
```markdown
## SPECIALIZATION: Colossus (Hero Talent - Alternative Choice at L13)

### Colossus - Key Talent (Granted at L13)

**Demolish**
- **Type**: Action
- **Effect**: Channeled 3-hit combo with 99% slow
- **BG3 Implementation**:
  - Action, Channeled Attack (4 turns)
  - Hit 1: 2d12 + Strength
  - Hit 2: 2d12 + Strength
  - Hit 3: 4d12 + Strength (finisher)
  - Total: 8d12 + (3 × Strength) damage
  - Apply Crushed: -99% movement for 3 turns
  - While channeling: Take -10% damage, immune to stuns/knockbacks
  - Recharge: Long Rest
  - Tags: Channeled, SingleTarget, Slow, Defense

### Colossus - Choice Nodes (3 Tiers: L15, L17, L19)

**Choice Node 1 (L15) - Pick 1 of 3:**
- **Boneshaker**: Demolish applies Deep Wounds (2d6 bleed/turn for 5 turns)
- **Colossal Might**: Stack Colossal Might on Shield Slam (10 stacks, +10% dmg per stack)
- **One-Handed Weapon Specialization**: +15% damage with 1H weapons

**Choice Node 2 (L17) - Pick 1 of 3:**
- **Arterial Bleed**: Bleeding effects you apply deal +30% damage
- **Practiced Strikes**: +10% attack speed while Colossal Might active
- **Unstoppable Force**: Demolish cannot be interrupted, grants CC immunity

**Choice Node 3 (L19) - Pick 1 of 3:**
- **Earthquaker**: Demolish final hit deals AoE damage (3m radius)
- **Walls of Iron**: +2 AC, Demolish grants Damage Reduction (20% for 4 turns)
- **Mountain of Muscle and Scars**: +15% max HP, bleeding cannot reduce you below 1 HP

### Colossus - Passives (Auto-Granted)

**Colossal Endurance** (L14)
- **Type**: Passive
- **Effect**: Endurance increase
- **BG3 Implementation**: +10% max HP, +1 AC while in Defensive Stance

**Shield Mastery** (L16)
- **Type**: Passive
- **Effect**: Shield proficiency bonus
- **BG3 Implementation**: Shield Slam generates +5 Rage, shield AC bonus +1

**Demolishing Charge** (L18)
- **Type**: Passive
- **Effect**: Charge enhancement
- **BG3 Implementation**: Charge generates +10 Rage, reduces Demolish cooldown by 1 turn

**Titanic Fury** (L20)
- **Type**: Passive
- **Effect**: Rage generation enhancement
- **BG3 Implementation**: Generate +5 Rage when you take damage from attacks (max 3 procs per turn)

### Colossus - Capstone (L20)

**Dominance of the Colossus**
- **Type**: Passive
- **Effect**: Colossal Might stacking system enhancement
- **BG3 Implementation**:
  - Colossal Might stacks to 10 (base is 5)
  - At 10 stacks: Shield Slam cooldown -1 turn, applies Sundered (-2 AC) for 3 turns
  - Demolish gains +1d12 damage per 2 stacks of Colossal Might
  - Tags: Passive, Enhancement, Stacking
```

---

### 6. Protection_Warrior_Talents_Extracted.md

**STATUS**: Need to verify structure

**REQUIRED CHANGES**:
1. Verify L20 Capstone timing (not L13)
2. Add specialization matrix: **Mountain Thane OR Colossus** (not Slayer)
3. Verify choice node levels match tier structure:
   - Mountain Thane: 4 tiers (L15, L16, L18, L19)
   - Colossus: 3 tiers (L15, L17, L19)
4. Add Mountain Thane full spec (if missing)
5. Add Colossus full spec (if missing)

---

### 7. Fury_Warrior_Talents_Extracted.md

**STATUS**: Need to verify structure

**REQUIRED CHANGES**:
1. Verify L20 Capstone timing (not L13)
2. Add specialization matrix: **Mountain Thane OR Slayer** (not Colossus)
3. Verify choice node levels match tier structure:
   - Mountain Thane: 4 tiers (L15, L16, L18, L19)
   - Slayer: 3 tiers (L15, L17, L19)
4. Add Mountain Thane full spec (if missing)
5. Add Slayer full spec (adapted for Fury - Bloodthirst instead of Overpower)

---

### 8. Warrior_Class_Blueprint.md

**STATUS**: Need to add comprehensive updates

**REQUIRED ADDITIONS**:
1. **Level 5 Extra Attack** section
2. **Corrected specialization matrix** (which specs get which specializations)
3. **Keystone L13 / Capstone L20** clarification
4. **5-Pool talent system overview** (link to detailed docs)

---

### 9. BG3_Global_Rules.md

**STATUS**: Referenced for Extra Attack, needs Warrior-specific notes

**REQUIRED ADDITIONS**:
1. Confirm Warrior follows "Extra Attack at L5" rule
2. Add Warrior resource system (Rage, 0-100 scale converted to 11 pips)
3. Add specialization timing notes (Keystone L13, Capstone L20)

---

## NEW DOCUMENTS NEEDED

### 1. WOW_TO_BG3_ABILITY_CONVERSION_GUIDE.md
**Purpose**: Master reference for converting WoW mechanics to BG3 stat files

**Content**:
- Damage formula conversions (WoW % weapon damage → BG3 dice)
- Status effect mappings (WoW debuffs → BG3 conditions)
- Cooldown conversions (WoW seconds → BG3 turns/rests)
- Rage cost scaling (WoW 0-100 → BG3 0-11 pips)
- Examples from existing abilities (Execute, Shield Slam, Charge, etc.)

### 2. WARRIOR_LEVEL_5_EXTRA_ATTACK.md
**Purpose**: Document L5 milestone for all Warrior specs

**Content**:
- BG3 Extra Attack mechanics (2 attacks per Attack action)
- Interaction with Warrior abilities (does Mortal Strike count as Attack action?)
- Progression.lsx implementation
- Status_BOOST entry for Extra Attack buff

### 3. CLASS_TALENTS_BG3_IMPLEMENTATIONS.md
**Purpose**: Complete BG3 stat file specs for all 24+ Class Talents

**Content**:
- Row-by-row breakdown (10 rows)
- Each ability: Spell_*.txt format, Status_BOOST entries, Passive wrappers
- Icon references
- Localization handle assignments

### 4. SUBCLASSSPEC_TALENTS_ARMS_BG3_IMPLEMENTATIONS.md
**Purpose**: Complete BG3 stat file specs for all 24+ Arms SubclassSpec Talents

**Content**:
- Row-by-row breakdown (10 rows)
- Mortal Strike, Overpower, Rend, Colossus Smash, Warbreaker, Bladestorm, etc.
- Full Spell_*.txt formats
- Status effects (Mortal Wound, Shattered Defenses, etc.)
- Interaction with baseline abilities

### 5. SPECIALIZATION_BG3_IMPLEMENTATIONS.md
**Purpose**: Complete BG3 stat file specs for all specialization abilities

**Content**:
- Colossus: Demolish, Colossal Might stacking, all choice talents
- Slayer: Slayer's Dominance, Marked for Execution mechanics, all choice talents
- Mountain Thane: Avatar of the Storm, lightning mechanics, all choice talents
- Passive implementations
- Complex status effects (stacking buffs, proc systems)

---

## IMPLEMENTATION PRIORITY

### Phase 1: Critical Corrections (IMMEDIATE)
1. ✅ Fix Capstone timing (L13 → L20) in ALL documents
2. ✅ Add L5 Extra Attack to ALL progression charts
3. ✅ Correct Arms specialization matrix (remove Mountain Thane, clarify Colossus/Slayer)
4. ✅ Fix choice node levels in Slayer (L15, L17, L19 not L13, L15, L18)

### Phase 2: Content Completion (HIGH PRIORITY)
5. ⏸️ Add full Colossus spec to Arms_Warrior_Talents_Extracted.md
6. ⏸️ Verify/correct Protection_Warrior_Talents_Extracted.md
7. ⏸️ Verify/correct Fury_Warrior_Talents_Extracted.md
8. ⏸️ Update Warrior_Class_Blueprint.md with 5-pool system overview

### Phase 3: New Documentation (MEDIUM PRIORITY)
9. ⏸️ Create WOW_TO_BG3_ABILITY_CONVERSION_GUIDE.md
10. ⏸️ Create WARRIOR_LEVEL_5_EXTRA_ATTACK.md
11. ⏸️ Create CLASS_TALENTS_BG3_IMPLEMENTATIONS.md
12. ⏸️ Create SUBCLASSSPEC_TALENTS_ARMS_BG3_IMPLEMENTATIONS.md
13. ⏸️ Create SPECIALIZATION_BG3_IMPLEMENTATIONS.md

### Phase 4: Cross-Reference Validation (LOW PRIORITY)
14. ⏸️ Update all ProjectDocuments references
15. ⏸️ Update SessionSummaries references
16. ⏸️ Verify all icon references
17. ⏸️ Verify all localization handle assignments

---

## CORRECTION TEMPLATES

### Template 1: 3-Tier Specialization Structure
```markdown
### Specialization Progression (3 Tiers)

- **L13**: Keystone (auto-granted)
- **L14**: Passive 1 (auto-granted)
- **L15**: 🔹 Choice Node 1 (pick 1 of 3)
- **L16**: Passive 2 (auto-granted)
- **L17**: 🔹 Choice Node 2 (pick 1 of 3)
- **L18**: Passive 3 (auto-granted)
- **L19**: 🔹 Choice Node 3 (pick 1 of 3)
- **L20**: Passive 4 + Capstone (auto-granted)

**Total**: 1 keystone + 1 capstone + 4 passives + 3 choices = **9 talents**
```

### Template 2: 4-Tier Specialization Structure
```markdown
### Specialization Progression (4 Tiers)

- **L13**: Keystone (auto-granted)
- **L14**: Passive 1 (auto-granted)
- **L15**: 🔹 Choice Node 1 (pick 1 of 3)
- **L16**: 🔹 Choice Node 2 (pick 1 of 3)
- **L17**: Passive 2 (auto-granted)
- **L18**: 🔹 Choice Node 3 (pick 1 of 3)
- **L19**: 🔹 Choice Node 4 (pick 1 of 3)
- **L20**: Passive 3 + Capstone (auto-granted)

**Total**: 1 keystone + 1 capstone + 3 passives + 4 choices = **9 talents**
```

### Template 3: Level 5 Extra Attack Entry
```markdown
## Level 5: Extra Attack

### Extra Attack
- **Type**: Feature
- **Effect**: When you take the Attack action, you can attack twice instead of once
- **BG3 Implementation**:
  - Passive feature
  - Applies to Attack action only (not bonus actions)
  - Works with all weapon attacks
  - Compatible with: Heroic Strike → Attack, Mortal Strike → Attack (if designed as Attack actions)
  - Does NOT stack with: Sweeping Strikes cleave (separate mechanic)
  - Tags: Feature, ExtraAttack
```

---

## VERIFICATION CHECKLIST

After corrections, verify:
- [ ] All specializations show Keystone at L13, Capstone at L20
- [ ] All progression charts include L5 Extra Attack
- [ ] Arms: Colossus OR Slayer (no Mountain Thane)
- [ ] Fury: Mountain Thane OR Slayer (no Colossus)
- [ ] Protection: Mountain Thane OR Colossus (no Slayer)
- [ ] Colossus: 3 tiers (L15, L17, L19)
- [ ] Slayer: 3 tiers (L15, L17, L19)
- [ ] Mountain Thane: 4 tiers (L15, L16, L18, L19)
- [ ] All new abilities have BG3 implementation notes
- [ ] All WoW mechanics converted to BG3 equivalents
- [ ] Cross-references between documents consistent

---

**END OF AUDIT REPORT**
