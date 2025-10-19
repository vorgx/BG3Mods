# FILE 1: meta.lsx Transformation Template

## Purpose
Defines mod metadata, version information, dependencies, and folder structure.

## File Location
- **Warlock Template**: `Data/Mods/Warlock_WoW_bdb3fa73-401b-4979-f02e-485422dd8d9c/meta.lsx`
- **Warrior Target**: `Data/Mods/Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7/meta.lsx`

## Critical Decisions Made

### 1. Folder Naming Convention
**Options considered**:
- `BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7`
- `Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7` ← **CHOSEN**
- `WoWWarrior_78fe4967-4e62-5491-d981-dd781acca4d7`

**Rationale**: Matches template pattern (Warlock_WoW), clear class identifier, professional naming.

### 2. Version Number Strategy
**Options considered**:
- Keep Warlock version: `72339069014638693` (v1.0.1.5)
- Use clean version: `36028797018963968` (v1.0.0.0) ← **CHOSEN**

**Rationale**: Fresh start for new mod, clean version semantics, no inherited version history.

### 3. Dependencies
**Decision**: Keep all 13 dependencies from Warlock template (proven working pattern).

**Rationale**: These handle:
- Gustav (base game)
- GustavDev (development tools)
- Shared / SharedDev (shared resources)
- Various DLC packs (compatibility)

## Transformation Mapping

### Attributes Changed (7 replacements)

| Attribute | Warlock Value | Warrior Value | Notes |
|-----------|---------------|---------------|-------|
| **Author** | `Royah97` | `vorgx` | Mod creator |
| **Name** | `WoWWarlock` | `WoWWarrior` | Display name |
| **Description** | `Warlock class...` | `Warrior class with 3 specializations...` | User-facing description |
| **UUID** | `bdb3fa73-401b-4979-f02e-485422dd8d9c` | `78fe4967-4e62-5491-d981-dd781acca4d7` | **CRITICAL**: Must match folder names |
| **Folder** | `Warlock_WoW_bdb3fa73...` | `Warrior_Wow_78fe4967...` | Both Mods/ and Public/ folders |
| **Version64** | `72339069014638693` | `36028797018963968` | Clean v1.0.0.0 |
| **PublishVersion** | `144255927717549775` | `36028797018963968` | Matches Version64 |

### Attributes Kept (5 unchanged)

| Attribute | Value | Rationale |
|-----------|-------|-----------|
| **Type** | (not present) | Warlock doesn't define, BG3 defaults to "Add-on" |
| **TargetModes** | (not present) | Warlock omits this, mod works in all game modes |
| **Scripts** | `<node id="Script">...</node>` | Keep Script Extender integration structure |
| **Dependencies** | All 13 modules | Proven compatibility, handles DLCs |
| **ModuleInfo node** | Structure with PublishHandle/MD5 | Keep all metadata nodes |

## Folder Renaming Required

### Before Transformation
```
Data/
├── Mods/Warlock_WoW_bdb3fa73-401b-4979-f02e-485422dd8d9c/
└── Public/Warlock_WoW_bdb3fa73-401b-4979-f02e-485422dd8d9c/
```

### After Transformation
```
Data/
├── Mods/Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7/
└── Public/Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7/
```

**⚠️ CRITICAL**: Folder names MUST match UUID and Folder attribute exactly.

## Final Target State (Complete File)

