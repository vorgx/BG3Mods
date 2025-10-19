# Arms Warrior - Complete Implementation Roadmap

**Date:** October 17, 2025  
**Purpose:** Detailed implementation plan for Arms Warrior as prototype for 5-pool talent system  
**Strategy:** Complete Arms first, validate system, then expand to Fury/Protection  
**Estimated Total Time:** 85-120 hours

---

## Executive Summary

**Why Arms First?**
- ✅ Arms is the most "traditional" spec (two-handed weapons, big hits)
- ✅ Validates all 5 pools (Class, SubclassSpec, SubclassBase, Specialization, Feats)
- ✅ Tests complex mechanics (Mortal Wounds, Execute thresholds, talent synergies)
- ✅ Provides foundation for Fury/Protection (many shared Class talents)

**Current Status:**
- **Pool 3 (SubclassBase):** 100% complete ✅ (12 abilities exist)
- **Pool 1 (Class Talents):** ~27% complete (8 of 30 exist)
- **Pool 2 (Arms Spec):** ~9% complete (2-3 of 24-30 exist)
- **Pool 4/5 (Specializations):** ~5% complete (1-2 of 14 Colossus abilities exist)

**NEW Abilities Needed for Arms:** ~47-53 abilities

---

## Phase Breakdown

### Phase 1: Core Arms Rotation (20-25 hours)

**Goal:** Make Arms playable with basic rotation by Level 10

**Priority Abilities (12-15 total):**

#### Pool 2 - Arms Spec Essentials
1. **Mortal Strike** (Spell_Target.txt) - 30min
   - Main spender, applies Mortal Wounds
   - `UseCosts: ActionPoint:1;Rage:30`
   - `SpellSuccess: DealDamage(2d12+StrengthModifier,MainMeleeWeaponDamageType,Magical);ApplyStatus(SELF,WAR_MORTAL_WOUNDS,100,6)`

2. **Overpower** (Spell_Target.txt) - 45min
   - Proc-based ability (triggers after dodged attacks)
   - `UseCosts: ActionPoint:1;Rage:10`
   - Requires passive: WAR_ARMS_OVERPOWER_PROC

3. **Rend** (Spell_Target.txt) - 30min
   - DoT bleed effect
   - `UseCosts: ActionPoint:1;Rage:20`
   - `SpellSuccess: ApplyStatus(TARGET,WAR_REND_BLEED,100,8)`

4. **Colossus Smash** (Spell_Target.txt) - 30min
   - Armor reduction debuff
   - `UseCosts: ActionPoint:1;Rage:20`
   - `SpellSuccess: DealDamage(2d8+StrengthModifier,MainMeleeWeaponDamageType,Magical);ApplyStatus(TARGET,WAR_COLOSSUS_SMASH_DEBUFF,100,6)`

5. **Cleave** (Spell_Zone.txt) - 30min
   - Cone AoE attack
   - `UseCosts: ActionPoint:1;Rage:15`
   - `AreaRadius: 3m`

6. **Sweeping Strikes** (Spell_Shout.txt) - 30min
   - Self-buff that hits additional targets
   - `UseCosts: ActionPoint:1;Rage:25`
   - `SpellSuccess: ApplyStatus(SELF,WAR_SWEEPING_STRIKES,100,3)`

7. **Execute Enhancement** (Passive.txt) - 20min
   - Passive that modifies existing Execute ability
   - `Boosts: IF(HasPassive('WAR_ARMS_EXECUTIONER')):Damage(Increase,1d12,Execute)`

8. **Deep Wounds** (Passive.txt) - 20min
   - Passive bleed effect on crits
   - `StatsFunctorContext: OnAttack`
   - `Conditions: IsCriticalHit()`
   - `StatsFunctors: ApplyStatus(TARGET,WAR_DEEP_WOUNDS,100,6)`

#### Status Effects Required
9. **WAR_MORTAL_WOUNDS** (Status_BOOST.txt) - 20min
   - Healing reduction debuff (-50% healing)
   - `StatusType: MORTAL_WOUNDS`
   - `TickType: StartTurn`

10. **WAR_REND_BLEED** (Status_BOOST.txt) - 20min
    - DoT bleed (1d6 per turn, 8 turns)
    - `StatusType: BLEEDING`

11. **WAR_COLOSSUS_SMASH_DEBUFF** (Status_BOOST.txt) - 20min
    - Armor reduction (-2 AC, 6 turns)
    - `Boosts: AC(-2)`

12. **WAR_SWEEPING_STRIKES** (Status_BOOST.txt) - 20min
    - Buff that triggers extra attacks
    - `Boosts: ExtraAttackOnSameTurn()`

13. **WAR_DEEP_WOUNDS** (Status_BOOST.txt) - 15min
    - DoT bleed from crits
    - `TickType: StartTurn`
    - `TickFunctors: DealDamage(1d4,Slashing)`

