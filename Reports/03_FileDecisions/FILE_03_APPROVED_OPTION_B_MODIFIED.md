# FILE 3 DECISION: Option B (Modified) - APPROVED

**Date**: October 18, 2025  
**Decision**: ✅ **OPTION B - Rage + 5 Charges** (with Overpower modification)  
**Status**: 🚀 READY TO IMPLEMENT  
**Estimated Time**: 4-6 hours

---

## ✅ APPROVED CONFIGURATION

### Resources to Implement (6 Total)

| # | Resource Name | Max | Replenish | Used By | Purpose |
|---|---------------|-----|-----------|---------|---------|
| **1** | **Rage** | 100 | Never | All abilities | Primary resource (KEEP from backup) |
| **2** | **DefensiveCharge** | 1 | Rest | Die by the Sword, Berserker Rage | Emergency defense |
| **3** | **TankCooldown** | 1 | Rest | Last Stand, Shield Wall, Indomitable | Ultimate survival |
| **4** | **MobilityCharge** | 2 | ShortRest | Heroic Leap, Intervene, Storm Bolt | Positioning/utility |
| **5** | **OverpowerCharge** ⚠️ | 2 | Never (proc) | Overpower (Arms) | Reactive damage |
| **6** | **ThunderCharge** | 3 | Never (proc) | Thunder Clap (Mountain Thane) | Scaling AoE |

---

## ⚠️ CRITICAL MODIFICATION: Overpower Proc Limit

**User Requirement**: **Overpower proc can only happen ONCE PER TURN**

**Implementation Notes**:
```
// In Passive.txt - Overpower proc passive
data "StatsFunctorContext" "OnAttackTarget"
data "Conditions" "AttackRollFailed() and not IsCriticalMiss() and not TurnBased(SG_OverpowerProcThisTurn)"
data "StatsFunctors" "RestoreResource(SELF,OverpowerCharge,1,0);ApplyStatus(SELF,SG_OverpowerProcThisTurn,100,1)"

// Add new status to track "already procced this turn"
// Status_BOOST.txt
new entry "SG_OverpowerProcThisTurn"
type "StatusData"
data "StatusType" "BOOST"
data "StackId" "SG_OverpowerProcThisTurn"
data "StatusPropertyFlags" "DisableCombatlog;DisableOverhead;DisablePortraitIndicator"
data "RemoveEvents" "OnTurnEnded"
```

**Why This Matters**:
- ✅ Prevents spam: Can't get 5 Overpower charges in one turn from missing 5 attacks
- ✅ Balanced: 1 proc per turn = max 2 charges every 2 turns (not 2 charges in 1 turn)
- ✅ Predictable: Players know "I get 1 proc per turn max"

**Remember for Future**:
- When implementing FILES 4-10 (Spell files), ensure Overpower proc has turn-based limit
- When implementing FILE 11 (Passives), add turn-tracking status
- Document this in all Overpower-related sections

---

## 📋 CHARGE-MODIFYING TALENTS (Implementation Plan)

### Existing Talents to Enhance (7 Total)

| Talent | Level | Spec | Current Effect | Charge Enhancement |
|--------|-------|------|----------------|-------------------|
| **Earthquaker** | L17 | Colossus | Reduces Shockwave cooldown | +1 MobilityCharge on 3+ targets hit |
| **Tide of Battle** | L19 | Colossus | Reduces Revenge cooldown + damage | Increase TankCooldown max 1→2 at 5 stacks |
| **Gathering Storms** | L20 | Mountain Thane | Restores Rage on lightning | Increase ThunderCharge cap 3→5 |
| **Thunder Blast** | L17 | Mountain Thane | 35% proc on Shield Slam | Crits guarantee +1 ThunderCharge (100% on crit) |
| **Opportunist** | L17 | Slayer | Reduces Execute cooldown on crit | Refund 1 DefensiveCharge on marked crit |
| **Overwhelming Blades** | L15 | Slayer | Grants buff on Execute kill | Refund 1 MobilityCharge on Execute kill |
| **Overpower Proc** | L3 | Arms | Grants proc on dodge | ⚠️ **MAX ONCE PER TURN** + crit miss = double charge |

**Implementation Priority**: 
- 🟢 **LOW** (Phase 2) - These are enhancements, not blockers
- Implement in FILE 11 (Passives) transformation
- Test each talent modification separately

---

### New Talents to Add (9 Total - Future Expansion)

| Talent | Suggested Level | Spec | Effect |
|--------|----------------|------|--------|
| **Relentless Assault** | L15-L17 | All | +1 max MobilityCharge (2→3 total) |
| **Battle Hardened** | L13-L15 | All | DefensiveCharge refills on ShortRest (not Rest) |
| **Second Wind** | L17-L19 | All | Killing blows refund 1 DefensiveCharge |
| **Tactical Mastery** | L13 | All | Start combat with +1 MobilityCharge (bonus) |
| **Storm Caller** | L20 | Mountain Thane | ThunderCharge cap +2 (3→5, stacks with Gathering Storms) |
| **Critical Momentum** | L15-L17 | Arms | Crits grant +1 OverpowerCharge (bypasses once-per-turn limit) |
| **Unstoppable Force** | L19 | Protection | +1 max TankCooldown (1→2) at 50% HP |
| **Lightning Reflexes** | L17 | Mountain Thane | ThunderCharge generation +10% (35%→45%) |
| **Executioner's Focus** | L19 | Arms/Fury | Execute casts reduce all charge cooldowns by 1 turn |

