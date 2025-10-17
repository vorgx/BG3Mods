# .vscode Folder - VS Code Integration

This folder contains automated build scripts and tasks for the BG3 Warrior mod.

## Quick Start

### 1. One-Time Setup (5 minutes)
See: `MULTITOOL_SETUP.md` in the root folder

### 2. Build Your Mod
Press **`Ctrl+Shift+B`** in VS Code

### 3. Install to BG3
1. Press `Ctrl+Shift+P`
2. Type "Tasks: Run Task"
3. Select "Install Mod to BG3"

That's it! 🎉

## What's Inside?

| File | Purpose |
|------|---------|
| `build-pak.ps1` | Packages mod using BG3 Modders Multitool |
| `unpack-pak.ps1` | Extracts PAK files for inspection |
| `launch.json` | F5 debug configurations |
| `tasks.json` | Build tasks (Ctrl+Shift+B) |
| `README.md` | Full documentation |

## Available Tasks

| Task | Shortcut | What It Does |
|------|----------|--------------|
| Build PAK (Multitool) | `Ctrl+Shift+B` | Creates `Package\BG3Wow_Latest.pak` |
| Unpack PAK | F5 menu | Extracts PAK to `Tests\UnpackedMod\` |
| Validate Mod | F5 menu | Checks for errors |
| Install to BG3 | Task menu | Copies PAK to game folder |

## Documentation

- **Quick Setup**: `../MULTITOOL_SETUP.md`
- **Full Guide**: `README.md` (this folder)
- **Multitool Wiki**: https://github.com/ShinyHobo/BG3-Modders-Multitool/wiki

## Ignore in Git?

✅ **NO** - These files should be committed so other contributors can use the same workflow.

The multitool executable itself is NOT included (you download it separately).
