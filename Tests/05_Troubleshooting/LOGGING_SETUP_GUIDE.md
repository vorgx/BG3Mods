# Script Extender Logging Setup Guide

**Date**: October 18, 2025  
**Purpose**: Enable detailed logging to diagnose mod crashes  
**Status**: Ready to use

---

## Prerequisites

### 1. Install BG3 Script Extender

**Download**: https://github.com/Norbyte/bg3se/releases

**Installation**:
1. Download latest release (v8 or higher for Patch 8)
2. Extract to BG3 game root folder:
   ```
   C:\Program Files (x86)\Steam\steamapps\common\Baldurs Gate 3\
   ```
3. Files should be in game root (same folder as `bg3.exe` and `bg3_dx11.exe`)

**Verify Installation**:
- Look for `DWrite.dll` in game root folder
- Look for `ScriptExtender` folder in game root

### 2. Launch Game with Script Extender

**Option A: Direct Launch**:
```
bg3.exe
```
Game will automatically load Script Extender if installed correctly.

**Option B: Via BG3 Mod Manager**:
- BG3 Mod Manager automatically launches with SE if detected
- No special configuration needed

---

## Log File Locations

### Primary Logs (Most Important)

**1. Script Extender Console Log**:
```
%LOCALAPPDATA%\Larian Studios\Baldur's Gate 3\ScriptExtender\Logs\Console.log
```
**Contains**: 
- `[BG3WOW]` debug messages from our Lua scripts
- Script loading status
- Runtime errors
- Mod initialization messages

**2. Osiris Log (Game Events)**:
```
%LOCALAPPDATA%\Larian Studios\Baldur's Gate 3\ScriptExtender\Logs\Osiris.log
```
**Contains**:
- Game event triggers
- Character creation events
- Level loading events
- Osiris story script execution

### Secondary Logs

**3. Game Player Log**:
```
%LOCALAPPDATA%\Larian Studios\Baldur's Gate 3\PlayerProfiles\Public\player.log
```
**Contains**: General game errors and warnings

**4. Crash Dumps** (if game crashes):
```
%LOCALAPPDATA%\Larian Studios\Baldur's Gate 3\CrashReports\
```

---

## How to Access Logs

### Quick Access Script

Save this as `View_Logs.ps1` in your BG3Mods folder:

```powershell
# Quick log viewer for BG3Wow debugging
$logPath = "$env:LOCALAPPDATA\Larian Studios\Baldur's Gate 3\ScriptExtender\Logs\Console.log"

if (Test-Path $logPath) {
    Write-Host "Opening Console.log..." -ForegroundColor Green
    notepad $logPath
} else {
    Write-Host "Log not found! Make sure:" -ForegroundColor Red
    Write-Host "1. Script Extender is installed" -ForegroundColor Yellow
    Write-Host "2. Game has been launched at least once" -ForegroundColor Yellow
    Write-Host "3. Path: $logPath" -ForegroundColor Cyan
}
```

### Manual Navigation

1. Press `Win + R`
2. Type: `%LOCALAPPDATA%\Larian Studios\Baldur's Gate 3\ScriptExtender\Logs`
3. Open `Console.log` in Notepad or VS Code

---

## What to Look For in Logs

### Successful Mod Loading

Search for `[BG3WOW]` in `Console.log`. You should see:

```
========================================
[BG3WOW] SHARED BOOTSTRAP LOADING
[BG3WOW] Mod: BG3Wow - World of Warcraft Warrior Class
[BG3WOW] Version: 2.0.0 - Equipment Fix Test
[BG3WOW] UUID: 78fe4967-4e62-5491-d981-dd781acca4d7
========================================
[BG3WOW] ===== SHARED BOOTSTRAP COMPLETE =====

========================================
[BG3WOW] CLIENT BOOTSTRAP LOADING
[BG3WOW] Version: 2.0.0 - Equipment Fix Test
[BG3WOW] Script Extender: 8
========================================
[BG3WOW] ✅ Client Tick Running - Mod Active
[BG3WOW] ===== CLIENT BOOTSTRAP COMPLETE =====

========================================
[BG3WOW] SERVER BOOTSTRAP LOADING
[BG3WOW] Version: 2.0.0 - Equipment Fix Test
[BG3WOW] Script Extender: 8
========================================
[BG3WOW] ✅ Server Session Loaded Successfully
[BG3WOW] ===== SERVER BOOTSTRAP COMPLETE =====
```

### Error Indicators

**❌ Red flags to watch for**:
- `[Error]` in Console.log
- `Failed to load` messages
- Stack traces (multiple lines starting with whitespace)
- Missing file errors
- UUID conflicts

### Character Creation Events

When you create a Warrior character:
```
[BG3WOW] ✅ Character Created: S_Player_[GUID]
```

### Game State Changes

```
[BG3WOW] Game State: 0 → 1
[BG3WOW] ✅ Server Session Loaded Successfully
[BG3WOW] ✅ Reset Completed - Game Ready
```

---

## Debug Messages We Added

### Location: Data/Mods/BG3Wow_UUID/ScriptExtender/Lua/

**BootstrapShared.lua** (Runs on both client & server):
- Mod name, version, UUID
- Script Extender version check
- Game version check

**BootstrapClient.lua** (Client-side):
- Client session loaded confirmation
- Game state changes
- Client tick running confirmation

