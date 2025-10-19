# Debug Logging Enabled - Testing Instructions

**Date**: October 18, 2025  
**Package**: BG3Wow_v2.0.0_DEBUG.pak (56.38 KB)  
**Status**: ✅ Deployed with enhanced logging  
**Purpose**: Diagnose crash cause with detailed console output

---

## What Was Done

### 1. Enhanced Script Extender Logging

Updated 3 Lua files in `Data/Mods/BG3Wow_UUID/ScriptExtender/Lua/`:

**BootstrapShared.lua**:
- Logs mod name, version, UUID on startup
- Displays Script Extender version
- Displays game version

**BootstrapClient.lua**:
- Logs client session loaded event
- Tracks game state changes
- Confirms client tick is running

**BootstrapServer.lua**:
- Logs server session loaded event
- Tracks game started event
- Tracks level loading
- Tracks character creation
- Logs reset completion

### 2. Created Helper Tools

**View_Logs.ps1** (in project root):
- Interactive menu for viewing logs
- Search for `[BG3WOW]` messages
- Search for errors
- Open logs in Notepad
- Copy logs to desktop
- Clear logs for fresh start
- Real-time log watching

### 3. Packaged and Deployed

**Package**: BG3Wow_v2.0.0_DEBUG.pak  
**Size**: 56.38 KB (slightly larger due to Lua scripts)  
**Deployed**: `%LOCALAPPDATA%\Larian Studios\Baldur's Gate 3\Mods\BG3Wow.pak`

---

## Testing Instructions

### Step 1: Install Script Extender (If Not Already Installed)

**Download**: https://github.com/Norbyte/bg3se/releases

1. Download latest release (v8+ for Patch 8)
2. Extract to BG3 game root folder:
   ```
   C:\Program Files (x86)\Steam\steamapps\common\Baldurs Gate 3\
   ```
3. Verify `DWrite.dll` exists in game root
4. Verify `ScriptExtender` folder exists in game root

**Note**: BG3 Mod Manager will automatically detect and use Script Extender.

### Step 2: Clear Old Logs (Optional but Recommended)

Run from PowerShell in project folder:
```powershell
.\View_Logs.ps1
# Choose option 7 to clear logs
```

Or manually:
```powershell
Remove-Item "$env:LOCALAPPDATA\Larian Studios\Baldur's Gate 3\ScriptExtender\Logs\*.log"
```

### Step 3: Launch Game

1. Open **BG3 Mod Manager**
2. Refresh mod list (should show BG3Wow)
3. Enable BG3Wow
4. Export load order
5. Launch game via Mod Manager
6. **Watch for crash or main menu**

### Step 4: Check Logs IMMEDIATELY

**Option A: Use Helper Script**:
```powershell
.\View_Logs.ps1
# Choose option 2 to search for [BG3WOW] messages
```

**Option B: Manual Check**:
```powershell
Select-String -Path "$env:LOCALAPPDATA\Larian Studios\Baldur's Gate 3\ScriptExtender\Logs\Console.log" -Pattern "\[BG3WOW\]"
```

**Option C: Open in Notepad**:
```powershell
notepad "$env:LOCALAPPDATA\Larian Studios\Baldur's Gate 3\ScriptExtender\Logs\Console.log"
```
Then search for `[BG3WOW]` (Ctrl+F)

---

## What to Report

### Scenario 1: Game Crashes Before Main Menu

**Check**: Does Console.log exist?

**If YES, Console.log exists**:
1. Run `.\View_Logs.ps1` → Option 2 (search for [BG3WOW])
2. Report if you see **ANY** `[BG3WOW]` messages
3. Run `.\View_Logs.ps1` → Option 3 (search for errors)
4. Copy error messages and share

**Expected messages if mod loads**:
```
[BG3WOW] SHARED BOOTSTRAP LOADING
[BG3WOW] Mod: BG3Wow - World of Warcraft Warrior Class
[BG3WOW] Version: 2.0.0 - Equipment Fix Test
[BG3WOW] CLIENT BOOTSTRAP LOADING
[BG3WOW] SERVER BOOTSTRAP LOADING
```

**If NO Console.log**:
- Script Extender not installed or not loading
- Install SE and try again

### Scenario 2: Game Launches to Main Menu

**SUCCESS!** The equipment fix worked. Now check:
1. Can you see `[BG3WOW]` messages in Console.log?
2. Report what you see when you search for character creation

### Scenario 3: Script Extender Not Installed

If logs folder doesn't exist:
```
%LOCALAPPDATA%\Larian Studios\Baldur's Gate 3\ScriptExtender\Logs
```

Then Script Extender is not installed. Install it first (see Step 1 above).

---

## Diagnostic Decision Tree

