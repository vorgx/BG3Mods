# VS Code Integration for BG3 Warrior Mod

This folder contains VS Code automation scripts for building and managing the BG3 Warrior mod.

## Setup Instructions

### 1. Install BG3 Modders Multitool

1. Download from: https://github.com/ShinyHobo/BG3-Modders-Multitool/releases
2. Extract to a folder (e.g., `C:\Tools\BG3-Modders-Multitool\`)
3. Update the `$multiToolPath` variable in:
   - `build-pak.ps1` (line 17)
   - `unpack-pak.ps1` (line 13)

### 2. Install PowerShell Extension for VS Code

1. Open VS Code Extensions (Ctrl+Shift+X)
2. Search for "PowerShell"
3. Install the official Microsoft PowerShell extension

## Usage

### Build PAK File (F5)

**Method 1: Debug Menu (Recommended)**
1. Press `F5` (or click Run → Start Debugging)
2. Select "Build PAK (Multitool)" from the dropdown
3. PAK file will be created at `Package\BG3Wow_Latest.pak`

**Method 2: Tasks Menu**
1. Press `Ctrl+Shift+B` (default build task)
2. Or: Terminal → Run Task → "Build PAK (Multitool)"

**Method 3: Command Palette**
1. Press `Ctrl+Shift+P`
2. Type "Tasks: Run Task"
3. Select "Build PAK (Multitool)"

### Unpack PAK File

**Debug Menu:**
1. Press `F5`
2. Select "Unpack PAK (Multitool)"
3. Files extracted to `Tests\UnpackedMod\`

**Tasks Menu:**
1. Terminal → Run Task → "Unpack PAK (Multitool)"

### Validate Mod Structure

**Debug Menu:**
1. Press `F5`
2. Select "Validate Mod Structure"
3. Checks UUID consistency, XML syntax, localization, etc.

**Tasks Menu:**
1. Terminal → Run Task → "Validate Mod Structure"

### Install Mod to BG3

**Tasks Menu:**
1. Terminal → Run Task → "Install Mod to BG3"
2. Copies `BG3Wow_Latest.pak` to `%LOCALAPPDATA%\Larian Studios\Baldur's Gate 3\Mods\`

## Available Scripts

| Script | Purpose | Output |
|--------|---------|--------|
| `build-pak.ps1` | Build PAK using Multitool | `Package\BG3Wow_Latest.pak` |
| `unpack-pak.ps1` | Unpack PAK for inspection | `Tests\UnpackedMod\` |
| `QUICK_PACKAGE.ps1` (root) | Build PAK using LSLib (fallback) | `Package\BG3Wow_Latest.pak` |
| `validate_mod_structure.ps1` (root) | Validate mod files | Console output |

## Multitool vs LSLib

**BG3 Modders Multitool** (Recommended):
- ✅ Faster packaging/unpacking
- ✅ Better compression
- ✅ Handles Patch 8 format automatically
- ✅ GUI available for complex tasks
- ❌ Requires separate download

**LSLib** (Fallback):
- ✅ Already included in `LsLib\` folder
- ✅ Command-line Divine.exe and ConverterApp.exe
- ❌ Slower than Multitool
- ❌ More manual configuration

## Troubleshooting

### "Multitool not found" Error
1. Download from: https://github.com/ShinyHobo/BG3-Modders-Multitool/releases
2. Update `$multiToolPath` in `build-pak.ps1` and `unpack-pak.ps1`

### PowerShell Extension Not Installed
1. Install "PowerShell" extension from VS Code Marketplace
2. Restart VS Code

### Build Fails
1. Run "Validate Mod Structure" task first
2. Check for XML syntax errors
3. Verify UUID consistency
4. Check localization handles

### Fallback to LSLib
If Multitool isn't working, use:
- Debug: "Build PAK (LSLib - Fallback)"
- Task: "Build PAK (LSLib - Fallback)"

## Keyboard Shortcuts

| Action | Shortcut |
|--------|----------|
| Build PAK | `Ctrl+Shift+B` |
| Run Debug Config | `F5` |
| Run Task | `Ctrl+Shift+P` → "Tasks: Run Task" |
| Open Terminal | `` Ctrl+` `` |

## Configuration Files

- `launch.json` - Debug configurations (F5 menu)
- `tasks.json` - Build tasks (Ctrl+Shift+B menu)
- `build-pak.ps1` - Main packaging script
- `unpack-pak.ps1` - PAK extraction script

## Learn More

- **BG3 Modders Multitool Wiki**: https://github.com/ShinyHobo/BG3-Modders-Multitool/wiki
- **Command Line Interface**: https://github.com/ShinyHobo/BG3-Modders-Multitool/wiki/Command-Line-Interface
- **VS Code Tasks**: https://code.visualstudio.com/docs/editor/tasks
- **VS Code Debugging**: https://code.visualstudio.com/docs/editor/debugging
