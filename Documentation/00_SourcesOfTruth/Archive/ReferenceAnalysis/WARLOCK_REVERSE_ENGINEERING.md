# WoW Warlock Mod - Complete Reverse Engineering Report

**Mod UUID**: `bdb3fa73-401b-4979-f02e-485422dd8d9c`  
**Location**: `Tests/02_ExampleMods/ExampleMod_WoWWarlock`

---

## 📁 FILE STRUCTURE ANALYSIS

### Core Files (REQUIRED):
1. ✅ `Mods/Warlock_WoW_.../meta.lsx` - Mod metadata
2. ✅ `Public/.../ClassDescriptions/ClassDescriptions.lsx` - Class definitions
3. ✅ `Public/.../Progressions/Progressions.lsx` - Level progression
4. ✅ `Public/.../Progressions/ProgressionDescriptions.lsx` - Localization
5. ✅ `Public/.../ActionResourceDefinitions/ActionResourceDefinitions.lsx` - Soul Shards resource
6. ✅ `Public/.../CharacterCreationPresets/AbilityDistributionPresets.lsx` - Ability presets

### Lists Files:
7. ✅ `Public/.../Lists/SkillLists.lsx` - Available skills for character creation
8. ✅ `Public/.../Lists/AbilityLists.lsx` - Ability score options
9. ✅ `Public/.../Lists/PassiveLists.lsx` - Passive ability lists
10. ✅ `Public/.../Lists/SpellLists.lsx` - Spell lists for progression

### Stats Files (Abilities):
11. ✅ `Stats/Generated/Data/Spell_Target.txt` - Single-target spells
12. ✅ `Stats/Generated/Data/Spell_Projectile.txt` - Projectile spells
13. ✅ `Stats/Generated/Data/Spell_Shout.txt` - AoE/buff spells
14. ✅ `Stats/Generated/Data/Spell_Zone.txt` - Ground-targeted AoE
15. ✅ `Stats/Generated/Data/Passive.txt` - Passive abilities
16. ✅ `Stats/Generated/Data/Status_BOOST.txt` - Buffs/debuffs
17. ✅ `Stats/Generated/Data/Character.txt` - Character stats/summons
18. ✅ `Stats/Generated/Data/Interrupt.txt` - Interrupt abilities

### Optional Files:
19. ✅ `Public/.../GUI/*.lsx` - Custom UI icons (3 files)
20. ✅ `Public/.../Levelmaps/LevelMapValues.lsx` - Level scaling
21. ✅ `Public/.../RootTemplates/*.lsf` - Summon templates (pets/demons)

### Files NOT Present in Warlock (but we have):
- ❌ DefaultValues folder - Not used by Warlock mod

---

## 🔍 ANALYZING KEY FILES

### 1. meta.lsx Analysis

Reading file...
