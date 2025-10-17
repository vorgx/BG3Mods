# Tests/02_ExampleMods

**Purpose**: Example mod implementations for reference and learning.

---

## 📚 **Contents**

This folder contains **3 example mod folders** demonstrating BG3 class mod implementations.

### **Example Mod Folders**
| Folder | Purpose | Use Case |
|--------|---------|----------|
| `ExampleMod_5eSpells/` | Reference implementation for D&D 5e spell conversion | Study spell syntax, localization, icons |
| `ExampleMod_WoWWarlock/` | Reference WoW Warlock class mod | WoW→BG3 class conversion patterns |
| `MinimalMod/` | Minimal mod template | Bootstrapping new mods |

---

## 🔍 **How to Use These Examples**

### **ExampleMod_5eSpells**
**Purpose**: Learn D&D 5e spell conversion to BG3 format

**Key Files to Study**:
- `Spell_*.txt` files → Spell stat definitions
- `Localization/*.loca.xml` → Localization handles
- `Icons/` → Spell icon implementations

**Use Cases**:
- Understanding spell syntax (Target, Shout, Zone, etc.)
- Learning localization handle patterns
- Implementing spell icons

### **ExampleMod_WoWWarlock**
**Purpose**: Reference WoW→BG3 class conversion patterns

**Key Files to Study**:
- `ClassDescriptions.lsx` → Class definition structure
- `Progressions.lsx` → Level progression tables
- `Passive.txt` → Passive ability implementations

**Use Cases**:
- WoW class conversion workflows
- Resource system implementations (Soul Shards, Rage, etc.)
- Specialization/subclass structure

**⚠️ Note**: This is also available in `My Documentation/07_ReferenceMods/WoWWarlock/`

### **MinimalMod**
**Purpose**: Bare-bones mod template for quick starts

**Key Files to Study**:
- `meta.lsx` → Minimal metadata structure
- Folder structure → Required directories

**Use Cases**:
- Bootstrapping new mods
- Understanding minimal required files
- Testing folder structure

---

## 🧩 **Relationship to BG3Wow Project**

### **ExampleMod_5eSpells**
- **Relevance**: Spell syntax reference for BG3Wow abilities
- **Cross-Reference**: Compare with `Data/Public/.../Stats/Generated/Data/Spell_*.txt`
- **Learning Goal**: Understand BG3 spell implementation patterns

### **ExampleMod_WoWWarlock**
- **Relevance**: WoW→BG3 conversion patterns (same methodology as BG3Wow Warrior)
- **Cross-Reference**: Compare with `Data/Public/.../ClassDescriptions.lsx` and `Progressions.lsx`
- **Learning Goal**: Study resource system implementation (Soul Shards vs. Rage)

### **MinimalMod**
- **Relevance**: Template for future BG3 class mods
- **Cross-Reference**: Use with `initialize_new_mod.py` for automation
- **Learning Goal**: Understand minimal mod requirements

---

## 📊 **Example Mod Comparison**

| Feature | ExampleMod_5eSpells | ExampleMod_WoWWarlock | MinimalMod |
|---------|---------------------|----------------------|------------|
| **Complexity** | Medium | High | Low |
| **Class Type** | Spell conversion | Full class mod | Template |
| **Resource System** | N/A | Soul Shards | N/A |
| **Localization** | ✅ Complete | ✅ Complete | ❌ Minimal |
| **Progressions** | ❌ N/A | ✅ Complete (L1-20) | ❌ N/A |
| **Best For** | Learning spell syntax | Learning WoW conversions | Quick starts |

---

## 🔧 **Integration with BG3Wow Warrior**

### **Using Examples for BG3Wow Development**

#### **From ExampleMod_5eSpells**
1. **Spell Syntax**: Study how to structure `Spell_Target.txt`, `Spell_Zone.txt` entries
2. **Localization**: Learn handle format (`h[8hex][2digit]`)
3. **Icons**: Understand icon file structure and references

#### **From ExampleMod_WoWWarlock**
1. **Class Structure**: Study `ClassDescriptions.lsx` for WoW class conversion
2. **Progression Tables**: Learn how to structure `Progressions.lsx` for L1-20
3. **Resource System**: Compare Soul Shards implementation to BG3Wow Rage system
4. **Passives**: Study `Passive.txt` for passive ability patterns

#### **From MinimalMod**
1. **Folder Structure**: Verify required directories for new mods
2. **meta.lsx Template**: Use as base for new mod metadata
3. **Quick Testing**: Use for rapid prototyping

---

## 🚀 **Quick Start with Examples**

### **Studying a Specific Example**
1. Navigate to the example folder (e.g., `ExampleMod_WoWWarlock/`)
2. Open `meta.lsx` to understand UUID, name, version
3. Review `ClassDescriptions.lsx` for class definitions
4. Examine `Progressions.lsx` for level progression
5. Study `Spell_*.txt` files for ability implementations

### **Comparing with BG3Wow**
1. Open BG3Wow's equivalent file (e.g., `Data/Public/.../Progressions.lsx`)
2. Use side-by-side comparison in VS Code
3. Note differences in structure, naming conventions
4. Apply patterns from examples to BG3Wow implementations

---

## ⚠️ **Important Notes**

### **Version Compatibility**
- ✅ ExampleMod_5eSpells: Patch 8 compatible
- ⚠️ ExampleMod_WoWWarlock: May need updates for Patch 8 (verify LSLib package version)
- ✅ MinimalMod: Universal template

### **UUID Conflicts**
- ⚠️ **NEVER** use UUIDs from example mods in your own mods!
- Each mod MUST have a unique UUID (generated via `uuid.uuid4()` in Python or `New-Guid` in PowerShell)
- BG3Wow UUID: `78fe4967-4e62-5491-d981-dd781acca4d7`

### **Localization Handles**
- ⚠️ **NEVER** reuse localization handles (`h[8hex][2digit]`) from example mods!
- Each mod should generate unique handles (increment counter for each new string)

---

## 🔗 **Related Documentation**

- **Reference Mods**: `My Documentation/07_ReferenceMods/` (WoWPriest, WoWDeathKnight, WoWWarlock)
- **Class Blueprint**: `My Documentation/02_DesignDocuments/Class Blueprint Template Full v1.md`
- **Ability Inventory**: `My Documentation/01_ProjectDocuments/ABILITY_IMPLEMENTATION_INVENTORY.md`
- **Community Library**: https://github.com/BG3-Community-Library-Team/BG3-Community-Library/wiki (shared spells/scripts)

---

**Last Updated**: October 17, 2025  
**Maintained By**: BG3Wow Development Team  
**For Questions**: See `DOCUMENTATION_LIBRARY.md` for comprehensive topic index
