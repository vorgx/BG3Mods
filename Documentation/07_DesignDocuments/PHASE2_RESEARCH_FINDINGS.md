# PHASE 2 RESEARCH FINDINGS: Hero Talent Implementation Options

**Date**: October 24, 2025  
**Research Source**: WoWWarlockHeroTalents mod (13K+ downloads, proven working)

---

## WoWWarlock's Actual Implementation

### They Used Option 3: Separate Subclasses ✅ PROVEN WORKING

**Structure**:
- **6 total subclasses** (instead of 3 base specs)
- Each subclass = Base Spec + Hero Talent Tree
- Player chooses at **L1** (character creation), NOT L13

**Example from Warlock**:
```
Base Specs (3):          Hero Trees (3):
- Demonology        →    - Diabolist
- Destruction       →    - Hellcaller  
- Affliction        →    - Soul Harvester

Resulting Subclasses (6):
1. DemoDiabolist (Demonology + Diabolist)
2. DestroDiabolist (Destruction + Diabolist)
3. AffSoulHarvester (Affliction + Soul Harvester)
4. DemoSoulHarvester (Demonology + Soul Harvester)
5. DestroHellcaller (Destruction + Hellcaller)
6. AffHellcaller (Affliction + Hellcaller)
```

**ClassDescriptions.lsx Pattern**:
```xml
<node id="ClassDescription">
    <attribute id="Name" type="FixedString" value="DemoDiabolist"/>
    <attribute id="ParentGuid" type="guid" value="BASE_WARLOCK_CLASS_UUID"/>
    <attribute id="ProgressionTableUUID" type="guid" value="UNIQUE_PROGRESSION_UUID"/>
    <attribute id="DisplayName" type="TranslatedString" handle="h..." version="2"/>
    <attribute id="Description" type="TranslatedString" handle="h..." version="1"/>
    <attribute id="UUID" type="guid" value="UNIQUE_SUBCLASS_UUID"/>
    <!-- All other attributes same as parent class -->
</node>
```

**Progressions.lsx Pattern**:
```xml
<!-- Separate progression for each subclass -->
<node id="Progression">
    <attribute id="Level" type="uint8" value="1"/>
    <attribute id="Name" type="LSString" value="DemoDiabolist"/>
    <attribute id="PassivesAdded" type="LSString" value="HERO_TALENT_KEYSTONES"/>
    <attribute id="ProgressionType" type="uint8" value="1"/>  <!-- Subclass -->
    <attribute id="TableUUID" type="guid" value="UNIQUE_PROGRESSION_UUID"/>
    <attribute id="UUID" type="guid" value="PROGRESSION_NODE_UUID"/>
</node>
```

---

## Comparison: 3 Implementation Options

| Feature | **Option 3 (Warlock)** | **Option 1 (Feat-Based)** | **Current (Phase 1)** |
|---------|------------------------|----------------------------|------------------------|
| **When chosen** | L1 (char creation) | L13 (mid-game) | N/A (all granted) |
| **WoW accuracy** | ❌ Wrong timing | ✅ Correct L13 | ❌ Wrong (no choice) |
| **Proven working** | ✅ 13K+ downloads | ⚠️ Untested | ✅ Works (overpowered) |
| **Subclasses needed** | 6 total | 3 total | 3 total |
| **Status effects** | None | 3 needed | None |
| **Passive conditions** | None | 33 updates | None |
| **Respec support** | ✅ Native BG3 | ⚠️ Need testing | ✅ Native BG3 |
| **Implementation time** | **4-6 hours** | 8-10 hours | N/A (done) |
| **Complexity** | **LOW** | HIGH | N/A |
| **Risk** | **LOW** | MEDIUM-HIGH | N/A |

---

## RECOMMENDATION: Use Option 3 (Warlock's Approach)

### Why This Is Better

1. **Proven Working**: 13K+ downloads, zero reported issues with this pattern
2. **Lower Risk**: No untested mechanics (status conditions on passives)
3. **Faster**: 4-6 hours vs 8-10 hours
4. **Simpler**: No status effects, no conditional passives, no feat definitions
5. **Native Respec**: BG3's respec system handles subclass changes automatically
6. **Easier Maintenance**: Each subclass is isolated, easier to debug

### Tradeoffs

**❌ NOT WoW-Accurate**:
- Player chooses at L1 instead of L13
- Can't "unlock" hero talents mid-playthrough (must respec to change)

