# WoWWarlock Complete Forensic Analysis Plan

## 🎯 Objective
Perform exhaustive autopsy of working WoWWarlock mod to discover EVERY implementation detail and apply learnings to our Warrior mod.

---

## 📋 Analysis Plan (20 Steps)

### Phase 1: Initial Discovery (Steps 1-4)
- [x] **Step 1:** List all files in WoWWarlock mod
- [ ] **Step 2:** Map file structure to website features
- [ ] **Step 3:** Extract all UUIDs and create cross-reference map
- [ ] **Step 4:** Document version numbers and dependencies

### Phase 2: Core Class Definition (Steps 5-7)
- [ ] **Step 5:** Analyze ClassDescriptions.lsx in extreme detail
  - **Document EVERY attribute with field analysis format**
  - Name, UUID, DisplayName, Description, BaseHp, HpPerLevel, etc.
  - What each field controls in character creation
  - How base class is defined
  - How subclasses link to base (via ParentGuid)
  - ProgressionTableUUID - what does it link to?
  - SpellCastingAbility - how does it work?
  - Compare field-by-field with our Warrior class

- [ ] **Step 6:** Analyze meta.lsx structure
  - Dependencies list
  - Module info attributes
  - Version handling
  - Compare with our meta.lsx

- [ ] **Step 7:** Analyze ActionResourceDefinitions.lsx
  - How Soul Shards are defined (all 10 resources)
  - **Document EVERY attribute:**
    - Name: Internal identifier
    - DisplayName: TranslatedString handle for UI
    - Description: TranslatedString handle for tooltip
    - UUID: Unique identifier for this resource
    - MaxValue: Maximum resource capacity
    - MaxLevel: Level scaling (0 = no scaling)
    - ReplenishType: When resource refills (Rest, ShortRest, Never, etc.)
    - ShowOnActionResourcePanel: Display in UI
    - Error: Error message handle (optional)
  - Compare field-by-field with our Rage definition
  - Identify any missing fields

### Phase 3: Progression System (Steps 8-10)
- [ ] **Step 8:** Analyze Progressions.lsx (50+ progressions)
  - **Document EVERY progression attribute:**
    - UUID: Unique identifier for this progression
    - Level: Character level (1-20)
    - Name: Internal name for progression
    - ProgressionType: Class, Subclass, etc.
    - TableUUID: Links to ClassDescription UUID
    - Boosts: LSString with boost syntax (ActionResource, Proficiency, etc.)
    - PassivesAdded: List of passive abilities granted
    - PassivesRemoved: List removed (subclass replacement)
    - Selectors: LSString with selector syntax (SelectSkills, SelectSpells, AddSpells)
    - AllowImprovement: Boolean for ASI/Feat choice
  - Level 1 base class progression - what's granted
  - How abilities are granted per level
  - **Selectors syntax breakdown:**
    - SelectSkills(UUID,count,type)
    - SelectSpells(UUID,count,type,restriction)
    - AddSpells(UUID,AlwaysPrepared/NotAlwaysPrepared,tag)
  - How subclass progressions differ
  - Boosts syntax examples and usage patterns

- [ ] **Step 9:** Analyze ProgressionDescriptions.lsx
  - If populated, what do descriptions do?
  - How they link to progressions

- [ ] **Step 10:** Analyze Lists folder (4 files)
  - **Document list file structure:**
    - UUID: Unique identifier (referenced by Selectors in Progressions)
    - Name: FixedString for internal identification
    - Content attribute (Spells/Passives/Skills/Abilities): LSString with items
  - SpellLists.lsx: All 53 spell lists
    - What spells in each list
    - How lists are grouped (by level? by feature?)
    - How Progressions reference these UUIDs
  - PassiveLists.lsx: All 52 passive lists
    - What passives in each list
    - Grouping logic
  - SkillLists.lsx: Skill selections
    - Available skills format
  - AbilityLists.lsx: Ability score distributions
    - What abilities can be chosen

### Phase 4: Ability Implementation (Steps 11-14)
- [ ] **Step 11:** Analyze Stats/Generated/Data folder
  - List all .txt files
  - Pick 3 sample abilities from website (e.g., Eldritch Blast, Hex, Soul Burn)
  - **Document COMPLETE implementation with field meanings:**
    - **Spell entry format:**
      - `new entry "EntryName"` - Entry declaration
      - `type "SpellData"` - Entry type
      - `data "key" "value"` - Attribute format
    - **Common spell attributes:**
      - SpellType: Target, Projectile, Zone, Shout, etc.
      - Level: Spell level (0 = cantrip)
      - SpellSchool: Evocation, Necromancy, etc.
      - AIFlags: AI behavior hints
      - TargetConditions: Who can be targeted (conditions syntax)
      - AreaRadius: AoE size
      - SpellRoll: Attack roll formula
      - SpellSuccess: What happens on hit (DealDamage, ApplyStatus)
      - SpellFail: What happens on miss
      - TargetRadius: Range
      - Icon: UI icon reference
      - DisplayName/Description: TranslatedString handles
      - UseCosts: ActionPoint:1;SoulShard:2 (cost syntax)
      - Cooldown: OncePerTurn, OncePerShortRest, etc.
    - Status effects used (ApplyStatus syntax)
    - Damage formulas (DealDamage syntax)
    - Targeting conditions (context.Target syntax)
    - Cost structure (Soul Shards, Action Points)

- [ ] **Step 12:** Map website abilities to stat files
  - Create complete ability inventory
  - Document which file each ability lives in
  - Note implementation patterns

- [ ] **Step 13:** Analyze Passive implementations
  - How passives are defined
  - How they interact with spells
  - Conditions and triggers

