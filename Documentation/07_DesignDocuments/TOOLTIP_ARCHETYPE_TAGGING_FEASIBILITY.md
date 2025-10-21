# Tooltip Archetype Tagging - Feasibility Report

**Date**: October 20, 2025  
**User Request**: "can we show via tooltips some labels / tag to indicate the archetypes. Execute, Bleed, AOE ect. ? can that work ?"  
**Status**: ✅ **FEASIBLE - Already Partially Implemented!**

---

## EXECUTIVE SUMMARY

**GREAT NEWS**: Your innovative idea is not only feasible—**it's already partially working in the current mod!**

The existing tooltip system uses a `Tags:` section at the end of ability descriptions. We can **enhance** this system to explicitly mark Build Archetype associations.

**Current State**: Generic tags (Generator, Spender, AoE, Defensive)  
**Proposed Enhancement**: Add Build Archetype tags (Execute Build, Bleed Build, etc.)

---

## CURRENT TOOLTIP SYSTEM (Already Working)

### How It Works
BG3 ability tooltips pull text from `English.loca.xml` (the localization file). Each ability has a `Description` handle that contains:
1. **Flavor text** (top of tooltip)
2. **Mechanics** (what the ability does)
3. **Action economy** (Action type, range, costs)
4. **Tags section** (categorization)

### Example: Current Charge Implementation
**Localization Entry** (English.loca.xml, line 38-44):
```xml
<content contentuid="h125abc02" version="4">Charge forward, rushing to an enemy and striking them.

Deal [1] damage and generate [2] Rage.
Knock the target [3] for [4] turn.

Action • 18m range

Tags: Generator, Gap-Closer, Control</content>
```

**What Players See** (in-game):
```
Charge

Charge forward, rushing to an enemy and striking them.

Deal 1d6+Strength damage and generate 20 Rage.
Knock the target Prone for 1 turn.

Action • 18m range

Tags: Generator, Gap-Closer, Control
```

**Result**: Tags are **fully visible** to players during level-up and in character sheet tooltips.

---

## YOUR PROPOSAL: Build Archetype Tags

### What We'd Add
Expand the `Tags:` line to include Build Archetype associations:

**Before** (current):
```
Tags: Spender, Execute, High-Damage
```

**After** (enhanced):
```
Tags: Spender, Execute, High-Damage • [Execute Build]
```

**Alternative Format** (more prominent):
```
Tags: Spender, Execute, High-Damage

Build: Execute Master
```

### Visual Mockup
**Improved Execute Tooltip**:
```
Execute

Strike down critically wounded enemies with a devastating blow.

Deal 4d12+Strength damage to enemies below 20% HP.
Costs 20 Rage (reduced to 10 with Improved Execute).

Action • Melee Weapon Attack

Tags: Spender, Execute, High-Damage • [Execute Build]
```

**Improved Rend Tooltip**:
```
Rend

Tear through enemy defenses, causing severe bleeding.

Deal 1d6+Strength damage and apply Bleed: 2d6 damage per turn for 3 turns.
Generates 10 Rage.

Action • Melee Weapon Attack

Tags: Generator, DoT, Damage-Over-Time • [Bleed Build]
```

---

## IMPLEMENTATION APPROACH

### Option 1: Inline Tag Addition (FASTEST - 30 min)
**What**: Add ` • [Build Name]` to existing Tags line  
**Example**: `Tags: Spender, High-Damage, Arms • [Execute Build]`

**Pros**:
- ✅ Minimal text changes (just append to Tags line)
- ✅ Consistent with existing format
- ✅ No new localization entries needed
- ✅ Can be done in 30 minutes for all Arms talents

**Cons**:
- Tags line might get long (can split to 2 lines if needed)

**How Many Abilities**:
- **Execute Build**: ~6-8 abilities (Execute, Improved Execute, Sudden Death, Massacre, etc.)
- **Bleed Build**: ~5-6 abilities (Rend, Bloodletting, Sharpened Blades)
- **Colossus Smash Build**: ~4-5 abilities (Colossus Smash, Test of Might, Warbreaker)
- **Overpower Build**: ~6-8 abilities (Overpower, Improved Overpower, Tactician, Storm of Swords)
- **AoE Build**: ~5-6 abilities (Cleave, Fervor of Battle, Bladestorm, Dance of Death)
- **Tank Hybrid**: ~4-5 abilities (Die by the Sword, Ignore Pain, Spiteful Serenity)

**Total for Arms**: ~30-40 ability descriptions to update

---

### Option 2: Separate Build Line (CLEAREST - 45 min)
**What**: Add dedicated "Build:" line below Tags  
**Example**:
```
Tags: Spender, Execute, High-Damage

Build: Execute Master
```

**Pros**:
- ✅ More prominent and clear
- ✅ Easier to spot for players
- ✅ Doesn't clutter Tags line

**Cons**:
- Slightly longer tooltips (adds 1 line per ability)

---

### Option 3: Hybrid Approach (RECOMMENDED - 40 min)
**What**: Use inline tags for multi-build abilities, dedicated line for signature abilities

