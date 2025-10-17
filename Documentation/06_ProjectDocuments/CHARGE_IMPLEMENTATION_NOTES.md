# Charge Ability - Implementation Notes

## Design Decision: Rush Attack Pattern (October 16, 2025)

### **Why Rush Attack Instead of Leap?**

**User Question**: "isnt there a ability in bg3 that is more of a charge than a leap"

**Research Finding**: BG3 has **Rush Attack** - a vanilla weapon action that perfectly matches Warrior Charge fantasy.

---

## **BG3 Rush Attack (Vanilla)**

**Source**: https://bg3.wiki/wiki/Rush_Attack

- **Description**: "Charge forward and attack the first enemy in your way"
- **Animation**: Ground-based forward charge (NOT aerial leap)
- **Range**: 9m / 30 ft
- **Damage**: 1d4 + STR/DEX modifier (Piercing)
- **Effect**: Possibly inflict **Off Balance** (STR save)
  - Disadvantage on STR/DEX checks
  - Attacks against target have Advantage
  - Removed by taking damage or Help action
- **Recharge**: Short rest
- **Special**: Does NOT provoke Opportunity Attacks
- **Found on**: Glaives, Halberds, Longswords, Pikes, Spears, Tridents (with proficiency)

---

## **Warrior Charge (Custom Implementation)**

### **Enhancements Over Vanilla Rush Attack**

| Feature | Vanilla Rush Attack | Warrior Charge |
|---------|---------------------|----------------|
| Range | 9m | **12m** (33% longer) |
| Damage | 1d4 + STR | 1d4 + STR (same) |
| Off Balance | Yes (STR save) | Yes (STR save) |
| No Opportunity Attacks | Yes | Yes |
| Rage Generation | None | **+10 Rage on hit** |
| Recharge | Short rest | Short rest |
| Animation | Ground charge | Ground charge |

### **Design Rationale**

1. **Fantasy Alignment**: Warriors charge into battle on the ground, not leap through air
2. **Player Familiarity**: Rush Attack is recognizable from longswords/spears
3. **Mechanical Synergy**: 
   - Off Balance grants Advantage → More hits → More Rage generation
   - No Opportunity Attacks → Safe engagement → Essential for gap closer
4. **WoW Charge Identity**: WoW Charge is a grounded rush movement, not aerial
5. **Balanced Enhancement**: 12m range (vs 9m) and Rage generation make it superior without being overpowered

---

## **Stats File Implementation**

### **Spell_Warrior.txt Entry**

```
new entry "WAR_Charge"
type "SpellData"
data "SpellType" "Target"
data "TargetRadius" "12"
data "AreaRadius" "0"
data "Level" "0"
data "SpellSchool" "Evocation"
data "SpellProperties" "ApplyStatus(OFF_BALANCE,100,1);IF(not HasStatus('SG_Incapacitated')):ApplyStatus(SELF,WAR_CHARGE_RAGE_GENERATION,100,0)"
data "TargetConditions" "Character() and not Dead()"
data "Icon" "Action_Charge"
data "DisplayName" "hc1a2b3c4-d5e6-f7a8-b9c0-d1e2f3a4b5c6;1" // "Charge"
data "Description" "hd2b3c4d5-e6f7-a8b9-c0d1-e2f3a4b5c6d7;1" // "Charge forward and attack the first enemy in your way, generating Rage. Doesn't provoke Opportunity Attacks."
data "TooltipStatusApply" "ApplyStatus(OFF_BALANCE,100,1)"
data "TooltipDamageList" "DealDamage(1d4, Piercing)"
data "TooltipAttackSave" "Strength"
data "PrepareEffect" "a8b9c0d1-e2f3-4a5b-6c7d-8e9f0a1b2c3d"
data "CastEffect" "b9c0d1e2-f3a4-5b6c-7d8e-9f0a1b2c3d4e"
data "TargetEffect" "c0d1e2f3-a4b5-6c7d-8e9f-0a1b2c3d4e5f"
data "UseCosts" "ActionPoint:1"
data "SpellAnimation" "dd86aa43-8189-4d9f-9a5c-454b5fe4a197,,,;::;4f5d822a-838b-4944-bb59-14e0e64d6779,,,;::;,,,"
data "VerbalIntent" "Damage"
data "SpellFlags" "HasVerbalComponent;IsAttack;IsMelee;RangeIgnoreVerticalThreshold;IgnoreSilence"
data "MemorizationCost" "1"
data "PrepareLoopSound" "Spell_Prepare_Weapon_Gen_L1toL3_Loop"
data "Cooldown" "OncePerShortRest"
data "MovementSpeedMultiplier" "2.5"
data "SpellSuccess" "DealDamage(1d4, Piercing);ExecuteWeaponFunctors(MainHand)"
data "SpellFail" "IF(not SavingThrow(Ability.Strength, SourceSpellDC())):ApplyStatus(OFF_BALANCE,100,2)"
data "IgnoreVisionBlock" "Yes"
data "HitAnimationType" "MeleeWeaponHit"
data "RechargeValues" "1"
```

### **Status_Warrior.txt Entry**

```
new entry "WAR_CHARGE_RAGE_GENERATION"
type "StatusData"
data "StatusType" "BOOST"
data "DisplayName" "h0a1b2c3-d4e5-f6a7-b8c9-d0e1f2a3b4c5;1" // "Rage Generation"
data "Description" "h1b2c3d4-e5f6-a7b8-c9d0-e1f2a3b4c5d6;1" // "Gained Rage from Charge"
data "Icon" "statIcons_Rage"
data "FormatColor" "Damage"
data "Boosts" "ActionResource(Rage,10,0)"
data "StatusPropertyFlags" "DisableOverhead;DisableCombatlog;DisablePortraitIndicator"
data "StackId" "WAR_CHARGE_RAGE"
data "RemoveEvents" "OnTurn"
data "RemoveConditions" "HasStatus('WAR_CHARGE_RAGE_GENERATION')"
```

