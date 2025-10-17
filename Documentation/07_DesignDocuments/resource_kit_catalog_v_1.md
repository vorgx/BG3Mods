# WoW → BG3 Resource & Kit Catalog (v1.0)

**Policy switch:** **Mana now uses `Meter 0–100`** (not charges). All mana-using abilities below have updated costs and regen. Use this catalog to author Sections **8 / 9 / 17 / 14 / 15** in the Blueprint.

---
## Global Mapping Rules
- **One resource per class.** Subclasses **share** the class resource and vary **how they gain** it.
- **Resource Types**
  - **Meter (0–100):** Rage, Focus, Energy, Fury, Insanity, Maelstrom, Runic Power, **Mana**.
  - **Pips:** Holy Power (0–5), Combo Points (0–6), Chi (0–5/6), Soul Shards (0–5), Arcane Charges (0–4) → if you prefer, treat Arcane Charges as **Charges** (0–4) + Mana meter.
  - **Stacks:** Maelstrom Weapon (0–10), special stackers.
- **Upcasting window:** Only for classes that explicitly use pips-as-upcast (your BG3 rule); default spender costs are **fixed**, unless marked.
- **Per-turn gain throttles:** Use `perTurnCap` and `icdTurns` on all passive/event gains.
- **Concentration:** Auras/fields/channels use Concentration unless clearly instantaneous.

---
## Template Snippet (drop-in skeleton per class)
```json
{
  "resource": {
    "key": "CLASS_RESOURCE",
    "uiName": "<Rage|Focus|Energy|Fury|Insanity|Maelstrom|Runic Power|Mana|…>",
    "type": "<Meter|Pips|Stacks|Charges>",
    "cap": <100|5|6|4|10>,
    "softCap": { "level": null, "maxPipsAtLevel": null },
    "combatOnly": true,
    "carryOverBetweenFights": false,
    "regen": { "perTurn": <class default>, "outOfCombat": <class default> },
    "spendersPolicy": { "upcastMax": 0, "minSpend": 0, "validateCostsAgainstCap": true }
  },
  "defaultGains": [ /* class-wide gains */ ],
  "subclassResourceAcquisition": { /* spec gains only */ },
  "classCore": { "builders": [], "spenders": [], "passives": [], "toggles": [] },
  "subclassKits": { "<SPEC>": { /* kit */ } }
}
```

---
# Classes → Specs (1:1 WoW → BG3)

## Warrior (Arms • Fury • Protection)
**Resource:** Rage — **Meter 0–100**
- **Default Gains:** On Hit Taken +3 (cap 9/turn); On Weapon Hit +2 (cap 6/turn); On Crit +3 (ICD 1 turn)
- **Regen:** perTurn 0; OOC 0
- **Spenders:** 20–40 Rage, fixed

**Shared Class Kit**
- **Primary Strike** (Action, 0 Rage): +5 Rage on Hit.
- **Charge** (Bonus): Gap close; next melee +2[W].
- **Heroic Shout** (Bonus, 1/short rest): Allies +1 to hit 2 turns.
- **Second Wind** (Action, 30 Rage): Heal small; cleanse Minor Slow.

**Arms**
- **Overpower** (Action, 20 Rage): Big hit; +50% vs Bleeding.
- **Mortal Strike** (Action, 30 Rage, CD 2): Apply -30% Healing 2 turns.
- **Colossus Mark** (Action, 20 Rage, CD 3, Conc.): Ignore 25% AC vs target.
- **Deep Wounds** (Passive): Crits apply Bleed; each tick +2 Rage (cap +4/turn).

**Fury**
- **Bloodthirst** (Action, 20 Rage): Hit + small self-heal; Crit → **Enrage** (2 turns) granting +1 Bonus Attack this turn.
- **Raging Flurry** (Bonus, 20 Rage): 2 strikes; if Enraged, each refunds +2 Rage on Hit (cap 4/turn).
- **Recklessness** (Action, 0 Rage, CD 4): 2 turns: +1 Rage per Hit event (no cap).
- **Meat Grinder** (Passive): On Kill: +15 Rage instantly.

