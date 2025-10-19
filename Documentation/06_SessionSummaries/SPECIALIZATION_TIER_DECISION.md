# Specialization Tier Structure - Decision Summary
**Date**: October 17, 2025  
**Decision**: APPROVED - Flexible Tier System  
**Status**: ✅ Complete - Documentation Updated

---

## Decision

**Question**: Should all specializations use the same tier structure (3 tiers vs 4 tiers)?

**Answer**: **Flexible system** - Tier count depends on the specialization, not the base spec.

---

## Specialization Matrix

| Base Spec | Specialization Option 1 | Specialization Option 2 |
|-----------|------------------------|------------------------|
| **Arms** | **Colossus** (3 tiers: L15, L17, L19) | **Slayer** (3 tiers: L15, L17, L19) |
| **Fury** | **Mountain Thane** (4 tiers: L15, L16, L18, L19) | **Slayer** (3 tiers: L15, L17, L19) |
| **Protection** | **Mountain Thane** (4 tiers: L15, L16, L18, L19) | **Colossus** (3 tiers: L15, L17, L19) |

---

## Tier Structures

### 3-Tier Specializations (Colossus, Slayer)

**Progression**:
- L13: Keystone (auto-granted)
- L14: Passive 1 (auto-granted)
- L15: 🔹 Choice Node 1 (pick 1 of 3)
- L16: Passive 2 (auto-granted)
- L17: 🔹 Choice Node 2 (pick 1 of 3)
- L18: Passive 3 (auto-granted)
- L19: 🔹 Choice Node 3 (pick 1 of 3)
- L20: Passive 4 + Capstone (auto-granted)

**Total**: 1 keystone + 1 capstone + 4 passives + 3 choices = **9 talents**

---

### 4-Tier Specializations (Mountain Thane)

**Progression**:
- L13: Keystone (auto-granted)
- L14: Passive 1 (auto-granted)
- L15: 🔹 Choice Node 1 (pick 1 of 3)
- L16: 🔹 Choice Node 2 (pick 1 of 3)
- L17: Passive 2 (auto-granted)
- L18: 🔹 Choice Node 3 (pick 1 of 3)
- L19: 🔹 Choice Node 4 (pick 1 of 3)
- L20: Passive 3 + Capstone (auto-granted)

**Total**: 1 keystone + 1 capstone + 3 passives + 4 choices = **9 talents**

---

## Rationale

**Why Different Tier Counts?**

- **3 Tiers** (Colossus, Slayer): Broader, more impactful choices with spacing. Simpler build paths.
- **4 Tiers** (Mountain Thane): More granular choices with tighter spacing. More complex synergy chains.

**Both systems result in 9 total talents**, but distribute player agency differently:
- 3-Tier: Fewer decisions, more auto-granted passives
- 4-Tier: More decisions, fewer auto-granted passives

---

## Documentation Updates

### Files Updated
✅ **ARMS_WARRIOR_5_POOL_TALENT_SYSTEM.md**
- Updated Pool 4 (Colossus) header: "3 Choice Tiers (L15, L17, L19)"
- Updated Pool 5 (Slayer) header: "3 Choice Tiers (L15, L17, L19)"
- Added specialization availability matrix to Executive Summary
- Noted cross-spec availability (Colossus for Arms/Protection, Slayer for Arms/Fury)

### Files Created
✅ **SPECIALIZATION_TIER_STRUCTURES.md** (NEW)
- Comprehensive cross-spec reference document
- Availability matrix (which specs can choose which specializations)
- Full tier structure breakdowns (3-tier vs 4-tier)
- BG3 Progressions.lsx implementation examples
- Balance considerations (power budget per tier)
- Player guidance (how to choose a specialization)
- Design rationale for tier differences

---

## Implementation Impact

### Phase 1: BG3 Constraint Research
**Updated requirement**: Must test BOTH 3-tier and 4-tier progression structures
- Test SelectPassives at L15 only (3-tier)
- Test SelectPassives at L15 AND L16 consecutively (4-tier)
- Verify UI handles back-to-back choice levels gracefully
- Document any differences in behavior

### Phase 2-3: Implementation
**Specialization-specific work**:
- **Colossus**: 9 choice talents (3 tiers × 3 options), 4 passives
- **Slayer**: 9 choice talents (3 tiers × 3 options), 4 passives
- **Mountain Thane**: 12 choice talents (4 tiers × 3 options), 3 passives

**Total new abilities across all 3 specializations**: ~30 choice talents + ~11 passives = **~41 specialization-specific abilities**

---

## Next Steps

1. ✅ **COMPLETE**: Documentation updated with flexible tier system
2. ⏸️ **NEXT**: Begin Phase 1 BG3 constraint research
   - Test 3-tier progression (Colossus/Slayer)
   - Test 4-tier progression (Mountain Thane)
   - Validate UI/UX for both structures
3. ⏸️ **FUTURE**: Create FURY_WARRIOR_5_POOL_TALENT_SYSTEM.md and PROTECTION_WARRIOR_5_POOL_TALENT_SYSTEM.md documents
4. ⏸️ **FUTURE**: Extract Mountain Thane full talent details from source material

---

## Status: DESIGN FINALIZED ✅

All critical design decisions are now complete:
- ✅ Decision 1: 12 baseline abilities (ALL exist in code)
- ✅ Decision 2: Keep 5-passive hero system
- ✅ Decision 3: Keep feats (hybrid D&D+WoW)
- ✅ Decision 4: Use WoW icons (~200+ available)
- ✅ Decision 5: Test 10 archetype builds
- ✅ **Decision 6**: Flexible specialization tier system (3 vs 4 tiers)

**Ready to proceed to Phase 1: BG3 Constraint Research** 🚀

---

**END OF DECISION SUMMARY**
