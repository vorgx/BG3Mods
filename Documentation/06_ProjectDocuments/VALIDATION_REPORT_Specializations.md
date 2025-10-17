# Specialization System - Validation Report
**Date:** October 16, 2025  
**Status:** ⚠️ **CRITICAL ISSUES FOUND - REQUIRES CORRECTION**

---

## 🚨 CRITICAL ISSUE: PASSIVE NAMING MISMATCH

### **Problem Identified:**
The Progressions.lsx file uses **subclass-specific passive names**, but the passive definition documents use **generic names**.

### **What Progressions.lsx Has:**
```xml
<!-- ARMS WARRIOR L13 -->
<attribute id="Tag" value="WAR_ARMS_Colossus_Keystone"/>
<attribute id="Tag" value="WAR_ARMS_Slayer_Keystone"/>

<!-- FURY WARRIOR L13 -->
<attribute id="Tag" value="WAR_FURY_MountainThane_Keystone"/>
<attribute id="Tag" value="WAR_FURY_Slayer_Keystone"/>

<!-- PROTECTION WARRIOR L13 -->
<attribute id="Tag" value="WAR_PROT_MountainThane_Keystone"/>
<attribute id="Tag" value="WAR_PROT_Colossus_Keystone"/>
```

### **What Passive Documents Have:**
```
new entry "WAR_MountainThane_Keystone"    ❌ WRONG - Missing subclass prefix
new entry "WAR_Colossus_Keystone"         ❌ WRONG - Missing subclass prefix
new entry "WAR_Slayer_Keystone"           ❌ WRONG - Missing subclass prefix
```

### **Impact:**
- **CRITICAL**: Passives will NOT be recognized by Progressions.lsx
- Game will fail to grant specialization keystones at L13
- Tier choices (L15/17/19) won't unlock (HasPassive checks will fail)
- Capstones won't grant at L20

---

## 🔧 REQUIRED CORRECTIONS

### **Option 1: Subclass-Specific Passives** (RECOMMENDED)
Create **separate passive entries** for each subclass:

**Arms Warrior:**
- `WAR_ARMS_Colossus_Keystone`
- `WAR_ARMS_Colossus_NoStrangerToPain`
- `WAR_ARMS_Colossus_VeteranVitality`
- ... (all 11 Colossus passives × Arms)
- `WAR_ARMS_Slayer_Keystone`
- `WAR_ARMS_Slayer_BrutalFinish`
- ... (all 11 Slayer passives × Arms)

**Fury Warrior:**
- `WAR_FURY_MountainThane_Keystone`
- `WAR_FURY_MountainThane_LightningStrikes`
- ... (all 11 Mountain Thane passives × Fury)
- `WAR_FURY_Slayer_Keystone`
- ... (all 11 Slayer passives × Fury)

**Protection Warrior:**
- `WAR_PROT_MountainThane_Keystone`
- ... (all 11 Mountain Thane passives × Protection)
- `WAR_PROT_Colossus_Keystone`
- ... (all 11 Colossus passives × Protection)

**Total Passives Required**: 
- Arms: 22 passives (11 Colossus + 11 Slayer)
- Fury: 22 passives (11 Mountain Thane + 11 Slayer)
- Protection: 22 passives (11 Mountain Thane + 11 Colossus)
- **GRAND TOTAL**: **66 passive entries** (up from 33)

**Pros:**
- ✅ Matches Progressions.lsx structure exactly
- ✅ Allows subclass-specific tuning if needed
- ✅ Clear separation for debugging

**Cons:**
- ❌ Massive duplication (same passive defined 2-3 times)
- ❌ Maintenance burden (changes must be applied to all copies)
- ❌ 66 passives instead of 33

---

### **Option 2: Update Progressions.lsx to Use Generic Names** (ALTERNATIVE)
Change Progressions.lsx to use generic passive names:

**Change From:**
```xml
<attribute id="Tag" value="WAR_ARMS_Colossus_Keystone"/>
```

**Change To:**
```xml
<attribute id="Tag" value="WAR_Colossus_Keystone"/>
```

**Pros:**
- ✅ Keeps passive count at 33 (no duplication)
- ✅ Easier maintenance (one definition per passive)
- ✅ Shared passives work same across subclasses

**Cons:**
- ❌ Requires updating Progressions.lsx (133 passive Tag references)
- ❌ Less granular control per subclass
- ❌ Harder to track which subclass has which passive

---

## 📊 VALIDATION SUMMARY

### **Progressions.lsx Passive References (Current State)**

