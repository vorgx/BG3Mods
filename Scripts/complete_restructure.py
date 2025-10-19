"""
Complete BG3Wow Mod Restructure - Match Working Mod Patterns
Analyzes Warlock/DeathKnight and restructures our mod to match EXACTLY
"""

import xml.etree.ElementTree as ET
import os
import shutil
from datetime import datetime

# Paths
WARRIOR_BASE = "Data/Public/BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7"
WARLOCK_BASE = "Tests/02_ExampleMods/ExampleMod_WoWWarlock/Public/Warlock_WoW_bdb3fa73-401b-4979-f02e-485422dd8d9c"
DEATHKNIGHT_BASE = "Tests/02_ExampleMods/WoWDeathKnightClass/Public/WoWDeathKnightClass"

print("=" * 80)
print("BG3WOW COMPLETE RESTRUCTURE - MATCHING WORKING MODS")
print("=" * 80)

# Create comprehensive backup
timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
backup_dir = f"Backups/BEFORE_FULL_RESTRUCTURE_{timestamp}"
os.makedirs(backup_dir, exist_ok=True)
shutil.copytree(WARRIOR_BASE, f"{backup_dir}/BG3Wow_Original", dirs_exist_ok=True)
print(f"\n Full backup created: {backup_dir}")

# ============================================================================
# STEP 1: Analyze Working Mod Structures
# ============================================================================
print("\n" + "=" * 80)
print("STEP 1: ANALYZING WORKING MODS")
print("=" * 80)

def analyze_progression_structure(file_path, mod_name):
    """Analyze how a working mod structures its Progressions.lsx"""
    tree = ET.parse(file_path)
    root = tree.getroot()
    
    progressions = root.findall('.//node[@id="Progression"]')
    
    print(f"\n{mod_name} Progression Structure:")
    print(f"  Total progressions: {len(progressions)}")
    
    # Check first progression (L1) structure
    l1_prog = [p for p in progressions if p.find('attribute[@id="Level"]').get('value') == '1'][0]
    
    print(f"  Level 1 structure:")
    for child in l1_prog:
        if child.tag == 'attribute':
            print(f"    - attribute: {child.get('id')}")
        elif child.tag == 'children':
            print(f"    - children node:")
            for subchild in child:
                print(f"        - {subchild.tag}: {subchild.get('id', 'N/A')}")
    
    # Check if Selectors is attribute or inside children
    selectors = l1_prog.find('attribute[@id="Selectors"]')
    if selectors is not None:
        print(f"   Selectors is DIRECT attribute of Progression")
        print(f"     Value: {selectors.get('value')[:80]}...")
    else:
        print(f"   Selectors NOT found as direct attribute")
    
    # Check AddSpells location
    addspells = l1_prog.find('attribute[@id="AddSpells"]')
    if addspells is not None:
        print(f"   AddSpells is DIRECT attribute of Progression")
    else:
        print(f"    AddSpells not used (likely in Selectors)")
    
    return True

# Analyze Warlock
warlock_prog_path = f"{WARLOCK_BASE}/Progressions/Progressions.lsx"
analyze_progression_structure(warlock_prog_path, "WARLOCK")

# Analyze DeathKnight  
dk_prog_path = f"{DEATHKNIGHT_BASE}/Progressions/Progressions.lsx"
analyze_progression_structure(dk_prog_path, "DEATHKNIGHT")

# ============================================================================
# STEP 2: Fix Progressions.lsx Structure COMPLETELY
# ============================================================================
print("\n" + "=" * 80)
print("STEP 2: RESTRUCTURING PROGRESSIONS.LSX")
print("=" * 80)

warrior_prog_path = f"{WARRIOR_BASE}/Progressions/Progressions.lsx"
tree = ET.parse(warrior_prog_path)
root = tree.getroot()

progressions = root.findall('.//node[@id="Progression"]')
print(f"\nFound {len(progressions)} progression nodes in Warrior mod")

fixed_count = 0
issues_found = []

for prog in progressions:
    level = prog.find('attribute[@id="Level"]').get('value')
    name = prog.find('attribute[@id="Name"]').get('value')
    
    # Get children node
    children = prog.find('children')
    
    if children is not None:
        # Check for misplaced attributes
        misplaced_attrs = children.findall('attribute')
        
        if misplaced_attrs:
            print(f"\n  Fixing Level {level} ({name}):")
            
            for attr in misplaced_attrs:
                attr_id = attr.get('id')
                print(f"    - Moving attribute '{attr_id}' to correct location")
                
                # Remove from children
                children.remove(attr)
                
                # Insert as direct child of progression (before children node)
                insert_index = list(prog).index(children)
                prog.insert(insert_index, attr)
                
                fixed_count += 1
            
            # Remove empty children node if it only has SubClasses or is empty
            remaining_nodes = children.findall('node')
            if len(remaining_nodes) == 0 or (len(remaining_nodes) == 1 and remaining_nodes[0].get('id') == 'SubClasses'):
                # Keep children with SubClasses
                pass
            elif len(remaining_nodes) == 0:
                # Remove completely empty children
                prog.remove(children)
                print(f"    - Removed empty children node")

