# Folder Structure Issue Found

**Date:** October 17, 2025  
**Issue:** Progressions.lsx in wrong location

---

## 🔍 Problem Identified

Comparing our folder structure with the WoWWarlock example mod revealed a critical difference:

### ❌ OUR STRUCTURE (INCORRECT)
```
Data/
├── Mods/BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7/
│   ├── meta.lsx                    ✅ CORRECT
│   └── Localization/               ✅ CORRECT
└── Public/BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7/
    ├── Progressions.lsx            ❌ WRONG LOCATION!
    ├── ClassDescriptions/          ✅ CORRECT
    │   └── ClassDescriptions.lsx
    └── Stats/Generated/Data/       ✅ CORRECT
```

### ✅ WARLOCK EXAMPLE STRUCTURE (CORRECT)
```
Data/
├── Mods/Warlock_WoW_UUID/
│   ├── meta.lsx                    ✅ CORRECT
│   └── Localization/               ✅ CORRECT
└── Public/Warlock_WoW_UUID/
    ├── Progressions/               ✅ CORRECT - SUBDIRECTORY!
    │   ├── Progressions.lsx
    │   └── ProgressionDescriptions.lsx
    ├── ClassDescriptions/          ✅ CORRECT
    │   └── ClassDescriptions.lsx
    └── Stats/Generated/Data/       ✅ CORRECT
```

---

## 🎯 Required Fix

**Move:** `Data/Public/BG3Wow_UUID/Progressions.lsx`  
**To:** `Data/Public/BG3Wow_UUID/Progressions/Progressions.lsx`

This is likely causing the game crash on launch because it can't find the Progressions file in the expected location.

---

## 📋 Comparison Summary

| Component | Warlock Example | Our Mod | Status |
|-----------|----------------|---------|--------|
| **meta.lsx** | `Mods/Warlock/meta.lsx` | `Mods/BG3Wow/meta.lsx` | ✅ Match |
| **Localization** | `Mods/Warlock/Localization/English/` | `Mods/BG3Wow/Localization/English/` | ✅ Match |
| **ClassDescriptions** | `Public/Warlock/ClassDescriptions/ClassDescriptions.lsx` | `Public/BG3Wow/ClassDescriptions/ClassDescriptions.lsx` | ✅ Match |
| **Progressions** | `Public/Warlock/Progressions/Progressions.lsx` | `Public/BG3Wow/Progressions.lsx` | ❌ **MISMATCH** |
| **Stat Files** | `Public/Warlock/Stats/Generated/Data/*.txt` | `Public/BG3Wow/Stats/Generated/Data/*.txt` | ✅ Match |
| **ActionResources** | `Public/Warlock/ActionResourceDefinitions/` | `Public/BG3Wow/ActionResourceDefinitions/` | ✅ Match |

---

## 🛠️ Fix Command

```powershell
# Create Progressions subdirectory
New-Item -ItemType Directory -Path "Data\Public\BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7\Progressions" -Force

# Move Progressions.lsx into subdirectory
Move-Item "Data\Public\BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7\Progressions.lsx" `
          "Data\Public\BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7\Progressions\Progressions.lsx"

# Verify
Get-Item "Data\Public\BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7\Progressions\Progressions.lsx"
```

---

## 📦 After Fix

1. Re-package mod with correct structure
2. Re-install to game Mods folder
3. Test if crash is resolved

---

## 🔍 Additional Files in Warlock Example

The Warlock mod also has:
- `Progressions/ProgressionDescriptions.lsx` (optional, might not be required)
- Extra folders: `GUI/`, `Levelmaps/`, `Lists/`, `MultiEffectInfos/`, `RootTemplates/`
- More GUI assets in `Mods/` folder

However, these are likely optional enhancements. The **Progressions/** subdirectory is the critical missing piece.

---

**Status:** Ready to fix and re-test  
**Priority:** HIGH - This is likely the crash cause
