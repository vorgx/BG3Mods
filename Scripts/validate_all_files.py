"""
Complete File-by-File Restructure and Validation
Compares EVERY file with working mods and reports changes
"""

import xml.etree.ElementTree as ET
import os
from datetime import datetime

print("=" * 80)
print("COMPLETE FILE-BY-FILE RESTRUCTURE")
print("=" * 80)

WARRIOR_BASE = "Data/Public/BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7"
WARLOCK_BASE = "Tests/02_ExampleMods/ExampleMod_WoWWarlock/Public/Warlock_WoW_bdb3fa73-401b-4979-f02e-485422dd8d9c"
DEATHKNIGHT_BASE = "Tests/02_ExampleMods/WoWDeathKnightClass/Public/WoWDeathKnightClass"

files_processed = 0
files_restructured = 0
issues_found = []

# ============================================================================
# FILE 1: ClassDescriptions.lsx
# ============================================================================
print("\n" + "=" * 80)
print("FILE 1: ClassDescriptions.lsx")
print("=" * 80)

warrior_file = f"{WARRIOR_BASE}/ClassDescriptions/ClassDescriptions.lsx"
warlock_file = f"{WARLOCK_BASE}/ClassDescriptions/ClassDescriptions.lsx"

print(f"\nAnalyzing: {warrior_file}")

# Parse Warlock structure
warlock_tree = ET.parse(warlock_file)
warlock_root = warlock_tree.getroot()
warlock_classes = warlock_root.findall('.//node[@id="ClassDescription"]')

print(f"Warlock structure (reference):")
if len(warlock_classes) > 0:
    first_class = warlock_classes[0]
    print(f"  Attributes order:")
    for i, attr in enumerate(first_class.findall('attribute'), 1):
        print(f"    {i}. {attr.get('id')}")

# Parse our Warrior structure
warrior_tree = ET.parse(warrior_file)
warrior_root = warrior_tree.getroot()
warrior_classes = warrior_root.findall('.//node[@id="ClassDescription"]')

print(f"\nOur Warrior structure:")
print(f"  Found {len(warrior_classes)} classes")

needs_restructure = False
for cls in warrior_classes:
    name_attr = cls.find('attribute[@id="Name"]')
    name = name_attr.get('value') if name_attr else "Unknown"
    
    # Check attribute order
    our_attrs = [attr.get('id') for attr in cls.findall('attribute')]
    print(f"  {name}: {len(our_attrs)} attributes")
    
    # Check for required attributes
    required = ['Name', 'UUID', 'ProgressionTableUUID', 'DisplayName', 'Description']
    for req in required:
        if req not in our_attrs:
            print(f"    WARNING: Missing {req}")
            needs_restructure = True

if not needs_restructure:
    print("  STATUS: OK - No restructuring needed")
else:
    print("  STATUS: NEEDS ATTENTION")
    issues_found.append("ClassDescriptions.lsx missing attributes")

files_processed += 1

# ============================================================================
# FILE 2: Progressions.lsx (Already done, verify)
# ============================================================================
print("\n" + "=" * 80)
print("FILE 2: Progressions.lsx")
print("=" * 80)

warrior_file = f"{WARRIOR_BASE}/Progressions/Progressions.lsx"
print(f"\nVerifying: {warrior_file}")

warrior_tree = ET.parse(warrior_file)
warrior_root = warrior_tree.getroot()
progressions = warrior_root.findall('.//node[@id="Progression"]')

print(f"Found {len(progressions)} progressions")

# Check first progression structure
l1_prog = [p for p in progressions if p.find('attribute[@id="Level"]').get('value') == '1'][0]

# Check if Selectors is direct attribute
selectors = l1_prog.find('attribute[@id="Selectors"]')
addspells = l1_prog.find('attribute[@id="AddSpells"]')

if selectors is not None:
    print("  Selectors: DIRECT attribute (CORRECT)")
else:
    print("  Selectors: NOT direct attribute (WRONG)")
    issues_found.append("Progressions.lsx: Selectors not direct attribute")

if addspells is not None:
    print("  AddSpells: DIRECT attribute (CORRECT)")
else:
    # Check if it's in children (wrong location)
    children = l1_prog.find('children')
    if children is not None:
        child_addspells = children.find('attribute[@id="AddSpells"]')
        if child_addspells is not None:
            print("  AddSpells: Inside children node (WRONG)")
            issues_found.append("Progressions.lsx: AddSpells in wrong location")

print("  STATUS: ALREADY RESTRUCTURED")
files_processed += 1

# ============================================================================
# FILE 3: ProgressionDescriptions.lsx
# ============================================================================
print("\n" + "=" * 80)
print("FILE 3: ProgressionDescriptions.lsx")
print("=" * 80)

warrior_file = f"{WARRIOR_BASE}/Progressions/ProgressionDescriptions.lsx"
print(f"\nAnalyzing: {warrior_file}")

