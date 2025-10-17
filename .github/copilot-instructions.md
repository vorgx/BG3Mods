# BG3Wow - Baldur's Gate 3 Warrior Class Mod

## Project Overview

This is a **Baldur's Gate 3 mod** that implements World of Warcraft's Warrior class with three specializations (Arms, Fury, Protection) and a Rage resource system. The mod uses Larian's modding framework with `.lsx` (XML-like) files for game data and `.txt` stat files for abilities.

**Mod UUID**: `78fe4967-4e62-5491-d981-dd781acca4d7`  
**Current Version**: 1.0.0.3 (Patch 8 / BG3 v4.8.0.10)

## Critical Architecture Patterns

### 1. File Structure (Non-Negotiable Paths)

```
Data/
├── Mods/BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7/
│   ├── meta.lsx                          # Mod metadata, dependencies
│   └── ScriptExtender/                   # SE debugging (Lua)
└── Public/BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7/
    ├── ClassDescriptions/ClassDescriptions.lsx  # Class/subclass definitions
    ├── Progressions.lsx                  # Level progression tables
    ├── Stats/Generated/Data/             # Ability stat files (.txt)
    │   ├── Spell_Target.txt              # Single-target abilities
    │   ├── Spell_Shout.txt               # AoE buffs
    │   ├── Spell_Jump.txt                # Gap closers (Charge, Leap)
    │   ├── Spell_Zone.txt                # Ground-targeted AoEs
    │   ├── Spell_Projectile.txt          # Ranged attacks
    │   ├── Status_BOOST.txt              # Buffs/debuffs
    │   └── Passive.txt                   # Passive abilities
    └── ActionResourceDefinitions/        # Rage resource definition
```

**CRITICAL**: The UUID `78fe4967-4e62-5491-d981-dd781acca4d7` MUST match across `meta.lsx`, folder names, and all references.

### 2. BG3-Specific File Formats

#### Spell Definitions (Stats/Generated/Data/*.txt)
Uses Larian's custom key-value format, NOT standard config syntax:
```
new entry "Target_WAR_Execute"
type "SpellData"
data "SpellType" "Target"
data "UseCosts" "ActionPoint:1;Rage:20"
data "DisplayName" "h125abc01;1"  // Localization handle
data "SpellSuccess" "DealDamage(4d12+StrengthModifier,MainMeleeWeaponDamageType,Magical)"
```

**Key patterns**:
- `data "TargetConditions"` uses Larian's condition syntax (e.g., `HealthPercentage(context.Target) <= 20`)
- Damage formulas: `DealDamage(XdY+Modifier,DamageType,Magical)`
- Status application: `ApplyStatus(SELF,STATUS_NAME,100,6)` (100 = chance, 6 = duration)

#### Progressions.lsx (Level-based grants)
XML structure with nested nodes:
```xml
<node id="Progression">
    <attribute id="Level" type="uint8" value="1"/>
    <attribute id="Boosts" type="LSString" value="ActionResource(Rage,100,0);Proficiency(HeavyArmor)"/>
    <attribute id="PassivesAdded" type="LSString" value="WAR_RageGeneration"/>
    <children>
        <node id="AddSpells">
            <attribute id="Spells" type="LSString" value="WAR_Charge;WAR_HeroicStrike"/>
        </node>
    </children>
</node>
```

### 3. Localization System

All user-facing text uses handles in `Public/.../Localization/English/English.loca.xml`:
```xml
<contentList>
    <content contentuid="h125abc01" version="1">Execute</content>
    <content contentuid="h125abc02" version="4">Strike down enemies below 20% HP for 4d12 damage.</content>
</contentList>
```

**Pattern**: Handle format is `h[8hex chars][2digit counter]` (e.g., `h125abc01`, `h125abc02`). Increment counter for each new string.

## Development Workflows

### Packaging the Mod
**Tool**: LSLib's Divine.exe or ConverterApp.exe (located in `LsLib/` folder, but may need manual download from GitHub)

**Command** (PowerShell):
```powershell
& "path\to\LSLib\ConverterApp.exe" `
  --source "Data" `
  --destination "Package\BG3Wow.pak" `
  --action "create-package" `
  --package-version "v18" `
  --compression-method "lz4"
```

**Install location**: `%LOCALAPPDATA%\Larian Studios\Baldur's Gate 3\Mods\BG3Wow.pak`

