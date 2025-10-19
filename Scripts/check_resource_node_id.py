"""
REPORT: ActionResourceDefinitions.lsx Structure Comparison
"""

import xml.etree.ElementTree as ET

print("=" * 80)
print("REPORT: ActionResourceDefinitions.lsx")
print("=" * 80)

WARRIOR_FILE = "Data/Public/BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7/ActionResourceDefinitions/ActionResourceDefinitions.lsx"
WARLOCK_FILE = "Tests/02_ExampleMods/ExampleMod_WoWWarlock/Public/Warlock_WoW_bdb3fa73-401b-4979-f02e-485422dd8d9c/ActionResourceDefinitions/ActionResourceDefinitions.lsx"

# Parse Warlock
print("\n[REFERENCE: Warlock]")
warlock_tree = ET.parse(WARLOCK_FILE)
warlock_root = warlock_tree.getroot()
warlock_resources = warlock_root.findall('.//node[@id="ActionResourceDefinition"]')

print(f"  Node ID used: 'ActionResourceDefinition'")
print(f"  Total resources: {len(warlock_resources)}")

if len(warlock_resources) > 0:
    first = warlock_resources[0]
    name_attr = first.find('attribute[@id="Name"]')
    print(f"  First resource: {name_attr.get('value')}")
    
    attrs = [attr.get('id') for attr in first.findall('attribute')]
    print(f"  Attributes: {', '.join(attrs)}")

# Parse Warrior
print("\n[OUR MOD: Warrior]")
warrior_tree = ET.parse(WARRIOR_FILE)
warrior_root = warrior_tree.getroot()

# Try both node IDs
warrior_resources_old = warrior_root.findall('.//node[@id="ActionResource"]')
warrior_resources_new = warrior_root.findall('.//node[@id="ActionResourceDefinition"]')

if len(warrior_resources_old) > 0:
    print(f"  Node ID used: 'ActionResource' (WRONG - should be ActionResourceDefinition)")
    print(f"  Total resources: {len(warrior_resources_old)}")
    resources = warrior_resources_old
    needs_fix = True
elif len(warrior_resources_new) > 0:
    print(f"  Node ID used: 'ActionResourceDefinition' (CORRECT)")
    print(f"  Total resources: {len(warrior_resources_new)}")
    resources = warrior_resources_new
    needs_fix = False
else:
    print(f"  ERROR: No resources found!")
    resources = []
    needs_fix = True

if len(resources) > 0:
    first = resources[0]
    name_attr = first.find('attribute[@id="Name"]')
    print(f"  Resource: {name_attr.get('value')}")
    
    attrs = [attr.get('id') for attr in first.findall('attribute')]
    print(f"  Attributes: {', '.join(attrs)}")

# Decision
print("\n" + "=" * 80)
if needs_fix:
    print("STATUS: NEEDS RESTRUCTURE")
    print("  Issue: Node ID is 'ActionResource' instead of 'ActionResourceDefinition'")
    print("  Action: Change node id attribute")
else:
    print("STATUS: OK - No changes needed")
print("=" * 80)
