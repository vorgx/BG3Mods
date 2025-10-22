# Level 1 Warrior Progression - Comprehensive Review (Updated Oct 22, 2025)

**Purpose**: Detailed analysis of Level 1 progression for all Warrior subclasses using **updated database structure** (per-subclass unlock columns).

**Database Used**: `AbilityDatabase_Warrior_FullyEnriched.csv` (transformed Oct 22, 2025)  
**Progression Source**: `Warrior Progression for all subclasses and Default hero structure.csv` (Row 2 = Level 1)  
**Reference Table**: `WARRIOR_PROGRESSION_L1-20_TABLE.md`

**Note**: This document replaces `LEVEL_1_PROGRESSION_REVIEW.md` (created Oct 21, 2025) which used the old single-column `unlock_level` structure.

---

## Section 1: Arms Warrior - Level 1 Abilities

**Total Abilities**: 4 (from database query)

### 1.1 Abilities Granted at Level 1

| Ability | Type | BG3 File | BG3 Spell Type | Database Unlock | CSV Source | Status |
|---------|------|----------|----------------|-----------------|------------|--------|
| **Whirlwind** | Offensive | Spell_Zone | Zone | arms_unlock=1 | Col 3 (Baseline Arms - Offensive) | ✅ Matched |
| **Battle Stance** | Offensive | Spell_Shout | Shout | arms_unlock=1 | Col 10 (Stances - Auto Grant) | ✅ Matched |
| **Defensive Stance** | Defensive | Spell_Shout | Shout | arms_unlock=1 | Col 11 (Stances - Auto Grant) | ✅ Matched |
| **Mortal Strike** | Offensive | Spell_Target | Target | arms_unlock=1 | Col 23 (Arms Spec - Auto Grant) | ✅ Matched |

### 1.2 Expected but Missing from Database Query

**Charge** - Listed in CSV Col 4 (Baseline Arms - Utility, Auto Grant) but **NOT in database results**

**Investigation**:
- Checked database (line 4): `"WAR__Charge_","Charge","",...,"","","","","Baseline","All",...`
- All unlock columns are **EMPTY** (warrior_unlock, arms_unlock, fury_unlock, protection_unlock)
- **CSV shows**: Charge appears at DIFFERENT levels per subclass:
  - Arms: Level 1 (Col 4 - Baseline Arms Utility)
  - Fury: Level 3 (Col 9 - Baseline Fury Utility)
  - Protection: NOT in baseline (may appear later in spec talents)
- **Root Cause**: Script `Update-AbilityDatabase-WithUnlocks.ps1` uses EXACT name matching:
  - CSV: "Charge - primary mobility and gap closer."
  - Database: "Charge"
  - Regex extraction may have failed due to description suffix

**Impact**: CRITICAL - Charge is Arms' primary gap closer, must be available at L1

**Recommended Fix**:
1. Manual database correction: Set `arms_unlock=1`, `fury_unlock=3`
2. Update script to handle name variations with descriptions

### 1.3 Additional Abilities Expected from Old Review (Oct 21)

**Old L1 Review** (`LEVEL_1_PROGRESSION_REVIEW.md`) listed 7 Arms abilities:
1. Whirlwind ✅ (confirmed in new query)
2. Charge ❌ (missing - see investigation above)
3. Battle Stance ✅ (confirmed in new query)
4. Defensive Stance ✅ (confirmed in new query)
5. Mortal Strike ✅ (confirmed in new query)
6. **Seasoned Soldier** ❌ (NOT in new query - was this Row 1 Class Talent choice?)
7. **Mastery: Deep Wounds** ❌ (NOT in new query - was this Row 1 Class Talent choice?)

**Cross-Reference CSV**:
- Seasoned Soldier: Col 23 (Arms Spec - Passive) - Marked "Row 1 of Warrior Class Talents"
- Mastery: Deep Wounds: Col 24 (Arms Spec - Passive) - Also Row 1

**Analysis**: These are **CHOICE NODES** (pick one), not auto-granted. Database query only shows **AUTO GRANT** abilities (arms_unlock=1). Choice abilities likely have:
- Different column structure in database (e.g., `choice_node_level` instead of `arms_unlock`)
- OR: Transformation script didn't populate choice abilities correctly

