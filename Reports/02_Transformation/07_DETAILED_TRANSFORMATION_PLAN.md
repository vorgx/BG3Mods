# 🔄 REVISED PLAN: Warlock Template with Manual Review Checkpoints

**Date:** October 18, 2024  
**Strategy:** Use Warlock structure, adapt to Warrior with MANUAL REVIEW at each step  
**Key Change:** Don't just copy - RESTRUCTURE our stat files to match Warlock's proven format

---

## 🎯 CRITICAL INSIGHT FROM AUTOPSY

From our analysis (`00_AUTOPSY_SUMMARY.md` and `02_WEBSITE_TO_FILES_MAPPING.md`):

### **What Makes Warlock Work:**

1. **File Structure Patterns:**
   - Each spell has proper type prefix (Target_, Shout_, Zone_, Jump_)
   - All abilities reference existing status effects
   - Lists link Progressions → Spells via UUIDs
   - 105 list entries create talent choice system

2. **Stat File Organization:**
   - Passive.txt: 240 entries (talent trees)
   - Status_BOOST.txt: 233 entries (buffs for every ability)
   - Spell_Target.txt: 141 entries (main attack abilities)
   - Everything cross-references correctly

3. **What We'll Adapt:**
   - ✅ Keep Warlock's file structure (it works!)
   - ✅ Keep Warlock's Lists structure (105 entries, working UUIDs)
   - ✅ Replace ability CONTENT with our Warrior abilities
   - ✅ Remove unmappable Warlock-specific content (demons, soul shards)
   - ✅ Restructure our 135 stat entries to match Warlock's format

---

## 📋 FILE-BY-FILE TRANSFORMATION PLAN

### **PHASE 1: AUTOMATED SETUP (15 min)**
Same as before - backup, copy, rename, replace UUIDs globally.

### **PHASE 2: MANUAL FILE TRANSFORMATIONS (2-3 hours)**
**Each file gets a checkpoint with:**
1. 📄 Current state analysis
2. 🎯 Transformation plan
3. 👀 Before/After preview
4. ⏸️ PAUSE for your approval
5. ✅ Execute changes
6. 🧪 Validation

---

## 📂 FILE TRANSFORMATION SEQUENCE

### **FILE 1: meta.lsx** ⏱️ 5 min
**Difficulty:** ⭐ Easy  
**Risk:** Low (just text changes)

#### **What We'll Change:**
- Name: "WoWWarlock" → "BG3Wow"
- Author: Update to your name
- Description: Warlock description → Warrior description
- Keep UUID (already replaced in automation)

#### **Preview:**
```xml
<!-- BEFORE -->
<attribute id="Name" type="FixedString" value="WoWWarlock"/>
<attribute id="Author" type="LSString" value="Khyber"/>
<attribute id="Description" type="LSString" value="Adds Warlock class from World of Warcraft..."/>

<!-- AFTER -->
<attribute id="Name" type="FixedString" value="BG3Wow"/>
<attribute id="Author" type="LSString" value="YourName"/>
<attribute id="Description" type="LSString" value="Adds Warrior class from World of Warcraft with Arms, Fury, and Protection specializations. Master of melee combat and Rage."/>
```

---

### **FILE 2: ActionResourceDefinitions.lsx** ⏱️ 10 min
**Difficulty:** ⭐⭐ Medium  
**Risk:** Medium (affects resource system)

#### **What We'll Do:**
1. **Delete:** All 10 Warlock resources (SoulShard, DemonicCore, etc.)
2. **Keep:** Our 1 Rage resource definition
3. **Verify:** Rage UUID matches what our passives reference

#### **Preview:**
```xml
<!-- BEFORE (Warlock - 10 resources) -->
<node id="ActionResourceDefinition">
    <attribute id="Name" value="SoulShard"/>
    <attribute id="MaxValue" value="5"/>
    <!-- ... -->
</node>
<node id="ActionResourceDefinition">
    <attribute id="Name" value="DemonicCore"/>
    <!-- ... -->
</node>
<!-- 8 more resources... -->

<!-- AFTER (Warrior - 1 resource) -->
<node id="ActionResourceDefinition">
    <attribute id="Name" type="FixedString" value="Rage"/>
    <attribute id="Description" type="TranslatedString" handle="h78fe4910" version="1"/>
    <attribute id="DisplayName" type="TranslatedString" handle="h78fe4911" version="1"/>
    <attribute id="IsSpellResource" type="bool" value="True"/>
    <attribute id="MaxValue" type="uint32" value="100"/>
    <attribute id="ReplenishType" type="ResourceReplenishType" value="Never"/>
    <attribute id="ShowOnActionResourcePanel" type="bool" value="True"/>
    <attribute id="UUID" type="guid" value="[our existing Rage UUID]"/>
</node>
```