print(f"\n Fixed {fixed_count} misplaced attributes")

# Write restructured file
tree.write(warrior_prog_path, encoding='UTF-8', xml_declaration=True)
print(f" Progressions.lsx restructured and saved")

# ============================================================================
# STEP 3: Validate Lists Folder Structure
# ============================================================================
print("\n" + "=" * 80)
print("STEP 3: VALIDATING LISTS FOLDER")
print("=" * 80)

lists_dir = f"{WARRIOR_BASE}/Lists"
required_lists = ['AbilityLists.lsx', 'PassiveLists.lsx', 'SkillLists.lsx', 'SpellLists.lsx']

print(f"\nChecking {lists_dir}:")
for list_file in required_lists:
    file_path = f"{lists_dir}/{list_file}"
    if os.path.exists(file_path):
        print(f"   {list_file} exists")
        # Validate it's proper XML
        try:
            tree = ET.parse(file_path)
            root = tree.getroot()
            region = root.find('.//region')
            if region is not None:
                print(f"     Region: {region.get('id')}")
        except:
            print(f"       Warning: XML parse error")
    else:
        print(f"   {list_file} MISSING!")
        issues_found.append(f"Missing {list_file}")

# ============================================================================
# STEP 4: Validate ClassDescriptions.lsx Structure
# ============================================================================
print("\n" + "=" * 80)
print("STEP 4: VALIDATING CLASSDESCRIPTIONS.LSX")
print("=" * 80)

class_desc_path = f"{WARRIOR_BASE}/ClassDescriptions/ClassDescriptions.lsx"
if os.path.exists(class_desc_path):
    tree = ET.parse(class_desc_path)
    root = tree.getroot()
    
    classes = root.findall('.//node[@id="ClassDescription"]')
    print(f"\n Found {len(classes)} class definitions:")
    
    for cls in classes:
        name_attr = cls.find('attribute[@id="Name"]')
        if name_attr is not None:
            name = name_attr.get('value')
            uuid_attr = cls.find('attribute[@id="UUID"]')
            uuid = uuid_attr.get('value') if uuid_attr is not None else 'N/A'
            print(f"  - {name} (UUID: {uuid})")
            
            # Check for ProgressionTableUUID
            prog_table = cls.find('attribute[@id="ProgressionTableUUID"]')
            if prog_table is not None:
                print(f"    ProgressionTableUUID: {prog_table.get('value')}")
            else:
                print(f"      Missing ProgressionTableUUID")
                issues_found.append(f"Missing ProgressionTableUUID in {name}")
else:
    print(" ClassDescriptions.lsx NOT FOUND!")
    issues_found.append("Missing ClassDescriptions.lsx")

# ============================================================================
# STEP 5: Validate ProgressionDescriptions.lsx
# ============================================================================
print("\n" + "=" * 80)
print("STEP 5: VALIDATING PROGRESSIONDESCRIPTIONS.LSX")
print("=" * 80)

prog_desc_path = f"{WARRIOR_BASE}/Progressions/ProgressionDescriptions.lsx"
if os.path.exists(prog_desc_path):
    tree = ET.parse(prog_desc_path)
    root = tree.getroot()
    
    prog_descs = root.findall('.//node[@id="ProgressionDescription"]')
    print(f"\n Found {len(prog_descs)} progression descriptions")
    
    for pd in prog_descs[:3]:  # Show first 3
        uuid_attr = pd.find('attribute[@id="UUID"]')
        display_attr = pd.find('attribute[@id="DisplayName"]')
        if uuid_attr and display_attr:
            print(f"  - UUID: {uuid_attr.get('value')}")
            print(f"    Display: {display_attr.get('value')}")
else:
    print(" ProgressionDescriptions.lsx NOT FOUND!")
    issues_found.append("Missing ProgressionDescriptions.lsx")

# ============================================================================
# STEP 6: Validate ActionResourceDefinitions
# ============================================================================
print("\n" + "=" * 80)
print("STEP 6: VALIDATING ACTIONRESOURCEDEFINITIONS.LSX")
print("=" * 80)

action_res_path = f"{WARRIOR_BASE}/ActionResourceDefinitions/ActionResourceDefinitions.lsx"
if os.path.exists(action_res_path):
    tree = ET.parse(action_res_path)
    root = tree.getroot()
    
    resources = root.findall('.//node[@id="ActionResourceDefinition"]')
    print(f"\n Found {len(resources)} action resources:")
    
    for res in resources:
        name_attr = res.find('attribute[@id="Name"]')
        if name_attr:
            print(f"  - {name_attr.get('value')}")
