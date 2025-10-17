# 🎮 BG3 Mod Development - Quick Reference Card

```
┌──────────────────────────────────────────────────────────────────┐
│                    KEYBOARD SHORTCUTS                            │
├──────────────────────────────────────────────────────────────────┤
│  Ctrl+Shift+B   Build PAK (default - fastest!)                  │
│  F5             Open debug menu (4 configurations)               │
│  Ctrl+Shift+P   Command palette (run any task)                   │
│  Ctrl+`         Open/close terminal                              │
└──────────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────────┐
│                    COMMON WORKFLOWS                              │
├──────────────────────────────────────────────────────────────────┤
│  BUILD MOD                                                       │
│    1. Make changes to files                                      │
│    2. Press Ctrl+Shift+B                                         │
│    3. Check Package\BG3Wow_Latest.pak created                    │
│                                                                  │
│  VALIDATE BEFORE BUILD                                           │
│    1. Press F5                                                   │
│    2. Select "Validate Mod Structure"                            │
│    3. Fix any errors                                             │
│    4. Press Ctrl+Shift+B to build                                │
│                                                                  │
│  INSTALL TO BG3                                                  │
│    1. Press Ctrl+Shift+P                                         │
│    2. Type "Tasks: Run Task"                                     │
│    3. Select "Install Mod to BG3"                                │
│    4. Open BG3 Mod Manager                                       │
│    5. Enable mod + Export load order                             │
│    6. Launch game                                                │
│                                                                  │
│  UNPACK A PAK FILE                                               │
│    1. Edit .vscode\unpack-pak.ps1 (set $pakToUnpack)             │
│    2. Press F5                                                   │
│    3. Select "Unpack PAK (Multitool)"                            │
│    4. Files extracted to Tests\UnpackedMod\                      │
└──────────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────────┐
│                    FILE LOCATIONS                                │
├──────────────────────────────────────────────────────────────────┤
│  Source Files:      Data\                                        │
│  Output PAK:        Package\BG3Wow_Latest.pak                    │
│  Build Scripts:     .vscode\build-pak.ps1                        │
│  Validation Script: validate_mod_structure.ps1                   │
│  BG3 Install:       %LOCALAPPDATA%\Larian Studios\              │
│                     Baldur's Gate 3\Mods\                        │
└──────────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────────┐
│                    F5 DEBUG MENU OPTIONS                         │
├──────────────────────────────────────────────────────────────────┤
│  Build PAK (Multitool)        Fast packaging (~10 sec)           │
│  Unpack PAK (Multitool)       Extract PAK files                  │
│  Build PAK (LSLib - Fallback) Slower but reliable                │
│  Validate Mod Structure       Check for errors                   │
└──────────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────────┐
│                    AVAILABLE TASKS                               │
├──────────────────────────────────────────────────────────────────┤
│  Access via: Ctrl+Shift+P → "Tasks: Run Task"                   │
│                                                                  │
│  - Build PAK (Multitool)         [DEFAULT: Ctrl+Shift+B]        │
│  - Unpack PAK (Multitool)                                        │
│  - Build PAK (LSLib - Fallback)                                  │
│  - Validate Mod Structure                                        │
│  - Install Mod to BG3                                            │
└──────────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────────┐
│                    FIRST-TIME SETUP                              │
├──────────────────────────────────────────────────────────────────┤
│  1. Download BG3 Modders Multitool                               │
│     https://github.com/ShinyHobo/BG3-Modders-Multitool/releases │
│                                                                  │
│  2. Extract to (example): C:\Tools\BG3-Modders-Multitool\       │
│                                                                  │
│  3. Update script paths:                                         │
│     - .vscode\build-pak.ps1 (line 17)                            │
│     - .vscode\unpack-pak.ps1 (line 13)                           │
│                                                                  │
│  4. Install PowerShell extension in VS Code                      │
│     Ctrl+Shift+X → Search "PowerShell" → Install                 │
│                                                                  │
│  5. Test: Press Ctrl+Shift+B                                     │
│     Should create Package\BG3Wow_Latest.pak                      │
│                                                                  │
│  See: MULTITOOL_SETUP.md for detailed instructions              │
└──────────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────────┐
│                    TROUBLESHOOTING                               │
├──────────────────────────────────────────────────────────────────┤
│  "Multitool not found"                                           │
│    → Check path in .vscode\build-pak.ps1 line 17                 │
│    → Verify bg3-modders-multitool.exe exists                     │
│                                                                  │
│  F5 menu doesn't work                                            │
│    → Install PowerShell extension (Ctrl+Shift+X)                 │
│    → Restart VS Code                                             │
│                                                                  │
│  Build fails                                                     │
│    → Run "Validate Mod Structure" (F5 menu)                      │
│    → Fix errors shown in terminal                                │
│    → Try building again                                          │
│                                                                  │
│  Need fallback method                                            │
│    → F5 → "Build PAK (LSLib - Fallback)"                         │
│    → Or run: .\QUICK_PACKAGE.ps1                                 │
└──────────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────────┐
│                    DOCUMENTATION                                 │
├──────────────────────────────────────────────────────────────────┤
│  Quick Setup:         MULTITOOL_SETUP.md                         │
│  Full Integration:    VSCODE_INTEGRATION_COMPLETE.md             │
│  VS Code Details:     .vscode\README.md                          │
│  Packaging Guide:     PACKAGING_GUIDE.md                         │
│  Pre-Build Checklist: pre_package_checklist.md                   │
│  Project Overview:    .github\copilot-instructions.md            │
│                                                                  │
│  Multitool Wiki:                                                 │
│  https://github.com/ShinyHobo/BG3-Modders-Multitool/wiki        │
└──────────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────────┐
│                    TIME SAVINGS                                  │
├──────────────────────────────────────────────────────────────────┤
│  Build Time Comparison:                                          │
│    Old Method (Manual):     ~45 seconds                          │
│    New Method (Ctrl+Shift+B): ~12 seconds                        │
│    Savings:                  33 seconds per build                │
│                                                                  │
│  Weekly Savings (50 builds):                                     │
│    Old: 37.5 minutes                                             │
│    New: 10 minutes                                               │
│    Saved: 27.5 minutes/week                                      │
└──────────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────────┐
│                    RECOMMENDED WORKFLOW                          │
├──────────────────────────────────────────────────────────────────┤
│  Daily Development:                                              │
│    1. Make changes to mod files                                  │
│    2. Ctrl+Shift+B to build                                      │
│    3. Repeat                                                     │
│                                                                  │
│  Before Major Changes:                                           │
│    1. F5 → "Validate Mod Structure"                              │
│    2. Fix any issues                                             │
│    3. Continue development                                       │
│                                                                  │
│  Before Testing In-Game:                                         │
│    1. F5 → "Validate Mod Structure"                              │
│    2. Ctrl+Shift+B to build                                      │
│    3. Ctrl+Shift+P → "Install Mod to BG3"                        │
│    4. Launch BG3 Mod Manager                                     │
│    5. Enable mod + Export load order                             │
│    6. Test in game                                               │
│                                                                  │
│  Before Release:                                                 │
│    1. Run full validation                                        │
│    2. Build with version number                                  │
│    3. Test thoroughly                                            │
│    4. Update CHANGELOG.md                                        │
│    5. Commit to git                                              │
│    6. Create release PAK                                         │
└──────────────────────────────────────────────────────────────────┘

🎮 Happy Modding! Press Ctrl+Shift+B to get started!
