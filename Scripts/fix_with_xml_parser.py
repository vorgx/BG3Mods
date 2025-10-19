"""
XML-aware fix for Progressions.lsx using proper XML parsing.
This will correctly handle nested structures.
"""

import xml.etree.ElementTree as ET
from pathlib import Path

file_path = Path(r"C:\Users\tenod\source\repos\BG3Mods\Data\Public\BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7\Progressions\Progressions.lsx")

SKILLS_UUID = "f974ebd6-3725-4b90-bb5c-2b647d41615d"
ABILITY_UUID = "b9149c8e-52c8-46e5-9cb6-fc39301c05fe"

print("📖 Loading XML...")
tree = ET.parse(file_path)
root = tree.getroot()

conversions = 0
passive_lists = []

def process_selectors_node(progression_node):
    """Find and convert Selectors nodes within a Progression."""
    global conversions
    
    # Find children node
    children_node = progression_node.find('children')
    if children_node is None:
        return
    
    # Find Selectors node
    selectors_node = children_node.find("node[@id='Selectors']")
    if selectors_node is None:
        return
    
    # Find the children of Selectors
    selectors_children = selectors_node.find('children')
    if selectors_children is None:
        return
    
    # Build selector string parts
    selector_parts = []
    add_spells_value = None
    
    # Process each child node
    for child in list(selectors_children):
        node_id = child.get('id')
        
        if node_id == 'SelectSkills':
            amount_attr = child.find("attribute[@id='Amount']")
            if amount_attr is not None:
                amount = amount_attr.get('value')
                selector_parts.append(f"SelectSkills({SKILLS_UUID},{amount})")
        
        elif node_id == 'SelectAbilityBonus':
            amount_attr = child.find("attribute[@id='Amount']")
            bonus_attr = child.find("attribute[@id='BonusType']")
            if amount_attr is not None and bonus_attr is not None:
                amount = amount_attr.get('value')
                bonus_type = bonus_attr.get('value')
                selector_parts.append(f"SelectAbilityBonus({ABILITY_UUID},AbilityBonus,{amount},{bonus_type})")
        
        elif node_id == 'AddSpells':
            spells_attr = child.find("attribute[@id='Spells']")
            if spells_attr is not None:
                add_spells_value = spells_attr.get('value')
        
        elif node_id == 'SelectPassives':
            # For now, comment these out - they need PassiveList files
            # We'll add a comment and skip them
            print(f"   ⚠️  Skipping SelectPassives (needs PassiveList implementation)")
            continue
    
    # Remove the old Selectors node
    children_node.remove(selectors_node)
    
    # Create new attributes directly in children node
    if selector_parts:
        selector_string = ";".join(selector_parts)
        attr = ET.Element('attribute')
        attr.set('id', 'Selectors')
        attr.set('type', 'LSString')
        attr.set('value', selector_string)
        children_node.append(attr)
    
    if add_spells_value:
        attr = ET.Element('attribute')
        attr.set('id', 'AddSpells')
        attr.set('type', 'LSString')
        attr.set('value', add_spells_value)
        children_node.append(attr)
    
    conversions += 1

# Find all Progression nodes
print("🔄 Processing Progression nodes...")
progressions_root = root.find(".//region[@id='Progressions']/node[@id='root']/children")

if progressions_root is not None:
    for progression in progressions_root.findall("node[@id='Progression']"):
        process_selectors_node(progression)

print(f"✅ Converted {conversions} Selector nodes")

# Save with proper XML formatting
print("💾 Saving...")
tree.write(file_path, encoding='UTF-8', xml_declaration=True)

# Pretty print (add spacing)
content = file_path.read_text(encoding='utf-8')
# ET doesn't preserve formatting well, let's fix indentation
import re

# Add newlines after tags for readability
content = re.sub(r'><', r'>\n<', content)

# Basic indentation (this is rough but better than nothing)
lines = content.split('\n')
formatted = []
indent_level = 0
for line in lines:
    stripped = line.strip()
    if not stripped:
        continue
    
    # Decrease indent for closing tags
    if stripped.startswith('</'):
        indent_level = max(0, indent_level - 1)
    
    formatted.append('    ' * indent_level + stripped)
    
    # Increase indent for opening tags (but not self-closing)
    if stripped.startswith('<') and not stripped.startswith('</') and not stripped.endswith('/>') and not stripped.startswith('<?'):
        indent_level += 1

file_path.write_text('\n'.join(formatted), encoding='utf-8')

print("✅ File saved with formatting")
print("\n" + "="*60)
print("NOTE: SelectPassives nodes were skipped.")
print("      These need PassiveList.lsx files to work properly.")
print("      For now, the mod will work without hero talents.")
print("="*60)
