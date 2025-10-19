# File-by-File Transformation Plan

**Created**: October 18, 2025  
**Strategy**: Systematic file-by-file transformation of WoWWarlock → WoWWarrior  
**Goal**: L1-20 progression, 3 subclasses (Arms full, Fury/Protection L2 placeholders), all spells/talents

---

## Current State

✅ **Data folder cleaned and WoWWarlock template copied**

**Warlock Mod UUID**: `bdb3fa73-401b-4979-f02e-485422dd8d9c`  
**Warrior Mod UUID**: `78fe4967-4e62-5491-d981-dd781acca4d7`

**Warrior Backup Location**: `Tests\WARRIOR_STATS_BACKUP_20251018_183829` (7 stat files, 135 entries)

---

## Critical Files Only (Core Functionality)

### Mods Folder (2 files)
1. `meta.lsx` - Mod metadata, name, version, dependencies, UUID

### Public Folder (8 critical files/folders)
2. `ClassDescriptions/ClassDescriptions.lsx` - Class definition (name, HP, abilities, subclasses)
3. `Progressions/Progressions.lsx` - Level progression (L1-L20, grants spells/passives per level)
4. `ActionResourceDefinitions/ActionResourceDefinitions.lsx` - Resource system (Rage vs Soul Shards)
5. `Stats/Generated/Data/*.txt` - **7 files** with ability definitions (135 entries)
6. `Lists/SpellLists.lsx` - Spell grant lists (referenced by Progressions)
7. `Lists/PassiveLists.lsx` - Passive grant lists (talent rows)
8. `CharacterCreationPresets/CharacterCreationPresets.lsx` - Character creation options
9. `Localization/English/English.loca.xml` - All user-facing text