#### Passive Wrappers
14. **WAR_ARMS_ROW1_MORTAL_STRIKE** (Passive.txt) - 10min
    - Talent wrapper
    - `Boosts: UnlockSpell(Target_WAR_MortalStrike)`

15. **WAR_ARMS_ROW1_OVERPOWER** (Passive.txt) - 10min
    - Talent wrapper + proc mechanic
    - `Boosts: UnlockSpell(Target_WAR_Overpower);UnlockPassive(WAR_ARMS_OVERPOWER_PROC)`

**Phase 1 Deliverables:**
- ✅ Spell_Target.txt: +5 entries (Mortal Strike, Overpower, Rend, Colossus Smash, Execute modifications)
- ✅ Spell_Zone.txt: +1 entry (Cleave)
- ✅ Spell_Shout.txt: +1 entry (Sweeping Strikes)
- ✅ Status_BOOST.txt: +5 entries (Mortal Wounds, Rend, Colossus Smash, Sweeping Strikes, Deep Wounds)
- ✅ Passive.txt: +5 entries (3 wrappers, 2 mechanics)
- ✅ Progressions.lsx: ~100 lines (L1-L10 Arms progression)
- ✅ English.loca.xml: ~30 handles

**Phase 1 Time Estimate:** 20-25 hours

---

### Phase 2: Class Talents Pool 1 (15-20 hours)

**Goal:** Implement shared Class Talents that Arms uses

**Abilities Needed (15-18 total):**

#### Row 1 - Mobility (2 NEW, 1 exists)
1. ✅ **Charge** - EXISTS (need to verify)
2. **Heroic Leap** (Spell_Jump.txt) - 30min
   - Gap closer with AoE landing damage
   - `UseCosts: ActionPoint:1;Rage:10`
   - `TeleportSelf()`
   - `SpellSuccess: DealDamage(1d8,Force,Magical)` (at landing)

3. **Intervene** (Spell_Target.txt) - 30min
   - Leap to ally, grant shield
   - `UseCosts: ActionPoint:1;Rage:15`
   - `TeleportSource()`
   - `SpellSuccess: ApplyStatus(TARGET,WAR_INTERVENE_SHIELD,100,3)`

#### Row 2 - Shouts (2 NEW, 1 exists)
4. ✅ **Battle Shout** - EXISTS
5. **Commanding Shout** (Spell_Shout.txt) - 30min
   - Party-wide HP buff
   - `UseCosts: ActionPoint:1;Rage:20`
   - `SpellSuccess: ApplyStatus(ALLIES,WAR_COMMANDING_SHOUT,100,10)`

6. **Rallying Cry** (Spell_Shout.txt) - 30min
   - Instant party heal
   - `UseCosts: ActionPoint:1;Rage:30`
   - `SpellSuccess: RestoreResource(ALLIES,Health,4d6,0)`

#### Row 3 - Defensive (3 NEW)
7. **Berserker Rage** (Spell_Shout.txt) - 30min (VERIFY - may exist)
   - Fear/CC immunity
   - `UseCosts: ActionPoint:1;Rage:0`
   - `SpellSuccess: ApplyStatus(SELF,WAR_BERSERKER_RAGE,100,6);RemoveStatus(SELF,FRIGHTENED);RemoveStatus(SELF,CHARMED)`

8. **Die by the Sword** (Spell_Shout.txt) - 30min
   - Parry buff (dodge next attack)
   - `UseCosts: ActionPoint:1;Rage:25`
   - `SpellSuccess: ApplyStatus(SELF,WAR_DIE_BY_THE_SWORD,100,2)`

9. **Defensive Stance** (Spell_Shout.txt) - 30min
   - Toggle stance (damage reduction)
   - `UseCosts: ActionPoint:1;Rage:0`
   - `SpellSuccess: ApplyStatus(SELF,WAR_DEFENSIVE_STANCE,100,-1)` (-1 = permanent until toggled)

#### Row 4 - Rage Management (3 NEW)
10. **Enrage** (Spell_Shout.txt) - 30min
    - Instant Rage generation
    - `UseCosts: ActionPoint:1;Rage:0`
    - `SpellSuccess: RestoreResource(SELF,Rage,30,0)`

11. **Unbridled Fury** (Passive.txt) - 20min
    - Passive Rage generation on crit
    - `StatsFunctorContext: OnAttack`
    - `Conditions: IsCriticalHit()`
    - `StatsFunctors: RestoreResource(SELF,Rage,10,0)`

12. **Focused Rage** (Passive.txt) - 20min
    - Reduces Rage costs by 10%
    - `Boosts: RageCostReduction(0.1)` (if BG3 supports) OR modify all abilities manually

#### Row 5 - Sustain (3 NEW)
13. **Victory Rush** (Spell_Target.txt) - 30min (VERIFY - may exist in SubclassBase)
    - Free after killing blow, heals
    - `UseCosts: ActionPoint:1;Rage:0`
    - `TargetConditions: HasStatus('WAR_VICTORIOUS')`
    - `SpellSuccess: RestoreResource(SELF,Health,2d8+StrengthModifier,0)`