### Testing Workflow
1. Package mod to `.pak` file
2. Copy to game's `Mods/` folder
3. Open **BG3 Mod Manager** (separate tool), enable mod, export load order
4. Launch game (Script Extender optional but enables debug logging)
5. Check logs: `%LOCALAPPDATA%\Larian Studios\Baldur's Gate 3\ScriptExtender\Logs\`

**Critical**: Conflicting mods with similar class names will crash the game. Check for existing Warrior mods in `Mods/` folder.

### Debugging
- **Script Extender logs**: `Data/Mods/.../ScriptExtender/Lua/Bootstrap*.lua` files log mod initialization
- **Search pattern**: `[BG3WOW]` in SE logs to filter mod-specific messages
- **Common crash cause**: Invalid UUID references, malformed XML, missing localization handles

## Project-Specific Conventions

### Naming Conventions
- **Abilities**: `WAR_AbilityName` (e.g., `WAR_Charge`, `WAR_Execute`)
- **Spell entries**: `Target_WAR_AbilityName`, `Shout_WAR_AbilityName` (matches spell type)
- **Statuses**: `WAR_STATUS_NAME` (e.g., `WAR_SHIELD_BLOCK`)
- **Passives**: `WAR_PassiveName` or `WAR_SpecName_PassiveName` (e.g., `WAR_Colossus_Keystone`)

### Specialization System (L13-20)
**Unique approach**: Hero talent trees from WoW (Mountain Thane, Colossus, Slayer) implemented as passive chains:
- **L13**: Keystone passive (unlocks specialization mechanics)
- **L15/L17/L19/L20**: Choice nodes (2-3 options per tier)
- **Passives** modify existing abilities via conditions: `HasPassive('WAR_Colossus_Keystone',context.Source)`

Example from `Passive.txt`:
```
new entry "WAR_Colossus_Keystone"
data "Boosts" "UnlockSpell(WAR_Demolish)"  // Grants new ability
data "StatsFunctorContext" "OnCast"
data "Conditions" "HasStringInSpellRoll('Projectile(WAR_ShieldSlam)')"
data "StatsFunctors" "ApplyStatus(SELF,WAR_COLOSSAL_MIGHT,100,5)"
```

### ✅ All Critical Dependencies Complete (v1.0.1.0)
All 9 abilities referenced by specialization passives are fully implemented:
- ✅ Execute, Shield Slam, Revenge, Shockwave, Thunder Clap (Spell_Target.txt & Spell_Zone.txt)
- ✅ Whirlwind, Raging Blow (Spell_Zone.txt & Spell_Target.txt)
- ✅ Mortal Strike (Spell_Target.txt)
- ✅ Avatar (Spell_Target.txt + Status_BOOST.txt)

**Mod Status**: 100% feature complete for base class + 3 specializations + hero talents (L13-20)

## Documentation Structure

### Implementation Guides (Documentation/06_ProjectDocuments/)
- **GETTING_STARTED.md**: 4-week roadmap for building the mod from scratch
- **FILE_REFERENCE.md**: BG3 file format syntax examples
- **ABILITY_IMPLEMENTATION_INVENTORY.md**: Tracks which abilities are complete vs. missing
- **PASSIVES_*.md**: Complete passive definitions ready for copy-paste into `Passive.txt`

### Session History (Tests/)
- **VALIDATION_STATUS_FINAL.md**: Last successful build validation
- **SUNDER_ARMOR_IMPLEMENTATION.md**: Example of full ability implementation flow
- Crash diagnosis reports (DEBUGGING_CRASHES.md in root)

## Common Pitfalls

1. **LSLib version mismatch**: Must use v1.20.3+ for Patch 8 compatibility (package version `v18`)
2. **Localization handles**: Missing or duplicate handles cause silent failures in character creation
3. **Rage resource**: Defined in `ActionResourceDefinitions/ActionResourceDefinitions.lsx`, NOT in Progressions.lsx
4. **Cooldown syntax**: `data "Cooldown" "OncePerTurn"` (not `"1Turn"` or numeric values)
5. **Context objects**: Use `context.Source` for caster, `context.Target` for target in conditions

## Pre-Packaging Validation Checklist

Before packaging a new version, ALWAYS run these checks:

### **1. UUID Consistency**
- [ ] Check `meta.lsx`: `<attribute id="UUID" value="78fe4967-4e62-5491-d981-dd781acca4d7" />`
- [ ] Verify folder names: `Mods/BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7/`
- [ ] Grep search for UUID in all files: NO hyphens/underscores inconsistencies

### **2. Localization Handles**
- [ ] All handles follow format: `h[8hex][2digit]` (e.g., `h125abc01`, `h125abc02`)
- [ ] No duplicate contentuid values in `English.loca.xml`
- [ ] All DisplayName/Description references have corresponding handles

### **3. XML Syntax Validation**
- [ ] `meta.lsx` opens in VS Code without errors
- [ ] `Progressions.lsx` has matching opening/closing `<node>` tags
- [ ] `ClassDescriptions.lsx` validates (no orphaned attributes)

### **4. Spell_*.txt Format**
- [ ] All entries have `new entry "EntryName"` + `type "SpellData"`
- [ ] No missing quotes in `data "key" "value"` lines
- [ ] UseCosts format: `ActionPoint:1;Rage:20` (semicolon-separated)

### **5. Cross-Reference Validation**
- [ ] All spell references in `Progressions.lsx` exist in `Spell_*.txt` files
- [ ] All passive references in `Progressions.lsx` exist in `Passive.txt`
- [ ] All status references exist in `Status_BOOST.txt`

### **6. Version Management**
- [ ] Increment `Version64` in `meta.lsx` (current: based on mod version)
- [ ] Update `CHANGELOG.md` with version changes
- [ ] Copy new .pak to `Package/` with versioned filename

### **7. Script Extender Validation** (if using SE)
- [ ] `Config.json` has correct `"RequiredVersion"` field
- [ ] `BootstrapClient.lua` / `BootstrapServer.lua` have no syntax errors
- [ ] SE logs show `[BG3WOW]` initialization messages (no errors)

### **8. Testing Protocol**
1. Package mod with LSLib (package version `v18`, compression `lz4`)
2. Install to `%LOCALAPPDATA%\Larian Studios\Baldur's Gate 3\Mods\`
3. Enable in BG3 Mod Manager (refresh mod list first)
4. Export load order
5. Launch game via BG3 Mod Manager
6. Create NEW Warrior character (respec doesn't work for new classes)
7. Check SE logs: `%LOCALAPPDATA%\Larian Studios\Baldur's Gate 3\ScriptExtender\Logs\`
8. In-game validation:
   - [ ] Rage bar visible in character sheet
   - [ ] Abilities cast correctly (check cooldowns, rage costs)
   - [ ] Passive abilities trigger correctly
   - [ ] Localization displays correctly (no missing text)

---

## Key References

- **Meta file**: `Data/Mods/.../meta.lsx` (mod name, version, dependencies)
- **Class definitions**: `Public/.../ClassDescriptions/ClassDescriptions.lsx`
- **Full progression table**: `Public/.../Progressions.lsx` (1292 lines, levels 1-20 for base + 3 subclasses)
- **Spell examples**: `Stats/Generated/Data/Spell_Target.txt` (Execute, Shield Slam implementations)
- **Packaging guide**: `Documentation/01_Reference-Guides/PACKAGING_GUIDE.md` and `QUICK_PACKAGE.md`
- **PROJECT_INDEX.md**: `Documentation/01_Reference-Guides/PROJECT_INDEX.md` - Comprehensive folder/file inventory
- **DOCUMENTATION_LIBRARY.md**: `Documentation/01_Reference-Guides/DOCUMENTATION_LIBRARY.md` - Topic index with 18+ URLs

## Integration Notes

- **BG3 Script Extender**: Optional but recommended for debugging. Lua files in `ScriptExtender/Lua/` log mod lifecycle events
- **Mod Manager**: BG3 Mod Manager (external tool) required to enable mods and manage load order
- **Testing saves**: New game required after changes to class definitions or progressions
- **Validation Status**: See `Documentation/10_ValidationReports/ACTUAL_MISSING_ABILITIES.md` for accurate implementation status (98.5% complete)
- **Missing Abilities**: Only 2 optional abilities missing (Indomitable, Shield Wall) - not 5 as previously thought

## AI Agent Workflow Protocol ⚠️

**CRITICAL**: Before making ANY changes to code or documentation, ALWAYS follow this protocol:

### 1. Read Design Documents FIRST
- **ALWAYS check**: `Documentation/07_DesignDocuments/` - Class blueprints, design specs, intended mechanics
- **ALWAYS check**: `Documentation/06_ProjectDocuments/` - Implementation guides, passive definitions, file references
- **Understand the INTENDED design** before modifying implementation or making claims about what's missing

### 2. Scan Implementation Files SECOND
- Read actual file contents in `Data/Public/.../Stats/Generated/Data/`
- Check ALL file types: `Spell_*.txt`, `Status_BOOST.txt`, `Passive.txt`, `Progressions.lsx`
- Don't rely on grep results alone - verify with actual file reads
- Many abilities are status effects or passives, not spell entries

### 3. Update Documentation for EVERY Change
- **If you change code** → Update relevant `.md` files in Documentation/
- **If you move files** → Update path references immediately (README.md, INDEX.md, etc.)
- **If you discover errors** → Create correction documents with evidence (line numbers, file paths)
- **Keep design docs and implementation in sync** - documentation drift causes confusion

### 4. Trust User Knowledge
- User knows their project better than AI scanning
- Verify user statements rather than contradicting them
- Ask clarifying questions if design intent is unclear
- Example: "I believe we converted heroic strike to sunder" → User was correct, validate first

### 5. Create Evidence-Based Reports
- Show proof with line numbers and actual code snippets
- Include file paths for all references
- Create searchable documentation for future sessions
- Don't make claims without verification

**Example Workflow**:
1. User asks about missing abilities
2. Read `Documentation/07_DesignDocuments/Warrior_Class_Blueprint.md` first
3. Scan all stat files in `Data/Public/.../Stats/Generated/Data/`
4. Compare design intent vs. implementation
5. Create report with evidence (line numbers, file paths)
6. Update documentation if discrepancies found