### Non-Critical (Skip for Now)
- `RootTemplates/` - 140 demon visual files (Warriors don't summon)
- `Content/` - VFX files (use BG3 defaults)
- `GUI/` - UI customization (optional)
- `Assets/` - Textures (optional)
- `Levelmaps/` - Unknown (keep as-is)
- `MultiEffectInfos/` - Unknown (keep as-is)
- `Lists/AbilityLists.lsx` - Empty
- `Lists/SkillLists.lsx` - Empty

---

## File-by-File Transformation Order

### PRIORITY 1: Foundation Files (Identity & Structure)

#### **FILE 1: meta.lsx** ⭐ START HERE
**Location**: `Data/Mods/Warlock_WoW_bdb3fa73-401b-4979-f02e-485422dd8d9c/meta.lsx`

**What It Controls**:
- Mod name, author, description
- Mod UUID (critical!)
- Folder references
- Version number
- Dependencies

**Transformation**:
1. Change UUID: `bdb3fa73-401b-4979-f02e-485422dd8d9c` → `78fe4967-4e62-5491-d981-dd781acca4d7`
2. Change Name: "WoWWarlock" → "BG3Wow" or "WoWWarrior"
3. Change Folder: `Warlock_WoW_*` → `BG3Wow_*`
4. Update Description: Warlock → Warrior
5. Update Author if desired

**Warrior Backup**: `Tests\WARRIOR_BACKUP_BEFORE_TEMPLATE_20251018_183829\Mods\BG3Wow_*/meta.lsx`

---

#### **FILE 2: ClassDescriptions.lsx** ⭐ CRITICAL
**Location**: `Data/Public/Warlock_WoW_*/ClassDescriptions/ClassDescriptions.lsx`

**What It Controls**:
- Class name ("Warlock" → "Warrior")
- Base HP (8 → 12)
- HP per level (5 → 7)
- Primary ability (Charisma → Strength)
- Armor proficiencies (light → heavy)
- Weapon proficiencies
- Subclass names (Demonology → Arms, etc.)
- Subclass descriptions
- CanLearnSpells (True → False)

**Transformation**:
1. Change ClassName: "Warlock" → "Warrior"
2. Change BaseHp: 8 → 12
3. Change HpPerLevel: 5 → 7
4. Change SpellCastingAbility: "Charisma" → "Strength"
5. Change CanLearnSpells: "True" → "False"
6. Update 3 subclass entries:
   - Demonology → Arms
   - Destruction → Fury
   - Affliction → Protection
7. Update all localization handles

**Warrior Backup**: `Tests\WARRIOR_BACKUP_*/Public/BG3Wow_*/ClassDescriptions/ClassDescriptions.lsx`

---

### PRIORITY 2: Resource System

#### **FILE 3: ActionResourceDefinitions.lsx**
**Location**: `Data/Public/Warlock_WoW_*/ActionResourceDefinitions/ActionResourceDefinitions.lsx`

**What It Controls**:
- Resource types (Soul Shards → Rage)
- Resource max values (5 shards → 100 rage)
- Resource display

**Transformation**:
1. Delete all 10 Warlock resources:
   - Soul Shards (5 variants)
   - Demonic Core
   - Backdraft
   - Havoc
   - Immolate
   - Chaos Bolt
2. Add 1 Warrior resource:
   - Rage (0-100)

**Warrior Backup**: `Tests\WARRIOR_BACKUP_*/Public/BG3Wow_*/ActionResourceDefinitions/ActionResourceDefinitions.lsx`

---

### PRIORITY 3: Ability Definitions (The Meat)

#### **FILE 4-10: Stats/Generated/Data/*.txt** (7 files)
**Location**: `Data/Public/Warlock_WoW_*/Stats/Generated/Data/`

**Files**:
4. `Passive.txt` - Passive abilities (36 Warrior entries)
5. `Spell_Target.txt` - Single-target spells (30 Warrior entries)
6. `Spell_Zone.txt` - AoE spells (6 Warrior entries)
7. `Spell_Shout.txt` - Self-buffs (3 Warrior entries)
8. `Spell_Jump.txt` - Gap closers (2 Warrior entries)
9. `Spell_Projectile.txt` - Ranged attacks (2 Warrior entries)
10. `Status_BOOST.txt` - Buffs/debuffs (56 Warrior entries)

**What They Control**:
- All ability definitions (damage, costs, effects, cooldowns)
- Passive ability mechanics
- Status effect definitions

**Transformation**:
1. **REPLACE ENTIRELY** with Warrior backup files
2. No merging needed - Warlock spells are irrelevant
3. Verify all WAR_* entries present
4. Check for missing fields (from autopsy lessons)

**Warrior Backup**: `Tests\WARRIOR_STATS_BACKUP_20251018_183829/*.txt`

**Autopsy Lessons**:
- Add visual effects (PrepareEffect, CastEffect, TargetEffect)
- Add tooltips (TooltipDamageList, TooltipAttackSave)
- Add animations (SpellAnimation)
- Add flags (SpellFlags, VerbalIntent)
- Follow Warlock format for missing fields

---

### PRIORITY 4: Progression System

#### **FILE 11: Progressions.lsx** ⭐ MOST COMPLEX
**Location**: `Data/Public/Warlock_WoW_*/Progressions/Progressions.lsx`

**What It Controls**:
- Level 1-20 progression
- Spells granted per level
- Passives granted per level
- Subclass progression (3 subclasses × L1-L12)
- Talent row selections (if used)

**Transformation Strategy**:
1. **Base Class (L1-L12)**:
   - Keep structure, replace spell/passive references
   - Replace Warlock spells with Warrior spells
   - Update SelectPassives references (if keeping talent rows)

2. **Base Class (L13-L20) - EXTEND**:
   - Add new levels 13-20 (Warlock only goes to L12)
   - Add hero talent passives (hardcoded)
   - Mountain Thane, Colossus, Slayer keystones/choices

3. **Subclasses**:
   - **Arms**: Full L1-L20 progression
   - **Fury**: L2 placeholder (basic ability grant)
   - **Protection**: L2 placeholder (basic ability grant)

**Warrior Backup**: `Tests\WARRIOR_BACKUP_*/Public/BG3Wow_*/Progressions/Progressions.lsx`

**Note**: This is the most complex file - will require detailed analysis

---

### PRIORITY 5: List References

#### **FILE 12: Lists/SpellLists.lsx**
**Location**: `Data/Public/Warlock_WoW_*/Lists/SpellLists.lsx`

**What It Controls**:
- Spell grant lists (referenced by Progressions via UUID)
- Example: `AddSpells(UUID)` in Progressions → SpellList with that UUID

**Transformation**:
1. Review which UUIDs Progressions references
2. Update those SpellLists with Warrior spells
3. Delete unmapped Warlock SpellLists
4. Keep UUIDs unchanged (Progressions already references them)

**Dependencies**: Must do AFTER Progressions analysis

---

#### **FILE 13: Lists/PassiveLists.lsx**
**Location**: `Data/Public/Warlock_WoW_*/Lists/PassiveLists.lsx`

**What It Controls**:
- Passive grant lists (talent rows)
- Referenced by `SelectPassives(UUID,amount,RowName)` in Progressions

**Transformation**:
1. Review which UUIDs Progressions references
2. Update PassiveLists with WAR_* passive names
3. Fix "WoWWarrior_*" → "WAR_*" prefix mismatch
4. Delete unmapped Warlock PassiveLists

**Critical Fix**: PassiveLists has "WoWWarrior_*" but our Passive.txt has "WAR_*"

---

### PRIORITY 6: Character Creation

#### **FILE 14: CharacterCreationPresets.lsx**
**Location**: `Data/Public/Warlock_WoW_*/CharacterCreationPresets/CharacterCreationPresets.lsx`

**What It Controls**:
- Character creation starting equipment
- Starting spells/cantrips
- Class appearance in character creator

**Transformation**:
1. Change class UUID reference
2. Update starting equipment (cloth → chainmail/plate)
3. Remove Warlock starting spells

**Warrior Backup**: May not have one - check backup

---

### PRIORITY 7: Localization

#### **FILE 15: Localization/English/English.loca.xml**
**Location**: `Data/Public/Warlock_WoW_*/Localization/English/English.loca.xml`

**What It Controls**:
- ALL user-facing text (names, descriptions, tooltips)
- Handle format: `h[8hex][2digit]` (e.g., `h125abc01`)

**Transformation**:
1. **REPLACE ENTIRELY** with Warrior localization
2. Ensure all WAR_* abilities have localization handles
3. Update class/subclass names

**Warrior Backup**: Check if exists in backup

---

## Transformation Workflow (Per File)

### Step 1: Analysis Phase
1. Open Warlock version of file
2. Open Warrior backup version (if exists)
3. Document differences
4. Identify what needs to change
5. Flag any missing content
6. Present analysis to user

### Step 2: Decision Phase
1. User reviews analysis
2. User approves transformation strategy
3. Clarify any questions

### Step 3: Transformation Phase
1. Apply changes to Warlock file
2. Verify syntax (XML validation)
3. Test locally if possible
4. Create checkpoint

### Step 4: Verification Phase
1. Check for errors
2. Verify all references valid
3. Document changes made
4. Move to next file

---

## Checkpoint System

After each file transformation:
- ✅ Create git commit (if using git)
- ✅ Create backup copy
- ✅ Document changes in transformation log
- ✅ Verify file loads without errors

After priority groups:
- ✅ Create .pak package
- ✅ Test in-game (optional checkpoint test)

---

## Estimated Timeline

| Priority | Files | Estimated Time | Complexity |
|----------|-------|----------------|------------|
| 1 | meta.lsx, ClassDescriptions.lsx | 30 min | Low |
| 2 | ActionResourceDefinitions.lsx | 15 min | Low |
| 3 | 7 Stat files | 2 hours | Medium |
| 4 | Progressions.lsx | 3 hours | **HIGH** |
| 5 | SpellLists.lsx, PassiveLists.lsx | 1.5 hours | Medium |
| 6 | CharacterCreationPresets.lsx | 15 min | Low |
| 7 | Localization | 30 min | Low |

**Total**: ~8 hours (spread across sessions)

---

## Success Criteria

After all files transformed:
- ✅ Mod packages without errors
- ✅ Class appears in character creation
- ✅ No missing UUID references
- ✅ No crashes on character creation
- ✅ Abilities display correct names/descriptions
- ✅ Level 1-20 progression works
- ✅ 3 subclasses selectable
- ✅ Rage resource displays

---

## Next Step

**Ready to begin FILE 1: meta.lsx?**

I will:
1. Read both Warlock and Warrior meta.lsx files
2. Present side-by-side comparison
3. Show proposed changes
4. Wait for your approval
5. Apply transformations

Say "proceed" when ready!