**Signature Abilities** (get dedicated "Build:" line):
- Execute → "Build: Execute Master"
- Rend → "Build: Bleed Specialist"
- Colossus Smash → "Build: Colossus Smash"
- Improved Overpower → "Build: Overpower Specialist"
- Cleave → "Build: AoE Specialist"
- Die by the Sword → "Build: Tank Hybrid"

**Supporting Abilities** (get inline archetype tag):
- Sudden Death → `Tags: Passive, Execute-Proc • [Execute Build]`
- Bloodletting → `Tags: Passive, Bleed-Enhancement • [Bleed Build]`
- Fervor of Battle → `Tags: Passive, AoE-Enhancement • [AoE Build]`

**Pros**:
- ✅ Balances clarity with conciseness
- ✅ Highlights "anchor" abilities for each build
- ✅ Doesn't overwhelm players with tags

---

## TECHNICAL VALIDATION

### ✅ Confirmed BG3 Capabilities
1. **Plain text in localization**: BG3 displays localization strings as-is (no sanitization that would break tags)
2. **Line breaks preserved**: Multi-line descriptions work perfectly (current mod uses them)
3. **Special characters**: BG3 supports `•`, `[]`, `→`, etc. (verified in current mod)
4. **Length limits**: No hard limits on description length (just readability concerns)

