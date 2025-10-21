# Build Archetypes - Purpose & Implementation Context

**Date**: October 20, 2025  
**Question**: Where/how will players see Build Archetypes in BG3 UI?

---

## 🎯 Critical Clarification: This is SOURCE_OF_TRUTH Documentation Only

### **Build Archetypes are NOT in-game UI**

**Important Context**:
- Section [4.1] is part of **SOURCE_OF_TRUTH.md** (project documentation)
- This document is for **developers/modders**, NOT players
- Players will NEVER see this document in-game

---

## 📋 Who Uses This Documentation?

### **Primary Audience**: Implementation Teams
1. **You** (mod creator) - Understanding class design
2. **Future developers** - Maintaining/expanding the mod
3. **Contributors** - Adding new features
4. **QA testers** - Validating builds work correctly

### **Secondary Audience**: Community
1. **Wiki editors** - Creating player guides (Nexus Mods, Fextralife, etc.)
2. **Build theorycrafters** - Analyzing optimal talent paths
3. **Content creators** - Making YouTube guides, Twitch builds

---

## 🎮 What Players Actually See In-Game

### BG3's Talent Selection UI (Level Up Screen)

**Current Implementation** (vanilla BG3 + all mods):
```
┌─────────────────────────────────────┐
│  LEVEL 5 - SELECT A TALENT          │
├─────────────────────────────────────┤
│                                     │
│  ○ Martial Prowess                  │
│    Passive damage boost to          │
│    two-handed weapons                │
│                                     │
│  ○ Die by the Sword                 │
│    Defensive cooldown (parry        │
│    incoming attacks for 3 turns)    │
│                                     │
│  ○ Improved Execute                 │
│    Execute deals additional         │
│    damage and costs less Rage       │
│                                     │
└─────────────────────────────────────┘
```

**Key Points**:
- Players see **ONLY** the talents available at their current level
- NO "build path" UI exists in BG3
- NO "recommended build" suggestions in vanilla game
- Tooltips show individual talent descriptions ONLY

---

## 🤔 So Why Document Build Archetypes?

### **Reason 1: Developer Understanding** (Primary)

When implementing talents in `Passive.txt` / `Spell_*.txt`, you need to understand:
- **Which talents synergize?** (e.g., Bloodsurge makes Overpower free → implement proc mechanic)
- **Which talents are build-defining?** (Colossus Smash opens Warbreaker/Test of Might → must implement both)
- **Which talents are dead-ends?** (Storm Wall requires Die by the Sword → add dependency check)

**Example Use Case**:
You're implementing **Tactician** (Row 5, L7). Documentation says:
- "Part of Overpower Specialist build"
- "Works with: Improved Overpower, Bloodsurge, Storm of Swords"
- "High skill ceiling build"

→ Now you know Tactician needs robust cooldown reset logic because it's critical to a build path, not just a standalone talent.

---

### **Reason 2: QA Testing** (Secondary)

When testing the mod, testers need guidance:
- "Test Execute Master build" → Pick Improved Execute, Sudden Death, Massacre, Executioner's Precision
- "Test Overpower Specialist build" → Pick Improved Overpower, Tactician, Storm of Swords
- "Verify builds are balanced" → Compare damage output of Execute Master vs. Colossus Smash build

**Without documented archetypes**: Testers pick random talents with no synergy, can't identify balance issues.

---

### **Reason 3: Community Guides** (Tertiary)

When players ask "How do I build Arms Warrior?", community creates guides:
- **Nexus Mods description page**: "Execute Master build: Take these talents..."
- **Reddit posts**: "Best Arms build for solo/group/boss fights?"
- **YouTube videos**: "Arms Warrior Complete Build Guide - BG3"

**Your SOURCE_OF_TRUTH.md becomes the reference** for wiki editors and guide creators.

---

## 🎨 How Players ACTUALLY Learn Builds

