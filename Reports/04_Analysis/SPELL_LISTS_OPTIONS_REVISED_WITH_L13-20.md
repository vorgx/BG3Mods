# Spell Lists Transformation - REVISED with Full L1-L20 Hero Talent Structure

**Date**: October 19, 2025  
**Context**: FILE 3 complete. Planning FILES 4-10 + LIST structure for L1-L20.  
**Critical Discovery**: Warrior progression goes to L20 with hero talents at L13-L20 (not just L1-L12).

---

## CRITICAL CORRECTION: Warrior Has L13-L20 Hero Talents

After reviewing:
1. `Warrior_Class_Blueprint.md` (1091 lines) - Full L1-L20 design
2. `WoWWarlockHeroTalents` mod - Proven L13-L20 structure
3. Warlock PassiveLists.lsx - SelectPassives system for talent choices

**The Warrior mod has**:
- **L1-L12**: Base class + 3 subclasses (Arms/Fury/Protection)
- **L13-L20**: Hero talent specializations (Mountain Thane/Colossus/Slayer) with choice nodes

This is NOT the simple L1-L12 structure I initially described. This is a **full WoW-style hero talent system**.

---

## Warlock Hero Talent Structure (Proven Pattern)

### Base Structure (L1-L12)
- **12 base class SpellLists**: `WoW_Warlock_Class_Level_1` through `WoW_Warlock_Class_Level_12`
- **12 per subclass (3 subclasses)**: Demo, Destro, Afflic = 36 SpellLists total
- **Total**: 48 SpellLists for L1-L12

### Hero Talent Structure (L13-L20 / Levels 1-8 of hero talent progression)
**6 Hero Specializations** (2 per base subclass):
- **Demo**: Diabolist, Soul Harvester
- **Destro**: Diabolist, Hellcaller  
- **Afflic**: Soul Harvester, Hellcaller

**Each hero specialization has**:
- **L1 (=L13)**: Keystone passive (auto-granted) + SpellList for new abilities
- **L2-L6 (=L14-L18)**: SelectPassives choice nodes (Offensive or Defensive)
- **L7 (=L19)**: Capstone passive (auto-granted)
- **L8 (=L20)**: Empty (feat level)

**PassiveLists structure**:
```xml
<node id="PassiveList">
    <attribute id="Name" value="Diabolist_Demo_Offensive"/>
    <attribute id="Passives" value="Passive1,Passive2,Passive3"/>
    <attribute id="UUID" value="..."/>
</node>
<node id="PassiveList">
    <attribute id="Name" value="Diabolist_Defensive"/>
    <attribute id="Passives" value="Passive4,Passive5"/>
    <attribute id="UUID" value="..."/>
</node>
```

**Progressions.lsx pattern**:
```xml
<!-- L1 of hero talent (=L13 character level) -->
<node id="Progression">
    <attribute id="Level" value="1"/>
    <attribute id="Name" value="DemoDiabolist"/>
    <attribute id="PassivesAdded" value="Keystone,Passive1,Passive2,Passive3"/>
    <attribute id="Selectors" value="AddSpells(UUID-FOR-SPELLIST)"/>
</node>

<!-- L2 of hero talent (=L14 character level) -->
<node id="Progression">
    <attribute id="Level" value="2"/>
    <attribute id="Name" value="DemoDiabolist"/>
    <attribute id="Selectors" value="SelectPassives(UUID-OFFENSIVE-LIST,1,TagName)"/>
</node>
```

---

## Warrior Hero Talent Structure (From Blueprint)

### Base Structure (L1-L12)
- **Base class**: 12 levels with shared abilities
- **Arms subclass**: 12 levels with Arms-specific abilities
- **Fury subclass**: 12 levels with Fury-specific abilities (currently 2 active)
- **Protection subclass**: 12 levels with Protection-specific abilities (currently 2 active)

### Hero Specializations (L13-L20)

**Available Specializations**:
| Base Subclass | Specialization Option 1 | Specialization Option 2 |
|---------------|-------------------------|-------------------------|
| Arms | Colossus (3-tier) | Slayer (3-tier) |
| Fury | Mountain Thane (4-tier) | Slayer (3-tier) |
| Protection | Mountain Thane (4-tier) | Colossus (3-tier) |

**Total Hero Specializations**: 6 (Mountain Thane × 2 base specs, Colossus × 2 base specs, Slayer × 2 base specs)

