# Warrior Implementation Tracker

Track your progress as you build the Warrior class!

## ✅ Setup (Complete!)
- [x] Mod project created
- [x] Meta.lsx updated with author info
- [x] Documentation structure created
- [x] Design blueprint completed

---

## 📋 Week 1: Foundation & First Abilities

### Day 1-2: Learn the Mod Kit
- [ ] Open Larian Mod Kit successfully
- [ ] Load BG3Wow project in Mod Kit
- [ ] Explore Stats Editor interface
- [ ] Explore Resource Manager
- [ ] Find where abilities are created

### Day 3-4: Create Rage Resource
- [ ] Create custom resource `RES_VORGX_WAR_RAGE`
- [ ] Set max value to 100
- [ ] Test resource shows up in editor
- [ ] Generate UUID for resource
- [ ] Document UUID in reference file

### Day 5-7: First Two Abilities
- [ ] Create Charge ability
  - [ ] Set name and display text
  - [ ] Configure as melee leap
  - [ ] Add weapon damage
  - [ ] Add 20 Rage generation
  - [ ] Add root effect (1 turn)
  - [ ] Test in-game (add to existing class)
  
- [ ] Create Heroic Strike ability
  - [ ] Set name and display text
  - [ ] Configure as melee attack
  - [ ] Set damage: 1d8 + Str
  - [ ] Set cost: 30 Rage
  - [ ] Test in-game

**Week 1 Goal:** Have 2 working abilities you can use in-game! 🎯

---

## 📋 Week 2: Base Warrior Class

### Create Class Definition
- [ ] Create new Class in Stats Editor
- [ ] Set name: `CLASS_VORGX_WARRIOR`
- [ ] Generate UUID for class
- [ ] Set hit die: d10
- [ ] Set primary ability: Strength
- [ ] Set saves: Strength, Constitution
- [ ] Add armor proficiencies (all)
- [ ] Add weapon proficiencies (Simple, Martial)
- [ ] Create ClassDescription.lsx entry

### Create Remaining Core Abilities
- [ ] Battle Shout
  - [ ] Bonus action
  - [ ] +2 attack to allies in 9m
  - [ ] 3 turn duration
  - [ ] Generate 10 Rage
  
- [ ] Execute
  - [ ] Melee attack
  - [ ] 2d8 base damage
  - [ ] 4d8 if target < 20% HP
  - [ ] Costs 30 Rage
  
- [ ] Rage Passive
  - [ ] Grant Rage resource
  - [ ] Display in passive list

### Create Progression Table
- [ ] Create Warrior progression table
- [ ] Generate progression UUID
- [ ] Add Level 1 grants:
  - [ ] Rage passive
  - [ ] Charge
  - [ ] Heroic Strike
- [ ] Add Level 2 grants:
  - [ ] Battle Shout
- [ ] Add Level 3 grants:
  - [ ] Subclass choice
  - [ ] Execute

### Create Localization
- [ ] Create English.loca.xml
- [ ] Add class name/description
- [ ] Add all ability names
- [ ] Add all ability descriptions

### Testing
- [ ] Export to .pak
- [ ] Enable mod in BG3
- [ ] Create new Warrior character
- [ ] Test level 1 abilities work
- [ ] Test level 2 (Battle Shout)
- [ ] Test level 3 (Execute)

**Week 2 Goal:** Playable Warrior class through level 3! 🎯

---

## 📋 Week 3: Arms Subclass

### Create Arms Subclass
- [ ] Create subclass in Stats Editor
- [ ] Set name: `SUBCLASS_VORGX_WAR_ARMS`
- [ ] Generate UUID
- [ ] Link to parent Warrior class
- [ ] Add to subclass list in Warrior progression

### Create Arms Abilities
- [ ] Mortal Strike
  - [ ] 2d10 + Str damage
  - [ ] 30 Rage cost
  - [ ] Apply Healing Reduction (50%, 2 turns)
  - [ ] 1 turn cooldown
  
- [ ] Weapon Mastery (Passive)
  - [ ] +1 attack with 2H weapons
  - [ ] +1 damage with 2H weapons
  
