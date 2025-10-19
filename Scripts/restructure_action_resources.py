"""
Fix ActionResourceDefinitions.lsx structure
Compare with Warlock and ensure proper format
"""

import xml.etree.ElementTree as ET

print("=" * 80)
print("RESTRUCTURE: ActionResourceDefinitions.lsx")
print("=" * 80)

WARRIOR_FILE = "Data/Public/BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7/ActionResourceDefinitions/ActionResourceDefinitions.lsx"
WARLOCK_FILE = "Tests/02_ExampleMods/ExampleMod_WoWWarlock/Public/Warlock_WoW_bdb3fa73-401b-4979-f02e-485422dd8d9c/ActionResourceDefinitions/ActionResourceDefinitions.lsx"

# Parse Warlock
print("\nWarlock structure (reference):")
warlock_tree = ET.parse(WARLOCK_FILE)
warlock_root = warlock_tree.getroot()
warlock_resources = warlock_root.findall('.//node[@id="ActionResource"]')

print(f"  Found {len(warlock_resources)} resources")
if len(warlock_resources) > 0:
    first = warlock_resources[0]
    name = first.find('attribute[@id="Name"]')
    print(f"  First resource: {name.get('value') if name is not None else 'Unknown'}")
    
    # Check attribute order
    print("  Attribute order:")
    for attr in first.findall('attribute'):
        print(f"    - {attr.get('id')}: {attr.get('type')}")

# Parse Warrior
print("\nWarrior structure:")
warrior_tree = ET.parse(WARRIOR_FILE)
warrior_root = warrior_tree.getroot()
warrior_resources = warrior_root.findall('.//node[@id="ActionResource"]')

print(f"  Found {len(warrior_resources)} resources")
if len(warrior_resources) > 0:
    first = warrior_resources[0]
    name = first.find('attribute[@id="Name"]')
    print(f"  Resource: {name.get('value') if name is not None else 'Unknown'}")
    
    # Check attribute order
    print("  Attribute order:")
    for attr in first.findall('attribute'):
        print(f"    - {attr.get('id')}: {attr.get('type')}")
    
    # Compare attributes
    warlock_attrs = set([attr.get('id') for attr in warlock_resources[0].findall('attribute')])
    warrior_attrs = set([attr.get('id') for attr in first.findall('attribute')])
    
    missing = warlock_attrs - warrior_attrs
    extra = warrior_attrs - warlock_attrs
    
    if missing:
        print(f"\n  Missing attributes (in Warlock but not Warrior): {missing}")
    if extra:
        print(f"  Extra attributes (in Warrior but not Warlock): {extra}")
    
    if not missing and not extra:
        print("\n  STATUS: IDENTICAL structure - No changes needed")
    else:
        print("\n  STATUS: Different structure - May need adjustment")
else:
    print("  ERROR: No resources found!")

print("\n" + "=" * 80)
print("ANALYSIS COMPLETE")
print("=" * 80)