- [ ] **Step 14:** Analyze Status effects (Status_BOOST.txt)
  - How buffs/debuffs are defined
  - Duration handling
  - Stacking rules

### Phase 5: Localization & UI (Steps 15-16)
- [ ] **Step 15:** Analyze Localization files
  - Handle format and usage
  - How many localization entries total
  - Naming conventions

- [ ] **Step 16:** Analyze GUI/Assets if present
  - Custom icons
  - Resource bar visuals
  - Class portraits

### Phase 6: Advanced Features (Steps 17-18)
- [ ] **Step 17:** Analyze RootTemplates (if present)
  - Character templates
  - Equipment definitions

- [ ] **Step 18:** Analyze CharacterCreationPresets
  - Ability distribution presets
  - How many, what values
  - Default selections

### Phase 7: Cross-Reference & Comparison (Steps 19-20)
- [ ] **Step 19:** Create complete UUID cross-reference document
  - Every UUID in every file
  - Show how files reference each other
  - Validate all links are correct

- [ ] **Step 20:** Compare EVERYTHING with our Warrior mod
  - File-by-file comparison
  - Identify what we're missing
  - Identify what we have wrong
  - Create fix plan

---

## � Field Documentation Standards

For EVERY field/attribute encountered, I will document:

### Field Analysis Format:
```
Field Name: [Exact attribute name]
Type: [Data type - LSString, guid, uint32, bool, FixedString, TranslatedString]
Purpose: [What this field does in the game]
Format: [Expected format/syntax]
Example: [Real value from WoWWarlock]
Validation: [How to verify correctness]
Required: [Yes/No - is this mandatory?]
Related To: [Other files/fields that reference this]
Source: [Where I learned this - WoWWarlock file, web search, BG3 wiki, etc.]
```

**🌐 Research Protocol:**
- If field purpose is UNCLEAR → Search web for BG3 modding documentation
- If syntax is UNKNOWN → Search for examples in BG3 wiki/forums
- If behavior is UNCERTAIN → Document as "Unknown - needs testing" and search
- All web findings will be cited with URLs in the Source field

### Common Field Types Reference:

**UUID (Universally Unique Identifier)**
- Format: 8-4-4-4-12 hexadecimal (e.g., `6e3d9938-b2d5-4a8a-825c-cb91a0dd3dc4`)
- Purpose: Uniquely identifies game objects (classes, spells, items, progressions)
- Generation: BG3 Toolkit auto-generates valid UUIDs
- Validation: Must be unique across entire mod
- Links: Referenced by other files to create relationships

**TranslatedString**
- Format: `handle="hXXXXXXXX" version="N"`
- Purpose: References localization entries for multi-language support
- Example: `handle="he0affd88gc0f4g5b38gecbcg9d34954cda30" version="1"`
- Validation: Handle must exist in Localization XML files

**LSString**
- Format: Plain text string
- Purpose: Comma or semicolon-separated lists, values, selectors
- Example: `"Athletics,Acrobatics,Intimidation"`

**FixedString**
- Format: Plain text identifier
- Purpose: Internal game identifiers (ability names, class names)
- Example: `"SoulShard"`, `"Warlock"`

**guid**
- Format: UUID format
- Purpose: Same as UUID, type specification for XML
- Example: `value="6e3d9938-b2d5-4a8a-825c-cb91a0dd3dc4"`

**uint32/int32**
- Format: Unsigned/signed 32-bit integer
- Purpose: Numbers (damage, HP, costs, max values)
- Example: `value="100"` for max Rage

**bool**
- Format: true/false
- Purpose: Toggle features on/off
- Example: `value="true"` for ShowOnActionResourcePanel

---

## �📊 Deliverables

For each phase, I will create:

1. **Detailed markdown reports** with:
   - Full file contents (for small files)
   - Annotated excerpts (for large files)
   - **Purpose and function of EVERY field/attribute**
   - **Field type documentation** (as defined above)
   - Cross-references to other files
   - Comparison with our implementation

2. **Summary tables** showing:
   - File inventory
   - UUID mappings
   - Ability implementations
   - Attribute meanings

3. **Visual diagrams** (ASCII) showing:
   - File relationship chains
   - Progression flow
   - Resource usage

4. **Final action plan** with:
   - Exact changes needed for Warrior mod
   - Priority order
   - Risk assessment

---

## 📁 Report Structure

```
Reports/
├── 01_FILE_INVENTORY.md
├── 02_CLASS_DEFINITION_AUTOPSY.md
├── 03_PROGRESSION_SYSTEM_AUTOPSY.md
├── 04_ABILITY_IMPLEMENTATION_AUTOPSY.md
├── 05_LOCALIZATION_AUTOPSY.md
├── 06_UUID_CROSS_REFERENCE.md
├── 07_COMPARISON_WARRIOR_VS_WARLOCK.md
├── 08_FIX_ACTION_PLAN.md
└── 09_WEB_RESEARCH_FINDINGS.md  (URLs and sources consulted)
```

---

## ⏱️ Estimated Time per Phase

- Phase 1: ~15 minutes (file discovery)
- Phase 2: ~20 minutes (core definitions)
- Phase 3: ~30 minutes (progressions - this is complex)
- Phase 4: ~40 minutes (abilities - most detailed)
- Phase 5: ~15 minutes (localization)
- Phase 6: ~10 minutes (advanced features)
- Phase 7: ~30 minutes (comparison & action plan)

**Total: ~2.5 hours of detailed analysis**

---

## 🚀 Ready to Start?

I will work through each step methodically and give you a report after completing each phase.

**Current Status:** Ready to begin Step 1
**Next Action:** List all WoWWarlock files and create inventory

Shall I proceed?
