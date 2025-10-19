# BG3Wow Script Extender Debug Guide

## 📋 Overview

The BG3Wow mod now includes Script Extender support for advanced debugging and logging.

## 🔧 What Was Added

### Files Added:
```
Mods/BG3Wow_.../ScriptExtender/
  ├── Config.json              (SE configuration)
  └── Lua/
      ├── BootstrapShared.lua  (Runs on both client & server)
      ├── BootstrapServer.lua  (Server-side logging)
      └── BootstrapClient.lua  (Client-side logging)
```

### What It Does:
- ✅ Logs when the mod loads
- ✅ Logs Script Extender version
- ✅ Logs game events (GameStarted, LevelLoaded, CharacterCreated)
- ✅ Helps diagnose loading issues
- ✅ Confirms mod is being recognized by the game

## 📝 How to View SE Logs

### Method 1: Use VIEW_SE_LOGS.ps1
```powershell
.\VIEW_SE_LOGS.ps1
```

### Method 2: Manual Check
```powershell
# View latest SE log
Get-ChildItem "$env:LOCALAPPDATA\Larian Studios\Baldur's Gate 3\Script Extender Logs\" | 
  Sort-Object LastWriteTime -Descending | 
  Select-Object -First 1 | 
  Get-Content

# Search for BG3Wow mentions
Get-Content "$env:LOCALAPPDATA\Larian Studios\Baldur's Gate 3\Script Extender Logs\Extender Runtime*.log" -Tail 100 | 
  Select-String "BG3WOW"
```

## 🎯 Expected Log Output

When the mod loads successfully, you should see:

```
[BG3WOW] ===== SHARED BOOTSTRAP LOADED =====
[BG3WOW] Mod UUID: 78fe4967-4e62-5491-d981-dd781acca4d7
[BG3WOW] Mod Name: BG3Wow - WoW Warrior Class
[BG3WOW] ========================================
[BG3WOW] BG3Wow Warrior Class Mod
[BG3WOW] Version: 1.0.0.1
[BG3WOW] Features:
[BG3WOW]   - Warrior Base Class
[BG3WOW]   - Arms Subclass
[BG3WOW]   - Fury Subclass (WIP)
[BG3WOW]   - Protection Subclass (WIP)
[BG3WOW]   - Rage Resource System
[BG3WOW]   - 19+ Baseline Abilities
[BG3WOW]   - 10+ Arms Abilities
[BG3WOW] ========================================
[BG3WOW] ===== SERVER BOOTSTRAP LOADED =====
[BG3WOW] Script Extender Version: <version>
[BG3WOW] Mod is loading successfully!
[BG3WOW] ===== CLIENT BOOTSTRAP LOADED =====
[BG3WOW] Client-side mod is loading successfully!
```

## 🔍 Troubleshooting

### If No [BG3WOW] Logs Appear:

1. **Game crashes before mod loads**
   - Check for conflicting mods (WoWWarrior)
   - Verify BG3Wow.pak is in Mods folder
   - Check modsettings.lsx has BG3Wow enabled

2. **Script Extender not installed**
   - Download from: https://github.com/Norbyte/bg3se/releases
   - Extract DLLs to BG3 bin folder
   - Launch via DWrite.dll

3. **Mod not loading**
   - Check Package structure with Divine.exe
   - Verify SE files are in the .pak
   - Check meta.lsx for correct UUID

### If Logs Show Errors:

Look for patterns like:
- `error loading` → Script syntax error
- `failed to load` → Missing file/dependency
- `conflicting` → Another mod is interfering

## 📦 Package Versions

- **v1.0.0.0** - Initial release (no SE)
- **v1.0.0.1_FIXED** - Added class localization fix
- **v1.0.0.2_SE** - Added Script Extender logging (49,926 bytes)

## 🎮 Testing Steps

1. **Disable conflicting mods** (especially WoWWarrior)
2. **Install BG3Wow.pak** (v1.0.0.2_SE)
3. **Launch game** via Script Extender
4. **Run VIEW_SE_LOGS.ps1** immediately
5. **Look for [BG3WOW] messages**
6. If logs appear → Mod is loading! Check in-game
7. If no logs → Game crashed before mod init

## 📊 Log File Locations

```
Script Extender Logs:
%LOCALAPPDATA%\Larian Studios\Baldur's Gate 3\Script Extender Logs\

Main Game Logs:
%LOCALAPPDATA%\Larian Studios\Baldur's Gate 3\PlayerProfiles\Public\Gustav.log

Crash Logs:
%LOCALAPPDATA%\Larian Studios\Baldur's Gate 3\Crashes\
```

## 💡 Tips

- SE logs are created **every time** the game launches
- Logs are named with timestamps
- Use `VIEW_SE_LOGS.ps1` after each launch attempt
- [BG3WOW] prefix makes our logs easy to find
- _P() function prints to SE console (visible in logs)

## 🚀 Next Steps

After confirming logs appear:
1. Verify "Warrior" class appears in character creation
2. Test ability tooltips and localization
3. Create test character and verify Rage generation
4. Test Arms abilities (Charge, Mortal Strike, etc.)

---

**Created:** October 17, 2025
**Version:** 1.0.0.2_SE
