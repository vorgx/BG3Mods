# Resource System Audit - Action Required After FILES 4-10

**Date**: October 19, 2025  
**Status**: ⚠️ **PENDING** - Complete after stat file transformation  
**Source**: `EXCEL_ABILITY_COUNT_SUMMARY.md` (200+ abilities identified)  
**Current Resources**: 6 Warrior + 2 Warlock (8 total)

---

## 🚨 **WHY THIS AUDIT IS CRITICAL**

**Discovery**: Excel analysis revealed **200+ abilities/passives/talents** across the Warrior class, far more than initially estimated!

**Problem**: Current resource system was designed for ~50-100 abilities. With 200+ abilities, we need to verify:
1. ✅ **Rage costs** are balanced across 60+ offensive abilities
2. ✅ **Charge resources** correctly assigned to mobility/defensive abilities
3. ✅ **New resources** may be needed for ability categories we haven't considered
4. ✅ **Cooldown types** appropriate for each ability (OncePerTurn, OncePerShortRest, OncePerCombat)

---

## 📊 **CURRENT RESOURCE SYSTEM** (From CHARGE_RESOURCES_DEEP_DIVE.md)

| Resource Name | Max | Replenish | Used By | Abilities Assigned | Status |
|---------------|-----|-----------|---------|-------------------|--------|
| **Rage** | 100 | Never (combat-only, -5 decay) | All offensive abilities | ~60 abilities | ✅ **Validated** (see RAGE_COMBAT_SIMULATION.md) |
| **MobilityCharge** | 2 | Short Rest | Charge, Heroic Leap, Intervene, Storm Bolt | 4 abilities | ⚠️ **Verify** - Are there more mobility abilities in Excel? |
| **DefensiveCharge** | 1 | Long Rest | Die by the Sword, Berserker Rage | 2 abilities | ⚠️ **Verify** - Protection has many defensive CDs |
| **TankCooldown** | 1 | Long Rest | Last Stand, Shield Wall, Indomitable | 3 abilities | ⚠️ **Verify** - Only 1 charge for 3 abilities? |
| **OverpowerCharge** | 2 | Never (proc-based) | Overpower (Arms) | 1 ability | ✅ **Verified** - Proc from dodge/parry |
| **ThunderCharge** | 3 | Never (proc-based) | Thunder Clap (empowered) | 1 ability | ✅ **Verified** - Proc from Shield Slam |

---

## ⚠️ **ABILITIES REQUIRING RESOURCE AUDIT** (From Excel Count)

### **Category 1: Offensive Abilities (~60 total)**

**Known Rage Costs** (from existing stat files):
- Heroic Strike: -30 Rage ✅
- Execute: -20 to -40 Rage (variable) ✅
- Mortal Strike: -30 Rage ✅
- Bloodthirst: -20 Rage ✅

**Needs Rage Cost Assignment** (~56 more):
- **Baseline**: Slam, Whirlwind, Shield Slam, Devastate (4)
- **Class Talents**: Shockwave, Thunder Clap, Champion's Spear, Thunderous Roar (4)
- **Arms Spec**: Colossus Smash, Warbreaker, Bladestorm, Skullsplitter, Rend, Cleave, Impale (7+)
- **Fury Spec**: Bloodthirst, Raging Blow, Rampage, Recklessness, Onslaught, Odyn's Fury, Whirlwind (enhanced) (7+)
- **Protection Spec**: Revenge, Shield Charge, Devastate (enhanced), Thunder Clap (3+)
- **Specialization**: Lightning Strikes, Demolish, Thunder Blast, Arterial Blows, Death Drive, Burst of Power, etc. (~20+)

**Action**: Review each ability's power level and assign appropriate Rage cost (15-40 range)

---

### **Category 2: Mobility Abilities** (Current: 4, Potential: ?)

**Currently Assigned to MobilityCharge (2 max)**:
1. ✅ Charge (baseline)
2. ✅ Heroic Leap (Class Talent Row 3)
3. ✅ Intervene (Class Talent Row 2)
4. ✅ Storm Bolt (Class Talent Row 3)

