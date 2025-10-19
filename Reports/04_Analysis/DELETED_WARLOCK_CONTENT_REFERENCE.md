# Deleted Warlock Content Reference

**Created**: October 18, 2025  
**Purpose**: Document Warlock mod content deleted during Phase 2 transformation  
**Context**: This content was removed as it's specific to Warlock (demon summons, soul shards, etc.) but patterns documented here can be referenced for future Warrior features

---

## Summary

The following Warlock-specific content was deleted from our Warrior mod template:

- **RootTemplates/**: 140 .lsf files (640.95 KB) - Demon character templates
- **Content/**: 16 files (29.69 KB) - Visual effects for Warlock spells
- **GUI/**: 4 files (79.09 KB) - Custom UI elements
- **Assets/**: 4 files (1198.04 KB) - Textures and visual assets

**Total deleted**: 164 files (~1.9 MB)

---

## 1. RootTemplates/ - Demon Summon System (140 files)

### Purpose
Contains character templates for all Warlock demons (Imps, Felstalkers, Voidwalkers, Infernals, etc.). Each demon has a `.lsf` binary file defining its appearance, animations, and visual properties.

### Pattern for Warriors
**Warriors don't summon creatures**, so these files are unnecessary. However, the pattern could be useful if we ever want to:
- Add companion NPCs (e.g., Warrior trainers)
- Create special visual effects that require character templates
- Implement temporary summons (e.g., "Ancestral Guardian" visual effect)

### File Structure
- All files are `.lsf` (binary format, not human-readable)
- 140 templates total (various demon types and variants)
- Each template UUID corresponds to entries in `Stats/Generated/Data/Character.txt` (which we don't have in our stat files)

### Example UUIDs (First 10)
```
0103daf5-6edb-49d5-acf1-b904b5799021.lsf
05129e44-718c-4da3-9da6-6924373071e8.lsf
0665e2b6-5b76-4480-8427-9c9d28dc8c4d.lsf
06f1e95b-f7d3-4053-848c-f34d30862ee3.lsf
072405c2-9f54-434a-b76d-ae3a07358931.lsf
08c5c7c8-b3d6-4e4c-aa47-e28dd3090fa0.lsf
0b2881c7-3863-4cd9-be4c-8c0bceb47164.lsf
0b53c064-c081-4cbc-8065-6f06fb31fbc7.lsf
0c4f41e3-dd8c-4f84-a983-10d68e0eb043.lsf
0d512f32-30d9-49d8-814f-a81832c4619d.lsf
```

### If Needed Later
To recreate demon summon functionality:
1. Create `Character.txt` entries in `Stats/Generated/Data/`
2. Add RootTemplate `.lsf` files with matching UUIDs
3. Create summon spells that reference the Character entries
4. Add spawn visual effects in `Content/`

---

## 2. Content/ - Visual Effects (16 files)

### Purpose
Contains custom visual effects (VFX) for Warlock spells:
- Soul fire effects
- Demon summoning portals
- Fel energy particles
- Shadow bolt projectiles
- Affliction DoT visuals

### Pattern for Warriors
Warriors could use similar custom VFX for:
- **Charge/Heroic Leap**: Custom leap trails, impact effects
- **Whirlwind**: Spinning blade effects
- **Thunder Clap**: Shockwave visual
- **Avatar**: Transformation glow effect
- **Rage effects**: Red aura when high Rage

### File Types
- `.lsf` files (binary visual effect definitions)
- `.fx` files (shader effects - if present)
- Particle system definitions

### Size
29.69 KB (16 files total)

### If Needed Later
To add custom VFX:
1. Create effect files in `Content/[Effect]Materials/` or `Content/[Effect]Resources/`
2. Reference effect UUIDs in spell entries via:
   - `data "PrepareEffect"` (casting animation start)
   - `data "CastEffect"` (spell launch visual)
   - `data "TargetEffect"` (impact on target)
3. Can reuse BG3's existing VFX or create custom ones

---

## 3. GUI/ - Custom UI Elements (4 files)

### Purpose
Custom user interface elements for Warlock:
- Soul Shard counter display
- Demon summon buttons
- Warlock-specific ability icons (if any)
- Custom frames/borders

### Pattern for Warriors
Potential Warrior UI customization:
- **Rage bar**: Custom visual appearance
- **Stance indicators**: Arms/Fury/Protection visual markers
- **Cooldown displays**: Custom icons for major abilities
- **Combat state**: In/out of combat indicators

### File Types
- `.dds` texture files for UI elements
- `.lsx` UI layout definitions (if present)
- Icon atlases

### Size
79.09 KB (4 files total)

### If Needed Later
To add custom UI:
1. Create UI texture files (`.dds` format)
2. Add UI definitions in `GUI/` folder
3. Reference in appropriate game files
4. May require Script Extender for advanced UI modifications

**Note**: Basic Rage bar already works via `ActionResourceDefinitions.lsx` - no custom UI needed for core functionality

---

## 4. Assets/ - Textures & Visual Assets (4 files)

### Purpose
Custom textures and visual assets:
- Demon skin textures
- Spell effect textures
- Custom ability icons
- Material definitions

### Pattern for Warriors
Potential uses:
- **Custom ability icons**: Unique icons for Warrior abilities
- **Armor textures**: Custom Warrior-themed armor visuals
- **Weapon effects**: Glowing weapons during Avatar/Recklessness
- **Class identity**: Visual customization to distinguish Warriors

### File Types
- `.dds` texture files (DirectDraw Surface)
- Likely includes normal maps, diffuse maps, specular maps
- Icon atlases

### Size
1198.04 KB (4 files total) - Largest category

### If Needed Later
To add custom textures:
1. Create `.dds` texture files (use tools like GIMP or Photoshop)
2. Place in `Assets/` folder with appropriate naming
3. Reference in material definitions or spell effects
4. Test in-game to ensure textures load correctly

---

## Key Warlock Patterns to Remember

### 1. Demon Summon Pattern
```
Spell Entry (Spell_Target.txt):
- Summons a character template
- References Character.txt entry
- Character.txt defines demon stats
- RootTemplate .lsf defines demon appearance
```

**Warrior Equivalent**: We don't summon, but pattern useful for temporary NPCs or visual effects

### 2. Soul Shard Resource System
```
ActionResourceDefinitions.lsx:
- Defines Soul Shards resource (0-5 shards)
- Spells cost/generate shards
- UI displays shard count
```

**Warrior Equivalent**: **Already implemented!** We use Rage (0-100) instead of Soul Shards (0-5)

### 3. DoT (Damage-over-Time) Pattern
Warlock Affliction spec uses many DoT effects. Pattern:
```
Status_BOOST.txt:
- StatusType "BOOST"
- TickType "StartTurn" or "EndTurn"
- StackId (for multiple DoTs)
- OnApply/OnTick damage formulas
```

**Warrior Equivalent**: 
- **Rend**: Bleed DoT (already implemented in `Status_BOOST.txt`)
- **Deep Wounds**: Passive bleed effect (already implemented)

### 4. Talent Row System
Warlock uses `SelectPassives()` for player choice:
```
Progressions.lsx:
<node id="Progression">
    <attribute id="Level" value="3"/>
    <children>
        <node id="SubClasses">
            <children>
                <node id="SubClass">
                    <attribute id="Boosts" value="SelectPassives(UUID,1,TalentRow1)"/>
                </node>
            </children>
        </node>
    </children>
</node>
```

**Warrior Equivalent**: We'll use this pattern in Phase 3 for Arms talent choices

---

## Files Preserved (NOT Deleted)

The following Warlock structure is **preserved** because it's core to BG3's class system:

✅ **ActionResourceDefinitions/** - Required (we'll modify for Rage)  
✅ **CharacterCreationPresets/** - Required for character creation  
✅ **ClassDescriptions/** - Required (we'll modify for Warrior)  
✅ **Levelmaps/** - Unknown purpose, keep for safety  
✅ **Lists/** - **Critical** - Contains SpellLists and PassiveLists (105 entries to transform in Phase 3)  
✅ **MultiEffectInfos/** - Unknown purpose, keep for safety  
✅ **Progressions/** - **Critical** - Level progression tables (will transform in Phase 5)  
✅ **Stats/** - **Already replaced** with our 7 Warrior stat files (135 entries)  

---

## Deletion Summary

**Phase 2 Action**: Delete 164 Warlock-specific files (1.9 MB)

**Rationale**:
- Warriors don't summon demons (no need for RootTemplates)
- Warriors don't need Warlock VFX (we'll use BG3's existing effects)
- Warriors don't need custom UI (Rage bar works with default UI)
- Warriors don't need Warlock textures (we'll use BG3's existing assets)

**Risk**: None - all deleted content is Warlock-specific, not required for class functionality

**Benefit**: Clean mod structure, easier to debug, smaller file size

**Future Reference**: This document preserved all patterns and folder structures for future feature development

---

## Next Steps After Deletion

1. ✅ **Phase 2**: Delete folders (current)
2. **Phase 3**: Transform Lists/ folder (105 entries - SpellLists and PassiveLists)
3. **Phase 4**: Add missing fields to our 135 stat entries
4. **Phase 5**: Transform Progressions.lsx (L1-L20)
5. **Phase 6**: Update core files (meta, ClassDescriptions, ActionResourceDefinitions, Localization)
6. **Phase 7**: Package and test

---

**End of Reference Document**