**Protection**
- **Shield Slam** (Action, 15 Rage): Hit; gain **Guarded** 1 turn; next Block +10 Rage.
- **Revenge** (Action, 20 Rage): Cone cleave; **free** if you blocked since last turn.
- **Last Stand** (Action, 30 Rage, CD 4): +20 THP 2 turns; when hit: +3 Rage (cap 9/turn).
- **Bulwark Stance** (Toggle, no cost): +1 AC; On Hit Taken +3 Rage (cap 9/turn).

---
## Paladin (Retribution • Protection • Holy)
**Resource:** Holy Power — **Pips 0–5**
- **Default Gains:** Builders +1; On Crit +1 (ICD 1 turn)
- **Regen:** perTurn 0; OOC 0
- **Spenders:** Finishers 3–5 pips

**Shared Class Kit**
- **Judgment** (Action, Builder): +1 Holy Power; Mark target (-1 AC vs you).
- **Blessing of Freedom** (Bonus): Cleanse & Resist Slow 2 turns.
- **Lay on Hands** (Action, 1/short rest): Big heal.
- **Divine Shield** (Action, 1/long rest): 1 turn immunity; ends your Concentration.

**Retribution**
- **Templar’s Strike** (Action, Builder): +1 pip; +1 die vs Marked.
- **Blade of Justice** (Action, Builder, CD 2): +2 pips.
- **Templar’s Verdict** (Action, Spender 3–5): Heavy ST; +10% per extra pip.
- **Crusade** (Action, CD 3, costs 3 pips): 2 turns: +1 Bonus Attack; Judgments generate +2.

**Protection**
- **Avenger’s Shield** (Action, Builder): Ranged shield bash; +1 pip; Interrupt (CON save).
- **Shield of the Righteous** (Action, Spender 3): +2 AC 2 turns; radiant hit.
- **Consecration** (Action, 0 pips, Conc.): Ground AoE; standing in it, your **Block** grants +1 pip (cap 2/turn).
- **Guardian of Ancient Kings** (Action, CD 4, 3 pips): 2 turns -50% damage taken.

**Holy** (healer)
- **Mana:** **Meter 0–100**; Regen perTurn 5; OOC 20
- **Holy Shock** (Bonus, builder, **Mana 8**): Heal or damage; +1 pip.
- **Word of Glory** (Action, spender 3–5, **Mana 15**): Group heal; +15% per extra pip.
- **Aura of Mercy** (Toggle, Conc., **Mana 5/turn**): Small team heal each turn; while active, builders grant +1 extra pip (ICD 1).
- **Beacon of Light** (Action, Conc., **Mana 12**): Redirect 50% heals to target 3 turns.

---
## Hunter (Beast Mastery • Marksmanship • Survival)
**Resource:** Focus — **Meter 0–100**
- **Regen:** perTurn 10; OOC 20; Haste: +5/turn per 10 Haste
- **Default Gains:** Weapon Hit +5 (cap 15/turn)
- **Spenders:** 20–40 Focus

**Shared Class Kit**
- **Steady Shot** (Action): +20 Focus if stationary; +10 if moved.
- **Disengage** (Bonus): Leap back; +10 Focus.
- **Hunter’s Mark** (Bonus, Conc.): vs target +1 die.
- **Feign Death** (Action, 1/short rest): Drop aggro/targeting.

**Beast Mastery**
- **Kill Command** (Bonus, 30 Focus): Pet strike; On Kill: refund 15.
- **Bestial Wrath** (Action, 40 Focus, CD 3): Pet +25% dmg 2 turns; your Focus regen +10/turn.
- **Barbed Shot** (Action, 25 Focus): Bleed; ticks +5 Focus (cap +15/turn from ticks).
- **Call of the Wild** (Action, 1/short rest): Summon beast 3 turns.

