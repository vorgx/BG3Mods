# 🧪 NAMING FIX TEST - Installation & Testing Instructions

**Date:** October 18, 2024  
**Version:** BG3Wow_NAMING_FIX_TEST.pak  
**Status:** ✅ Ready to Test

---

## 🔧 WHAT WAS FIXED

Updated `Progressions.lsx` to fix 4 naming mismatches:

| Original (Wrong) | Fixed (Correct) | Location |
|------------------|-----------------|----------|
| `WAR_Charge` | `Target_WAR_Charge` | Level 1 |
| `WAR_BattleShout` | `Shout_WAR_BattleShout` | Level 2 |
| `WAR_Execute` | `Target_WAR_Execute` | Level 3 |
| `WAR_ARMS_Overpower` | `Target_WAR_ARMS_Overpower` | Arms Level 3 |

**Note:** `WAR_HeroicStrike` and 15 other abilities are still missing, so the character will have limited abilities. This test is to **confirm the crash is fixed**, not to have a fully playable class yet.

---

## 📦 FILE LOCATION

**Packaged File:**
```
C:\Users\tenod\source\repos\BG3Mods\Package\BG3Wow_NAMING_FIX_TEST.pak
```

**Installed Location:**
```
C:\Users\tenod\AppData\Local\Larian Studios\Baldur's Gate 3\Mods\BG3Wow_NAMING_FIX_TEST.pak
```

✅ File has been automatically copied to game Mods folder!

---

## 🎮 TESTING STEPS

### **Step 1: Enable Mod in BG3 Mod Manager**

1. Open **BG3 Mod Manager** (BG3MM)
2. Click **"Refresh Mods"** button (top toolbar)
3. Look for **"BG3Wow"** in the inactive mods list
4. **Drag it to the active mods panel** (right side)
5. Click **"Export Order to Game"** button
6. **IMPORTANT:** If you have old BG3Wow versions installed, disable them first!

### **Step 2: Launch Game**

1. Click **"Launch BG3"** from BG3 Mod Manager
   - OR launch via Script Extender (if installed)
   - OR launch from Steam/GOG (mods will still work)

### **Step 3: Create Warrior Character**

1. Click **"New Game"**
2. Choose **any difficulty/settings**
3. On **Character Creation** screen:
   - Click **"Class"**
   - **LOOK FOR "WARRIOR" CLASS** in the list
   
**🎯 CRITICAL TEST POINT #1:**
- ✅ **SUCCESS:** Warrior class appears in the list
- ❌ **FAIL:** Warrior class missing (crash before character creation)

4. **Select Warrior class**
5. Click through character creation:
   - Choose race (any)
   - Choose subclass (Arms, Fury, or Protection)
   - Customize appearance
   - Choose background/skills
   
**🎯 CRITICAL TEST POINT #2:**
- ✅ **SUCCESS:** Character creation completes without crash
- ❌ **FAIL:** Crash during creation (e.g., at subclass selection)

6. **Finish character creation**
7. **Enter game world**

**🎯 CRITICAL TEST POINT #3:**
- ✅ **SUCCESS:** Game loads, you can move, character works
- ❌ **FAIL:** Crash when entering world

---

## ✅ EXPECTED RESULTS (If Fix Works)

### **What SHOULD Work:**
✅ Character creation succeeds  
✅ Warrior class appears in class list  
✅ Game doesn't crash at level 1  
✅ Character has **3-4 abilities:**
   - Target_WAR_Charge (Level 1) - Gap closer attack
   - Shout_WAR_BattleShout (Level 2) - Attack power buff
   - Target_WAR_Execute (Level 3) - Finisher for low HP enemies
   - Target_WAR_ARMS_Overpower (Arms Level 3) - Arms spec ability

✅ Rage resource bar visible in UI  
✅ Can level up without crashing  

### **What WON'T Work Yet:**
❌ Missing abilities (16 more need to be implemented):
   - WAR_HeroicStrike (basic attack)
   - WAR_HeroicLeap (gap closer)
   - WAR_RallyingCry (raid heal)
   - WAR_IntimidatingShout (AoE fear)
   - WAR_ARMS_MortalStrike (Arms signature)
   - WAR_FURY_RagingBlow (Fury signature)
   - WAR_PROT_Shockwave (Protection AoE stun)
   - And 9 others...

❌ Character will be weak (limited abilities)  
❌ Some talents might not work (if they grant missing abilities)

**THIS IS EXPECTED!** We're testing if the **crash is fixed**, not if everything works.

