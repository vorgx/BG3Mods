# Warrior Class - Implementation Guide

## 📋 What You Have Now

✅ **Warrior_Class_Blueprint.json** - Your complete design document  
✅ **BG3Wow mod project** - Empty but ready  
✅ **Larian Mod Kit** - Installed and ready to use

## 🎯 Your Goal

Build a playable Warrior class with 3 subclasses (Arms, Fury, Protection) from levels 1-20.

---

## 📅 Implementation Roadmap

### **WEEK 1: Learn the Tools & Create First Ability**

#### Day 1-2: Mod Kit Familiarization
1. **Open the Larian Mod Kit** (usually in `C:\Program Files (x86)\Steam\steamapps\common\Baldurs Gate 3\bin\LSModKit.exe`)
2. **Load your project**: File → Open Project → Browse to `BG3Mods` folder
3. **Explore the interface**:
   - Resource Manager (left panel)
   - Stats Editor
   - Script Editor
   - Asset Browser

#### Day 3-4: Create Your First Resource (Rage)
1. In Mod Kit: **Tools → Resource Manager**
2. Create new **Boosts** resource type
3. Create `RES_VORGX_WAR_RAGE`:
   - Type: Custom Resource
   - Max Value: 100
   - Default: 0
   - Icon: (use placeholder or find warrior icon)

#### Day 5-7: Create First Two Abilities

**Ability 1: Charge (Builder)**
- Go to **Stats Editor → Interrupt Data**
- Create new **Spell** (yes, abilities are technically spells in BG3):
  - Name: `ACTION_VORGX_WAR_CHARGE`
  - Display Name: "Charge"
  - Type: Target
  - Range: 18m
  - Effects:
    - Deal weapon damage
    - Teleport caster to target
    - Add 20 Rage to caster
    - Root target for 1 turn
  
**Ability 2: Heroic Strike (Spender)**
- Create new Spell:
  - Name: `ACTION_VORGX_WAR_HEROIC_STRIKE`
  - Display Name: "Heroic Strike"
  - Type: Target
  - Range: Melee (1.5m)
  - Resource Cost: 30 Rage
  - Damage: 1d8 + Strength Modifier
  - Damage Type: Slashing

**✅ WEEK 1 MILESTONE**: Test these 2 abilities in-game by adding them to an existing class temporarily

---

### **WEEK 2: Build Base Warrior Class**

#### Tasks:
1. **Create Class Definition**
   - In Mod Kit: **Stats Editor → Class Descriptions**
   - Create `CLASS_VORGX_WARRIOR`
   - Set base stats from blueprint (d10 HD, Str/Con saves, etc.)

2. **Add Core Abilities** (from §5)
   - Create remaining abilities:
     - Battle Shout
     - Execute
     - Rage passive

3. **Create Progression Table**
   - **Stats Editor → Progressions**
   - Create `WARRIOR_PROGRESSION`
   - Add level 1 grants:
     - Rage passive
     - Charge
     - Heroic Strike
   - Add level 2-3 grants

**✅ WEEK 2 MILESTONE**: Playable Warrior base class through level 3

---

### **WEEK 3: First Subclass (Arms)**

#### Tasks:
1. **Create Subclass Definition**
   - Stats Editor → Subclass
   - Create `SUBCLASS_VORGX_WAR_ARMS`

2. **Create Arms Abilities** (from §7)
   - Mortal Strike (signature ability)
   - Weapon Mastery (passive)
   - Overpower
   - Colossus Smash

3. **Wire Subclass Progression**
   - Add subclass choice at level 3
   - Grant Arms abilities at levels 3, 5, 7

**✅ WEEK 3 MILESTONE**: Warrior + Arms subclass playable 1-10

---

### **WEEK 4: Add Fury & Protection**

#### Tasks:
1. **Create Fury Subclass** (from §7)
   - Rampage, Bloodthirst, Enrage, Whirlwind
   
2. **Create Protection Subclass** (from §7)
   - Shield Slam, Shield Block, Shield Spec, Taunt