**Marksmanship**
- **Aimed Shot** (Action, 35 Focus, CD 2): Heavy shot; +50% if you didn’t move.
- **Rapid Fire** (Action, 30 Focus): Beam; Crit refunds +5 (cap 10/turn).
- **Trueshot** (Action, CD 3): 2 turns: Aimed Shot costs 20 and has advantage.
- **Readiness** (Passive): On Kill: reset Rapid Fire.

**Survival**
- **Raptor Strike** (Action, 25 Focus): Melee hit; **Mongoose** stack +1 (max 5).
- **Mongoose Fury** (Action, 30 Focus): Consume stacks; +20% per stack.
- **Harpoon** (Bonus): Gap close; next melee grants +10 Focus on Hit.
- **Explosive Trap** (Action, 30 Focus): Ground trap, knock + burn.

---
## Rogue (Assassination • Outlaw • Subtlety)
**Resource:** Combo Points — **Pips 0–6** (baseline 5; feat can allow 6)
- **Default Gains:** Builders +1; Crit +1 (ICD 1)
- **Spenders:** Finishers 1–5 CP; CP reset on spend

**Shared Class Kit**
- **Backstab** (Action, Builder): +1 CP; from Stealth → advantage & +1 die.
- **Sprint** (Bonus): +6 m for 2 turns.
- **Vanish** (Action, 1/short rest): Enter Stealth; next builder +2 CP.
- **Kidney Shot** (Action, Finisher 2–5): Stun 1–3 turns (CON save each turn).

**Assassination**
- **Mutilate** (Action, Builder): +2 CP if target is Poisoned.
- **Deadly Poison** (Bonus, Toggle, Conc., **Mana 0**): Coat weapon; builders against Poisoned target +1 CP (ICD 1).
- **Envenom** (Action, Finisher 2–5): Heavy poison; +25% poison chance 2 turns.
- **Garrote** (Action, Builder, CD 2): Silence 1 turn; +1 CP.

**Outlaw**
- **Sinister Strike** (Action, Builder): 35% extra swing adding +1 CP.
- **Roll the Bones** (Action, 1/short rest): Random 3-turn buff.
- **Between the Eyes** (Action, Finisher 2–5): Heavy hit; higher CP → longer daze.
- **Grappling Hook** (Bonus): Mobility + advantage next melee.

**Subtlety**
- **Shadowstrike** (Action, Builder): Teleport strike from Stealth; +2 CP.
- **Symbols of Death** (Bonus, CD 2): 2 turns: builders +1 CP (ICD 1) & +1 die.
- **Eviscerate** (Action, Finisher 2–5): Heavy finisher; +25% from Stealth.
- **Shadow Dance** (Action, CD 3): 1 turn counts as Stealthed.

---
## Priest (Shadow • Holy • Discipline)
**Resource (Shadow):** Insanity — **Meter 0–100**
**Resource (Holy/Disc):** **Mana — Meter 0–100**
- **Holy/Disc Regen:** perTurn 6; OOC 20

**Shared Class Kit**
- **Smite** (Action): Light damage (Shadow: Psychic; Holy/Disc: Radiant).
- **Power Word: Shield** (Bonus, 1/short rest, **Mana 10**): THP bubble 2 turns.
- **Dispel Magic** (Action, **Mana 10**): Remove 1 magic effect.
- **Leap of Faith** (Bonus, **Mana 8**): Pull ally.

**Shadow**
- **Mind Blast** (Action, CD 2): +30 Insanity.
- **Vampiric Touch** (Action, Conc.): DoT; each tick +5 Insanity (cap +15/turn).
- **Devouring Plague** (Action, spend 50–100 Insanity): Heavy DoT; stacking rolls damage over.
- **Voidform** (Action, CD 3): 2 turns: builders +10 Insanity and +1 AC.

**Holy** (healer)
- **Holy Word: Serenity** (Action, **Mana 25**): Big single heal.
- **Prayer of Mending** (Action, **Mana 15**): Bouncing heal (5 hops max).
- **Renew** (Bonus, Conc., **Mana 10**): HoT 3 turns.
- **Guardian Spirit** (Reaction, **Mana 20**, 1/long rest): Prevent lethal; heal instead.

