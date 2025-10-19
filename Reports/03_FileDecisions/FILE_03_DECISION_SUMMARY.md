# FILE 3 DECISION SUMMARY: ActionResourceDefinitions.lsx

**Date**: October 18, 2025  
**Status**: ⏸️ AWAITING USER DECISION  
**Context**: Transforming Warlock's 10 resources to Warrior system

---

## 🎯 YOUR OPTIONS

### **OPTION A: Rage Only (Simple & Fast)**

**Resources**: 1 total (just Rage)

**Time to Implement**: ⏱️ **15 minutes**

**What You Get**:
- ✅ Single Rage resource (0-100, combat generation)
- ✅ All abilities cost Rage + Action Points
- ✅ Cooldowns remain as OncePerShortRest/OncePerLongRest
- ✅ Simple, classic Warrior feel
- ✅ Easy to understand for players

**What You DON'T Get**:
- ❌ No charge-based abilities (can't use 2 Heroic Leaps)
- ❌ No visual proc tracking (Overpower procs hidden in status effects)
- ❌ No talent interactions with charges (only cooldown reductions)
- ❌ No specialization-unique resources (Mountain Thane feels same as others)
- ❌ Rigid cooldowns (can't adapt to situation)

**Implementation**:
```xml
<!-- Single resource -->
<node id="ActionResourceDefinition">
    <attribute id="Name" value="Rage"/>
    <attribute id="MaxValue" value="100"/>
    <attribute id="ReplenishType" value="Never"/>
    <attribute id="UUID" value="a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d"/>
</node>
```

**Best For**: Players who want classic, simple Warrior gameplay without complexity

---

### **OPTION B: Rage + 5 Charges (Recommended - Deep Tactical Play)** ⭐

**Resources**: 6 total (Rage + 5 charges)

**Time to Implement**: ⏱️ **4-6 hours**

**What You Get**:
- ✅ Rage resource (0-100) for all attacks
- ✅ **DefensiveCharge (1)**: Choose Die by the Sword OR Berserker Rage
- ✅ **TankCooldown (1)**: Choose Last Stand OR Shield Wall OR Indomitable (Protection)
- ✅ **MobilityCharge (2)**: Mix and match Heroic Leap + Intervene + Storm Bolt
- ✅ **OverpowerCharge (2)**: Visible proc tracking for Arms spec
- ✅ **ThunderCharge (3)**: Mountain Thane's unique lightning resource
- ✅ Flexible cooldowns (can use 2 leaps if needed)
- ✅ Visual proc feedback (see charge bars fill up)
- ✅ **16+ talent interactions** (charges can be refunded, caps increased, effects scaled)
- ✅ Proven system (Warlock mod has 13K+ downloads)

**What You DON'T Get**:
- ❌ Takes longer to implement (4-6 hours vs 15 min)
- ❌ Slightly more complex for players to learn
- ❌ Need to update 8 spell files + passives

**Charge Details**:

| Charge | Max | Refill | Used By | Strategic Choice |
|--------|-----|--------|---------|------------------|
| DefensiveCharge | 1 | Rest | Die by the Sword, Berserker Rage | "Parry all OR break CC?" |
| TankCooldown | 1 | Rest | Last Stand, Shield Wall, Indomitable | "HP, mitigation, or immunity?" |
| MobilityCharge | 2 | ShortRest | Heroic Leap, Intervene, Storm Bolt | "Double leap OR leap+stun?" |
| OverpowerCharge | 2 | Proc | Overpower (Arms) | "Spend now or save?" |
| ThunderCharge | 3 | Proc | Thunder Clap (Mountain Thane) | "When to unleash?" |

**Talent Interactions**: 7 existing talents can be enhanced + 9 new talents possible = 16+ interactions

**Best For**: Players who want tactical depth, flexible cooldowns, and build customization

---

### **OPTION C: Rage + SOME Charges (Custom Mix)**

**Resources**: 2-5 total (Rage + your choice)

**Time to Implement**: ⏱️ **2-5 hours** (depends on count)

**What You Get**:
- ✅ Rage resource (mandatory)
- ✅ Pick which charges to include from B's list
- ✅ Balance complexity vs. tactical depth

**Example Combinations**:

**C1: Rage + Mobility Only** (2 resources, ~2 hours)
- MobilityCharge (2): Heroic Leap, Intervene, Storm Bolt
- Skip defensive/tank/proc charges
- **For**: Players who want flexible movement but simple combat

**C2: Rage + Proc Charges Only** (3 resources, ~3 hours)
- OverpowerCharge (2): Arms reactive damage
- ThunderCharge (3): Mountain Thane lightning
- Skip defensive/tank/mobility charges
- **For**: Players who want spec identity but standard cooldowns

**C3: Rage + Defensive Only** (3 resources, ~2 hours)
- DefensiveCharge (1): Die by the Sword, Berserker Rage
- TankCooldown (1): Last Stand, Shield Wall, Indomitable
- Skip mobility/proc charges
- **For**: Tanks who want flexible defense but simple offense

**Best For**: Players who want SOME tactical depth but not full complexity

---

### **OPTION D: Custom Modifications**

**Resources**: Whatever you design

**Time to Implement**: ⏱️ **Varies**

**What You Get**:
- ✅ Fully custom resource system
- ✅ Mix of charges, counters, stacks, or unique mechanics
- ✅ Your vision, your way

**Examples**:
- "Rage + just MobilityCharge + ThunderCharge"
- "Rage + universal CooldownCharge (shared by ALL cooldowns)"
- "Rage + FuryCharge (Fury spec only) + ProtectionCharge (Protection spec only)"

**Best For**: You have a specific vision not covered by A/B/C

---

## 📊 QUICK COMPARISON TABLE

| Feature | Option A | Option B | Option C | Option D |
|---------|----------|----------|----------|----------|
| **Time** | 15 min | 4-6 hours | 2-5 hours | Varies |
| **Resources** | 1 (Rage) | 6 (Rage + 5) | 2-5 | Custom |
| **Flexibility** | Low | High | Medium | Custom |
| **Visual Procs** | No | Yes | Maybe | Custom |
| **Talent Interactions** | 7 | 16+ | 7-12 | Custom |
| **Player Complexity** | Very Low | Medium | Low-Medium | Custom |
| **Strategic Depth** | Low | High | Medium | Custom |
| **Specialization Identity** | Low | High | Medium | Custom |

---

## 🎮 GAMEPLAY COMPARISON

### **Option A (Rage Only)**
```
Turn 1: Heroic Leap [USED] → Wait until Short Rest
Turn 2: Die by the Sword [USED] → Wait until Long Rest
Turn 3: Overpower proc hidden in status bar (no visual feedback)
Turn 4: Thunder Clap (no special effect, just damage)
```
**Feel**: Simple, straightforward, classic

### **Option B (Rage + 5 Charges)**
```
Turn 1: Heroic Leap [1 MobilityCharge spent, 1 remaining]
Turn 2: Enemy dodge → +1 OverpowerCharge [⚡ 1/2 visible]
Turn 3: Shield Slam → +1 ThunderCharge [⚡ 1/3 visible]
Turn 4: Decide: Save DefensiveCharge for boss OR use now?
Turn 5: Thunder Clap with 3 charges → MASSIVE DAMAGE
```
**Feel**: Tactical, engaging, high skill ceiling

---

## 💡 RECOMMENDATIONS BASED ON GOALS

### **Choose A if you want**:
- ✅ Fastest implementation (15 min)
- ✅ Simplest gameplay
- ✅ Classic Warrior feel
- ✅ No learning curve for players

### **Choose B if you want**:
- ✅ Proven system (Warlock template)
- ✅ Deep customization (16+ talent interactions)
- ✅ Flexible cooldowns (double leap possible)
- ✅ Visual proc tracking (see charges)
- ✅ Specialization identity (unique resources)
- ✅ High skill ceiling gameplay

### **Choose C if you want**:
- ✅ Some tactical depth
- ✅ Faster than B (2-5 hours)
- ✅ Pick specific features you like
- ✅ Balance complexity vs. depth

### **Choose D if you want**:
- ✅ Total creative control
- ✅ Unique system not listed above

---

## 🏆 MY RECOMMENDATION: **OPTION B**

**Why?**
1. **Proven Pattern**: Warlock mod (13K+ downloads) uses this successfully
2. **Future-Proof**: Can add 9 new charge-modifying talents later
3. **Specialization Identity**: Mountain Thane FEELS different (ThunderCharges)
4. **Flexibility**: Use 2 Heroic Leaps if you need mobility
5. **Visual Feedback**: Players SEE "2 Overpower procs ready!" 
6. **High Skill Ceiling**: Rewards good play (charge management, proc tracking)
7. **Build Diversity**: Charge-focused builds vs. standard builds
8. **Power Spikes**: L20 talents can increase charge caps (2 tank cooldowns!)

**Tradeoff**: Takes 4-6 hours instead of 15 minutes, but unlocks WAY more gameplay depth.

---

## ❓ FINAL DECISION QUESTIONS

Before you choose, consider:

1. **Time Budget**: Do you have 15 min (A) or 4-6 hours (B)?
2. **Complexity Tolerance**: Simple (A) or Tactical (B)?
3. **Player Audience**: Casual (A) or Hardcore (B)?
4. **Future Plans**: One-and-done (A) or Expandable (B)?
5. **Specialization Identity**: Generic (A) or Unique per spec (B)?

---

## 🎯 TO PROCEED, REPLY WITH:

- **"A"** → Rage only (15 min, simple)
- **"B"** → Rage + 5 charges (4-6 hours, recommended)
- **"C1"** → Rage + Mobility only
- **"C2"** → Rage + Proc charges only
- **"C3"** → Rage + Defensive only
- **"D"** → Custom (describe what you want)

I'm ready to start transforming FILE 3 as soon as you decide! 🚀