#### **Arms Warrior Specializations**
| Level | Node Type | Passive Tag | Match Status |
|-------|-----------|-------------|--------------|
| L13 | SelectPassives | WAR_ARMS_Colossus_Keystone | ❌ NOT DEFINED |
| L13 | SelectPassives | WAR_ARMS_Slayer_Keystone | ❌ NOT DEFINED |
| L15 | SelectPassives (Colossus) | WAR_ARMS_Colossus_NoStrangerToPain | ❌ NOT DEFINED |
| L15 | SelectPassives (Colossus) | WAR_ARMS_Colossus_VeteranVitality | ❌ NOT DEFINED |
| L15 | SelectPassives (Colossus) | WAR_ARMS_Colossus_OneAgainstMany | ❌ NOT DEFINED |
| L15 | SelectPassives (Slayer) | WAR_ARMS_Slayer_BrutalFinish | ❌ NOT DEFINED |
| L15 | SelectPassives (Slayer) | WAR_ARMS_Slayer_ImminentDemise | ❌ NOT DEFINED |
| L15 | SelectPassives (Slayer) | WAR_ARMS_Slayer_OverwhelmingBlades | ❌ NOT DEFINED |
| ... | ... | ... (13 more Arms passives) | ❌ NOT DEFINED |

#### **Fury Warrior Specializations**
| Level | Node Type | Passive Tag | Match Status |
|-------|-----------|-------------|--------------|
| L13 | SelectPassives | WAR_FURY_MountainThane_Keystone | ❌ NOT DEFINED |
| L13 | SelectPassives | WAR_FURY_Slayer_Keystone | ❌ NOT DEFINED |
| ... | ... | ... (20 more Fury passives) | ❌ NOT DEFINED |

#### **Protection Warrior Specializations**
| Level | Node Type | Passive Tag | Match Status |
|-------|-----------|-------------|--------------|
| L13 | SelectPassives | WAR_PROT_MountainThane_Keystone | ❌ NOT DEFINED |
| L13 | SelectPassives | WAR_PROT_Colossus_Keystone | ❌ NOT DEFINED |
| ... | ... | ... (20 more Protection passives) | ❌ NOT DEFINED |

**Total Missing Passives**: **66** (all specialization passives across all 3 subclasses)

---

## 🎯 RECOMMENDATION

### **CHOSEN APPROACH: Option 2 (Update Progressions.lsx)**

**Rationale:**
1. **Avoid massive duplication** - 33 passives instead of 66
2. **Easier maintenance** - One source of truth per passive
3. **Shared mechanics work identically** - Mountain Thane works same on Fury/Protection
4. **Smaller localization burden** - 70 handles instead of 140+

**Implementation Plan:**
1. Update Progressions.lsx to use generic passive names
2. Keep passive definition documents as-is (already correct)
3. Update PASSIVES_MASTER.md to reflect generic naming pattern
4. Add note about shared passives across subclasses

---

## 🛠️ CORRECTIONS REQUIRED

### **Progressions.lsx Changes Needed:**

#### **Find and Replace Pattern:**
```
Find: WAR_ARMS_Colossus_
Replace: WAR_Colossus_

Find: WAR_ARMS_Slayer_
Replace: WAR_Slayer_

Find: WAR_FURY_MountainThane_
Replace: WAR_MountainThane_

Find: WAR_FURY_Slayer_
Replace: WAR_Slayer_

Find: WAR_PROT_MountainThane_
Replace: WAR_MountainThane_

Find: WAR_PROT_Colossus_
Replace: WAR_Colossus_
```

#### **Affected Lines (Estimated):**
- Arms L13 keystone tags: 2 lines
- Arms L15/17/19 tier choice tags: ~18 lines
- Arms L20 capstone references: 2 lines
- Fury (same pattern): ~22 lines
- Protection (same pattern): ~22 lines
- **Total: ~66 lines** to update

### **Passive Documents Changes:**
✅ **NO CHANGES NEEDED** - Already using generic names correctly!

### **PASSIVES_MASTER.md Updates:**
- Update cross-reference section to clarify generic naming
- Add note about shared passives across subclasses
- Update example code blocks

---

## ✅ VALIDATION CHECKLIST (POST-CORRECTION)

### **After Progressions.lsx Update:**
- [ ] All keystone Tag references use generic names (WAR_Colossus_Keystone, etc.)
- [ ] All tier choice Tag references use generic names
- [ ] All HasPassive() requirements use generic names
- [ ] All capstone ApplyStatus() calls use generic names
- [ ] No subclass prefix remains (WAR_ARMS_, WAR_FURY_, WAR_PROT_)

### **Cross-Reference Validation:**
- [ ] Every Tag in Progressions.lsx has matching entry in passive docs
- [ ] Every HasPassive() check references valid keystone passive
- [ ] Every ApplyStatus() capstone has matching status definition
- [ ] All talent names match between Progressions.lsx and SPECIALIZATIONS_REFERENCE.md

