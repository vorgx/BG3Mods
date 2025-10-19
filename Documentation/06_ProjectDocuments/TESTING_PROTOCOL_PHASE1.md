# Phase 1 Testing Protocol - Overpower & Rend

**Date:** October 17, 2025  
**Build:** v2.0.0_ARMS_PHASE1_TEST  
**Abilities Under Test:** Overpower, Rend  
**Purpose:** Validate 8-step workflow and 5-pool system integration

---

## Pre-Packaging Validation Checklist

### 1. Syntax Validation

**Check for missing quotes in Spell_Target.txt:**
```powershell
Select-String -Path "Data\Public\BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7\Stats\Generated\Data\Spell_Target.txt" -Pattern 'data "[^"]+" [^"]' | Select-Object -First 10
```
✅ **Expected:** No results (all data lines have proper quotes)

**Check for duplicate entry names:**
```powershell
Select-String -Path "Data\Public\BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7\Stats\Generated\Data\Spell_Target.txt" -Pattern '^new entry' | Group-Object Line | Where-Object Count -gt 1
```
✅ **Expected:** No duplicates

**Verify new entries exist:**
```powershell
Select-String -Path "Data\Public\BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7\Stats\Generated\Data\Spell_Target.txt" -Pattern 'Target_WAR_Overpower|Target_WAR_Rend'
```
✅ **Expected:** 2 matches (one for each ability)

### 2. Status Validation

**Verify status entries exist:**
```powershell
Select-String -Path "Data\Public\BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7\Stats\Generated\Data\Status_BOOST.txt" -Pattern 'WAR_OVERPOWER_PROC|WAR_REND_BLEED'
```
✅ **Expected:** 2 matches

### 3. Passive Validation

**Verify passive wrappers exist:**
```powershell
Select-String -Path "Data\Public\BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7\Stats\Generated\Data\Passive.txt" -Pattern 'WAR_ARMS_ROW1_OVERPOWER|WAR_ARMS_ROW1_REND'
```
✅ **Expected:** 2 matches

### 4. Localization Validation

**Verify all handles exist:**
```powershell
Select-String -Path "Data\Mods\BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7\Localization\English\English.loca.xml" -Pattern 'h8a7f2b0[1-8]'
```
✅ **Expected:** 8 matches (h8a7f2b01 through h8a7f2b08)

**Check for duplicate contentuid:**
```powershell
Select-String -Path "Data\Mods\BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7\Localization\English\English.loca.xml" -Pattern 'contentuid="h8a7f2b' | Group-Object Line | Where-Object Count -gt 1
```
✅ **Expected:** No duplicates

### 5. XML Validation

**Validate English.loca.xml structure:**
```powershell
[xml]$xml = Get-Content "Data\Mods\BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7\Localization\English\English.loca.xml"
$xml.contentList.content | Where-Object { $_.contentuid -like 'h8a7f2b*' } | Select-Object contentuid, '#text' | Format-Table -AutoSize
```
✅ **Expected:** 8 entries displayed with proper text

---

## Packaging Instructions

### Step 1: Verify LSLib Exists

```powershell
Test-Path "LsLib\ConverterApp.exe"
```
✅ **Expected:** True

**If False:** Download LSLib v1.20.3+ from GitHub: https://github.com/Norbyte/lslib/releases

### Step 2: Package Mod

```powershell
& "LsLib\ConverterApp.exe" `
  --source "Data" `
  --destination "Package\BG3Wow_v2.0.0_ARMS_PHASE1_TEST.pak" `
  --action "create-package" `
  --package-version "v18" `
  --compression-method "lz4"
