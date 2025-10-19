# Phase 1 - Report 02: Website Features Mapped to Files

**Step 2 of 20** - Mapping Nexus Page Features to Mod Files  
**Date:** October 18, 2024

---

## 📊 Mod Overview from Website

**Total Features Implemented:**
- **Base Class:** 1 (Warlock)
- **Subclasses:** 3 (Demonology, Destruction, Affliction)
- **Hero Talents:** 3 (Diabolist, Soul Harvester, Hellcaller) [Levels 13-20]
- **Base Progression Rows:** 9 rows (84 total talent choices)
- **Demon Pets:** 15+ types (Imp, Voidwalker, Felhunter, Succubus/Incubus, Felguard, Wild Imp, Dreadstalker, Vilefiend, etc.)
- **Custom Resource:** Soul Shards (5 charges, replenishes on Long Rest)
- **Estimated Total Abilities:** 150+ (spells, passives, pet abilities)

---

## 🗺️ Feature → File Mapping

### **1. CLASS DEFINITION → ClassDescriptions.lsx**

**Website Features:**
- "Warlock class inspired by World of Warcraft"
- Spellcasting modifier: Charisma
- 3 subclasses (Demonology, Destruction, Affliction)

**File Implementation:**
- `ClassDescriptions.lsx` - 4 class entries:
  1. Base "Warlock" class
  2. "WoWWarlockDemonology" subclass
  3. "WoWWarlockDestruction" subclass
  4. "WoWWarlockAffliction" subclass

**Key Attributes:**
- `SpellCastingAbility="Charisma"`
- `BaseHp` + `HpPerLevel` (physically weak sp ellcasters)
- `ProgressionTableUUID` links to Progressions.lsx

**Our Warrior Equivalent:**
- ✅ We have 4 classes (base + 3 subclasses)
- ✅ Similar structure
- ⚠️ Need to verify SpellCastingAbility equivalent

---

### **2. CUSTOM RESOURCE → ActionResourceDefinitions.lsx**

**Website Features:**
- "Soul Shards are used as Action Resource"
- "Has 5 charges. Recharges at full rest"
- Multiple resource types (Demonic Core for Demonology, Soul Shard Fragments for Destruction, etc.)

**File Implementation:**
- `ActionResourceDefinitions.lsx` - **10 different resources!**
  1. SoulShard (main resource)
  2. Soulfire
  3. DemonicCore (Demonology)
  4. SoulShardFragments (Destruction)
  5. NightfallProc (Affliction)
  6. SucculentSoul (Soul Harvester hero talent)
  7-10. Other specialized resources

**Key Attributes:**
- `MaxValue="5"` (for Soul Shards)
- `ReplenishType="Rest"` (recharges on Long Rest)
- `ShowOnActionResourcePanel="true"` (displays in UI)

**Our Warrior Equivalent:**
- ✅ We have Rage resource
- ❌ Only 1 resource (Warlock has 10!)
- ⚠️ Need to verify ReplenishType (Never vs Rest)

---

### **3. LEVEL PROGRESSION → Progressions.lsx**

**Website Features:**
- Level 1-12: Base class + subclass progression
- Level 13-20: Hero Talent progression (3 separate trees)
- 9 talent rows unlocked progressively
- Each level grants: base abilities + 1-3 talent choices

**File Implementation:**
- `Progressions.lsx` - **50+ progression nodes**
  - **Base Warlock:** Levels 1-12 (12 progressions)
  - **Demonology:** Levels 1-12 (12 progressions)
  - **Destruction:** Levels 1-12 (12 progressions)
  - **Affliction:** Levels 1-12 (12 progressions)
  - **Diabolist Hero:** Levels 13-20 (8 progressions)
  - **Soul Harvester Hero:** Levels 13-20 (8 progressions)
  - **Hellcaller Hero:** Levels 13-20 (8 progressions)

**Progression Structure (Example - Level 2):**
```
Level 2:
- Grants: Soul Leech passive
- Selectors: SelectPassives(Row1UUID,1)  ← Player chooses 1 from Row 1
```

**Our Warrior Equivalent:**
- ✅ We have 54 progression nodes (similar scale)
- ✅ We have level 1-20 progressions
- ❌ We don't have hero talents (levels 13-20 different design)
- ⚠️ Need to verify Selectors syntax matches

---

### **4. TALENT CHOICES → Lists Files**

**Website Features:**
- **Row 1:** 3 choices (Burning Rush, Fel Domination, Conjure Healthstone)
- **Row 2:** 3 choices (Demon Armor, Fel Armor, Mortal Coil)
- ... (9 rows total, 84+ total choices)

**File Implementation:**
- **PassiveLists.lsx:** 52 lists!
  - One list per talent row
  - Each list contains 2-3 passive options
  - Example: `Row1_PassiveChoices` contains "BurningRush;FelDomination;ConjureHealthstone"
  
- **SpellLists.lsx:** 53 lists!
  - Spell pools for AddSpells selectors
  - Demon summon lists
  - Subclass-specific ability pools

**Our Warrior Equivalent:**
- ✅ We have 4 Lists files
- ❌ Only 1 entry each (minimal placeholders)
- 🔥 **CRITICAL GAP:** Warlock has 105 list entries, we have 4!

---

### **5. ABILITIES → Stats/Generated/Data/**

