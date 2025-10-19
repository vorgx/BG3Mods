# Quick Testing Guide - Overpower & Rend

**Date:** October 17, 2025  
**Build:** Phase 1 Test (Overpower + Rend)  
**Status:** ✅ Pre-validation passed - Ready to package

---

## ✅ Pre-Validation Results

All checks passed:
- ✅ Spell entries exist (Target_WAR_Overpower, Target_WAR_Rend)
- ✅ Status entries exist (WAR_OVERPOWER_PROC, WAR_REND_BLEED)
- ✅ Passive wrappers exist (WAR_ARMS_ROW1_OVERPOWER, WAR_ARMS_ROW1_REND)
- ✅ All 8 localization handles exist (h8a7f2b01-08)
- ✅ No syntax errors detected

---

## Packaging Options

### Option A: BG3 Modders Multitool (Recommended - Easiest)

**Download:** https://github.com/ShinyHobo/BG3-Modders-Multitool/releases/latest

**Steps:**
1. Download and extract BG3 Modders Multitool
2. Open the Multitool
3. Go to **Utilities** tab
4. Click **"Pack Mod"** or **"Generate Pak"**
5. Select your mod's `Data` folder: `C:\Users\tenod\source\repos\BG3Mods\Data`
6. Choose output location: `C:\Users\tenod\source\repos\BG3Mods\Package\BG3Wow_v2.0.0_ARMS_PHASE1_TEST.pak`
7. Click **Pack** → Wait for completion
8. ✅ Done!

**Advantages:**
- No command line needed
- Automatic validation
- Progress bar
- Error messages if issues found

---

### Option B: LSLib Command Line (Already Have)

**You already have LSLib in the LsLib/ folder!**

**Quick Package Command:**
```powershell
# From BG3Mods root directory
.\LsLib\Tools\Divine.exe --action create-package --source "Data" --destination "Package\BG3Wow_v2.0.0_ARMS_PHASE1_TEST.pak" --package-version 18 --compression-method lz4
```

**Or use ConverterApp (GUI):**
```powershell
# Launch GUI version
.\LsLib\ConverterApp.exe
```
Then:
1. Select "Create Package" tab
2. Source: Browse to `Data` folder
3. Destination: `Package\BG3Wow_v2.0.0_ARMS_PHASE1_TEST.pak`
4. Package version: `v18`
5. Compression: `LZ4`
6. Click **Create Package**

---

### Option C: Manual Script (Automated)

Create a quick packaging script:

**File:** `Scripts\Package_Test.ps1`
```powershell
# Quick Packaging Script
$ErrorActionPreference = "Stop"

Write-Host "🎯 BG3Wow Phase 1 Test Packaging" -ForegroundColor Cyan

# Paths
$root = "C:\Users\tenod\source\repos\BG3Mods"
$divine = "$root\LsLib\Tools\Divine.exe"
$source = "$root\Data"
$output = "$root\Package\BG3Wow_v2.0.0_ARMS_PHASE1_TEST.pak"

# Check Divine exists
if (-not (Test-Path $divine)) {
    Write-Host "❌ LSLib Divine.exe not found!" -ForegroundColor Red
    Write-Host "Please download LSLib from: https://github.com/Norbyte/lslib/releases" -ForegroundColor Yellow
    exit 1
}

# Package
Write-Host "📦 Packaging mod..." -ForegroundColor Yellow
& $divine --action create-package --source $source --destination $output --package-version 18 --compression-method lz4

# Verify
if (Test-Path $output) {
    $size = (Get-Item $output).Length / 1KB
    Write-Host "✅ Package created successfully!" -ForegroundColor Green
    Write-Host "📄 File: $output" -ForegroundColor Cyan
    Write-Host "📊 Size: $([math]::Round($size, 2)) KB" -ForegroundColor Cyan
} else {
    Write-Host "❌ Packaging failed!" -ForegroundColor Red
    exit 1
}

# Copy to game (optional)
$modsFolder = "$env:LOCALAPPDATA\Larian Studios\Baldur's Gate 3\Mods"
$confirm = Read-Host "Copy to game Mods folder? (Y/N)"
if ($confirm -eq 'Y') {
    Copy-Item $output -Destination $modsFolder -Force
    Write-Host "✅ Copied to game!" -ForegroundColor Green
    Write-Host "🎮 Open BG3 Mod Manager to enable the mod" -ForegroundColor Yellow
}
```

