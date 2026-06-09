# Speed Upgrade System - Complete Guide

## Overview
You now have a **persistent speed upgrade system** where items carry over between levels and can be spent on permanent speed boosts.

---

## How It Works

### Game Flow
```
Level 1: Collect 5 items -> Items persist (5 total)
    |
Level 2: Collect 7 items -> You now have 12 items total
    |
    ├─ Option A: Go to shop, buy Speed Upgrade (costs 10 items) -> 2.0x speed forever!
    |
    └─ Option B: Keep collecting to buy other upgrades
```

### HUD Display
The game now shows on screen:
- **Item count** (top left): "X 12" (example with 12 items)
- **Mouse controls** (below items): "Press Left Alt for Mouse Look / Press C for Mouse Lock"
- **Speed upgrade progress** (bottom): Shows your progress toward the upgrade

Example displays:
- `Speed Upgrade: 5/10 items` (collecting)
- `Speed Upgrade: Ready to Buy!` (have 10+, not purchased)
- `Speed Upgrade: ✓ ACTIVE (2.0x faster)` (purchased)

---

## Technical Details

### GameManager Changes
New functions and variables:

```gdscript
# Variables
var total_food_owned: int  # PERSISTS between levels!
var speed_multiplier: float = 1.0  # 1.0 = normal, 2.0 = 2x faster

# New Functions
can_afford_speed_upgrade() -> bool  # Returns true if you have 10+ items
purchase_speed_upgrade() -> bool    # Spend 10 items to upgrade (returns success)
save_total_food()                   # Saves items to user://total_food.save
load_total_food()                   # Loads items on startup
```

### Player Changes
```gdscript
const BASE_SPEED: float = 5.0
var current_speed: float

func _physics_process(delta):
    current_speed = BASE_SPEED * GameManager.speed_multiplier
    velocity.x = input_dir.x * current_speed
```

### Shop Changes
Speed Boost card automatically appears when you have 10+ items.

### HUD Changes
New **SpeedUpgradeLabel** displays at bottom showing progress.

---

## Persistence

### What Gets Saved
1. **total_food.save** - Your total items across all levels
2. **speed_upgrades.save** - Your speed multiplier (1.0 or 2.0)
3. **purchased_items.save** - Which shop items you've bought

### What Resets
- **Restart Button** in Shop scene resets everything:
  - Items back to 0
  - Speed multiplier back to 1.0
  - All purchased items cleared
  - All save files deleted

---

## Testing the System

### Quick Test 1: Items Persist
1. Start Level 1
2. Collect 3 items
3. Go to Shop (beat level)
4. See "Speed Upgrade: 3/10 items"
5. Start Level 2
6. Collect 7 more items
7. Should see "Speed Upgrade: 10/10 items" -> "Speed Upgrade: Ready to Buy!"

### Quick Test 2: Purchase Speed Upgrade
1. Have 10+ items
2. Go to Shop
3. "Speed Boost" card appears
4. Click it (costs 10 items)
5. Items drop to (your_count - 10)
6. Starts saying "Speed Upgrade: ✓ ACTIVE (2.0x faster)"
7. Move to next level - you stay 2.0x faster!

### Quick Test 3: Reset
1. Click "Restart" button in Shop
2. All items → 0
3. Speed back to normal
4. Speed Upgrade card disappears
5. Start fresh

---

## Customizing Speed

To change the speed multiplier (currently 2.0x), edit **GameManager.gd** line 26:

```gdscript
func apply_speed_upgrade() -> void:
    speed_multiplier = 2.0  # Change this number!
```

Examples:
- `1.5` = 1.5x speed (50% faster)
- `2.0` = 2x speed (double) ← current
- `2.5` = 2.5x speed
- `3.0` = 3x speed (triple)

---

## File Structure

### Save Files (in user:// directory)
```
user://
  ├── total_food.save           # Your item count
  ├── speed_upgrades.save       # Speed multiplier
  └── purchased_items.save      # Bought items
```

### Scripts Modified
```
res://Scripts/
  ├── GameManager.gd            # Core upgrade logic + persistence
  ├── HUD.gd                     # Display upgrades on screen
  ├── Shop.gd                    # Show Speed Boost card
  ├── SellThing.gd              # Handle purchases
  └── player.gd                 # Use speed multiplier
```

### Scenes Modified
```
res://Scenes/
  └── HUD.tscn                  # Added SpeedUpgradeLabel
```

---

## Troubleshooting

### Items not persisting
- Check that `collect_food()` is being called when you pick up items
- Verify `GameManager.save_total_food()` is called
- Check `user://total_food.save` exists

### Speed upgrade doesn't work
- Verify `player.gd` uses `GameManager.speed_multiplier`
- Check `apply_speed_upgrade()` is called when purchased
- Look for console errors (View → Toggle Console)

### Speed Boost card not appearing
- Must have exactly 10+ items
- Must not have already purchased it
- Check `GameManager.can_afford_speed_upgrade()` returns true

### Can't reset the game
- Make sure you're in the Shop scene
- Look for a "Restart" button
- It should call `_on_restart_button_pressed()`

---

## Console Debugging

In the game, you can print debug info:

```gdscript
print("Items: %d" % GameManager.total_food_owned)
print("Speed multiplier: %.1f" % GameManager.speed_multiplier)
print("Can afford upgrade: %s" % GameManager.can_afford_speed_upgrade())
```

View output: **View → Toggle Console** (in Godot editor)

---

## Summary

✅ Items **persist** between levels
✅ Collect 10+ items to unlock Speed Boost
✅ Buy Speed Boost (costs 10 items) for **permanent 2.0x speed**
✅ Speed stays active across all future levels
✅ Restart button resets everything
✅ Full persistence system with auto-save

Enjoy your speed upgrades! 🚀