**Implementation Priority**: 
- 🟡 **MEDIUM** (Phase 3) - Post-launch enhancements
- Add in future updates (v1.1.0+)
- Requires talent tree expansion

---

## 🎯 FILE 3 TRANSFORMATION STEPS

### Step 1: Backup Current File ✅
- Already backed up at: `Tests\WARRIOR_BACKUP_BEFORE_TEMPLATE_20251018_183829\Public\BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7\ActionResourceDefinitions\ActionResourceDefinitions.lsx`

### Step 2: Transform ActionResourceDefinitions.lsx
**File**: `Data\Public\Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7\ActionResourceDefinitions\ActionResourceDefinitions.lsx`

**Actions**:
1. Keep XML structure from Warlock template
2. Delete 9 Warlock resources (keep only first node as template)
3. Add 6 Warrior resources:
   - Rage (from backup UUID: `a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d`)
   - DefensiveCharge (new UUID)
   - TankCooldown (new UUID)
   - MobilityCharge (new UUID)
   - OverpowerCharge (new UUID)
   - ThunderCharge (new UUID)
4. Keep localization handles (will update in FILE 12)

### Step 3: Create Test Script
**File**: `Documentation\08_TransformationTemplates\Tests\Test-ActionResourceDefinitions.ps1`

**Validations**:
- ✅ File exists
- ✅ XML parses successfully
- ✅ Exactly 6 resources found
- ✅ Rage resource present with correct UUID
- ✅ All 5 charges present with correct max values
- ✅ All replenish types correct
- ✅ All UUIDs valid and unique

### Step 4: Run All Tests
```powershell
.\Documentation\08_TransformationTemplates\Tests\Test-AllFiles.ps1 -ModPath "Data"
```
**Expected**: 3/3 tests passing (FILE 1, 2, 3)

### Step 5: Document Template
**File**: `Documentation\08_TransformationTemplates\FILE_03_ActionResourceDefinitions.lsx_TEMPLATE.md`

**Contents**:
- Side-by-side comparison (Warlock vs Warrior)
- Transformation notes
- Charge resource details
- Overpower proc limit documentation
- Future talent modifications list

### Step 6: Create Session Report
**File**: `Documentation\05_SessionReports\FILE_03_TRANSFORMATION_COMPLETE.md`

**Contents**:
- What was changed
- Test results
- Known issues (dummy localization handles)
- Next steps (FILE 4)

---

## 📝 IMPLEMENTATION NOTES

### UUID Generation Strategy
- **Rage**: Use existing UUID from backup (`a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d`)
- **5 Charges**: Generate new UUIDs (use online UUID generator or PowerShell)

```powershell
# Generate 5 new UUIDs
1..5 | ForEach-Object { [guid]::NewGuid().ToString() }
```

### Localization Handles Strategy
- **Keep Warlock handles** for now (FILE 12 will update them)
- Update DisplayName/Description text in FILE 12 transformation
- No text changes in FILE 3 (just resource mechanics)

### Replenish Types
- `Never`: Combat-generated only (Rage, OverpowerCharge, ThunderCharge)
- `Rest`: Long Rest (DefensiveCharge, TankCooldown)
- `ShortRest`: Short Rest (MobilityCharge)

---

## ⚠️ KNOWN ISSUES TO FIX LATER

1. **Dummy Localization** (FILE 2 & FILE 3)
   - Using Warlock handles currently
   - Will replace in FILE 12 transformation

2. **Overpower Proc Limit** (FILE 11)
   - Needs turn-tracking status
   - Implement when transforming Passive.txt

3. **Talent Modifications** (FILE 11)
   - 7 existing talents need charge enhancements
   - Implement as Phase 2 after base transformation

4. **Spell Cost Updates** (FILES 4-10)
   - 8 abilities need to change from cooldowns to charges
   - Implement during spell file transformation

---

## 🎯 SUCCESS CRITERIA

- [ ] ActionResourceDefinitions.lsx has 6 resources (Rage + 5 charges)
- [ ] Rage has correct UUID from backup
- [ ] All 5 charges have unique UUIDs
- [ ] All max values correct (1, 1, 2, 2, 3)
- [ ] All replenish types correct (Never, Rest, ShortRest)
- [ ] Test-ActionResourceDefinitions.ps1 created
- [ ] All 3 tests passing (FILE 1, 2, 3)
- [ ] Template documentation created
- [ ] Session report created
- [ ] Overpower proc limit documented for future

---

## 🚀 READY TO IMPLEMENT

**Estimated Time**: 30-45 minutes for FILE 3 only  
**Total System Time**: 4-6 hours (includes FILES 4-11 modifications)

**Next Command**: "Start FILE 3 transformation" when ready to proceed!
