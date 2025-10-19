# 🔄 PLAN: Use WoWWarlock as Template for Warrior Mod

**Date:** October 18, 2024  
**Strategy:** Replace our mod with working WoWWarlock structure, then adapt for Warrior  
**Confidence:** 99% (using proven working structure)

---

## 🎯 STRATEGY OVERVIEW

### **Why This Will Work:**
1. ✅ WoWWarlock has 13,000+ downloads - **PROVEN TO WORK**
2. ✅ Same structure we need (class + 3 subclasses)
3. ✅ All files correctly formatted and linked
4. ✅ We keep our Warrior ability implementations (135 stat entries)
5. ✅ We just adapt Warlock's working skeleton

### **What We'll Do:**
1. Backup current Warrior mod
2. Copy WoWWarlock structure to our Data folder
3. Replace Warlock-specific content with Warrior content
4. Update UUIDs to our mod's UUID
5. Keep our existing stat files (they're good!)
6. Test incrementally

---

## 📋 DETAILED STEP-BY-STEP PLAN

### **PHASE 1: BACKUP & SETUP (5 minutes)**

#### **Step 1.1: Backup Current Warrior Mod**
```powershell
# Create timestamped backup
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$backupPath = "Tests\WARRIOR_BACKUP_BEFORE_TEMPLATE_$timestamp"

# Backup entire Data folder
Copy-Item "Data" "$backupPath" -Recurse -Force

Write-Host "✅ Backed up to: $backupPath"
```

**What We're Saving:**
- All our Warrior stat files (Passive.txt, Spell_*.txt, Status_BOOST.txt)
- Our Progressions.lsx (for reference)
- Our ClassDescriptions.lsx (for reference)
- Everything we've built so far

#### **Step 1.2: Backup Our Stat Files Separately (Extra Safety)**
```powershell
# Create dedicated stat files backup
$statsBackup = "Tests\WARRIOR_STATS_BACKUP_$timestamp"
New-Item -ItemType Directory -Path $statsBackup -Force

# Copy our carefully crafted stat files
Copy-Item "Data\Public\BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7\Stats\Generated\Data\*" `
    "$statsBackup\" -Force

Write-Host "✅ Stat files backed up separately"
```

**Why Extra Backup:**
- We have 135 working stat entries (good work!)
- Don't want to lose our Warrior ability implementations
- Can always restore these

---

### **PHASE 2: COPY WARLOCK TEMPLATE (2 minutes)**

#### **Step 2.1: Clear Current Data Folder**
```powershell
# Remove current mod (safely backed up)
Remove-Item "Data\*" -Recurse -Force

Write-Host "✅ Cleared Data folder"
```

#### **Step 2.2: Copy Warlock Structure**
```powershell
# Copy entire Warlock mod structure
$warlockSource = "Tests\02_ExampleMods\ExampleMod_WoWWarlock"

# Copy Mods folder structure
Copy-Item "$warlockSource\Mods\*" "Data\Mods\" -Recurse -Force

# Copy Public folder structure
Copy-Item "$warlockSource\Public\*" "Data\Public\" -Recurse -Force

Write-Host "✅ Copied Warlock template structure"
```

**What We Now Have:**
- Working meta.lsx
- Working ClassDescriptions.lsx
- Working Progressions.lsx
- Working Lists/ folder (105 entries!)
- Working ActionResourceDefinitions.lsx
- All Warlock stat files (as reference)

---

### **PHASE 3: RENAME FOLDERS (UUID Change) (3 minutes)**

#### **Step 3.1: Rename Warlock UUID to Warrior UUID**

**Warlock UUID:** `bdb3fa73-401b-4979-f02e-485422dd8d9c`  
**Warrior UUID:** `78fe4967-4e62-5491-d981-dd781acca4d7`

```powershell
# Rename Mods folder
Rename-Item "Data\Mods\Warlock_WoW_bdb3fa73-401b-4979-f02e-485422dd8d9c" `
    "Data\Mods\BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7"

# Rename Public folder
Rename-Item "Data\Public\Warlock_WoW_bdb3fa73-401b-4979-f02e-485422dd8d9c" `
    "Data\Public\BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7"

Write-Host "✅ Folders renamed to Warrior UUID"
```

---

### **PHASE 4: GLOBAL FIND & REPLACE (10 minutes)**

#### **Step 4.1: Replace All UUIDs**

We need to replace Warlock's UUID with ours in ALL files.

```powershell
# Get all text files in Data folder
$files = Get-ChildItem "Data" -Recurse -Include "*.lsx","*.txt" -File

foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw
    
    # Replace Warlock UUID with Warrior UUID
    $content = $content -replace "bdb3fa73-401b-4979-f02e-485422dd8d9c", "78fe4967-4e62-5491-d981-dd781acca4d7"
    
    # Save back
    Set-Content $file.FullName -Value $content -NoNewline
}

