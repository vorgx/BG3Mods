# Localization Entries Needed for Sunder Armor
**Total Handles Required**: 8 (h125abc121-128)

---

## ENGLISH.LOCA.XML ENTRIES

Add these entries to your English.loca.xml file:

```xml
<?xml version="1.0" encoding="utf-8"?>
<contentList>
    
    <!-- ========================================
         SUNDER ARMOR - Spell Entries
         ========================================
    -->
    
    <!-- Spell DisplayName -->
    <content contentuid="h125abc121" version="1">Sunder Armor</content>
    
    <!-- Spell Description (4 parameters: damage, rage, ac_reduction, max_stacks) -->
    <content contentuid="h125abc122" version="4">Strike at enemy armor, weakening their defenses.

Deal [1] damage and generate [2] Rage.
Reduce target's AC by -[3] for 5 turns (stacks up to [4] times).

Bonus Action • Melee Weapon Attack

Tags: Generator, Single-Target, Armor Reduction</content>
    
    
    <!-- ========================================
         WAR_SUNDERATTACK_ARMOR - Status Entries
         ========================================
    -->
    
    <!-- Status DisplayName -->
    <content contentuid="h125abc123" version="1">Sundered Armor</content>
    
    <!-- Status Description (2 parameters: ac_per_stack, max_stacks) -->
    <content contentuid="h125abc124" version="2">Armor weakened by Sunder Armor attacks.

-[1] AC per stack. Stacks up to [2] times.</content>
    
    
    <!-- ========================================
         WAR_SUNDER_ARMOR_RAGE - Trigger Entries
         ========================================
    -->
    
    <!-- Rage Trigger DisplayName -->
    <content contentuid="h125abc127" version="1">Sunder Armor: Rage</content>
    
    <!-- Rage Trigger Description -->
    <content contentuid="h125abc128" version="1">Generating Rage from Sunder Armor.</content>
    
</contentList>
```

---

## PARAMETER MAPPING

### Sunder Armor Spell (h125abc122)
```
data "DescriptionParams" "DealDamage(1d6+StrengthModifier,MainMeleeWeaponDamageType);15;1;3"
```

**Parameters**:
- `[1]` = `DealDamage(1d6+StrengthModifier,MainMeleeWeaponDamageType)` → "1d6 + STR damage"
- `[2]` = `15` → "15 Rage"
- `[3]` = `1` → "1 AC reduction per stack"
- `[4]` = `3` → "3 max stacks"

**In-Game Display**:
> Strike at enemy armor, weakening their defenses.
>
> Deal **1d6 + STR** damage and generate **15** Rage.
> Reduce target's AC by **-1** for 5 turns (stacks up to **3** times).
>
> Bonus Action • Melee Weapon Attack
>
> Tags: Generator, Single-Target, Armor Reduction

---

### Sundered Armor Status (h125abc124)
```
data "DescriptionParams" "1;3"
```

**Parameters**:
- `[1]` = `1` → "1 AC per stack"
- `[2]` = `3` → "3 max stacks"

**In-Game Display**:
> Armor weakened by Sunder Armor attacks.
>
> **-1** AC per stack. Stacks up to **2** times.

---

## FILE LOCATION

Create or update this file:
```
c:\Users\tenod\source\repos\BG3Mods\Data\Public\BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7\Localization\English\English.loca.xml
```

**Note**: This file likely doesn't exist yet. You'll need to create the full English.loca.xml with proper XML structure and all ~300 warrior ability entries.

---

## VERIFICATION

After adding entries, verify:
1. All 8 handles present (h125abc121-128)
2. Version numbers match (version="1" or version="4")
3. XML syntax is valid (no unclosed tags)
4. Parameters match DescriptionParams in stat files
5. In-game tooltips display correctly

---

## ALTERNATIVE: Quick Test Without Localization

If you want to test Sunder Armor immediately without creating English.loca.xml:

**The game will display**:
- Ability name: `h125abc121;1` (handle visible)
- Description: `h125abc122;4` (handle visible)
- Status: `h125abc123;1` (handle visible)

**But mechanics will work**:
- Damage: 1d6 + STR ✅
- Rage generation: +15 ✅
- AC reduction: -1 per stack ✅
- Stacking: Up to 3 ✅

You can verify the gameplay mechanics work before spending time on localization.

---

## NEXT LOCALIZATION FILES

After Sunder Armor, you'll need entries for:
- All 19 baseline warrior abilities (h125abc01-h125abc120 range)
- All 10 Arms warrior abilities
- All 8 Fury warrior abilities (not yet implemented)
- All 9 Protection warrior abilities (not yet implemented)

**Estimated Total**: ~300+ localization entries