14. **Impending Victory** (Spell_Target.txt) - 30min
    - Enhanced Victory Rush (more healing)
    - Replaces Victory Rush passive

15. **Second Wind** (Spell_Shout.txt) - 30min
    - Self-heal on cooldown
    - `UseCosts: ActionPoint:1;Rage:15`
    - `Cooldown: OncePerShortRest`
    - `SpellSuccess: RestoreResource(SELF,Health,3d10+Level,0)`

#### Row 6 - Utility (3 NEW)
16. **Pummel** (Spell_Target.txt) - 30min (VERIFY - may exist in SubclassBase)
    - Interrupt spell
    - `UseCosts: ActionPoint:1;Rage:10`
    - `SpellSuccess: Interrupt();ApplyStatus(TARGET,WAR_SPELL_LOCK,100,2)` (silence)

17. **Spell Reflection** (Spell_Shout.txt) - 45min
    - Reflect next spell
    - `UseCosts: ActionPoint:1;Rage:25`
    - `SpellSuccess: ApplyStatus(SELF,WAR_SPELL_REFLECTION,100,2)`
    - **Complex:** Requires reflection mechanic

18. **Intimidating Shout** (Spell_Zone.txt) - 30min
    - AoE fear
    - `UseCosts: ActionPoint:1;Rage:20`
    - `Cooldown: OncePerTurn`
    - `SpellSuccess: ApplyStatus(ENEMIES,FRIGHTENED,100,2)`

#### Row 7-10 (Implement in Phase 4)

**Phase 2 Deliverables:**
- ✅ Spell_Target.txt: +4 entries (Intervene, Victory Rush, Impending Victory, Pummel)
- ✅ Spell_Shout.txt: +7 entries (Commanding Shout, Rallying Cry, Berserker Rage, Die by the Sword, Defensive Stance, Enrage, Second Wind, Spell Reflection)
- ✅ Spell_Jump.txt: +1 entry (Heroic Leap)
- ✅ Spell_Zone.txt: +1 entry (Intimidating Shout)
- ✅ Status_BOOST.txt: +8 entries (Commanding Shout, Berserker Rage, Die by the Sword, Defensive Stance, Spell Reflection, Intervene Shield, Spell Lock, Victorious proc)
- ✅ Passive.txt: +10 entries (Unbridled Fury, Focused Rage, wrappers for all Row 1-6 talents)
- ✅ Progressions.lsx: +150 lines (Class Talent SelectPassives for Rows 1-6)
- ✅ English.loca.xml: +36 handles

**Phase 2 Time Estimate:** 15-20 hours

---

### Phase 3: Arms Specialization - Colossus (15-20 hours)

**Goal:** Implement one complete hero talent tree for Arms (recommend Colossus)

**Abilities Needed (8-10 total):**

#### L13 - Keystone
1. **Demolish** (Spell_Target.txt) - 45min
   - Shield-based attack that stacks Colossal Might
   - `UseCosts: ActionPoint:1;Rage:30`
   - `TargetConditions: HasShieldEquipped(context.Source)`
   - `SpellSuccess: DealDamage(3d10+StrengthModifier,MainMeleeWeaponDamageType,Magical);ApplyStatus(SELF,WAR_COLOSSAL_MIGHT,100,10)`

2. **WAR_COLOSSAL_MIGHT** (Status_BOOST.txt) - 30min
   - Stacking buff (max 5 stacks)
   - `StackType: Additive`
   - `StackPriority: 1`
   - `Boosts: Damage(Increase,1d4,All)` (per stack)

#### L14 - Passive 1
3. **Unshakable** (Passive.txt) - 20min
   - +1 AC per Colossal Might stack
   - `Boosts: IF(HasStatus('WAR_COLOSSAL_MIGHT')):AC(StatusStackCount(WAR_COLOSSAL_MIGHT))`

#### L15 - Choice Node 1 (Pick 1 of 3)
4. **One-Handed Specialization** (Passive.txt) - 20min
   - +1d6 damage with one-handed weapons
   - `Boosts: IF(IsWeaponOneHanded()):Damage(Increase,1d6,MainMeleeWeaponDamageType)`

5. **Practiced Strikes** (Passive.txt) - 20min
   - Demolish Rage cost reduced to 20
   - `Boosts: IF(HasSpell('Target_WAR_Demolish')):RageCostReduction(10,Target_WAR_Demolish)`

6. **Shield Mastery** (Passive.txt) - 20min
   - Shield Slam grants 1 stack of Colossal Might
   - `StatsFunctorContext: OnCast`
   - `Conditions: HasStringInSpellRoll('Target_WAR_ShieldSlam')`
   - `StatsFunctors: ApplyStatus(SELF,WAR_COLOSSAL_MIGHT,100,10)`