### ✅ No Modding Limitations
- **No coding required**: Just update text in English.loca.xml
- **No new handles needed**: Reuse existing Description handles (increment version number)
- **No engine changes**: BG3 already displays full description text
- **No conflicts**: Tags are purely informational (don't affect game mechanics)

### ✅ WoWWarlock Precedent
**Checked WoWWarlock mod for similar patterns**: No build archetype tags used, BUT the mod DOES use custom tooltip formatting with `Tags:` sections, proving the approach is viable.

---

## COMPARISON: Tooltip Tags vs. Documentation

| Aspect | Documentation Only | Tooltip Tags (Your Idea) |
|--------|-------------------|-------------------------|
| **Player Visibility** | ❌ External guides required | ✅ Visible during level-up |
| **Discoverability** | ❌ Low (need to search) | ✅ High (immediate context) |
| **Implementation Time** | 15 min | 30-45 min (all Arms talents) |
| **Maintenance** | Easy | Easy (just text updates) |
| **Impact** | Developer/wiki reference | Direct player UX improvement |
| **Replicability** | Yes (Fury/Protection) | Yes (same pattern) |
| **Unique Value** | Planning aid | In-game guidance |

**Verdict**: Tooltip tags are **superior in every way** except implementation time (+15-30 min vs. documentation-only).

---

## RECOMMENDED IMPLEMENTATION PLAN

### Phase 1: Prove Concept (10 min)
1. Update **1 signature ability** per build archetype (6 abilities total)
2. Test in-game to confirm tooltips display correctly
3. Get user approval on format (inline vs. dedicated line vs. hybrid)

**Example Test Cases**:
- Execute → Add "Build: Execute Master"
- Rend → Add "Build: Bleed Specialist"
- Colossus Smash → Add "Build: Colossus Smash"
- Improved Overpower → Add "Build: Overpower Specialist"
- Cleave → Add "Build: AoE Specialist"
- Die by the Sword → Add "Build: Tank Hybrid"

---

### Phase 2: Full Arms Implementation (30-40 min)
1. Update all ~30-40 Arms talent descriptions
2. Use hybrid approach (signature abilities get dedicated line, supporting get inline tag)
3. Verify localization handle versions incremented correctly
4. Test full Arms build paths in-game

---

### Phase 3: Replicate to Fury/Protection (1-1.5 hours each)
1. Apply same pattern to Fury SubclassSpec Talents
2. Apply same pattern to Protection SubclassSpec Talents
3. Document build archetypes for Fury/Protection in SOURCE_OF_TRUTH.md

---

## EXAMPLE IMPLEMENTATIONS (Copy-Paste Ready)

### Execute Build - Signature Ability
**File**: English.loca.xml  
**Handle**: h125abc05 (Execute description)

**Current**:
```xml
<content contentuid="h125abc05" version="4">Strike down critically wounded enemies with a devastating blow.

Deal [1] damage to enemies below [2]% HP.
Costs [3] Rage.

Action • Melee Weapon Attack

Tags: Spender, Execute, High-Damage</content>
```

**Enhanced**:
```xml
<content contentuid="h125abc05" version="5">Strike down critically wounded enemies with a devastating blow.

Deal [1] damage to enemies below [2]% HP.
Costs [3] Rage.

Action • Melee Weapon Attack

Tags: Spender, Execute, High-Damage

Build: Execute Master</content>
```

**Result**: Players immediately see this is the anchor ability for Execute builds.

---

### Bleed Build - Supporting Talent
**File**: English.loca.xml  
**Handle**: (need to find Bloodletting handle)

**Current** (hypothetical):
```xml
<content contentuid="h125abc99" version="1">Your Rend ability causes enemies to bleed more severely.

Rend's damage-over-time effect deals 50% increased damage.

Passive

Tags: Passive, Bleed-Enhancement</content>
```

**Enhanced**:
```xml
<content contentuid="h125abc99" version="2">Your Rend ability causes enemies to bleed more severely.

Rend's damage-over-time effect deals 50% increased damage.

Passive • [Bleed Build]

Tags: Passive, Bleed-Enhancement</content>
```

**Result**: Players know this talent enhances Bleed build playstyle.

---

### AoE Build - Multi-Build Ability
**Example**: Whirlwind (can be used in AoE OR Fury builds)

**Enhanced**:
```xml
<content contentuid="h125abc20" version="3">Spin in a devastating circle, striking all nearby enemies.

Deal [1] damage to all enemies within [2]m.
Generates [3] Rage per target hit.

Action • Melee Weapon Attack

Tags: Generator, AoE, Melee • [AoE Build] [Fury Build]</content>
```

**Result**: Players see this ability works for multiple archetypes.

---

## NEXT STEPS

### Decision Point: Format Choice
**Question for User**: Which format do you prefer?

1. **Inline Tags** (fastest): `Tags: Spender, Execute • [Execute Build]`
2. **Dedicated Line** (clearest): `Build: Execute Master` (separate line)
3. **Hybrid** (recommended): Signature abilities get dedicated line, supporting get inline tag

---

### After Format Choice: Implementation

**Step 1**: Update 6 signature abilities (proof of concept)  
**Step 2**: Test in-game (verify tooltips display correctly)  
**Step 3**: User approval on appearance/readability  
**Step 4**: Full Arms implementation (~30 abilities)  
**Step 5**: Document build archetypes in SOURCE_OF_TRUTH.md (15 min)  
**Step 6**: Replicate pattern to Fury/Protection when building those sections

---

## TIME ESTIMATES

| Task | Time |
|------|------|
| **Proof of Concept** (6 abilities) | 10 min |
| **Full Arms Implementation** (30-40 abilities) | 30-40 min |
| **Build Archetypes Documentation** (Section 4.1 addition) | 15 min |
| **Fury Implementation** (when building [4.2]) | 30-40 min |
| **Protection Implementation** (when building [4.3]) | 30-40 min |
| **TOTAL** (all 3 specs) | ~2-2.5 hours |

**vs. Documentation-Only Approach**: ~15 min (just write build paths in docs)

**Extra Investment**: ~2 hours for **massive UX improvement** (players see build paths in-game)

---

## RISKS AND MITIGATION

### Risk 1: Tooltips Too Long
**Concern**: Adding build tags might make tooltips cluttered

**Mitigation**:
- Use concise archetype names (e.g., "Execute Build" not "Execute Master Specialization Path")
- Use inline tags for most abilities (doesn't add lines)
- Only use dedicated "Build:" line for anchor abilities (~6 per spec)
- Test readability in-game before full rollout

---

### Risk 2: Build Tags Confusing for New Players
**Concern**: Players unfamiliar with archetypes might not understand tags

**Mitigation**:
- Add brief explanation in class description (English.loca.xml)
- Use intuitive archetype names (Execute, Bleed, AoE, Tank are self-explanatory)
- Tags are **additive** (don't remove existing info, just enhance it)
- Players can ignore tags if not ready for build optimization

---

### Risk 3: Maintenance Burden
**Concern**: Need to update tags if builds change

**Mitigation**:
- Tags are plain text (no code changes needed)
- SOURCE_OF_TRUTH.md will document canonical build paths
- Version control tracks all localization changes
- Pattern is replicable (same approach for all 3 specs)

---

## RECOMMENDATION

**✅ PROCEED WITH TOOLTIP ARCHETYPE TAGGING**

**Why**:
1. **Already 90% there**: Mod already uses Tags system, just need to enhance it
2. **Superior UX**: Players see build guidance during talent selection (not external guides)
3. **Low risk**: Plain text changes, fully reversible
4. **High impact**: Makes 44 Arms talent choices much more approachable
5. **Replicable**: Same pattern for Fury/Protection
6. **Modest time investment**: ~2 hours total for all 3 specs

**Suggested Workflow**:
1. **NOW**: Choose format (inline, dedicated, or hybrid)
2. **NOW**: Implement proof of concept (6 signature abilities, 10 min)
3. **NOW**: Test in-game, get your approval
4. **THEN**: Full Arms implementation (30-40 min)
5. **THEN**: Document build archetypes in SOURCE_OF_TRUTH.md (15 min)
6. **THEN**: Proceed with [4.2] Fury (replicate pattern)
7. **THEN**: Proceed with [4.3] Protection (replicate pattern)

**Result**: Best-in-class build discoverability directly in BG3 UI, setting your mod apart from others!

---

## USER DECISION REQUIRED

**Please choose your preferred format**:

**Option A: Inline Tags** (fastest)
```
Tags: Spender, Execute, High-Damage • [Execute Build]
```

**Option B: Dedicated Line** (clearest)
```
Tags: Spender, Execute, High-Damage

Build: Execute Master
```

**Option C: Hybrid** (recommended - balance of both)
```
Signature abilities:
Build: Execute Master

Supporting abilities:
Tags: Passive, Execute-Proc • [Execute Build]
```

**Once you decide, I'll implement the proof of concept (6 abilities) and we can test it immediately!**
