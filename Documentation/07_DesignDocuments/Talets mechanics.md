
https://www.wowhead.com/guide/classes/warrior/arms/abilities-talents-pve-dps#arms-talents

Groups
- Class Talents, (10 rows) Contains (Warrior Class Talents) on level 1 you get all from row 1, after that you will continue to pick 1 from the next row every 2nd level up
- SubclassSpec Talents, (10 rows) Contains (Arms Spec Talents) on level 1 you get the passive's and all from row 1, after that you will continue to pick 1 from the next row every 2nd level up
- SubclassBase Talents, (Bucket/group) Contains (Baseline Arms Warrior Abilities) **UPDATE (v2.0):** Changed to auto-granted progression. Each subclass receives the same 12 abilities at different levels to support their unique identity. See Warrior_Class_Blueprint.md for specific level assignments per subclass.
- Specialization, Contains (Colossus Talents) and (Slayer Talents) Choice: at lvl 13 you choose your specialization choose one of the 2 in this group.


- Class Talents, (10 rows) Contains (Warrior Class Talents) 
- SubclassSpec Talents, (10 rows) Contains (Arms Spec Talents) 
- SubclassBase Talents, (Auto-granted) Contains (Baseline Arms Warrior Abilities) **v2.0:** 12 abilities granted at specific levels (L3-L12), different order per subclass
- Specialization, Contains (Colossus Talents) and (Slayer Talents) 2 Groups of Talents, Choose 1 Specialization group at lvl 13


can you convert all of the talents on this link / page to fit BG3 and our new resource mechanics

Groups:
Class Talents(10 rows),
SubclassSpec Talents(10 rows), 
SubclassBase Talents(Bucket/group, Baseline Arms Warrior Abilities), 
Specialization,         "lists": {
                                    "KEY_TALENT":   "LIST_SPEC_KEY_TALENT",     // exactly one item; grant at L13
                                    "CAPSTONE":     "LIST_SPEC_CAPSTONE",       // exactly one item; grant at L13
                                    "CHOICE_NODE_1":"LIST_SPEC_CHOICES_1",      // 3 options; pick 1 at L15
                                    "CHOICE_NODE_2":"LIST_SPEC_CHOICES_2",      // 3 options; pick 1 at L17
                                    "CHOICE_NODE_3":"LIST_SPEC_CHOICES_3",      // 3 options; pick 1 at L19
                                    "PASSIVES":     "LIST_SPEC_PASSIVES"        // many; 1 each level L13→L20 until exhausted
                                },

specializations work like this, they have 4 groups: 
(Key Talent) - Unique ability for the Specialization unlocked at lvl 13.
(Capstone Talent) - unlocked on lvl 15 (Choice Nodes) - 3 groups of 3 talents,  choose 1 from each group, 1 on lvl 15, 17 and 19, only the 3 for that tier should be able(3 talents) are availabale at selection.
(specialization_Passives),  1 each level from level 13 to 20 or until they run out.



## Authoring (drop-in JSON — generic with tips in empties)