#### L16 - Passive 2
7. **Unyielding** (Passive.txt) - 20min
   - Immune to Prone/Knockback
   - `Boosts: Immunity(Prone);Immunity(Knockback)`

#### L17 - Choice Node 2 (Pick 1 of 3)
8. **Crashing Chaos** (Passive.txt) - 20min
   - Demolish hits enemies in 3m radius
   - Modifies Demolish to Spell_Zone.txt version OR adds AoE effect

9. **Impassable Wall** (Passive.txt) - 20min
   - Colossal Might grants +10% damage reduction per stack
   - `Boosts: IF(HasStatus('WAR_COLOSSAL_MIGHT')):DamageReduction(Flat,StatusStackCount(WAR_COLOSSAL_MIGHT)*10)`

10. **Bulwark** (Passive.txt) - 20min
    - Max Colossal Might stacks increased to 8
    - Modify WAR_COLOSSAL_MIGHT status `MaxStacks: 8`

#### L18 - Passive 3
11. **Concussive Blows** (Passive.txt) - 20min
    - Shield Slam/Demolish apply Disadvantage
    - `StatsFunctorContext: OnCast`
    - `Conditions: HasStringInSpellRoll('Target_WAR_ShieldSlam|Target_WAR_Demolish')`
    - `StatsFunctors: ApplyStatus(TARGET,WAR_CONCUSSIVE_BLOWS,100,2)`

12. **WAR_CONCUSSIVE_BLOWS** (Status_BOOST.txt) - 15min
    - Disadvantage on attack rolls
    - `Boosts: Disadvantage(AttackRoll)`

#### L19 - Choice Node 3 (Pick 1 of 3)
13. **No Quarter** (Passive.txt) - 20min
    - Colossal Might increases crit damage by 10% per stack
    - `Boosts: IF(HasStatus('WAR_COLOSSAL_MIGHT')):CriticalDamage(Increase,StatusStackCount(WAR_COLOSSAL_MIGHT)*10)`

14. **Mountain of Steel** (Passive.txt) - 20min
    - +2 AC while at 3+ Colossal Might stacks
    - `Boosts: IF(StatusStackCount(WAR_COLOSSAL_MIGHT)>=3):AC(2)`

15. **Fortress** (Passive.txt) - 20min
    - Gain Temporary HP equal to 2× Colossal Might stacks when Demolish crits
    - `StatsFunctorContext: OnCast`
    - `Conditions: IsCriticalHit();HasStringInSpellRoll('Target_WAR_Demolish')`
    - `StatsFunctors: GainTemporaryHitPoints(StatusStackCount(WAR_COLOSSAL_MIGHT)*2)`

#### L20 - Capstone
16. **Dominance of the Colossus** (Passive.txt) - 30min
    - At 3+ stacks, Avatar/Shield Slam/Demolish cost 0 Rage
    - `Boosts: IF(StatusStackCount(WAR_COLOSSAL_MIGHT)>=3):RageCostReduction(100,Target_WAR_Avatar;Target_WAR_ShieldSlam;Target_WAR_Demolish)`

**Phase 3 Deliverables:**
- ✅ Spell_Target.txt: +1 entry (Demolish)
- ✅ Status_BOOST.txt: +2 entries (Colossal Might, Concussive Blows)
- ✅ Passive.txt: +13 entries (Keystone wrapper + 12 choice/passive nodes)
- ✅ Progressions.lsx: +150 lines (L13-L20 Specialization progression with SelectPassives)
- ✅ English.loca.xml: +32 handles

**Phase 3 Time Estimate:** 15-20 hours

---

### Phase 4: Remaining Arms Talents (15-20 hours)

**Goal:** Complete Rows 7-10 of Class Talents + Rows 4-10 of Arms Spec Talents

**Abilities Needed (12-15 total):**

#### Class Talents Row 7 - AoE (3 NEW, 1 exists)
1. ✅ **Whirlwind** - EXISTS in SubclassBase
2. **Thunder Clap** (Spell_Zone.txt) - 30min
   - AoE slow
   - `UseCosts: ActionPoint:1;Rage:20`
   - `AreaRadius: 3m`
   - `SpellSuccess: DealDamage(1d8,Thunder,Magical);ApplyStatus(ENEMIES,SLOWED,100,2)`

3. **Cleave** (Already in Phase 1 if Arms-specific, or create Class version) - 30min

#### Class Talents Row 8 - Movement (3 NEW)
4. **Juggernaut** (Passive.txt) - 20min
   - Charge stuns target
   - Modifies existing Charge spell

5. **War Machine** (Passive.txt) - 20min
   - Killing blow resets Charge cooldown
   - `StatsFunctorContext: OnKill`
   - `StatsFunctors: ResetCooldown(Target_WAR_Charge)`

