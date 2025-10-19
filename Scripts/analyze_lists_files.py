"""
REPORT: All Lists Files Structure Comparison
"""

import xml.etree.ElementTree as ET

print("=" * 80)
print("REPORT: Lists Folder Files")
print("=" * 80)

WARRIOR_BASE = "Data/Public/BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7/Lists"
WARLOCK_BASE = "Tests/02_ExampleMods/ExampleMod_WoWWarlock/Public/Warlock_WoW_bdb3fa73-401b-4979-f02e-485422dd8d9c/Lists"

files_to_check = [
    ('SkillLists.lsx', 'SkillList', 'Skills'),
    ('SpellLists.lsx', 'SpellList', 'Spells'),
    ('PassiveLists.lsx', 'PassiveList', 'Passives'),
    ('AbilityLists.lsx', 'AbilityList', 'Abilities')
]

for filename, node_id, content_attr in files_to_check:
    print("\n" + "=" * 80)
    print(f"FILE: {filename}")
    print("=" * 80)
    
    # Parse Warlock
    print("\n[REFERENCE: Warlock]")
    warlock_file = f"{WARLOCK_BASE}/{filename}"
    warlock_tree = ET.parse(warlock_file)
    warlock_lists = warlock_tree.findall(f'.//node[@id="{node_id}"]')
    
    print(f"  Total entries: {len(warlock_lists)}")
    if len(warlock_lists) > 0:
        first = warlock_lists[0]
        attrs = [attr.get('id') for attr in first.findall('attribute')]
        print(f"  Attributes: {', '.join(attrs)}")
        
        # Check first entry content
        content = first.find(f'attribute[@id="{content_attr}"]')
        if content is not None:
            value = content.get('value')
            if value:
                items = value.split(';') if ';' in value else value.split(',')
                print(f"  First entry has {len(items)} {content_attr.lower()}")
    
    # Parse Warrior
    print("\n[OUR MOD: Warrior]")
    warrior_file = f"{WARRIOR_BASE}/{filename}"
    warrior_tree = ET.parse(warrior_file)
    warrior_lists = warrior_tree.findall(f'.//node[@id="{node_id}"]')
    
    print(f"  Total entries: {len(warrior_lists)}")
    if len(warrior_lists) > 0:
        first = warrior_lists[0]
        attrs = [attr.get('id') for attr in first.findall('attribute')]
        print(f"  Attributes: {', '.join(attrs)}")
        
        # Check first entry content
        content = first.find(f'attribute[@id="{content_attr}"]')
        if content is not None:
            value = content.get('value')
            if value:
                items = value.split(';') if ';' in value else value.split(',')
                print(f"  First entry has {len(items)} {content_attr.lower()}")
            else:
                print(f"  WARNING: {content_attr} attribute is EMPTY")
        else:
            print(f"  WARNING: No {content_attr} attribute found")
    
    # Comparison
    print("\n[COMPARISON]")
    if len(warlock_lists) > 0 and len(warrior_lists) > 0:
        warlock_attrs = set([attr.get('id') for attr in warlock_lists[0].findall('attribute')])
        warrior_attrs = set([attr.get('id') for attr in warrior_lists[0].findall('attribute')])
        
        missing = warlock_attrs - warrior_attrs
        if missing:
            print(f"  Missing attributes: {missing}")
            print(f"  STATUS: NEEDS RESTRUCTURE (add missing attributes)")
        else:
            # Check if content is empty
            warrior_content = warrior_lists[0].find(f'attribute[@id="{content_attr}"]')
            if warrior_content is None or not warrior_content.get('value'):
                print(f"  STATUS: STRUCTURE OK but {content_attr} is EMPTY")
            else:
                print(f"  STATUS: OK")
    elif len(warrior_lists) == 0:
        print(f"  STATUS: ERROR - No entries found")
    else:
        print(f"  STATUS: OK")

print("\n" + "=" * 80)
print("ALL LISTS FILES ANALYZED")
print("=" * 80)
