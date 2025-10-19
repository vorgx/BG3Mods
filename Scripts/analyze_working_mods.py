"""
Comprehensive analysis script for Warlock and DeathKnight mods.
Extracts progression tables, file structures, and requirements.
"""

import xml.etree.ElementTree as ET
from pathlib import Path
from collections import defaultdict

def analyze_mod(mod_name, mod_path_public, mod_path_mods=None):
    """Analyze a complete BG3 mod structure."""
    
    print(f"\n{'='*80}")
    print(f"ANALYZING: {mod_name}")
    print(f"{'='*80}\n")
    
    results = {
        'name': mod_name,
        'files': [],
        'progressions': [],
        'classes': [],
        'lists': {},
        'stats_files': []
    }
    
    # 1. File inventory
    print("[FILES] FILE STRUCTURE:")
    public_path = Path(mod_path_public)
    if public_path.exists():
        for file in public_path.rglob('*.lsx'):
            relative = str(file.relative_to(public_path))
            results['files'].append(relative)
            print(f"   [OK] {relative}")
    
    # 2. Analyze Progressions.lsx
    print("\n[PROG] PROGRESSION TABLE:")
    progressions_file = list(public_path.rglob('Progressions/Progressions.lsx'))
    if progressions_file:
        tree = ET.parse(progressions_file[0])
        root = tree.getroot()
        
        progressions_by_table = defaultdict(list)
        
        for progression in root.findall(".//node[@id='Progression']"):
            level = progression.find("attribute[@id='Level']")
            name = progression.find("attribute[@id='Name']")
            selectors = progression.find("attribute[@id='Selectors']")
            passives = progression.find("attribute[@id='PassivesAdded']")
            boosts = progression.find("attribute[@id='Boosts']")
            table_uuid = progression.find("attribute[@id='TableUUID']")
            is_multiclass = progression.find("attribute[@id='IsMulticlass']")
            
            prog_data = {
                'level': level.get('value') if level is not None else '?',
                'name': name.get('value') if name is not None else '?',
                'selectors': selectors.get('value') if selectors is not None else '',
                'passives': passives.get('value') if passives is not None else '',
                'boosts': boosts.get('value') if boosts is not None else '',
                'table_uuid': table_uuid.get('value') if table_uuid is not None else '',
                'is_multiclass': is_multiclass is not None
            }
            
            results['progressions'].append(prog_data)
            progressions_by_table[prog_data['table_uuid']].append(prog_data)
        
        # Print progression tables
        for table_uuid, progs in progressions_by_table.items():
            # Skip multiclass entries
            non_mc_progs = [p for p in progs if not p['is_multiclass']]
            if non_mc_progs:
                class_name = non_mc_progs[0]['name']
                print(f"\n   {class_name} (UUID: {table_uuid[:8]}...):")
                for prog in sorted(non_mc_progs, key=lambda x: int(x['level']) if x['level'].isdigit() else 0):
                    level = prog['level']
                    
                    # Parse selectors
                    features = []
                    if 'AddSpells' in prog['selectors']:
                        features.append(' Spells')
                    if 'SelectPassives' in prog['selectors']:
                        # Count how many passive choices
                        count = prog['selectors'].count('SelectPassives')
                        features.append(f' {count} Talent Choice(s)')
                    if 'SelectSkills' in prog['selectors']:
                        features.append(' Skills')
                    if 'SelectAbilityBonus' in prog['selectors']:
                        features.append(' Ability Scores')
                    if prog['passives']:
                        features.append(f" {prog['passives'][:30]}...")
                    if 'AllowImprovement' in prog.get('boosts', '') or 'AllowImprovement' in str(prog):
                        features.append(' Feat')
                    
                    features_str = ', '.join(features) if features else '(no changes)'
                    print(f"      L{level:2s}: {features_str}")
    
    # 3. Analyze ClassDescriptions
    print("\n CLASS DEFINITIONS:")
    class_desc_file = list(public_path.rglob('ClassDescriptions/ClassDescriptions.lsx'))
    if class_desc_file:
        tree = ET.parse(class_desc_file[0])
        root = tree.getroot()
        
        for class_node in root.findall(".//node[@id='ClassDescription']"):
            name_attr = class_node.find("attribute[@id='Name']")
            uuid_attr = class_node.find("attribute[@id='UUID']")
            parent_attr = class_node.find("attribute[@id='ParentGuid']")
            
            class_info = {
                'name': name_attr.get('value') if name_attr is not None else '?',
                'uuid': uuid_attr.get('value') if uuid_attr is not None else '?',
                'is_subclass': parent_attr is not None
            }
            results['classes'].append(class_info)
            
            indent = "      " if class_info['is_subclass'] else "   "
            prefix = "" if class_info['is_subclass'] else ""
            print(f"{indent}{prefix} {class_info['name']}")
    
    # 4. Analyze Lists
    print("\n LISTS:")
    for list_type in ['SkillLists', 'AbilityLists', 'PassiveLists', 'SpellLists']:
        list_file = list(public_path.rglob(f'Lists/{list_type}.lsx'))
        if list_file:
            tree = ET.parse(list_file[0])
            root = tree.getroot()
            count = len(root.findall(f".//node[@id='{list_type[:-1]}']"))
            results['lists'][list_type] = count
            print(f"    {list_type}: {count} list(s)")
        else:
            print(f"    {list_type}: Not found")
    
    # 5. Stats files
    print("\n STATS FILES:")
    stats_path = public_path / 'Stats' / 'Generated' / 'Data'
    if stats_path.exists():
        for stat_file in sorted(stats_path.glob('*.txt')):
            size_kb = stat_file.stat().st_size / 1024
            results['stats_files'].append(stat_file.name)
            
            # Count entries
            content = stat_file.read_text(encoding='utf-8', errors='ignore')
            entry_count = content.count('new entry')
            print(f"    {stat_file.name}: {entry_count} entries ({size_kb:.1f} KB)")
    
    return results

# Analyze Warlock
warlock_results = analyze_mod(
    "WoW Warlock",
    r"C:\Users\tenod\source\repos\BG3Mods\Tests\02_ExampleMods\ExampleMod_WoWWarlock\Public\Warlock_WoW_bdb3fa73-401b-4979-f02e-485422dd8d9c"
)

# Analyze DeathKnight
dk_results = analyze_mod(
    "WoW Death Knight",
    r"C:\Users\tenod\source\repos\BG3Mods\Tests\02_ExampleMods\WoWDeathKnightClass\Public\WoWDeathKnightClass"
)

# Comparison
print(f"\n{'='*80}")
print("COMPARISON SUMMARY")
print(f"{'='*80}\n")

print(" File Count:")
print(f"   Warlock: {len(warlock_results['files'])} LSX files")
print(f"   DeathKnight: {len(dk_results['files'])} LSX files")

print("\n Class Structure:")
print(f"   Warlock: {len(warlock_results['classes'])} classes/subclasses")
print(f"   DeathKnight: {len(dk_results['classes'])} classes/subclasses")

print("\n Stats Files:")
print(f"   Warlock: {len(warlock_results['stats_files'])} files")
print(f"   DeathKnight: {len(dk_results['stats_files'])} files")

print("\n Analysis complete!")
print("\nKey findings will be saved to report files...")
