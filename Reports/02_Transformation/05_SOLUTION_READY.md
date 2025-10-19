# 🎯 FINAL SOLUTION: Fix Naming Mismatches

**Date:** October 18, 2024  
**Status:** ✅ **SOLUTION IDENTIFIED - READY TO IMPLEMENT**

---

## 🔍 REFINED ROOT CAUSE

**The crash is caused by naming mismatches between:**
- `Progressions.lsx` (references spells WITHOUT prefixes)
- `Spell_*.txt` files (define spells WITH prefixes)

**Example:**
```xml
<!-- Progressions.lsx says: -->
<attribute id="AddSpells" value="WAR_Charge" />

<!-- But Spell_Target.txt has: -->
new entry "Target_WAR_Charge"

<!-- Game looks for "WAR_Charge", can't find it → CRASH -->
```

---

## 📊 DETAILED ANALYSIS

### **Spells That Exist With Wrong Names:**

| Progressions Reference | Actual Stat Entry | File | Status |
|------------------------|-------------------|------|--------|
| `WAR_Charge` | `Target_WAR_Charge` | Spell_Target.txt | ✅ EXISTS |
| `WAR_Execute` | `Target_WAR_Execute` | Spell_Target.txt | ✅ EXISTS |
| `WAR_BattleShout` | `Shout_WAR_BattleShout` | Spell_Shout.txt | ✅ EXISTS |
| `WAR_ARMS_Overpower` | `Target_WAR_ARMS_Overpower` | Spell_Target.txt | ✅ EXISTS |

### **Spells That Genuinely Don't Exist:**

| Progressions Reference | Expected Location | Status |
|------------------------|-------------------|--------|
| `WAR_HeroicStrike` | Spell_Target.txt? | ❌ MISSING |
| `WAR_ARMS_MortalStrike` | Spell_Target.txt | ❌ MISSING |
| `WAR_DefensiveStance` | Spell_Shout.txt? | ❌ MISSING |
| `WAR_IntimidatingShout` | Spell_Shout.txt | ❌ MISSING |
| `WAR_HeroicLeap` | Spell_Jump.txt | ❌ MISSING |
| `WAR_RallyingCry` | Spell_Shout.txt | ❌ MISSING |
| `WAR_Hamstring` | Spell_Target.txt | ❌ MISSING |
| `WAR_SpellReflection` | Spell_Target.txt? | ❌ MISSING |
| `WAR_DiebytheSword` | Spell_Target.txt | ❌ MISSING |
| `WAR_ARMS_ColossusSmash` | Spell_Target.txt | ❌ MISSING |
| `WAR_ARMS_SweepingStrikes` | Spell_Zone.txt? | ❌ MISSING |
| `WAR_ARMS_Warbreaker` | Spell_Zone.txt | ❌ MISSING |
| `WAR_FURY_RagingBlow` | Spell_Target.txt | ❌ MISSING |
| `WAR_PROT_Shockwave` | Spell_Zone.txt | ❌ MISSING |
| `WAR_Avatar` | Spell_Shout.txt? | ❌ MISSING |
| `Shout_WAR_ShieldBlock` | Spell_Shout.txt | ❌ MISSING |

---

## 🛠️ THE FIX - Option 1: Rename in Progressions (FASTEST)

**Strategy:** Update Progressions.lsx to use correct prefixed names.

### **Find & Replace Operations:**

```xml
<!-- Level 1 -->
BEFORE: value="WAR_Charge;WAR_HeroicStrike"
AFTER:  value="Target_WAR_Charge;WAR_HeroicStrike"  <!-- Charge fixed, HeroicStrike still missing -->

<!-- Level 2 -->
BEFORE: value="WAR_BattleShout"
AFTER:  value="Shout_WAR_BattleShout"

<!-- Level 5 -->
BEFORE: value="WAR_Execute"
AFTER:  value="Target_WAR_Execute"

<!-- Arms Level 3 -->
BEFORE: value="WAR_ARMS_MortalStrike;WAR_ARMS_Overpower"
AFTER:  value="WAR_ARMS_MortalStrike;Target_WAR_ARMS_Overpower"  <!-- Overpower fixed, MortalStrike still missing -->
```

### **Exact Line Changes Needed:**

I'll search Progressions.lsx for the exact lines and provide replacements.

---

## 🛠️ THE FIX - Option 2: Quick Test (Comment Out Missing)

**Strategy:** Temporarily disable ALL missing abilities to test if this fixes the crash.

```xml
<!-- Level 1 - Keep only working abilities -->
<attribute id="AddSpells" value="Target_WAR_Charge" />
<!-- WAR_HeroicStrike removed temporarily -->

<!-- Level 2 -->
<attribute id="AddSpells" value="Shout_WAR_BattleShout" />

<!-- Level 5 -->
<attribute id="AddSpells" value="Target_WAR_Execute" />
```

**Expected Result:** 
- Character creation WORKS ✅
- Character has only 3-4 abilities (proof of concept)
- Confirms naming mismatch was the crash cause

---

## 🎯 RECOMMENDED IMMEDIATE ACTION

### **Step 1: Create Test Fix (5 minutes)**

Update `Progressions.lsx` Line 16 (Level 1):