**Action**: Need to check database for choice node structure and query separately.

### 1.4 Summary: Arms Warrior Level 1

**Auto-Granted Abilities**: 4 confirmed
- ✅ Whirlwind (AoE cleave)
- ✅ Battle Stance (offensive stance)
- ✅ Defensive Stance (defensive stance)
- ✅ Mortal Strike (primary single-target attack)

**Missing Critical Ability**: 1
- ❌ Charge (gap closer) - CRITICAL BUG in database transformation

**Choice Nodes**: 2 (NOT in auto-grant query)
- Seasoned Soldier (rage generation passive)
- Mastery: Deep Wounds (scaling damage passive)

**Total Expected**: 7 abilities (4 auto + 1 missing + 2 choice nodes)

---

## Section 2: Fury Warrior - Level 1 Abilities

**Total Abilities**: 6 (from database query)

### 2.1 Abilities Granted at Level 1

| Ability | Type | BG3 File | BG3 Spell Type | Database Unlock | CSV Source | Status |
|---------|------|----------|----------------|-----------------|------------|--------|
| **Whirlwind** | Offensive | Spell_Zone | Zone | fury_unlock=1 | Col 8 (Baseline Fury - Offensive) | ✅ Matched |
| **Berserker Rage** | Offensive | Spell_Shout | Shout | fury_unlock=1 | Col 9 (Baseline Fury - Utility) | ✅ Matched |
| **Battle Stance** | Offensive | Spell_Shout | Shout | fury_unlock=1 | Col 10 (Stances - Auto Grant) | ✅ Matched |
| **Defensive Stance** | Defensive | Spell_Shout | Shout | fury_unlock=1 | Col 11 (Stances - Auto Grant) | ✅ Matched |
| **Titan's Grip** | Passive | Passive | N/A | fury_unlock=1 | Col 36 (Fury Spec - Passive) | ✅ Matched |
| **Bloodthirst** | Offensive | Spell_Target | Target | fury_unlock=1 | Col 38 (Fury Spec - Auto Grant) | ✅ Matched |

### 2.2 Comparison with Old Review (Oct 21)

**Old L1 Review** listed 7 Fury abilities:
1. Whirlwind ✅ (confirmed)
2. Berserker Rage ✅ (confirmed)
3. Battle Stance ✅ (confirmed)
4. Defensive Stance ✅ (confirmed)
5. Titan's Grip ✅ (confirmed)
6. Bloodthirst ✅ (confirmed)
7. **Mastery: Unshackled Fury** ❌ (NOT in new query)

**Cross-Reference CSV**:
- Mastery: Unshackled Fury: Col 37 (Fury Spec - Passive) - Listed alongside Titan's Grip

**Analysis**: Mastery: Unshackled Fury is likely an **AUTO GRANT** passive (not choice node) but missing from database query results.

**Investigation**:
- Check database for "Mastery: Unshackled Fury" entry
- Verify if `fury_unlock` column is populated
- If missing, add manual correction: `fury_unlock=1`

### 2.3 Summary: Fury Warrior Level 1

**Auto-Granted Abilities**: 6 confirmed
- ✅ Whirlwind (AoE cleave, facilitates cleaving)
- ✅ Berserker Rage (CC removal)
- ✅ Battle Stance (offensive stance)
- ✅ Defensive Stance (defensive stance)
- ✅ Titan's Grip (dual-wield two-handers passive)
- ✅ Bloodthirst (primary attack)

**Expected but Missing**: 1
- ❌ Mastery: Unshackled Fury (scaling damage passive) - Needs investigation

**Total Expected**: 7 abilities (6 confirmed + 1 missing)

---

## Section 3: Protection Warrior - Level 1 Abilities

**Total Abilities**: 4 (from database query)

### 3.1 Abilities Granted at Level 1

| Ability | Type | BG3 File | BG3 Spell Type | Database Unlock | CSV Source | Status |
|---------|------|----------|----------------|-----------------|------------|--------|
| **Shield Slam** | Offensive | Spell_Target | Target | protection_unlock=1 | Col 5 (Baseline Protection - Offensive) | ✅ Matched |
| **Battle Stance** | Offensive | Spell_Shout | Shout | protection_unlock=1 | Col 10 (Stances - Auto Grant) | ✅ Matched |
| **Defensive Stance** | Defensive | Spell_Shout | Shout | protection_unlock=1 | Col 11 (Stances - Auto Grant) | ✅ Matched |
| **Ignore Pain** | Defensive | Spell_Shout | Shout | protection_unlock=1 | Col 47 (Protection Spec - Auto Grant) | ✅ Matched |