**Run it:**
```powershell
.\Scripts\Package_Test.ps1
```

---

## Quick Install & Test

### 1. Install to Game

**Automatic (PowerShell):**
```powershell
$modsPath = "$env:LOCALAPPDATA\Larian Studios\Baldur's Gate 3\Mods"
Copy-Item "Package\BG3Wow_v2.0.0_ARMS_PHASE1_TEST.pak" -Destination $modsPath -Force
Write-Host "✅ Mod copied to game!" -ForegroundColor Green
```

**Manual:**
1. Open: `%LOCALAPPDATA%\Larian Studios\Baldur's Gate 3\Mods\`
2. Copy: `BG3Wow_v2.0.0_ARMS_PHASE1_TEST.pak` to this folder

### 2. Enable in BG3 Mod Manager

1. **Open BG3 Mod Manager**
2. **Refresh** (F5)
3. **Find:** BG3Wow_v2.0.0_ARMS_PHASE1_TEST
4. **Enable** (checkbox or drag to active panel)
5. **Export load order**
6. **Launch game** (from Mod Manager)

### 3. Quick Test Checklist

**Create Character:**
- Class: Warrior
- Level up to 3 → Select Arms subclass
- Talent choice: Overpower OR Rend

**Test Overpower:**
- [ ] Attack enemy, wait for dodge
- [ ] "Overpower Ready" status appears
- [ ] Cast Overpower → 2d10+STR damage
- [ ] Costs 10 Rage

**Test Rend:**
- [ ] Cast Rend on enemy
- [ ] Immediate: 1d10+STR damage
- [ ] Status: "Rending Wounds" (1d6/turn, 8 turns)
- [ ] Costs 20 Rage

---

## Expected Results

### Success Indicators ✅
- No crash on launch
- Warrior class available
- Arms subclass selectable at L3
- Talent selection shows 3 options (Mortal Strike | Overpower | Rend)
- All text displays correctly (no "h8a7f2b##")
- Abilities cast successfully
- Damage values correct
- Status effects work

### Known Limitations ⚠️
- **Overpower proc**: Requires enemy to actually dodge (not just miss)
- **Rend stacking**: Each cast adds separate stack (intended)
- **Rage costs**: Need sufficient Rage to cast

---

## If Testing Fails

### Game crashes on launch:
1. Check SE logs: `%LOCALAPPDATA%\Larian Studios\Baldur's Gate 3\ScriptExtender\Logs\`
2. Look for XML parsing errors
3. Disable conflicting mods

### Abilities don't appear:
1. Verify you selected Arms subclass (not base Warrior)
2. Check talent selection at L3 (not auto-granted)
3. Verify passive wrappers in Passive.txt

### Raw handles display (h8a7f2b##):
1. Localization file not loaded
2. Check English.loca.xml exists in pak
3. Verify contentuid matches exactly

---

## Next Steps

### If Tests Pass ✅
→ **Continue Phase 1 implementation**
- Colossus Smash (armor debuff)
- Cleave (AoE cone attack)
- Sweeping Strikes (multi-target buff)

Estimated time: 3-4 hours for next 3 abilities

### If Tests Fail ❌
→ **Debug and fix issues**
- Document errors with screenshots
- Check SE logs for specifics
- Fix syntax/reference errors
- Re-package and re-test

---

## My Recommendation

**Use Option A (BG3 Modders Multitool)** if you don't have it already - it's the easiest and has built-in validation.

**Use Option B (LSLib Divine.exe)** since you already have LSLib in your project - just use the command line version.

**Use Option C (Script)** if you want automated packaging for future builds.

---

**Ready to package?** Let me know which option you'd like to use and I can help with the specific steps!

**Status:** ✅ Code validated, ready for testing  
**Confidence:** 🟢 High - All syntax checks passed