**Potential Additional Mobility Abilities from Excel**:
- **Heroic Throw** (baseline) - Ranged pull, is this mobility? 🤔
- **Bounding Stride** (Class Talent Row 4) - Movement speed buff? 🤔
- **Double Time** (Class Talent Row 7) - Charge enhancement? 🤔
- **Shield Charge** (Protection Row 10) - Shield-based charge? 🤔

**Question**: Should these abilities:
- **Option A**: Use MobilityCharge (increase max to 3-4?)
- **Option B**: Use Rage costs instead?
- **Option C**: Have separate cooldowns (OncePerShortRest)?

---

### **Category 3: Defensive Abilities** (Current: 2, Potential: 10+)

**Currently Assigned to DefensiveCharge (1 max)**:
1. ✅ Die by the Sword (Arms Row 3)
2. ✅ Berserker Rage (baseline, Fury L1)

**Currently Assigned to TankCooldown (1 max)**:
1. ✅ Last Stand (Protection Row 5)
2. ✅ Shield Wall (Protection Row 7)
3. ✅ Indomitable (Protection Row 9)

**Potential Additional Defensive Abilities from Excel**:
- **Second Wind** (Class Talent Row 4) - Self-heal
- **Rallying Cry** (Class Talent Row 5) - Group heal
- **Spell Reflection** (Class Talent Row 5) - Reflect spell
- **Ignore Pain** (baseline Protection L3) - Damage reduction
- **Shield Block** (baseline Protection L3) - Block damage
- **Enraged Regeneration** (Fury Row 3) - Heal over time
- **Demoralizing Shout** (Protection Row 2) - Debuff enemies
- **Brace For Impact** (Protection Row 3) - Reduce incoming damage

**Problem**: 
- DefensiveCharge has 1 max, but we have 2 abilities assigned (Die by the Sword, Berserker Rage)
- TankCooldown has 1 max, but we have 3 abilities assigned (Last Stand, Shield Wall, Indomitable)
- 8+ more defensive abilities need resource assignment

**Question**: Should these abilities:
- **Option A**: Increase DefensiveCharge max to 2-3?
- **Option B**: Increase TankCooldown max to 2-3?
- **Option C**: Create separate resources (HealCharge, MitigationCharge)?
- **Option D**: Use Rage costs + cooldowns (e.g., -20 Rage + OncePerShortRest)?

---

### **Category 4: Buff/Shout Abilities** (Potential: 15+)

**Known Buff Abilities from Excel**:
- **Battle Shout** (baseline) - Attack power buff
- **Rallying Cry** (Class Talent Row 5) - HP buff
- **Intimidating Shout** (Class Talent Row 4) - Fear
- **Demoralizing Shout** (Protection Row 2) - Attack debuff
- **Berserker Shout** (Class Talent Row 7) - Remove CC from allies
- **Piercing Howl** (Class Talent Row 7) - Slow enemies
- **Thunderous Roar** (Class Talent Row 9) - AoE damage + debuff
- **Cacophonous Roar** (Class Talent Row 5) - Interrupt
- **Uproar** (Class Talent Row 10) - Thunderous Roar enhancement
- **Thunderous Words** (Class Talent Row 10) - Thunder damage boost
- **Berserker's Torment** (Class Talent Row 10) - Intimidating Shout enhancement
- **Booming Voice** (Protection Row 9) - Shout enhancement

**Current Resource Assignment**: NONE! (No ShoutCharge resource exists)

**Question**: Should shouts:
- **Option A**: Use Rage costs (e.g., -20 Rage per shout)?
- **Option B**: Create ShoutCharge resource (max 2-3, replenish Short Rest)?
- **Option C**: Use cooldowns only (OncePerShortRest, no resource cost)?

---

### **Category 5: Stance Abilities** (Current: 2)

**Known Stances from Excel**:
1. ✅ Battle Stance (auto-granted L1)
2. ✅ Defensive Stance (auto-granted L1)

**Current Resource Assignment**: FREE (no cost to switch)

**Question**: Should stance switching:
- **Option A**: Remain free (BG3 standard)?
- **Option B**: Cost -5 Rage per switch (WoW-like)?
- **Option C**: Use Bonus Action but remain free?

---

