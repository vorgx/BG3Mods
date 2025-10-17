# Level 1 Passive Abilities - Detailed Breakdown
**Date:** October 16, 2025

---

## 🎯 LEVEL 1 PASSIVES EXPLAINED

### **Arms: WAR_ARMS_WeaponMastery**

**Based on Blueprint:** "Weapon Mastery" (unlockLevel: 3 in blueprint, moved to L1 as minor version)

**What It Does:**
- ✅ **+1 to Attack Rolls** when wielding a two-handed melee weapon
- ✅ **+1 to Damage Rolls** when wielding a two-handed melee weapon

**BG3 Implementation:**
```
Passive: WAR_ARMS_WeaponMastery
Conditions: Is wielding weapon with "Versatile" or "Two-Handed" property
Effect: AttackRollBonus(1), DamageBonus(1)
```

**Why This Works:**
- Greatswords, Greataxes, Halberds = +1 hit/+1 damage
- Encourages two-handed playstyle from Level 1
- Stacks with Strength modifier and proficiency bonus
- **Example:** Level 1 Arms with 16 STR, Greatsword
  - Base: +5 to hit (STR +3, Prof +2, Mastery +1)
  - Base: 2d6+3 damage → **2d6+4** with Mastery

**Blueprint Reference:**
- Full version unlocks at L3: "PASSIVE_VORGX_WAR_ARMS_WEAPONMASTER"
- This L1 version is the same effect, just earlier

---

### **Fury: WAR_FURY_DualWieldMastery**

**Based on Blueprint Passive:** "Enrage" (unlockLevel: 3 in blueprint, reinterpreted for L1)

**What It Does:**
- ✅ **+2 Rage** generated per melee attack that **hits**
- ✅ Enhances base Rage generation (normally +5 per hit from WAR_RageGeneration)
- ✅ Total: **+7 Rage per hit** (5 base + 2 from mastery)

**BG3 Implementation:**
```
Passive: WAR_FURY_DualWieldMastery
Trigger: OnMeleeAttackHit
Effect: RestoreResource(Rage, 2)
```

**Why This Works:**
- Fury dual-wields = more attacks = more Rage
- Encourages aggressive playstyle
- With dual-wield at L1: Main hand hit (+7 Rage) + off-hand hit (+7 Rage) = **+14 Rage per round**
- Feeds into Fury's high-Rage spender abilities (Rampage costs 40)

**Example Rage Economy:**
- Turn 1: Attack x2 (main + off-hand) = +14 Rage → Total: 14 Rage
- Turn 2: Attack x2 = +14 Rage → Total: 28 Rage
- Turn 3: Attack x2 = +14 Rage → Total: 42 Rage → **Can use Rampage (40 Rage)**

**Blueprint Reference:**
- Differs from blueprint "Enrage" (crit-based damage buff)
- This is a **Rage economy passive** to enable dual-wield Rage generation fantasy
- Makes Fury the fastest Rage-generating spec

---

### **Protection: WAR_PROT_ShieldSpecialization**

**Based on Blueprint:** "Shield Specialization" (unlockLevel: 3 in blueprint, moved to L1)

**What It Does:**
- ✅ **+2 Armor Class (AC)** when wielding a shield
- ✅ Stacks with shield's base +2 AC bonus
- ✅ Total shield AC bonus: **+4 AC** (+2 shield base + 2 specialization)

**BG3 Implementation:**
```
Passive: WAR_PROT_ShieldSpecialization
Conditions: Has shield equipped
Effect: ACBonus(2)
```

**Why This Works:**
- Protection = tank spec
- Starting AC at L1: **21 AC** (17 Splint + 4 shield)
- Highest AC of any Level 1 class in BG3
- Encourages sword-and-board tanking

**Level 1 AC Comparison:**
- Fighter (Chain + Shield): 18 AC (16 + 2)
- Cleric (Chain + Shield): 18 AC (16 + 2)
- **Protection Warrior:** **21 AC** (17 Splint + 2 shield + 2 passive)