3. **Full Progression 1-20**
   - Wire all abilities
   - Add ASI/Feats at 4/8/12/16/20
   - Extra Attack at 5

**✅ WEEK 4 MILESTONE**: Complete 3-subclass Warrior, testable 1-20

---

## 🛠️ Key Files You'll Be Creating

Your mod will generate files in these locations:

```
Data/
  Mods/BG3Wow_.../
    meta.lsx                    ← Already exists, we updated it
    
  Public/BG3Wow_.../
    Stats/Generated/
      Data/
        Spell_*.txt             ← Abilities defined here
        Status_*.txt            ← Buffs/debuffs
        Passive_*.txt           ← Passive abilities
        
    ClassDescriptions/
      ClassDescriptions.lsx     ← Class/Subclass definitions
      
    Progressions/
      Progressions.lsx          ← Level-up grants
      
    Localization/English/
      English.loca.xml          ← All text strings
```

---

## 🎓 BG3 Modding Crash Course

### Key Concepts:

1. **Everything is a "Spell"**
   - Active abilities = Spells (Target, Projectile, Zone, etc.)
   - Even melee attacks are technically spells

2. **Stats.txt Syntax**
   - BG3 uses proprietary `.txt` files for game data
   - Format: `new entry "KeyName"`
   - Each property: `type "PropertyName" "Value"`

3. **LSX Files**
   - XML-based (Larian Studio XML)
   - Used for: Classes, Progressions, Templates
   - Edit in Mod Kit or text editor

4. **Progressions**
   - Controls what you get at each level
   - Format: Level → Grants (Spells, Passives, Feats)

5. **Localization**
   - All player-facing text in `.loca.xml`
   - Format: `<content contentuid="UUID" version="1">Text</content>`

---

## 📚 Resources

### Official:
- [Larian Modding Wiki](https://docs.larian.game/Main_Page)
- BG3 Mod Kit Documentation (in install folder)

### Community:
- [BG3 Modding Community Discord](https://discord.gg/bg3mods)
- [Nexus Mods BG3](https://www.nexusmods.com/baldursgate3)
- **r/BaldursGate3Mods** subreddit

### Tools:
- **LSLib** - For .pak packing/unpacking
- **BG3 Mod Manager** - For testing
- **VS Code** - For editing .lsx and .txt files

---

## 🚀 Quick Start Commands

### Testing Your Mod:
1. In Mod Kit: **File → Export to Mod Fixer**
2. Creates `.pak` file in `%LOCALAPPDATA%\Larian Studios\Baldur's Gate 3\Mods`
3. Launch BG3, enable mod in Mod Manager
4. Create new character, select Warrior class

### Common Issues:

**"Mod doesn't appear in-game"**
- Check `meta.lsx` has correct UUID
- Verify .pak was created
- Check Mod Manager shows it as enabled

**"Abilities don't show up"**
- Verify Progressions.lsx grants them at correct level
- Check Stats.txt syntax (one typo breaks everything)
- Look at Script Extender logs

**"Game crashes"**
- Usually a malformed LSX file
- Validate XML syntax
- Check for circular dependencies

---

## 🎯 Your Next Action

**RIGHT NOW:**

1. ✅ Read through `Warrior_Class_Blueprint.json`
2. ✅ Open Larian Mod Kit
3. ✅ Create the Rage resource
4. ✅ Create Charge ability
5. ✅ Add it to an existing class temporarily to test
6. ✅ See it work in-game!

**Then:**
- Follow Week 1 plan above
- Ask questions as you go
- Iterate and test frequently

---

## 💡 Pro Tips

1. **Test early, test often** - Don't build 20 abilities before testing
2. **Copy from vanilla** - Look at Fighter/Barbarian for reference
3. **One subclass at a time** - Don't try to do all 3 at once
4. **Use Script Extender** - Install it for better error messages
5. **Join the Discord** - Community is very helpful

---

**You've got this! Start small, iterate, and build up. The blueprint is your north star, but the Mod Kit is where the magic happens.** 🎮⚔️
