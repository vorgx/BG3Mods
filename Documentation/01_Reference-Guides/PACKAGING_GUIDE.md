# 📦 BG3 WARRIOR MOD - PACKAGING GUIDE

**Date**: October 17, 2025  
**Mod**: BG3Wow (Warrior Class)  
**Tool**: LSLib v1.20.3+ (Patch 8 compatible)

---

## QUICK START - PACKAGING STEPS

### Option 1: Using LSLib GUI (Recommended for first-time)

1. **Download LSLib** (if not already installed):
   - Get latest from: https://github.com/Norbyte/lslib/releases
   - Extract to a folder (e.g., `C:\BG3ModTools\LSLib`)

2. **Open Divine.exe** (LSLib GUI tool)

3. **Package Tab Settings**:
   - **Source Path**: `c:\Users\tenod\source\repos\BG3Mods\Data\Mods\BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7`
   - **Destination Path**: `c:\Users\tenod\source\repos\BG3Mods\BG3Wow.pak`
   - **Package Version**: `v18` (Patch 8)
   - **Compression Method**: `LZ4`
   - **Compression Level**: `Default`

4. **Click "Create Package"**

5. **Output**: `BG3Wow.pak` file created

### Option 2: Using PowerShell Script (Automated)

See `PACKAGE_MOD.ps1` script below for automated packaging.

---

## DIRECTORY STRUCTURE CHECK

Your mod needs this structure to package correctly:

```
BG3Mods/
└── Data/
    ├── Mods/
    │   └── BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7/
    │       └── meta.lsx                    ✅ (found)
    └── Public/
        └── BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7/
            ├── Localization/
            │   └── English/
            │       └── English.loca.xml    ✅ (created)
            ├── Stats/
            │   └── Generated/
            │       └── Data/
            │           ├── Spell_Target.txt    ✅
            │           ├── Spell_Zone.txt      ✅
            │           ├── Spell_Shout.txt     ✅
            │           ├── Spell_Jump.txt      ✅
            │           ├── Spell_Projectile.txt ✅
            │           ├── Status_BOOST.txt    ✅
            │           └── Passive.txt         ✅
            └── Progressions.lsx               ✅
```

**Status**: ✅ **All required files present**

---

## PACKAGING VALIDATION CHECKLIST

Before packaging, verify:

### File Checks
- [x] `meta.lsx` exists in Mods folder
- [x] All stat files exist in Stats/Generated/Data/
- [x] `English.loca.xml` exists in Localization/English/
- [x] `Progressions.lsx` exists in Public folder

### Content Checks
- [x] All UUIDs match: `78fe4967-4e62-5491-d981-dd781acca4d7`
- [x] meta.lsx has correct mod name: `BG3Wow`
- [x] meta.lsx has author: `vorgx`
- [x] Version64 set: `36028797018963968` (1.0.0)

### Localization Checks
- [x] All 128 handles present (h125abc01-128)
- [x] XML properly formatted with TranslatedString elements
- [x] All spell/status references have localization

---

## INSTALLATION LOCATIONS

After packaging, copy `BG3Wow.pak` to one of these locations:

### Windows
```
%LOCALAPPDATA%\Larian Studios\Baldur's Gate 3\Mods\
```

**Full Path**:
```
C:\Users\tenod\AppData\Local\Larian Studios\Baldur's Gate 3\Mods\BG3Wow.pak
```

### Enable in ModManager
1. Open BG3 Mod Manager
2. Import `BG3Wow.pak`
3. Enable the mod
4. Export load order
5. Launch game

---

## TROUBLESHOOTING

### Issue: "Package creation failed"
**Solution**: Check file paths have no special characters, ensure LSLib has write permissions

### Issue: "Invalid version"
**Solution**: Use Package Version `v18` for Patch 8

### Issue: "Mod doesn't appear in-game"
**Solution**: 
- Verify .pak is in correct Mods folder
- Check ModManager load order
- Ensure mod is enabled in modsettings.lsx

### Issue: "Game crashes on load"
**Solution**: 
- Check meta.lsx for errors
- Verify all XML files are well-formed
- Check Progressions.lsx for invalid references

---

## PACKAGING OPTIONS

### Compression Methods
- **LZ4**: Recommended (fast, good compression)
- **Zlib**: Alternative (slower, slightly better compression)
- **None**: Not recommended (large file size)

### Package Versions
- **v13**: Patch 4-6
- **v16**: Patch 7
- **v18**: Patch 8 (current - use this)

---

## POST-PACKAGING VALIDATION

After creating the .pak:

1. **Check file size**: Should be 50-200 KB (depending on content)
2. **Test extraction**: Use LSLib to extract and verify contents
3. **Install and test**: Copy to Mods folder and launch game
4. **Character creation**: Check if Warrior class appears
5. **In-game test**: Create character, test abilities

---

## VERSION INCREMENTING

When making updates:

1. Update `Version64` in meta.lsx:
   - Current: `36028797018963968` (1.0.0)
   - Next: `36028797018963969` (1.0.1)
   - Formula: Major.Minor.Revision.Build encoded as int64

2. Update mod description if needed

3. Repackage with new version number

---

## DISTRIBUTION

When ready to share:

1. **Test thoroughly** in-game
2. **Create README.md** with installation instructions
3. **Package** with LSLib
4. **Upload** to Nexus Mods or similar platform
5. **Include**:
   - `BG3Wow.pak` file
   - Installation instructions
   - Changelog
   - Known issues
   - Credits

---

## NEXT STEPS AFTER PACKAGING

1. ✅ Package the mod using LSLib
2. ✅ Copy `BG3Wow.pak` to Mods folder
3. ✅ Enable in BG3 Mod Manager
4. ✅ Launch game and test
5. ✅ Verify Warrior class appears in character creation
6. ✅ Test abilities in-game (see VALIDATION_STATUS_FINAL.md)
7. ✅ Fix any issues found
8. ✅ Proceed to Fury/Protection implementation

---

**Ready to package?** See the PowerShell script below or use LSLib GUI!