#### **Question for You:**
Do you want Rage to:
- Start at 0, build up in combat? (ReplenishType="Never")
- Start at full outside combat? (ReplenishType="Rest")
- Constantly regenerate? (ReplenishType="ShortRest")

---

### **FILE 3: ClassDescriptions.lsx** ⏱️ 20 min
**Difficulty:** ⭐⭐⭐ Hard  
**Risk:** High (defines how class appears in game)

#### **What We'll Change:**

**Base Class:**
- Name: "Warlock" → "Warrior"
- SpellCastingAbility: "Charisma" → "Strength"
- PrimaryAbility: "Charisma" → "Strength"
- BaseHp: 8 → 12 (warriors tankier)
- HpPerLevel: 5 → 7
- CanLearnSpells: True → False (no spellbook)
- MustPrepareSpells: True → False

**Subclass 1 (Demonology → Arms):**
- Name: "WoWWarlockDemonology" → "WoWWarriorArms"
- DisplayName: Update handle
- Description: Update handle
- Keep ProgressionTableUUID (we'll update Progressions later)

**Subclass 2 (Destruction → Fury):**
- Name: "WoWWarlockDestruction" → "WoWWarriorFury"

**Subclass 3 (Affliction → Protection):**
- Name: "WoWWarlockAffliction" → "WoWWarriorProtection"

#### **Preview (Base Class):**
```xml
<!-- BEFORE (Warlock) -->
<node id="ClassDescription">
    <attribute id="Name" value="Warlock"/>
    <attribute id="BaseHp" value="8"/>
    <attribute id="HpPerLevel" value="5"/>
    <attribute id="SpellCastingAbility" value="Charisma"/>
    <attribute id="PrimaryAbility" value="Charisma"/>
    <attribute id="CanLearnSpells" value="True"/>
    <attribute id="MustPrepareSpells" value="True"/>
    <attribute id="SpellList" value="[warlock spell list UUID]"/>
    <!-- ... -->
</node>

<!-- AFTER (Warrior) -->
<node id="ClassDescription">
    <attribute id="Name" value="Warrior"/>
    <attribute id="BaseHp" value="12"/>
    <attribute id="HpPerLevel" value="7"/>
    <attribute id="SpellCastingAbility" value="Strength"/>
    <attribute id="PrimaryAbility" value="Strength"/>
    <attribute id="CanLearnSpells" value="False"/>
    <attribute id="MustPrepareSpells" value="False"/>
    <attribute id="SpellList" value="[keep Warlock's UUID - we'll update SpellLists.lsx]"/>
    <!-- ... -->
</node>
```

---

### **FILE 4-7: Lists Folder** ⏱️ 1 hour
**Difficulty:** ⭐⭐⭐⭐ Very Hard  
**Risk:** Critical (breaking these = crash)

**THIS IS THE MOST IMPORTANT PART!**

#### **Warlock's Lists Structure (What Makes It Work):**

**SpellLists.lsx:** 53 lists
- List for each talent row (9 rows per spec)
- List for starting spells
- List for subclass-specific spells
- Each list has UUID that Progressions references

**PassiveLists.lsx:** 52 lists
- List for each talent choice row
- Each list has 2-3 passive options
- UUID referenced by SelectPassives in Progressions

#### **Our Strategy:**

1. **Keep ALL UUIDs** (Progressions references them)
2. **Replace spell/passive NAMES** with our Warrior ones
3. **Map Warlock talents → Warrior talents**

#### **Example Transformation:**

**SpellLists.lsx - Row 1 Talent Spells:**
```xml
<!-- BEFORE (Warlock Row 1) -->
<node id="SpellList">
    <attribute id="Comment" type="LSString" value="Row 1 - Utility Spells"/>
    <attribute id="Spells" type="LSString" value="Shout_BurningRush;Target_FelDomination;Target_ConjureHealthstone"/>
    <attribute id="UUID" type="guid" value="a1b2c3d4-5e6f-7a8b-9c0d-1e2f3a4b5c6d"/>
</node>

<!-- AFTER (Warrior Row 1) -->
<node id="SpellList">
    <attribute id="Comment" type="LSString" value="Row 1 - Warrior Utility"/>
    <attribute id="Spells" type="LSString" value="Shout_WAR_BattleShout;Shout_WAR_CommandingShout;Target_WAR_Hamstring"/>
    <attribute id="UUID" type="guid" value="a1b2c3d4-5e6f-7a8b-9c0d-1e2f3a4b5c6d"/>  <!-- SAME UUID! -->
</node>
```

**PassiveLists.lsx - Row 1 Talent Passives:**
```xml
<!-- BEFORE (Warlock Row 1) -->
<node id="PassiveList">
    <attribute id="Comment" type="LSString" value="Row 1 - Passive Choices"/>
    <attribute id="Passives" type="LSString" value="WL_ImprovedSoulLeech;WL_DemonicResolve;WL_FelSynergy"/>
    <attribute id="UUID" type="guid" value="b1c2d3e4-6f7a-8b9c-0d1e-2f3a4b5c6d7e"/>
</node>

<!-- AFTER (Warrior Row 1) -->
<node id="PassiveList">
    <attribute id="Comment" type="LSString" value="Row 1 - Warrior Passive Choices"/>
    <attribute id="Passives" type="LSString" value="WAR_ImprovedCharge;WAR_DoubleTime;WAR_Warbringer"/>
    <attribute id="UUID" type="guid" value="b1c2d3e4-6f7a-8b9c-0d1e-2f3a4b5c6d7e"/>  <!-- SAME UUID! -->
</node>
```

#### **The Challenge:**

Warlock has 105 lists. We need to:
1. Map each list to a Warrior equivalent
2. Handle lists we CAN'T map (demon summons, soul shard spells)
3. For unmappable lists: Leave empty or add placeholder

#### **My Proposal:**

**Approach A: Minimal Replacement** (1 hour)
- Keep all 105 lists (preserve structure)
- Replace mappable content (base class, subclass spells)
- Set unmappable lists to empty strings: `value=""`
- Progressions won't reference empty lists anyway

**Approach B: Full Restructure** (3 hours)
- Map every Warlock list to Warrior equivalent
- Create new Warrior talent rows
- Implement full talent tree
- More work but complete system

**Question for You:** Which approach? A is faster, B is complete.

---

### **FILE 8: Progressions.lsx** ⏱️ 45 min
**Difficulty:** ⭐⭐⭐⭐⭐ Extremely Hard  
**Risk:** Critical (this is where crash happens)

#### **What We'll Do:**

**For Each Progression Node (50+ nodes):**
1. Update `Name` attribute (Warlock → Warrior)
2. Update `PassivesAdded` (replace Warlock passives)
3. Update `AddSpells` (replace with our Warrior spells)
4. Keep UUIDs and Selectors (they reference Lists UUIDs)

#### **Example Level 1 Base Class:**

```xml
<!-- BEFORE (Warlock Level 1) -->
<node id="Progression">
    <attribute id="Level" type="uint8" value="1"/>
    <attribute id="Name" type="LSString" value="Warlock"/>
    <attribute id="ProgressionType" type="uint8" value="0"/>
    <attribute id="PassivesAdded" type="LSString" value="UnlockSoulShards;WarlockSpellcasting"/>
    <attribute id="Boosts" type="LSString" value="ActionResource(SoulShard,5,0);Proficiency(LightArmor)"/>
    <attribute id="Selectors" type="LSString" value="SelectSkills(f974ebd6-3725-4b90-bb5c-2b647d41615d,2)"/>
    <children>
        <node id="SubClasses">
            <!-- subclass grants -->
        </node>
    </children>
</node>

<!-- AFTER (Warrior Level 1) -->
<node id="Progression">
    <attribute id="Level" type="uint8" value="1"/>
    <attribute id="Name" type="LSString" value="Warrior"/>
    <attribute id="ProgressionType" type="uint8" value="0"/>
    <attribute id="PassivesAdded" type="LSString" value="WAR_UnlockRage;WAR_RageGeneration"/>
    <attribute id="Boosts" type="LSString" value="ActionResource(Rage,100,0);Proficiency(LightArmor);Proficiency(MediumArmor);Proficiency(HeavyArmor);Proficiency(Shields)"/>
    <attribute id="Selectors" type="LSString" value="SelectSkills(f974ebd6-3725-4b90-bb5c-2b647d41615d,2)"/>
    <children>
        <node id="SubClasses">
            <!-- subclass grants - update to Arms/Fury/Protection UUIDs -->
        </node>
    </children>
</node>
```

#### **Critical Pattern:**

Every `AddSpells` in Progressions must:
1. Reference spells that EXIST in our Spell_*.txt files
2. Use correct prefix (Target_, Shout_, Zone_, Jump_)
3. Or be removed if we don't have that ability

**Example:**
```xml
<!-- Warlock Level 2 -->
<attribute id="AddSpells" type="LSString" value="Target_Shadowbolt;Shout_SoulLeech"/>

<!-- Warrior Level 2 -->
<attribute id="AddSpells" type="LSString" value="Target_WAR_Charge;Shout_WAR_BattleShout"/>
```

---

### **FILE 9-15: Stats/Generated/Data/** ⏱️ 1 hour
**Difficulty:** ⭐⭐⭐⭐ Very Hard  
**Risk:** High (abilities must match Progressions references)

#### **What We'll Do:**

**Keep Our Files, But Restructure Them to Match Warlock's Format:**

**Our Current Files:**
- Passive.txt (36 entries)
- Spell_Target.txt (30 entries)
- Spell_Zone.txt (6 entries)
- Spell_Shout.txt (3 entries)
- Spell_Jump.txt (2 entries)
- Spell_Projectile.txt (2 entries)
- Status_BOOST.txt (56 entries)

**Warlock's Format Patterns We'll Adopt:**

1. **Every spell entry needs:**
   - Proper type prefix in entry name
   - `data "SpellType"` matching the file type
   - `data "DisplayName"` with localization handle
   - `data "Description"` with localization handle
   - `data "Icon"` (can use generic BG3 icons)
   - `data "UseCosts"` (ActionPoint + Rage)

2. **Example of proper format:**

**Our Current Format (might be missing fields):**
```
new entry "Target_WAR_Execute"
type "SpellData"
data "SpellType" "Target"
data "UseCosts" "ActionPoint:1;Rage:20"
data "SpellSuccess" "DealDamage(4d12+StrengthModifier,MainMeleeWeaponDamageType,Magical)"
```

**Warlock's Complete Format:**
```
new entry "Target_Shadowbolt"
type "SpellData"
data "SpellType" "Target"
data "Level" "0"
data "SpellSchool" "Evocation"
data "TargetRadius" "18"
data "AreaRadius" "0"
data "SpellRoll" "Attack(AttackType.RangedSpellAttack)"
data "SpellSuccess" "DealDamage(1d10+CharismaModifier,Force,Magical)"
data "TargetConditions" "Character() and not Dead()"
data "Icon" "Spell_Evocation_Shadowbolt"
data "DisplayName" "h[handle]"
data "Description" "h[handle]"
data "TooltipDamageList" "DealDamage(1d10+CharismaModifier,Force)"
data "TooltipAttackSave" "RangedSpellAttack"
data "PrepareEffect" "VFX_Spells_Shadowbolt_Prepare_01:Dummy_OverheadFX_01"
data "CastEffect" "VFX_Spells_Shadowbolt_Cast_01:Dummy_CastFX_01"
data "UseCosts" "ActionPoint:1;SoulShard:1"
data "SpellAnimation" "e2668398-4135-4c78-9fb3-1cb0d0e3a981,,;,,;eadedda5-d3ea-4a7f-9e9c-5e26932cc8e4,,;8a32c1c9-cd7e-4835-9c17-0ee61e60e95e,,;,,;,,"
data "VerbalIntent" "Damage"
data "SpellFlags" "HasVerbalComponent;HasSomaticComponent;IsSpell;HasHighGroundRangeExtension;RangeIgnoreVerticalThreshold;IsHarmful"
data "HitCosts" "SoulShard:1"
```

**Question for You:**  
Do you want me to:
1. **Add missing fields** to our entries (matching Warlock's complete format)?
2. **Keep minimal** format (if it works, don't touch it)?
3. **Review each stat file** one by one and decide?

---

### **FILE 16: Localization/English/English.loca.xml** ⏱️ 30 min
**Difficulty:** ⭐⭐ Medium  
**Risk:** Medium (missing handles = blank text in-game)

#### **What We'll Do:**

Replace all Warlock localization strings with Warrior strings.

**Example:**
```xml
<!-- BEFORE -->
<content contentuid="h[warlock_base]" version="1">Warlock</content>
<content contentuid="h[warlock_desc]" version="1">A wielder of dark magic who binds demons...</content>

<!-- AFTER -->
<content contentuid="h78fe4901" version="1">Warrior</content>
<content contentuid="h78fe4902" version="1">A master of melee combat who channels Rage...</content>
```

**Challenge:**  
Warlock has 500+ localization entries. We need to:
1. Keep handles for our Warrior abilities
2. Delete handles for Warlock demons/spells we're not using
3. Add new handles if we're missing any

---

## 📊 COMPLETE FILE CHECKLIST

| File | Est. Time | Difficulty | Checkpoint? |
|------|-----------|------------|-------------|
| 1. meta.lsx | 5 min | ⭐ Easy | ✅ Yes |
| 2. ActionResourceDefinitions.lsx | 10 min | ⭐⭐ Medium | ✅ Yes |
| 3. ClassDescriptions.lsx | 20 min | ⭐⭐⭐ Hard | ✅ Yes |
| 4. SpellLists.lsx | 20 min | ⭐⭐⭐⭐ Very Hard | ✅ Yes |
| 5. PassiveLists.lsx | 20 min | ⭐⭐⭐⭐ Very Hard | ✅ Yes |
| 6. SkillLists.lsx | 5 min | ⭐ Easy | ✅ Yes |
| 7. AbilityLists.lsx | 5 min | ⭐ Easy | ✅ Yes |
| 8. Progressions.lsx | 45 min | ⭐⭐⭐⭐⭐ Extreme | ✅ Yes |
| 9. Passive.txt | 15 min | ⭐⭐⭐ Hard | ✅ Yes |
| 10. Spell_Target.txt | 15 min | ⭐⭐⭐ Hard | ✅ Yes |
| 11. Spell_Zone.txt | 5 min | ⭐⭐ Medium | ✅ Yes |
| 12. Spell_Shout.txt | 5 min | ⭐⭐ Medium | ✅ Yes |
| 13. Spell_Jump.txt | 5 min | ⭐⭐ Medium | ✅ Yes |
| 14. Spell_Projectile.txt | 5 min | ⭐⭐ Medium | ✅ Yes |
| 15. Status_BOOST.txt | 10 min | ⭐⭐⭐ Hard | ✅ Yes |
| 16. English.loca.xml | 30 min | ⭐⭐ Medium | ✅ Yes |
| **TOTAL** | **3.5 hours** | | |

---

## 🎯 WORKFLOW FOR EACH FILE

1. **📋 Analysis:** Show current file structure
2. **🎯 Plan:** Explain what we'll change and why
3. **👀 Preview:** Show before/after side-by-side
4. **❓ Questions:** Ask for your input on decisions
5. **⏸️ PAUSE:** Wait for your "proceed" approval
6. **✅ Execute:** Make the changes
7. **🧪 Validate:** Verify changes are correct
8. **📦 Checkpoint:** Save progress, package test version

---

## 🚀 READY TO START?

**When you say "let's start", I will:**

1. **Run automation script** (Phase 1)
   - Backup everything
   - Copy Warlock template
   - Global UUID replacement
   
2. **Start FILE 1: meta.lsx**
   - Show you current content
   - Show you proposed changes
   - Wait for approval
   - Make changes
   - Validate

3. **Continue through all 16 files**
   - One at a time
   - Full transparency
   - Your approval at each step

**Estimated Total Time:** 4-5 hours (automation + manual with reviews)

**Success Probability:** 95% (proven structure + careful adaptation)

---

## ❓ DECISION POINTS BEFORE WE START

**Please answer these so I can plan accordingly:**

1. **Lists Approach:**
   - Option A: Keep all 105 lists, set unmappable ones to empty? (1 hour)
   - Option B: Full restructure with complete Warrior talent mapping? (3 hours)

2. **Stat Files:**
   - Option A: Add missing fields to match Warlock's complete format?
   - Option B: Keep minimal format if entries work?
   - Option C: Review each file individually?

3. **Unmappable Content:**
   - Delete completely? (cleaner)
   - Leave as empty placeholders? (safer, maintains structure)

4. **Testing Frequency:**
   - Package and test after every 5 files?
   - Package and test after all files complete?
   - Your preference?

---

**Status:** DETAILED PLAN READY ✅  
**Waiting for:** Your answers to decision points, then "let's start"