Write-Host "✅ Replaced all UUIDs"
```

#### **Step 4.2: Replace Mod Name & Folder References**

```powershell
foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw
    
    # Replace mod name
    $content = $content -replace "Warlock_WoW", "BG3Wow"
    $content = $content -replace "WoWWarlock", "WoWWarrior"
    
    # Save back
    Set-Content $file.FullName -Value $content -NoNewline
}

Write-Host "✅ Replaced mod names"
```

---

### **PHASE 5: UPDATE META.LSX (5 minutes)**

#### **Step 5.1: Edit meta.lsx**

**File:** `Data\Mods\BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7\meta.lsx`

**Changes Needed:**
```xml
<!-- BEFORE (Warlock) -->
<attribute id="Name" value="WoWWarlock"/>
<attribute id="Author" value="[Warlock Author]"/>
<attribute id="Description" value="World of Warcraft Warlock class..."/>

<!-- AFTER (Warrior) -->
<attribute id="Name" value="BG3Wow"/>
<attribute id="Author" value="[Your Name]"/>
<attribute id="Description" value="World of Warcraft Warrior class with Arms, Fury, and Protection specializations"/>
```

#### **Step 5.2: Verify Version & Dependencies**
```xml
<!-- Keep these as-is (they're correct) -->
<attribute id="UUID" value="78fe4967-4e62-5491-d981-dd781acca4d7"/>
<attribute id="Type" value="Add-on"/>
<node id="ModuleShortDesc">
    <attribute id="Version64" value="144115196665790673"/> <!-- BG3 version -->
</node>
```

---

### **PHASE 6: UPDATE CLASSDESCRIPTIONS.LSX (15 minutes)**

**File:** `Data\Public\BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7\ClassDescriptions\ClassDescriptions.lsx`

#### **Step 6.1: Replace Class Names**

**For Base Class:**
```xml
<!-- BEFORE -->
<attribute id="Name" value="Warlock"/>
<attribute id="DisplayName" handle="[warlock_handle]"/>
<attribute id="Description" handle="[warlock_desc_handle]"/>

<!-- AFTER -->
<attribute id="Name" value="Warrior"/>
<attribute id="DisplayName" handle="h78fe4901"/>
<attribute id="Description" handle="h78fe4902"/>
```

#### **Step 6.2: Update Subclass Names**

**For 3 Subclasses:**
```xml
<!-- Subclass 1: Demonology → Arms -->
<attribute id="Name" value="WoWWarriorArms"/>
<attribute id="DisplayName" handle="h78fe4903"/>

<!-- Subclass 2: Destruction → Fury -->
<attribute id="Name" value="WoWWarriorFury"/>
<attribute id="DisplayName" handle="h78fe4904"/>

<!-- Subclass 3: Affliction → Protection -->
<attribute id="Name" value="WoWWarriorProtection"/>
<attribute id="DisplayName" handle="h78fe4905"/>
```

#### **Step 6.3: Update Key Attributes**

```xml
<!-- Base Class Attributes -->
<attribute id="SpellCastingAbility" value="Strength"/>  <!-- Was Charisma -->
<attribute id="PrimaryAbility" value="Strength"/>  <!-- Was Charisma -->
<attribute id="BaseHp" value="12"/>  <!-- Was 8 (warriors tankier) -->
<attribute id="HpPerLevel" value="7"/>  <!-- Was 5 -->
<attribute id="CanLearnSpells" value="False"/>  <!-- Was True (no spellbook) -->
<attribute id="MustPrepareSpells" value="False"/>  <!-- Warriors don't prepare -->
```

**KEEP THESE AS-IS (Working UUIDs):**
```xml
<attribute id="UUID" value="[whatever Warlock's base class UUID is]"/>
<attribute id="ProgressionTableUUID" value="[progression UUID]"/>
```

---

### **PHASE 7: REPLACE STAT FILES (10 minutes)**

**Strategy:** Keep Warlock's file structure, replace content with our Warrior abilities.

#### **Step 7.1: Restore Our Warrior Stat Files**

```powershell
# Delete Warlock stat files
Remove-Item "Data\Public\BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7\Stats\Generated\Data\*" -Force

# Copy our Warrior stat files back
Copy-Item "$statsBackup\*" `
    "Data\Public\BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7\Stats\Generated\Data\" -Force

Write-Host "✅ Restored our Warrior stat files"
```

**Files We're Keeping (Ours):**
- Passive.txt (36 entries)
- Spell_Target.txt (30 entries)
- Spell_Zone.txt (6 entries)
- Spell_Shout.txt (3 entries)
- Spell_Jump.txt (2 entries)
- Spell_Projectile.txt (2 entries)
- Status_BOOST.txt (56 entries)

**Files We DON'T Need (Warlock-specific):**
- Character.txt (demon definitions)
- Interrupt.txt (spell locks)
- Status_EFFECT.txt (warlock effects)
- Object.txt (summoned objects)

---

### **PHASE 8: UPDATE ACTIONRESOURCEDEFINITIONS (10 minutes)**

**File:** `Data\Public\BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7\ActionResourceDefinitions\ActionResourceDefinitions.lsx`

#### **Step 8.1: Delete Warlock Resources, Add Rage**

Warlock has 10 resources (Soul Shards, Demonic Core, etc.).  
Warrior needs 1 resource (Rage).

**Delete all Warlock `<node id="ActionResourceDefinition">` blocks.**

**Add our Rage resource:**
```xml
<node id="ActionResourceDefinition">
    <attribute id="Description" type="TranslatedString" handle="h78fe4910" version="1"/>
    <attribute id="DisplayName" type="TranslatedString" handle="h78fe4911" version="1"/>
    <attribute id="IsSpellResource" type="bool" value="True"/>
    <attribute id="MaxValue" type="uint32" value="100"/>
    <attribute id="Name" type="FixedString" value="Rage"/>
    <attribute id="PartyActionResource" type="bool" value="False"/>
    <attribute id="ReplenishType" type="ResourceReplenishType" value="Never"/>
    <attribute id="ShowOnActionResourcePanel" type="bool" value="True"/>
    <attribute id="UUID" type="guid" value="[generate new UUID or use existing]"/>
</node>
```

---

### **PHASE 9: CLEAN UP PROGRESSIONS.LSX (30 minutes)**

**File:** `Data\Public\BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7\Progressions\Progressions.lsx`

**Strategy:** Keep Warlock's structure (it works!), replace ability grants with our Warrior abilities.

#### **Step 9.1: Update Level 1 Base Class**

**Find the Level 1 Progression node, change:**
```xml
<!-- BEFORE (Warlock) -->
<attribute id="PassivesAdded" value="UnlockSoulShards;WarlockSpellcasting"/>
<attribute id="AddSpells" value="Shout_SoulShard;Target_EldritchBlast"/>

<!-- AFTER (Warrior) -->
<attribute id="PassivesAdded" value="WAR_UnlockRage;WAR_RageGeneration"/>
<attribute id="AddSpells" value="Target_WAR_Charge;Target_WAR_HeroicStrike"/>
```

#### **Step 9.2: Update All Progressions Systematically**

**For each Level 2-12:**
- Replace Warlock ability names with Warrior ability names
- Use the correct prefixes (Target_, Shout_, Zone_, Jump_)
- Reference abilities that EXIST in our stat files

**Example Level 2:**
```xml
<!-- BEFORE -->
<attribute id="AddSpells" value="Target_Shadowbolt"/>

<!-- AFTER -->
<attribute id="AddSpells" value="Shout_WAR_BattleShout"/>
```

#### **Step 9.3: Update Subclass Progressions**

**Arms (replace Demonology):**
```xml
<attribute id="Name" value="WoWWarriorArms"/>
<attribute id="AddSpells" value="Target_WAR_ARMS_MortalStrike;Target_WAR_ARMS_Overpower"/>
```

**Fury (replace Destruction):**
```xml
<attribute id="Name" value="WoWWarriorFury"/>
<attribute id="AddSpells" value="Target_WAR_Bloodthirst;Target_WAR_Rampage"/>
```

**Protection (replace Affliction):**
```xml
<attribute id="Name" value="WoWWarriorProtection"/>
<attribute id="AddSpells" value="Target_WAR_ShieldSlam;Target_WAR_Taunt"/>
```

---

### **PHASE 10: UPDATE LISTS/ FOLDER (20 minutes)**

**Files:** 
- `Lists/SpellLists.lsx`
- `Lists/PassiveLists.lsx`
- `Lists/SkillLists.lsx`
- `Lists/AbilityLists.lsx`

**Strategy:** Keep Warlock's 105 list entries structure, update UUIDs and references.

#### **Step 10.1: SpellLists.lsx**

Warlock has 53 spell lists. We need to:
1. Keep the structure (list nodes with UUIDs)
2. Update spell names to reference our Warrior spells
3. Keep UUIDs (Progressions reference these)

**Example:**
```xml
<!-- Warlock Row 1 Spell List -->
<node id="SpellList">
    <attribute id="Spells" value="Shout_DemonArmor;Shout_FelArmor"/>
    <attribute id="UUID" value="[some-uuid]"/>
</node>

<!-- Change to Warrior Row 1 Spell List -->
<node id="SpellList">
    <attribute id="Spells" value="Shout_WAR_BattleShout;Shout_WAR_CommandingShout"/>
    <attribute id="UUID" value="[same-uuid]"/>  <!-- DON'T CHANGE UUID! -->
</node>
```

#### **Step 10.2: PassiveLists.lsx**

Warlock has 52 passive lists (talent rows). Same strategy:
1. Keep structure and UUIDs
2. Replace Warlock passive names with Warrior passive names

**Example:**
```xml
<!-- Warlock Talent Row -->
<node id="PassiveList">
    <attribute id="Passives" value="WL_BurningRush;WL_FelDomination;WL_ConjureHealthstone"/>
    <attribute id="UUID" value="[some-uuid]"/>
</node>

<!-- Change to Warrior Talent Row -->
<node id="PassiveList">
    <attribute id="Passives" value="WAR_ImprovedCharge;WAR_DoubleTime;WAR_Warbringer"/>
    <attribute id="UUID" value="[same-uuid]"/>
</node>
```

---

### **PHASE 11: UPDATE LOCALIZATION (15 minutes)**

**File:** `Data\Public\BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7\Localization\English\English.loca.xml`

#### **Step 11.1: Replace All Localization Strings**

```xml
<!-- BEFORE (Warlock) -->
<content contentuid="h[warlock_handle]">Warlock</content>
<content contentuid="h[warlock_desc]">A wielder of dark magic...</content>

<!-- AFTER (Warrior) -->
<content contentuid="h78fe4901">Warrior</content>
<content contentuid="h78fe4902">A master of melee combat and Rage...</content>
```

#### **Step 11.2: Add Strings for All Warrior Abilities**

Use our existing localization handles (we already have these!).

---

### **PHASE 12: DELETE UNNECESSARY FILES (5 minutes)**

**Files to Delete (Warlock-specific, not needed for Warrior):**

```powershell
# Remove RootTemplates (140 demon templates)
Remove-Item "Data\Public\BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7\RootTemplates" -Recurse -Force

# Remove GUI customizations (optional)
Remove-Item "Data\Public\BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7\GUI" -Recurse -Force

# Remove custom Assets (optional)
Remove-Item "Data\Public\BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7\Assets" -Recurse -Force

# Remove Content visuals
Remove-Item "Data\Public\BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7\Content" -Recurse -Force

Write-Host "✅ Removed Warlock-specific files"
```

**Keep These (We Need Them):**
- ActionResourceDefinitions/
- ClassDescriptions/
- Progressions/
- Lists/
- Stats/Generated/Data/
- Localization/
- meta.lsx

---

### **PHASE 13: PACKAGE & TEST (5 minutes)**

```powershell
# Package the templated mod
$sourcePath = (Resolve-Path "Data").Path
$destPath = Join-Path (Get-Location) "Package\BG3Wow_FROM_WARLOCK_TEMPLATE.pak"

& "LsLib\Tools\Divine.exe" -g bg3 -a create-package -s $sourcePath -d $destPath -c lz4

# Copy to game
Copy-Item $destPath "$env:LOCALAPPDATA\Larian Studios\Baldur's Gate 3\Mods\" -Force

Write-Host "✅ Package created and installed"
```

---

## 📊 TIME ESTIMATES

| Phase | Task | Time | Difficulty |
|-------|------|------|------------|
| 1 | Backup current mod | 5 min | Easy |
| 2 | Copy Warlock template | 2 min | Easy |
| 3 | Rename folders | 3 min | Easy |
| 4 | Global find/replace UUIDs | 10 min | Easy |
| 5 | Update meta.lsx | 5 min | Easy |
| 6 | Update ClassDescriptions | 15 min | Medium |
| 7 | Replace stat files | 10 min | Easy |
| 8 | Update ActionResourceDefinitions | 10 min | Medium |
| 9 | Clean up Progressions | 30 min | Hard |
| 10 | Update Lists/ folder | 20 min | Medium |
| 11 | Update Localization | 15 min | Medium |
| 12 | Delete unnecessary files | 5 min | Easy |
| 13 | Package & test | 5 min | Easy |
| **TOTAL** | | **2.5 hours** | |

---

## 🎯 SUCCESS CRITERIA

### **Milestone 1: Structure Works**
✅ Mod appears in BG3 Mod Manager  
✅ No errors enabling mod  
✅ Warrior class appears in character creation  

### **Milestone 2: Character Creation Works**
✅ Can select Warrior class  
✅ Can choose subclass (Arms/Fury/Protection)  
✅ Character creation completes  
✅ No crash  

### **Milestone 3: Gameplay Works**
✅ Character loads into game  
✅ Has abilities (however many we've implemented)  
✅ Rage resource displays  
✅ Can use abilities  
✅ Can level up  

---

## 🛡️ SAFETY MEASURES

### **Multiple Backups:**
1. ✅ Full mod backup in `Tests/WARRIOR_BACKUP_BEFORE_TEMPLATE_[timestamp]`
2. ✅ Stat files backup in `Tests/WARRIOR_STATS_BACKUP_[timestamp]`
3. ✅ Can restore at any time

### **Incremental Testing:**
- Test after each major phase
- Don't proceed if previous phase fails
- Can roll back to any checkpoint

### **Version Control:**
- Package each successful milestone
- Name packages clearly: `BG3Wow_TEMPLATE_PHASE_[N].pak`
- Keep working versions

---

## 🚀 AUTOMATION SCRIPT

I can create a PowerShell script that automates most of this:

**`apply_warlock_template.ps1`:**
- Backs up current mod
- Copies Warlock structure
- Performs global UUID replacements
- Renames folders
- Restores our stat files
- Cleans up Warlock-specific files

**Then you manually:**
- Update Progressions (ability grants)
- Update Lists (talent choices)
- Update localization strings

**Estimated time with automation:** 1.5 hours instead of 2.5 hours

---

## 📋 DECISION POINTS

### **Option A: Automated Setup + Manual Content (RECOMMENDED)**
**Time:** 1.5 hours  
**Pros:** Fast initial setup, careful ability mapping  
**Cons:** Still need manual work on Progressions/Lists  

### **Option B: Fully Manual (More Control)**
**Time:** 2.5 hours  
**Pros:** Understand every change  
**Cons:** More tedious, error-prone  

### **Option C: Hybrid (Automate Structure, Import Our Progressions)**
**Time:** 1 hour  
**Pros:** Fastest, keeps our Progressions work  
**Cons:** Might still have naming mismatches  

---

## 🎯 RECOMMENDED APPROACH

**I recommend Option A with this workflow:**

1. **Run automation script** (15 minutes)
   - Backup everything
   - Copy Warlock structure
   - Replace UUIDs globally
   - Restore our stat files

2. **Manual cleanup** (1 hour)
   - Update Progressions.lsx (replace Warlock abilities with ours)
   - Update Lists/ folder (talent choices)
   - Update ClassDescriptions (Warrior attributes)
   - Update localization strings

3. **Test** (15 minutes)
   - Package mod
   - Test in-game
   - Verify character creation works

4. **Polish** (15 minutes)
   - Fix any issues found
   - Re-test
   - Final package

**Total: 1.5-2 hours to working Warrior mod using proven structure**

---

## ✅ READY TO PROCEED?

**Say "yes" and I'll:**
1. Create the automation script
2. Run the backup
3. Copy Warlock template
4. Perform global replacements
5. Create testing checkpoints
6. Guide you through manual content updates

**This will give you a 99% working mod structure, then we just need to map Warrior abilities to the working skeleton!**

---

**Status:** PLAN READY ✅  
**Risk Level:** Low (everything backed up, using proven structure)  
**Success Probability:** 99% (Warlock structure is known working)