### **Category 6: Proc-Based Abilities** (Current: 2)

**Currently Assigned**:
1. ✅ Overpower (Arms) - Uses OverpowerCharge (2 max, proc from dodge/parry)
2. ✅ Thunder Clap (empowered) - Uses ThunderCharge (3 max, proc from Shield Slam)

**Potential Additional Proc-Based Abilities from Excel**:
- **Revenge** (Protection Row 2) - Procs after taking damage?
- **Sudden Death** (Arms Row 4, Fury Row 4) - Procs free Execute?
- **Bloodsurge** (Arms Row 4, Protection Row 5) - Procs instant Slam?
- **Tactician** (Arms Row 5) - Procs Overpower charge?

**Question**: Do these abilities need new proc resources, or do they work differently?

---

### **Category 7: Ultimate/Avatar Abilities** (Potential: 4+)

**Known Ultimate Abilities from Excel**:
- **Avatar** (Class Talent Row 9) - Transformation ultimate
- **Recklessness** (Fury Row 7) - Damage boost ultimate
- **Bladestorm** (Arms Row 9, Fury Row 9) - Whirlwind ultimate
- **Ravager** (Arms Row 9, Fury Row 9, Protection Row 10) - Ground-targeted AoE
- **Odyn's Fury** (Fury Row 9) - Lightning strike ultimate
- **Avatar of the Storm** (Mountain Thane capstone) - Ultimate transformation
- **Dominance of the Colossus** (Colossus capstone) - Ultimate power
- **Unrelenting Onslaught** (Slayer capstone) - Ultimate assault

**Current Resource Assignment**: NONE!

**Question**: Should ultimates:
- **Option A**: Use high Rage costs (e.g., -80 Rage)?
- **Option B**: Create UltimateCharge resource (max 1, replenish Long Rest)?
- **Option C**: Use cooldowns only (OncePerCombat or OncePerLongRest)?

---

## 🎯 **RESOURCE AUDIT WORKFLOW** (After FILES 4-10 Complete)

### **Phase 1: Categorize All Abilities** ✅

1. ✅ Read all `Spell_*.txt` files in `Data/Public/.../Stats/Generated/Data/`
2. ✅ Read `Passive.txt` for passive effects
3. ✅ Create spreadsheet: Ability Name | Type | Excel Source | Current Resource | Proposed Resource
4. ✅ Flag abilities with NO resource assignment

### **Phase 2: Identify Resource Gaps** ⚠️

1. ⚠️ Count abilities per resource (e.g., "20 abilities use DefensiveCharge but max is 1")
2. ⚠️ Identify new resource needs (e.g., "ShoutCharge doesn't exist but 12 shouts need it")
3. ⚠️ Flag resource max value mismatches (e.g., "TankCooldown max 1, but 3 abilities assigned")

### **Phase 3: Design New Resources** 🚧

For each gap, decide:
- **Resource Name** (e.g., ShoutCharge, UltimateCharge)
- **Max Value** (1-5 range typical)
- **Replenish Type** (Never, Short Rest, Long Rest, Combat)
- **Unlock Level** (when does player get this resource?)
- **Abilities Assigned** (which abilities use this resource?)

### **Phase 4: Update ActionResourceDefinitions.lsx** 🚧

1. 🚧 Add new resource nodes to `ActionResourceDefinitions.lsx`
2. 🚧 Update Progressions.lsx to grant new resources at appropriate levels
3. 🚧 Update all affected `Spell_*.txt` entries with new UseCosts
4. 🚧 Test in-game to verify resource display and functionality

### **Phase 5: Balance Validation** 🚧

1. 🚧 Run combat simulations with new resources (like RAGE_COMBAT_SIMULATION.md)
2. 🚧 Verify no resource starvation (always have resources to use abilities)
3. 🚧 Verify no resource overflow (never hit max and waste generation)
4. 🚧 Adjust max values or replenish rates as needed

---

## 📋 **QUESTIONS FOR USER** (Need Answers to Proceed)

### **Question 1: Defensive Abilities**
DefensiveCharge (1 max) has 2 abilities, TankCooldown (1 max) has 3 abilities, plus 8+ more defensive abilities in Excel.

