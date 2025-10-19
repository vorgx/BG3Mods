"""
Final cleanup: Remove all remaining nested Selector nodes.
These are SelectPassives for hero talents (L13-20) which need PassiveList files.
We'll comment them out for now to get the base class working.
"""

import re
from pathlib import Path

file_path = Path(r"C:\Users\tenod\source\repos\BG3Mods\Data\Public\BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7\Progressions\Progressions.lsx")

content = file_path.read_text(encoding='utf-8')

# Pattern for remaining Selector blocks (SelectPassives with nested choices)
selector_pattern = r'<node id="Selectors">.*?</node>\s*(?=</children>)'

def comment_selector(match):
    """Comment out the entire Selector block."""
    block = match.group(0)
    lines = block.split('\n')
    commented = '\n'.join(['<!-- ' + line + ' -->' if line.strip() else line for line in lines])
    return '<!-- TEMPORARILY DISABLED - SelectPassives needs PassiveList files -->\n' + commented

# Count before
before_count = content.count('<node id="Selectors">')

# Replace
new_content = re.sub(selector_pattern, comment_selector, content, flags=re.DOTALL)

# Count after
after_count = new_content.count('<node id="Selectors">')

print(f"Selector nodes before: {before_count}")
print(f"Selector nodes after: {after_count}")
print(f"Commented out: {before_count - after_count}")

if after_count == 0:
    print("\n✅ All Selector nodes removed/converted!")
else:
    print(f"\n⚠️ {after_count} Selector nodes remain")

# Write
file_path.write_text(new_content, encoding='utf-8')
print(f"\nUpdated: {file_path}")