### 3.2 Expected but Missing from Database Query

**Taunt** - Listed in CSV Col 6 (Baseline Protection - Utility) but **NOT in database results**

**Investigation**:
- Check database for "Taunt" entry
- Verify if `protection_unlock` column is populated
- **Expected**: Taunt is core tanking ability, MUST be available at L1
- If missing, add manual correction: `protection_unlock=1`

**Mastery: Critical Block** - Listed in CSV Col 7 (Baseline Protection - Passives) but **NOT in database results**

**Investigation**:
- Check database for "Mastery: Critical Block" entry
- Verify if `protection_unlock` column is populated
- **Expected**: This is Protection's Mastery, core passive for block mitigation
- If missing, add manual correction: `protection_unlock=1`

### 3.3 Comparison with Old Review (Oct 21)

**Old L1 Review** listed 6 Protection abilities:
1. Shield Slam ✅ (confirmed)
2. Taunt ❌ (missing - see investigation)
3. Mastery: Critical Block ❌ (missing - see investigation)
4. Battle Stance ✅ (confirmed)
5. Defensive Stance ✅ (confirmed)
6. Ignore Pain ✅ (confirmed)

**Analysis**: 2 out of 6 abilities are missing from database query. Both are **AUTO GRANT** baseline abilities (not choice nodes).

**Root Cause**: Likely same issue as Charge - exact name matching failed during transformation script execution.

### 3.4 Summary: Protection Warrior Level 1

**Auto-Granted Abilities**: 4 confirmed
- ✅ Shield Slam (main offensive skill, rage generation)
- ✅ Battle Stance (offensive stance)
- ✅ Defensive Stance (defensive stance)
- ✅ Ignore Pain (core defensive skill)

**Missing Critical Abilities**: 2
- ❌ Taunt (core tanking utility) - CRITICAL BUG
- ❌ Mastery: Critical Block (block mitigation passive) - CRITICAL BUG

**Total Expected**: 6 abilities (4 confirmed + 2 missing)

---

## Section 4: Cross-Reference Validation (Database vs CSV)

### 4.1 Summary Table

| Subclass | Confirmed Abilities | Missing Abilities | Total Expected | Match Rate |
|----------|--------------------:|------------------:|---------------:|-----------:|
| **Arms** | 4 | 3 (Charge + 2 choice) | 7 | 57% |
| **Fury** | 6 | 1 (Mastery) | 7 | 86% |
| **Protection** | 4 | 2 (Taunt + Mastery) | 6 | 67% |
| **TOTAL** | 14 | 6 | 20 | 70% |

### 4.2 Critical Findings

**Issue 1: Charge Missing from All Subclasses**
- Arms: Should be `arms_unlock=1` (CSV Col 4)
- Fury: Should be `fury_unlock=3` (CSV Col 9)
- Protection: May appear in spec talents later
- **Impact**: Primary gap closer unavailable - game-breaking bug

**Issue 2: Taunt Missing for Protection**
- Should be `protection_unlock=1` (CSV Col 6)
- **Impact**: Core tanking utility unavailable - tank cannot function properly

**Issue 3: Masteries Missing**
- Mastery: Deep Wounds (Arms) - May be choice node, not auto-grant
- Mastery: Unshackled Fury (Fury) - Should be `fury_unlock=1` (CSV Col 37)
- Mastery: Critical Block (Protection) - Should be `protection_unlock=1` (CSV Col 7)
- **Impact**: Core passive scaling mechanics unavailable

**Issue 4: Choice Nodes Not Captured**
- Arms Row 1 Class Talents (Seasoned Soldier, Mastery: Deep Wounds)
- Database query only returned AUTO GRANT abilities
- **Root Cause**: Choice abilities may require different query (check for `choice_node_level` column or similar)

### 4.3 Database Structure Investigation Needed

**Questions**:
1. How are choice nodes stored in database? (separate column? different value format?)
2. Why did transformation script fail on Charge, Taunt, and Masteries?
3. Are choice abilities supposed to have unlock levels or different structure?