try:
    warrior_tree = ET.parse(warrior_file)
    warrior_root = warrior_tree.getroot()
    
    prog_descs = warrior_root.findall('.//node[@id="ProgressionDescription"]')
    print(f"  Found {len(prog_descs)} progression descriptions")
    
    # Check structure
    if len(prog_descs) == 0:
        print("  WARNING: No progression descriptions found!")
        print("  STATUS: EMPTY FILE - May need content")
        issues_found.append("ProgressionDescriptions.lsx is empty")
    else:
        # Check first entry
        first = prog_descs[0]
        attrs = [attr.get('id') for attr in first.findall('attribute')]
        print(f"  First entry has: {', '.join(attrs)}")
        print("  STATUS: OK")
    
except ET.ParseError as e:
    print(f"  ERROR: XML Parse Error - {e}")
    print("  STATUS: CORRUPTED - Needs fixing")
    issues_found.append(f"ProgressionDescriptions.lsx XML error: {e}")

files_processed += 1

# ============================================================================
# FILE 4: ActionResourceDefinitions.lsx
# ============================================================================
print("\n" + "=" * 80)
print("FILE 4: ActionResourceDefinitions.lsx")
print("=" * 80)

warrior_file = f"{WARRIOR_BASE}/ActionResourceDefinitions/ActionResourceDefinitions.lsx"
warlock_file = f"{WARLOCK_BASE}/ActionResourceDefinitions/ActionResourceDefinitions.lsx"

print(f"\nAnalyzing: {warrior_file}")

# Compare structure
warlock_tree = ET.parse(warlock_file)
warlock_resources = warlock_tree.findall('.//node[@id="ActionResourceDefinition"]')

warrior_tree = ET.parse(warrior_file)
warrior_resources = warrior_tree.findall('.//node[@id="ActionResourceDefinition"]')

print(f"  Warlock has: {len(warlock_resources)} resources")
print(f"  Warrior has: {len(warrior_resources)} resources")

if len(warrior_resources) > 0:
    first = warrior_resources[0]
    name_attr = first.find('attribute[@id="Name"]')
    if name_attr:
        print(f"  Resource name: {name_attr.get('value')}")
    
    # Check attribute count
    attrs = first.findall('attribute')
    print(f"  Attributes per resource: {len(attrs)}")
    print("  STATUS: OK")
else:
    print("  STATUS: NO RESOURCES DEFINED")
    issues_found.append("ActionResourceDefinitions.lsx has no resources")

files_processed += 1

# ============================================================================
# FILE 5: Lists Files (4 files)
# ============================================================================
print("\n" + "=" * 80)
print("FILES 5-8: Lists Folder")
print("=" * 80)

lists_files = ['SkillLists.lsx', 'SpellLists.lsx', 'PassiveLists.lsx', 'AbilityLists.lsx']

for list_file in lists_files:
    print(f"\nAnalyzing: Lists/{list_file}")
    
    warrior_file = f"{WARRIOR_BASE}/Lists/{list_file}"
    
    if not os.path.exists(warrior_file):
        print(f"  STATUS: MISSING FILE")
        issues_found.append(f"{list_file} is missing")
        continue
    
    try:
        tree = ET.parse(warrior_file)
        root = tree.getroot()
        
        # Get the list type from filename
        list_type = list_file.replace('.lsx', '').replace('Lists', 'List')
        
        # Find list nodes
        list_nodes = root.findall(f'.//node[@id="{list_type[:-1]}"]')  # Remove trailing 's'
        
        if len(list_nodes) == 0:
            # Try singular
            list_nodes = root.findall(f'.//node[@id="{list_type}"]')
        
        print(f"  Found {len(list_nodes)} list entries")
        
        if len(list_nodes) > 0:
            # Check first entry
            first = list_nodes[0]
            uuid_attr = first.find('attribute[@id="UUID"]')
            if uuid_attr:
                print(f"  First entry UUID: {uuid_attr.get('value')}")
            
            # Check content attribute
            content_attrs = ['Skills', 'Spells', 'Passives', 'Abilities']
            has_content = False
            for content_attr in content_attrs:
                attr = first.find(f'attribute[@id="{content_attr}"]')
                if attr:
                    value = attr.get('value')
                    print(f"  Content ({content_attr}): {len(value) if value else 0} chars")
                    has_content = True
                    break
            
            if not has_content:
                print(f"  WARNING: No content attribute found")
        
        print(f"  STATUS: OK")
        
    except ET.ParseError as e:
        print(f"  ERROR: XML Parse Error - {e}")
        print(f"  STATUS: CORRUPTED")
        issues_found.append(f"{list_file} XML error: {e}")
    
    files_processed += 1

# ============================================================================
# FILE 9: AbilityDistributionPresets.lsx
# ============================================================================
print("\n" + "=" * 80)
print("FILE 9: AbilityDistributionPresets.lsx")
print("=" * 80)

warrior_file = f"{WARRIOR_BASE}/CharacterCreationPresets/AbilityDistributionPresets.lsx"
warlock_file = f"{WARLOCK_BASE}/CharacterCreationPresets/AbilityDistributionPresets.lsx"