```

✅ **Expected Output:**
```
INFO: Divine 1.20.x
INFO: Creating package...
INFO: Package created successfully: Package\BG3Wow_v2.0.0_ARMS_PHASE1_TEST.pak
```

⚠️ **If Errors Occur:**
- Check for malformed XML in English.loca.xml
- Verify meta.lsx is valid XML
- Check for missing closing quotes in .txt files

### Step 3: Verify Package Created

```powershell
Get-Item "Package\BG3Wow_v2.0.0_ARMS_PHASE1_TEST.pak" | Select-Object Name, Length, LastWriteTime
```
✅ **Expected:** File exists, size ~500KB-1MB (depending on mod size)

---

## Installation Instructions

### Step 1: Copy to Game Mods Folder

```powershell
$modsPath = "$env:LOCALAPPDATA\Larian Studios\Baldur's Gate 3\Mods"
Copy-Item "Package\BG3Wow_v2.0.0_ARMS_PHASE1_TEST.pak" -Destination $modsPath -Force
```

✅ **Expected:** File copied to game Mods folder

**Verify:**
```powershell
Get-Item "$env:LOCALAPPDATA\Larian Studios\Baldur's Gate 3\Mods\BG3Wow_v2.0.0_ARMS_PHASE1_TEST.pak"
```

### Step 2: Enable in BG3 Mod Manager

1. **Launch BG3 Mod Manager** (external tool)
2. **Refresh mod list** (F5 or Refresh button)
3. **Find:** BG3Wow_v2.0.0_ARMS_PHASE1_TEST
4. **Enable** the mod (checkbox or drag to right panel)
5. **Export load order** (Export button - creates/updates modsettings.lsx)
6. **Close** Mod Manager

⚠️ **Important:** Do NOT launch game directly from Steam/GOG. Use Mod Manager's "Launch Game" button.

### Step 3: Launch Game

**Option A:** Launch from BG3 Mod Manager (recommended)  
**Option B:** Launch from Steam/GOG (only if modsettings.lsx exported correctly)

✅ **Expected:** Game launches without errors

⚠️ **If Game Crashes on Launch:**
- Check Script Extender logs: `%LOCALAPPDATA%\Larian Studios\Baldur's Gate 3\ScriptExtender\Logs\`
- Look for errors related to BG3Wow or Warrior
- Common causes: Malformed XML, invalid UUID references, conflicting mods

---

## In-Game Testing Protocol

### Test Environment Setup