6. **Bounding Stride** (Passive.txt) - 20min
   - Charge increases movement speed
   - `StatsFunctorContext: OnCast`
   - `Conditions: HasStringInSpellRoll('Target_WAR_Charge')`
   - `StatsFunctors: ApplyStatus(SELF,WAR_BOUNDING_STRIDE,100,2)`

#### Class Talents Row 9 - Major Cooldowns (3 NEW)
7. **Avatar** (Spell_Shout.txt) - 45min
   - Major defensive/offensive cooldown
   - `UseCosts: ActionPoint:1;Rage:0`
   - `Cooldown: OncePerLongRest`
   - `SpellSuccess: ApplyStatus(SELF,WAR_AVATAR,100,10)`

8. **WAR_AVATAR** (Status_BOOST.txt) - 30min
   - Complex buff: +20% damage, immune to CC, +2 AC
   - `Boosts: Damage(Increase,20,All);Immunity(Frightened);Immunity(Charmed);Immunity(Stunned);AC(2)`

9. **Recklessness** (Spell_Shout.txt) - 30min
   - Advantage on attacks, enemies have Advantage
   - `UseCosts: ActionPoint:1;Rage:0`
   - `Cooldown: OncePerShortRest`
   - `SpellSuccess: ApplyStatus(SELF,WAR_RECKLESSNESS,100,3)`

10. **Bladestorm** (Spell_Zone.txt) - 45min
    - Channel AoE whirlwind
    - `UseCosts: ActionPoint:1;Rage:40`
    - `Cooldown: OncePerShortRest`
    - `AreaRadius: 4m`
    - `SpellSuccess: DealDamage(6d6,MainMeleeWeaponDamageType,Magical)` (hits all in radius)

#### Class Talents Row 10 - Already in Phase 2 or skip for Arms

#### Arms Spec Row 4 - Mastery (3 NEW)
11. **Deep Wounds** (Already in Phase 1) - skip
12. **Sudden Death** (Passive.txt) - 20min
    - Execute can be used above 20% HP (procs)
    - `Boosts: UnlockPassive(WAR_SUDDEN_DEATH_PROC)`
    - Requires proc mechanic

13. **Massacre** (Passive.txt) - 20min
    - Execute threshold increased to 35% HP
    - Modifies Execute spell `TargetConditions: HealthPercentage(context.Target) <= 35`

#### Arms Spec Row 5 - Control (3 NEW)
14. **Shockwave** (Spell_Zone.txt) - 30min
    - Cone stun
    - `UseCosts: ActionPoint:1;Rage:30`
    - `Cooldown: OncePerTurn`
    - `AreaRadius: 4m (cone)`
    - `SpellSuccess: ApplyStatus(ENEMIES,STUNNED,100,2)`

15. **Storm Bolt** (Spell_Projectile.txt) - 30min
    - Ranged stun
    - `UseCosts: ActionPoint:1;Rage:25`
    - `Range: 18m`
    - `SpellSuccess: DealDamage(2d6,Thunder,Magical);ApplyStatus(TARGET,STUNNED,100,1)`

16. **Demoralizing Shout** (Spell_Zone.txt) - 30min
    - AoE attack debuff
    - `UseCosts: ActionPoint:1;Rage:20`
    - `SpellSuccess: ApplyStatus(ENEMIES,WAR_DEMORALIZED,100,4)`

#### Arms Spec Row 6 - Execute Enhancements (Already in Phase 1 or add variants)

#### Arms Spec Row 7 - Debuffs (3 NEW)
17. **Sunder Armor** (Already implemented?) - VERIFY
18. **Mortal Wounds** (Passive enhancement to Mortal Strike) - Already in Phase 1
19. **Trauma** (Passive.txt) - 20min
    - Deep Wounds also slows targets
    - Modifies WAR_DEEP_WOUNDS status

#### Arms Spec Row 8-10 - Skip for initial prototype OR add major cooldown enhancements

**Phase 4 Deliverables:**
- ✅ Spell_Target.txt: +2 entries
- ✅ Spell_Shout.txt: +2 entries (Avatar, Recklessness)
- ✅ Spell_Zone.txt: +4 entries (Thunder Clap, Bladestorm, Shockwave, Demoralizing Shout)
- ✅ Spell_Projectile.txt: +1 entry (Storm Bolt)
- ✅ Status_BOOST.txt: +5 entries (Avatar, Recklessness, Bounding Stride, Demoralized, modified Deep Wounds)
- ✅ Passive.txt: +8 entries (Juggernaut, War Machine, Bounding Stride, Sudden Death, Massacre, Trauma, wrappers)
- ✅ Progressions.lsx: +200 lines (Rows 7-9 Class + Rows 4-7 Arms)
- ✅ English.loca.xml: +40 handles

**Phase 4 Time Estimate:** 15-20 hours

---

### Phase 5: Progressions.lsx Integration (10-15 hours)

**Goal:** Create complete L1-L20 Progressions.lsx entries for Arms Warrior

**Deliverables:**

