# 🎯 MASTER TRANSFORMATION PLAN: Warlock Template → Warrior Mod

**Date:** October 18, 2024  
**Strategy:** Use proven WoWWarlock structure (13K+ downloads), adapt for Warrior  
**Approach:** Full talent tree mapping + restructured stat files + manual review at each step  

---

## ✅ DECISIONS CONFIRMED

**Decision 1:** Option B - Full talent tree mapping (show mapping plan first before execution)  
**Decision 2:** Option A - Add all missing fields to match Warlock format (show plan first)  
**Decision 3:** Delete unmappable content, but document what it does for future reference  
**Decision 4:** Package only when everything is complete  
**Subclass Strategy:** Arms (full implementation), Fury & Protection (L1 placeholders only)

---

## 📊 CURRENT WARRIOR MOD INVENTORY

### **Our Stat Files (135 Total Entries):**

**Passive.txt:** 36 entries
- Mountain Thane: 11 passives (L13-20 hero talents)
- Colossus: 11 passives (L13-20 hero talents)
- Slayer: 11 passives (L13-20 hero talents)
- Arms Row 1: 2 passives (Overpower, Rend)
- Utility: 1 passive (Victory Rush trigger)

**Spell_Target.txt:** 30 entries
- Base class: 21 spells (Charge, Execute, Slam, etc.)
- Arms specific: 9 spells (Mortal Strike, Overpower, Colossus Smash, etc.)

**Spell_Zone.txt:** 6 entries
- Base: 4 (Revenge, Shockwave, Thunder Clap, Whirlwind)
- Arms: 2 (Warbreaker, Bladestorm)

**Spell_Shout.txt:** 3 entries
- Battle Shout, Rallying Cry, Intimidating Shout

**Spell_Jump.txt:** 2 entries
- Heroic Leap, Intervene

**Spell_Projectile.txt:** 2 entries
- Heroic Throw, Storm Bolt

**Status_BOOST.txt:** 56 entries
- Buffs, debuffs, status effects for all abilities

---

## 📋 WARLOCK TEMPLATE STRUCTURE (What We're Adapting)

### **What Warlock Has:**

**Files:** 186 total
- **9 Critical Files:** meta.lsx, ClassDescriptions.lsx, Progressions.lsx, Lists/ (4 files), ActionResourceDefinitions.lsx, Stats/ (10 files)
- **177 Optional Files:** RootTemplates/ (140 demon files), Content/ (16 visuals), GUI/ (4 UI), Assets/ (4 textures), etc.