#### 3-Tier Specializations (Colossus, Slayer)
- **L13**: Keystone (auto-granted)
- **L14**: Passive 1 (auto-granted)
- **L15**: Choice Node 1 (pick 1 of 2-3)
- **L16**: Passive 2 (auto-granted)
- **L17**: Choice Node 2 (pick 1 of 2-3)
- **L18**: Passive 3 (auto-granted)
- **L19**: Choice Node 3 (pick 1 of 2-3)
- **L20**: Passive 4 + Capstone (auto-granted)

#### 4-Tier Specializations (Mountain Thane)
- **L13**: Keystone (auto-granted)
- **L14**: Passive 1 (auto-granted)
- **L15**: Choice Node 1 (pick 1 of 2)
- **L16**: Choice Node 2 (pick 1 of 2)
- **L17**: Passive 2 (auto-granted)
- **L18**: Choice Node 3 (pick 1 of 2)
- **L19**: Choice Node 4 (pick 1 of 2)
- **L20**: Passive 3 + Capstone (auto-granted)

---

## Revised List Structure Requirements

### SpellLists.lsx

**Base Class + Subclasses (L1-L12)**: 48 entries
- 12 Base Warrior (`WoW_Warrior_Class_Level_1` through `WoW_Warrior_Class_Level_12`)
- 12 Arms (`WoW_Warrior_Arms_Level_1` through `WoW_Warrior_Arms_Level_12`)
- 12 Fury (`WoW_Warrior_Fury_Level_1` through `WoW_Warrior_Fury_Level_12`)
- 12 Protection (`WoW_Warrior_Protection_Level_1` through `WoW_Warrior_Protection_Level_12`)

**Hero Specializations (L13-L20)**: 6 entries (keystone spell unlocks)
- `WoW_Warrior_MountainThane_Fury_Level_1` (Heroic Leap + Thunder Clap Enhanced)
- `WoW_Warrior_MountainThane_Protection_Level_1` (Thunder Clap Enhanced)
- `WoW_Warrior_Colossus_Arms_Level_1` (Demolish ability)
- `WoW_Warrior_Colossus_Protection_Level_1` (Demolish ability)
- `WoW_Warrior_Slayer_Arms_Level_1` (Enhanced Execute)
- `WoW_Warrior_Slayer_Fury_Level_1` (Enhanced Execute)

**TOTAL SpellLists**: 48 + 6 = **54 entries**

### PassiveLists.lsx

**Hero Talent Choice Nodes**: Required for SelectPassives system

Each hero specialization needs choice lists:
- **Mountain Thane** (Fury): 4 choice nodes × 2 options = 4 PassiveLists
- **Mountain Thane** (Protection): 4 choice nodes × 2 options = 4 PassiveLists
- **Colossus** (Arms): 3 choice nodes × 2-3 options = 3-6 PassiveLists
- **Colossus** (Protection): 3 choice nodes × 2-3 options = 3-6 PassiveLists
- **Slayer** (Arms): 3 choice nodes × 2-3 options = 3-6 PassiveLists
- **Slayer** (Fury): 3 choice nodes × 2-3 options = 3-6 PassiveLists

**ESTIMATED PassiveLists**: 20-32 entries (depending on choice node structure)

---

## Option A: Complete Rebuild (REVISED - Still Recommended)

### Overview
- **Time**: 3-4 hours (increased from 2 hours due to hero talent complexity)
- **Risk**: Low-Medium
- **Approach**: Delete Warlock content, create full L1-L20 Warrior structure

### What Gets Created

#### SpellLists.lsx (54 entries)
1. **Base Class (12)**: `WoW_Warrior_Class_Level_1` through `_12`
2. **Arms (12)**: `WoW_Warrior_Arms_Level_1` through `_12`
3. **Fury (12)**: `WoW_Warrior_Fury_Level_1` through `_12`
4. **Protection (12)**: `WoW_Warrior_Protection_Level_1` through `_12`
5. **Hero Keystones (6)**: 
   - `WoW_Warrior_MountainThane_Fury_Level_1`
   - `WoW_Warrior_MountainThane_Protection_Level_1`
   - `WoW_Warrior_Colossus_Arms_Level_1`
   - `WoW_Warrior_Colossus_Protection_Level_1`
   - `WoW_Warrior_Slayer_Arms_Level_1`
   - `WoW_Warrior_Slayer_Fury_Level_1`