### **File Consistency:**
- [ ] PASSIVES_MOUNTAIN_THANE.md uses WAR_MountainThane_* naming
- [ ] PASSIVES_COLOSSUS.md uses WAR_Colossus_* naming
- [ ] PASSIVES_SLAYER.md uses WAR_Slayer_* naming
- [ ] PASSIVES_MASTER.md cross-references match

---

## 📝 ADDITIONAL FINDINGS

### **Status Name Inconsistencies:**

#### **Capstone Statuses in Progressions.lsx:**
```xml
<!-- Arms L20 -->
ApplyStatus(SELF,WAR_ARMS_Colossus_Capstone)
ApplyStatus(SELF,WAR_ARMS_Slayer_Capstone)

<!-- Should be: -->
ApplyStatus(SELF,WAR_Colossus_PreciseMight)
ApplyStatus(SELF,WAR_Slayer_Malice)
```

**Issue**: Capstone status names in Progressions.lsx don't match passive entry names.

**Required Changes:**
- Arms Colossus capstone: `WAR_ARMS_Colossus_Capstone` → `WAR_Colossus_PreciseMight`
- Arms Slayer capstone: `WAR_ARMS_Slayer_Capstone` → `WAR_Slayer_Malice`
- Fury Mountain Thane capstone: `WAR_FURY_MountainThane_Capstone` → `WAR_MountainThane_GatheringStorms`
- Fury Slayer capstone: `WAR_FURY_Slayer_Capstone` → `WAR_Slayer_Malice`
- Protection Mountain Thane capstone: `WAR_PROT_MountainThane_Capstone` → `WAR_MountainThane_GatheringStorms`
- Protection Colossus capstone: `WAR_PROT_Colossus_Capstone` → `WAR_Colossus_PreciseMight`

---

## 🔍 CROSS-REFERENCE TABLE

### **Keystones (L13)**
| Progressions.lsx Tag (CURRENT) | Should Be | Passive Doc Entry | Status |
|-------------------------------|-----------|-------------------|--------|
| WAR_ARMS_Colossus_Keystone | WAR_Colossus_Keystone | WAR_Colossus_Keystone | ❌ MISMATCH |
| WAR_ARMS_Slayer_Keystone | WAR_Slayer_Keystone | WAR_Slayer_Keystone | ❌ MISMATCH |
| WAR_FURY_MountainThane_Keystone | WAR_MountainThane_Keystone | WAR_MountainThane_Keystone | ❌ MISMATCH |
| WAR_FURY_Slayer_Keystone | WAR_Slayer_Keystone | WAR_Slayer_Keystone | ❌ MISMATCH |
| WAR_PROT_MountainThane_Keystone | WAR_MountainThane_Keystone | WAR_MountainThane_Keystone | ❌ MISMATCH |
| WAR_PROT_Colossus_Keystone | WAR_Colossus_Keystone | WAR_Colossus_Keystone | ❌ MISMATCH |

### **Capstones (L20)**
| Progressions.lsx Status (CURRENT) | Should Be | Passive Doc Entry | Status |
|----------------------------------|-----------|-------------------|--------|
| WAR_ARMS_Colossus_Capstone | WAR_Colossus_PreciseMight | WAR_Colossus_PreciseMight | ❌ MISMATCH |
| WAR_ARMS_Slayer_Capstone | WAR_Slayer_Malice | WAR_Slayer_Malice | ❌ MISMATCH |
| WAR_FURY_MountainThane_Capstone | WAR_MountainThane_GatheringStorms | WAR_MountainThane_GatheringStorms | ❌ MISMATCH |
| WAR_FURY_Slayer_Capstone | WAR_Slayer_Malice | WAR_Slayer_Malice | ❌ MISMATCH |
| WAR_PROT_MountainThane_Capstone | WAR_MountainThane_GatheringStorms | WAR_MountainThane_GatheringStorms | ❌ MISMATCH |
| WAR_PROT_Colossus_Capstone | WAR_Colossus_PreciseMight | WAR_Colossus_PreciseMight | ❌ MISMATCH |

---

## 🎯 ACTION ITEMS

### **Priority 1: Update Progressions.lsx** ⏸️
1. Replace all subclass-prefixed passive names with generic names
2. Update capstone status names to match passive entry names
3. Verify all HasPassive() requirements updated
4. Total changes: ~72 lines

### **Priority 2: Validate Cross-References** ⏸️
1. Run grep search to confirm all Tag references match passive docs
2. Verify all status names consistent
3. Check all ability references (WAR_Execute, WAR_ShieldSlam, etc.)

### **Priority 3: Update Documentation** ⏸️
1. Update PASSIVES_MASTER.md with corrected cross-reference examples
2. Add note about shared passives across subclasses
3. Update Blueprint with final passive naming convention

---

**Validation Status**: ❌ **FAILED - Critical mismatches found**  
**Required Action**: Update Progressions.lsx before proceeding with Stats file implementation  
**Estimated Fix Time**: 15 minutes (find/replace operations)
