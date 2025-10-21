# BG3Wow - World of Warcraft Classes for Baldur's Gate 3

A comprehensive mod bringing WoW classes to BG3, starting with the **Warrior** class and its three specializations: Arms, Fury, and Protection.

> **⚡ ONE-KEYSTROKE BUILDS!**  
> Press **`Ctrl+Shift+B`** in VS Code to build your mod in ~10 seconds.  
> See: [Quick Reference](QUICK_REFERENCE.md) | [Full Index](INDEX.md)

> **📚 NEW: Unified Documentation Folder**  
> All documentation merged into single folder! See **[INDEX.md](INDEX.md)** for complete navigation.  
> All guides, design docs, and reports → `Documentation/` (13 organized subfolders)  
> Setup guides → `Documentation/02_Setup-Guides/`  
> Design documents → `Documentation/07_DesignDocuments/`

> **📌 SOURCE OF TRUTH - Read First!**  
> **Master Documentation**: [SOURCE_OF_TRUTH.md](Documentation/00_SourcesOfTruth/SOURCE_OF_TRUTH.md) - Current project state (always up-to-date)  
> **Ability Database**: [AbilityDatabase_Warrior_FullyEnriched.csv](Documentation/00_SourcesOfTruth/AbilityDatabase_Warrior_FullyEnriched.csv) - 215 abilities, 100% complete  
> **Folder Policy**: Only 4 files in [00_SourcesOfTruth/](Documentation/00_SourcesOfTruth/README.md) - all others archived

> **🤖 AI Assistants: Read [AI Agent Protocol](Documentation/03_Workflows/AI_AGENT_PROTOCOL.md) FIRST**  
> Mandatory workflow for all AI agents: Read design docs → Scan implementation → Document changes

## 📦 Project Status

**Current Phase:** Initial Setup & Design  
**First Deliverable:** Warrior Class (Arms, Fury, Protection subclasses)  
**Target:** Levels 1-20 with full Rage resource system

## 📚 Documentation

**→ [INDEX.md](INDEX.md)** - Complete documentation navigation hub

### Quick Start - Build & Package
1. **[QUICK_REFERENCE.md](Documentation/03_Workflows/QUICK_REFERENCE.md)** - Visual keyboard shortcuts & workflows
2. **[START_HERE.md](Documentation/02_Setup-Guides/START_HERE.md)** - 5-minute setup guide
3. **[MULTITOOL_SETUP.md](Documentation/02_Setup-Guides/MULTITOOL_SETUP.md)** - Detailed setup for fast builds

### Development Guides
1. **[GETTING_STARTED.md](Documentation/06_ProjectDocuments/GETTING_STARTED.md)** - Step-by-step implementation
2. **[Warrior_Class_Blueprint.md](Documentation/07_DesignDocuments/Warrior_Class_Blueprint.md)** - Complete class design
3. **[FILE_REFERENCE.md](Documentation/06_ProjectDocuments/FILE_REFERENCE.md)** - BG3 file format cheat sheet
4. **[Class Blueprint Template Full v1.md](Documentation/07_DesignDocuments/Class%20Blueprint%20Template%20Full%20v1.md)** - Advanced framework (reference)

### Warrior Class Overview

**Base Class Features:**
- **Primary Ability:** Strength
- **Hit Die:** d10
- **Saves:** Strength, Constitution
- **Resource:** Rage (0-100, builds through combat)
- **Armor:** All armor + shields
- **Weapons:** Simple + Martial

**Core Abilities:**
- Charge (gap closer, generates Rage)
- Heroic Strike (basic Rage spender)
- Battle Shout (party buff)
- Execute (finisher for low-HP targets)

**Subclasses (Level 3):**

**Arms** - Two-handed weapon specialist
- Mortal Strike (signature ability with healing reduction)
- Weapon Mastery (+1 attack/damage with 2H weapons)
- Colossus Smash (armor shredding)

**Fury** - Dual-wielding berserker
- Rampage (multi-attack)
- Bloodthirst (lifesteal)
- Enrage (crit-based damage stacking)
- Whirlwind (AoE)

**Protection** - Shield-based tank
- Shield Slam (damage + daze)
- Shield Block (damage reduction)
- Shield Specialization (+2 AC)
- Taunt (forced targeting)

## 🗂️ Project Structure

```
BG3Mods/
├── Data/
│   ├── Mods/
│   │   └── BG3Wow_.../
│   │       ├── meta.lsx                    ← Mod metadata
│   │       └── Localization/English/       ← Text strings
│   └── Public/
│       └── BG3Wow_.../
│           ├── Content/[PAK]_BG3Wow/       ← Game assets (generated)
│           └── RootTemplates/              ← Templates (generated)
└── My Documentation/
    ├── GETTING_STARTED.md                  ← START HERE
    ├── Warrior_Class_Blueprint.json        ← Design spec
    ├── FILE_REFERENCE.md                   ← Syntax guide
    └── Class Blueprint Template Full v1.md ← Advanced reference
```

## 🎯 Implementation Roadmap

### Week 1: Foundation
- [x] Setup mod project structure
- [ ] Create Rage resource
- [ ] Build first 2 abilities (Charge, Heroic Strike)
- [ ] Test abilities in-game

### Week 2: Base Warrior
- [ ] Complete base Warrior class
- [ ] Add all core abilities
- [ ] Create class progression 1-3
- [ ] Test in character creation

### Week 3: Arms Subclass
- [ ] Create Arms subclass
- [ ] Build Arms abilities
- [ ] Wire Arms progression 3-10
- [ ] Full playthrough test

### Week 4: Fury & Protection
- [ ] Create Fury subclass
- [ ] Create Protection subclass
- [ ] Complete progression 1-20
- [ ] Polish and release v0.1.0

## 🛠️ Tools Required

- **Larian Mod Kit** (comes with BG3)
- **LSLib** (for .pak management)
- **BG3 Script Extender** (recommended for debugging)
- **Text Editor** (VS Code recommended)

## 📖 Learning Resources

- [Larian Modding Wiki](https://docs.larian.game/)
- [BG3 Modding Community Discord](https://discord.gg/bg3mods)
- [Nexus Mods BG3](https://www.nexusmods.com/baldursgate3)

## 🤝 Contributing

This is a personal learning project, but feedback and suggestions are welcome!

## 📄 License

MIT License - See LICENSE file

## 🎮 Author

**vorgx** - Building WoW classes one Rage point at a time!

---

**Next Step:** Open [GETTING_STARTED.md](My%20Documentation/GETTING_STARTED.md) and start building! ⚔️
