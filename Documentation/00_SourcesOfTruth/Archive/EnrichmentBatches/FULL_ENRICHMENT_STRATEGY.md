# Full Enrichment Strategy - 169 Remaining Abilities

**Date**: October 20, 2025  
**Goal**: Complete enrichment of all 215 abilities (currently 46/215 done)

---

## Phase 1: Leverage Existing Documentation (IMMEDIATE)

Many of the 169 abilities are already documented in SOURCE_OF_TRUTH.md with full mechanics. I can enrich these WITHOUT needing Icy-Veins research.

### Sources Available NOW:
1. **SOURCE_OF_TRUTH.md Section [4]** - Complete subclass talent descriptions with mechanics
2. **Excel Progression CSV** - Ability descriptions and unlock levels
3. **Existing extraction docs** - FURY_WARRIOR_ICYVEINS_EXTRACTION.md, COLOSSUS_ICYVEINS_EXTRACTION.md

**Estimated abilities we can enrich from existing docs**: ~80-100

---

## Phase 2: Passive Abilities (Use Pattern Matching)

Many passives follow standard patterns:
- Stat boosts → `Boosts` field in Passive.txt
- Proc triggers → `StatsFunctorContext` + `Conditions`
- Ability modifications → `StatsFunctors` that reference other abilities

**Estimated**: ~50 passives can be templated

---

## Phase 3: Manual Icy-Veins Research (LATER)

For truly unique abilities not documented anywhere, research from:
- Arms: https://www.icy-veins.com/wow/arms-warrior-pve-dps-spell-summary
- Fury: https://www.icy-veins.com/wow/fury-warrior-pve-dps-spell-summary
- Protection: https://www.icy-veins.com/wow/protection-warrior-pve-tank-spell-summary

**Estimated**: ~20-30 abilities need deep research

---

## Execution Plan

### Batch 1: Passive Stat Boosts (Immediate - 30 min)
Extract from SOURCE_OF_TRUTH.md and convert to BG3 Boosts syntax.

Examples:
- Seasoned Soldier → `CriticalChance(1)`
- War Machine → `IF(Killed()):StatusTempo()`
- Leeching Strikes → `Lifesteal(1%)`

### Batch 2: Ability Modifiers (Immediate - 1 hour)
Use Section [4] bidirectional callouts.

Examples:
- Improved Execute → modifies Execute
- Critical Thinking → modifies Execute
- Storm Wall → modifies Die by the Sword
- Test of Might → modifies Colossus Smash

### Batch 3: Active Abilities from Section [4] (1-2 hours)
Extract full mechanics from talent descriptions.

Examples:
- Demoralizing Shout
- Intimidating Shout
- Impending Victory
- Warbreaker
- Massacre

### Batch 4: Hero Talent Trees (2-3 hours)
Mountain Thane, Colossus, Slayer abilities from existing extractions.

### Batch 5: Remaining Gaps (Manual Research)
Anything not covered by above sources.

---

## Let's Start with Batch 1

I'll create an enrichment script that pulls from SOURCE_OF_TRUTH.md Section [4] and the Excel CSV to populate as many as possible.

Ready to proceed?