**Discipline** (healer/damage)
- **Penance** (Action, **Mana 16**): 3 bolts dmg or heal; heals targets with **Atonement**.
- **Power Word: Radiance** (Action, **Mana 20**): Applies Atonement to allies.
- **Atonement** (Passive): Damage heals Atoned allies (25%).
- **Evangelism** (Action, **Mana 18**, 1/short rest): Extend Atonement durations.

---
## Death Knight (Blood • Frost • Unholy)
**Resource:** Runic Power — **Meter 0–100**
- **Default Gains:** Builders +15–25; StartOfTurn +10 if you spent last turn (rune-cycle sim)
- **Spenders:** 25–40 RP

**Shared Class Kit**
- **Death Grip** (Bonus, CD 2): Pull enemy.
- **Death Strike** (Action, 35 RP): Hit + heal % recent damage.
- **Anti-Magic Shell** (Action, CD 3): Magic resist 1 turn; gain RP on absorb.
- **Raise Dead** (Action, 1/short rest): Ghoul 3 turns.

**Blood / Frost / Unholy** — as in prior draft (unchanged costs in RP); keep builders/spenders exactly as listed previously.

---
## Shaman (Elemental • Enhancement • Restoration)
**Resources:**
- **Elemental:** Maelstrom — **Meter 0–100**
- **Enhancement:** Maelstrom Weapon — **Stacks 0–10**
- **Restoration:** **Mana — Meter 0–100** (Regen perTurn 6; OOC 20)

**Shared Class Kit**
- **Flame Shock** (Action, Conc., **Mana 12** for Resto/Ele; no Mana for Enh): DoT.
- **Ghost Wolf** (Bonus): +3 m; immune to Slow 1 turn.
- **Purge** (Action, **Mana 10**): Remove 1 enemy buff.
- **Healing Surge** (Action, **Mana 16**): Single-target fast heal.

**Elemental**
- **Lava Burst** (Action): +20 Maelstrom; crits guaranteed vs Flame-shocked.
- **Earth Shock** (Action, spend 60 Maelstrom): Heavy hit.
- **Stormkeeper** (Action, CD 3): Next 2 Lightning spells cost 0 and +1 die.
- **Earthquake** (Action, spend 60, Conc.): Ground AoE knock chance.

**Enhancement**
- **Stormstrike** (Action): +2 Stacks; Crit +1 Stack.
- **Lava Lash** (Action): +1 Stack; +1 extra if Flame-shocked.
- **Elemental Blast** (Action, spend 5–10 stacks): Heavy hit; at 10 stacks, +1 AC 1 turn.
- **Feral Spirit** (Action, 1/short rest): Wolves; each hit +1 Stack (cap +5/turn).

**Restoration** (healer)
- **Riptide** (Bonus, **Mana 12**): Heal + HoT.
- **Chain Heal** (Action, **Mana 25**): Bounces (−20% per hop).
- **Spirit Link Totem** (Action, **Mana 30**, 1/short rest, Conc.): 2-turn redistribution zone.
- **Capacitor Totem** (Action, **Mana 15**, CD 2): Delayed AoE stun.

---
## Druid (Balance • Feral • Guardian • Restoration)
**Resources:**
- **Balance:** Astral Power — **Meter 0–100**
- **Feral:** Combo Points — **Pips 0–6**
- **Guardian:** Rage — **Meter 0–100**
- **Restoration:** **Mana — Meter 0–100** (Regen perTurn 6; OOC 20)

**Shared Class Kit**
- **Wild Shape** (Bonus): Swap forms.
- **Entangling Roots** (Action, Conc., **Mana 10**): Root 2 turns.
- **Rejuvenation** (Bonus, Conc., **Mana 10**): HoT.
- **Barkskin** (Reaction, 1/short rest): -30% damage 1 turn.

**Balance**
- **Wrath** (Action): +10 AP.
- **Starfire** (Action): +15 AP (line targets).
- **Starsurge** (Action, spend 40–80 AP): Heavy ST; costs less if both Eclipses up.
- **Starfall** (Action, spend 60 AP, Conc.): AoE rain.