```xml
<?xml version="1.0" encoding="UTF-8"?>
<save>
    <version major="4" minor="7" revision="1" build="3"/>
    <region id="Config">
        <node id="root">
            <children>
                <node id="Dependencies">
                    <children>
                        <node id="ModuleShortDesc">
                            <attribute id="Folder" type="LSString" value="GustavDev"/>
                            <attribute id="MD5" type="LSString" value=""/>
                            <attribute id="Name" type="LSString" value="GustavDev"/>
                            <attribute id="PublishHandle" type="uint64" value="0"/>
                            <attribute id="UUID" type="guid" value="28ac9ce2-2aba-8cda-b3b5-6e922f71b6b8"/>
                            <attribute id="Version64" type="int64" value="36028797018963968"/>
                        </node>
                        <node id="ModuleShortDesc">
                            <attribute id="Folder" type="LSString" value="Gustav"/>
                            <attribute id="MD5" type="LSString" value=""/>
                            <attribute id="Name" type="LSString" value="Gustav"/>
                            <attribute id="PublishHandle" type="uint64" value="0"/>
                            <attribute id="UUID" type="guid" value="991c9c7a-fb80-40cb-8f0d-b92d4e80e9b1"/>
                            <attribute id="Version64" type="int64" value="36028797018963968"/>
                        </node>
                        <!-- ... 11 more dependency nodes (keep all from Warlock) ... -->
                    </children>
                </node>
                <node id="ModuleInfo">
                    <attribute id="Author" type="LSString" value="vorgx"/>
                    <attribute id="CharacterCreationLevelName" type="FixedString" value=""/>
                    <attribute id="Description" type="LSString" value="Adds the Warrior class with 3 specializations (Arms, Fury, Protection) and Rage resource system"/>
                    <attribute id="FileSize" type="uint64" value="0"/>
                    <attribute id="Folder" type="LSString" value="Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7"/>
                    <attribute id="LobbyLevelName" type="FixedString" value=""/>
                    <attribute id="MD5" type="LSString" value=""/>
                    <attribute id="MainMenuBackgroundVideo" type="FixedString" value=""/>
                    <attribute id="MenuLevelName" type="FixedString" value=""/>
                    <attribute id="Name" type="LSString" value="WoWWarrior"/>
                    <attribute id="NumPlayers" type="uint8" value="4"/>
                    <attribute id="PhotoBooth" type="FixedString" value=""/>
                    <attribute id="PublishHandle" type="uint64" value="0"/>
                    <attribute id="PublishVersion" type="int64" value="36028797018963968"/>
                    <attribute id="StartLevelName" type="FixedString" value=""/>
                    <attribute id="UUID" type="guid" value="78fe4967-4e62-5491-d981-dd781acca4d7"/>
                    <attribute id="Version64" type="int64" value="36028797018963968"/>
                    <children>
                        <node id="PublishVersion">
                            <attribute id="Version64" type="int64" value="36028797018963968"/>
                        </node>
                        <node id="Scripts">
                            <children>
                                <node id="Script">
                                    <attribute id="UUID" type="FixedString" value="f97b43be-7398-4ea5-8fe2-be7eb3d4b5ca"/>
                                </node>
                            </children>
                        </node>
                        <node id="TargetModes">
                            <children>
                                <node id="Target">
                                    <attribute id="Object" type="FixedString" value="Story"/>
                                </node>
                            </children>
                        </node>
                    </children>
                </node>
            </children>
        </node>
    </region>
</save>
```

## Validation Checklist

Before moving to FILE 2, verify:

- [ ] **UUID consistency**: `78fe4967-4e62-5491-d981-dd781acca4d7` matches in:
  - ModuleInfo UUID attribute
  - Folder names (Mods/ and Public/)
  - Folder attribute value
- [ ] **Version numbers**: Both `Version64` and `PublishVersion` = `36028797018963968`
- [ ] **Folders renamed**: Both `Data/Mods/` and `Data/Public/` folders
- [ ] **XML validation**: File opens without errors in VS Code
- [ ] **Dependencies intact**: All 13 dependency nodes preserved
- [ ] **Scripts section**: Kept unchanged from template

## Notes for Future Classes

### UUID Generation Strategy
For new classes, generate UUIDs using:
- PowerShell: `[guid]::NewGuid().ToString()`
- Python: `import uuid; str(uuid.uuid4())`
- Online: https://www.uuidgenerator.net/

**Pattern**: Use lowercase, no brackets: `12345678-1234-1234-1234-123456789abc`

### Version64 Calculation
Format: `MAJOR.MINOR.REVISION.BUILD`
- v1.0.0.0 = `36028797018963968` (recommended for new mods)
- v1.0.1.0 = `36310271490727936`
- v1.0.1.5 = `72339069014638693`

**Formula**: `((MAJOR * 2^55) + (MINOR * 2^47) + (REVISION * 2^31) + BUILD)`

### Folder Naming Best Practices
Use pattern: `ClassIdentifier_ModPrefix_UUID`
- ✅ `Warrior_Wow_78fe4967...` (clear, professional)
- ✅ `Paladin_WoW_abcdef12...`
- ❌ `BG3Wow_78fe4967...` (ambiguous class)
- ❌ `MyAwesomeClass...` (unprofessional)

### Dependencies Management
**Always keep Gustav dependencies** (first 2 nodes):
- `GustavDev` (dev tools)
- `Gustav` (base game)

**Consider DLC compatibility**:
- Keep Shared/SharedDev for asset reuse
- Keep DLC dependencies if using their assets
- Safe to keep all 13 even if not using all features

## Troubleshooting

### Issue: Mod doesn't appear in Mod Manager
**Cause**: UUID mismatch between meta.lsx and folder names  
**Fix**: Verify all 3 locations use exact same UUID

### Issue: Load order conflicts
**Cause**: Missing dependencies  
**Fix**: Ensure all 13 dependencies present, especially Gustav

### Issue: Version errors in game logs
**Cause**: Version64 and PublishVersion mismatch  
**Fix**: Set both to same value (36028797018963968 for v1.0.0.0)

---

**Transformation Date**: January 2025  
**Template Version**: 1.0  
**Source Mod**: WoWWarlock (bdb3fa73-401b-4979-f02e-485422dd8d9c)  
**Proven Working**: Yes (13K+ downloads)
