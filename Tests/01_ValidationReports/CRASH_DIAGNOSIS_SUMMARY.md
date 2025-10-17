# 🔍 CRASH DEBUGGING SUMMARY

**Date:** October 17, 2025 12:53 AM

## 🚨 Issues Found

### 1. **Wrong Filename** ✅ FIXED
- **Problem:** Mod was named `BG3Wow_v1.0.0.0.pak` instead of `BG3Wow.pak`
- **Impact:** Mod Manager couldn't find the file properly
- **Solution:** Renamed to `BG3Wow.pak`
- **Status:** ✅ FIXED

### 2. **Massive Mod List** ⚠️ HIGH RISK
- **Problem:** 300+ mods installed simultaneously
- **Impact:** High chance of conflicts, load order issues, crashes
- **Specific Conflicts Detected:**
  - `WoWWarrior_951cbea7-d9d3-f32e-bcc6-00e17952595a.pak` - **CONFLICT!**
  - `WoWDeathKnightClass.pak` - Potential conflict
  - `WoWDemonHunterClass.pak` - Potential conflict
  - `WoWWarlock.pak` - Potential conflict
  - `WoWPriest_f0d7e1dc-1a16-c068-9f62-684b81a1190c.pak` - Potential conflict
- **Solution:** Disable other WoW class mods for testing

### 3. **Mod Manager Status** ✅ WORKING
- **modsettings.lsx:** Mod is properly enabled
- **UUID:** 78fe4967-4e62-5491-d981-dd781acca4d7 ✅
- **Version:** 36028797018963968 (1.0.0.0) ✅
- **Folder:** BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7 ✅

---

## 📋 CRITICAL: Conflicting WoW Warrior Mod

**YOU HAVE ANOTHER WOW WARRIOR MOD INSTALLED!**

```
WoWWarrior_951cbea7-d9d3-f32e-bcc6-00e17952595a.pak
```

This is a **DIFFERENT** WoW Warrior mod with a different UUID. This will cause:
- Class definition conflicts
- Ability conflicts
- Crash on character creation
- Unpredictable behavior

**YOU MUST DISABLE OR REMOVE THIS MOD BEFORE TESTING BG3Wow!**

---

## 🛠️ Immediate Action Plan

### Step 1: Disable Conflicting Mods

**In BG3 Mod Manager, disable these mods:**

1. **WoWWarrior** (UUID: 951cbea7-d9d3-f32e-bcc6-00e17952595a) ⚠️ **CRITICAL**
2. WoWDeathKnightClass
3. WoWDemonHunterClass  
4. WoWWarlock
5. WoWPriest

Or better yet - **disable ALL mods except BG3Wow** for initial testing.

### Step 2: Verify Installation

Run this command to verify:

```powershell
.\VIEW_LOGS.ps1
```

Or manually check:
```
File: %LOCALAPPDATA%\Larian Studios\Baldur's Gate 3\Mods\BG3Wow.pak
Size: Should be ~46 KB
```

### Step 3: Test with Clean Load

1. **Launch BG3 Mod Manager**
2. **Disable all mods** (or just enable BG3Wow + Essential mods)
3. **Save Load Order**
4. **Launch Game**
5. **Create New Character**
6. **Select Warrior Class**

### Step 4: Re-enable Mods Gradually

If BG3Wow works alone:
1. Enable mods in small batches
2. Test after each batch
3. Identify which mod causes conflicts

---

## 📊 Mod Statistics

- **Total Mods Installed:** 300+
- **BG3Wow Status:** Enabled, Renamed to correct filename
- **Load Order Position:** In modsettings.lsx
- **Known Conflicts:** 1 critical (WoWWarrior), 4 potential

---

## 🔧 Testing Checklist

- [ ] Disable conflicting WoW mods
- [ ] Verify BG3Wow.pak exists (46 KB)
- [ ] Launch BG3 Mod Manager
- [ ] Confirm BG3Wow is enabled
- [ ] Save load order
- [ ] Launch game (check for crashes)
- [ ] Start new game (existing saves won't work)
- [ ] Character creation (check for Warrior class)
- [ ] Select Warrior
- [ ] Check starting abilities
- [ ] Test in-game

---

## 📝 Log Locations

### Game Logs
```
%LOCALAPPDATA%\Larian Studios\Baldur's Gate 3\PlayerProfiles\Public\
- Gustav.log (main game log)
```

### Script Extender Logs
```
%LOCALAPPDATA%\Larian Studios\Baldur's Gate 3\Script Extender Logs\
- Extender Runtime *.log
```

### Mod Settings
```
%LOCALAPPDATA%\Larian Studios\Baldur's Gate 3\PlayerProfiles\Public\modsettings.lsx
- Contains mod load order and enabled mods
```

### Crash Files (if created)
```
%LOCALAPPDATA%\Larian Studios\Baldur's Gate 3\Crashes\
- crash_*.txt
- crash_dump_*.dmp
```

---

## ⚠️ Common Crash Causes with Many Mods

1. **Class Definition Conflicts** - Multiple mods adding same class
2. **UUID Conflicts** - Two mods using same UUIDs
3. **Load Order Issues** - Dependencies not loading first
4. **Memory Overflow** - Too many mods loaded
5. **Incompatible Versions** - Mods for different game versions
6. **Missing Dependencies** - Mod requires another mod

---

## 🎯 Expected Behavior After Fix

**Game Launch:**
- Game should launch without crash
- No error messages about BG3Wow

**Character Creation:**
- Warrior class should appear in class list
- Selecting Warrior should not crash
- Level 1 abilities should appear

**In-Game:**
- Abilities should be usable
- Rage should generate correctly
- No errors in combat log

---

## 📞 If Still Crashing

1. **Check Gustav.log for errors:**
   ```powershell
   Get-Content "$env:LOCALAPPDATA\Larian Studios\Baldur's Gate 3\PlayerProfiles\Public\Gustav.log" -Tail 100 | Select-String "error|BG3Wow"
   ```

2. **Search for BG3Wow references:**
   ```powershell
   Select-String -Path "$env:LOCALAPPDATA\Larian Studios\Baldur's Gate 3\PlayerProfiles\Public\*.log" -Pattern "BG3Wow|78fe4967"
   ```

3. **Check Windows Event Viewer:**
   - Open Event Viewer
   - Windows Logs → Application
   - Look for bg3.exe or bg3_dx11.exe errors

4. **Verify game files:**
   - Steam: Right-click BG3 → Properties → Verify Integrity
   - GOG: Options → Manage Installation → Verify/Repair

---

## 📁 Quick Reference

**Mod File:**
```
C:\Users\tenod\AppData\Local\Larian Studios\Baldur's Gate 3\Mods\BG3Wow.pak
```

**Source Files:**
```
C:\Users\tenod\source\repos\BG3Mods\Data\
```

**Packaged Versions:**
```
C:\Users\tenod\source\repos\BG3Mods\Package\
- BG3Wow_v1.0.0.0.pak
- BG3Wow_Latest.pak
```

---

## ✅ Summary

**What Was Fixed:**
- ✅ Renamed mod to correct filename (BG3Wow.pak)
- ✅ Identified conflicting WoW Warrior mod
- ✅ Verified mod is in modsettings.lsx

**What You Need To Do:**
- ⚠️ **Disable the other WoWWarrior mod**
- ⚠️ Test with minimal mods first
- ⚠️ Gradually re-enable other mods

**Next Steps:**
1. Disable WoWWarrior (UUID: 951cbea7...)
2. Launch game
3. Test BG3Wow mod
4. Report results!

---

**Good luck! The main issue was the filename and the conflicting Warrior mod.** 🎮