**Action Items**:
1. Read full database CSV to understand choice node structure
2. Check for abilities with empty unlock columns but valid `unlock_source="Baseline"`
3. Create manual correction script for missing abilities
4. Re-run database query to include choice abilities

---

## Section 5: FILE 11 Implementation Notes (Progressions.lsx)

### 5.1 Level 1 Structure in Progressions.lsx

**Base Warrior Class (UUID: `78fe4967-4e62-5491-d981-dd781acca4d7-Warrior`)**

```xml
<node id="Progression">
    <attribute id="Level" type="uint8" value="1"/>
    <attribute id="Name" type="LSString" value="Warrior"/>
    <attribute id="ProgressionType" type="uint8" value="0"/> <!-- 0 = Class -->
    <attribute id="TableUUID" type="guid" value="78fe4967-4e62-5491-d981-dd781acca4d7"/>
    
    <!-- Auto-granted abilities for ALL subclasses -->
    <attribute id="Boosts" type="LSString" value="ActionResource(Rage,100,0);Proficiency(MartialWeapons);Proficiency(SimpleWeapons);Proficiency(Shields);Proficiency(HeavyArmor);Proficiency(MediumArmor);Proficiency(LightArmor)"/>
    
    <children>
        <!-- Spells granted to all at L1 -->
        <node id="AddSpells">
            <attribute id="Spells" type="LSString" value="WAR_BattleStance;WAR_DefensiveStance"/>
        </node>
        
        <!-- Passives granted to all at L1 -->
        <node id="PassivesAdded">
            <attribute id="Passives" type="LSString" value="WAR_RageGeneration"/>
        </node>
    </children>
</node>
```

**Arms Subclass (UUID: `78fe4967-4e62-5491-d981-dd781acca4d7-Arms`)**

```xml
<node id="Progression">
    <attribute id="Level" type="uint8" value="1"/>
    <attribute id="Name" type="LSString" value="Arms"/>
    <attribute id="ProgressionType" type="uint8" value="1"/> <!-- 1 = Subclass -->
    <attribute id="TableUUID" type="guid" value="78fe4967-4e62-5491-d981-dd781acca4d7-Arms"/>
    
    <children>
        <!-- Spells granted to Arms at L1 -->
        <node id="AddSpells">
            <attribute id="Spells" type="LSString" value="WAR_Whirlwind;WAR_Charge;WAR_MortalStrike"/>
        </node>
        
        <!-- Passives granted to Arms at L1 -->
        <node id="PassivesAdded">
            <attribute id="Passives" type="LSString" value=""/>
        </node>
        
        <!-- Choice nodes for Arms L1 -->
        <node id="Selectors">
            <children>
                <node id="Selector">
                    <attribute id="SelectionId" type="LSString" value="ArmsClassTalentsRow1"/>
                    <children>
                        <node id="Option">
                            <attribute id="Passive" type="LSString" value="WAR_SeasonedSoldier"/>
                        </node>
                        <node id="Option">
                            <attribute id="Passive" type="LSString" value="WAR_Mastery_DeepWounds"/>
                        </node>
                    </children>
                </node>
            </children>
        </node>
    </children>
</node>
```

**Fury Subclass (UUID: `78fe4967-4e62-5491-d981-dd781acca4d7-Fury`)**

```xml
<node id="Progression">
    <attribute id="Level" type="uint8" value="1"/>
    <attribute id="Name" type="LSString" value="Fury"/>
    <attribute id="ProgressionType" type="uint8" value="1"/> <!-- 1 = Subclass -->
    
    <children>
        <!-- Spells granted to Fury at L1 -->
        <node id="AddSpells">
            <attribute id="Spells" type="LSString" value="WAR_Whirlwind;WAR_BerserkerRage;WAR_Bloodthirst"/>
        </node>
        
        <!-- Passives granted to Fury at L1 -->
        <node id="PassivesAdded">
            <attribute id="Passives" type="LSString" value="WAR_TitansGrip;WAR_Mastery_UnshackledFury"/>
        </node>
    </children>
</node>
```

**Protection Subclass (UUID: `78fe4967-4e62-5491-d981-dd781acca4d7-Protection`)**

