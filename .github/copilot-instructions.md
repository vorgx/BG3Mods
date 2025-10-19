# BG3Wow - Baldur's Gate 3 Warrior Class Mod

## Project Overview

This is a **Baldur's Gate 3 mod** that implements World of Warcraft's Warrior class with three specializations (Arms, Fury, Protection) and a Rage resource system. The mod uses Larian's modding framework with `.lsx` (XML-like) files for game data and `.txt` stat files for abilities.

**Mod UUID**: `78fe4967-4e62-5491-d981-dd781acca4d7`  
**Current Version**: 1.0.0.3 (Patch 8 / BG3 v4.8.0.10)

## 🚨 CURRENT STATUS: File-by-File Transformation In Progress

**Strategy**: Using proven WoWWarlock mod (13K+ downloads) as template foundation  
**Method**: Systematic file-by-file transformation (analyze → review → approve → transform → test)  
**Progress**: ✅ FILES 1-2 COMPLETE + TESTS PASSING | 📋 FILE 3 NEXT  
**Handover Doc**: `HANDOVER_FILE_BY_FILE_START.md` ← **READ THIS FIRST**  
**Detailed Plan**: `Reports\FILE_BY_FILE_TRANSFORMATION_PLAN.md`  
**Test Suite**: `Documentation\08_TransformationTemplates\Tests\` ← **NEW: Automated validation**

**Critical Backups**:
- Full Warrior mod: `Tests\WARRIOR_BACKUP_BEFORE_TEMPLATE_20251018_183829`
- Stat files only: `Tests\WARRIOR_STATS_BACKUP_20251018_183829`

**Current Template**: Fresh WoWWarlock copy in `Data/` folder (UUID: `bdb3fa73-401b-4979-f02e-485422dd8d9c`)  
**Goal**: Transform to Warrior mod with L1-20, 3 subclasses, 135 abilities

**Completed Files**:
- ✅ FILE 1: meta.lsx (UUID, dependencies, version) - Test passing
- ✅ FILE 2: ClassDescriptions.lsx (base + 3 subclasses, 2 active + 2 commented) - Test passing
  - **Note**: Currently using dummy SpellList UUID `32879c22-4858-48ef-8f8d-22e6d395b396` (Warlock template)
  - Will replace with real Warrior SpellList UUID when FILE 12 (Lists/SpellLists.lsx) is transformed

---

## 🔴 SOURCE OF TRUTH PROTOCOL (CRITICAL - ALWAYS FOLLOW)

**Living Document**: `Documentation/00_SourcesOfTruth/SOURCE_OF_TRUTH.md`

This is the **single authoritative source** for all project information. All other documents may be outdated.

### Pre-Change Protocol
**BEFORE making ANY code or file changes**:
1. Read relevant section of `Documentation/00_SourcesOfTruth/SOURCE_OF_TRUTH.md`
2. Use it as baseline for current state
3. Cross-reference with design documents if needed
4. Proceed with change

### Post-Change Protocol
**AFTER any change + tests pass**:
1. Update SOURCE_OF_TRUTH.md with new information
2. Update "Last Updated" timestamp in changed section
3. Add change log entry with date and reason
4. If creating new files, update [12] Folder Structure Inventory
5. If changing UUIDs/names, update all relevant sections

### File Creation Protocol
**BEFORE creating new files**:
1. Check [12] Folder Structure Inventory in SOURCE_OF_TRUTH.md
2. Determine correct folder location
3. Present location to user for confirmation
4. Create file in confirmed location
5. Update SOURCE_OF_TRUTH.md folder inventory

### Cross-Reference Protocol
**WHEN moving/renaming files or folders**:
1. Search SOURCE_OF_TRUTH.md for all references to old path/name
2. Update ALL references to new path/name
3. Search codebase for broken links (README.md, INDEX.md, HANDOVER docs)
4. Run all tests to verify nothing broke
5. Update SOURCE_OF_TRUTH.md with rename record

### Archive Protocol
**DO NOT use information from Archive/ folders** unless explicitly asked:
- Archive folders contain outdated information
- Always use SOURCE_OF_TRUTH.md as primary reference
- If user asks about history, check Archive/ AFTER checking SOURCE_OF_TRUTH.md

### Enforcement
- **Pre-change**: Read SOURCE_OF_TRUTH.md section → Use as baseline → Proceed
- **Post-change**: Update SOURCE_OF_TRUTH.md → Update timestamp → Add change log → Confirm
- **File creation**: Check folder inventory → Confirm location → Create → Update inventory
- **Cross-reference**: Search old name → Update all → Test → Record change

---

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

### 0. SOURCE OF TRUTH PROTOCOL (READ FIRST)
- **⚠️ MANDATORY**: Follow SOURCE OF TRUTH PROTOCOL (see section above)
- **Pre-change**: Read `Documentation/00_SourcesOfTruth/SOURCE_OF_TRUTH.md` relevant section
- **Post-change**: Update SOURCE_OF_TRUTH.md + timestamp + change log
- **File creation**: Check folder inventory, confirm location with user
- **Cross-reference**: Update all references when moving/renaming files

### 1. Check Handover Document (File-by-File Transformation)
- **⚠️ MANDATORY**: Read `HANDOVER_FILE_BY_FILE_START.md` for current session context
- **⚠️ VALIDATE**: Check what file we're currently working on (1-15)
- **⚠️ VERIFY**: Confirm previous file was completed before moving to next
- **⚠️ WORKFLOW**: Analyze → Review → Approve → Transform → Verify (never skip approval!)

### 2. File-by-File Transformation Rules (CURRENT STRATEGY)
- **NEVER** skip ahead - complete current file before suggesting next
- **ALWAYS** present side-by-side comparison (Warlock vs Warrior)
- **ALWAYS** wait for explicit user approval before changing anything
- **ALWAYS** verify changes after transformation (XML syntax, references)
- **ALWAYS** create test script for each file (following Test-MetaLsx.ps1 / Test-ClassDescriptions.ps1 patterns)
- **ALWAYS** run tests to verify transformation before moving to next file
- **DOCUMENT** every change made to each file
- **CREATE** checkpoint after each priority group

### 3. Read Design Documents
- **ALWAYS check**: `Documentation/07_DesignDocuments/` - Class blueprints, design specs, intended mechanics
- **ALWAYS check**: `Documentation/06_ProjectDocuments/` - Implementation guides, passive definitions, file references
- **ALWAYS check**: `Reports/02_Transformation/FILE_BY_FILE_TRANSFORMATION_PLAN.md` - Current transformation plan
- **Understand the INTENDED design** before modifying implementation or making claims about what's missing

### 4. Scan Implementation Files
- Read actual file contents in `Data/Public/.../Stats/Generated/Data/`
- Check ALL file types: `Spell_*.txt`, `Status_BOOST.txt`, `Passive.txt`, `Progressions.lsx`
- Don't rely on grep results alone - verify with actual file reads
- Many abilities are status effects or passives, not spell entries

### 5. Update Documentation for EVERY Change
- **If you change code** → Update relevant `.md` files in Documentation/
- **If you move files** → Update path references immediately (README.md, INDEX.md, etc.)
- **If you discover errors** → Create correction documents with evidence (line numbers, file paths)
- **Keep design docs and implementation in sync** - documentation drift causes confusion

### 6. Trust User Knowledge
- User knows their project better than AI scanning
- Verify user statements rather than contradicting them
- Ask clarifying questions if design intent is unclear
- Example: "I believe we converted heroic strike to sunder" → User was correct, validate first

### 7. Lessons from WoWWarlock Autopsy (Apply to Stat Files)
When transforming stat files (FILES 4-10), ensure entries have these fields:

**Visual Effects** (from Warlock reference):
- `data "PrepareEffect"` - Casting animation start
- `data "CastEffect"` - Spell launch visual  
- `data "TargetEffect"` - Impact on target

**Tooltips**:
- `data "TooltipDamageList"` - Damage display
- `data "TooltipAttackSave"` - Save DC display

**Animations**:
- `data "SpellAnimation"` - Character animation

**Flags**:
- `data "SpellFlags"` - Spell behavior flags
- `data "VerbalIntent"` - AI behavior hints

**Icon References**:
- `data "Icon"` - Ability icon path

**Cooldown Format**:
- Use `"OncePerTurn"`, `"OncePerShortRest"`, `"OncePerCombat"` (NOT numeric values)

### 8. Critical Naming Conventions
- **Warrior Abilities**: ALWAYS use `WAR_*` prefix (e.g., `WAR_Charge`, `WAR_MountainThane_Keystone`)
- **NEVER** use `WoWWarrior_*` prefix (causes crashes - passive name mismatch)
- **Warlock References**: Keep UUIDs unchanged, replace spell/passive names only

### 9. UUID Management
- **Warlock Template UUID**: `bdb3fa73-401b-4979-f02e-485422dd8d9c` (in Data/ folder now)
- **Warrior Mod UUID**: `78fe4967-4e62-5491-d981-dd781acca4d7` (our target)
- **Folder Naming**: Must match UUID exactly
- **Don't create new UUIDs** unless explicitly instructed (we're transforming, not creating from scratch)

### 10. Test Creation Protocol (NEW - October 18, 2025)
**CRITICAL**: For EVERY file transformed (FILES 1-15), create a validation test script.

**Test Script Naming**: `Test-{FileName}.ps1` (e.g., `Test-MetaLsx.ps1`, `Test-ClassDescriptions.ps1`)  
**Location**: `Transformation_Templates/Tests/`  
**Pattern**: Follow `Test-MetaLsx.ps1` and `Test-ClassDescriptions.ps1` as reference templates

**Required Test Elements**:
```powershell
# 1. Parameters (file path, expected values)
param([Parameter(Mandatory=$true)][string]$FilePath)