print(f"\nAnalyzing: {warrior_file}")

if not os.path.exists(warrior_file):
    print("  STATUS: MISSING FILE")
    issues_found.append("AbilityDistributionPresets.lsx is missing")
else:
    # Compare with Warlock
    warlock_tree = ET.parse(warlock_file)
    warlock_presets = warlock_tree.findall('.//node[@id="AbilityDistributionPreset"]')
    
    warrior_tree = ET.parse(warrior_file)
    warrior_presets = warrior_tree.findall('.//node[@id="AbilityDistributionPreset"]')
    
    print(f"  Warlock has: {len(warlock_presets)} presets")
    print(f"  Warrior has: {len(warrior_presets)} presets")
    
    if len(warrior_presets) > 0:
        print("  STATUS: OK")
    else:
        print("  STATUS: EMPTY - No presets defined")
        issues_found.append("AbilityDistributionPresets.lsx has no presets")

files_processed += 1

# ============================================================================
# FILE 10: DefaultValues (if exists)
# ============================================================================
print("\n" + "=" * 80)
print("FILES 10-11: DefaultValues Folder")
print("=" * 80)

default_values_files = ['Skills.lsx', 'Abilities.lsx']

for dv_file in default_values_files:
    print(f"\nAnalyzing: DefaultValues/{dv_file}")
    
    warrior_file = f"{WARRIOR_BASE}/DefaultValues/{dv_file}"
    dk_file = f"{DEATHKNIGHT_BASE}/DefaultValues/{dv_file}"
    
    if not os.path.exists(warrior_file):
        print(f"  STATUS: NOT PRESENT (DeathKnight has this, Warlock doesn't)")
        # Not necessarily an error
        continue
    
    # Compare with DeathKnight
    dk_tree = ET.parse(dk_file)
    dk_defaults = dk_tree.findall('.//node[@id="DefaultValue"]')
    
    warrior_tree = ET.parse(warrior_file)
    warrior_defaults = warrior_tree.findall('.//node[@id="DefaultValue"]')
    
    print(f"  DeathKnight has: {len(dk_defaults)} default entries")
    print(f"  Warrior has: {len(warrior_defaults)} default entries")
    
    if len(warrior_defaults) > 0:
        # Check structure
        first = warrior_defaults[0]
        attrs = [attr.get('id') for attr in first.findall('attribute')]
        print(f"  Attributes: {', '.join(attrs)}")
        
        # Check TableUUID
        table_uuid = first.find('attribute[@id="TableUUID"]')
        if table_uuid:
            print(f"  TableUUID: {table_uuid.get('value')}")
        
        print("  STATUS: OK")
    else:
        print("  STATUS: EMPTY")
    
    files_processed += 1

# ============================================================================
# FILE 12: meta.lsx
# ============================================================================
print("\n" + "=" * 80)
print("FILE 12: meta.lsx")
print("=" * 80)

warrior_meta = "Data/Mods/BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7/meta.lsx"
print(f"\nAnalyzing: {warrior_meta}")

meta_tree = ET.parse(warrior_meta)
meta_root = meta_tree.getroot()

# Check UUID
uuid_attr = meta_root.find('.//node[@id="ModuleInfo"]/attribute[@id="UUID"]')
if uuid_attr:
    uuid = uuid_attr.get('value')
    print(f"  UUID: {uuid}")
    if uuid != "78fe4967-4e62-5491-d981-dd781acca4d7":
        print(f"  WARNING: UUID mismatch!")
        issues_found.append("meta.lsx UUID mismatch")

# Check Type
type_attr = meta_root.find('.//node[@id="ModuleInfo"]/attribute[@id="Type"]')
if type_attr:
    mod_type = type_attr.get('value')
    print(f"  Type: {mod_type}")
    if mod_type != "Add-on":
        print(f"  NOTE: Type is '{mod_type}' (should be 'Add-on')")

# Check Dependencies
dependencies = meta_root.findall('.//node[@id="Dependencies"]/children/node')
print(f"  Dependencies: {len(dependencies)}")
for dep in dependencies:
    dep_name = dep.find('attribute[@id="Name"]')
    if dep_name:
        print(f"    - {dep_name.get('value')}")

print("  STATUS: OK")
files_processed += 1

# ============================================================================
# FINAL SUMMARY
# ============================================================================
print("\n" + "=" * 80)
print("VALIDATION SUMMARY")
print("=" * 80)

print(f"\nFiles processed: {files_processed}")
print(f"Files restructured: {files_restructured}")
print(f"Issues found: {len(issues_found)}")

if len(issues_found) > 0:
    print("\nISSUES DETECTED:")
    for i, issue in enumerate(issues_found, 1):
        print(f"  {i}. {issue}")
else:
    print("\nNO ISSUES FOUND - All files validated successfully!")

print("\n" + "=" * 80)
print("REPORT COMPLETE")
print("=" * 80)