else:
    print(" ActionResourceDefinitions.lsx NOT FOUND!")
    issues_found.append("Missing ActionResourceDefinitions.lsx")

# ============================================================================
# STEP 7: Validate meta.lsx
# ============================================================================
print("\n" + "=" * 80)
print("STEP 7: VALIDATING META.LSX")
print("=" * 80)

meta_path = "Data/Mods/BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7/meta.lsx"
if os.path.exists(meta_path):
    tree = ET.parse(meta_path)
    root = tree.getroot()
    
    # Check UUID
    uuid_attr = root.find('.//node[@id="ModuleInfo"]/attribute[@id="UUID"]')
    if uuid_attr:
        uuid = uuid_attr.get('value')
        print(f"\n  UUID: {uuid}")
        if uuid != "78fe4967-4e62-5491-d981-dd781acca4d7":
            print(f"    UUID mismatch!")
            issues_found.append("UUID mismatch in meta.lsx")
    
    # Check Type
    type_attr = root.find('.//node[@id="ModuleInfo"]/attribute[@id="Type"]')
    if type_attr:
        mod_type = type_attr.get('value')
        print(f"  Type: {mod_type}")
        if mod_type != "Add-on":
            print(f"    Type should be 'Add-on'")
    
    # Check Dependencies
    dependencies = root.findall('.//node[@id="Dependencies"]/children/node')
    print(f"  Dependencies: {len(dependencies)} found")
    for dep in dependencies:
        dep_name = dep.find('attribute[@id="Name"]')
        if dep_name:
            print(f"    - {dep_name.get('value')}")
else:
    print(" meta.lsx NOT FOUND!")
    issues_found.append("Missing meta.lsx")

# ============================================================================
# STEP 8: Cross-Reference UUID Validation
# ============================================================================
print("\n" + "=" * 80)
print("STEP 8: CROSS-REFERENCE UUID VALIDATION")
print("=" * 80)

print("\nValidating UUID references:")

# Get base class TableUUID from Progressions
tree = ET.parse(warrior_prog_path)
root = tree.getroot()
base_prog = [p for p in root.findall('.//node[@id="Progression"]') 
             if p.find('attribute[@id="Level"]').get('value') == '1' 
             and p.find('attribute[@id="ProgressionType"]').get('value') == '0'][0]
table_uuid = base_prog.find('attribute[@id="TableUUID"]').get('value')
print(f"  Base class TableUUID (from Progressions): {table_uuid}")

# Check if it matches ClassDescriptions
tree = ET.parse(class_desc_path)
root = tree.getroot()
warrior_class = root.find('.//node[@id="ClassDescription"]')
prog_table_uuid = warrior_class.find('attribute[@id="ProgressionTableUUID"]')
if prog_table_uuid:
    prog_uuid = prog_table_uuid.get('value')
    print(f"  ProgressionTableUUID (from ClassDescriptions): {prog_uuid}")
    if table_uuid == prog_uuid:
        print(f"   UUIDs MATCH!")
    else:
        print(f"   UUIDs DO NOT MATCH!")
        issues_found.append("TableUUID mismatch between Progressions and ClassDescriptions")

# Check SkillLists UUID
tree = ET.parse(f"{WARRIOR_BASE}/Lists/SkillLists.lsx")
root = tree.getroot()
skill_list = root.find('.//node[@id="SkillList"]')
skill_uuid = skill_list.find('attribute[@id="UUID"]').get('value')
print(f"  SkillList UUID: {skill_uuid}")

# Check if used in Progressions Selectors
tree = ET.parse(warrior_prog_path)
root = tree.getroot()
l1_prog = [p for p in root.findall('.//node[@id="Progression"]') 
           if p.find('attribute[@id="Level"]').get('value') == '1'][0]
selectors = l1_prog.find('attribute[@id="Selectors"]')
if selectors and skill_uuid in selectors.get('value'):
    print(f"   SkillList UUID referenced in Progressions Selectors")
else:
    print(f"   SkillList UUID NOT found in Progressions Selectors")
    issues_found.append("SkillList UUID not referenced in Progressions")

# ============================================================================
# FINAL REPORT
# ============================================================================
print("\n" + "=" * 80)
print("VALIDATION COMPLETE")
print("=" * 80)

if len(issues_found) == 0:
    print("\n  NO ISSUES FOUND! Mod structure matches working mods!")
    print("\nReady to package and test!")
else:
    print(f"\n  Found {len(issues_found)} issues:")
    for i, issue in enumerate(issues_found, 1):
        print(f"  {i}. {issue}")
    print("\n Fix these issues before packaging.")

print("\n" + "=" * 80)
print("RESTRUCTURE COMPLETE")
print("=" * 80)
print(f"\nBackup location: {backup_dir}")
print("Next step: Review validation report, then package and test")

