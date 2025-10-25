# ability_id Naming Convention

**Last Updated**: October 23, 2025  
**Status**: ✅ **ENFORCED** (176 violations fixed)

---

## Naming Rules

### ✅ **Correct Format**: `WAR_Word1_Word2_Word3`

**Pattern**:
- **Prefix**: Always `WAR_` (all caps)
- **Words**: Capitalized first letter, separated by **single underscore**
- **No trailing underscores**
- **No double underscores**

**Examples**:
```
✅ WAR_Crashing_Thunder
✅ WAR_Lightning_Strikes
✅ WAR_Shield_Slam
✅ WAR_Heroic_Leap
✅ WAR_Mortal_Strike
```

---

## Special Cases

### Possessive ('s)

**Rule**: Use lowercase `s` for possessive apostrophe

**Examples**:
```
✅ WAR_Slayer_s_Dominance  (Slayer's Dominance)
✅ WAR_Titan_s_Grip        (Titan's Grip)
✅ WAR_Champion_s_Spear    (Champion's Spear)
✅ WAR_Berserker_s_Torment (Berserker's Torment)
✅ WAR_Odyn_s_Fury         (Odyn's Fury)
```

### Small Words (articles, prepositions, conjunctions)

**Rule**: Keep lowercase for small words in the middle of multi-word names

**Examples**:
```
✅ WAR_Keep_your_feet_on_the_Ground  ("your", "on", "the" lowercase)
✅ WAR_Mountain_of_Muscle_and_Scars  ("of", "and" lowercase)
✅ WAR_Strength_of_the_Mountain      ("of", "the" lowercase)
✅ WAR_Armored_to_the_Teeth          ("to", "the" lowercase)
✅ WAR_Die_by_the_Sword              ("by", "the" lowercase)
✅ WAR_In_For_The_Kill               ("For", "The" capitalized for emphasis)
```

**Lowercase words**: `s`, `of`, `the`, `and`, `your`, `on`, `to`, `in`, `for`, `by`, `a`, `an`, `or`

---

## Common Violations (FIXED)

### ❌ **Double Underscores**

**Wrong**: `WAR__Whirlwind_`  
**Correct**: `WAR_Whirlwind`

**Wrong**: `WAR__Shield_Slam_`  
**Correct**: `WAR_Shield_Slam`

---

### ❌ **Trailing Underscores**

**Wrong**: `WAR_Charge_`  
**Correct**: `WAR_Charge`

**Wrong**: `WAR_Execute_`  
**Correct**: `WAR_Execute`

---

### ❌ **Lowercase After Underscore**

**Wrong**: `WAR_lightning_strikes`  
**Correct**: `WAR_Lightning_Strikes`

**Wrong**: `WAR_crashing_thunder`  
**Correct**: `WAR_Crashing_Thunder`

**Wrong**: `WAR_brutal_finish`  
**Correct**: `WAR_Brutal_Finish`

---

## Validation Script

```powershell
# Check for naming violations in database
$DbPath = "C:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\AbilityDatabase_Warrior_FullyEnriched.csv"
$Db = Import-Csv $DbPath -Encoding UTF8

$Violations = @()

foreach ($ability in $Db) {
    $id = $ability.ability_id
    $issues = @()
    
    # Check for double underscores
    if ($id -match '__') {
        $issues += "Double underscore (__)"
    }
    
    # Check for trailing underscore
    if ($id -match '_$') {
        $issues += "Trailing underscore"
    }
    
    # Check for lowercase after underscore (except small words)
    if ($id -match '_[a-z]') {
        if ($id -notmatch '_s_|_of_|_the_|_and_|_your_|_on_|_to_|_in_|_for_|_by_|_a_|_an_|_or_') {
            $issues += "Lowercase after underscore"
        }
    }
    
    if ($issues.Count -gt 0) {
        $Violations += [PSCustomObject]@{
            ability_id = $id
            ability_name = $ability.ability_name
            issues = $issues -join ', '
        }
    }
}

if ($Violations.Count -eq 0) {
    Write-Host "[SUCCESS] All ability_id follow naming convention!" -ForegroundColor Green
} else {
    Write-Host "[WARNING] Found $($Violations.Count) violations" -ForegroundColor Red
    $Violations | Format-Table -AutoSize
}
```

**Expected Output** (after Oct 23, 2025 fixes):
```
[SUCCESS] All ability_id follow naming convention!
```

---

## Fix History

### October 23, 2025 - Mass Cleanup

**Violations Found**: 209 abilities with naming issues  
**Fixes Applied**: 176 ability_id corrected

**Backup Created**: `AbilityDatabase_Warrior_FullyEnriched_BACKUP_BEFORE_NAMING_FIX_20251023_175657.csv`

**Fix Pattern**:
1. Remove double underscores (`__` → `_`)
2. Remove trailing underscores (`_$` → ``)
3. Capitalize words after underscores (except small words)

**Sample Fixes**:
| Old | New |
|-----|-----|
| `WAR__Whirlwind_` | `WAR_Whirlwind` |
| `WAR__Shield_Slam_` | `WAR_Shield_Slam` |
| `WAR__Execute_` | `WAR_Execute` |
| `WAR__Mortal_Strike_` | `WAR_Mortal_Strike` |
| `WAR_Grant_Extra_Attack` | `WAR_Grant_Extra_Attack` (no change - already correct) |

---

## Integration with Other Systems

### Progression CSV (LINKED - Main.csv)

**Format in CSV**: `Display Name - ability_id`

**Examples**:
```csv
"Crashing Thunder - WAR_Crashing_Thunder"
"Lightning Strikes - WAR_Lightning_Strikes"
"Shield Slam - WAR_Shield_Slam"
```

**⚠️ CRITICAL**: ability_id in CSV must match database exactly (case-sensitive)

### Stat Files (Data/Public/.../Stats/Generated/Data/)

**Entry Names**: Use ability_id directly (without `WAR_` prefix in some cases, but keep for consistency)

**Example** (`Spell_Target.txt`):
```
new entry "Target_WAR_Execute"
type "SpellData"
data "SpellProperties" "..."
```

**Pattern**: `{SpellType}_{ability_id}` (e.g., `Target_WAR_Execute`, `Shout_WAR_Battle_Shout`)

---

## Change Log

| Date | Change | Reason |
|------|--------|--------|
| Oct 23, 2025 | Mass cleanup: 176 ability_id fixed (double underscores, trailing underscores, incorrect casing) | User request - consistency enforcement, screenshots showed violations |
| Oct 23, 2025 | Document created with naming rules, validation script, fix history | User request - "document the structure" after seeing screenshot with inconsistencies |

---

## Enforcement

**Status**: ✅ **Active Enforcement**

**Validation**: Run validation script before any commit to ensure compliance

**New Abilities**: Always follow naming convention when adding new ability_id

**Small Word List**: Update if new small words discovered (e.g., "with", "from")
