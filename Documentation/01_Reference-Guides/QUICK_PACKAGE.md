# 🚀 QUICK PACKAGING REFERENCE

> **⚡ NEW: BG3 Modders Multitool Integration**  
> For faster builds and better compression, see: `MULTITOOL_SETUP.md`  
> Or just press **Ctrl+Shift+B** in VS Code after setup!  
> This guide covers the legacy LSLib method (still works as fallback).

---

## Method 1: PowerShell Script (Easiest)

```powershell
# Navigate to mod directory
cd c:\Users\tenod\source\repos\BG3Mods

# Run packaging script (update LSLib path if needed)
.\PACKAGE_MOD.ps1 -LSLibPath "C:\BG3ModTools\LSLib\ConverterApp.exe"

# Or with auto-copy to game:
.\PACKAGE_MOD.ps1 -LSLibPath "C:\BG3ModTools\LSLib\ConverterApp.exe" -CopyToGame
```

## Method 2: LSLib GUI

1. Open `Divine.exe`
2. Go to **Package** tab
3. Set:
   - Source: `c:\Users\tenod\source\repos\BG3Mods\Data`
   - Destination: `c:\Users\tenod\source\repos\BG3Mods\BG3Wow.pak`
   - Version: `v18`
   - Compression: `LZ4`
4. Click **Create Package**

## Method 3: Command Line

```powershell
& "C:\BG3ModTools\LSLib\ConverterApp.exe" `
  --source "c:\Users\tenod\source\repos\BG3Mods\Data" `
  --destination "c:\Users\tenod\source\repos\BG3Mods\BG3Wow.pak" `
  --action "create-package" `
  --package-version "v18" `
  --compression-method "lz4"
```

## Install to Game

**Manual Copy**:
```powershell
Copy-Item "c:\Users\tenod\source\repos\BG3Mods\BG3Wow.pak" `
  -Destination "$env:LOCALAPPDATA\Larian Studios\Baldur's Gate 3\Mods\"
```

**Then**:
1. Open BG3 Mod Manager
2. Refresh mod list
3. Enable BG3Wow
4. Export load order
5. Launch game

## Quick Validation

Before packaging:
```powershell
# Check all required files exist
Test-Path "c:\Users\tenod\source\repos\BG3Mods\Data\Mods\BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7\meta.lsx"
Test-Path "c:\Users\tenod\source\repos\BG3Mods\Data\Public\BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7\Localization\English\English.loca.xml"
```

## Common Issues

**LSLib not found**: Update `-LSLibPath` parameter
**Packaging fails**: Check file permissions, ensure Data folder structure is correct
**Mod not in game**: Check it's in `AppData\Local\Larian Studios\Baldur's Gate 3\Mods\`

## File Locations

- **LSLib Download**: https://github.com/Norbyte/lslib/releases
- **Mod Source**: `c:\Users\tenod\source\repos\BG3Mods\Data\`
- **Game Mods**: `%LOCALAPPDATA%\Larian Studios\Baldur's Gate 3\Mods\`
- **Output .pak**: `c:\Users\tenod\source\repos\BG3Mods\BG3Wow.pak`