```json
{
  "catalog": {
    "policy": {
      "namespace": "VORGX",
      "notes": "TIP — Keep list contents scoped: Class vs Subclass; avoid mixing keys across families."
    },

    "groups": {
      "CLASS_TALENTS": {
        "rows": 10,
        "rowKeys": [
          "LIST_CLASS_TALENTS_ROW_1","LIST_CLASS_TALENTS_ROW_2","LIST_CLASS_TALENTS_ROW_3",
          "LIST_CLASS_TALENTS_ROW_4","LIST_CLASS_TALENTS_ROW_5","LIST_CLASS_TALENTS_ROW_6",
          "LIST_CLASS_TALENTS_ROW_7","LIST_CLASS_TALENTS_ROW_8","LIST_CLASS_TALENTS_ROW_9",
          "LIST_CLASS_TALENTS_ROW_10"
        ],
        "ui": { "labelToken": "h_LIST_CLASS_TALENTS", "rowLabelPattern": "h_LIST_CLASS_TALENTS_ROW_${n}" },
        "notes": "Row 1 is granted at L1; thereafter pick 1 from the next row every 2 levels (see §14 cadence)."
      },

      "SUBCLASSSPEC_TALENTS": {
        "rows": 10,
        "rowKeys": [
          "LIST_SUBCLASSSPEC_ROW_1","LIST_SUBCLASSSPEC_ROW_2","LIST_SUBCLASSSPEC_ROW_3",
          "LIST_SUBCLASSSPEC_ROW_4","LIST_SUBCLASSSPEC_ROW_5","LIST_SUBCLASSSPEC_ROW_6",
          "LIST_SUBCLASSSPEC_ROW_7","LIST_SUBCLASSSPEC_ROW_8","LIST_SUBCLASSSPEC_ROW_9",
          "LIST_SUBCLASSSPEC_ROW_10"
        ],
        "optionals": ["LIST_SUBCLASSSPEC_PASSIVES_ROW_1"],
        "ui": { "labelToken": "h_LIST_SUBCLASSSPEC_TALENTS", "rowLabelPattern": "h_LIST_SUBCLASSSPEC_ROW_${n}" },
        "notes": "Subclass-scoped 10-row ladder; optional passive row for baseline subclass passives."
      },

      "SUBCLASSBASE": {
        "bucket": false,
        "autoGranted": true,
        "lists": {
          "arms": "LIST_SUBCLASSBASE_ARMS",
          "fury": "LIST_SUBCLASSBASE_FURY",
          "protection": "LIST_SUBCLASSBASE_PROTECTION"
        },
        "ui": { "armsToken": "h_LIST_SUBCLASSBASE_ARMS", "furyToken": "h_LIST_SUBCLASSBASE_FURY", "protectionToken": "h_LIST_SUBCLASSBASE_PROTECTION" },
        "notes": "v2.0 UPDATE: Changed from bucket system to auto-granted progression. 12 abilities granted at specific levels (L3-L12). Each subclass receives same abilities but in different order to support unique identity. See Warrior_Class_Blueprint.md for level assignments."
      },

      "SPECIALIZATION": {
        "lists": {
          "keyTalent": "LIST_SPEC_KEY_TALENT",
          "capstone": "LIST_SPEC_CAPSTONE",
          "choices1": "LIST_SPEC_CHOICES_1",
          "choices2": "LIST_SPEC_CHOICES_2",
          "choices3": "LIST_SPEC_CHOICES_3",
          "passives": "LIST_SPEC_PASSIVES"
        },
        "ui": { "labelToken": "h_LIST_SPECIALIZATION" },
        "notes": "Unlocked at L13 (Tier III). Key + Capstone + Choices_1 at 13; Choices_2 at 15; Choices_3 at 18; Passives each level 13→20."
      }
    },

    "lists": [
      {
        "key": "LIST_CLASS_TALENTS_ROW_1",
        "appliesTo": "CLASS",
        "entries": [
          /* keys from §5.actions/passives OR §7.actions/passives; keep same-scope content */
        ],
        "tags": ["Flavor:Steel"],
        "loc": { "titleToken": "h_LIST_CLASS_TALENTS_ROW_1", "descToken": "d_LIST_CLASS_TALENTS_ROW_1" },
        "notes": "TIP — Homogeneous row themes aid choice clarity (e.g., mobility row)."
      },

      {
        "key": "LIST_SUBCLASSSPEC_ROW_1",
        "appliesTo": "SUBCLASS",
        "entries": [],
        "tags": [],
        "loc": { "titleToken": "h_LIST_SUBCLASSSPEC_ROW_1", "descToken": "d_LIST_SUBCLASSSPEC_ROW_1" }
      },

      {
        "key": "LIST_SUBCLASSBASE_OFFENSE",
        "appliesTo": "SUBCLASS",
        "entries": [],
        "constraints": { "category": ["Action","Spell"], "identity": ["Aggro","Execute","Ranged","Pet"], "min": 0, "max": 999 },
        "loc": { "titleToken": "h_LIST_SUBCLASSBASE_OFFENSE", "descToken": "d_LIST_SUBCLASSBASE_OFFENSE" }
      },

      {
        "key": "LIST_SUBCLASSBASE_UTILITY",
        "appliesTo": "SUBCLASS",
        "entries": [],
        "constraints": { "category": ["Action","Passive","Aura","Stance"], "utility": ["Cleanse","Dispel","MovementBuff","DefenseBuff","Heal","TempHP"], "min": 0, "max": 999 },
        "loc": { "titleToken": "h_LIST_SUBCLASSBASE_UTILITY", "descToken": "d_LIST_SUBCLASSBASE_UTILITY" }
      },

      {
        "key": "LIST_SUBCLASSBASE_ALL",
        "appliesTo": "SUBCLASS",
        "derivedFrom": ["LIST_SUBCLASSBASE_OFFENSE","LIST_SUBCLASSBASE_UTILITY"],
        "entries": [],
        "loc": { "titleToken": "h_LIST_SUBCLASSBASE_ALL" },
        "notes": "TIP — Keep this auto-synced as the union of Offense/Utility."
      },

      { "key": "LIST_SPEC_KEY_TALENT",   "appliesTo": "SUBCLASS", "entries": [], "loc": { "titleToken": "h_LIST_SPEC_KEY_TALENT" } },
      { "key": "LIST_SPEC_CAPSTONE",     "appliesTo": "SUBCLASS", "entries": [], "loc": { "titleToken": "h_LIST_SPEC_CAPSTONE" } },
      { "key": "LIST_SPEC_CHOICES_1",    "appliesTo": "SUBCLASS", "entries": [], "loc": { "titleToken": "h_LIST_SPEC_CHOICES_1" } },
      { "key": "LIST_SPEC_CHOICES_2",    "appliesTo": "SUBCLASS", "entries": [], "loc": { "titleToken": "h_LIST_SPEC_CHOICES_2" } },
      { "key": "LIST_SPEC_CHOICES_3",    "appliesTo": "SUBCLASS", "entries": [], "loc": { "titleToken": "h_LIST_SPEC_CHOICES_3" } },
      { "key": "LIST_SPEC_PASSIVES",     "appliesTo": "SUBCLASS", "entries": [], "loc": { "titleToken": "h_LIST_SPEC_PASSIVES" }, "notes": "One passive per level L13→20 or until exhausted." }
    ]
  }
}
```

Class Talents (Class Talents), Contains (Warrior Class Talents) 
Subclass Spec Talents (SubclassSpec Talents) Contains (Arms Spec Talents) 
Subclass Base Talents (SubclassBase Talents) Contains (Baseline Arms Warrior Abilities) 
Specialization (Specialization), Contains (Colossus Talents) and (Slayer Talents) 2 Groups of Talents, Choose 1 Specialization group at lvl 13
