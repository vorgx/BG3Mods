# Enrichment Strategy Update - Pivot to Documentation-Based Approach

**Date**: October 20, 2025  
**Decision Point**: After attempting HTML parsing

---

## What We Tried

✅ **Copied offline HTML resources** - 9 files (3 Icy-Veins + 6 Wowhead guides)  
✅ **Documented offline resources** - Updated WOW_SOURCE_REFERENCES.md  
❌ **HTML parsing** - Too complex, HTML structure varies, would take 5-10 hours of regex work  

---

## Better Approach: Mine SOURCE_OF_TRUTH.md

**Realization**: We already have 80% of the ability mechanics documented in SOURCE_OF_TRUTH.md Section [4]!

### What's Already Documented

**Section [4.1] Arms Warrior** (~60 abilities):
- Complete talent descriptions with mechanics
- Bidirectional prerequisites (which abilities unlock what)
- Build archetype tags
- Rotation priorities

**Section [4.2] Fury Warrior** (~59 abilities):
- All Fury talents with mechanics
- Enrage system details
- Bloodthirst healing mechanics
- Rampage/Onslaught costs

**Section [4.3] Protection Warrior** (~47 abilities):
- Tank-specific mechanics
- Shield Block charge system
- Rage generation values
- Mitigation cooldowns

**Total**: ~166 abilities with full WoW mechanics already written!

---

## Efficient Enrichment Plan

### Phase A: Extract from SOURCE_OF_TRUTH.md (4-6 hours)

**Script**: Parse Section [4] markdown to extract:
1. Ability names from talent tables
2. Descriptions from subsections
3. Rage costs from mechanics text
4. Prerequisites from bidirectional callouts
5. Archetype tags from build sections

**Pattern Matching**:
- Passive stat boosts → `bg3_file_type: Passive`, `Boosts` functors
- Ability modifiers → populate `modified_by` column
- Proc triggers → `StatsFunctorContext: OnCast/OnDamage`
- Active abilities → determine `bg3_spell_type` from description

**Output**: ~120-140 newly enriched abilities (46 already done + 80-100 from docs)

### Phase B: Pattern-Based Passive Templates (2-3 hours)

Many passives follow standard patterns we can template:

**Stat Boosts**:
- "+X% crit" → `CriticalChance(X)`
- "+X% damage" → `Damage(X)`
- "+X% healing" → `Heal(X)`

**Conditional Boosts**:
- "While Enraged..." → `IF(HasStatus('WAR_ENRAGED')):Boost(...)`
- "On kill..." → `IF(Killed()):Boost(...)`

**Ability Modifications**:
- "Increases [Ability] damage by X%" → Links to base ability via `modified_by`

### Phase C: Manual Research for Gaps (2-4 hours)

Remaining ~30-40 abilities that aren't in docs or templates:
- Complex hero talent interactions
- Unique proc mechanics
- New TWW abilities not yet documented

---

## Revised Timeline

| Task | Approach | Time | Output |
|------|----------|------|--------|
| **Documented abilities** | Parse SOURCE_OF_TRUTH.md Section [4] | 4-6 hrs | +80-100 enriched |
| **Pattern passives** | Apply BG3 templates to stat boosts | 2-3 hrs | +30-40 enriched |
| **Manual gaps** | Research + manual entry | 2-4 hrs | +20-30 enriched |
| **Total** | | **8-13 hrs** | **~160-170 enriched** |

**Result**: 46 (current) + 130-140 (new) = **176-186 of 215 abilities enriched** (82-87%)

Remaining 29-39 abilities (13-18%) will be:
- Very niche talents
- Minor stat boosts
- Optional utilities

---

## Implementation Decision Point

**Option A**: Complete enrichment first (8-13 hours)  
- Pros: 100% data before implementation
- Cons: Delays seeing working mod

**Option B**: Start implementation now with 46 ready abilities  
- Pros: Working mod ASAP, learn what works
- Cons: May need to pause for enrichment

**Option C**: Hybrid - Enrich docs (4-6 hrs) then implement  
- Pros: 80% enriched (120-140 abilities), solid foundation
- Cons: Still some work before full implementation

---

## Recommendation

**Go with Option C (Hybrid Approach)**:

1. **Today**: Parse SOURCE_OF_TRUTH.md (4-6 hours)  
   → 120-140 abilities enriched (56-65% total)

2. **Tomorrow**: Start implementation with 120-140 abilities  
   → Working mod with core rotations + talents

3. **Later**: Fill gaps as needed during testing  
   → Add missing abilities when you notice them

This gives you a **playable, feature-rich mod faster** while still having solid data coverage.

---

## Next Immediate Step

Create `ENRICH_FROM_SOURCE_OF_TRUTH.ps1` to parse Section [4] and populate database.

**Ready to proceed?**