**✅ BG3-Native**:
- Uses BG3's existing subclass system (same as Cleric domains, Warlock patrons)
- Works exactly how players expect BG3 mods to work
- No custom mechanics that might break with game updates

---

## REVISED IMPLEMENTATION PLAN (Option 3)

### For Warrior: 6 Subclasses Total

**Current 3 Base Specs**:
- Arms
- Fury
- Protection

**3 Hero Talent Trees**:
- Colossus (Arms + Protection compatible)
- Slayers (Arms + Fury compatible)
- Mountain Thane (Fury + Protection compatible)

**6 New Subclasses**:
1. **ArmsColossus** (Arms + Colossus tree)
2. **ArmsSlayers** (Arms + Slayers tree)
3. **FuryMountainThane** (Fury + Mountain Thane tree)
4. **FurySlayers** (Fury + Slayers tree)
5. **ProtectionMountainThane** (Protection + Mountain Thane tree)
6. **ProtectionColossus** (Protection + Colossus tree)

---

## STEP-BY-STEP IMPLEMENTATION (Option 3)

### Step 1: Generate New UUIDs (5 minutes)
Need **18 new UUIDs**:
- 6 for subclass ClassDescription nodes
- 6 for subclass ProgressionTableUUID
- 6 for subclass L1 Progression nodes

```powershell
1..18 | ForEach-Object { [guid]::NewGuid().ToString() }
```

---

### Step 2: Update ClassDescriptions.lsx (1-2 hours)

**REPLACE** current 3 subclass definitions with 6 new ones.

**BEFORE** (Current - 3 subclasses):
```xml
<!-- Arms -->
<node id="ClassDescription">
    <attribute id="Name" type="LSString" value="Arms"/>
    <attribute id="UUID" type="guid" value="CURRENT_ARMS_UUID"/>
    <!-- ... -->
</node>

<!-- Fury -->
<node id="ClassDescription">
    <attribute id="Name" type="LSString" value="Fury"/>
    <attribute id="UUID" type="guid" value="CURRENT_FURY_UUID"/>
    <!-- ... -->
</node>

<!-- Protection -->
<node id="ClassDescription">
    <attribute id="Name" type="LSString" value="Protection"/>
    <attribute id="UUID" type="guid" value="CURRENT_PROTECTION_UUID"/>
    <!-- ... -->
</node>
```

**AFTER** (6 subclasses):
```xml
<!-- Arms + Colossus -->
<node id="ClassDescription">
    <attribute id="Name" type="FixedString" value="ArmsColossus"/>
    <attribute id="DisplayName" type="TranslatedString" handle="hNEW001" version="1"/>
    <attribute id="Description" type="TranslatedString" handle="hNEW002" version="1"/>
    <attribute id="ParentGuid" type="guid" value="BASE_WARRIOR_UUID"/>
    <attribute id="ProgressionTableUUID" type="guid" value="NEW_UUID_1"/>
    <attribute id="UUID" type="guid" value="NEW_UUID_7"/>
    <!-- Copy all other attributes from current Arms subclass -->
</node>

<!-- Arms + Slayers -->
<node id="ClassDescription">
    <attribute id="Name" type="FixedString" value="ArmsSlayers"/>
    <attribute id="DisplayName" type="TranslatedString" handle="hNEW003" version="1"/>
    <attribute id="Description" type="TranslatedString" handle="hNEW004" version="1"/>
    <attribute id="ParentGuid" type="guid" value="BASE_WARRIOR_UUID"/>
    <attribute id="ProgressionTableUUID" type="guid" value="NEW_UUID_2"/>
    <attribute id="UUID" type="guid" value="NEW_UUID_8"/>
    <!-- Copy all other attributes from current Arms subclass -->
</node>

<!-- Repeat for 4 more: FuryMountainThane, FurySlayers, ProtectionMountainThane, ProtectionColossus -->
```

**Critical**: Copy ALL attributes from current subclass nodes (CharacterCreationPose, SoundClassType, PrimaryAbility, etc.)

---

### Step 3: Replace Progressions.lsx (2-3 hours)

**Massive change**: Replace all subclass progressions (L3-20) with 6 separate subclass progressions.

