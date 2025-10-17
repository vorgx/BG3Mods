# BG3 Modding Resources Bookmarks
**Last Updated:** October 16, 2025

---

## 🔧 Essential Tools

### BG3 Multitool
- **GitHub:** https://github.com/ShinyHobo/BG3-Modders-Multitool
- **Purpose:** Search game files, pack mods, extract resources
- **Required:** Yes (core modding tool)

### LSLib (Norbyte)
- **GitHub:** https://github.com/Norbyte/lslib
- **Releases:** https://github.com/Norbyte/lslib/releases
- **Latest:** v1.20.3 (Sep 2025)
- **Purpose:** Convert LSX/LSF, pack/unpack .pak files, GR2 model conversion
- **Patch 8 Support:** v1.20.0+
- **Master Branch:** https://github.com/Norbyte/lslib/tree/master

### BG3 Script Extender (bg3se)
- **GitHub:** https://github.com/Norbyte/bg3se
- **Purpose:** Lua/Osiris scripting support, advanced modding features
- **Required:** For Lua-based mods only

### BG3 Mod Manager
- **GitHub:** https://github.com/LaughingLeader/BG3ModManager
- **Purpose:** Load order management, mod installation
- **Required:** Highly recommended

---

## 📚 Community Resources

### BG3 Community Library
- **GitHub:** https://github.com/BG3-Community-Library-Team/BG3-Community-Library
- **Wiki:** https://github.com/BG3-Community-Library-Team/BG3-Community-Library/wiki
- **Purpose:** 
  - Common collection of spells, scripts, items, statuses, passives
  - Example implementations for mod authors
  - Compatibility framework (separated as of 2.0.4.1)
- **Key Features:**
  - Using Content in Your Mods: https://github.com/BG3-Community-Library-Team/BG3-Community-Library/wiki/Using-Community-Library-Content
  - Making Contributions: https://github.com/BG3-Community-Library-Team/BG3-Community-Library/wiki/Making-Contributions
  - Development Environment Setup: https://github.com/BG3-Community-Library-Team/BG3-Community-Library/wiki/Setting-up-a-Development-Environment
- **Latest Release:** 2.2.8.4 (Jul 17, 2024)
- **License:** MIT

### BG3 Compatibility Framework
- **GitHub:** https://github.com/BG3-Community-Library-Team/BG3-Compatibility-Framework
- **Purpose:** Subclass compatibility between mods
- **Note:** Separated from Community Library as of v2.0.4.1

### BG3 Best Practices Wiki
- **URL:** https://github.com/Baldurs-Gate-3-modders/Best-Practices-Wiki/wiki
- **Purpose:** Community-curated best practices for BG3 modding

---

## 📖 Official Documentation

### BG3 Wiki
- **Modding Resources:** https://bg3.wiki/wiki/Modding:Modding_resources
- **Creating Mods:** https://bg3.wiki/wiki/Modding:Creating_mods
- **Working with LSX:** https://bg3.wiki/wiki/Modding:Working_with_LSX_files
- **Localization:** https://bg3.wiki/wiki/Modding:Localization
- **Packaging Mods:** https://bg3.wiki/wiki/Modding:Packaging_mods

### Larian Studios Resources
- **Patch 7 Modding:** https://larian.club/Patch7
- **Community Update #29:** https://baldursgate3.game/news/community-update-29-playing-with-mods_124
- **Official Discord:** https://discord.com/invite/larianstudios
  - `#bg3-modding` channel
  - `#bg3-scripting` channel

---

## 🌐 Mod Distribution Sites

### Nexus Mods
- **BG3 Section:** https://www.nexusmods.com/baldursgate3
- **Purpose:** Most popular mod hosting site

### Thunderstore
- **BG3 Section:** https://baldurs-gate-3.thunderstore.io/
- **Purpose:** Alternative mod hosting

### Curse Forge
- **BG3 Section:** https://www.curseforge.com/baldurs-gate-3
- **Purpose:** Alternative mod hosting

---

## 🔍 Reference Implementations