**Feral** — as prior (CP-based)

**Guardian** — as prior (Rage-based)

**Restoration** (healer)
- **Swiftmend** (Action, **Mana 20**): Consume a HoT for burst heal.
- **Wild Growth** (Action, **Mana 25**): Group HoT.
- **Innervate** (Action, 1/short rest): An ally’s spells cost 0 Mana for 2 turns.
- **Tranquility** (Action, **Mana 40**, 1/long rest, Conc.): Channel heal.

---
## Mage (Arcane • Fire • Frost)
**Resources:**
- **All specs:** **Mana — Meter 0–100** (Regen perTurn 4; OOC 20)
- **Arcane:** **Arcane Charges — Charges 0–4** (secondary) that scale damage/cost

**Shared Class Kit**
- **Counterspell** (Reaction, **Mana 6**): Interrupt.
- **Blink** (Bonus, **Mana 4**): Short teleport.
- **Ice Block** (Action, **Mana 10**, 1/long rest): Self-stasis, cleanse.
- **Mirror Image** (Action, **Mana 12**, 1/short rest): Decoys.

**Arcane**
- **Arcane Blast** (Action, **Mana 10**): Add +1 Charge (max 4); damage scales per Charge.
- **Arcane Missiles** (Action, **Mana 20**): Spender; **consumes all Charges** to fire multi-hit beam.
- **Evocation** (Action, 1/short rest): Restore **40 Mana** over the turn.
- **Arcane Power** (Action, CD 3, **Mana 0**): 2 turns: spells +1 die; Charges decay slower.

**Fire**
- **Fireball** (Action, **Mana 12**): ST nuke; applies Burning 2 turns on crit.
- **Scorch** (Action, **Mana 5**): Light hit; advantage if target <30% HP.
- **Pyroblast** (Action, **Mana 30**): Heavy hit; if **Hot Streak**, may cast as Bonus.
- **Combustion** (Action, CD 3, **Mana 0**): 1 turn: spells always crit.
- **Phoenix Flames** (Action, CD 2, **Mana 20**): Cleave burst; ignites.

**Frost**
- **Frostbolt** (Action, **Mana 8**): Slow; next cast vs target gains advantage.
- **Ice Lance** (Action, CD 2, **Mana 15**): Double vs Chilled/Frozen.
- **Frozen Orb** (Action, CD 3, **Mana 30**): AoE chill field.
- **Icy Veins** (Action, CD 3, **Mana 0**): 2 turns: guaranteed **Chilled** from spells.

---
## Warlock (Affliction • Demonology • Destruction)
**Resources:** Soul Shards — **Pips 0–5** (+ fragments), **and Mana — Meter 0–100** (secondary, Regen perTurn 4; OOC 20)

**Shared Class Kit**
- **Health Funnel** (Action, **Mana 12**): Heal your pet.
- **Fear** (Action, Conc., **Mana 10**): Disorient 2 turns (save each turn).
- **Create Healthstone** (Action, **Mana 10**, 1/short rest): Consumable heal.
- **Unending Resolve** (Reaction, **Mana 8**, 1/short rest): -30% damage 1 turn.

**Affliction**
- **Corruption** (Action, Conc., **Mana 10**): DoT; ticks grant fragments (cap 10/turn).
- **Agony** (Action, Conc., **Mana 10**): Ramping DoT; accelerates fragment gain.
- **Unstable Affliction** (Action, **1 Shard + Mana 10**): Heavy DoT; dispel → burst.
- **Malefic Rapture** (Action, **Mana 20 + 1 Shard**): Detonate DoTs for burst.

**Demonology**
- **Summon Felguard** (Action, **Mana 20**, 1/short rest): Pet 3 turns.
- **Demonbolt** (Action, **Mana 12**): Builder; +20 fragments (double if 2+ demons active).
- **Hand of Gul’dan** (Action, **1–2 Shards + Mana 10**): AoE; summons imps scaling with shards.
- **Demonic Tyrant** (Action, **Mana 20**, 1/long rest): Extend demon durations; +1 die damage.

