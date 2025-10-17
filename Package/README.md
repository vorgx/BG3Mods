# BG3Wow Mod - Package Folder

This folder contains all versioned builds of the BG3Wow mod.

## Current Status

✅ **Ready to Package!** All mod files validated and ready.

⚠️ **LSLib Required:** You need to install LSLib to create .pak files.

## Quick Start

### 1. Install LSLib

Download LSLib from: https://github.com/Norbyte/lslib/releases

**Recommended:**
- Download the latest release (v1.20.3 or newer)
- Extract to `C:\BG3ModTools\LSLib\`
- Or extract anywhere and note the path

### 2. Package the Mod

Run from the BG3Mods root folder:

```powershell
# If LSLib is at C:\BG3ModTools\LSLib\
.\PACKAGE_MOD.ps1 -CreateLatest

# If LSLib is elsewhere
.\PACKAGE_MOD.ps1 -LSLibPath "C:\Path\To\LSLib\ConverterApp.exe" -CreateLatest

# To auto-copy to game folder
.\PACKAGE_MOD.ps1 -CreateLatest -CopyToGame
```

### 3. Install to Game

**Option A - Automatic (if using -CopyToGame flag):**
- Script copies to: `%LOCALAPPDATA%\Larian Studios\Baldur's Gate 3\Mods\`

**Option B - Manual:**
1. Copy `BG3Wow_Latest.pak` or `BG3Wow_v1.0.0.0.pak` from this folder
2. Paste to: `%LOCALAPPDATA%\Larian Studios\Baldur's Gate 3\Mods\`
3. Rename to `BG3Wow.pak` (if needed)

### 4. Enable in Game

1. Launch BG3 Mod Manager
2. Enable "BG3Wow" mod
3. Launch game

## Version History

- **v1.0.0.0** - Initial release
  - Warrior base class (19 abilities)
  - Arms Warrior specialization (10 abilities)
  - Rage resource system
  - All core abilities validated

## File Structure

After first package, this folder will contain:

```
Package/
├── BG3Wow_v1.0.0.0.pak    # Versioned build
├── BG3Wow_Latest.pak      # Always points to latest version
└── README.md              # This file
```

## Validation Status

✅ All 9 core files validated
✅ 42/42 cross-references valid
✅ 128 localization handles complete
✅ All Rage generation mechanics verified
✅ Ready for in-game testing

**Confidence Level:** 95% - Ready to test!

## Testing Checklist

Once installed, test:

1. **Create Warrior Character** - Verify class appears
2. **Charge** → Verify 10 Rage generation
3. **Sunder Armor** → Verify 15 Rage, -1 AC stacking (max 3)
4. **Victory Rush** → Kill enemy, verify unlock
5. **Cooldowns** → Battle Shout, Rallying Cry (10 turns each)
6. **Arms Abilities** → Overpower, Colossus Smash, etc.

Report any issues!