```xml
<!-- BEFORE -->
<attribute id="AddSpells" type="LSString" value="WAR_Charge;WAR_HeroicStrike" />

<!-- AFTER (Test Fix) -->
<attribute id="AddSpells" type="LSString" value="Target_WAR_Charge" />
```

Update Line 53 (Level 2):

```xml
<!-- BEFORE -->
<attribute id="AddSpells" type="LSString" value="WAR_BattleShout" />

<!-- AFTER (Test Fix) -->
<attribute id="AddSpells" type="LSString" value="Shout_WAR_BattleShout" />
```

Update Line 63 (Level 5):

```xml
<!-- BEFORE -->
<attribute id="AddSpells" type="LSString" value="WAR_Execute" />

<!-- AFTER (Test Fix) -->
<attribute id="AddSpells" type="LSString" value="Target_WAR_Execute" />
```

### **Step 2: Package & Test (2 minutes)**

```powershell
# Package mod
& "LsLib\Tools\Divine.exe" `
  --action create-package `
  --source "Data" `
  --destination "Package\BG3Wow_FIXED_NAMING.pak" `
  --package-version v18 `
  --compression-method lz4

# Copy to game
Copy-Item "Package\BG3Wow_FIXED_NAMING.pak" `
  "$env:LOCALAPPDATA\Larian Studios\Baldur's Gate 3\Mods\"
```

### **Step 3: Launch Game & Test (1 minute)**

1. Open BG3 Mod Manager
2. Enable BG3Wow mod
3. Export load order
4. Launch game
5. **Create Warrior character**
6. **CHECK:** Does character creation succeed? ✅

**Expected Result:**  
✅ Character creation WORKS  
✅ Character has 3 abilities (Charge, Battle Shout, Execute)  
❌ Character missing ~15 abilities (HeroicStrike, etc.)

---

## 📋 COMPLETE FIX PLAN (After Test Succeeds)

Once we confirm the test fix works, systematically fix all references:

### **Phase 1: Fix Naming Mismatches (4 spells)**

| Old Name | New Name | Line in Progressions |
|----------|----------|---------------------|
| `WAR_Charge` | `Target_WAR_Charge` | ~Line 16, 43 |
| `WAR_Execute` | `Target_WAR_Execute` | ~Line 63 |
| `WAR_BattleShout` | `Shout_WAR_BattleShout` | ~Line 53 |
| `WAR_ARMS_Overpower` | `Target_WAR_ARMS_Overpower` | ~Line 236 |

**Estimated Time:** 2 minutes (4 find/replace operations)

### **Phase 2: Implement Missing Core Abilities (Priority Order)**

**Priority 1 - Level 1 (Required for character creation):**
1. `WAR_HeroicStrike` → Create in Spell_Target.txt

**Priority 2 - Subclass Signature Abilities:**
2. `WAR_ARMS_MortalStrike` → Spell_Target.txt  
3. `WAR_FURY_RagingBlow` → Spell_Target.txt  
4. `WAR_PROT_Shockwave` → Spell_Zone.txt

**Priority 3 - Base Class Core:**
5. `WAR_HeroicLeap` → Spell_Jump.txt  
6. `WAR_RallyingCry` → Spell_Shout.txt  
7. `WAR_IntimidatingShout` → Spell_Shout.txt

**Priority 4 - Remaining:**
8-16. All other missing abilities

**Estimated Time:** 
- 5 min per ability × 16 abilities = 80 minutes (1.3 hours)
- OR use Warlock mod as reference to speed up

### **Phase 3: Verify All References**

Re-run validation script:
```powershell
Get-Content ".\validate_spell_references.ps1" | powershell -
```

**Expected Result:** `✅ ALL SPELLS FOUND!`

---

## 🎲 CONFIDENCE LEVEL

**Naming Mismatch = Crash Cause:** 95% confidence

**Evidence:**
1. ✅ 20 spells missing (confirmed via script)
2. ✅ 4 spells exist with different names (confirmed via grep)
3. ✅ Warlock mod has all spells with prefixes (consistent pattern)
4. ✅ BG3 requires exact name matches (established BG3 modding pattern)
5. ✅ Crash timing matches (occurs at character creation = level 1 spell grant)

**Alternative Theories (Low Probability):**
- ❌ Lists folder issue: Unlikely (Warlock also has minimal lists)
- ❌ ProgressionTableUUID issue: Already validated in Phase 31
- ❌ ActionResource issue: Already fixed in Phase 31
- ❌ Meta.lsx issue: Validated, structure correct

---

## 📝 NEXT IMMEDIATE STEPS

**RIGHT NOW:**
1. Read Progressions.lsx lines 10-25 to get exact syntax
2. Make 3 precise replacements (Charge, BattleShout, Execute)
3. Package as `BG3Wow_NAMING_FIX_TEST.pak`
4. Test in-game

**IF TEST SUCCEEDS:**
5. Fix remaining naming mismatches (Overpower)
6. Implement missing abilities (HeroicStrike first)
7. Iterate until all 20 abilities work

**IF TEST FAILS:**
8. Re-examine crash logs
9. Check for secondary issues (localization, status effects)
10. Deep dive into Warlock mod's Progressions.lsx for comparison

---

**Status:** READY TO IMPLEMENT FIX ✅  
**Time to Test Fix:** ~10 minutes  
**Probability of Success:** 95%