1. **Base Class Progression** (L1-L20) - 3 hours
   - Hit Die, Rage resource, Extra Attack, ASI/Feats
   - Copy from existing Warrior base progression

2. **Arms Subclass Progression** (L3-L20) - 5 hours
   - **L3-L12:** Pool 1 + Pool 2 + Pool 3 auto-grants
   - SelectPassives nodes for each row (2 per level L3-L9)
   - SubclassBase auto-grants via Boosts/PassivesAdded

3. **Specialization Progression** (L13-L20) - 4 hours
   - SelectPassives for Keystone choice (L13)
   - SelectPassives for Choice Nodes (L15, L17, L19)
   - PassivesAdded for auto-granted passives (L14, L16, L18, L20)

4. **Validation & Testing** - 3 hours
   - Verify all UUIDs correct
   - Check SelectPassives have correct Amount values
   - Ensure proper nesting and dependencies
   - Test in-game (if possible)

**Example Structure (Level 5 Arms):**
```xml
<node id="Progression">
    <attribute id="Level" type="uint8" value="5"/>
    <attribute id="Name" type="LSString" value="Arms"/>
    <attribute id="UUID" type="guid" value="UUID_ARMS_L5"/>
    
    <!-- Base Class: Extra Attack -->
    <attribute id="PassivesAdded" type="LSString" value="ExtraAttack"/>
    
    <!-- Pool 3 (SubclassBase): Auto-grant Hamstring -->
    <attribute id="Boosts" type="LSString" value="UnlockSpell(Target_WAR_Hamstring)"/>
    
    <children>
        <!-- Pool 1 (Class Talents): Row 6 Choice -->
        <node id="SelectPassives">
            <attribute id="UUID" type="guid" value="UUID_CLASS_ROW6"/>
            <attribute id="Amount" type="uint8" value="1"/>
            <attribute id="Passives" type="LSString" value="WAR_Class_Row6_Pummel;WAR_Class_Row6_SpellReflection;WAR_Class_Row6_IntimidatingShout"/>
        </node>
        
        <!-- Pool 2 (Arms Spec): Row 3 Choice -->
        <node id="SelectPassives">
            <attribute id="UUID" type="guid" value="UUID_ARMS_ROW3"/>
            <attribute id="Amount" type="uint8" value="1"/>
            <attribute id="Passives" type="LSString" value="ARMS_Row3_SweepingStrikes;ARMS_Row3_CleaveEnhancement;ARMS_Row3_RendMastery"/>
        </node>
    </children>
</node>
```

**Phase 5 Deliverables:**
- ✅ Progressions.lsx: ~600-800 lines (complete L1-L20 Arms)
- ✅ UUID generation for all progression nodes
- ✅ Dependency verification (ensure prerequisites met)

**Phase 5 Time Estimate:** 10-15 hours

---

### Phase 6: Localization (5-10 hours)

**Goal:** Create all English.loca.xml handles for Arms abilities

**Total Handles Needed:** ~100-120 handles (2 per ability)

**Handle Format:** `h[8hex][2digit]` (e.g., `h125abc01`, `h125abc02`)

**Example Entries:**
```xml
<contentList>
    <!-- Mortal Strike -->
    <content contentuid="h125abc01" version="1">Mortal Strike</content>
    <content contentuid="h125abc02" version="1">A vicious strike that deals 2d12 weapon damage and reduces healing by 50% for 6 turns.</content>
    
    <!-- Overpower -->
    <content contentuid="h125abc03" version="1">Overpower</content>
    <content contentuid="h125abc04" version="1">Strike with overwhelming force, dealing 2d10 damage. Can only be used after the target dodges an attack.</content>
    
    <!-- Rend -->
    <content contentuid="h125abc05" version="1">Rend</content>
    <content contentuid="h125abc06" version="1">Wounds the target, inflicting 1d6 bleed damage per turn for 8 turns.</content>
    
    <!-- Colossus Smash -->
    <content contentuid="h125abc07" version="1">Colossus Smash</content>
    <content contentuid="h125abc08" version="1">Smash the enemy's defenses, dealing 2d8 damage and reducing their armor by 2 for 6 turns.</content>
    
    <!-- ... etc for all ~50-60 abilities -->
</contentList>
```

**Process:**
1. Generate unique handle IDs for all abilities (use sequential hex)
2. Write DisplayName (short) for each
3. Write Description (detailed mechanics) for each
4. Update all Spell_*.txt entries with correct handles
5. Validate no duplicate contentuid values

**Phase 6 Deliverables:**
- ✅ English.loca.xml: +100-120 handles
- ✅ All Spell/Status/Passive files updated with correct handle references
- ✅ No duplicate contentuid values

**Phase 6 Time Estimate:** 5-10 hours

---

### Phase 7: Testing & Debugging (10-15 hours)

**Goal:** Package mod, test in-game, fix bugs, validate 5-pool system

**Testing Protocol:**