# 2. Color output helpers (NO Unicode characters!)
function Write-Pass { param($Message) Write-Host "[PASS] $Message" -ForegroundColor Green }
function Write-Fail { param($Message) Write-Host "[FAIL] $Message" -ForegroundColor Red; $script:FailCount++ }
function Write-Warn { param($Message) Write-Host "[WARN] $Message" -ForegroundColor Yellow }
function Write-Info { param($Message) Write-Host "[INFO] $Message" -ForegroundColor Cyan }

# 3. XML handling for .lsx files - ALWAYS strip multi-line comments first
$RawContent = Get-Content $FilePath -Raw
$CleanedContent = $RawContent -replace '(?s)<!--.*?-->', ''
[xml]$ParsedXml = $CleanedContent

# 4. Validation checks with informative context
Write-Info "Found value: $SomeValue"
if ($SomeValue -eq $ExpectedValue) { Write-Pass "Value correct" } 
else { Write-Fail "Value mismatch: expected $ExpectedValue, got $SomeValue" }

# 5. Exit with proper code
if ($FailCount -gt 0) { exit 1 } else { exit 0 }
```

**PowerShell XML Best Practices**:
- **Multi-line comments**: ALWAYS use `$Content -replace '(?s)<!--.*?-->', ''` before parsing (prevents "Unexpected end of file" errors)
- **Version checking**: Support both attribute AND child node patterns (Warlock uses child nodes)
- **Avoid Unicode**: Use `[PASS]`/`[FAIL]`/`[WARN]`/`[INFO]` - NO emoji (✅❌⚠️ℹ️ cause parse errors)
- **Show context**: Always display what was found before validating it (`Write-Info "UUID: $uuid"` then `Write-Pass "UUID valid"`)

**Test Master Runner**: After creating test, add it to `Test-AllFiles.ps1` for batch validation

**Documentation**: Update `Tests/README.md` with new test details, usage examples, and lessons learned

### 11. Create Evidence-Based Reports
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