#### PassiveLists.lsx (20-32 entries)
**Pattern** (using Warlock's proven structure):
```xml
<!-- Mountain Thane Fury - Offensive Choices -->
<node id="PassiveList">
    <attribute id="Name" value="WAR_MountainThane_Fury_Offensive_L15"/>
    <attribute id="Passives" value="WAR_MountainThane_ThunderBlast,WAR_MountainThane_StormBolts"/>
    <attribute id="UUID" value="NEW-UUID"/>
</node>

<!-- Colossus Arms - L15 Choices -->
<node id="PassiveList">
    <attribute id="Name" value="WAR_Colossus_Arms_Choices_L15"/>
    <attribute id="Passives" value="WAR_Colossus_MountainOfMuscle,WAR_Colossus_OneAgainstMany"/>
    <attribute id="UUID" value="NEW-UUID"/>
</node>
```

### Implementation Steps (REVISED)

#### Step 1: Backup (5 minutes)
```powershell
$BackupPath = "Tests\LISTS_BACKUP_BEFORE_REBUILD_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
New-Item -ItemType Directory -Path $BackupPath -Force
Copy-Item "Data\Public\Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7\Lists\*" -Destination $BackupPath -Recurse
```

#### Step 2: Generate UUIDs (15 minutes)
Need **74-86 UUIDs** (54 SpellLists + 20-32 PassiveLists):
```powershell
1..86 | ForEach-Object { [guid]::NewGuid().ToString() } | Out-File "Reports\NEW_WARRIOR_LIST_UUIDS.txt"
```

#### Step 3: Map Base Class Spells (30 minutes)
From `Warrior_Class_Blueprint.md` + `ARMS_WARRIOR_FULL_PROGRESSION.md`:

**Base Class Spells (L1-L12)**:
| Level | Spells |
|-------|--------|
| 1 | `Target_WAR_Charge`, `Target_WAR_HeroicStrike` |
| 2 | `Shout_WAR_BattleShout` |
| 3 | `Target_WAR_Execute` |
| 4 | (Feat - empty) |
| 5 | (Extra Attack - passive, no spell) |
| 6 | `Shout_WAR_DefensiveStance` |
| 7 | `Shout_WAR_IntimidatingShout` |
| 8 | (Feat - empty) |
| 9 | `Jump_WAR_HeroicLeap` |
| 10 | `Shout_WAR_RallyingCry` |
| 11 | (Improved Extra Attack - passive, no spell) |
| 12 | (Feat - empty) |

**Arms Subclass Spells (L1-L12)**:
| Level | Spells |
|-------|--------|
| 1 | (Passive only: `WAR_ARMS_WeaponMastery`) |
| 2 | (Base class only) |
| 3 | `Target_WAR_ARMS_MortalStrike`, `Target_WAR_ARMS_Overpower` |
| 4 | (Feat) |
| 5 | (Passive only: `WAR_ARMS_TacticalMastery`) |
| 6 | (Base class only) |
| 7 | `Target_WAR_ARMS_ColossusSmash` |
| 8 | (Feat) |
| 9 | `Shout_WAR_ARMS_SweepingStrikes` |
| 10 | (Base class only) |
| 11 | `Zone_WAR_ARMS_Warbreaker` |
| 12 | (Feat) |

**Fury Subclass Spells (L1-L12)**:
| Level | Spells |
|-------|--------|
| 1 | `Shout_WAR_FURY_Enrage` |
| 2-12 | (Placeholders - Fury not fully implemented) |

**Protection Subclass Spells (L1-L12)**:
| Level | Spells |
|-------|--------|
| 1 | `Shout_WAR_PROT_ShieldBlock` |
| 2-12 | (Placeholders - Protection not fully implemented) |

#### Step 4: Map Hero Talent Spells (20 minutes)
From `Warrior_Class_Blueprint.md`:

| Hero Specialization | Keystone Spell (L13) | Notes |
|---------------------|----------------------|-------|
| Mountain Thane (Fury) | `Jump_WAR_HeroicLeap`, `Zone_WAR_ThunderClap_Enhanced` | Unlocks Thunder Clap variant |
| Mountain Thane (Protection) | `Zone_WAR_ThunderClap_Enhanced` | Thunder Clap with Lightning |
| Colossus (Arms) | `Zone_WAR_Demolish` | 3d10 per stack AoE |
| Colossus (Protection) | `Zone_WAR_Demolish` | Same Demolish ability |
| Slayer (Arms) | `Target_WAR_Execute_Enhanced` | Enhanced Execute |
| Slayer (Fury) | `Target_WAR_Execute_Enhanced` | Enhanced Execute |

#### Step 5: Map Hero Talent Passives (45 minutes)
From `PASSIVES_*.md` files:

**Example for Colossus Arms**:
- **L13 Keystone**: `WAR_Colossus_Keystone` (auto-granted)
- **L14 Passive**: (auto-granted)
- **L15 Choices**: `WAR_Colossus_MountainOfMuscle` OR `WAR_Colossus_OneAgainstMany` OR `WAR_Colossus_VeteranVitality`
- **L16 Passive**: (auto-granted)
- **L17 Choices**: `WAR_Colossus_PracticedStrikes` OR `WAR_Colossus_ArterialBleed` OR `WAR_Colossus_Earthquaker`
- **L18 Passive**: (auto-granted)
- **L19 Choices**: `WAR_Colossus_MartialExpert` OR `WAR_Colossus_TideOfBattle` OR `WAR_Colossus_DemolishShockwave`
- **L20 Capstone**: `WAR_Colossus_PreciseMight` (auto-granted status)

Create PassiveList for each choice node (3 lists for Colossus Arms).

#### Step 6: Write SpellLists.lsx (60 minutes)
54 entries with proper XML structure.

#### Step 7: Write PassiveLists.lsx (45 minutes)
20-32 entries for hero talent choices.

#### Step 8: Validate (30 minutes)
- XML syntax
- UUID uniqueness
- Spell/passive name references

#### Step 9: Create Documentation (30 minutes)
- UUID mapping (old Warlock → new Warrior)
- Hero talent structure diagram
- Progressions.lsx update guide

### Pros
✅ **Clean structure** - matches Warlock's proven L1-L20 pattern  
✅ **Exact Warlock architecture** - SpellLists + PassiveLists for hero talents  
✅ **Full L13-L20 support** - proper SelectPassives choice nodes  
✅ **Maintainable** - clear naming, logical organization  
✅ **Documented** - complete UUID mapping for Progressions.lsx  

### Cons
⚠️ **More complex than expected** - 54 SpellLists + 20-32 PassiveLists (not just 38)  
⚠️ **Longer time** - 3-4 hours (not 2 hours)  
⚠️ **Hero talent mapping** - must understand 6 specializations × 3-4 choice tiers  
⚠️ **New UUIDs** - must update Progressions.lsx in FILE 11  

### Why This Is Still Best
This option **replicates the Warlock hero talent system exactly**:
1. Same SpellLists structure (base + subclass + hero keystone)
2. Same PassiveLists structure (choice nodes via SelectPassives)
3. Same Progressions.lsx pattern (L1-L12 base, L13-L20 hero specializations)
4. Proven to work (Warlock mod has 13K+ downloads)

---

## Option B: Transform Existing (HIGHLY NOT RECOMMENDED)

### Overview
- **Time**: 5-6 hours (increased from 3+ hours)
- **Risk**: Very High
- **Approach**: Find/replace Warlock → Warrior, remap hero specializations

### Why This Is Even Worse Now
The Warlock mod has:
- 48 base/subclass SpellLists
- Hero talent SpellLists for Diabolist/SoulHarvester/Hellcaller
- PassiveLists for choice nodes

The Warrior mod needs:
- 48 base/subclass SpellLists (same)
- Hero talent SpellLists for MountainThane/Colossus/Slayer (DIFFERENT)
- PassiveLists for choice nodes (DIFFERENT structure - 3-tier vs 4-tier)

**Mapping nightmare**: 
- Warlock Diabolist (3 subclasses) → Warrior Colossus (2 subclasses) + half of MountainThane?
- Warlock SoulHarvester → Warrior Slayer + other half of MountainThane?
- Warlock Hellcaller → What maps to this?

❌ **DO NOT USE THIS OPTION** - Hero talent structures don't align.

---

## Option C: Hybrid Approach (REVISED - Medium Complexity)

### Overview
- **Time**: 2.5-3 hours
- **Risk**: Medium
- **Approach**: Keep some Warlock UUIDs, create new structure with Warrior content

### What Gets Done
1. **Keep Warlock base/subclass UUIDs** (48 UUIDs for L1-L12)
2. **Generate new UUIDs for hero talents** (6 SpellLists + 20-32 PassiveLists)
3. **Create clean Warrior names** (`WoW_Warrior_*`)
4. **Map Warlock base UUIDs → Warrior base lists**
5. **Create new hero talent structure** (don't try to map from Warlock)

### Pros
✅ **Preserves base UUIDs** - L1-L12 Progressions.lsx doesn't need updates  
✅ **Faster than Option A** - reuse 48 UUIDs, generate 26-38 new ones  
✅ **Warlock-like pattern** - same structure, some UUID preservation  

### Cons
⚠️ **UUID semantics broken** - Warlock Demo UUID used for Arms  
⚠️ **Partial preservation** - hero talents still need new UUIDs anyway  
⚠️ **Confusing debugging** - "Why is this Arms list using Warlock Diabolist UUID?"  
⚠️ **Still complex** - hero talent structure must be built from scratch  

### Is This Worth It?
**Maybe**. Saves 30-60 minutes by reusing 48 base UUIDs, but hero talents (the complex part) still require full implementation.

---

## Recommendation: Option A (Complete Rebuild)

### Why Option A Is Best

**1. Warrior Hero Talents Are NOT Warlock Hero Talents**
- Warlock: Diabolist/SoulHarvester/Hellcaller (2 spec combos each)
- Warrior: MountainThane/Colossus/Slayer (2 spec combos each)
- **Different specializations = different list structures**
- Trying to transform Warlock hero talents to Warrior is impossible

**2. We're Updating Progressions.lsx Anyway**
- FILE 11 (Progressions.lsx) is already on our todo list
- We'll update L1-L12 references AND L13-L20 hero talent progressions
- **No extra work** to use new UUIDs

**3. Clean Slate = No Hidden Issues**
- No leftover Warlock hero talent references
- No semantic confusion (UUID matches content)
- Easy to debug and maintain

**4. Exact Warlock Pattern**
- 48 base/subclass SpellLists ✅
- 6 hero keystone SpellLists ✅
- 20-32 PassiveLists for choice nodes ✅
- SelectPassives in Progressions.lsx ✅
- **This IS "closest to Warlock"** - same architecture, different content

**5. Time Investment Justified**
- 3-4 hours for Option A vs 2.5-3 hours for Option C
- **30-60 minutes difference** for significantly cleaner result
- Long-term maintainability worth the extra time

---

## Next Steps (Awaiting User Decision)

**Please choose**:
1. **Option A: Complete Rebuild** (3-4 hours, clean L1-L20 structure, new UUIDs)
2. **Option C: Hybrid** (2.5-3 hours, preserve base UUIDs, new hero talent UUIDs)
3. **Option B: Transform** (5-6 hours, high risk, NOT RECOMMENDED)

**My strong recommendation**: **Option A**

**Why**: Warrior hero talents are fundamentally different from Warlock hero talents. Option A gives us the cleanest implementation of the full L1-L20 system. The extra 30-60 minutes is worth avoiding semantic confusion and maintenance headaches.

---

## Implementation Checklist (Once Option Chosen)

### Pre-Implementation (10 minutes)
- [ ] Backup current Lists/ folder
- [ ] Read Warrior_Class_Blueprint.md (L13-L20 sections)
- [ ] Read PASSIVES_MOUNTAIN_THANE.md, PASSIVES_COLOSSUS.md, PASSIVES_SLAYER.md
- [ ] Create spell mapping tables (L1-L12 + L13-L20 keystones)

### SpellLists.lsx (90 minutes)
- [ ] Generate 54 UUIDs
- [ ] Create 12 base class lists
- [ ] Create 36 subclass lists (12 × 3)
- [ ] Create 6 hero keystone lists
- [ ] Validate XML syntax
- [ ] Validate spell name references

### PassiveLists.lsx (75 minutes)
- [ ] Generate 20-32 UUIDs
- [ ] Map choice nodes for each hero specialization:
  - [ ] Mountain Thane Fury (4 choice nodes)
  - [ ] Mountain Thane Protection (4 choice nodes)
  - [ ] Colossus Arms (3 choice nodes)
  - [ ] Colossus Protection (3 choice nodes)
  - [ ] Slayer Arms (3 choice nodes)
  - [ ] Slayer Fury (3 choice nodes)
- [ ] Create PassiveList entries
- [ ] Validate XML syntax
- [ ] Validate passive name references

### Documentation (30 minutes)
- [ ] Create UUID_MAPPING.md (old Warlock → new Warrior)
- [ ] Create HERO_TALENT_STRUCTURE.md (choice node diagram)
- [ ] Update SPELL_LISTS_OPTIONS_REVISED_WITH_L13-20.md with implementation notes

### Testing Preparation (15 minutes)
- [ ] Note: FILE 11 (Progressions.lsx) must reference these UUIDs
- [ ] Note: FILE 10 (Passive.txt) must have all passives defined
- [ ] Note: FILES 4-9 (Spell_*.txt) must have all spells defined

---

**Total Estimated Time**: 3-4 hours (Option A) or 2.5-3 hours (Option C)

**Ready for your decision!**