**BootstrapServer.lua** (Server-side):
- Server session loaded confirmation
- Game started event
- Level loaded events
- Character creation events

---

## Common Issues & Solutions

### Issue 1: No ScriptExtender Folder

**Problem**: Log folder doesn't exist  
**Solution**: 
1. Verify Script Extender is installed (check for `DWrite.dll` in game root)
2. Launch game at least once to create log folder
3. Check game root for `ScriptExtender` folder

### Issue 2: No [BG3WOW] Messages in Logs

**Problem**: Mod not loading  
**Solution**:
1. Check mod is enabled in BG3 Mod Manager
2. Verify `meta.lsx` has correct UUID
3. Check `ScriptExtender/Config.json` exists in mod folder
4. Verify folder structure matches documentation

### Issue 3: Lua Errors in Console.log

**Problem**: Script syntax errors  
**Solution**:
1. Check line number in error message
2. Open corresponding .lua file
3. Fix syntax (missing `end`, wrong function name, etc.)

### Issue 4: Game Crashes Before Logs Created

**Problem**: Crash happens too early  
**Solution**:
1. Check Windows Event Viewer:
   - `eventvwr.msc`
   - Windows Logs → Application
   - Look for BG3 crash entries
2. Check for crash dumps in:
   ```
   %LOCALAPPDATA%\Larian Studios\Baldur's Gate 3\CrashReports\
   ```

---

## Testing Workflow

### Step 1: Clear Old Logs
```powershell
Remove-Item "$env:LOCALAPPDATA\Larian Studios\Baldur's Gate 3\ScriptExtender\Logs\*.log"
```

### Step 2: Launch Game
- Launch via BG3 Mod Manager
- Watch for crash or main menu

### Step 3: Check Logs Immediately
```powershell
Get-Content "$env:LOCALAPPDATA\Larian Studios\Baldur's Gate 3\ScriptExtender\Logs\Console.log" | Select-String "\[BG3WOW\]"
```

### Step 4: Analyze Results

**If you see `[BG3WOW]` messages**:
- ✅ Mod is loading
- ✅ Script Extender is working
- Check for error messages after `[BG3WOW]` lines

**If you see NO `[BG3WOW]` messages**:
- ❌ Mod not loading at all
- Check mod is enabled in Mod Manager
- Check `Config.json` exists
- Verify folder structure

**If game crashes before main menu**:
- ❌ Crash is in game data loading (not scripts)
- Problem likely in:
  - ClassDescriptions.lsx (equipment references, UUIDs)
  - Progressions.lsx (progression table references)
  - Localization (missing handles)

---

## PowerShell Helper Commands

### View Last 50 Lines of Console Log
```powershell
Get-Content "$env:LOCALAPPDATA\Larian Studios\Baldur's Gate 3\ScriptExtender\Logs\Console.log" -Tail 50
```

### Search for BG3WOW Messages
```powershell
Select-String -Path "$env:LOCALAPPDATA\Larian Studios\Baldur's Gate 3\ScriptExtender\Logs\Console.log" -Pattern "\[BG3WOW\]"
```

### Search for Errors
```powershell
Select-String -Path "$env:LOCALAPPDATA\Larian Studios\Baldur's Gate 3\ScriptExtender\Logs\Console.log" -Pattern "Error|Failed|Exception"
```

### Watch Log in Real-Time (while game running)
```powershell
Get-Content "$env:LOCALAPPDATA\Larian Studios\Baldur's Gate 3\ScriptExtender\Logs\Console.log" -Wait -Tail 20
```

### Copy All Logs to Desktop
```powershell
$desktop = [Environment]::GetFolderPath("Desktop")
$logsFolder = "$env:LOCALAPPDATA\Larian Studios\Baldur's Gate 3\ScriptExtender\Logs"
Copy-Item "$logsFolder\*" "$desktop\BG3_Logs_$(Get-Date -Format 'yyyyMMdd_HHmmss')\" -Recurse
Write-Host "Logs copied to desktop"
```

---

## Next Steps After Enabling Logging

1. **Package mod** with updated debug scripts
2. **Clear old logs** before testing
3. **Launch game** via BG3 Mod Manager
4. **Check Console.log** for `[BG3WOW]` messages
5. **Report findings**:
   - If `[BG3WOW]` appears: Mod is loading, scripts work
   - If no `[BG3WOW]`: Mod not loading, check structure
   - If errors after `[BG3WOW]`: Script issues, check error message
   - If crash before `[BG3WOW]`: Game data issue (ClassDescriptions, Progressions)

---

## Expected Output (Success Case)

```
[INFO] Loading Script Extender...
[INFO] Game Version: 4.8.0.10
[INFO] Script Extender Version: 8

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

[BG3WOW] ✅ GameStarted Event - Server Initialized
[BG3WOW] Level Loaded: WLD_Main_A
[BG3WOW] Editor Mode: false
```

This output means:
- ✅ Script Extender is working
- ✅ Mod is loading successfully
- ✅ Both client and server scripts are running
- ✅ Game reached main menu without crash

---

**Files Updated This Session**:
- `ScriptExtender/Lua/BootstrapClient.lua` - Enhanced debug output
- `ScriptExtender/Lua/BootstrapServer.lua` - Enhanced debug output
- `ScriptExtender/Config.json` - Already configured

**Next**: Package mod and test with logging enabled.