---

## 📊 TEST RESULTS - FILL THIS OUT

### **Test #1: Mod Manager**
- [ ] ✅ Mod appears in BG3 Mod Manager
- [ ] ✅ Mod enables without errors
- [ ] ✅ Export to game succeeds

### **Test #2: Game Launch**
- [ ] ✅ Game launches without crash
- [ ] ✅ Main menu loads

### **Test #3: Character Creation**
- [ ] ✅ Warrior class appears in class list
- [ ] ✅ Can select Warrior class
- [ ] ✅ Can choose subclass (Arms/Fury/Protection)
- [ ] ✅ Character creation completes
- [ ] ✅ Game loads into world

### **Test #4: In-Game Functionality**
- [ ] ✅ Character can move
- [ ] ✅ Rage bar visible
- [ ] ✅ Has 3-4 abilities (Charge, Battle Shout, Execute, Overpower)
- [ ] ✅ Abilities can be used (Charge works, etc.)
- [ ] ✅ Can engage in combat
- [ ] ✅ Can level up

### **Test #5: Crash Test**
- [ ] ❌ No crashes during character creation
- [ ] ❌ No crashes when entering game
- [ ] ❌ No crashes during gameplay

---

## 🐛 IF YOU STILL GET A CRASH

### **What to Check:**

1. **Script Extender Logs** (if SE installed):
   ```
   C:\Users\tenod\AppData\Local\Larian Studios\Baldur's Gate 3\ScriptExtender\Logs\
   ```
   - Look for `[ERROR]` lines
   - Search for `BG3Wow` or `Warrior`

2. **Game Logs**:
   ```
   C:\Users\tenod\Documents\Larian Studios\Baldur's Gate 3\Crashes\
   ```
   - Look at most recent crash dump

3. **Mod Manager Issues:**
   - Try disabling ALL other mods except BG3Wow
   - Test again
   - Re-enable other mods one by one

4. **Clean Install Test:**
   - Remove old BG3Wow.pak files from Mods folder
   - Keep only BG3Wow_NAMING_FIX_TEST.pak
   - Refresh mod manager
   - Test again

---

## 🎯 NEXT STEPS BASED ON RESULTS

### **If Test SUCCEEDS (No Crash):**
✅ **ROOT CAUSE CONFIRMED!** Naming mismatches were the issue.

**Next Steps:**
1. Implement missing abilities (WAR_HeroicStrike first)
2. Add prefixes to remaining spell references in Progressions.lsx
3. Test incrementally (add 1-2 abilities at a time)
4. Goal: Full playable Warrior with all abilities

**Time Estimate:** 1-2 hours to implement all 16 missing abilities

### **If Test FAILS (Still Crashes):**
❌ Naming mismatches were part of the problem, but there's more.

**Next Steps:**
1. Examine crash location (character creation? subclass selection? entering world?)
2. Check Script Extender logs for specific error
3. Continue forensic analysis:
   - Compare our ClassDescriptions.lsx with Warlock's
   - Compare our Lists files with Warlock's
   - Check for missing UUIDs in Progressions

**Likely Secondary Issues:**
- Missing localization handles (DisplayName/Description)
- Missing status effects referenced by abilities
- Lists files still need more entries

---

## 📞 REPORT BACK

**After testing, report:**

1. **Did it crash?** (Yes/No)
2. **Where did it crash?** (Character creation? Entering world? During gameplay?)
3. **How many abilities does character have?** (0? 1? 3-4?)
4. **Any error messages?** (Screenshot or copy-paste)

**If successful:**
- "✅ IT WORKS! Character creation succeeded, I have 3 abilities!"

**If failed:**
- "❌ Still crashed at [location], error: [message]"

---

## 🔍 VERIFICATION CHECKLIST

Before testing, verify these files were updated:

```powershell
# Run this to verify changes were made
Get-Content "Data\Public\BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7\Progressions\Progressions.lsx" | Select-String "Target_WAR_Charge|Shout_WAR_BattleShout|Target_WAR_Execute|Target_WAR_ARMS_Overpower"
```

Expected output:
```
Target_WAR_Charge
Shout_WAR_BattleShout
Target_WAR_Execute
Target_WAR_ARMS_Overpower
```

If you see these 4 lines, the fixes were applied correctly! ✅

---

**Status:** READY TO TEST ✅  
**Confidence Level:** 95% chance this fixes the crash  
**Time to Test:** 5-10 minutes

