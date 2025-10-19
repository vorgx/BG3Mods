# SubclassBase Ability Reordering - Complete

**Date:** October 17, 2025  
**Purpose:** Document the reordering of SubclassBase baseline abilities to better support each subclass's unique identity  
**Status:** ✅ COMPLETE - All 4 documentation files updated

---

## Change Summary

**What Changed:** The 12 baseline abilities (SubclassBase Talents) are now granted in **different orders** for each subclass (Arms/Fury/Protection) to support their unique playstyle and identity from early levels.

**What Stayed the Same:** All 3 subclasses still receive all 12 abilities by level 12. Only the **order** changed.

---

## New Ability Order by Subclass

### Arms Warrior (Two-Handed DPS)

| Level | Ability | Rationale |
|-------|---------|-----------|
| **L3** | Whirlwind | AoE cleave identity from the start |
| **L4** | Execute | ⭐ **Arms specialty** - Execute earlier than other specs |
| **L5** | Hamstring | Tactical slow for precision control |
| **L6** | Slam | Basic filler damage |
| **L7** | Charge | Gap closer for engagement |
| **L8** | Victory Rush | Sustain tool |
| **L9** | Heroic Throw | Ranged pull utility |
| **L10** | Shield Slam | Shield utility option (1H+shield builds) |
| **L11** | Pummel | Interrupt |
| **L12** | Battle Shout | Party buff |
| **L12** | Berserker Rage | Cleanse |
| **L12** | Taunt | Utility |

**Early Power Curve:** Whirlwind → Execute → Hamstring gives strong early DPS rotation

---

### Fury Warrior (Dual-Wield DPS)

| Level | Ability | Rationale |
|-------|---------|-----------|
| **L3** | Whirlwind | Dual-wield AoE identity |
| **L4** | Slam | Fast filler for rage spending |
| **L5** | Berserker Rage | ⭐ **Enrage mechanic early** - Core to Fury identity |
| **L6** | Charge | Early mobility for aggressive playstyle |
| **L7** | Victory Rush | Sustain for risky gameplay |
| **L8** | Execute | Execute phase tool |
| **L9** | Heroic Throw | Ranged utility |
| **L10** | Hamstring | Utility slow |
| **L11** | Pummel | Interrupt |
| **L12** | Battle Shout | Party buff |
| **L12** | Taunt | Off-spec utility |
| **L12** | Shield Slam | Off-spec utility |

**Early Power Curve:** Whirlwind → Slam → Berserker Rage establishes dual-wield + enrage identity

---

### Protection Warrior (Shield Tank)

| Level | Ability | Rationale |
|-------|---------|-----------|
| **L3** | Taunt | ⭐ **Core tanking tool** - Can effectively tank from L3 |
| **L4** | Shield Slam | Shield-based damage |
| **L5** | Heroic Throw | Ranged pull tool |
| **L6** | Charge | Gap closer for engagement |
| **L7** | Pummel | Interrupt (critical for tanks) |
| **L8** | Slam | Filler damage |
| **L9** | Execute | Threat spike tool |
| **L10** | Victory Rush | Sustain |
| **L11** | Whirlwind | AoE threat generation |
| **L12** | Battle Shout | Party buff |
| **L12** | Hamstring | Utility slow |
| **L12** | Berserker Rage | Cleanse |

**Early Power Curve:** Taunt → Shield Slam → Heroic Throw establishes tank identity immediately

---

## Key Improvements

✅ **Protection gets Taunt at L3** (not L12) - Can actually tank from subclass selection  
✅ **Arms gets Execute at L4** (not L8) - Reinforces Arms as the Execute specialist  
✅ **Fury gets Berserker Rage at L5** (not L12) - Enrage mechanics define Fury gameplay early  
✅ **Each spec feels unique** - Different rotations and identities from L3-7  
✅ **Better synergy** - Abilities support spec playstyle immediately  
✅ **Logical power curve** - Core tools → Filler → Utility → Off-spec tools

---

## Design Rationale

### Problem with Old System (All Specs Identical)

**Old Progression (All Specs):**
- L3: Whirlwind → L4: Slam → L5: Shield Slam → L6: Hamstring → L7: Victory Rush → L8: Execute → L9: Heroic Throw → L10: Charge → L11: Pummel → L12: Battle Shout, Berserker Rage, Taunt