**Destruction**
- **Incinerate** (Action, **Mana 10**): Builder; +20 fragments.
- **Conflagrate** (Bonus, CD 2, **Mana 10**): Builder; +1 shard if target is **Immolated**.
- **Immolate** (Action, Conc., **Mana 10**): DoT; ticks grant fragments.
- **Chaos Bolt** (Action, **2 Shards + Mana 20**): Huge nuke.

---
## Monk (Windwalker • Brewmaster • Mistweaver)
**Resources:**
- **Windwalker:** Chi — **Pips 0–5/6**
- **Brewmaster:** Energy — **Meter 0–100** (Stagger as passive status)
- **Mistweaver:** **Mana — Meter 0–100** (Regen perTurn 6; OOC 20)

**Shared Class Kit**
- **Roll** (Bonus): Dash, 2 charges.
- **Provoke** (Bonus): Taunt.
- **Paralysis** (Action, **Mana 8** for Mistweaver; 0 otherwise): Disorient 1–2 turns.
- **Fortifying Brew** (Action, 1/short rest): +20 THP 2 turns.

**Windwalker** — as prior (Chi-based)

**Brewmaster** — as prior (Energy-based)

**Mistweaver** (healer)
- **Renewing Mist** (Bonus, **Mana 12**): Rolling HoT.
- **Enveloping Mist** (Action, **Mana 18**): Big HoT; target +1 AC.
- **Essence Font** (Action, **Mana 26**): Group channel heal; applies bolts.
- **Revival** (Action, **Mana 35**, 1/long rest): Mass dispel + heal.

---
## Demon Hunter (Havoc • Vengeance)
**Resource:** Fury — **Meter 0–100** (120 with feat)
- **Default Gains:** Builders +20–30; on Crit +10 (ICD 1)

**Shared Class Kit**
- **Fel Rush** (Bonus): Dash; leaves small fire.
- **Spectral Sight** (Bonus, 1/short rest): Reveal hidden.
- **Blur** (Reaction, 1/short rest): +2 AC 1 turn; adv. on DEX saves.
- **Throw Glaive** (Action, 0 Fury): Ranged bounce.

**Havoc / Vengeance** — as prior (Fury-based costs retained)

---
## Evoker (Devastation • Preservation • Augmentation)
**Resource:** Essence — **Charges 0–5/6** (regens +1 at Start of Turn). Evoker also has Mana in WoW, but **BG3 translation uses Essence as the primary**; you may optionally layer **Mana (Meter)** with small costs if desired.

**Shared Class Kit**
- **Hover** (Bonus): Fly 2 m; ignore difficult terrain 1 turn.
- **Landslide** (Action, CD 2): Line CC.
- **Emerald Blossom** (Action, **1 Essence**): Ground heal blossom.
- **Quell** (Reaction): Interrupt.

**Devastation / Preservation / Augmentation** — as prior (Essence-based)

# Class Resources by Spec — Mechanics & Caps (WoW reference)

> Purpose: quick, at‑a‑glance reference of each class/spec’s primary resource, how it’s generated/spent, and typical caps/quirks. Secondary resources (e.g., Mana for hybrids/healers) noted where relevant.

---

## Compact Overview Table

