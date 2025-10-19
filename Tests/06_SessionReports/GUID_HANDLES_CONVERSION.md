# GUID Handle Format Conversion - October 18, 2025

## Problem Identified

The mod was loading successfully but the Warrior class was **invisible** in character creation. Analysis revealed:

1. **SIMPLIFIED package (44 KB)** - Didn't include localization → Class invisible
2. **Previous attempts with localization** - Crashed the game
3. **Root cause**: Incorrect handle format in localization files

## Solution: Convert to GUID-Format Handles

After analyzing working mods (WoWDemonHunterClass, WoWWarlock), discovered they ALL use **GUID-format handles**:

### GUID Handle Format
- Pattern: `h` + 8hex + `g` + 4hex + `g` + 4hex + `g` + 4hex + `g` + 12hex
- Example: `h113ba9cbgebe3g4971ga06ag961e06c51d52`
- This is a standard GUID with hyphens replaced by 'g'

### Our Previous (Incorrect) Format
- Pattern: `h` + continuous hex string
- Example: `h5a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d`
- BG3 couldn't match these in localization lookups

## Files Modified

### 1. ClassDescriptions.lsx
Updated all TranslatedString handles:

**Warrior Base Class:**
- DisplayName: `h5a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d` → `h2192a15fgd3c6g47c8g8f2ag887078521591`
- Description: `hd78e30ba1c9e4f9bb0c9aa1f8e9c7d2a` → `hec9f49b2g20fbg427bgb437gfd4041ffd5ec`

**Arms Warrior:**
- DisplayName: `h9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f` → `h0ae71f9cgcb9ag4eb9g8bedgdc08c872bccc`
- Description: `h1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d` → `h5300bf31g2077g4482g80dfg06112305b4d5`

**Fury Warrior:**
- DisplayName: `h4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f` → `h8d2875a5g4c2ag482fg9158g98f8d100d978`
- Description: `h3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e` → `h151545dbg38fdg42d8gbfe8g784683acd258`

**Protection Warrior:**
- DisplayName: `h6d7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a` → `hc4f8321dgffefg447fgb8fagd3f964cc05d8`
- Description: `h5c6d7e8f9a0b1c2d3e4f5a6b7c8d9e0f` → `hd276f0e5g1198g4d05g9a64ga3a38e97aea2`

### 2. ActionResourceDefinitions.lsx
Updated Rage resource handles:
- DisplayName: `h9b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e` → `hdffb5cfegff1fg4209gb239ga15ec5d929ee`
- Description: `h8a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d` → `h2483ce0dg3709g4983g8aacg8dde1c406c97`

### 3. Localization Files
**Updated:** `Data/Mods/.../Localization/English/english.xml`
- Replaced ALL class description handles with new GUID format
- Added Rage resource entries with GUID handles
- **Created:** `english.loca.xml` (duplicate copy - BG3 needs both files)

## Package Results

**New Package:** `BG3Wow_GUID_HANDLES_20251018_120902.pak`
- **Size:** 67.28 KB (previously 44 KB without localization)
- **Includes:** Both Mods/ and Public/ folders
- **Localization:** Both .xml and .loca.xml files included
- **Status:** Deployed to game Mods folder

## Expected Outcome

With GUID-format handles matching between ClassDescriptions.lsx and localization files, BG3 should now be able to:
1. ✅ Load the mod without crashing
2. ✅ Find localization strings for class names
3. ✅ Display "Warrior" class in character creation
4. ✅ Show all 3 subclasses (Arms, Fury, Protection)

## Testing Required

1. Launch BG3 via Mod Manager
2. Start new character creation
3. Check if "Warrior" appears in class list
4. Verify all 3 subclasses appear at level 3

## References

- **Working Mods Analyzed:** WoWDemonHunterClass, WoWWarlock
- **BG3 Wiki:** https://bg3.wiki/wiki/Modding:Working_with_LSX_files
- **Key Discovery:** All working class mods use GUID-format handles in both LSX and localization files
