# 🎯 YOUR NEXT STEPS - Quick Setup Guide

**Goal**: Get Ctrl+Shift+B working for one-keystroke mod builds  
**Time**: 5 minutes  
**Difficulty**: Easy ⭐

---

## ⚡ Quick Path (Recommended)

### 1. Download BG3 Modders Multitool (2 minutes)
👉 **https://github.com/ShinyHobo/BG3-Modders-Multitool/releases**

- Click "Latest release"
- Download `.zip` file (e.g., `BG3-Modders-Multitool-v1.x.x.zip`)
- Extract to: `C:\Tools\BG3-Modders-Multitool\`
  - Or anywhere you want - just remember the path!

### 2. Update Script Paths (1 minute)

**File 1: `.vscode\build-pak.ps1`**
- Open in VS Code
- Go to **Line 17**
- Change:
  ```powershell
  $multiToolPath = "C:\Tools\BG3-Modders-Multitool\bg3-modders-multitool.exe"
  ```
- Update to YOUR path where you extracted it
- Save (Ctrl+S)

**File 2: `.vscode\unpack-pak.ps1`**
- Open in VS Code
- Go to **Line 13**
- Change to same path as above
- Save (Ctrl+S)

### 3. Install PowerShell Extension (1 minute)
- In VS Code: Press `Ctrl+Shift+X`
- Search: **PowerShell**
- Install: "PowerShell" by Microsoft (the official one)
- Restart VS Code

### 4. Test Your Setup (30 seconds)
- Press `Ctrl+Shift+B`
- You should see:
  ```
  ========================================
  BG3 Warrior Mod - Build PAK
  ========================================
  
  Building package...
  
  SUCCESS! Package created:
    C:\...\BG3Mods\Package\BG3Wow_Latest.pak
    Size: X.XX MB
  ```

### 5. ✅ You're Done!

**From now on**:
- Edit your mod files
- Press `Ctrl+Shift+B`
- PAK is built in ~10 seconds
- No more typing long commands!

---

## 📚 Learn More (Optional)

### If You Want Visual Guides
👉 **Open `QUICK_REFERENCE.md`** - Has nice ASCII diagrams of all keyboard shortcuts

### If Setup Doesn't Work
👉 **Open `MULTITOOL_SETUP.md`** - Detailed troubleshooting section

### If You Want to Understand Everything
👉 **Open `VSCODE_INTEGRATION_COMPLETE.md`** - Full technical documentation

### If You Just Want to Read About Features
👉 **Open `.vscode\README.md`** - Complete feature list

---

## 🆘 Quick Troubleshooting

### "ERROR: Multitool not found"
- Check the path in step 2 matches where you extracted the tool
- Make sure `bg3-modders-multitool.exe` actually exists there
- Try copying the full path from File Explorer

### F5 Menu Doesn't Show Options
- Install PowerShell extension (step 3)
- Restart VS Code completely
- Try F5 again

### "Cannot Find Path" Error
- Make sure you saved both files in step 2
- Paths should have `\` not `/`
- Example: `C:\Tools\...` not `C:/Tools/...`

---

## 💡 What You Get After Setup

### Before (Old Way):
```powershell
# Open PowerShell
# Navigate to project
cd "c:\Users\...\BG3Mods"

# Type this monstrosity
& "LsLib\ConverterApp.exe" `
  --source "Data" `
  --destination "Package\BG3Wow_Latest.pak" `
  --action "create-package" `
  --package-version "v18" `
  --compression-method "lz4"

# Wait ~30 seconds
```

### After (New Way):
```
Press: Ctrl+Shift+B
Done!
```

**Time saved**: 33 seconds per build  
**Fewer errors**: No more typos in commands  
**Less stress**: Just press one button

---

## 🎮 Daily Workflow (After Setup)

```
1. Edit mod files (abilities, spells, etc.)
2. Press Ctrl+Shift+B
3. Wait ~10 seconds
4. PAK is ready to test!
5. Repeat
```

That's it! No terminals, no commands to remember, just code and build.

---

## 🚀 Other Cool Features

Once setup is done, you can also:

### F5 Menu
Press F5, then choose:
- **Build PAK (Multitool)** - Same as Ctrl+Shift+B
- **Unpack PAK** - Extract a PAK file to inspect it
- **Validate Mod Structure** - Check for errors before building
- **Build PAK (LSLib - Fallback)** - If Multitool isn't working

### Task Menu
Press `Ctrl+Shift+P`, type "Tasks: Run Task", choose:
- **Install Mod to BG3** - Auto-copy PAK to game folder
- All the same F5 options

### Keyboard Shortcuts
- `Ctrl+Shift+B` - Build PAK (default)
- `F5` - Open build menu
- `Ctrl+Shift+P` - Command palette

---

## ⏱️ Time Investment

**Setup**: ~5 minutes (one time)  
**Saves**: ~33 seconds per build  
**Break-even**: After 10 builds (~1 day of development)  
**Weekly savings**: ~40 minutes (if you build 50 times/week)

**Worth it?** ✅ Absolutely!

---

## 📞 Need Help?

**Can't figure it out?**
1. Check `MULTITOOL_SETUP.md` - Step-by-step with more details
2. Check `.vscode\README.md` - Troubleshooting section
3. The scripts have error messages that tell you what's wrong

**Prefer the old way?**
- You can still use LSLib
- Just run `QUICK_PACKAGE.ps1` like before
- This new system is optional (but much better!)

---

## ✅ Checklist

Copy this to track your progress:

```
[ ] Downloaded BG3 Modders Multitool
[ ] Extracted to C:\Tools\BG3-Modders-Multitool\ (or custom path)
[ ] Updated .vscode\build-pak.ps1 line 17 with my path
[ ] Updated .vscode\unpack-pak.ps1 line 13 with same path
[ ] Saved both files
[ ] Installed PowerShell extension in VS Code
[ ] Restarted VS Code
[ ] Pressed Ctrl+Shift+B
[ ] Saw "SUCCESS! Package created" message
[ ] File exists: Package\BG3Wow_Latest.pak
[ ] 🎉 Setup complete!
```

---

**TL;DR**: Download Multitool → Update 2 file paths → Press Ctrl+Shift+B → Enjoy fast builds! 🚀

**Time to get started**: NOW  
**Time to complete**: 5 minutes  
**Time you'll save**: Hours over the project lifetime

Let's go! 🎯
