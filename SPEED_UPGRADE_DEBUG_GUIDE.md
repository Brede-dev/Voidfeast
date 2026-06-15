# Speed Upgrade System - Debug & Testing Guide

## ✅ What Was Just Fixed

1. **Removed conflicting `class_name` declarations** that were preventing scripts from loading
2. **Added debug output** to track when speed upgrades are purchased and applied
3. **Set speed multiplier back to 2.0** (was 10.0 for testing)
4. **Added print statements** in 3 key locations for debugging

---

## 🔍 Debug Output Locations

### 1. **GameManager.gd - Line 26**
When you purchase the speed upgrade, you'll see:
```
⚡ SPEED UPGRADE APPLIED! speed_multiplier = 2.0
```

### 2. **SellThing.gd - Line 52**
When you click a shop card, you'll see:
```
🛒 Purchasing item: speed_upgrade
```

### 3. **Player.gd - Line 57**
Every frame while moving with boost active, you'll see:
```
🎮 Current Speed: 10.0 (BASE: 5.0 × Multiplier: 2.0)
```

---

## 🧪 Step-by-Step Testing

### Test Case 1: Purchase Speed Upgrade
1. Start the game
2. Collect 10 items (press E to collect near items)
3. Open the Shop
4. **Expected Output:**
   - See "Speed Boost" card with cost "10"
   - Click it
   - See: `🛒 Purchasing item: speed_upgrade`
   - See: `⚡ SPEED UPGRADE APPLIED! speed_multiplier = 2.0`

### Test Case 2: Verify Speed Doubles
5. Enter a level
6. Move the player (WASD keys)
7. **Expected Output:**
   - See: `🎮 Current Speed: 10.0 (BASE: 5.0 × Multiplier: 2.0)`
   - Player movement is noticeably FASTER
   - Without boost: `🎮 Current Speed: 5.0 (BASE: 5.0 × Multiplier: 1.0)`

### Test Case 3: Items Persist
8. Collect items on Level 1
9. Complete level and go to Level 2
10. **Expected:** Item count persists, speed multiplier is 2.0

---

## 🐛 Troubleshooting

### Issue: Speed Upgrade card doesn't appear in shop
**Solution:** Check the Output tab for errors. Make sure:
- You have 10+ items collected
- Speed multiplier = 1.0 (not already upgraded)
- ShopScript.gd is attached to Shop.tscn

### Issue: Clicking card doesn't purchase
**Solution:** Check Output tab for:
- `🛒 Purchasing item:` message
- If not appearing, the click detection might be failing
- Check that SellThing has correct exports set in inspector

### Issue: Speed doesn't change after purchase
**Solution:** Check Output tab for:
- `⚡ SPEED UPGRADE APPLIED!` message
- If not appearing, `add_purchased_item()` isn't being called
- Check that item_id exactly matches "speed_upgrade"

### Issue: Movement still slow
**Solution:** Open Output tab and look for:
- `🎮 Current Speed:` messages
- If multiplier shows 1.0, purchase didn't work
- If multiplier shows 2.0 but movement looks same, could be delta time or velocity issues

---

## 📊 Expected Console Output Timeline

```
[Start Game]
(no output - speed is normal)

[Collect 10 items]
(no output - just collecting)

[Go to Shop]
(no output - shopping)

[Click Speed Boost Card]
🛒 Purchasing item: speed_upgrade
⚡ SPEED UPGRADE APPLIED! speed_multiplier = 2.0

[Enter Level]
(no output - standing still)

[Move Player (Press WASD)]
🎮 Current Speed: 10.0 (BASE: 5.0 × Multiplier: 2.0)
🎮 Current Speed: 10.0 (BASE: 5.0 × Multiplier: 2.0)
🎮 Current Speed: 10.0 (BASE: 5.0 × Multiplier: 2.0)
(repeats while moving)

[Stop Moving]
(no output)
```

---

## 🔧 If Still Not Working

Try these steps in order:

1. **Clear output logs** (call `clear_output_logs`)
2. **Open Player.gd** in editor to force reload
3. **Open GameManager.gd** in editor to force reload
4. **Open SellThing.gd** in editor to force reload
5. **Restart Godot** if still having issues
6. **Check for typos** in item_id - must be exactly `"speed_upgrade"`

---

## 📝 Key Code Locations

| What | File | Line |
|------|------|------|
| Apply speed boost | GameManager.gd | 25-28 |
| Use speed in movement | player.gd | 55-57 |
| Purchase item | SellThing.gd | 51-53 |
| Create speed card | ShopScript.gd | 14-21 |

---

## 💡 How It Should Work

```
Player clicks card
    ↓
SellThing._input() detects click (line 37-44)
    ↓
SellThing.mark_as_purchased() (line 51)
    ↓
GameManager.add_purchased_item("speed_upgrade") (line 68-74)
    ↓
Checks if item_id == "speed_upgrade" → YES
    ↓
Calls apply_speed_upgrade() (line 74)
    ↓
Sets speed_multiplier = 2.0 (line 26)
    ↓
Emits speed_upgraded signal (line 27)
    ↓
Player script reads GameManager.speed_multiplier every frame (line 56)
    ↓
current_speed = 5.0 * 2.0 = 10.0 (DOUBLE SPEED!) ✅
```

---

If you're still seeing issues, look for these messages in the Output tab:
- ❌ `⚡ SPEED UPGRADE APPLIED!` - Not appearing? Purchase logic isn't running
- ❌ `🛒 Purchasing item:` - Not appearing? Click detection failing
- ❌ `🎮 Current Speed:` - Not appearing? Player isn't moving or multiplier is 1.0