- [ ] Overpower
  - [ ] 1d12 + Str damage
  - [ ] 20 Rage cost
  - [ ] Ignore 50% target AC
  - [ ] Bonus action
  
- [ ] Colossus Smash
  - [ ] 2d12 + Str damage
  - [ ] 40 Rage cost
  - [ ] -3 AC to target (2 turns)
  - [ ] 2 turn cooldown

### Create Arms Progression
- [ ] Level 3: Mortal Strike, Weapon Mastery
- [ ] Level 5: Overpower
- [ ] Level 7: Colossus Smash

### Localization
- [ ] Add Arms subclass name/description
- [ ] Add all Arms ability names
- [ ] Add all Arms ability descriptions

### Testing
- [ ] Export updated .pak
- [ ] Create Arms Warrior
- [ ] Test Mortal Strike at L3
- [ ] Test Overpower at L5
- [ ] Test Colossus Smash at L7
- [ ] Playthrough test L1-10

**Week 3 Goal:** Full Arms specialization playable! 🎯

---

## 📋 Week 4: Fury & Protection + Full Progression

### Create Fury Subclass
- [ ] Create Fury subclass definition
- [ ] Generate UUID
- [ ] Create Fury abilities:
  - [ ] Rampage (4 attacks, 1d6 each)
  - [ ] Bloodthirst (damage + heal)
  - [ ] Enrage passive (crit-based stacking)
  - [ ] Whirlwind (AoE)
- [ ] Create Fury progression (L3, 5, 7)
- [ ] Add localization

### Create Protection Subclass
- [ ] Create Protection subclass definition
- [ ] Generate UUID
- [ ] Create Protection abilities:
  - [ ] Shield Slam (damage + daze)
  - [ ] Shield Block (damage reduction reaction)
  - [ ] Shield Specialization passive (+2 AC)
  - [ ] Taunt (forced targeting)
- [ ] Create Protection progression (L3, 5, 7)
- [ ] Add localization

### Complete Level 1-20 Progression
- [ ] Add feat levels (4, 8, 12, 16, 20)
- [ ] Add Extra Attack at L5
- [ ] Plan levels 8-20 feature unlocks
- [ ] Wire all subclass progressions
- [ ] Add tier markers (L5, 8, 13, 18)

### Polish & Testing
- [ ] Test all 3 subclasses L1-20
- [ ] Verify all abilities work correctly
- [ ] Check Rage generation/spending balance
- [ ] Verify all text displays correctly
- [ ] Icon pass (if needed)
- [ ] Balance adjustments

### Release v0.1.0
- [ ] Final playthrough test (all 3 subclasses)
- [ ] Create mod page description
- [ ] Take screenshots
- [ ] Package final .pak
- [ ] Upload to Nexus Mods (optional)
- [ ] Update README with release notes

**Week 4 Goal:** Complete, playable Warrior class with 3 subclasses! 🎯🎉

---

## 🎓 Learning Notes

### Problems Encountered:
(Track issues you run into and how you solved them)

1. **Issue:** 
   **Solution:**

2. **Issue:**
   **Solution:**

### Things I Learned:
(Document discoveries and techniques)

- 

### UUIDs Reference:
(Keep track of all generated UUIDs)

```
CLASS_VORGX_WARRIOR = 
SUBCLASS_VORGX_WAR_ARMS = 
SUBCLASS_VORGX_WAR_FURY = 
SUBCLASS_VORGX_WAR_PROT = 

WARRIOR_PROGRESSION = 
ARMS_PROGRESSION = 
FURY_PROGRESSION = 
PROT_PROGRESSION = 

RES_VORGX_WAR_RAGE = 
```

---

## 📝 Quick Commands

### Generate UUID (PowerShell):
```powershell
[guid]::NewGuid()
```

### Test Mod:
1. Export in Mod Kit
2. Copy .pak to: `%LOCALAPPDATA%\Larian Studios\Baldur's Gate 3\Mods`
3. Launch BG3
4. Enable in Mod Manager

### Check Logs:
```
%LOCALAPPDATA%\Larian Studios\Baldur's Gate 3\ScriptExtender\Logs
```

---

**Keep this file updated as you progress! Mark items complete and add notes. Good luck! ⚔️**