```
Game crashes?
├─ YES → Check Console.log exists?
│  ├─ YES → Search for [BG3WOW]
│  │  ├─ FOUND → Mod loaded! Check for errors after [BG3WOW] messages
│  │  │           Problem: Script error or runtime issue
│  │  │           Action: Share error messages
│  │  │
│  │  └─ NOT FOUND → Mod didn't load
│  │                Problem: Config.json, folder structure, or mod not enabled
│  │                Action: Verify mod enabled in Mod Manager
│  │
│  └─ NO → Script Extender not installed
│           Action: Install SE and retry
│
└─ NO → Game launches!
         └─ Check Console.log for [BG3WOW]
            ├─ FOUND → ✅ Mod is working! Test character creation
            └─ NOT FOUND → Mod not loading (but game works)
                          Action: Check mod enabled in Mod Manager
```

---

## Expected Success Output

If everything works, Console.log should contain:

```
========================================
[BG3WOW] SHARED BOOTSTRAP LOADING
[BG3WOW] Mod: BG3Wow - World of Warcraft Warrior Class
[BG3WOW] Version: 2.0.0 - Equipment Fix Test
[BG3WOW] UUID: 78fe4967-4e62-5491-d981-dd781acca4d7
[BG3WOW] Script Extender Version: 8
[BG3WOW] Game Version: 4.8.0.10
========================================
[BG3WOW] ===== SHARED BOOTSTRAP COMPLETE =====

========================================
[BG3WOW] CLIENT BOOTSTRAP LOADING
[BG3WOW] Version: 2.0.0 - Equipment Fix Test
[BG3WOW] Script Extender: 8
========================================
[BG3WOW] ✅ Client Session Loaded Successfully
[BG3WOW] Game State: 0 → 1
[BG3WOW] ✅ Client Tick Running - Mod Active
[BG3WOW] ===== CLIENT BOOTSTRAP COMPLETE =====

========================================
[BG3WOW] SERVER BOOTSTRAP LOADING
[BG3WOW] Version: 2.0.0 - Equipment Fix Test
[BG3WOW] Script Extender: 8
========================================
[BG3WOW] Checking for Warrior class definitions...
[BG3WOW] ✅ Server Session Loaded Successfully
[BG3WOW] ✅ Reset Completed - Game Ready
[BG3WOW] ===== SERVER BOOTSTRAP COMPLETE =====
```

This means:
- ✅ Script Extender working
- ✅ Mod loading successfully
- ✅ Both client and server scripts running
- ✅ No errors during initialization

---

## Quick Reference Commands

### Search for BG3WOW messages:
```powershell
Select-String -Path "$env:LOCALAPPDATA\Larian Studios\Baldur's Gate 3\ScriptExtender\Logs\Console.log" -Pattern "\[BG3WOW\]"
```

### Search for errors:
```powershell
Select-String -Path "$env:LOCALAPPDATA\Larian Studios\Baldur's Gate 3\ScriptExtender\Logs\Console.log" -Pattern "Error|Failed|Exception"
```

### View last 50 lines:
```powershell
Get-Content "$env:LOCALAPPDATA\Larian Studios\Baldur's Gate 3\ScriptExtender\Logs\Console.log" -Tail 50
```

### Copy logs to desktop:
```powershell
$desktop = [Environment]::GetFolderPath("Desktop")
Copy-Item "$env:LOCALAPPDATA\Larian Studios\Baldur's Gate 3\ScriptExtender\Logs\*" "$desktop\BG3_Logs\" -Recurse
```

---

## Files Modified This Session

### Enhanced:
- `Data/Mods/BG3Wow_UUID/ScriptExtender/Lua/BootstrapClient.lua`
- `Data/Mods/BG3Wow_UUID/ScriptExtender/Lua/BootstrapServer.lua`
- `Data/Mods/BG3Wow_UUID/ScriptExtender/Lua/BootstrapShared.lua`

### Created:
- `View_Logs.ps1` - Interactive log viewer
- `Tests/05_Troubleshooting/LOGGING_SETUP_GUIDE.md` - Full logging documentation
- `Tests/05_Troubleshooting/DEBUG_TESTING_INSTRUCTIONS.md` - This file

### Unchanged (Still Fixed from Previous Session):
- `ClassDescriptions/ClassDescriptions.lsx` - Equipment IDs → EQP_CC_Barbarian
- All stat files (Spell_Target.txt, Status_BOOST.txt, Passive.txt)
- Localization (English.loca.xml)
- Progressions.lsx (in correct subdirectory)

---

## Next Steps

1. **Install Script Extender** (if not installed)
2. **Clear old logs** (optional)
3. **Launch game** via BG3 Mod Manager
4. **Run `.\View_Logs.ps1`** → Option 2
5. **Report findings**:
   - Do you see `[BG3WOW]` messages?
   - Do you see any errors?
   - Does game crash or reach main menu?

**Goal**: Determine if crash is:
- **Before** Lua scripts load (game data issue: ClassDescriptions, Progressions)
- **During** Lua scripts load (script syntax error)
- **After** Lua scripts load (runtime error in scripts)
- **No crash** (equipment fix worked!)

---

**Status**: Ready for testing with full diagnostic logging enabled.
