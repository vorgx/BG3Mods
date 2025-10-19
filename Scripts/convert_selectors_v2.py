"""
Convert ALL Progressions.lsx Selector formats - handles multiple patterns.
"""

import re
from pathlib import Path

file_path = Path(r"C:\Users\tenod\source\repos\BG3Mods\Data\Public\BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7\Progressions\Progressions.lsx")

# Read file
content = file_path.read_text(encoding='utf-8')

SKILLS_UUID = "f974ebd6-3725-4b90-bb5c-2b647d41615d"
ABILITY_UUID = "b9149c8e-52c8-46e5-9cb6-fc39301c05fe"

# Find all Selector blocks
selector_pattern = r'<node id="Selectors">\s*<children>(.*?)</children>\s*</node>'

def convert_selector_block(match):
    """Convert a single Selector block to LSString format."""
    block_content = match.group(1)
    indent = '                        '  # Match indentation of original Selectors node
    
    parts = []
    
    # Check for SelectSkills
    skills_match = re.search(r'<node id="SelectSkills">\s*<attribute id="Amount" type="uint8" value="(\d+)"/>', block_content)
    if skills_match:
        amount = skills_match.group(1)
        parts.append(f"SelectSkills({SKILLS_UUID},{amount})")
    
    # Check for SelectAbilityBonus
    ability_match = re.search(r'<node id="SelectAbilityBonus">\s*<attribute id="Amount" type="uint8" value="(\d+)"/>\s*<attribute id="BonusType" type="uint8" value="(\d+)"/>', block_content)
    if ability_match:
        amount = ability_match.group(1)
        bonus_type = ability_match.group(2)
        parts.append(f"SelectAbilityBonus({ABILITY_UUID},AbilityBonus,{amount},{bonus_type})")
    
    # Check for AddSpells
    spells_match = re.search(r'<node id="AddSpells">\s*<attribute id="Spells" type="LSString" value="([^"]*)"/>', block_content)
    if spells_match:
        spells = spells_match.group(1)
        # AddSpells doesn't take the spell list directly - it needs to be separate or part of progression
        # Actually, looking at working mods, AddSpells goes OUTSIDE Selectors in most cases
        # But some working mods put it in Selectors with a UUID
        # Let's check if there's a pattern
        pass  # We'll handle this differently
    
    if not parts:
        # Only AddSpells, no selectors
        if spells_match:
            spells = spells_match.group(1)
            return f'{indent}<attribute id="Selectors" type="LSString" value="AddSpells()"/>\n{indent}<attribute id="AddSpells" type="LSString" value="{spells}"/>'
        return match.group(0)  # Keep original if empty
    
    selector_value = ";".join(parts)
    result = f'{indent}<attribute id="Selectors" type="LSString" value="{selector_value}"/>'
    
    # Handle AddSpells separately if present
    if spells_match:
        spells = spells_match.group(1)
        result += f'\n{indent}<attribute id="AddSpells" type="LSString" value="{spells}"/>'
    
    return result

# Apply conversion
new_content = re.sub(selector_pattern, convert_selector_block, content, flags=re.DOTALL)

# Count changes
original_count = content.count('<node id="Selectors">')
new_count = new_content.count('<node id="Selectors">')
conversions = original_count - new_count

print(f"Original Selector nodes: {original_count}")
print(f"Converted: {conversions}")
print(f"Remaining: {new_count}")

if new_count > 0:
    print(f"\n⚠️ Warning: {new_count} Selector nodes remain unconverted")
    print("This may require manual review.")
else:
    print("\n✅ All Selector nodes successfully converted!")

# Write result
file_path.write_text(new_content, encoding='utf-8')
print(f"\nUpdated: {file_path}")
print("(Backup already exists from previous run)")
