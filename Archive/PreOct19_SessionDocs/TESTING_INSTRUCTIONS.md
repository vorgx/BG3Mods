# Testing Instructions - BG3Wow_ALL_FILES_RESTRUCTURED

## Quick Test Steps

### 1. Enable Mod in BG3 Mod Manager
- Open **BG3 Mod Manager**
- Click **Refresh** to detect the new package
- Find **BG3Wow** in the list
- Check the box to enable it
- Click **Export Order to Game** (bottom right)

### 2. Launch Game
- Launch BG3 via **BG3 Mod Manager** (NOT Steam/GOG directly)
- Wait for game to fully load

### 3. Create New Character
⚠️ **IMPORTANT**: Must create NEW character, respec won't work for new classes
- Click **New Game**
- Start character creation
- **Look for "Warrior" in class list**

### 4. What to Check

#### ✅ Success Indicators:
- [ ] Warrior appears in class selection
- [ ] Class description displays correctly
- [ ] Can select Warrior class
- [ ] Can proceed through character creation
- [ ] Rage bar visible in character sheet
- [ ] Starting abilities (Charge, Heroic Strike) visible
- [ ] Can start game successfully

#### ❌ Failure Indicators:
- [ ] Game crashes on character creation screen
- [ ] Warrior class not visible in list
- [ ] Game freezes when selecting Warrior
- [ ] Missing abilities or Rage bar

### 5. Check Logs (If Issues)
```powershell
# View Script Extender logs
notepad "$env:LOCALAPPDATA\Larian Studios\Baldur's Gate 3\ScriptExtender\Logs\ScriptExtender.log"

# View game logs
notepad "$env:LOCALAPPDATA\Larian Studios\Baldur's Gate 3\PlayerProfiles\Public\GameplayErrors.log"
```

Search for:
- `[BG3WOW]` - Our mod's debug messages
- `ERROR` - Any errors
- `Warrior` - Class-specific issues
- `Rage` - Resource-specific issues

---

## If It Works ✅
Report back:
- "Class appears in character creation!"
- Take screenshot if possible
- Test a few abilities in tutorial

## If It Crashes ❌
Report back:
- When exactly it crashed (loading, character creation, etc.)
- Any error messages shown
- Check logs and share relevant error lines

---

**Package:** BG3Wow_ALL_FILES_RESTRUCTURED_20251018_170927.pak  
**Installed:** %LOCALAPPDATA%\Larian Studios\Baldur's Gate 3\Mods\  
**Fixes Applied:** 5 structural issues (ActionResourceDefinitions node ID + all Lists files)

Ready to test! 🎮
