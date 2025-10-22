# Level 3 Unlock Breakdown - Visual Example

**Date**: October 22, 2025  
**Purpose**: Show how unlock levels will be populated from progression CSV  
**Example Level**: 3

---

## 📊 Level 3 - What Unlocks

### From Progression CSV (Row 3)

#### 🔴 **Arms Warrior** (Baseline Abilities)
```
Offensive: Execute (Exe) - Arms' version of Execute
Utility:   Pummel - low cooldown interrupt.
```

#### 🔵 **Protection Warrior** (Baseline Abilities)
```
Offensive: Devastate - A very basic damaging skill that has a lot of talent interactions.
Utility:   Shield Block (SB) - Primary defensive skill. Very powerful damage mitigation while active.
Passive:   Riposte - A very simple Crit to Parry conversion.
```

#### 🟢 **Fury Warrior** (Baseline Abilities)
```
Offensive: Slam - initial rage spender, quickly replaced by other abilities.
Utility:   Charge - primary mobility and gap closer.
```

#### 🟡 **Warrior Class Talents** (All Subclasses - CHOICES)
```
Impending Victory (IV) - on-demand version of Victory Rush.
Heroic Leap (Leap) - burst mobility skill...
Storm Bolt - useful ranged stun on a relatively low cooldown.
```
**Note**: These are CHOICES (pick 1), not auto-granted

#### 🟠 **Arms Spec Talents** (Arms Only - CHOICES)
```
Martial Prowess - enables Overpower's buff.
Die by the Sword (DbtS) - Arms primary defensive cooldown.
Improved Execute - enables Arms Execute.
```
**Note**: These are CHOICES (pick 1), not auto-granted

#### 🟣 **Fury Spec Talents** (Fury Only - CHOICES)
```
Frenzied Enrage - greatly increases the speed of Fury gameplay.
Powerful Enrage - large damage increase without increasing the speed of Fury gameplay.
Enraged Regeneration (ER) - Fury's primary defensive cooldown.
Improved Execute - turns Execute into a rage generator.
```
**Note**: These are CHOICES (pick 1), not auto-granted

#### 🟤 **Protection Spec Talents** (Protection Only - CHOICES)
```
Brace For Impact (BFI) - Stacking buff that grants 10% Shield Slam damage...
Armor Specialization - Basic Armor increase...
Fight Through the Flames (FTTF) - Newly added in The War Within...
Devastator - Excellent rotation-smoothing talent, must-have talent. DO NOT TRY TO SKIP THIS.
```
**Note**: These are CHOICES (pick 1), not auto-granted

---

## 🎯 How This Translates to Database

### ✅ **AUTO-GRANTED BASELINE ABILITIES**

These get unlock levels populated:

| Ability Name | warrior_unlock | arms_unlock | fury_unlock | protection_unlock | Reason |
|--------------|----------------|-------------|-------------|-------------------|--------|
| **Execute** | **(empty)** | **3** | **(empty)** | **(empty)** | Only Arms gets it at L3 (Fury gets at L7, Prot at L10) |
| **Pummel** | **(empty)** | **3** | **(empty)** | **(empty)** | Only Arms gets it at L3 (Fury gets at L5, Prot at L7) |
| **Devastate** | **(empty)** | **(empty)** | **(empty)** | **3** | Protection-only baseline ability |
| **Shield Block** | **(empty)** | **(empty)** | **(empty)** | **3** | Protection-only baseline ability |
| **Riposte** | **(empty)** | **(empty)** | **(empty)** | **3** | Protection-only baseline ability |
| **Slam** | **(empty)** | **(empty)** | **3** | **(empty)** | Only Fury gets it at L3 (Arms/Prot get at L7) |
| **Charge** | **(empty)** | **(empty)** | **3** | **(empty)** | Only Fury gets it at L3 (Arms gets at L1, Prot at L5) |

### ❌ **TALENT CHOICES - NOT POPULATED YET**

These are player choices, not auto-granted, so unlock levels need different handling:

| Ability Name | Type | Notes |
|--------------|------|-------|
| Impending Victory | Class Talent | Player choice at L3 |
| Heroic Leap | Class Talent | Player choice at L3 |
| Storm Bolt | Class Talent | Player choice at L3 |
| Martial Prowess | Arms Spec Talent | Player choice at L3 |
| Die by the Sword | Arms Spec Talent | Player choice at L3 |
| Improved Execute | Arms Spec Talent | Player choice at L3 |
| Frenzied Enrage | Fury Spec Talent | Player choice at L3 |
| Powerful Enrage | Fury Spec Talent | Player choice at L3 |
| Enraged Regeneration | Fury Spec Talent | Player choice at L3 |
| Improved Execute (Fury) | Fury Spec Talent | Player choice at L3 |
| Brace For Impact | Prot Spec Talent | Player choice at L3 |
| Armor Specialization | Prot Spec Talent | Player choice at L3 |
| Fight Through the Flames | Prot Spec Talent | Player choice at L3 |
| Devastator | Prot Spec Talent | Player choice at L3 |