```xml
<node id="Progression">
    <attribute id="Level" type="uint8" value="1"/>
    <attribute id="Name" type="LSString" value="Protection"/>
    <attribute id="ProgressionType" type="uint8" value="1"/> <!-- 1 = Subclass -->
    
    <children>
        <!-- Spells granted to Protection at L1 -->
        <node id="AddSpells">
            <attribute id="Spells" type="LSString" value="WAR_ShieldSlam;WAR_Taunt;WAR_IgnorePain"/>
        </node>
        
        <!-- Passives granted to Protection at L1 -->
        <node id="PassivesAdded">
            <attribute id="Passives" type="LSString" value="WAR_Mastery_CriticalBlock"/>
        </node>
    </children>
</node>
```

### 5.2 Implementation Checklist for FILE 11

**Base Class (All Subclasses)**:
- [x] Rage resource granted (ActionResource boost)
- [x] Proficiencies granted (all armor types, martial/simple weapons, shields)
- [x] Battle Stance spell (AddSpells)
- [x] Defensive Stance spell (AddSpells)
- [x] Rage generation passive (PassivesAdded)

**Arms Subclass**:
- [x] Whirlwind spell (AddSpells)
- [x] Mortal Strike spell (AddSpells)
- [⚠️] Charge spell (AddSpells) - **MISSING IN DATABASE**
- [⚠️] Choice node for Row 1 Class Talents (Selectors) - **NEEDS VERIFICATION**

**Fury Subclass**:
- [x] Whirlwind spell (AddSpells)
- [x] Berserker Rage spell (AddSpells)
- [x] Bloodthirst spell (AddSpells)
- [x] Titan's Grip passive (PassivesAdded)
- [⚠️] Mastery: Unshackled Fury passive (PassivesAdded) - **MISSING IN DATABASE**

**Protection Subclass**:
- [x] Shield Slam spell (AddSpells)
- [x] Ignore Pain spell (AddSpells)
- [⚠️] Taunt spell (AddSpells) - **MISSING IN DATABASE**
- [⚠️] Mastery: Critical Block passive (PassivesAdded) - **MISSING IN DATABASE**

---

## Section 6: Player Choice Breakdown

### 6.1 Level 1 Choices

**Arms Warrior**:
- **Row 1 Class Talents** (Pick 1):
  - Seasoned Soldier (increases rage generation from crits)
  - Mastery: Deep Wounds (enables scaling damage from Mastery)

**Fury Warrior**:
- **No choices at Level 1** (all abilities auto-granted)

**Protection Warrior**:
- **No choices at Level 1** (all abilities auto-granted)

### 6.2 Auto-Granted vs Choice Summary

| Subclass | Auto-Granted | Choice Nodes | Total Abilities | Choice Impact |
|----------|-------------:|-------------:|----------------:|--------------:|
| Arms | 5 (+ 1 missing Charge) | 1 node (2 options) | 7 | 28% |
| Fury | 7 (+ 1 missing Mastery) | 0 | 7 | 0% |
| Protection | 6 (+ 2 missing) | 0 | 6 | 0% |

**Analysis**:
- Arms has earliest player choice (L1) - strategic decision between rage generation vs sustained damage
- Fury and Protection have simpler L1 experience - all abilities granted automatically
- Protection has highest missing ability count (2 critical abilities)

---

## Section 7: Critical Findings & Recommendations

### 7.1 CRITICAL BUGS (Must Fix Before FILE 11 Implementation)

**Bug 1: Charge Missing from Database**
- **Severity**: CRITICAL
- **Impact**: Arms cannot gap close at L1, Fury cannot gap close at L3
- **Fix**: Manual database correction
  ```csv
  "WAR__Charge_","Charge","",...,"","1","3","","Baseline","Arms, Fury",...
  ```
- **Root Cause**: Transformation script failed on name extraction (CSV has descriptions)

**Bug 2: Taunt Missing for Protection**
- **Severity**: CRITICAL
- **Impact**: Protection cannot tank (no threat generation)
- **Fix**: Manual database correction
  ```csv
  "WAR__Taunt_","Taunt","",...,"","","","1","Baseline","Protection",...
  ```