#### 1. Pre-Packaging Validation (2 hours)
- [ ] Run UUID consistency check (grep for 78fe4967-4e62-5491-d981-dd781acca4d7)
- [ ] Validate all XML files (meta.lsx, Progressions.lsx, ClassDescriptions.lsx)
- [ ] Check Spell_*.txt syntax (no missing quotes, proper data "key" "value" format)
- [ ] Verify all handle references exist in English.loca.xml
- [ ] Check for duplicate contentuid values

#### 2. Packaging (1 hour)
```powershell
& "LsLib\ConverterApp.exe" `
  --source "Data" `
  --destination "Package\BG3Wow_v2.0.0_ARMS_PROTOTYPE.pak" `
  --action "create-package" `
  --package-version "v18" `
  --compression-method "lz4"
```

#### 3. Installation & Launch (1 hour)
- Copy .pak to `%LOCALAPPDATA%\Larian Studios\Baldur's Gate 3\Mods\`
- Open BG3 Mod Manager
- Enable mod, export load order
- Launch game (check for crashes)

#### 4. Character Creation Testing (2 hours)
- [ ] Create NEW Arms Warrior character
- [ ] Verify Rage bar visible (11 pips, 100 max)
- [ ] Check Class Talents Pool 1 Row 1: Charge + Heroic Leap + Intervene visible
- [ ] Check Class Talents Pool 1 Row 2: 3 options (Battle Shout | Commanding Shout | Rallying Cry)
- [ ] Verify localization (no missing text, all ability names/descriptions display)

#### 5. Level-by-Level Validation (3 hours)
- [ ] **L1:** Pool 1 Row 1 auto-granted, Row 2 choice works
- [ ] **L2:** Pool 1 Row 3 choice works
- [ ] **L3:** Subclass selection appears, Pool 2 Row 1 choice works, SubclassBase Whirlwind granted
- [ ] **L4:** Feat selection works, Pool 1 Row 5 + Pool 2 Row 2 choices work, Execute granted
- [ ] **L5:** Extra Attack granted, Hamstring granted, 2 talent choices work
- [ ] **L6-L12:** All talent choices appear correctly, SubclassBase abilities granted at correct levels
- [ ] **L13:** Specialization choice appears (Colossus | Slayer), Keystone granted
- [ ] **L15/L17/L19:** Choice nodes appear with 3 options each
- [ ] **L20:** Capstone granted

#### 6. Ability Functionality Testing (3 hours)
- [ ] **Mortal Strike:** Casts correctly, deals damage, applies Mortal Wounds debuff (check healing reduction)
- [ ] **Overpower:** Only usable after dodge proc (verify condition)
- [ ] **Rend:** Applies bleed DoT (verify 1d6 per turn, 8 turns)
- [ ] **Colossus Smash:** Applies -2 AC debuff (verify with Examine)
- [ ] **Sweeping Strikes:** Hits multiple targets (verify AoE effect)
- [ ] **Execute:** Only usable below 20% HP, deals massive damage
- [ ] **Heroic Leap:** Gap closer works, landing AoE damage applies
- [ ] **Charge:** Teleports to target, generates Rage
- [ ] **Avatar:** Grants immunity to CC, damage boost visible
- [ ] **Demolish:** Grants Colossal Might stacks (check status icon)
- [ ] **Dominance (L20):** Free abilities at 3+ stacks (verify 0 Rage cost)