| Class | Spec | Primary Resource | Core Mechanics | Typical Cap | Secondary |
|---|---|---|---|---:|---|
| **Warrior** | Arms / Fury / Protection | **Rage** | Empties OOC; slowly decays OOC; generated by hits/talents; spent on attacks/defensives | 100 (talents may raise) | — |
| **Paladin** | Retribution | **Holy Power** | Builder → Spender cycle | 5 | Mana (for spells) |
|  | Protection | **Holy Power** | Builder → Spender cycle | 5 | Mana |
|  | Holy | **Holy Power** | Builder → Spender (some builds) | 5 | Mana (primary healer pool) |
| **Hunter** | Beast Mastery / Marksmanship / Survival | **Focus** | Passive regen (haste‑scaled); fuels shots/melee | 100 | — |
| **Rogue** | Assassination / Outlaw / Subtlety | **Energy** + **Combo Points** | Fast passive Energy regen; builders grant CP → finishers spend CP | 100 Energy; 5 CP base (talents allow >5 finishers) | — |
| **Priest** | Shadow | **Insanity** | Builders generate → spend on Devouring Plague | ~100 practical | Mana secondary |
|  | Holy / Discipline | **Mana** | Healer pool; throughput gated by regen/cost | Max mana | — |
| **Death Knight** | Blood / Frost / Unholy | **Runes** → **Runic Power** | 6 Runes recharge (~10s, haste‑reduced); spending Rune abilities generates RP → spenders | 6 Runes; RP ~0–100 | — |
| **Shaman** | Elemental | **Maelstrom** | Builder → Spender bar | ~0–100 | Mana secondary |
|  | Enhancement | **Maelstrom Weapon (stacks)** | Proc‑based stacks → spend at 5–10 | 10 stacks | Mana secondary |
|  | Restoration | **Mana** | Healer pool | Max mana | — |
| **Druid** | Balance | **Astral Power** | Builder → Spender bar | 100 | — |
|  | Feral | **Energy** + **Combo Points** | Energy fuels builders → CP to finishers | 100 Energy; 5 CP base | — |
|  | Guardian | **Rage** | Tank variant of Rage | 100 | — |
|  | Restoration | **Mana** | Healer pool | Max mana | — |
| **Mage** | Arcane | **Mana** + **Arcane Charges** | Charges (up to 4) modify mana cost/damage | 4 Charges; Mana | — |
|  | Fire / Frost | **Mana** | Caster pool; spec mechanics drive spend/regen | Max mana | — |
| **Warlock** | Affliction / Demonology / Destruction | **Soul Shards** | Fragments → full shards; spend on major spells | 5 shards (50 frags) | Mana secondary |
| **Monk** | Windwalker | **Energy** + **Chi** | Builders generate Chi → spenders consume | 100 Energy; 5 Chi (6 w/Ascension) | — |
|  | Brewmaster | **Energy** | No Chi since Legion; Stagger is mitigation, not a resource | 100 | — |
|  | Mistweaver | **Mana** | Healer pool | Max mana | — |
| **Demon Hunter** | Havoc / Vengeance | **Fury** | Builder → Spender; decays OOC; Vengeance uses Soul Fragments mechanic | 100 base (120 w/talents) | — |
| **Evoker** | Devastation / Preservation / Augmentation | **Essence** (+ Mana) | Essence “pips” passively regen (~1 per 5s); fuels key spells | 5 pips (6 w/talent) | Mana |

> **Legend:** OOC = out of combat; “Max mana” has no universal numeric cap beyond the character’s maximum mana at a given state.

---

## Per‑Class Notes (mechanics & quirks)

### Warrior — Rage
- **Generation:** dealing/taking damage; certain abilities/talents.
- **Decay/Reset:** empties and slowly decays when OOC.
- **Use:** physical spenders (offense/defense). **Cap:** 100; some talents increase.

### Paladin — Holy Power (+ Mana)
- **Specs:** Ret/Prot/Holy use **Holy Power** as a builder–spender cycle (cap **5**).
- **Mana:** used for spellcasting; behaves as a percentage‑based pool rather than a fixed 0–100 secondary bar.

### Hunter — Focus
- **Regen:** passive, scales with **Haste**.
- **Use:** ranged/melee shots; **Cap:** **100**.

### Rogue — Energy + Combo Points
- **Energy:** fast passive regen; **Cap 100**.
- **Combo Points:** builders grant CP; finishers consume. **Base cap 5**; talents (e.g., Deeper Stratagem) enable finishers above 5 CP.

### Priest — Insanity / Mana
- **Shadow:** **Insanity** as builder–spender (practical **cap ~100**), spent notably on *Devouring Plague*. Mana secondary.
- **Holy/Discipline:** **Mana** as primary healer pool (no universal numeric cap beyond max mana).