---

## **Off Balance Condition**

**BG3 Vanilla Status** (already exists in game):
- **Effect**: 
  - Target has Disadvantage on Strength and Dexterity checks
  - Attacks against target have Advantage
- **Duration**: Until target takes damage or receives Help action
- **Save**: Strength saving throw to resist

**Warrior Charge Usage**: STR save on hit, if failed → Off Balance for 2 turns (removed by damage)

---

## **Progression Integration**

### **Level 1 AddSpells Selector**

```xml
<node id="Selectors">
    <children>
        <node id="AddSpells">
            <attribute id="Spells" type="LSString" value="WAR_Charge;WAR_HeroicStrike"/>
            <attribute id="UUID" type="guid" value="bc76bcd5-b481-4cc8-8c04-4de370e9e2cf"/>
        </node>
    </children>
</node>
```

---

## **Comparison to Other Gap Closers**

| Ability | Class | Range | Damage | Recharge | Special |
|---------|-------|-------|--------|----------|---------|
| **Rush Attack** | Weapon Action | 9m | 1d4+STR | Short Rest | Off Balance, No OA |
| **Warrior Charge** | Warrior L1 | **12m** | 1d4+STR | Short Rest | Off Balance, No OA, **+10 Rage** |
| Misty Step | Wizard/Sorcerer | 18m | None | Short Rest | Teleport, no attack |
| Step of the Wind (Dash) | Monk | Movement×2 | None | Ki point | Bonus action |
| Enraged Throw | Barbarian | 18m | Weapon dmg | Rage | Throw attack |

**Warrior Charge sits between weapon action and spell**, offering better range than Rush Attack but shorter than teleports, with unique Rage economy.

---

## **Animation & VFX Notes**

- **Animation**: Use Rush Attack animation base (ground charge, not leap)
- **Speed**: MovementSpeedMultiplier 2.5 (fast dash)
- **VFX**: Consider adding:
  - Rage-colored trail (red/orange particle effect)
  - Impact effect on hit
  - Dust/ground debris during charge
- **Sound**: Heavy footsteps, battle cry on activation

---

## **Balance Considerations**

### **Strengths**
- Excellent gap closer (12m, no OA)
- Rage economy (+10 on hit = 2 Heroic Strikes per 4 charges)
- Off Balance synergy (Advantage → more hits → more Rage)
- Short rest recharge (not per-encounter limited)

### **Limitations**
- Low damage (1d4+STR, not scaling)
- Must hit to generate Rage (miss = wasted charge)
- Single target only (not AoE)
- Requires clear path (hits first enemy in way)
- STR save can negate Off Balance

### **Multiclass Synergies**
- **Rogue**: Charge → Off Balance → Advantage for Sneak Attack
- **Barbarian**: Charge → Rage → Reckless Attack synergy
- **Fighter**: Action Surge → Double Charge for positioning
- **Paladin**: Charge → Off Balance → Advantage on Smite attack

---

## **Future Enhancement Ideas**

### **Talents/Feats That Could Modify Charge**
1. **Juggernaut** (WoW Protection talent): Charge causes Knockdown instead of Off Balance
2. **Double Time** (WoW talent): Charge gains 2 charges
3. **Warbringer** (WoW talent): Charge roots target for 1 turn
4. **Intervene** (Protection variant): Charge ally's attacker, grant ally protection
5. **Improved Charge**: Increase range to 15m, Rage generation to +15

---

## **Localization Handles**

### **Spell Name**
- Handle: `hc1a2b3c4-d5e6-f7a8-b9c0-d1e2f3a4b5c6`
- English: "Charge"

### **Spell Description**
- Handle: `hd2b3c4d5-e6f7-a8b9-c0d1-e2f3a4b5c6d7`
- English: "Charge forward and attack the first enemy in your way, generating <LSTag Tooltip=\"RageResource\">Rage</LSTag>. Possibly inflict <LSTag Tooltip=\"OffBalance\">Off Balance</LSTag>. Doesn't provoke <LSTag Tooltip=\"OpportunityAttack\">Opportunity Attacks</LSTag>."

### **Status Name**
- Handle: `h0a1b2c3-d4e5-f6a7-b8c9-d0e1f2a3b4c5`
- English: "Rage Generation"

### **Status Description**
- Handle: `h1b2c3d4-e5f6-a7b8-c9d0-e1f2a3b4c5d6`
- English: "Gained Rage from Charge."

---

## **Testing Checklist**

- [ ] Charge moves character 12m toward target
- [ ] Attack triggers on first enemy in path
- [ ] Damage calculation: 1d4 + STR modifier (Piercing)
- [ ] Rage generation: +10 on hit
- [ ] Off Balance applies on failed STR save
- [ ] Off Balance grants Advantage to attacks
- [ ] Doesn't provoke Opportunity Attacks during movement
- [ ] Short rest recharge works
- [ ] Animation plays correctly (ground charge, not leap)
- [ ] Works with two-handed weapons (Arms)
- [ ] Works with dual-wield (Fury)
- [ ] Works with shield (Protection)
- [ ] Multiclass interactions work correctly
- [ ] Tooltip displays all information
- [ ] Localization displays correctly

---

**Last Updated**: October 16, 2025  
**Status**: Ready for Stats file implementation  
**Next Steps**: Generate Progressions.lsx, then create Spell_Warrior.txt with Charge entry
