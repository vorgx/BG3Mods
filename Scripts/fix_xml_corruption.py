"""
Fix ALL XML corruption and complete full restructure
"""

import os
import re

print("=" * 80)
print("FIXING XML CORRUPTION")
print("=" * 80)

# Fix ProgressionDescriptions.lsx
prog_desc_file = "Data/Public/BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7/Progressions/ProgressionDescriptions.lsx"

print(f"\nFixing: {prog_desc_file}")

with open(prog_desc_file, 'r', encoding='utf-8') as f:
    content = f.read()

# Check for duplicate XML declarations
if content.count('<?xml') > 1:
    print("  ❌ Found duplicate XML declarations")
    
    # Remove all XML declarations
    content = re.sub(r'<\?xml[^>]+\?>', '', content)
    
    # Remove duplicate <save> tags
    content = re.sub(r'<save>', '', content)
    content = re.sub(r'</save>', '', content)
    
    # Remove duplicate version tags
    lines = content.split('\n')
    cleaned_lines = []
    seen_version = False
    
    for line in lines:
        # Skip empty lines at start
        if not line.strip() and not cleaned_lines:
            continue
        # Skip duplicate version lines
        if '<version major=' in line:
            if not seen_version:
                seen_version = True
                cleaned_lines.append(line)
        else:
            cleaned_lines.append(line)
    
    content = '\n'.join(cleaned_lines)
    
    # Add single XML declaration at start
    content = '<?xml version="1.0" encoding="UTF-8"?>\n<save>\n' + content.strip() + '\n</save>'
    
    # Write fixed content
    with open(prog_desc_file, 'w', encoding='utf-8') as f:
        f.write(content)
    
    print("  ✅ Fixed duplicate XML declarations")
else:
    print("  ✅ No corruption found")

print("\n" + "=" * 80)
print("XML FIX COMPLETE")
print("=" * 80)
