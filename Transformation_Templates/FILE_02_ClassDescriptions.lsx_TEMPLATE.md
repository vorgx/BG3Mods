# FILE 2: ClassDescriptions.lsx Transformation Template

## Purpose
Defines class characteristics: HP values, ability scores, equipment, progression tables, and subclass relationships.

## File Location
- **Warlock Template**: `Data/Public/Warlock_WoW_bdb3fa73-401b-4979-f02e-485422dd8d9c/ClassDescriptions/ClassDescriptions.lsx`
- **Warrior Target**: `Data/Public/Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7/ClassDescriptions/ClassDescriptions.lsx`

## Structure Overview

Warlock template has **4 ClassDescription nodes**:
1. Base Warlock class (L1-20)
2. Demonology subclass (L1-12 in Warlock's case)
3. Destruction subclass
4. Affliction subclass

Warrior implementation has **2 active nodes** (for initial release):
1. Base Warrior class (L1-20)
2. ArmsWarrior subclass (L1-12)
3. FuryWarrior subclass → COMMENTED OUT (future)
4. ProtectionWarrior subclass → COMMENTED OUT (future)

**Note**: Full implementation will have 10 nodes (1 base + 3 subclasses + 6 hero talents).

## Critical Discoveries

### SpellList UUID Mystery (RESOLVED)
**UUID**: `32879c22-4858-48ef-8f8d-22e6d395b396`

**Investigation findings**:
- Referenced in all ClassDescription nodes in Warlock
- NEVER defined in SpellLists.lsx
- NOT used in Progressions.lsx (different UUIDs there)
- Appears to be "dummy/ghost reference" ignored by BG3 engine

**Decision**: **KEEP this UUID unchanged** in all Warrior ClassDescription nodes
- Proven working pattern (13K+ downloads)
- Changing it may break unknown game systems
- Spells are granted via Progressions.lsx, not this SpellList reference

### Attribute Retention Strategy
**User requirements**:
- `CanLearnSpells`: Keep as `false` (Warrior doesn't learn spells like Wizard)
- `ClassHotbarColumns`, `CommonHotbarColumns`, `ItemsHotbarColumns`: Keep current values (5, 9, 2)
- `ShortName`: Keep template handle, will localize to "WAR" in FILE 15
- `HasGod`: Do NOT add (removed from final transformation)

## NODE 1: Base Warrior Class

### Transformation Mapping (11 attributes changed)

| Attribute | Warlock Value | Warrior Value | Rationale |
|-----------|---------------|---------------|-----------|
| **BaseHp** | `8` | `10` | Warrior d10 hit die (vs Warlock d8) |
| **ClassEquipment** | `EQP_CC_Warlock` | `EQP_CC_Barbarian` | Heavy armor starter gear |
| **Description** | `h45282db9...` | `hec9f49b2g20fbg427bgb437gfd4041ffd5ec` | Localization handle for Warrior description |
| **DisplayName** | `h95e35621...` | `h2192a15fgd3c6g47c8g8f2ag887078521591` | Localization handle for "Warrior" |
| **HpPerLevel** | `5` | `10` | Warrior gains 1d10 HP per level |
| **Name** | `WoWWarlock` | `WoWWarrior` | Internal class identifier |
| **PrimaryAbility** | `6` (Charisma) | `1` (Strength) | Warrior primary stat |
| **ProgressionTableUUID** | `95fff39d...` | `a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d` | Links to Warrior progression (FILE 3) |
| **SoundClassType** | `Warlock` | `Barbarian` | Grunt sounds fit Warrior better |
| **SpellCastingAbility** | `6` (Charisma) | `1` (Strength) | Warrior damage scales with Strength |
| **UUID** | `a417135a-918e-4acf-9ab9-e1e72ef50afb` | `78fe4967-4e62-5491-d981-dd781acca4d7` | Base Warrior class UUID |

### Attributes Kept Unchanged (10 attributes)

| Attribute | Value | Rationale |
|-----------|-------|-----------|
| **CanLearnSpells** | `false` | Warrior doesn't learn spells like Wizard |
| **CharacterCreationPose** | `0f07ec6e-4ef0-434e-9a51-1353260ccff8` | Generic class pose |
| **ClassHotbarColumns** | `5` | Works for Warrior action economy |
| **CommonHotbarColumns** | `9` | Standard hotbar layout |
| **ItemsHotbarColumns** | `2` | Standard item slots |
| **LearningStrategy** | `1` | Matches BG3 class system |
| **MustPrepareSpells** | `false` | Warrior abilities always available |
| **ShortName** | `h8a85b937...` | Will localize to "WAR" in FILE 15 |
| **SpellList** | `32879c22-4858-48ef-8f8d-22e6d395b396` | **CRITICAL**: Keep dummy UUID |
| **Tags** | `5804f55a-93f7-4281-9512-8d548a9e2a22` | CLASS tag (standard BG3 identifier) |

### Ability Score Values Reference

| Ability | Value | BG3 Constant |
|---------|-------|--------------|
| Strength | `1` | Primary for Warrior |
| Dexterity | `2` | - |
| Constitution | `3` | - |
| Intelligence | `4` | - |
| Wisdom | `5` | - |
| Charisma | `6` | Primary for Warlock |

### Final Target State (NODE 1)

```xml
<node id="ClassDescription">
    <attribute id="BaseHp" type="int32" value="10"/>
    <attribute id="CanLearnSpells" type="bool" value="false"/>
    <attribute id="CharacterCreationPose" type="guid" value="0f07ec6e-4ef0-434e-9a51-1353260ccff8"/>
    <attribute id="ClassEquipment" type="FixedString" value="EQP_CC_Barbarian"/>
    <attribute id="ClassHotbarColumns" type="int32" value="5"/>
    <attribute id="CommonHotbarColumns" type="int32" value="9"/>
    <attribute id="Description" type="TranslatedString" handle="hec9f49b2g20fbg427bgb437gfd4041ffd5ec" version="2"/>
    <attribute id="DisplayName" type="TranslatedString" handle="h2192a15fgd3c6g47c8g8f2ag887078521591" version="1"/>
    <attribute id="HpPerLevel" type="int32" value="10"/>
    <attribute id="ItemsHotbarColumns" type="int32" value="2"/>
    <attribute id="LearningStrategy" type="uint8" value="1"/>
    <attribute id="MustPrepareSpells" type="bool" value="false"/>
    <attribute id="Name" type="FixedString" value="WoWWarrior"/>
    <attribute id="PrimaryAbility" type="uint8" value="1"/>
    <attribute id="ProgressionTableUUID" type="guid" value="a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d"/>
    <attribute id="ShortName" type="TranslatedString" handle="h8a85b937g0dd5g280bge335gb8acaf364077" version="1"/>
    <attribute id="SoundClassType" type="FixedString" value="Barbarian"/>
    <attribute id="SpellCastingAbility" type="uint8" value="1"/>
    <attribute id="SpellList" type="guid" value="32879c22-4858-48ef-8f8d-22e6d395b396"/>
    <attribute id="UUID" type="guid" value="78fe4967-4e62-5491-d981-dd781acca4d7"/>
    <children>
        <node id="Tags">
            <attribute id="Object" type="guid" value="5804f55a-93f7-4281-9512-8d548a9e2a22"/>
        </node>
    </children>
</node>
```

## NODE 2: ArmsWarrior Subclass

### Transformation Mapping (13 attributes changed)

| Attribute | Warlock Value | Warrior Value | Rationale |
|-----------|---------------|---------------|-----------|
| **BaseHp** | `8` | `10` | Inherits Warrior d10 hit die |
| **ClassEquipment** | `EQP_CC_Warlock` | `EQP_CC_Barbarian` | Heavy armor |
| **Description** | `h77582df7...` | `h5300bf31g2077g4482g80dfg06112305b4d5` | Arms Warrior description |
| **DisplayName** | `h53cb997e...` | `h0ae71f9cgcb9ag4eb9g8bedgdc08c872bccc` | "Arms Warrior" display name |
| **HpPerLevel** | `5` | `10` | d10 per level |
| **Name** | `Demonology` | `ArmsWarrior` | Internal subclass identifier |
| **ParentGuid** | `a417135a...` | `78fe4967-4e62-5491-d981-dd781acca4d7` | Links to base Warrior UUID |
| **PrimaryAbility** | `6` | `1` | Strength primary |
| **ProgressionTableUUID** | `6e4f6936...` | `2b3c4d5e-6f7a-8b9c-0d1e-2f3a4b5c6d7e` | Arms progression table |
| **ShortName** | `hf6f3fed0...` | `hf6f3fed0gad58ge625g3527g4af0b4a2e14f` | Keep template (localize later) |
| **SoundClassType** | `Warlock` | `Barbarian` | Barbarian sounds |
| **SpellCastingAbility** | `6` | `1` | Strength scaling |
| **UUID** | `8e387e2d...` | `1a2b3c4d-5e6f-7a8b-9c0d-1e2f3a4b5c6d` | Arms Warrior UUID |

### Attributes Kept Unchanged (7 attributes)

| Attribute | Value | Rationale |
|-----------|-------|-----------|
| **CanLearnSpells** | `false` | Subclass doesn't learn spells |
| **CharacterCreationPose** | `0f07ec6e...` | Generic pose |
| **ClassHotbarColumns** | `5` | Standard layout |
| **CommonHotbarColumns** | `9` | Standard layout |
| **ItemsHotbarColumns** | `2` | Standard layout |
| **LearningStrategy** | `1` | BG3 system |
| **SpellList** | `32879c22-4858-48ef-8f8d-22e6d395b396` | **CRITICAL**: Keep dummy UUID |
| **Tags** | `5804f55a...` | CLASS tag |

### Final Target State (NODE 2)

```xml
<node id="ClassDescription">
    <attribute id="BaseHp" type="int32" value="10"/>
    <attribute id="CanLearnSpells" type="bool" value="false"/>
    <attribute id="CharacterCreationPose" type="guid" value="0f07ec6e-4ef0-434e-9a51-1353260ccff8"/>
    <attribute id="ClassEquipment" type="FixedString" value="EQP_CC_Barbarian"/>
    <attribute id="ClassHotbarColumns" type="int32" value="5"/>
    <attribute id="CommonHotbarColumns" type="int32" value="9"/>
    <attribute id="Description" type="TranslatedString" handle="h5300bf31g2077g4482g80dfg06112305b4d5" version="2"/>
    <attribute id="DisplayName" type="TranslatedString" handle="h0ae71f9cgcb9ag4eb9g8bedgdc08c872bccc" version="1"/>
    <attribute id="HpPerLevel" type="int32" value="10"/>
    <attribute id="ItemsHotbarColumns" type="int32" value="2"/>
    <attribute id="LearningStrategy" type="uint8" value="1"/>
    <attribute id="MustPrepareSpells" type="bool" value="false"/>
    <attribute id="Name" type="FixedString" value="ArmsWarrior"/>
    <attribute id="ParentGuid" type="guid" value="78fe4967-4e62-5491-d981-dd781acca4d7"/>
    <attribute id="PrimaryAbility" type="uint8" value="1"/>
    <attribute id="ProgressionTableUUID" type="guid" value="2b3c4d5e-6f7a-8b9c-0d1e-2f3a4b5c6d7e"/>
    <attribute id="ShortName" type="TranslatedString" handle="hf6f3fed0gad58ge625g3527g4af0b4a2e14f" version="1"/>
    <attribute id="SoundClassType" type="FixedString" value="Barbarian"/>
    <attribute id="SpellCastingAbility" type="uint8" value="1"/>
    <attribute id="SpellList" type="guid" value="32879c22-4858-48ef-8f8d-22e6d395b396"/>
    <attribute id="UUID" type="guid" value="1a2b3c4d-5e6f-7a8b-9c0d-1e2f3a4b5c6d"/>
    <children>
        <node id="Tags">
            <attribute id="Object" type="guid" value="5804f55a-93f7-4281-9512-8d548a9e2a22"/>
        </node>
    </children>
</node>
```

## NODES 3 & 4: Future Subclasses (Commented Out)

### Strategy
Transform nodes to Warrior format, then wrap in XML comments for future activation.

**Rationale**:
- Prevents game from loading incomplete subclasses
- Nodes are **fully transformed** to Warrior values (ready to uncomment)
- Avoids XML errors from empty/invalid nodes
- Zero transformation work needed when activating - just uncomment!

### NODE 3: FuryWarrior (READY TO ACTIVATE)

**Transformation Summary** (13 attributes changed, same as ArmsWarrior):
- `BaseHp`: 8 → 10
- `HpPerLevel`: 5 → 10
- `ClassEquipment`: EQP_CC_Warlock → EQP_CC_Barbarian
- `Name`: Destruction → FuryWarrior
- `ParentGuid`: a417135a... → 78fe4967-4e62-5491-d981-dd781acca4d7
- `PrimaryAbility`: 6 → 1
- `ProgressionTableUUID`: c0a214a0... → 3c4d5e6f-7a8b-9c0d-1e2f-3a4b5c6d7e8f
- `SoundClassType`: Warlock → Barbarian
- `SpellCastingAbility`: 6 → 1
- `UUID`: 54ad57a9... → 2b3c4d5e-6f7a-8b9c-0d1e-2f3a4b5c6d7e
- `Description`: Updated to Fury Warrior handle (h7a91c4e3...)
- `DisplayName`: Updated to Fury Warrior handle (hb2e8f506...)
- `ShortName`: Kept template handle

**Current State**:
```xml
<!-- PLACEHOLDER: FuryWarrior subclass - To be implemented in future update
<node id="ClassDescription">
    <attribute id="BaseHp" type="int32" value="10"/>
    <attribute id="CanLearnSpells" type="bool" value="false"/>
    <attribute id="CharacterCreationPose" type="guid" value="0f07ec6e-4ef0-434e-9a51-1353260ccff8"/>
    <attribute id="ClassEquipment" type="FixedString" value="EQP_CC_Barbarian"/>
    <attribute id="ClassHotbarColumns" type="int32" value="5"/>
    <attribute id="CommonHotbarColumns" type="int32" value="9"/>
    <attribute id="Description" type="TranslatedString" handle="h7a91c4e3gf832g4d29g9e17g2f04b6e8a793" version="2"/>
    <attribute id="DisplayName" type="TranslatedString" handle="hb2e8f506g9d73g4ac8gb024g5c19d3f7e6a2" version="1"/>
    <attribute id="HpPerLevel" type="int32" value="10"/>
    <attribute id="ItemsHotbarColumns" type="int32" value="2"/>
    <attribute id="LearningStrategy" type="uint8" value="1"/>
    <attribute id="MustPrepareSpells" type="bool" value="false"/>
    <attribute id="Name" type="FixedString" value="FuryWarrior"/>
    <attribute id="ParentGuid" type="guid" value="78fe4967-4e62-5491-d981-dd781acca4d7"/>
    <attribute id="PrimaryAbility" type="uint8" value="1"/>
    <attribute id="ProgressionTableUUID" type="guid" value="3c4d5e6f-7a8b-9c0d-1e2f-3a4b5c6d7e8f"/>
    <attribute id="ShortName" type="TranslatedString" handle="hf6f3fed0gad58ge625g3527g4af0b4a2e14f" version="1"/>
    <attribute id="SoundClassType" type="FixedString" value="Barbarian"/>
    <attribute id="SpellCastingAbility" type="uint8" value="1"/>
    <attribute id="SpellList" type="guid" value="32879c22-4858-48ef-8f8d-22e6d395b396"/>
    <attribute id="UUID" type="guid" value="2b3c4d5e-6f7a-8b9c-0d1e-2f3a4b5c6d7e"/>
    <children>
        <node id="Tags">
            <attribute id="Object" type="guid" value="5804f55a-93f7-4281-9512-8d548a9e2a22"/>
        </node>
    </children>
</node>
-->
```

### NODE 4: ProtectionWarrior (READY TO ACTIVATE)

**Transformation Summary** (13 attributes changed, same as ArmsWarrior):
- `BaseHp`: 8 → 10
- `HpPerLevel`: 5 → 10
- `ClassEquipment`: EQP_CC_Warlock → EQP_CC_Barbarian
- `Name`: Affliction → ProtectionWarrior
- `ParentGuid`: a417135a... → 78fe4967-4e62-5491-d981-dd781acca4d7
- `PrimaryAbility`: 6 → 1
- `ProgressionTableUUID`: 13638a8a... → 4d5e6f7a-8b9c-0d1e-2f3a-4b5c6d7e8f9a
- `SoundClassType`: Warlock → Barbarian
- `SpellCastingAbility`: 6 → 1
- `UUID`: e9aaae5b... → 3c4d5e6f-7a8b-9c0d-1e2f-3a4b5c6d7e8f
- `Description`: Updated to Protection Warrior handle (h6c82d5f4...)
- `DisplayName`: Updated to Protection Warrior handle (ha3f7e617...)
- `ShortName`: Kept template handle

**Current State**:
```xml
<!-- PLACEHOLDER: ProtectionWarrior subclass - To be implemented in future update
<node id="ClassDescription">
    <attribute id="BaseHp" type="int32" value="10"/>
    <attribute id="CanLearnSpells" type="bool" value="false"/>
    <attribute id="CharacterCreationPose" type="guid" value="0f07ec6e-4ef0-434e-9a51-1353260ccff8"/>
    <attribute id="ClassEquipment" type="FixedString" value="EQP_CC_Barbarian"/>
    <attribute id="ClassHotbarColumns" type="int32" value="5"/>
    <attribute id="CommonHotbarColumns" type="int32" value="9"/>
    <attribute id="Description" type="TranslatedString" handle="h6c82d5f4ge921g4b38g8d26g1e03a5d9c8b4" version="2"/>
    <attribute id="DisplayName" type="TranslatedString" handle="ha3f7e617g8e64g4ba9ga135g4d28c6e8f7b3" version="1"/>
    <attribute id="HpPerLevel" type="int32" value="10"/>
    <attribute id="ItemsHotbarColumns" type="int32" value="2"/>
    <attribute id="LearningStrategy" type="uint8" value="1"/>
    <attribute id="MustPrepareSpells" type="bool" value="false"/>
    <attribute id="Name" type="FixedString" value="ProtectionWarrior"/>
    <attribute id="ParentGuid" type="guid" value="78fe4967-4e62-5491-d981-dd781acca4d7"/>
    <attribute id="PrimaryAbility" type="uint8" value="1"/>
    <attribute id="ProgressionTableUUID" type="guid" value="4d5e6f7a-8b9c-0d1e-2f3a-4b5c6d7e8f9a"/>
    <attribute id="ShortName" type="TranslatedString" handle="hf6f3fed0gad58ge625g3527g4af0b4a2e14f" version="1"/>
    <attribute id="SoundClassType" type="FixedString" value="Barbarian"/>
    <attribute id="SpellCastingAbility" type="uint8" value="1"/>
    <attribute id="SpellList" type="guid" value="32879c22-4858-48ef-8f8d-22e6d395b396"/>
    <attribute id="UUID" type="guid" value="3c4d5e6f-7a8b-9c0d-1e2f-3a4b5c6d7e8f"/>
    <children>
        <node id="Tags">
            <attribute id="Object" type="guid" value="5804f55a-93f7-4281-9512-8d548a9e2a22"/>
        </node>
    </children>
</node>
-->
```

### Activation Instructions

When ready to implement Fury or Protection:
1. **Remove comment markers** (`<!-- PLACEHOLDER...` and `-->`)
2. **Create Progressions.lsx entries** for the ProgressionTableUUIDs
3. **Update Localization** for Description/DisplayName handles
4. **Test in character creation** - subclass should appear at L3
5. **No other changes needed** - nodes are fully transformed!

## Hero Talent System Architecture (Future Implementation)

Current transformation: **2 nodes** (Base + Arms)  
Full implementation: **10 nodes** total

### Structure Breakdown:
1. Base Warrior (L1-20)
2. ArmsWarrior subclass (L1-12)
3. FuryWarrior subclass (L1-12) → Currently commented
4. ProtectionWarrior subclass (L1-12) → Currently commented
5. Colossus hero talent (L13-20, Arms path)
6. Slayer hero talent (L13-20, Arms path)
7. MountainThane hero talent (L13-20, Fury path)
8. Slayer hero talent (L13-20, Fury path) ← Shared with Arms
9. MountainThane hero talent (L13-20, Protection path) ← Shared with Fury
10. Colossus hero talent (L13-20, Protection path) ← Shared with Arms

### Hero Talent Specialization Matrix:
| Subclass | Hero Talent Path 1 | Hero Talent Path 2 |
|----------|-------------------|-------------------|
| Arms | Colossus (3-tier) | Slayer (3-tier) |
| Fury | Mountain Thane (4-tier) | Slayer (3-tier) |
| Protection | Mountain Thane (4-tier) | Colossus (3-tier) |

**Note**: All hero talent ClassDescription nodes will use same dummy SpellList UUID (`32879c22...`).

## ClassEquipment Reference

### Available Equipment Templates
| Value | Description | Armor Type | Suitable For |
|-------|-------------|------------|--------------|
| `EQP_CC_Barbarian` | Heavy armor, two-handed weapon | Heavy | Warrior (chosen) |
| `EQP_CC_Fighter` | Plate armor, sword & shield | Heavy | Alternative |
| `EQP_CC_Paladin` | Plate armor, longsword | Heavy | Alternative |
| `EQP_CC_Warlock` | Cloth robes, staff | Light | Caster classes |
| `EQP_CC_Wizard` | Cloth robes, dagger | Light | Caster classes |
| `EQP_CC_Rogue` | Leather, daggers | Light | DEX classes |

**Decision**: `EQP_CC_Barbarian` chosen for Warrior because:
- Heavy armor proficiency matches design
- Two-handed weapon aesthetic fits
- Similar combat role (melee frontline)

## SoundClassType Reference

### Available Sound Types
| Value | Description | Suitable For |
|-------|-------------|--------------|
| `Barbarian` | Grunts, battle cries, aggressive | Warrior (chosen) |
| `Fighter` | Disciplined combat shouts | Alternative |
| `Paladin` | Righteous, heroic tone | Divine classes |
| `Warlock` | Dark, eldritch whispers | Caster classes |
| `Wizard` | Scholarly, arcane incantations | Caster classes |

**Decision**: `Barbarian` chosen for Warrior because:
- Matches aggressive combat style
- Rage mechanics thematically similar
- Fighter sounds too generic

## Validation Checklist

After transformation, verify:

### Node Structure
- [ ] Base class node fully transformed (11 attributes changed)
- [ ] Arms subclass node fully transformed (13 attributes changed)
- [ ] Future subclass nodes commented out (NODEs 3&4)
- [ ] All `<children>` and `</children>` tags properly nested
- [ ] All nodes end with `</node>` closing tag

### UUID Consistency
- [ ] Base class UUID: `78fe4967-4e62-5491-d981-dd781acca4d7`
- [ ] Arms UUID: `1a2b3c4d-5e6f-7a8b-9c0d-1e2f3a4b5c6d`
- [ ] Arms ParentGuid: `78fe4967...` (matches base)
- [ ] SpellList UUID: `32879c22...` (same in all nodes)

### Ability Values
- [ ] PrimaryAbility: `1` (Strength) in all active nodes
- [ ] SpellCastingAbility: `1` (Strength) in all active nodes
- [ ] BaseHp: `10` in all active nodes
- [ ] HpPerLevel: `10` in all active nodes

### Equipment & Sounds
- [ ] ClassEquipment: `EQP_CC_Barbarian` in all active nodes
- [ ] SoundClassType: `Barbarian` in all active nodes

### Preserved Attributes
- [ ] CanLearnSpells: `false` in all active nodes
- [ ] Hotbar columns unchanged (5, 9, 2)
- [ ] Tags: `5804f55a-93f7-4281-9512-8d548a9e2a22` in all active nodes
- [ ] SpellList: `32879c22...` in all active nodes (unchanged from template)

### XML Validation
- [ ] File opens without errors in VS Code
- [ ] get_errors tool returns no errors
- [ ] XML structure well-formed (balanced tags)

## Troubleshooting

### Issue: Class doesn't appear in character creation
**Cause**: Invalid UUID or ProgressionTableUUID  
**Fix**: Verify UUIDs exist in corresponding Progressions.lsx (FILE 3)

### Issue: Subclass not selectable at L3
**Cause**: ParentGuid doesn't match base class UUID  
**Fix**: Ensure Arms ParentGuid = `78fe4967-4e62-5491-d981-dd781acca4d7`

### Issue: Wrong HP values in-game
**Cause**: BaseHp or HpPerLevel incorrect  
**Fix**: Warrior should be 10/10 (d10 hit die)

### Issue: Class uses wrong sounds
**Cause**: SoundClassType incorrect  
**Fix**: Use `Barbarian` for aggressive Warrior sounds

### Issue: Equipment doesn't match class fantasy
**Cause**: Wrong ClassEquipment reference  
**Fix**: Use `EQP_CC_Barbarian` for heavy armor starter

## Notes for Future Classes

### Subclass Implementation Pattern
When adding FuryWarrior or ProtectionWarrior:
1. Uncomment relevant node from commented section
2. Transform Name, UUID, ProgressionTableUUID
3. Transform Description/DisplayName handles
4. Keep all other attributes (HP, abilities, equipment)
5. Ensure ParentGuid = base class UUID

### Hero Talent Implementation Pattern
For hero talents (L13-20 specializations):
1. Create NEW ClassDescription node (don't transform existing)
2. Set ParentGuid = subclass UUID (not base class)
3. Use same SpellList dummy UUID (`32879c22...`)
4. ProgressionTableUUID links to hero talent progression
5. Keep HP values (inherited from parent)

### Critical UUID Relationships
```
Base Warrior (78fe4967...)
├── Arms Subclass (1a2b3c4d..., ParentGuid=78fe4967...)
│   ├── Colossus Hero (new UUID, ParentGuid=1a2b3c4d...)
│   └── Slayer Hero (new UUID, ParentGuid=1a2b3c4d...)
├── Fury Subclass (new UUID, ParentGuid=78fe4967...)
│   ├── MountainThane Hero (new UUID, ParentGuid=Fury UUID)
│   └── Slayer Hero (reused UUID, ParentGuid=Fury UUID)
└── Protection Subclass (new UUID, ParentGuid=78fe4967...)
    ├── MountainThane Hero (reused UUID, ParentGuid=Protection UUID)
    └── Colossus Hero (reused UUID, ParentGuid=Protection UUID)
```

### Progression Table UUID Mapping
Each ClassDescription needs unique ProgressionTableUUID:
- Base Warrior: `a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d`
- Arms: `2b3c4d5e-6f7a-8b9c-0d1e-2f3a4b5c6d7e`
- Fury: `3c4d5e6f-7a8b-9c0d-1e2f-3a4b5c6d7e8f` (future)
- Protection: `4d5e6f7a-8b9c-0d1e-2f3a-4b5c6d7e8f9a` (future)
- Hero talents: Generate new UUIDs for each

---

**Transformation Date**: January 2025  
**Template Version**: 1.0  
**Source Mod**: WoWWarlock (bdb3fa73-401b-4979-f02e-485422dd8d9c)  
**Proven Working**: Yes (13K+ downloads)  
**SpellList UUID Mystery**: Resolved (keep dummy UUID pattern)