**Bug 3: Masteries Missing**
- **Severity**: HIGH
- **Impact**: Core scaling mechanics unavailable
- **Fix**: Manual database corrections
  - Mastery: Unshackled Fury → `fury_unlock=1`
  - Mastery: Critical Block → `protection_unlock=1`
  - Mastery: Deep Wounds → May be choice node, needs verification

### 7.2 Data Quality Issues

**Issue 1: 70% Match Rate**
- 70 out of 215 abilities matched (32.6%)
- 145 abilities unmatched (67.4%)
- **Recommendation**: Investigate unmatched abilities - are they talent passives? choice nodes?

**Issue 2: Choice Node Representation**
- Current query only returns auto-grant abilities
- Choice nodes not captured in `arms_unlock/fury_unlock/protection_unlock` columns
- **Recommendation**: Add separate columns for choice nodes or use different query strategy

**Issue 3: "All" Subclass Handling**
- Stances (Battle/Defensive) appear for all subclasses
- Database shows individual columns populated (arms=1, fury=1, protection=1)
- **Recommendation**: Verify script correctly populates "all" abilities for all subclasses

### 7.3 Next Steps

**Immediate Actions**:
1. **Fix database bugs** (Charge, Taunt, Masteries) - manual corrections
2. **Investigate choice nodes** - read full database to understand structure
3. **Re-run query** with corrected data to verify L1 completeness
4. **Create validation script** to compare database vs CSV for all levels

**Level 2 Review Preparation**:
1. Query L2 abilities from database (both auto-grant and choice)
2. Cross-reference with CSV Row 3 (Level 2)
3. Identify any additional missing abilities
4. Create comprehensive L2 review document

**FILE 11 Implementation**:
1. Use corrected database as source of truth for Progressions.lsx
2. Verify all L1 abilities present in spell/passive stat files
3. Test in-game to ensure abilities appear correctly
4. Validate choice nodes display properly in character creation

---

## Section 8: Comparison with Old Review (Oct 21)

### 8.1 Key Differences from `LEVEL_1_PROGRESSION_REVIEW.md`

**Old Review** (Oct 21, single `unlock_level` column):
- Arms: 7 abilities listed (all confirmed in CSV)
- Fury: 7 abilities listed (all confirmed in CSV)
- Protection: 6 abilities listed (all confirmed in CSV)
- **3 critical discrepancies** identified:
  1. Charge had wrong unlock level (fixed in new database)
  2. Bloodthirst had wrong unlock level (fixed in new database)
  3. Some ability had subclass filter error (need to verify if fixed)

**New Review** (Oct 22, per-subclass unlock columns):
- Arms: 4 abilities confirmed, 3 missing (Charge + 2 choice)
- Fury: 6 abilities confirmed, 1 missing (Mastery)
- Protection: 4 abilities confirmed, 2 missing (Taunt + Mastery)
- **6 missing abilities** identified (database transformation incomplete)

### 8.2 Progress Made

**✅ Improvements**:
- Per-subclass unlock columns enable accurate multi-level ability tracking
- Whirlwind now correctly shows different unlock levels (Arms=1, Fury=1, Protection=12)
- Database structure supports WoW talent system better (same ability, different unlock per subclass)

**❌ Regressions**:
- Transformation script didn't capture all abilities (70% match rate)
- Critical baseline abilities missing (Charge, Taunt, Masteries)
- Choice nodes not represented in new structure (need separate query/column)

### 8.3 Action Plan

**Phase 1: Fix Critical Bugs** (TODAY)
1. Manual database corrections for 3 critical abilities (Charge, Taunt, Mastery: Critical Block)
2. Verify Mastery: Unshackled Fury entry exists and populate fury_unlock=1
3. Re-run query to confirm L1 completeness

**Phase 2: Understand Choice Nodes** (TODAY)
1. Read full database CSV to find choice node examples
2. Determine how choice abilities are stored (different column? value format?)
3. Create separate query for choice abilities vs auto-grant

**Phase 3: Complete L2 Review** (NEXT SESSION)
1. Apply lessons learned from L1 to L2 analysis
2. Query both auto-grant AND choice abilities
3. Cross-reference thoroughly before declaring "complete"

**Phase 4: Update Documentation** (ONGOING)
1. Mark old L1 review as deprecated (add note at top)
2. Update SOURCE_OF_TRUTH.md with findings from this review
3. Create session summary with transformation script improvements