**Stat Entries:** 790 total
- Passive.txt: 240 entries (talent trees!)
- Status_BOOST.txt: 233 entries
- Spell_Target.txt: 141 entries
- Spell_Projectile.txt: 54 entries
- Spell_Shout.txt: 47 entries
- Character.txt: 63 entries (demons - we'll delete)

**Lists:** 105 entries (THE KEY TO MAKING IT WORK)
- SpellLists.lsx: 53 lists
- PassiveLists.lsx: 52 lists

**Progressions:** 50+ nodes
- Base class: 12 levels
- 3 Subclasses × 12 levels each
- Selectors reference Lists UUIDs

**Resources:** 10 custom resources
- Soul Shard, Demonic Core, Soul Shard Fragments, etc.

---

## 🔄 TRANSFORMATION PHASES

### **PHASE 1: AUTOMATED SETUP (15 minutes)**
✅ Same as original plan - run automation script to backup, copy, rename, replace UUIDs

---

### **PHASE 2: WARLOCK CONTENT DELETION & DOCUMENTATION (30 minutes)**

**BEFORE we start adapting, document what we're removing:**

#### **Files to Delete & Document:**

**RootTemplates/ (140 files - Demon summons)**
```
DOCUMENTATION:
- Purpose: Visual templates for summoned demons
- How it works: CharacterTemplate references in Character.txt
- Examples: 
  - Imp: Small ranged demon, Fireball attack
  - Voidwalker: Tank demon, Taunt ability
  - Felhunter: Anti-magic demon, Spell devour
- Future use: If we add summons (banners, totems), use this structure
- Delete: All demon RootTemplates (we have no summons)
```

**Character.txt (63 entries - Demon stat blocks)**
```
DOCUMENTATION:
- Purpose: Defines demon stats (HP, AC, movement)
- How it works: Spell summons reference CharacterTemplate UUID
- Pattern:
  new entry "DemonName"
  type "Character"
  data "Strength" "10"
  data "AC" "13"
  data "Vitality" "10"
- Future use: For Guardian-type summons or NPC allies
- Delete: All demon character entries
```

**Soul Shard Spells (15+ entries - Warlock resource spenders)**
```
DOCUMENTATION:
- Purpose: Spells that consume Soul Shards
- How it works: data "UseCosts" "ActionPoint:1;SoulShard:1"
- Examples:
  - Chaos Bolt: Big damage nuke
  - Haunt: DoT that returns Soul Shard on kill
- Future use: Pattern for Rage spenders
- Delete: All Soul Shard-specific spells (we use Rage)
```

**Affliction DoTs (20+ entries - Damage over time spells)**
```
DOCUMENTATION:
- Purpose: Apply damage-over-time debuffs
- How it works: ApplyStatus(target, DOT_STATUS, 100, duration)
- Examples:
  - Agony: Stacking DoT
  - Corruption: Standard DoT
- Future use: For Rend, Deep Wounds, bleeding effects
- Keep pattern: Our Rend already uses this
```

**Action to Take:**
Create `Reports\DELETED_WARLOCK_CONTENT_REFERENCE.md` with full documentation before deletion.

---

### **PHASE 3: LISTS FOLDER MAPPING (2-3 hours) - DECISION 1**

**This is the MOST CRITICAL phase** - Warlock's 105 lists are why it works!

#### **Step 3.1: Analyze Warlock's List Structure (30 min)**

**I'll read and document:**
1. All 53 SpellLists entries (what each one does)
2. All 52 PassiveLists entries (talent choices)
3. How Progressions.lsx references these UUIDs
4. Which lists are level-based vs talent-row-based

**Output:** `Reports\WARLOCK_LISTS_ANALYSIS.md`

#### **Step 3.2: Create Warrior → Warlock Mapping Plan (1 hour)**

**For Each Warlock List, I'll show you:**

**Example Preview:**

```markdown
### WARLOCK LIST #1: Base Class Level 1 Starting Spells

**Warlock Structure:**
```xml
<node id="SpellList">
    <attribute id="Comment" value="Starting Spells - Level 1"/>
    <attribute id="Spells" value="Target_EldritchBlast;Shout_SoulShard"/>
    <attribute id="UUID" value="12345678-90ab-cdef-1234-567890abcdef"/>
</node>
```

**Mapped to Warrior:**
```xml
<node id="SpellList">
    <attribute id="Comment" value="Starting Spells - Warrior Level 1"/>
    <attribute id="Spells" value="Target_WAR_Charge;Target_WAR_SunderArmor"/>
    <attribute id="UUID" value="12345678-90ab-cdef-1234-567890abcdef"/>  <!-- SAME UUID! -->
</node>
```

**Reasoning:**
- Eldritch Blast = ranged basic attack → Charge = melee basic gap closer
- Soul Shard generator → Sunder Armor = Rage generator
- Keep UUID so Progressions.lsx doesn't break
```

**This document will have 105 sections** - one for each list, showing:
- Original Warlock content
- Proposed Warrior mapping
- Reasoning
- Alternative options (if any)

**I'll PAUSE and show you this document for approval before making changes.**

#### **Step 3.3: Execute List Transformations (1 hour)**

After you approve the mapping plan:
1. Update SpellLists.lsx (53 lists)
2. Update PassiveLists.lsx (52 lists)
3. Verify all UUIDs remain unchanged
4. Document which lists are empty placeholders (for Fury/Protection)

---

### **PHASE 4: STAT FILES RESTRUCTURE (2-3 hours) - DECISION 2**

**Goal:** Add all missing fields to match Warlock's complete format

#### **Step 4.1: Compare Warlock vs Warrior Entry Format (30 min)**

**Example Analysis - Spell_Target.txt:**

**Warlock Entry (Complete Format):**
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
data "DisplayName" "h12345678"
data "Description" "h12345679"
data "TooltipDamageList" "DealDamage(1d10+CharismaModifier,Force)"
data "TooltipAttackSave" "RangedSpellAttack"
data "PrepareEffect" "VFX_Spells_Shadowbolt_Prepare_01:Dummy_OverheadFX_01"
data "CastEffect" "VFX_Spells_Shadowbolt_Cast_01:Dummy_CastFX_01"
data "TargetEffect" "VFX_Spells_Shadowbolt_Impact_01:Dummy_Bone_Main"
data "UseCosts" "ActionPoint:1;SoulShard:1"
data "SpellAnimation" "e2668398-4135-4c78-9fb3-1cb0d0e3a981,,;,,;eadedda5-d3ea-4a7f-9e9c-5e26932cc8e4,,;8a32c1c9-cd7e-4835-9c17-0ee61e60e95e,,;,,;,,"
data "VerbalIntent" "Damage"
data "SpellFlags" "HasVerbalComponent;HasSomaticComponent;IsSpell;HasHighGroundRangeExtension;RangeIgnoreVerticalThreshold;IsHarmful"
data "HitCosts" "SoulShard:1"
data "Cooldown" "OncePerTurn"
```

**Our Current Entry (Minimal Format):**
```
new entry "Target_WAR_Execute"
type "SpellData"
data "SpellType" "Target"
data "UseCosts" "ActionPoint:1;Rage:20"
data "TargetConditions" "HealthPercentage(context.Target) <= 20"
data "SpellSuccess" "DealDamage(4d12+StrengthModifier,MainMeleeWeaponDamageType,Magical)"
data "DisplayName" "h125abc01;1"
data "Description" "h125abc02;1"
data "Icon" "Action_Execute"
```

**Missing Fields (to add):**
- `data "Level" "0"`
- `data "SpellSchool" "Evocation"` (or "Warrior" custom school)
- `data "TargetRadius" "18"` (melee = 1.5m, ranged = 18m)
- `data "SpellRoll" "Attack(AttackType.MeleeWeaponAttack)"`
- `data "TooltipDamageList" "DealDamage(4d12+StrengthModifier,MainMeleeWeaponDamageType)"`
- `data "TooltipAttackSave" "MeleeWeaponAttack"`
- `data "VerbalIntent" "Damage"`
- `data "SpellFlags" "IsMelee;HasHighGroundRangeExtension;IsHarmful"`
- `data "Cooldown" "OncePerTurn"` (if applicable)
- Visual effects (PrepareEffect, CastEffect, TargetEffect) - can use generic BG3 effects
- SpellAnimation - can use generic melee animations

#### **Step 4.2: Create Field Addition Plan for Each Stat File (1 hour)**

**I'll create:** `Reports\STAT_FILE_RESTRUCTURE_PLAN.md`

**For Each File:**
1. Show current entry format
2. Show fields to add (with values)
3. Explain reasoning for each field
4. Preview before/after for 2-3 example entries

**Files to Restructure:**
- Passive.txt (36 entries)
- Spell_Target.txt (30 entries)
- Spell_Zone.txt (6 entries)
- Spell_Shout.txt (3 entries)
- Spell_Jump.txt (2 entries)
- Spell_Projectile.txt (2 entries)
- Status_BOOST.txt (56 entries)

**I'll PAUSE and show you the plan for approval.**

#### **Step 4.3: Execute Field Additions (1-1.5 hours)**

After approval:
1. Update each entry file-by-file
2. Test package after every file
3. Verify no syntax errors
4. Document any entries that need special attention

---

### **PHASE 5: PROGRESSIONS.LSX TRANSFORMATION (1.5 hours)**

**Goal:** Replace Warlock ability grants with Warrior ability grants

#### **Step 5.1: Map Progressions Structure (30 min)**

**Warlock Progressions Pattern:**

```xml
<!-- Level 1 - Base Class -->
<node id="Progression">
    <attribute id="Level" value="1"/>
    <attribute id="Name" value="Warlock"/>
    <attribute id="PassivesAdded" value="UnlockSoulShards;WarlockSpellcasting"/>
    <attribute id="Boosts" value="ActionResource(SoulShard,5,0);Proficiency(LightArmor)"/>
    <children>
        <node id="AddSpells">
            <attribute id="Spells" value="Target_EldritchBlast;Shout_SoulShard"/>
        </node>
        <node id="SelectSpells">
            <attribute id="UUID" value="[SpellList UUID]"/>
            <attribute id="Amount" value="2"/>
        </node>
    </children>
</node>

<!-- Level 2 - Subclass Choice -->
<node id="Progression">
    <attribute id="Level" value="2"/>
    <attribute id="Name" value="Warlock"/>
    <children>
        <node id="SubClasses">
            <children>
                <node id="SubClass">
                    <attribute id="UUID" value="[Demonology UUID]"/>
                </node>
                <node id="SubClass">
                    <attribute id="UUID" value="[Destruction UUID]"/>
                </node>
                <node id="SubClass">
                    <attribute id="UUID" value="[Affliction UUID]"/>
                </node>
            </children>
        </node>
    </children>
</node>

<!-- Level 3-12 - Warlock Progressions -->
<!-- Level 3-12 - Subclass Progressions (Demonology, Destruction, Affliction) -->
```

**Warrior Progressions Plan:**

```xml
<!-- Level 1 - Warrior Base Class -->
<node id="Progression">
    <attribute id="Level" value="1"/>
    <attribute id="Name" value="Warrior"/>
    <attribute id="PassivesAdded" value="WAR_UnlockRage;WAR_RageGeneration"/>
    <attribute id="Boosts" value="ActionResource(Rage,100,0);Proficiency(LightArmor);Proficiency(MediumArmor);Proficiency(HeavyArmor);Proficiency(Shields);Proficiency(MartialWeapons)"/>
    <children>
        <node id="AddSpells">
            <attribute id="Spells" value="Target_WAR_Charge;Target_WAR_SunderArmor"/>
        </node>
    </children>
</node>

<!-- Level 2 - Subclass Choice -->
<node id="Progression">
    <attribute id="Level" value="2"/>
    <attribute id="Name" value="Warrior"/>
    <children>
        <node id="SubClasses">
            <children>
                <node id="SubClass">
                    <attribute id="UUID" value="[Arms UUID]"/>  <!-- Keep Warlock's Demonology UUID -->
                </node>
                <node id="SubClass">
                    <attribute id="UUID" value="[Fury UUID]"/>  <!-- Keep Warlock's Destruction UUID -->
                </node>
                <node id="SubClass">
                    <attribute id="UUID" value="[Protection UUID]"/>  <!-- Keep Warlock's Affliction UUID -->
                </node>
            </children>
        </node>
    </children>
</node>

<!-- Level 3 - Battle Shout -->
<node id="Progression">
    <attribute id="Level" value="3"/>
    <attribute id="Name" value="Warrior"/>
    <children>
        <node id="AddSpells">
            <attribute id="Spells" value="Shout_WAR_BattleShout"/>
        </node>
    </children>
</node>

<!-- Continue for Levels 4-12... -->
```

#### **Step 5.2: Create Level-by-Level Mapping (30 min)**

**I'll create:** `Reports\PROGRESSIONS_MAPPING_PLAN.md`

**For Each Level 1-12:**
- Show Warlock grants
- Show proposed Warrior grants
- Explain reasoning
- Note which SelectSpells/SelectPassives reference Lists UUIDs

**Subclass Handling:**
- **Arms:** Full progression L2-L12
- **Fury & Protection:** L2 only (placeholder to avoid breaking character creation)

**I'll PAUSE for your approval.**

#### **Step 5.3: Execute Progressions Updates (30 min)**

After approval, update Progressions.lsx systematically.

---

### **PHASE 6: OTHER CORE FILES (1 hour)**

#### **File 1: meta.lsx (5 min)**
Simple text changes - name, author, description.

#### **File 2: ClassDescriptions.lsx (15 min)**
Update class attributes:
- Name: "Warlock" → "Warrior"
- SpellCastingAbility: "Charisma" → "Strength"
- BaseHp: 8 → 12
- HpPerLevel: 5 → 7
- CanLearnSpells: True → False
- MustPrepareSpells: True → False
- Subclass names

#### **File 3: ActionResourceDefinitions.lsx (10 min)**
Delete 10 Warlock resources, add 1 Rage resource.

#### **File 4: Localization (30 min)**
Replace all Warlock strings with Warrior strings.

---

### **PHASE 7: CLEANUP & PACKAGING (30 min)**

1. Delete RootTemplates/, GUI/, Assets/, Content/ (after documentation)
2. Verify all files reference correct entries
3. Run validation checks
4. Package final mod
5. Test in-game

---

## 📊 COMPLETE TIME ESTIMATE

| Phase | Task | Time | Approval Checkpoint? |
|-------|------|------|---------------------|
| 1 | Automated setup | 15 min | No (standard) |
| 2 | Delete & document Warlock content | 30 min | Yes (review doc) |
| 3.1 | Analyze Warlock lists | 30 min | Yes (analysis doc) |
| 3.2 | Create mapping plan | 1 hour | ✅ YES (full mapping doc) |
| 3.3 | Execute list transformations | 1 hour | No (plan approved) |
| 4.1 | Compare entry formats | 30 min | Yes (comparison doc) |
| 4.2 | Create field addition plan | 1 hour | ✅ YES (restructure doc) |
| 4.3 | Execute field additions | 1.5 hours | No (plan approved) |
| 5.1 | Map progressions structure | 30 min | Yes (structure doc) |
| 5.2 | Create level-by-level plan | 30 min | ✅ YES (mapping doc) |
| 5.3 | Execute progressions updates | 30 min | No (plan approved) |
| 6 | Update other core files | 1 hour | Yes (preview each) |
| 7 | Cleanup & packaging | 30 min | No (final step) |
| **TOTAL** | | **9-10 hours** | **6 major checkpoints** |

**With your approvals at each checkpoint:** 2-3 work sessions over 1-2 days

---

## 🎯 SUCCESS CHECKPOINTS

### **Checkpoint 1: Deleted Content Documented** ✅
- `DELETED_WARLOCK_CONTENT_REFERENCE.md` created
- All Warlock-specific content catalogued
- Patterns documented for future use

### **Checkpoint 2: Lists Mapping Plan Approved** ✅
- `WARLOCK_LISTS_ANALYSIS.md` complete
- All 105 lists mapped to Warrior equivalents
- Arms full mapping, Fury/Protection placeholders defined

### **Checkpoint 3: Stat File Restructure Plan Approved** ✅
- `STAT_FILE_RESTRUCTURE_PLAN.md` complete
- All missing fields identified
- Before/after previews for all 7 files

### **Checkpoint 4: Progressions Mapping Approved** ✅
- `PROGRESSIONS_MAPPING_PLAN.md` complete
- Levels 1-12 mapped
- Arms full, Fury/Protection L2 only

### **Checkpoint 5: Core Files Updated** ✅
- meta.lsx, ClassDescriptions.lsx, ActionResourceDefinitions.lsx, Localization updated
- All text strings in place

### **Checkpoint 6: Package & Test** ✅
- Mod packages successfully
- Character creation works
- No crashes
- Warrior class appears with Arms subclass

---

## 🚀 WORKFLOW PER CHECKPOINT

**For Each Major Checkpoint:**

1. **I Create Analysis/Plan Document**
   - Complete analysis with examples
   - Before/after previews
   - Reasoning for each decision
   - Alternative options where applicable

2. **I Present Document to You**
   - "Here's the plan for [Phase X]"
   - "Please review [DOCUMENT.md]"
   - "Questions or changes needed?"

3. **You Review & Approve/Request Changes**
   - "Looks good, proceed"
   - "Change [X] to [Y]"
   - "Why did you choose [Z]?"

4. **I Execute Changes**
   - Make approved changes
   - Document what was done
   - Create checkpoint backup if needed

5. **Move to Next Checkpoint**

---

## 📋 READY TO START?

**Next Steps:**

1. **You say "Let's start"**
2. **I run Phase 1** (automated setup - 15 min)
3. **I create Phase 2 doc** (deleted content documentation)
4. **You review, I delete files**
5. **I create Phase 3.1 doc** (Warlock lists analysis)
6. **Continue through all checkpoints...**

**This gives you full control and visibility every step of the way!**

---

## 🛡️ SAFETY MEASURES

### **Multiple Backups:**
1. Full mod backup before starting: `Tests\WARRIOR_BACKUP_BEFORE_TEMPLATE_[timestamp]`
2. Stat files separate backup: `Tests\WARRIOR_STATS_BACKUP_[timestamp]`
3. Checkpoint after each major phase

### **Rollback Strategy:**
- Can restore from any checkpoint
- All original files preserved
- Automation script creates restore point

### **Version Control:**
- Package after each successful checkpoint
- Name pattern: `BG3Wow_CHECKPOINT_[phase_name].pak`
- Can test at any point

---

**Status:** MASTER PLAN READY ✅  
**Merged from:** 06_WARLOCK_TEMPLATE_PLAN.md + 07_DETAILED_TRANSFORMATION_PLAN.md  
**Conflicts resolved:** Transformation plan takes priority (per user request)  
**Awaiting:** User approval to begin Phase 1