**Question**: Should talent choices also get unlock levels? Or only auto-granted abilities?

---

## 🔍 **Key Observations**

### 1. **Execute Appears Multiple Times**
- Arms gets "Execute" at L3
- Fury gets "Execute" at L7
- Protection gets "Execute" at L10
- **Result**: `warrior_unlock = (empty)` because different levels
- Each spec column gets its own level: `arms_unlock = 3, fury_unlock = 7, protection_unlock = 10`

### 2. **Charge Appears Multiple Times**
- Arms gets "Charge" at L1
- Fury gets "Charge" at L3
- Protection gets "Charge" at L5
- **Result**: `warrior_unlock = (empty)` because different levels
- Each spec column gets its own level: `arms_unlock = 1, fury_unlock = 3, protection_unlock = 5`

### 3. **Pummel Appears Multiple Times**
- Arms gets "Pummel" at L3
- Fury gets "Pummel" at L5
- Protection gets "Pummel" at L7
- **Result**: `warrior_unlock = (empty)` because different levels
- Each spec column gets its own level: `arms_unlock = 3, fury_unlock = 5, protection_unlock = 7`

### 4. **Some Abilities Are Spec-Exclusive**
- "Devastate" only appears in Protection column
- "Shield Block" only appears in Protection column
- "Riposte" only appears in Protection column
- **Result**: `warrior_unlock = (empty)`, `arms_unlock = (empty)`, `fury_unlock = (empty)`, `protection_unlock = 3`

---

## 🤔 **Questions for User**

### Q1: Talent Choices
**Should talent choice abilities also get unlock levels?**
- ✅ **YES**: Populate unlock level when talent becomes AVAILABLE (even if not auto-granted)
- ❌ **NO**: Only populate unlock levels for AUTO-GRANTED abilities

**Current assumption**: Only populate AUTO-GRANTED abilities (baseline + Row 1/2 auto-grants)

### Q2: warrior_unlock Logic
**When should `warrior_unlock` be populated?**

**Option A** (Current understanding):
- Only when ALL specs get the ability at the SAME level
- Example: Battle Stance (all get at L1) → `warrior_unlock = 1`
- Example: Execute (different levels) → `warrior_unlock = (empty)`

**Option B** (Alternative):
- Never populate `warrior_unlock` at all (use only spec-specific columns)

**Current assumption**: Option A

---

## 📋 **Script Behavior for Level 3**

```powershell
# Parsing Level 3 row from CSV

# Arms baseline abilities
Add to database:
  Execute:  arms_unlock = 3
  Pummel:   arms_unlock = 3

# Protection baseline abilities
Add to database:
  Devastate:     protection_unlock = 3
  Shield Block:  protection_unlock = 3
  Riposte:       protection_unlock = 3

# Fury baseline abilities
Add to database:
  Slam:    fury_unlock = 3
  Charge:  fury_unlock = 3 (also update earlier Arms entry: arms_unlock = 1)

# Class talent choices (skip for now - not auto-granted)
Skip: Impending Victory, Heroic Leap, Storm Bolt

# Spec talent choices (skip for now - not auto-granted)
Skip: All Arms/Fury/Protection spec talent choices
```

---

## ✅ **Expected Database Updates After Processing L3**

| Ability | Before | After |
|---------|--------|-------|
| Execute | `arms_unlock = ''` | `arms_unlock = 3` |
| Pummel | `arms_unlock = ''` | `arms_unlock = 3` |
| Devastate | `protection_unlock = ''` | `protection_unlock = 3` |
| Shield Block | `protection_unlock = ''` | `protection_unlock = 3` |
| Riposte | `protection_unlock = ''` | `protection_unlock = 3` |
| Slam | `fury_unlock = ''` | `fury_unlock = 3` |
| Charge | `arms_unlock = '', fury_unlock = ''` | `arms_unlock = 1, fury_unlock = 3` (L1 from earlier row) |

---

## 🎯 **Is This the Expected Behavior?**

Please confirm:
1. ✅ Only auto-granted baseline abilities get unlock levels (not talent choices)
2. ✅ `warrior_unlock` stays empty unless ALL specs get at SAME level
3. ✅ Each spec column gets its unlock level even if different from others
4. ✅ Abilities appearing at multiple levels get ALL levels recorded (e.g., Charge at L1/L3/L5)

**Waiting for confirmation before finalizing script logic!** 🚦
