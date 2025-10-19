# Warrior Charge-Based Resource Analysis

**Date**: October 18, 2025  
**Purpose**: Identify Warrior abilities that could benefit from charge-based resources (like Warlock's 10-resource system)  
**Context**: FILE 3 transformation - considering whether to keep single Rage resource or add charge-based resources

---

## 🎯 Executive Summary

**Current System**: 1 resource (Rage 0-100, never replenishes outside combat)  
**Warlock System**: 10 resources (1 primary + 9 charges for specific abilities/talents)  

**Recommendation**: **Hybrid System** - Keep Rage as primary + add 5 charge-based resources for cooldown abilities

---

## 📊 Warlock Resource Pattern Analysis

### How Warlock Uses Charges

| Resource Type | Purpose | Example Abilities | Max Charges | Replenish |
|---------------|---------|-------------------|-------------|-----------|
| **Primary Resource** | Spent on all major spells | Soul Shard (5) | 5 | ShortRest |
| **Cooldown Replacement** | Replace OncePerShortRest with charges | Soulfire (1), Havoc (1) | 1 | Rest |
| **Proc-Based Buffs** | Grant charges when conditions met | Demonic Core (4) | 4 | Rest |
| **Stacking Buffs** | Multiple charges = stronger effect | Tormented Crescendo (3) | 3 | Rest |
| **Resource Fragments** | Small charges combine into primary | Soul Shard Fragment (30) | 30 | Rest |

**Key Insight**: Warlock uses charges to:
1. Replace cooldowns with limited-use charges (more flexible)
2. Track proc-based mechanics (Demonic Core on Hand of Gul'dan)
3. Create resource management mini-games (spend charges vs. save for big spell)

---

## 🛡️ Warrior Abilities: Charge Opportunity Analysis

### Total Warrior Abilities Analyzed
- **135 total entries** across 7 stat files
- **27 abilities with cooldowns** (OncePerShortRest, OncePerTurn)
- **33 hero talent passives** (3 specializations × 11 talents each)
- **55 status effects** (buffs/debuffs tracked)

---

## 💡 CANDIDATES FOR CHARGE-BASED RESOURCES

### Category 1: **Cooldown Replacement Charges** (High Priority)

These abilities currently use `OncePerShortRest` cooldowns and could instead use charges:

| Ability | Current Cooldown | Suggested Charge | Max Charges | Replenish | Rationale |
|---------|------------------|------------------|-------------|-----------|-----------|
| **Heroic Leap** | OncePerShortRest | `HeroicLeapCharge` | 2 | ShortRest | Multiple gap closers per combat |
| **Intervene** | OncePerShortRest | `InterveneCharge` | 2 | ShortRest | Protect allies multiple times |
| **Storm Bolt** | OncePerShortRest | `StormBoltCharge` | 2 | ShortRest | Stun multiple targets |
| **Die by the Sword** | OncePerShortRest | `DefensiveCharge` | 1 | ShortRest | Major defensive cooldown |
| **Berserker Rage** | OncePerShortRest | `DefensiveCharge` | 1 | ShortRest | Share with Die by the Sword |
| **Last Stand** | OncePerShortRest | `TankCooldown` | 1 | Rest | Ultimate tank survival |
| **Shield Wall** | OncePerShortRest | `TankCooldown` | 1 | Rest | Ultimate tank defense |
| **Indomitable** | OncePerShortRest | `TankCooldown` | 1 | Rest | Ultimate tank immunity |

**Benefits**:
- More flexible than hard cooldowns (can use 2 charges back-to-back if needed)
- Better telegraphing to players ("2 charges remaining")
- Can be modified by talents (e.g., "Gain +1 Heroic Leap charge")

---

### Category 2: **Proc-Based Mechanics** (Medium Priority)

Abilities that trigger charges when conditions are met (like Demonic Core):

| Mechanic | Current Implementation | Suggested Charge | Max Charges | Trigger Condition |
|----------|------------------------|------------------|-------------|-------------------|
| **Overpower Proc** | Status: WAR_OVERPOWER_PROC | `OverpowerCharge` | 2 | Dodge/Parry enemy attack |
| **Victory Rush Proc** | Status: WAR_VICTORIOUS | `VictoryCharge` | 1 | Kill an enemy |
| **Thunder Blast** | Status: WAR_THUNDER_BLAST_CHARGE | `ThunderCharge` | 3 | Shield Slam crits (35%) |
| **Colossal Might** | Status: WAR_COLOSSAL_MIGHT | `ColossalCharge` | 5 | Shield Slam hits |
| **Sweeping Strikes** | Status: WAR_SWEEPING_STRIKES | `SweepingCharge` | 6 | Duration-based (6 attacks) |

**Benefits**:
- Visual resource bar shows "you have 3 Thunder Blast charges ready!"
- More intuitive than hidden status effects
- Can spend charges strategically (save for burst damage)

---

### Category 3: **Specialization Resources** (Low Priority)

Hero talent specializations could have unique resources (like Warlock specs):

| Specialization | Resource Name | Max Charges | Purpose | Replenish |
|----------------|---------------|-------------|---------|-----------|
| **Mountain Thane** | `LightningStrike` | 10 | Track lightning procs (25% chance) | Combat |
| **Colossus** | `ColossalMight` | 5 | Empower next Shield Slam | Combat |
| **Slayer** | `ExecutionMark` | 3 | Track Execute targets marked | Combat |

**Benefits**:
- Distinct visual identity for each specialization
- Build-around resource (talents modify generation/spending)
- Adds depth to L13-20 gameplay

---

### Category 4: **NOT Recommended for Charges**

These should remain as-is:

| Ability Type | Reason |
|--------------|--------|
| **Rage-costing abilities** | Already use Rage resource |
| **OncePerTurn abilities** | Too frequent for charge system |
| **Passive buffs** | No active spending mechanic |
| **DoT/Bleed effects** | Status effects work better |

---

## 🎨 RECOMMENDED CHARGE RESOURCES (5 Total)

### Proposed ActionResourceDefinitions

| # | Resource Name | Max | Replenish | Used By | Specialization |
|---|---------------|-----|-----------|---------|----------------|
| **1** | **Rage** (keep) | 100 | Never | All abilities | All |
| **2** | **DefensiveCharge** | 1 | Rest | Die by the Sword, Berserker Rage | All |
| **3** | **TankCooldown** | 1 | Rest | Last Stand, Shield Wall, Indomitable | Protection |
| **4** | **MobilityCharge** | 2 | ShortRest | Heroic Leap, Intervene | All |
| **5** | **OverpowerCharge** | 2 | Never | Overpower (reactive) | Arms |
| **6** | **ThunderCharge** | 3 | Never | Thunder Blast (Mountain Thane) | Mountain Thane |

**Total**: 1 primary + 5 charges = 6 resources (vs Warlock's 10)

---

## 📋 IMPLEMENTATION IMPACT

### File Changes Required

| File | Change Description | Complexity |
|------|-------------------|------------|
| **ActionResourceDefinitions.lsx** | Add 5 new charge resources | LOW |
| **Spell_*.txt** (8 abilities) | Change cooldowns to UseCosts | MEDIUM |
| **Passive.txt** (5 passives) | Grant charges via Boosts | LOW |
| **Status_BOOST.txt** (3 statuses) | Replace statuses with RestoreResource | LOW |
| **Localization** | Add DisplayName/Description for 5 resources | MEDIUM |

**Total Effort**: ~4-6 hours (vs. 15 minutes for Rage-only)

---

## ✅ DECISION MATRIX

### Option A: Rage Only (Original Plan)
**Pros**:
- Simple, fast to implement (15 minutes)
- Matches original Warrior design
- Less complexity for players

**Cons**:
- Cooldowns feel rigid (can't use 2 Heroic Leaps back-to-back)
- No visual feedback for procs (Overpower ready)
- Less depth than Warlock system

### Option B: Rage + 5 Charges (Hybrid)
**Pros**:
- Retains Rage identity
- Adds tactical depth (charge management)
- Visual proc tracking (Overpower charges)
- Flexible cooldowns (spend charges when needed)
- Matches Warlock's proven design pattern

**Cons**:
- More implementation time (4-6 hours)
- Slightly more complex for players
- Need to balance charge generation/spending

### Option C: Full Warlock Clone (10 Resources)
**Pros**:
- Maximum depth and customization

**Cons**:
- Over-engineered for Warrior (doesn't fit class fantasy)
- Too complex - Warrior should be simpler than caster

---

## 🎯 FINAL RECOMMENDATION

**Option B: Rage + 5 Charges (Hybrid System)**

**Rationale**:
1. **Proven Pattern**: Warlock mod has 13K+ downloads, system is tested
2. **Tactical Depth**: Charge management > rigid cooldowns
3. **Visual Feedback**: Players see "2 Overpower charges" vs. hidden status
4. **Flexibility**: Can use charges strategically (save for burst)
5. **Spec Identity**: Thunder Charge makes Mountain Thane feel unique

**Next Steps**:
1. Get user approval for hybrid system vs. Rage-only
2. If approved, design 5 charge resources in detail
3. Transform ActionResourceDefinitions.lsx with 6 total resources
4. Update spell files to use charges instead of cooldowns

---

## 📊 DETAILED ABILITY BREAKDOWN

### Abilities with OncePerShortRest (12 total)

| Ability | File | Line | Spec | Charge Candidate? |
|---------|------|------|------|-------------------|
| Demolish | Spell_Target.txt | 248 | All | ❌ (Rage-based) |
| Die by the Sword | Spell_Target.txt | 407 | All | ✅ DefensiveCharge |
| Colossus Smash | Spell_Target.txt | 478 | Arms | ❌ (Major cooldown) |
| Rend | Spell_Target.txt | 520 | Arms | ❌ (DoT ability) |
| Deadly Calm | Spell_Target.txt | 629 | Arms | ❌ (Buff duration) |
| Berserker Rage | Spell_Target.txt | 842 | Fury | ✅ DefensiveCharge |
| Enraged Regeneration | Spell_Target.txt | 955 | Fury | ❌ (Heal over time) |
| Last Stand | Spell_Target.txt | 1024 | Protection | ✅ TankCooldown |
| Shield Wall | Spell_Target.txt | 1056 | Protection | ✅ TankCooldown |
| Indomitable | Spell_Target.txt | 1088 | Protection | ✅ TankCooldown |
| Heroic Leap | Spell_Jump.txt | 37 | All | ✅ MobilityCharge |
| Intervene | Spell_Jump.txt | 74 | All | ✅ MobilityCharge |
| Storm Bolt | Spell_Projectile.txt | 75 | All | ✅ MobilityCharge |
| Shockwave | Spell_Zone.txt | 83 | All | ❌ (Major CC) |

**Charge Candidates**: 8 abilities (67% of cooldown abilities)

---

## 🔍 STATUS EFFECTS THAT COULD BE CHARGES

Currently tracked as status effects but could be resources:

| Status Name | File Line | Purpose | Charge Name | Max |
|-------------|-----------|---------|-------------|-----|
| WAR_OVERPOWER_PROC | Status_BOOST:796 | Enable Overpower | OverpowerCharge | 2 |
| WAR_VICTORIOUS | Status_BOOST:611 | Enable Victory Rush | VictoryCharge | 1 |
| WAR_THUNDER_BLAST_CHARGE | Status_BOOST:259 | Enable Thunder Blast | ThunderCharge | 3 |
| WAR_SWEEPING_STRIKES | Status_BOOST:475 | Track attacks left | SweepingCharge | 6 |
| WAR_BURST_OF_POWER | Status_BOOST:243 | Lightning damage buff | (Keep as status) | N/A |

**Recommended**: Convert first 3 to charges (Overpower, Victory Rush, Thunder Blast)

---

## 📝 USER DECISION NEEDED

**Question**: Which system should we implement for FILE 3?

**A) Rage Only** (15 min, simple)
- 1 resource total
- Keep all cooldowns as OncePerShortRest

**B) Rage + 5 Charges** (4-6 hours, recommended)
- 6 resources total
- Replace cooldowns with charges
- Add proc-based charge generation

**C) Custom Hybrid** (you tell me what you want)
- Mix and match from analysis above

**Please approve A, B, or provide custom requirements before I proceed with FILE 3 transformation.**