### **Method 1: External Resources** (Most Common)
- **Wiki pages** (Baldur's Gate 3 Wiki, Fextralife)
- **YouTube guides** (content creators theory-craft builds)
- **Reddit/Discord** (community shares optimal builds)
- **Nexus Mods description** (mod authors provide build suggestions)

### **Method 2: Trial and Error** (Common)
- Players experiment with talents
- Discover synergies through gameplay
- Ask community for advice after hitting brick wall

### **Method 3: Reading Tooltips** (Least Common)
- Some players read every talent tooltip carefully
- Infer synergies from descriptions
- Plan builds manually

---

## 💡 Could You Add In-Game Build Suggestions?

### **Short Answer**: Not really, BG3's UI doesn't support it

**BG3 Limitations**:
1. **No "Recommended Build" UI** - Larian doesn't provide API for build suggestions
2. **No Talent Filtering** - Can't mark talents as "Execute Build" or "Tank Build"
3. **No Talent Trees Visual** - BG3 uses flat lists, not WoW-style trees
4. **No Mod Hooks** - Script Extender doesn't expose level-up UI for modification

**What You COULD Do** (with extensive effort):
1. **Nexus Mods Description Page**: List build archetypes in mod description
2. **README.md in Mod Folder**: Include build guide players can read
3. **Custom Item Tooltips**: Create in-game books/notes with build suggestions (hacky but possible)

**Realistic Approach**: Document builds in SOURCE_OF_TRUTH → Copy to Nexus description → Let community wiki editors create guides

---

## 📐 So Should We Still Add Build Archetypes?

### **✅ YES - Here's Why**:

1. **Implementation Guidance**: Helps you prioritize which talents to implement first
   - "Execute Master is most popular → implement Execute enhancements first"
   - "Tank Hybrid is niche → implement defensive talents later"

2. **Testing Framework**: Provides structured test cases
   - "Test Case 1: Execute Master build (L1-L12 path)"
   - "Test Case 2: Overpower Specialist build (L1-L12 path)"

3. **Community Foundation**: Becomes the authoritative source for wikis/guides
   - Players don't read SOURCE_OF_TRUTH, but wiki editors do
   - Wiki editors create player-facing guides using your documentation

4. **Future Maintenance**: New developers understand class design intent
   - "Why did original designer make Tactician reset cooldowns?"
   - "Because it's core to Overpower Specialist archetype"

5. **Balance Validation**: Ensures builds are roughly equal in power
   - "Execute Master does 35% more damage than Tank Hybrid"
   - "Is this intentional? (Yes - Tank Hybrid has survivability)"

---

## 🎯 Revised Understanding

**Build Archetypes are NOT**:
- ❌ In-game UI elements
- ❌ Player-facing recommendations in BG3
- ❌ Automated build suggestions

**Build Archetypes ARE**:
- ✅ Developer documentation for understanding talent synergies
- ✅ QA testing framework for build validation
- ✅ Reference material for community wiki editors
- ✅ Design intent documentation for future maintainers

---

## 💬 Recommendation

**Still add Build Archetypes** because:
1. **You** need them for implementation planning (which talents are build-defining?)
2. **Testers** need them for structured testing (verify builds work)
3. **Community** will use them to create player-facing guides (Nexus/Wiki)

**Alternative Approach** (if you're concerned about scope):
- Add **abbreviated version** in SOURCE_OF_TRUTH.md (just talent lists per archetype, no long descriptions)
- Save **detailed explanations** for Nexus Mods description page (player-facing)

**Example Abbreviated Version**:
```markdown
##### Build Archetypes (Quick Reference)

**Execute Master**: Row 3 (Improved Execute) → Row 4 (Sudden Death) → Row 7 (Massacre) → Row 10 (Executioner's Precision)

**Colossus Smash**: Row 5 (Colossus Smash) → Row 7 (Test of Might or Warbreaker)

**Overpower Specialist**: Row 4 (Improved Overpower) → Row 5 (Tactician) → Row 7 (Storm of Swords) → Row 9 (Battlelord)

**AoE Specialist**: Row 4 (Fervor of Battle) → Row 6 (Cleave) → Row 9 (Bladestorm) → Row 10 (Dance of Death)

**Bleed Specialist**: Row 6 (Rend) → Row 9 (Bloodletting or Sharpened Blades)

**Tank Hybrid**: Row 3 (Die by the Sword) → Row 4 (Ignore Pain or Storm Wall) → Row 6 (Spiteful Serenity)
```

**Time**: 5 minutes (vs. 15 for full version)

---

## 🎯 Decision Point

**Would you like to**:
1. **Add full Build Archetypes** (15 min) - Detailed descriptions + playstyle notes
2. **Add abbreviated version** (5 min) - Just talent path lists
3. **Skip for now** - Focus on Improvement 2 (Prerequisites) instead
4. **Reconsider entire approach** - Different improvement ideas?

---

**Status**: ⏸️ Awaiting your decision on how players will access build guidance