**Website Abilities Count:**
- **Base Warlock:** 30+ abilities
- **Demonology:** 25+ unique abilities
- **Destruction:** 20+ unique abilities
- **Affliction:** 25+ unique abilities
- **Hero Talents:** 30+ additional abilities
- **Pet Abilities:** 40+ demon abilities
- **TOTAL:** ~170 abilities

**File Implementation:**
| File | Warlock Entries | Purpose |
|------|-----------------|---------|
| `Spell_Projectile.txt` | ~15 | Eldritch Blast, Firebolt, etc. |
| `Spell_Target.txt` | ~40 | Shadowbolt, Chaos Bolt, Demonbolt, etc. |
| `Spell_Zone.txt` | ~20 | Rain of Fire, Hand of Gul'dan, etc. |
| `Spell_Shout.txt` | ~10 | Buffs like Demon Armor, Fel Armor |
| `Passive.txt` | ~60 | All talent passives |
| `Status_BOOST.txt` | ~30 | Buff/debuff effects |
| `Status_EFFECT.txt` | ~10 | Special effects |
| `Interrupt.txt` | ~5 | Spell interrupts (Spell Lock) |

**Our Warrior Equivalent:**
- ✅ We have similar stat files
- ⚠️ Unknown entry counts (need to verify)
- 🔥 **NEED TO COMPARE:** Do we have enough abilities implemented?

---

### **6. DEMON PETS → Stats Files + RootTemplates**

**Website Features:**
- **15+ demon types:** Imp, Voidwalker, Felhunter, Succubus/Incubus, Felguard, Wild Imp, Imp Gang Boss, Dreadstalker, Vilefiend, Bilescourge, Demonic Tyrant, Doomguard, Infernal, Overfiend, etc.
- Each has 2-5 unique abilities
- **Total pet abilities:** 40+

**File Implementation:**
- **Stats files:** Character.txt, Object.txt (summon definitions)
- **RootTemplates/:** **140 .lsf files!**
  - These are character/creature templates
  - Each demon likely has a RootTemplate defining stats, visuals, AI

**Our Warrior Equivalent:**
- ❌ We have 0 RootTemplates
- ❌ We don't summon creatures (different class design)
- ✅ Not needed for Warrior

---

### **7. UI/VISUALS → GUI/ + Assets/**

**Website Features:**
- Soul Shard resource bar display
- Custom class icons
- Visual effects for spells

**File Implementation:**
- **GUI/:** 4 files (custom UI elements for Soul Shard display)
- **Assets/:** 4 files (custom textures + VFX)
  - 3 .dds icon textures
  - 1 .lsfx visual effect

**Our Warrior Equivalent:**
- ❌ We have no custom GUI
- ❌ We have no custom Assets
- ⚠️ **MIGHT BE OPTIONAL** - base game UI may suffice

---

## 🔍 Critical Discoveries

### **Scale Comparison:**

| Feature | Warlock | Warrior | Status |
|---------|---------|---------|--------|
| **Classes (base + subclasses)** | 4 | 4 | ✅ MATCH |
| **Progression nodes** | 50+ | 54 | ✅ MATCH |
| **Custom resources** | 10 | 1 | ⚠️ Different scale |
| **List entries (PassiveLists + SpellLists)** | 105 | 4 | 🔥 HUGE GAP |
| **Stat file entries** | ~180 | ??? | 🔍 NEED TO COUNT |
| **RootTemplates** | 140 | 0 | ✅ Different design |
| **GUI files** | 4 | 0 | ⚠️ May be optional |
| **Asset files** | 4 | 0 | ⚠️ May be optional |

---

## 🎯 Key Insights

### **What Makes Warlock Work:**

1. **MASSIVE Lists Implementation:**
   - 52 PassiveLists for talent choices
   - 53 SpellLists for ability pools
   - **This is how Selectors work!** Progressions reference these UUIDs

2. **Complex Resource System:**
   - 10 different custom resources
   - Each subclass has unique resources
   - Resources interact with abilities via UseCosts

3. **Extensive Ability Implementation:**
   - ~180 entries across 10 stat files
   - Every ability fully implemented
   - Every passive fully defined

4. **RootTemplates for Pets:**
   - 140 creature templates
   - Each demon fully defined
   - Not applicable to non-summoner classes

### **What We're Missing (Potentially Critical):**

1. **🔥 LISTS CONTENT:**
   - We have 4 list files but only 1 entry each
   - Warlock has 105 entries!
   - **This might be why Selectors fail → crash**

2. **⚠️ Resource Complexity:**
   - We have 1 resource (Rage)
   - Warlock has 10
   - Unknown if simpler = problem

3. **❓ Ability Count:**
   - Need to count our stat file entries
   - Compare with Warlock's ~180

---

## 📝 Next Steps (Steps 3-4)

**Step 3:** Extract ALL UUIDs from Warlock and create cross-reference map  
**Step 4:** Document version numbers and dependencies (meta.lsx)

Then we'll dive DEEP into:
- How Progressions reference Lists (Selectors syntax)
- How Lists reference Spells/Passives
- How abilities are fully implemented

---

**Status:** STEP 2 COMPLETE ✅  
**Critical Finding:** Lists folder is the linchpin - we have 4 entries, Warlock has 105!

