# Quick Test - Speed Upgrade System

## 🎮 How to Test It

### Step 1: Start the Game
1. Click "Play" in the Godot editor
2. Start a level

### Step 2: Collect 10 Items
1. Move around and collect 10 pieces of food
2. Watch the HUD counter go from "X 0" to "X 10"

### Step 3: Go to Shop
1. Exit the level
2. Click on the shop icon/button
3. **Look for the "Speed Boost" card** (should appear with the other items)
4. HUD should show "Speed Upgrade: Ready to Buy!"

### Step 4: Buy the Speed Upgrade
1. Click the "Speed Boost" card
2. Your item count should go from 10 to 0
3. The card should disappear
4. HUD should show "Speed Upgrade: ✓ ACTIVE (2.0x faster)"

### Step 5: Experience Double Speed
1. Go to the next level
2. **Walk around** - you should move **NOTICEABLY FASTER**
3. Compare to before: it should be exactly double speed!

### Step 6: Test Persistence Reset
1. **Close the game completely**
2. Restart the game
3. **Speed boost is GONE** (you're back to normal speed)
4. **But your items still exist!** (if you collected any, they're still there)

---

## ✅ Expected Results

| Step | Expected | Result |
|------|----------|--------|
| Collect 10 items | Counter shows "X 10" | ✅ or ❌ |
| Go to shop | "Speed Boost" card appears | ✅ or ❌ |
| Click card | Items go from 10 → 0 | ✅ or ❌ |
| In next level | Movement is **DOUBLE** | ✅ or ❌ |
| Close & reopen | Speed is **NORMAL** again | ✅ or ❌ |
| Items in second session | You can collect and buy again | ✅ or ❌ |

---

## 🐛 If Something Goes Wrong

### Speed Card Not Appearing in Shop
- Check: Do you have 10+ items?
- Check: Haven't bought the upgrade already?
- Solution: Verify `Shop.gd` has the speed upgrade card code (lines 13-18)

### Speed Not Increasing After Purchase
- Check: Did you click the speed card?
- Check: Did your items go from 10 → 0?
- Check: Did you go to a NEW level (not the same one)?
- Solution: Verify `Player.gd` line 56 has `current_speed = BASE_SPEED * GameManager.speed_multiplier`

### Speed Persisting After Game Restart
- This should NOT happen! Speed should reset!
- Solution: Verify `GameManager.gd` does NOT load speed multiplier in `_ready()`

---

## 📝 Code Locations (If You Need to Debug)

**Speed multiplier is applied here:**
- File: `res://Scripts/Player.gd`
- Line 56: `var current_speed: float = BASE_SPEED * GameManager.speed_multiplier`

**Speed upgrade is triggered here:**
- File: `res://Scripts/GameManager.gd`
- Line 26: `speed_multiplier = 2.0`

**Shop shows card here:**
- File: `res://Scripts/Shop.gd`
- Lines 13-18: Speed upgrade card creation

---

## 🎯 What Should Be Different

**BEFORE Speed Upgrade:**
- Walk speed: 5.0 units/sec
- Takes 10 seconds to walk 50 units

**AFTER Speed Upgrade:**
- Walk speed: 10.0 units/sec (2x faster)
- Takes 5 seconds to walk 50 units
- You should see a **very noticeable** difference!

---

**Ready to test? Start the game and try it out!** 🚀
