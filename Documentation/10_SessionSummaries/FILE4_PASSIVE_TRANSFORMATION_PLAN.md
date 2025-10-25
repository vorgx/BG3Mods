# FILE 4: Passive.txt Transformation Plan

**Date**: October 24, 2025  
**File**: `Data/Public/Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7/Stats/Generated/Data/Passive.txt`  
**Status**: Planning Phase  
**Estimated Time**: 20-30 minutes

---

## 📊 Current State Analysis

### Warrior Backup (Source)
- **Location**: `Tests/04_Backups/.../Stats/Generated/Data/Passive.txt`
- **Lines**: 453 lines
- **Entries**: 36 passive entries (estimated from header comments: 33 hero talents + 3 class passives)
- **Structure**: Well-organized with comments, hero talent trees documented
- **Quality**: ✅ Already has StatsFunctorContext, Conditions, StatsFunctors (complex mechanics)

### Warlock Template (Reference)
- **Location**: `Data/Public/Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7/Stats/Generated/Data/Passive.txt`
- **Lines**: 2178 lines (much longer, includes all Warlock passives)
- **Structure**: Simpler passives (mostly UnlockSpell boosts)
- **Fields**: DisplayName, Description, DescriptionParams, Icon, Properties, Boosts, StatsFunctorContext

### Key Observations

1. **Warrior passives are MORE complete** than Warlock in terms of mechanics
2. **Warlock adds** `DescriptionParams` field (for tooltip variable substitution)
3. **Warrior already has** complex StatsFunctorContext/Conditions/StatsFunctors
4. **Missing fields in Warrior**: `DescriptionParams` (optional, for tooltips)
5. **Icon references**: Warrior uses generic BG3 icons, may need custom icons later

---

## 🎯 Transformation Strategy

### What We Need to Do

**Minimal changes needed** - Warrior passives are already well-structured!

1. **Keep all Warrior entries** (don't remove any)
2. **Add `DescriptionParams` where needed** (for dynamic tooltip values)
3. **Verify icon references** (ensure they exist or use placeholders)
4. **Add header comments** (mod metadata, total counts)
5. **Validate against AbilityDatabase** (confirm all 36 passives are in database)

### What We DON'T Need to Do

❌ **Don't add visual effects** (passives don't have PrepareEffect/CastEffect)  
❌ **Don't change mechanics** (StatsFunctors already correct)  
❌ **Don't reference Warlock animations** (passives have no animations)  
❌ **Don't change ability names** (already using WAR_* format)

---

## 📋 Step-by-Step Workflow

### Step 1: Read Full Warrior Backup
- Load complete Passive.txt from backup
- Count total entries
- Identify all 36 passive names

### Step 2: Cross-Reference with AbilityDatabase
- Query AbilityDatabase for `bg3_file_type = "Passive"`
- Confirm all 36 passives exist in database
- Check for missing passives (database has more than backup?)

### Step 3: Enhance Entries (If Needed)
For each passive:
- Add `DescriptionParams` if tooltip has dynamic values (e.g., "25% chance" → `DescriptionParams "25"`)
- Verify `Icon` reference exists (or flag for later icon creation)
- Add inline comments for complex StatsFunctors (for maintainability)

### Step 4: Write to Data Folder
- Replace Warlock Passive.txt with transformed Warrior Passive.txt
- Preserve file structure (comments, blank lines for readability)
- Add transformation metadata header

### Step 5: Validation
- Verify XML-like syntax (proper quotes, semicolons)
- Check all WAR_* references match database ability_id
- Confirm no duplicate entry names
- Test syntax with BG3 Script Extender (if possible)

---

## 📊 Expected Entries (From Backup Header)

### Hero Talents (33 total)
- **Mountain Thane**: 11 passives (keystone + 9 tiers + capstone)
- **Colossus**: 11 passives (keystone + 9 tiers + capstone)
- **Slayer**: 11 passives (keystone + 9 tiers + capstone)

### Class Passives (3 estimated)
- TBD based on full file read

### Total: 36 passives

---

## 🔍 Sample Entry Comparison

### Current Warrior Entry (Already Good!)
```
new entry "WAR_MountainThane_Keystone"
type "PassiveData"
data "DisplayName" "h123abc01;1"
data "Description" "h123abc02;1"
data "Icon" "PassiveFeature_Generic_Lightning"
data "Properties" "Highlighted"
data "StatsFunctorContext" "OnStatusApplied"
data "Conditions" "HasStatus('SG_Polymorph_BeastShape_Behaviour',context.Source)"
data "StatsFunctors" "ApplyStatus(SELF,WAR_AVATAR_OF_THE_STORM,-1)"
```

### Potential Enhancement (Add DescriptionParams)
```
new entry "WAR_MountainThane_LightningStrikes"
type "PassiveData"
data "DisplayName" "h123abc03;1"
data "Description" "h123abc04;1"
data "DescriptionParams" "25"  // ← ADD THIS for "25% chance" in tooltip
data "Icon" "PassiveFeature_Generic_Lightning"
data "Properties" "Highlighted"
data "StatsFunctorContext" "OnDamage"
data "Conditions" "HasPassive('WAR_MountainThane_Keystone',context.Source)"
data "StatsFunctors" "IF(RandomCastOutcome(25,100)):DealDamage(1d10,Lightning,Magical)"
```

---

## ✅ Quality Checklist

Before presenting transformation:

- [ ] All 36 passives read from backup
- [ ] All passives exist in AbilityDatabase (bg3_file_type = "Passive")
- [ ] No missing passives (database may have more than 36)
- [ ] All entry names use `WAR_*` format
- [ ] All localization handles follow `h[8hex][2digit];version` format
- [ ] All icon references documented (even if generic placeholders)
- [ ] Complex StatsFunctors have inline comments
- [ ] File header has transformation metadata

---

## 📝 Next Steps

1. **Read full Warrior Passive.txt** (all 453 lines)
2. **Query AbilityDatabase** for all Passive entries
3. **Present findings** to user:
   - Total passives found: X
   - Missing from database: Y (if any)
   - Recommended enhancements: Z
4. **Get approval** before writing to Data folder
5. **Transform and validate**

---

## 🎯 Success Criteria

**Transformation complete when:**
- ✅ All Warrior passives moved from backup to Data folder
- ✅ 100% database coverage confirmed
- ✅ File syntax validated (no errors)
- ✅ Enhancements applied (DescriptionParams, comments)
- ✅ User approved final version

**Estimated Time**: 20-30 minutes (mostly validation)

---

**Ready to proceed with Step 1: Read full Warrior Passive.txt?**
