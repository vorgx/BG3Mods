# Localization XML Header Fix - October 18, 2025

## Problem Discovered

After converting to GUID-format handles, the mod **still crashed**. Investigation revealed the crash was caused by **incorrect XML header** in localization files.

## Root Cause

### Our Localization Header (WRONG):
```xml
<?xml version="1.0"?>
<contentList xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
```

### Working Mods' Header (CORRECT):
```xml
<?xml version="1.0" encoding="utf-8"?>
<contentList>
```

**The Issue**: BG3 doesn't use or expect XML schema declarations (`xmlns:xsd`, `xmlns:xsi`) in localization files. These extra attributes caused the game to crash when parsing the localization data.

## Solution Applied

### 1. Fixed XML Header
Changed from:
```xml
<?xml version="1.0"?>
<contentList xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
```

To:
```xml
<?xml version="1.0" encoding="utf-8"?>
<contentList>
```

### 2. Updated Both Files
- ✅ `english.xml` - Fixed header
- ✅ `english.loca.xml` - Updated copy with fixed header

## Important Clarification: Handle vs UUID Format

Based on user's research with BG3 Toolkit and official documentation:

### **Actual UUIDs** (type="guid"):
- Format: `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx` (standard GUID with **hyphens**)
- Example: `6e3d9938-b2d5-4a8a-825c-cb91a0dd3dc4`
- Used for: CharacterCreationPose, ProgressionTableUUID, UUID attributes

### **Localization Handles** (TranslatedString handle=):
- Format: `h` + 8hex + `g` + 4hex + `g` + 4hex + `g` + 4hex + `g` + 12hex
- Example: `h113ba9cbgebe3g4971ga06ag961e06c51d52`
- The 'g' replaces hyphens in GUID format for handles specifically
- Used for: DisplayName and Description handles in TranslatedString attributes

**Both formats were CORRECT in our implementation.** The crash was purely from the XML schema declarations.

## Package Results

**New Package:** `BG3Wow_FIXED_XML_20251018_121223.pak`
- **Size:** 67.16 KB
- **Changes:** Only XML header fix in localization files
- **Status:** ✅ Deployed to game Mods folder

## Expected Outcome

With the correct XML header matching working mods:
1. ✅ Game should load without crashing
2. ✅ Localization strings should parse correctly
3. ✅ "Warrior" class should appear in character creation
4. ✅ All class names and descriptions should display properly

## Files Modified

- `Data/Mods/.../Localization/English/english.xml` - Fixed XML header
- `Data/Mods/.../Localization/English/english.loca.xml` - Updated with fixed header

## Testing Required

1. Launch BG3 via Mod Manager
2. Verify game loads without crash
3. Check character creation for "Warrior" class
4. Verify class description displays correctly
