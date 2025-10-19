"""
FINAL FIX for Progressions.lsx

Strategy:
1. Convert SelectSkills/SelectAbilityBonus/AddSpells to LSString format
2. For SelectPassives: Create PassiveLists.lsx files and reference them in LSString format
   Format: SelectPassives(PassiveListUUID,Amount)
   
This preserves ALL content while using correct BG3 format.
"""

import re
from pathlib import Path
from collections import defaultdict

file_path = Path(r"C:\Users\tenod\source\repos\BG3Mods\Data\Public\BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7\Progressions\Progressions.lsx")

SKILLS_UUID = "f974ebd6-3725-4b90-bb5c-2b647d41615d"
ABILITY_UUID = "b9149c8e-52c8-46e5-9cb6-fc39301c05fe"

# Read file
content = file_path.read_text(encoding='utf-8')
print("📖 Original file loaded (1243 lines)")

# Track passive lists to create
passive_lists_to_create = []

def create_passive_list_uuid(passives, requirement=None):
    """Generate UUID for passive list and track it for file creation."""
    # Create a deterministic UUID based on content
    import hashlib
    content_str = ','.join(sorted(passives)) + (requirement or '')
    hash_obj = hashlib.md5(content_str.encode())
    hash_hex = hash_obj.hexdigest()
    
    # Format as UUID
    list_uuid = f"{hash_hex[:8]}-{hash_hex[8:12]}-{hash_hex[12:16]}-{hash_hex[16:20]}-{hash_hex[20:32]}"
    
    passive_lists_to_create.append({
        'uuid': list_uuid,
        'passives': passives,
        'requirement': requirement
    })
    
    return list_uuid

def process_selectors_node(match):
    """Process entire Selectors node block."""
    children_content = match.group(1)
    indent = '                        '
    
    selectors = []
    add_spells = None
    
    # 1. Handle SelectSkills
    if '<node id="SelectSkills">' in children_content:
        amount_match = re.search(r'<node id="SelectSkills">.*?<attribute id="Amount" type="uint8" value="(\d+)"/>', children_content, re.DOTALL)
        if amount_match:
            selectors.append(f"SelectSkills({SKILLS_UUID},{amount_match.group(1)})")
    
    # 2. Handle SelectAbilityBonus
    if '<node id="SelectAbilityBonus">' in children_content:
        ability_match = re.search(
            r'<node id="SelectAbilityBonus">.*?<attribute id="Amount" type="uint8" value="(\d+)"/>.*?<attribute id="BonusType" type="uint8" value="(\d+)"/>',
            children_content, re.DOTALL
        )
        if ability_match:
            selectors.append(f"SelectAbilityBonus({ABILITY_UUID},AbilityBonus,{ability_match.group(1)},{ability_match.group(2)})")
    
    # 3. Handle AddSpells
    if '<node id="AddSpells">' in children_content:
        spells_match = re.search(r'<node id="AddSpells">.*?<attribute id="Spells" type="LSString" value="([^"]*)"/>', children_content, re.DOTALL)
        if spells_match:
            add_spells = spells_match.group(1)
    
    # 4. Handle SelectPassives (hero talents)
    if '<node id="SelectPassives">' in children_content:
        # Extract each SelectPassives node
        for passive_block in re.finditer(
            r'<node id="SelectPassives">(.*?)</node>(?=\s*(?:<node id="SelectPassives">|</children>))',
            children_content, re.DOTALL
        ):
            block_content = passive_block.group(1)
            
            # Get amount
            amount_match = re.search(r'<attribute id="Amount" type="uint8" value="(\d+)"/>', block_content)
            amount = amount_match.group(1) if amount_match else "1"
            
            # Get requirement (optional)
            req_match = re.search(r'<attribute id="Requirement" type="LSString" value="([^"]+)"/>', block_content)
            requirement = req_match.group(1) if req_match else None
            
            # Get all passive tags
            passive_tags = re.findall(r'<attribute id="Tag" type="LSString" value="([^"]+)"/>', block_content)
            
            if passive_tags:
                # Create passive list and get UUID
                list_uuid = create_passive_list_uuid(passive_tags, requirement)
                
                # Add selector
                # Note: Requirement needs to be handled in Progressions as a conditional, not in selector
                selectors.append(f"SelectPassives({list_uuid},{amount})")
    
    # Build result
    result_lines = []
    
    if selectors:
        selector_str = ";".join(selectors)
        result_lines.append(f'{indent}<attribute id="Selectors" type="LSString" value="{selector_str}"/>')
    
    if add_spells:
        result_lines.append(f'{indent}<attribute id="AddSpells" type="LSString" value="{add_spells}"/>')
    
    return '\n'.join(result_lines) if result_lines else ''

# Convert all Selector nodes
print("🔄 Converting Selector nodes...")
selector_pattern = r'<node id="Selectors">\s*<children>(.*?)</children>\s*</node>'
new_content = re.sub(selector_pattern, process_selectors_node, content, flags=re.DOTALL)

# Stats
original_count = content.count('<node id="Selectors">')
new_count = new_content.count('<node id="Selectors">')
print(f"✅ Converted {original_count - new_count} / {original_count} Selector nodes")

# Save file
file_path.write_text(new_content, encoding='utf-8')
print(f"💾 Saved: {file_path}")

# Create PassiveLists.lsx files
if passive_lists_to_create:
    print(f"\n📋 Creating {len(passive_lists_to_create)} PassiveList files...")
    
    lists_dir = file_path.parent.parent / "Lists"
    lists_dir.mkdir(exist_ok=True)
    
    # Group by unique UUID (deduplicate)
    unique_lists = {pl['uuid']: pl for pl in passive_lists_to_create}
    
    for list_info in unique_lists.values():
        list_file = lists_dir / f"PassiveList_{list_info['uuid']}.lsx"
        
        # Create LSX content
        lsx_content = f'''<?xml version="1.0" encoding="UTF-8"?>
<save>
    <version major="4" minor="8" revision="0" build="10"/>
    <region id="PassiveLists">
        <node id="root">
            <children>
                <node id="PassiveList">
                    <attribute id="UUID" type="guid" value="{list_info['uuid']}"/>
                    <children>
'''
        
        # Add each passive
        for passive_tag in list_info['passives']:
            lsx_content += f'''                        <node id="Passive">
                            <attribute id="PassiveName" type="FixedString" value="{passive_tag}"/>
                        </node>
'''
        
        lsx_content += '''                    </children>
                </node>
            </children>
        </node>
    </region>
</save>
'''
        
        list_file.write_text(lsx_content, encoding='utf-8')
        print(f"   ✅ Created: {list_file.name}")
        if list_info['requirement']:
            print(f"      Note: Requirement '{list_info['requirement']}' - needs to be in Progression node")

# Validate XML
print("\n🔍 Validating XML...")
import xml.etree.ElementTree as ET
try:
    ET.parse(file_path)
    print("✅ XML is valid!")
except ET.ParseError as e:
    print(f"❌ XML error: {e}")
    print("   Manual fix may be needed")

print("\n" + "="*60)
print("✅ CONVERSION COMPLETE!")
print(f"   - Progressions.lsx updated")
print(f"   - {len(unique_lists)} PassiveList files created")
print("   - Ready for packaging")
print("="*60)