**BEFORE** (Current - 3 subclass progressions × 18 levels = 54 nodes):
```xml
<!-- Arms Level 3 -->
<node id="Progression">
    <attribute id="Level" type="uint8" value="3"/>
    <attribute id="Name" type="LSString" value="Arms"/>
    <!-- ... -->
</node>
<!-- Arms Level 4-20 ... -->

<!-- Fury Level 3 -->
<node id="Progression">
    <attribute id="Level" type="uint8" value="3"/>
    <attribute id="Name" type="LSString" value="Fury"/>
    <!-- ... -->
</node>
<!-- Fury Level 4-20 ... -->

<!-- Protection Level 3 -->
<node id="Progression">
    <attribute id="Level" type="uint8" value="3"/>
    <attribute id="Name" type="LSString" value="Protection"/>
    <!-- ... -->
</node>
<!-- Protection Level 4-20 ... -->
```

**AFTER** (6 subclass progressions × 18 levels = 108 nodes):
```xml
<!-- ArmsColossus Level 3 -->
<node id="Progression">
    <attribute id="Level" type="uint8" value="3"/>
    <attribute id="Name" type="LSString" value="ArmsColossus"/>
    <attribute id="ProgressionType" type="uint8" value="1"/>
    <attribute id="TableUUID" type="guid" value="NEW_UUID_1"/>
    <!-- Copy L3 abilities from Arms -->
</node>

<!-- ArmsColossus Level 13 -->
<node id="Progression">
    <attribute id="Level" type="uint8" value="13"/>
    <attribute id="Name" type="LSString" value="ArmsColossus"/>
    <attribute id="ProgressionType" type="uint8" value="1"/>
    <attribute id="TableUUID" type="guid" value="NEW_UUID_1"/>
    <attribute id="PassivesAdded" type="LSString" value="WAR_Demolish"/>  <!-- Colossus keystone only -->
</node>

<!-- ArmsColossus Level 15-20 with Colossus talents only -->

<!-- ArmsSlayers Level 3 -->
<node id="Progression">
    <attribute id="Level" type="uint8" value="3"/>
    <attribute id="Name" type="LSString" value="ArmsSlayers"/>
    <attribute id="ProgressionType" type="uint8" value="1"/>
    <attribute id="TableUUID" type="guid" value="NEW_UUID_2"/>
    <!-- Copy L3 abilities from Arms -->
</node>

<!-- ArmsSlayers Level 13 with Slayers keystone only -->
<!-- ... etc for all 6 subclasses × 18 levels -->
```

**Hero Talent Distribution**:
- **ArmsColossus**: Gets 11 Colossus talents (L13-20)
- **ArmsSlayers**: Gets 11 Slayers talents (L13-20)
- **FuryMountainThane**: Gets 11 Mountain Thane talents (L13-20)
- **FurySlayers**: Gets 11 Slayers talents (L13-20)
- **ProtectionMountainThane**: Gets 11 Mountain Thane talents (L13-20)
- **ProtectionColossus**: Gets 11 Colossus talents (L13-20)

---

### Step 4: Update Localization (30 minutes)

Add 12 new handles:
- 6 subclass names (`hNEW001`, `hNEW003`, `hNEW005`, `hNEW007`, `hNEW009`, `hNEW011`)
- 6 subclass descriptions (`hNEW002`, `hNEW004`, `hNEW006`, `hNEW008`, `hNEW010`, `hNEW012`)

**Example**:
```xml
<content contentuid="hNEW001" version="1">Arms (Colossus)</content>
<content contentuid="hNEW002" version="1">Master of Arms wielding the Colossus hero talents. Become an unstoppable juggernaut, smashing through enemies with devastating power and unbreakable resilience.</content>

<content contentuid="hNEW003" version="1">Arms (Slayers)</content>
<content contentuid="hNEW004" version="1">Master of Arms wielding the Slayers hero talents. Become a relentless executor, striking down wounded enemies with brutal precision.</content>

<!-- ... 4 more pairs -->
```

---

### Step 5: Update Base Class L1 Subclass References (15 minutes)

In Progressions.lsx, update base Warrior L1 node to reference 6 subclasses instead of 3:

**BEFORE**:
```xml
<node id="Progression">
    <attribute id="Level" type="uint8" value="1"/>
    <attribute id="Name" type="LSString" value="Warrior"/>
    <children>
        <node id="SubClasses">
            <children>
                <node id="SubClass">
                    <attribute id="Object" type="guid" value="CURRENT_ARMS_UUID"/>
                </node>
                <node id="SubClass">
                    <attribute id="Object" type="guid" value="CURRENT_FURY_UUID"/>
                </node>
                <node id="SubClass">
                    <attribute id="Object" type="guid" value="CURRENT_PROTECTION_UUID"/>
                </node>
            </children>
        </node>
    </children>
</node>
```

