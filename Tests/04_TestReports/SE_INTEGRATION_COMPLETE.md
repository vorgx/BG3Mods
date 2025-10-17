# BG3Wow Mod - Script Extender Integration Complete ✅

## 🎉 What We Just Did

Added **Script Extender debugging support** to help diagnose mod loading issues!

## 📦 New Package Created

**File:** `BG3Wow_v1.0.0.2_SE.pak`
- **Size:** 49,926 bytes (49.9 KB)
- **Installed To:** `%LOCALAPPDATA%\Larian Studios\Baldur's Gate 3\Mods\BG3Wow.pak`
- **Includes:** 
  - All previous fixes (class localization)
  - NEW: Script Extender logging system

## ✨ New Features

### Script Extender Files Added:
```
Mods/BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7/ScriptExtender/
├── Config.json
└── Lua/
    ├── BootstrapShared.lua   (1,001 bytes)
    ├── BootstrapServer.lua   (1,195 bytes)
    └── BootstrapClient.lua   (393 bytes)
```

### What They Do:
- 🔍 **Log mod loading** - Confirms BG3Wow is recognized by the game
- 📊 **Track game events** - GameStarted, LevelLoaded, CharacterCreated
- 🐛 **Diagnose crashes** - Shows where mod fails to load
- ✅ **Verify initialization** - Confirms all systems are working

## 📝 New Tools Created

### 1. VIEW_SE_LOGS.ps1
**Purpose:** View Script Extender logs with BG3Wow filtering
```powershell
.\VIEW_SE_LOGS.ps1
```
**Features:**
- Shows full SE log content
- Highlights BG3Wow-specific messages
- Color-codes errors/warnings
- Lists recent log files

### 2. SE_DEBUGGING_GUIDE.md
**Purpose:** Complete guide to SE debugging
**Contents:**
- How SE logging works
- Expected log output
- Troubleshooting steps
- Log file locations

## 🎯 Testing Instructions

### Step 1: Verify Installation
```powershell
# Check BG3Wow.pak is installed
Get-Item "$env:LOCALAPPDATA\Larian Studios\Baldur's Gate 3\Mods\BG3Wow.pak"
# Should show: 49,926 bytes, dated October 17, 2025 1:40 AM
```

### Step 2: Disable Conflicting Mods
⚠️ **CRITICAL:** You still have conflicting WoWWarrior mod!
```powershell
# Check for conflicts
Get-ChildItem "$env:LOCALAPPDATA\Larian Studios\Baldur's Gate 3\Mods" | Where-Object {$_.Name -like "*Warrior*" -or $_.Name -like "*WoW*"}

# You MUST disable: WoWWarrior_951cbea7-d9d3-f32e-bcc6-00e17952595a.pak
```

**Options:**
- Use BG3 Mod Manager to uncheck it
- Or temporarily move it out of Mods folder

### Step 3: Launch Game
1. Open BG3 via Script Extender (normal launcher is fine if SE is installed)
2. Game should launch without crashing now
3. Close game after reaching main menu

### Step 4: Check Logs
```powershell
# View SE logs with our tool
.\VIEW_SE_LOGS.ps1

# Look for [BG3WOW] messages like:
# [BG3WOW] ===== SHARED BOOTSTRAP LOADED =====
# [BG3WOW] Mod UUID: 78fe4967-4e62-5491-d981-dd781acca4d7
# [BG3WOW] BG3Wow Warrior Class Mod
# etc.
```

### Step 5: Test In-Game
If logs show successful loading:
1. Start **NEW GAME**
2. In character creation, look for **"Warrior"** class
3. Select Warrior → Choose subclass (Arms/Fury/Protection)
4. Check character sheet for Rage resource
5. Verify abilities appear in hotbar

## 📊 Expected Behavior

### ✅ Success Indicators:
- Game launches without crash
- SE logs show [BG3WOW] messages
- "Warrior" class appears in character creation
- Class has proper name/description (not placeholder text)
- Rage resource bar visible
- Abilities have proper tooltips

### ❌ Failure Indicators:
- Game crashes on launch → Still have conflicting mods
- No [BG3WOW] logs → Mod didn't load (check modsettings.lsx)
- Warrior class missing → Class not registering
- Placeholder text → Localization not loading

## 🔧 Troubleshooting Quick Reference

| Issue | Solution |
|-------|----------|
| Game crashes | Disable WoWWarrior mod |
| No SE logs | Verify SE installed correctly |
| No [BG3WOW] logs | Check BG3Wow.pak size = 49,926 bytes |
| Warrior missing | Check modsettings.lsx has BG3Wow enabled |
| No abilities | Check Progressions.lsx loaded |
| Crash in char creation | Check ClassDescriptions.lsx + localization |

## 📋 Files Modified/Created Today

### Modified:
- ✅ English.loca.xml - Added 12 class description entries
- ✅ BG3Wow.pak - Now includes SE logging

### Created:
- ✅ ScriptExtender/Config.json
- ✅ ScriptExtender/Lua/BootstrapShared.lua
- ✅ ScriptExtender/Lua/BootstrapServer.lua
- ✅ ScriptExtender/Lua/BootstrapClient.lua
- ✅ VIEW_SE_LOGS.ps1
- ✅ SE_DEBUGGING_GUIDE.md
- ✅ This summary file

## 📦 Package History

| Version | Size | Changes |
|---------|------|---------|
| v1.0.0.0 | 47,164 | Initial build |
| v1.0.0.1_FIXED | 47,997 | Added class localization |
| v1.0.0.2_SE | 49,926 | Added SE logging (current) |

## 🎯 What's Next

1. **Disable WoWWarrior mod** (MUST DO!)
2. **Launch game** and check for crashes
3. **Run VIEW_SE_LOGS.ps1** to verify mod loaded
4. **Test in-game** - create Warrior character
5. **Report back** what you see!

## 💡 Pro Tips

- SE logs are created **every launch** - fresh data each time
- [BG3WOW] prefix makes our logs easy to spot
- If game crashes, SE logs show how far it got
- 157-byte logs = crash before mod init
- Multi-KB logs = mod loaded, check for [BG3WOW]

## 🚀 Debug Commands

```powershell
# Quick check installed package
Get-Item "$env:LOCALAPPDATA\Larian Studios\Baldur's Gate 3\Mods\BG3Wow.pak"

# View latest SE log
.\VIEW_SE_LOGS.ps1

# Check for conflicts
Get-ChildItem "$env:LOCALAPPDATA\Larian Studios\Baldur's Gate 3\Mods" | 
  Where-Object {$_.Name -like "*Warrior*"}

# View modsettings.lsx
Get-Content "$env:LOCALAPPDATA\Larian Studios\Baldur's Gate 3\PlayerProfiles\Public\modsettings.lsx" | 
  Select-String "BG3Wow|WoWWarrior"
```

---

**Status:** ✅ Ready for testing
**Next Step:** Disable conflicting WoWWarrior mod and launch game!
**Created:** October 17, 2025 1:41 AM