#### 7. Bug Fixing (2 hours)
- Check Script Extender logs: `%LOCALAPPDATA%\Larian Studios\Baldur's Gate 3\ScriptExtender\Logs\`
- Fix any errors (missing UUIDs, malformed XML, etc.)
- Re-package and re-test

#### 8. Balance Testing (1 hour)
- Play through combat encounters L1-L10
- Verify damage feels appropriate (not overpowered/underpowered)
- Check Rage economy (can use abilities frequently enough?)
- Test talent synergies (Colossus Smash → Mortal Strike combo)

**Phase 7 Deliverables:**
- ✅ BG3Wow_v2.0.0_ARMS_PROTOTYPE.pak (tested, functional)
- ✅ Bug fixes applied
- ✅ Testing report document (list of verified features)
- ✅ Known issues document (any unresolved problems)

**Phase 7 Time Estimate:** 10-15 hours

---

## Total Time Breakdown

| Phase | Description | Time Estimate |
|-------|-------------|---------------|
| **Phase 1** | Core Arms Rotation (12-15 abilities) | 20-25 hours |
| **Phase 2** | Class Talents Pool 1 (15-18 abilities) | 15-20 hours |
| **Phase 3** | Arms Specialization - Colossus (8-10 abilities) | 15-20 hours |
| **Phase 4** | Remaining Arms Talents (12-15 abilities) | 15-20 hours |
| **Phase 5** | Progressions.lsx Integration | 10-15 hours |
| **Phase 6** | Localization (100-120 handles) | 5-10 hours |
| **Phase 7** | Testing & Debugging | 10-15 hours |
| **TOTAL** | **Full Arms Implementation** | **85-120 hours** |

---

## File Type Summary

**Total NEW Entries Needed for Arms:**

| File | NEW Entries | Estimated Time |
|------|-------------|----------------|
| **Spell_Target.txt** | ~15-18 | 8-10 hours |
| **Spell_Shout.txt** | ~10-12 | 6-8 hours |
| **Spell_Zone.txt** | ~8-10 | 5-7 hours |
| **Spell_Jump.txt** | ~1 | 30 min |
| **Spell_Projectile.txt** | ~1-2 | 30-60 min |
| **Status_BOOST.txt** | ~20-25 | 10-12 hours |
| **Passive.txt** | ~30-35 | 12-15 hours |
| **Progressions.lsx** | ~600-800 lines | 10-15 hours |
| **English.loca.xml** | ~100-120 handles | 5-10 hours |

**Grand Total:** ~47-53 NEW abilities (excluding existing SubclassBase)

---

## Success Criteria

**Minimal Viable Arms (Phase 1-2):**
- ✅ Arms playable L1-L10 with basic rotation
- ✅ Core abilities work (Mortal Strike, Overpower, Rend, Colossus Smash, Execute)
- ✅ Class Talents Pool 1 functional (Rows 1-6 choices appear)
- ✅ SubclassBase auto-grants work (12 abilities by L12)

**Complete Arms Prototype (All Phases):**
- ✅ Arms playable L1-L20 with full 5-pool system
- ✅ All Class Talents rows functional (10 rows, 9 choices)
- ✅ All Arms Spec Talents functional (10 rows, 9 choices)
- ✅ Colossus Specialization complete (Keystone + 3 choices + passives + Capstone)
- ✅ Character creation smooth (no crashes, all text displays)
- ✅ Abilities cast correctly (damage, status effects, cooldowns)
- ✅ 5-pool system validated for expansion to Fury/Protection

---

## Next Steps After Arms Completion

1. **Validate 5-Pool System:**
   - Confirm SelectPassives ≤12 options works
   - Verify deep nesting doesn't cause issues
   - Test UI display limits
   - Document any BG3 constraints discovered

2. **Create Template System:**
   - Use Arms as template for Fury/Protection
   - Document reusable patterns (spell structures, passive wrappers, progression nodes)
   - Create ability creation templates (reduce time per ability)

3. **Expand to Fury:**
   - Copy Pool 1 (Class Talents) from Arms ✅
   - Copy Pool 3 (SubclassBase) ✅ (already exists)
   - Implement Pool 2 (Fury Spec Talents) - ~24-28 NEW abilities
   - Implement Pool 4/5 (Mountain Thane or Slayer) - ~7-8 NEW abilities
   - Estimated Time: 40-50 hours (faster due to templates)

4. **Expand to Protection:**
   - Copy Pool 1 (Class Talents) from Arms ✅
   - Copy Pool 3 (SubclassBase) ✅ (already exists)
   - Implement Pool 2 (Protection Spec Talents) - ~24-28 NEW abilities
   - Implement Pool 4/5 (Mountain Thane or Colossus) - ~7-8 NEW abilities
   - Estimated Time: 40-50 hours

5. **Final Polish:**
   - Balance all 3 specs
   - Complete all specializations (6 total)
   - Final testing pass
   - Documentation updates
   - Estimated Time: 30-40 hours

**Total Time to Complete Mod (All 3 Specs):** ~200-260 hours

---

## Risk Mitigation

**Known Risks:**
1. **SelectPassives Limit:** May be ≤12 options per node
   - **Mitigation:** Keep rows to ≤10 talents, test early
2. **Passive Wrapper Complexity:** Nested conditionals may fail
   - **Mitigation:** Test simple passives first, add complexity incrementally
3. **Progressions.lsx Nesting:** Deep XML structures may cause crashes
   - **Mitigation:** Validate XML frequently, use XML validator tool
4. **Status Effect Interactions:** Multiple buffs/debuffs may conflict
   - **Mitigation:** Test one ability at a time, document conflicts

**Contingency Plans:**
- If SelectPassives limit discovered: Reduce talents per row (e.g., 8 instead of 10)
- If passive wrappers fail: Use direct Boosts in Progressions.lsx instead
- If crashes occur: Use Script Extender logs to diagnose, create minimal test cases

---

## Conclusion

This roadmap provides a **complete, phase-by-phase implementation plan** for Arms Warrior as a prototype for the 5-pool talent system.

**Current Position:** Ready to begin Phase 1 (Core Arms Rotation)

**Recommended Next Action:** Start with Phase 1, implement 12-15 core Arms abilities, test basic functionality, then proceed to Phase 2.

---

**Last Updated:** October 17, 2025  
**Status:** Ready for Implementation  
**Estimated Completion:** 85-120 hours for full Arms prototype