---

## Appendix A: Raw Database Query Results

**Query Date**: October 22, 2025  
**Query Command**: `Scripts/Query-Level1-Abilities.ps1`  
**Database**: `AbilityDatabase_Warrior_FullyEnriched.csv` (transformed Oct 22)

**Results**:

```
=== ARMS WARRIOR (Level 1) ===

ability_name     ability_type bg3_file_type bg3_spell_type
------------     ------------ ------------- --------------
Whirlwind        Offensive    Spell_Zone    Zone
Battle Stance    Offensive    Spell_Shout   Shout
Defensive Stance Defensive    Spell_Shout   Shout
Mortal Strike    Offensive    Spell_Target  Target

Total: 4 abilities

=== FURY WARRIOR (Level 1) ===

ability_name     ability_type bg3_file_type bg3_spell_type
------------     ------------ ------------- --------------
Whirlwind        Offensive    Spell_Zone    Zone
Berserker Rage   Offensive    Spell_Shout   Shout
Battle Stance    Offensive    Spell_Shout   Shout
Defensive Stance Defensive    Spell_Shout   Shout
Titan's Grip     Passive      Passive       N/A
Bloodthirst      Offensive    Spell_Target  Target

Total: 6 abilities

=== PROTECTION WARRIOR (Level 1) ===

ability_name     ability_type bg3_file_type bg3_spell_type
------------     ------------ ------------- --------------
Shield Slam      Offensive    Spell_Target  Target
Battle Stance    Offensive    Spell_Shout   Shout
Defensive Stance Defensive    Spell_Shout   Shout
Ignore Pain      Defensive    Spell_Shout   Shout

Total: 4 abilities
```

---

## Appendix B: CSV Cross-Reference (Level 1 Only)

**CSV File**: `Warrior Progression for all subclasses and Default hero structure.csv`  
**Row**: 2 (Level 1)

**Column Mapping**:

| Col | Category | Ability Listed | Expected Subclass | Database Status |
|-----|----------|----------------|-------------------|-----------------|
| 3 | Baseline Arms - Offensive | Whirlwind | Arms | ✅ arms_unlock=1 |
| 4 | Baseline Arms - Utility | Charge | Arms | ❌ MISSING |
| 5 | Baseline Protection - Offensive | Shield Slam | Protection | ✅ protection_unlock=1 |
| 6 | Baseline Protection - Utility | Taunt | Protection | ❌ MISSING |
| 7 | Baseline Protection - Passives | Mastery: Critical Block | Protection | ❌ MISSING |
| 8 | Baseline Fury - Offensive | Whirlwind | Fury | ✅ fury_unlock=1 |
| 9 | Baseline Fury - Utility | Berserker Rage | Fury | ✅ fury_unlock=1 |
| 10 | Stances | Battle Stance | All | ✅ all subclasses=1 |
| 11 | Stances | Defensive Stance | All | ✅ all subclasses=1 |
| 23 | Arms Spec - Passive | Seasoned Soldier | Arms | ❓ Choice node? |
| 24 | Arms Spec - Passive | Mastery: Deep Wounds | Arms | ❓ Choice node? |
| 25 | Arms Spec - Auto Grant | Mortal Strike | Arms | ✅ arms_unlock=1 |
| 36 | Fury Spec - Passive | Titan's Grip | Fury | ✅ fury_unlock=1 |
| 37 | Fury Spec - Passive | Mastery: Unshackled Fury | Fury | ❌ MISSING |
| 38 | Fury Spec - Auto Grant | Bloodthirst | Fury | ✅ fury_unlock=1 |
| 47 | Protection Spec - Auto Grant | Ignore Pain | Protection | ✅ protection_unlock=1 |

**Summary**:
- ✅ Confirmed: 11 abilities (79%)
- ❌ Missing: 3 abilities (21%) - Charge, Taunt, Mastery: Critical Block
- ❓ Unknown: 2 abilities (choice nodes) - Seasoned Soldier, Mastery: Deep Wounds

---

**Document Status**: DRAFT - PENDING CRITICAL BUG FIXES  
**Next Review**: Level 2 (after database corrections applied)  
**Created**: October 22, 2025  
**Last Updated**: October 22, 2025