### Extracted Mods (In `My Documentation/`)
- **WoWPriest** (`WoWPriest_f0d7e1dc-1a16-c068-9f62-684b81a1190c/`)
  - Single class with Holy Power resource
  - Basic ActionResourceDefinitions + Progressions structure
  - Patch 8 meta.lsx, Patch 7 data files

- **WoWDeathKnightClass** (`WoWDeathKnightClass/` & `WoWDeathKnightFix/`)
  - Base class + 3 subclasses (Blood/Frost/Unholy)
  - Multiple resources (RunicPower + 3 Rune types)
  - SubClasses node implementation
  - Patch 6 format (older)

### Analysis Documents
- `RESEARCH_FINDINGS_BG3_Structure.md` - WoWPriest analysis
- `RESEARCH_FINDINGS_DeathKnight.md` - WoWDeathKnight + comparison matrix

---

## 💬 Community Channels

### Discord Servers
- **Larian Studios Official:** https://discord.com/invite/larianstudios
  - #bg3-modding
  - #bg3-scripting
- **BG3 Wiki Discord:** https://discord.gg/EYNTAQXaNs

### Forums & Communities
- **Nexus Mods Forums:** https://forums.nexusmods.com/index.php?/forum/10065-baldurs-gate-3/
- **Larian Studios Forums:** https://forums.larian.com/

---

## 🛠️ Technical References

### File Format Documentation
- **LSX Format:** XML-based Larian file format
- **LSF Format:** Binary Larian file format
- **GR2 Format:** Granny 3D model format
- **Conversion:** Use LSLib to convert between formats

### Game Paths (Windows)
- **Profiles:** `%LocalAppData%\Larian Studios\Baldur's Gate 3\PlayerProfiles\Public`
- **Mods (.pak):** `%LocalAppData%\Larian Studios\Baldur's Gate 3\Mods`
- **Mods (loose):** `<game_install>\Baldur's Gate 3\Data`
- **Tools/Scripts:** `<game_install>\Baldur's Gate 3\bin`

### Version Information
- **Current Patch:** Patch 8 (October 2025)
- **LSLib Version:** v1.20.3 (Patch 8 compatible)
- **File Version Format:** `<version major="4" minor="8" revision="0" build="10"/>`

---

## 📋 Quick Reference

### Mod File Structure
```
ModName/
├── Mods/
│   └── ModName/
│       └── meta.lsx (mod metadata, dependencies)
└── Public/
    └── ModName/
        ├── ActionResourceDefinitions/
        │   └── ActionResourceDefinitions.lsx
        ├── ClassDescriptions/
        │   └── ClassDescriptions.lsx
        ├── Progressions/
        │   └── Progressions.lsx
        ├── Stats/
        │   └── Generated/ (Spell/Passive/Status .txt files)
        └── Localization/
            └── English/
                └── English.loca.xml
```

### Common Attributes
- **PrimaryAbility Enum:**
  - 0 = None
  - 1 = Strength
  - 2 = Dexterity
  - 3 = Constitution
  - 4 = Intelligence
  - 5 = Wisdom
  - 6 = Charisma

- **ProgressionType Enum:**
  - 0 = Class progression
  - 1 = Subclass progression

---

## 🎓 Learning Resources

### Tutorials
- BG3 Wiki Tutorial List: https://bg3.wiki/wiki/Modding:Tutorials
- Community Library Examples: Use mod content as reference
- Best Practices Wiki: https://github.com/Baldurs-Gate-3-modders/Best-Practices-Wiki/wiki

### Video Resources
- Search "BG3 modding" on YouTube for video tutorials
- Nexus Mods BG3 section often has video guides linked

---

## 📝 Notes

### Patch 8 Compatibility
- All `.lsx` files must use version `4.8.0.10`
- LSLib v1.20.0+ required for Patch 8 support
- Older mods (Patch 7 and earlier) may not work correctly
- No structural changes to file formats, only version numbers

### Common Issues
- **Missing localization:** Check TranslatedString handles in .loca.xml
- **Mod not loading:** Verify version format matches current patch
- **Class not appearing:** Check Progressions.lsx SubClasses node
- **Equipment errors:** Verify Equipment.txt entries exist

---

**Maintained by:** GitHub Copilot  
**Project:** WoW Warrior Class Mod for BG3  
**Last Review:** October 16, 2025