### Death Knight — Runes → Runic Power
- **Runes:** 6 charges; recharge ≈ **10s** baseline; reduced by **Haste**.
- **Runic Power:** generated by Rune spenders; consumed by RP spenders (commonly **0–100** bar).

### Shaman — Maelstrom / Maelstrom Weapon / Mana
- **Elemental:** **Maelstrom** builder–spender (≈ **0–100**). Mana secondary.
- **Enhancement:** **Maelstrom Weapon** **stacks** from procs; spend optimally at **5–10**; **cap 10** stacks. Mana secondary.
- **Restoration:** **Mana** healer pool.

### Druid — Astral Power / Energy+CP / Rage / Mana
- **Balance:** **Astral Power** builder–spender (cap **100**).
- **Feral:** **Energy (100)** + **Combo Points (5 base)** → finishers; talents can push effective finishers beyond 5.
- **Guardian:** **Rage** (cap **100**).
- **Restoration:** **Mana** healer pool.

### Mage — Mana (+ Arcane Charges)
- **Arcane:** **Arcane Charges** (cap **4**) amplify damage and mana costs; coupled with **Mana**.
- **Fire/Frost:** **Mana** only; class‑specific procs/cooldowns drive pacing.

### Warlock — Soul Shards (+ Mana)
- **System:** Fragments → **Soul Shards**; **cap 5 shards (50 fragments)**. Mana as a secondary pool.

### Monk — Energy + Chi / Energy / Mana
- **Windwalker:** **Energy (100)** + **Chi (5; 6 w/Ascension)** builder–spender.
- **Brewmaster:** **Energy (100)**; **Stagger** is mitigation (not a spendable resource).
- **Mistweaver:** **Mana** healer pool.

### Demon Hunter — Fury (+ Soul Fragments for Vengeance)
- **Fury:** builder–spender; **decays OOC**; **cap 100** baseline (**120** with talent like *Unrestrained Fury*).
- **Vengeance:** also uses **Soul Fragments** as a mitigation/heal mechanic.

### Evoker — Essence (+ Mana)
- **Essence:** passive “pip” system; **cap 5** (**6** with talent); baseline regen ~**1 per 5s**.
- **Use:** fuels *Disintegrate/Pyre* (Devastation) and key heals (Preservation). **Mana** coexists as caster pool.

---

## Source Hints (for deeper reading)
- Common guides: **Icy Veins**, **Wowpedia/Warcraft Wiki**, **Wago**, class discords.
- Example anchors from your notes: Icy Veins; Wowpedia/Wowpedia‑Fandom; warcraft.wiki.gg; wago.io.

---

## Next steps (optional)
- **BG3 translation layer:** map each primary resource to a BG3‑style bar/stack (e.g., Energy/Focus → 0–100; Holy Power/Chi/CP → 5–6 pips; Runes → 6 charges + RP 0–100; Maelstrom Weapon → 0–10 stacks; Essence → 5–6 pips).
- **Caps registry:** maintain a single JSON/YAML that defines per‑spec caps and OOC behaviours (decay, reset, regen rate). Useful for generators.
- **Talent modifiers:** annotate which talents modify caps (e.g., **Unrestrained Fury** to 120; **Ascension** to 6 Chi; **Deeper Stratagem** finishers above 5 CP).
- **Automation hook:** expose the table as CSV/JSON for your blueprint maker so resource rules auto‑populate per spec.



---
## Validation & Renderer Tips
- **Mana as Meter**: Ensure `type:"Meter"`, `cap:100`, add sensible `regen` (healers: perTurn 6; OOC 20; DPS: perTurn 4; OOC 20).
- **Notes at Acquisition**: For every new mechanic (e.g., “Refunds 10 Focus on Crit (cap 10/turn)”), add to `notesAtAcquisition` so §15 Notes prints it on first grant.
- **Subclass Gains Mirror**: Set `uiMirrors.showGainsOnSubclassCards:true` (Section 9) to surface acquisition rules.
- **Anti-cheese**: Use global `enforceGlobalPerTurnGainCap` and event-level `perTurnCap` for On-Hit/On-Tick hooks.