**What should we do?**
- A) Increase DefensiveCharge max to 3, TankCooldown max to 3
- B) Merge into single DefensiveCooldown (max 5, Long Rest)
- C) Use Rage costs + cooldowns (e.g., -20 Rage + OncePerShortRest)
- D) Other solution?

### **Question 2: Shout Abilities**
12+ shout abilities in Excel, currently NO resource assigned.

**What should we do?**
- A) Create ShoutCharge resource (max 2-3, Short Rest)
- B) Use Rage costs (e.g., -20 Rage per shout)
- C) Use cooldowns only (OncePerShortRest, no resource)
- D) Other solution?

### **Question 3: Ultimate Abilities**
8+ ultimate abilities in Excel (Avatar, Recklessness, Bladestorm, etc.), currently NO resource assigned.

**What should we do?**
- A) Create UltimateCharge resource (max 1, Long Rest)
- B) Use high Rage costs (e.g., -80 Rage)
- C) Use cooldowns only (OncePerCombat)
- D) Other solution?

### **Question 4: Mobility Abilities**
4 abilities assigned to MobilityCharge (max 2), plus 4+ potential mobility abilities in Excel.

**What should we do?**
- A) Increase MobilityCharge max to 4
- B) Some mobility abilities use Rage costs instead
- C) Use cooldowns only (OncePerShortRest)
- D) Other solution?

### **Question 5: Protection L5 "Shield Block (2nd charge)"**
Excel shows Protection gets "Shield Block (2nd charge resource)" at L5.

**Clarification needed**:
- Is this granting a 2nd charge of Shield Block resource (max 1 → max 2)?
- Or is this a separate ability/passive that enhances Shield Block?
- How does this interact with TankCooldown resource?

---

## 🔧 **RECOMMENDED APPROACH** (Agent Suggestion)

Based on Excel analysis and BG3 standards, I recommend:

### **1. Keep Current Resources** ✅
- **Rage** (100 max) - Universal currency for offensive abilities
- **MobilityCharge** (increase to 3 max) - Charge, Heroic Leap, Intervene, Storm Bolt
- **OverpowerCharge** (2 max, proc) - Overpower
- **ThunderCharge** (3 max, proc) - Thunder Clap

### **2. Merge Defensive Resources** 🔄
- **DefensiveCooldown** (3 max, Long Rest) - Merges DefensiveCharge + TankCooldown
  - Die by the Sword, Berserker Rage, Last Stand, Shield Wall, Indomitable
  - Assigns remaining defensive abilities (Second Wind, Rallying Cry, Spell Reflection, etc.)

### **3. Create New Resources** ✨
- **ShoutCharge** (2 max, Short Rest) - All shout abilities (Battle Shout, Intimidating Shout, etc.)
- **UltimateCharge** (1 max, Long Rest) - Ultimate abilities (Avatar, Recklessness, Bladestorm, etc.)

### **4. Use Rage Costs for Remaining** 💰
- Buffs without shouts: -15 to -25 Rage
- Utility abilities: -10 to -20 Rage
- Minor abilities: -5 to -15 Rage

**Total Resources**: 6 Warrior resources (Rage, MobilityCharge, DefensiveCooldown, ShoutCharge, UltimateCharge, OverpowerCharge, ThunderCharge)

---

## ⏭️ **NEXT STEPS**

1. ⏸️ **Complete FILES 4-10 transformation** (implement all abilities in stat files)
2. ⏸️ **User answers Questions 1-5** (decide resource system structure)
3. ⏸️ **Run Phase 1 audit** (categorize all abilities from stat files)
4. ⏸️ **Implement resource changes** (ActionResourceDefinitions.lsx + Progressions.lsx)
5. ⏸️ **Update stat files** (assign UseCosts to all abilities)
6. ⏸️ **Run Phase 5 simulations** (validate balance)
7. ✅ **Document final resource system** in SOURCE_OF_TRUTH.md Section [10]

---

**Last Updated**: October 19, 2025  
**Status**: ⚠️ **BLOCKED** - Waiting for FILES 4-10 transformation + user decisions  
**Priority**: 🔴 **HIGH** - 200+ abilities need resource assignments!
