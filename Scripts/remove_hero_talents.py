"""
Remove hero talent progressions (L13-20 for subclasses).
These will be added back later with proper PassiveList files.
For now, keep only base Warrior progression (L1-20) and simplified subclass progressions (L3-12).
"""

import re
from pathlib import Path

file_path = Path(r"C:\Users\tenod\source\repos\BG3Mods\Data\Public\BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7\Progressions\Progressions.lsx")

content = file_path.read_text(encoding='utf-8')

# Find all progression nodes with level >= 13 that belong to subclasses (ProgressionType 1) 
# Pattern: <!-- ARMS LEVEL X --> or <!-- FURY LEVEL X --> or <!-- PROTECTION LEVEL X --> followed by progression node
subclass_talent_pattern = r'<!-- (?:ARMS|FURY|PROTECTION) LEVEL (?:1[3-9]|20) .*?-->\s*<node id="Progression">.*?</node>\s*(?=<!--|\s*</children>)'

matches = list(re.finditer(subclass_talent_pattern, content, flags=re.DOTALL))
print(f"Found {len(matches)} hero talent progression blocks to remove")

# Remove them
new_content = re.sub(subclass_talent_pattern, '', content, flags=re.DOTALL)

# Count Selector nodes after removal
remaining_selectors = new_content.count('<node id="Selectors">')

print(f"Remaining Selector nodes: {remaining_selectors}")

if remaining_selectors == 0:
    print("\n✅ All nested Selector nodes removed!")
else:
    print(f"\n⚠️ {remaining_selectors} Selector nodes still present")

# Write
file_path.write_text(new_content, encoding='utf-8')
print(f"\nUpdated: {file_path}")
print("Hero talents (L13-20) removed from subclass progressions")