**Issues:**
1. Protection couldn't effectively tank until L12 (Taunt)
2. All specs played identically in early levels
3. Shield Slam at L5 for Arms (doesn't use shields typically)
4. No early identity differentiation

### Solution: Spec-Specific Ordering

Each subclass receives the same 12 abilities but in an order that:
- **Supports their core identity** (Execute for Arms, Enrage for Fury, Taunt for Prot)
- **Enables their playstyle early** (Tanks can tank, DPS can DPS)
- **Creates unique rotations** (Different ability availability = different gameplay)
- **Maintains balance** (All abilities by L12, same total power)

---

## Files Updated

### ✅ Priority 1: Core Design Documents

**1. Warrior_Class_Blueprint.md** (Lines 199-230)
- Replaced single ability list with 3 spec-specific lists
- Added design rationale section
- Added status confirmation (all abilities exist)

**2. ARMS_WARRIOR_5_POOL_TALENT_SYSTEM.md** (Lines 690-850)
- Updated POOL 3 section with new progression order
- Added Arms-specific L3-L12 progression table
- Added comparison tables for Fury & Protection
- Updated implementation status section

### ✅ Priority 2: Validation Reports

**3. WOW_SOURCE_IMPLEMENTATION_STATUS.md** (Lines 20-40)
- Updated baseline abilities tables with level columns for all 3 specs
- Added visual markers (⭐) for key differences
- Added "Key Differences" summary section

### ✅ Priority 3: Reference Documents

**4. Talets mechanics.md** (Lines 5-80)
- Updated SubclassBase description with v2.0 notes
- Changed JSON template from bucket system to auto-granted
- Updated notes to reference new system

---

## Implementation Notes

### BG3 Implementation Method

**Old System (Planned):**
```xml
<!-- Bucket system with player choice -->
<node id="SelectPassives">
    <attribute id="Amount" value="1"/>
    <attribute id="Passives" value="LIST_SUBCLASSBASE_ALL"/>
</node>
```

**New System (Implemented):**
```xml
<!-- Auto-granted at specific levels per subclass -->
<node id="Progression">
    <attribute id="Level" value="3"/>
    <attribute id="Boosts" value="UnlockSpell(Target_WAR_Taunt)"/>  <!-- Protection only -->
</node>

<node id="Progression">
    <attribute id="Level" value="3"/>
    <attribute id="Boosts" value="UnlockSpell(Zone_WAR_Whirlwind)"/>  <!-- Arms/Fury only -->
</node>
```

**Method:**
- Use subclass-specific Progressions.lsx entries
- Different `UnlockSpell()` boosts at different levels per spec
- All abilities already exist (no new spells needed)

---

## Testing Checklist

### Per-Subclass Testing

**Arms Warrior:**
- [ ] Whirlwind unlocks at L3
- [ ] Execute unlocks at L4 (earlier than other specs)
- [ ] Shield Slam unlocks at L10 (later than Protection)
- [ ] Taunt unlocks at L12 (later than Protection)

**Fury Warrior:**
- [ ] Whirlwind unlocks at L3
- [ ] Berserker Rage unlocks at L5 (earlier than other specs)
- [ ] Charge unlocks at L6 (earlier than Arms)
- [ ] Execute unlocks at L8 (later than Arms)

**Protection Warrior:**
- [ ] Taunt unlocks at L3 (much earlier than other specs)
- [ ] Shield Slam unlocks at L4 (earlier than other specs)
- [ ] Charge unlocks at L6 (same as Fury)
- [ ] Whirlwind unlocks at L11 (later than other specs)

### Balance Testing

- [ ] All 3 specs have all 12 abilities by L12
- [ ] Early-level power feels balanced across specs
- [ ] Each spec has viable rotation from L3-5
- [ ] Spec identity is clear from early levels

---

## Cross-References

**Related Documents:**
- `Warrior_Class_Blueprint.md` - Main blueprint with all 3 spec progressions
- `ARMS_WARRIOR_5_POOL_TALENT_SYSTEM.md` - Complete Arms 5-pool system
- `WOW_SOURCE_IMPLEMENTATION_STATUS.md` - Implementation status tracking
- `Talets mechanics.md` - Technical reference for talent system

**Next Steps:**
- Create Fury & Protection 5-pool documents (similar to Arms)
- Update Progressions.lsx with subclass-specific unlock levels
- Test in-game to verify spec identity feels distinct

---

## Conclusion

✅ **SubclassBase reordering is complete** - All documentation updated with new spec-specific ability orders

**Impact:**
- Protection can tank from L3 (Taunt)
- Arms gets Execute specialty at L4
- Fury gets enrage identity at L5
- All specs feel unique from early levels

**Status:** Ready for implementation in Progressions.lsx

---

**Last Updated:** October 17, 2025  
**Author:** AI Assistant with user approval  
**Version:** v2.0 Design Specification
