import re
import xml.etree.ElementTree as ET

# Read the file
with open('Data/Public/BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7/Progressions/Progressions.lsx', 'r', encoding='utf-8') as f:
    content = f.read()

# Parse XML
tree = ET.parse('Data/Public/BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7/Progressions/Progressions.lsx')
root = tree.getroot()

# Find all Progression nodes
progressions_region = root.find('.//region[@id="Progressions"]')
progressions_root = progressions_region.find('node[@id="root"]')
progressions = progressions_root.find('children').findall('node[@id="Progression"]')

print(f"Found {len(progressions)} progression nodes")

fixed_count = 0

for progression in progressions:
    # Check if this progression has a children node with attributes
    children_node = progression.find('children')
    
    if children_node is not None:
        # Find Selectors and AddSpells inside children
        selectors_attr = children_node.find('attribute[@id="Selectors"]')
        addspells_attr = children_node.find('attribute[@id="AddSpells"]')
        
        if selectors_attr is not None or addspells_attr is not None:
            level = progression.find('attribute[@id="Level"]').get('value')
            name = progression.find('attribute[@id="Name"]').get('value')
            print(f"  Fixing Level {level} ({name})")
            
            # Move Selectors to direct child of Progression
            if selectors_attr is not None:
                children_node.remove(selectors_attr)
                # Insert before children node
                insert_index = list(progression).index(children_node)
                progression.insert(insert_index, selectors_attr)
                print(f"    - Moved Selectors attribute")
            
            # Move AddSpells to direct child of Progression
            if addspells_attr is not None:
                children_node.remove(addspells_attr)
                # Insert after other attributes, before children
                insert_index = list(progression).index(children_node)
                progression.insert(insert_index, addspells_attr)
                print(f"    - Moved AddSpells attribute")
            
            fixed_count += 1

print(f"\nFixed {fixed_count} progression nodes")

# Write back to file
tree.write('Data/Public/BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7/Progressions/Progressions.lsx', 
           encoding='UTF-8', 
           xml_declaration=True)

print("\nFile restructured successfully!")
print("Backup created: Progressions_BACKUP.lsx")