**Blueprint Reference:**
- Exact same as blueprint "PASSIVE_VORGX_WAR_PROT_SHIELD_SPEC" (unlockLevel: 3)
- We're just granting it at L1 instead for early identity

---

## 📊 PASSIVE COMPARISON TABLE

| Passive | Arms Weapon Mastery | Fury Dual-Wield Mastery | Prot Shield Spec |
|---------|---------------------|-------------------------|------------------|
| **Type** | Combat accuracy | Resource generation | Defense |
| **Benefit** | +1 hit/+1 dmg (2H) | +2 Rage per hit | +2 AC (shield) |
| **Conditions** | Two-handed weapon | Melee attack hits | Shield equipped |
| **Playstyle** | Greatsword striker | Dual-wield berserker | Sword-and-board tank |
| **Level 1 Impact** | 5% better hit chance, +1 damage | 40% faster Rage gen | 3 AC higher than peers |
| **Scales With** | STR, weapon upgrades | Attack speed, dual-wield | Shield upgrades, armor |

---

## 🔧 STATS FILE IMPLEMENTATION (Future Reference)

### Arms Weapon Mastery
```
new entry "WAR_ARMS_WeaponMastery"
type "PassiveData"
data "DisplayName" "h_WAR_ARMS_WeaponMastery"
data "Description" "h_WAR_ARMS_WeaponMastery_Desc"
data "Icon" "PassiveFeature_Generic_Damage"
data "Properties" "IsHidden"
data "Boosts" "IF(IsTwoHandedWeapon()):AttackRollBonus(1);IF(IsTwoHandedWeapon()):DamageBonus(1)"
```

### Fury Dual-Wield Mastery
```
new entry "WAR_FURY_DualWieldMastery"
type "PassiveData"
data "DisplayName" "h_WAR_FURY_DualWieldMastery"
data "Description" "h_WAR_FURY_DualWieldMastery_Desc"
data "Icon" "PassiveFeature_Generic_Damage"
data "Properties" "IsHidden"
data "Boosts" "IF(IsMeleeAttack()):RestoreResource(Rage,2,0)"
```

### Protection Shield Specialization
```
new entry "WAR_PROT_ShieldSpecialization"
type "PassiveData"
data "DisplayName" "h_WAR_PROT_ShieldSpecialization"
data "Description" "h_WAR_PROT_ShieldSpecialization_Desc"
data "Icon" "PassiveFeature_ShieldProficiency"
data "Properties" "IsHidden"
data "Boosts" "IF(HasShieldEquipped()):ACBonus(2)"
```

---

## ✅ CONFIRMED IMPLEMENTATION

**Per User Decision:**
1. ✅ Passive names confirmed: WAR_ARMS_WeaponMastery, WAR_FURY_DualWieldMastery, WAR_PROT_ShieldSpecialization
2. ✅ Placeholder UUIDs for SpellLists and SkillLists (will document for later)
3. ✅ Improved Extra Attack at Level 11 (3 attacks like Fighter)
4. ✅ Placeholder UUIDs for SpellLists and SkillLists
5. ✅ ASI only at Level 20 (5 total: 4/8/12/16/20) - user clarified it's a **feat choice**, not automatic

---

## 🎓 ASI CLARIFICATION

**Important:** User clarified that in BG3, you only get Ability Score Improvement if you **choose the ASI feat** instead of another feat.

**BG3 Feat System:**
- Levels 4, 8, 12, 16, 20: Player gets **feat choice**
- One option is always "Ability Score Improvement" feat (+2 to one stat or +1 to two stats)
- Other options: Great Weapon Master, Alert, Lucky, etc.

**Progressions.lsx Implementation:**
- Use `AllowImprovement="true"` at levels 4/8/12/16/20
- This enables the feat selection UI
- Player chooses between ASI or combat feats

**Not like D&D where ASI is automatic!**

---

## 📝 NEXT: Generate Progressions.lsx

With all decisions confirmed, ready to generate complete Progressions.lsx file!
