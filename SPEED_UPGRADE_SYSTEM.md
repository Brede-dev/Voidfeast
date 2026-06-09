# Speed Upgrade System

## Overview
A speed upgrade system has been added to the Voidfeast game. Once the player collects 10 items, a "Speed Boost" upgrade appears in the shop for 10 items. When purchased, the player's movement speed increases by 1.5x (from 5.0 to 7.5 units per second).

## How It Works

### 1. **Collection Phase**
- Player collects food items during levels
- Each item collected increases `GameManager.total_food_owned`
- No speed upgrade available until 10 items are collected

### 2. **Shop Display**
- When `total_food_owned >= 10`, the "Speed Boost" card appears in the Shop
- The speed upgrade costs 10 items (same as other shop items)
- It will only appear once and disappears after purchase

### 3. **Purchase**
- Player clicks the "Speed Boost" card when they have 10+ items
- Cost is deducted from `total_food_owned`
- Upgrade is permanently saved to `user://speed_upgrades.save`
- The item is marked as purchased in `user://purchased_items.save`

### 4. **Speed Application**
- Speed multiplier is loaded on game startup
- Player speed is calculated as: `current_speed = BASE_SPEED * speed_multiplier`
- Base speed is 5.0, multiplier is 1.5, resulting in 7.5 units/second
- Applies immediately when player enters a level

## Modified Files

### GameManager.gd
**New Variables:**
- `speed_multiplier: float = 1.0` - Tracks the current speed multiplier

**New Signals:**
- `speed_upgraded(new_multiplier: float)` - Emitted when speed upgrade is purchased

**New Functions:**
- `apply_speed_upgrade()` - Sets multiplier to 1.5 and emits signal
- `save_speed_upgrades()` - Persists speed multiplier to disk
- `load_speed_upgrades()` - Loads speed multiplier from disk on startup

**Modified Functions:**
- `_ready()` - Now calls `load_speed_upgrades()`
- `add_purchased_item(item_id)` - Now calls `apply_speed_upgrade()` if item_id is "speed_upgrade"
- `_on_restart_button_pressed()` - Now resets `speed_multiplier` and clears speed upgrade save file

### player.gd
**New Variables:**
- `current_speed: float = BASE_SPEED` - Tracks current movement speed

**Modified Constants:**
- Changed `SPEED` to `BASE_SPEED` for clarity

**Modified Functions:**
- `_ready()` - Now calls `update_speed_from_multiplier()` and connects to `speed_upgraded` signal
- `_physics_process()` - Now uses `current_speed` instead of `SPEED`

**New Functions:**
- `update_speed_from_multiplier()` - Calculates current speed from multiplier
- `_on_speed_upgraded(new_multiplier)` - Callback when speed is upgraded

### Shop.gd
**Modified Functions:**
- `_ready()` - Now adds "Speed Boost" card when conditions are met (10+ items, not purchased)
- `_on_restart_button_pressed()` - Now also resets `speed_multiplier` and deletes speed upgrade save file

### SellThing.gd
**New Variables:**
- `title_label: Label` - Optional reference to display item title

**Modified Functions:**
- `_ready()` - Now sets title to "Speed Boost" for speed upgrade items

## Game Flow

```
Gameplay Loop:
  ↓
Collect 10+ Items
  ↓
Speed Boost Appears in Shop
  ↓
Click Speed Boost (costs 10 items)
  ↓
Speed increases to 1.5x (7.5 units/sec)
  ↓
Speed persists across levels and game restarts
  ↓
Next level or game restart uses upgraded speed
```

## Save Files

### speed_upgrades.save
- Location: `user://speed_upgrades.save`
- Contains: Float value of speed multiplier (1.0 or 1.5)
- Created/Updated: When speed upgrade is purchased
- Loaded: On GameManager startup

### purchased_items.save
- Location: `user://purchased_items.save`
- Contains: Array of purchased item IDs including "speed_upgrade"
- Prevents the speed upgrade from appearing again after purchase

## Testing the System

To test the speed upgrade system:

1. **Manual Testing:**
   - Start a new game
   - Collect 10 items
   - Go to shop - "Speed Boost" should appear
   - Click "Speed Boost" to purchase
   - Return to game - player should move faster

2. **Verification:**
   - Check console for: "Speed upgraded! New multiplier: 1.5 New speed: 7.5"
   - Notice player movement speed increase
   - Quit game and restart - speed boost should persist

## Configuration

To modify the speed upgrade:

**In GameManager.gd - apply_speed_upgrade():**
```gdscript
func apply_speed_upgrade() -> void:
	speed_multiplier = 1.5  # Change this value to adjust multiplier
	emit_signal("speed_upgraded", speed_multiplier)
```

**In Shop.gd - _ready():**
```gdscript
if GameManager.total_food_owned >= 10 and not GameManager.is_item_purchased("speed_upgrade"):
	# Change cost here:
	speed_upgrade.cost = 10
	# Change minimum items required:
	# Change condition from >= 10 to >= 20, etc.
```

## Future Enhancements

Possible expansions to this system:
- Multiple tier speed upgrades (1.25x, 1.5x, 2.0x)
- Visual feedback when speed is upgraded (particle effects, sound)
- Display current speed multiplier in HUD
- Speed boost duration (temporary instead of permanent)
- Stackable speed upgrades