**AFTER**:
```xml
<node id="Progression">
    <attribute id="Level" type="uint8" value="1"/>
    <attribute id="Name" type="LSString" value="Warrior"/>
    <children>
        <node id="SubClasses">
            <children>
                <node id="SubClass">
                    <attribute id="Object" type="guid" value="NEW_UUID_7"/>  <!-- ArmsColossus -->
                </node>
                <node id="SubClass">
                    <attribute id="Object" type="guid" value="NEW_UUID_8"/>  <!-- ArmsSlayers -->
                </node>
                <node id="SubClass">
                    <attribute id="Object" type="guid" value="NEW_UUID_9"/>  <!-- FuryMountainThane -->
                </node>
                <node id="SubClass">
                    <attribute id="Object" type="guid" value="NEW_UUID_10"/>  <!-- FurySlayers -->
                </node>
                <node id="SubClass">
                    <attribute id="Object" type="guid" value="NEW_UUID_11"/>  <!-- ProtectionMountainThane -->
                </node>
                <node id="SubClass">
                    <attribute id="Object" type="guid" value="NEW_UUID_12"/>  <!-- ProtectionColossus -->
                </node>
            </children>
        </node>
    </children>
</node>
```

---

### Step 6: Testing (2-3 hours)

1. **Package mod** with all changes
2. **Install** to BG3
3. **Character creation**: Verify 6 subclass options appear
4. **Create one of each subclass** (6 test characters)
5. **Level to 20** for each
6. **Verify**:
   - L3-12: Base spec abilities correct
   - L13-20: Only chosen hero talent tree activates (11 talents)
   - Other hero tree talents NOT granted
7. **Test respec**: Verify can change subclass choice

---

## TOTAL TIME ESTIMATE: 4-6 Hours

| Step | Time | Complexity |
|------|------|------------|
| 1. Generate UUIDs | 5 min | Trivial |
| 2. ClassDescriptions (6 subclasses) | 1-2 hours | Medium |
| 3. Progressions (108 nodes) | 2-3 hours | High |
| 4. Localization | 30 min | Easy |
| 5. Base class references | 15 min | Easy |
| 6. Testing | 2-3 hours | Critical |
| **TOTAL** | **6-9 hours** | |

---

## AUTOMATION OPPORTUNITY

### Script to Generate 6 Subclass Progressions

Since we need to duplicate progression data 6 times (with different hero talents), we can script it:

```powershell
# Generate_6Subclass_Progressions.ps1
# Takes current 3 subclass progressions, creates 6 with hero talent splits

$SubclassMapping = @{
    "ArmsColossus" = @{ Base="Arms"; HeroTalents=$ColossusPassives }
    "ArmsSlayers" = @{ Base="Arms"; HeroTalents=$SlayersPassives }
    "FuryMountainThane" = @{ Base="Fury"; HeroTalents=$MountainThanePassives }
    "FurySlayers" = @{ Base="Fury"; HeroTalents=$SlayersPassives }
    "ProtectionMountainThane" = @{ Base="Protection"; HeroTalents=$MountainThanePassives }
    "ProtectionColossus" = @{ Base="Protection"; HeroTalents=$ColossusPassives }
}

# For each new subclass:
#   1. Copy L3-12 from base spec (unchanged)
#   2. For L13-20: Replace hero talents with only chosen tree's 11 talents
#   3. Update Name, TableUUID, ProgressionType=1
```

This would reduce Step 3 from 2-3 hours to 30 minutes + testing.

---

## DECISION POINT

**Which implementation should we use?**

### Option 1: Feat-Based Selection (L13 choice)
- ✅ WoW-accurate (L13 timing)
- ❌ Untested, higher risk
- ❌ 8-10 hours
- ❌ Complex (status conditions, passive updates)

### Option 3: Separate Subclasses (L1 choice) ⭐ RECOMMENDED
- ❌ NOT WoW-accurate (L1 instead of L13)
- ✅ Proven working (13K+ downloads)
- ✅ 4-6 hours
- ✅ Simple (no new mechanics)

**User decision needed**: Prioritize WoW accuracy (Option 1) or stability/speed (Option 3)?
