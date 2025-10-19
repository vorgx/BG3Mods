"""
Convert Progressions.lsx Selector format from nested XML nodes to LSString format.

BG3 requires Selectors in this format:
<attribute id="Selectors" type="LSString" value="SelectSkills(UUID,2);SelectAbilityBonus(UUID,AbilityBonus,2,1)"/>

Current file has nested nodes like:
<node id="Selectors">
    <children>
        <node id="SelectSkills">
            <attribute id="Amount" type="uint8" value="2"/>
            <attribute id="SkillsList" type="guid" value="f974ebd6-3725-4b90-bb5c-2b647d41615d"/>
        </node>
        <node id="SelectAbilityBonus">
            <attribute id="Amount" type="uint8" value="2"/>
            <attribute id="BonusType" type="uint8" value="1"/>
        </node>
"""

import re
from pathlib import Path

# File path
file_path = Path(r"C:\Users\tenod\source\repos\BG3Mods\Data\Public\BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7\Progressions\Progressions.lsx")

# Read file
content = file_path.read_text(encoding='utf-8')

# UUIDs
SKILLS_UUID = "f974ebd6-3725-4b90-bb5c-2b647d41615d"
ABILITY_UUID = "b9149c8e-52c8-46e5-9cb6-fc39301c05fe"  # Standard shared UUID

# Pattern to match entire Selectors node block
pattern = r'(\s*)<node id="Selectors">\s*<children>\s*<node id="SelectSkills">\s*<attribute id="Amount" type="uint8" value="(\d+)"/>\s*<attribute id="SkillsList" type="guid" value="[^"]*"/>\s*<attribute id="UUID" type="guid" value="[^"]*"/>\s*</node>\s*<node id="SelectAbilityBonus">\s*<attribute id="Amount" type="uint8" value="(\d+)"/>\s*<attribute id="BonusType" type="uint8" value="(\d+)"/>\s*<attribute id="UUID" type="guid" value="[^"]*"/>\s*</node>\s*(?:<node id="AddSpells">\s*<attribute id="Spells" type="LSString" value="([^"]*)"/>\s*<attribute id="UUID" type="guid" value="[^"]*"/>\s*</node>\s*)?</children>\s*</node>'

def replace_selector(match):
    indent = match.group(1)
    skills_amount = match.group(2)
    ability_amount = match.group(3)
    ability_bonus_type = match.group(4)
    add_spells = match.group(5) if match.group(5) else None
    
    # Build selector string
    selector_parts = [
        f"SelectSkills({SKILLS_UUID},{skills_amount})",
        f"SelectAbilityBonus({ABILITY_UUID},AbilityBonus,{ability_amount},{ability_bonus_type})"
    ]
    
    if add_spells:
        selector_parts.append(f"AddSpells({add_spells})")
    
    selector_value = ";".join(selector_parts)
    
    return f'{indent}<attribute id="Selectors" type="LSString" value="{selector_value}"/>'

# Apply replacement
new_content = re.sub(pattern, replace_selector, content, flags=re.DOTALL)

# Count replacements
original_count = content.count('<node id="Selectors">')
new_count = new_content.count('<node id="Selectors">')
replacements = original_count - new_count

print(f"Found {original_count} Selector nodes")
print(f"Replaced {replacements} instances")
print(f"Remaining nested Selectors: {new_count}")

# Write backup
backup_path = file_path.with_suffix('.lsx.backup')
backup_path.write_text(content, encoding='utf-8')
print(f"\nBackup created: {backup_path}")

# Write new file
file_path.write_text(new_content, encoding='utf-8')
print(f"Updated: {file_path}")
print("\n✅ Conversion complete!")