1. **Start New Game** (don't use existing saves)
2. **Character Creation:**
   - Class: Warrior ✅
   - Subclass: Arms (at Level 3) ✅
   - Levels: Test at L1, L3 (talent selection), L5 (combat testing)
   - Companion: Shadowheart (for healing tests with Mortal Wounds)

### Test 1: Character Creation & Talent Selection

**Level 1 (Base Class):**
- [ ] Warrior class available in character creation
- [ ] Rage bar visible (11 pips, 100 max)
- [ ] Base abilities granted (Charge, Heroic Strike exist)
- [ ] Localization displays correctly (no "h125abc##" raw handles)

**Level 3 (Subclass + Arms Row 1):**
- [ ] Arms subclass choice appears
- [ ] After selecting Arms → Talent selection screen appears
- [ ] Arms Row 1 shows 3 options: **Mortal Strike | Overpower | Rend**
- [ ] All 3 ability names display correctly (not raw handles)
- [ ] Descriptions display correctly (damage values, Rage costs visible)
- [ ] Can select one talent ✅

### Test 2: Overpower - Proc Mechanic

**Setup:**
- Level: 3+
- Talent: Overpower selected
- Enemy: Any (Training Dummy or Goblin)
- Equipment: Melee weapon

**Test Steps:**

**A. Initial State:**
- [ ] Overpower appears in hotbar/action menu
- [ ] Overpower is **greyed out** (not castable)
- [ ] Tooltip shows: "Requires enemy dodge" or similar condition
- [ ] Rage: 10+ available

**B. Trigger Proc:**
- [ ] Attack enemy with normal attack (basic melee)
- [ ] **Wait for enemy to dodge** (may take multiple attempts)
- [ ] Watch for "Overpower Ready" status to appear on **your character**
- [ ] Overpower becomes **highlighted** (castable)

⚠️ **If proc doesn't trigger:** Attack multiple times, enemy needs to successfully dodge (not just miss due to low roll)

**C. Cast Overpower:**
- [ ] Click Overpower ability
- [ ] Target enemy (should be in range)
- [ ] Animation plays (melee attack)
- [ ] Damage dealt: **2d10 + Strength modifier** (check combat log)
- [ ] Example: STR 16 (+3) → Expected damage: 5-23 (2d10+3)
- [ ] Rage consumed: **10 Rage** (check Rage bar)
- [ ] "Overpower Ready" status **removed** from your character
- [ ] Overpower returns to **greyed out** state

**D. Duration Test:**
- [ ] Trigger proc again (enemy dodges)
- [ ] **Don't cast Overpower** for 6 turns
- [ ] "Overpower Ready" status expires after 6 turns
- [ ] Overpower returns to greyed out

✅ **Success Criteria:**
- Proc triggers only on dodge ✅
- Damage is 2d10+STR ✅
- Costs 10 Rage ✅
- Status removed after use ✅
- 6-turn duration ✅

### Test 3: Rend - DoT Bleed

**Setup:**
- Level: 3+
- Talent: Rend selected
- Enemy: Any (Training Dummy or Goblin with ~30+ HP)
- Equipment: Melee weapon

**Test Steps:**

**A. Initial Cast:**
- [ ] Rend appears in hotbar/action menu
- [ ] Rend is **castable** (not greyed out)
- [ ] Rage: 20+ available
- [ ] Click Rend, target enemy
- [ ] Animation plays (melee attack)
- [ ] **Immediate damage:** 1d10 + Strength modifier (check combat log)
- [ ] Example: STR 16 (+3) → Expected: 4-13 damage (1d10+3)
- [ ] Rage consumed: **20 Rage**

**B. Bleed Status Applied:**
- [ ] "Rending Wounds" status appears on **enemy** (status icon)
- [ ] Hover over status → Description shows "1d6 Slashing per turn"
- [ ] Status shows "8 turns remaining"

**C. DoT Ticks:**
- [ ] **End your turn**
- [ ] At **start of enemy turn** → Bleed ticks (1d6 Slashing damage)
- [ ] Check combat log: "Rending Wounds deals 1-6 Slashing damage"
- [ ] Status updates: "7 turns remaining"
- [ ] **Repeat for multiple turns** → Verify ticks each turn

**D. Duration Test:**
- [ ] Watch status for full 8 turns
- [ ] Bleed ticks at start of each enemy turn
- [ ] After 8 turns → Status expires automatically
- [ ] No more bleed damage

**E. Stacking Test:**
- [ ] Cast Rend on **same enemy** again
- [ ] Check status: Should show **2 stacks** of "Rending Wounds"
- [ ] Each turn → 2d6 damage (1d6 per stack)
- [ ] Cast Rend **3rd time** → 3 stacks → 3d6 per turn

✅ **Success Criteria:**
- Immediate damage: 1d10+STR ✅
- Costs 20 Rage ✅
- Status lasts 8 turns ✅
- Ticks at start of turn ✅
- DoT damage: 1d6 per stack ✅
- Stacking works ✅

### Test 4: Localization Verification

**Check all text displays correctly:**

**Overpower:**
- [ ] DisplayName: "Overpower" (not "h8a7f2b01")
- [ ] Description: Full text with damage values visible
- [ ] Status name: "Overpower Ready"
- [ ] Status description: Clear explanation of proc

**Rend:**
- [ ] DisplayName: "Rend"
- [ ] Description: Full text with DoT details
- [ ] Status name: "Rending Wounds"
- [ ] Status description: "Bleeding heavily. Taking 1d6 Slashing damage per turn."

⚠️ **If raw handles display (h8a7f2b##):**
- Localization handles not loaded correctly
- Check English.loca.xml for typos in contentuid
- Verify handles match exactly between files

### Test 5: Edge Cases & Bugs

**Overpower Edge Cases:**
- [ ] Test with no proc → Ability stays greyed out ✅
- [ ] Test with proc + insufficient Rage (< 10) → Should show error
- [ ] Test proc trigger from different enemies → Should work for any
- [ ] Test proc persistence across combat → Should expire after 6 turns

**Rend Edge Cases:**
- [ ] Test on dying enemy (< 10 HP) → DoT should kill over time
- [ ] Test multiple stacks (3-5 stacks) → Damage multiplies correctly
- [ ] Test refresh duration → Each Rend restarts 8-turn timer per stack
- [ ] Test on immune enemies (constructs?) → Should fail gracefully

**Resource Management:**
- [ ] Cast abilities with insufficient Rage → Error message displays
- [ ] Verify Rage generation from other abilities (Charge, etc.)
- [ ] Check Rage doesn't go negative

---

## Troubleshooting Guide

### Problem: Abilities Don't Appear

**Symptoms:** Overpower/Rend missing from hotbar after talent selection

**Diagnosis:**
1. Check Passive.txt - Verify `UnlockSpell()` boosts exist
2. Check Progressions.lsx - Verify SelectPassives includes passive names
3. Check case sensitivity - Spell names must match exactly

**Fix:** Verify passive wrapper names match SelectPassives entries

### Problem: Raw Handles Display (h8a7f2b##)

**Symptoms:** Ability names show as "h8a7f2b01" instead of "Overpower"

**Diagnosis:**
1. Check English.loca.xml - Verify contentuid exists
2. Check Spell/Status/Passive files - Verify DisplayName matches contentuid
3. Check XML syntax - Ensure proper closing tags

**Fix:** Add missing handles or fix contentuid typos

### Problem: Overpower Never Becomes Castable

**Symptoms:** "Overpower Ready" status never appears

**Diagnosis:**
1. Check Passive.txt - Verify `OnAttackTarget` context exists
2. Check condition: `AttackRollFailed() and not IsCriticalMiss()`
3. Verify enemy is actually dodging (not just low roll)

**Fix:** May need to adjust trigger condition or test with higher-AC enemies

### Problem: Rend Doesn't Tick

**Symptoms:** Bleed status applied but no damage per turn

**Diagnosis:**
1. Check Status_BOOST.txt - Verify `TickType: StartTurn`
2. Check TickFunctors - Verify `DealDamage(1d6,Slashing)`
3. Check combat log for tick messages

**Fix:** Verify TickType and TickFunctors syntax exactly matches vanilla examples

### Problem: Game Crashes on Launch

**Symptoms:** Game closes immediately or during loading screen

**Diagnosis:**
1. Check SE logs: `%LOCALAPPDATA%\Larian Studios\Baldur's Gate 3\ScriptExtender\Logs\`
2. Look for XML parsing errors
3. Check for duplicate entry names
4. Verify UUID consistency

**Fix:** Run pre-packaging validation again, fix any syntax errors

---

## Test Results Template

**Tester:** [Your Name]  
**Date:** [Test Date]  
**Build:** v2.0.0_ARMS_PHASE1_TEST  
**Game Version:** BG3 Patch 8 (4.8.0.10)

### Overpower Results

| Test | Pass/Fail | Notes |
|------|-----------|-------|
| Talent selection appears | ⬜ | |
| Initial state (greyed out) | ⬜ | |
| Proc triggers on dodge | ⬜ | |
| Damage: 2d10+STR | ⬜ | Actual: ___ |
| Rage cost: 10 | ⬜ | |
| Status removed after use | ⬜ | |
| 6-turn expiration | ⬜ | |
| Localization correct | ⬜ | |

**Overall:** ✅ Pass / ❌ Fail

**Issues Found:**
- [ ] None
- [ ] List issues here...

### Rend Results

| Test | Pass/Fail | Notes |
|------|-----------|-------|
| Talent selection appears | ⬜ | |
| Castable without proc | ⬜ | |
| Immediate damage: 1d10+STR | ⬜ | Actual: ___ |
| Rage cost: 20 | ⬜ | |
| Status applied | ⬜ | |
| DoT ticks: 1d6/turn | ⬜ | Actual: ___ |
| 8-turn duration | ⬜ | |
| Stacking works | ⬜ | Max stacks tested: ___ |
| Localization correct | ⬜ | |

**Overall:** ✅ Pass / ❌ Fail

**Issues Found:**
- [ ] None
- [ ] List issues here...

### Next Steps

**If All Tests Pass:**
✅ Continue Phase 1 implementation (Colossus Smash, Cleave, Sweeping Strikes)
✅ Use validated templates for faster implementation
✅ Batch test next 3-4 abilities together

**If Tests Fail:**
❌ Document all issues with screenshots/logs
❌ Fix identified problems
❌ Re-package and re-test
❌ Only proceed after validation

---

## Performance Checklist

- [ ] No frame rate drops during ability casting
- [ ] No memory leaks (game stable after 30+ min)
- [ ] Combat log doesn't spam excessively
- [ ] Status icons display correctly (no missing textures)
- [ ] Sounds play correctly (or no crashes if missing)

---

**Last Updated:** October 17, 2025  
**Status:** Ready for testing  
**Expected Test Duration:** 30-60 minutes
