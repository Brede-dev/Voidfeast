# Timer Setup Guide for Voidfeast

## ✅ I've Added Timer Functionality - Here's How to Use It

---

## **Option 1: Simple Elapsed Time Display** ✨ (ALREADY IMPLEMENTED)

Shows how long the player has been in the game.

### What was added:
- ✅ `TimerLabel` added to HUD scene
- ✅ HUD.gd updated to track and display elapsed time
- Displays in format: `0:00` (minutes:seconds)

### How to use:
The timer will automatically start when the level loads. No additional setup needed!

---

## **Option 2: Countdown Timer** ⏱️ (READY TO USE)

Shows a countdown from a time limit (useful for time-based challenges).

### What was added:
- ✅ Time limit variables in GameManager
- ✅ `start_timer()` and `stop_timer()` functions in GameManager
- ✅ `time_over` signal in GameManager
- ✅ HUD handles both elapsed and countdown

### How to use:

**In LevelManager.gd or any script:**

```gdscript
# Start a 5-minute countdown timer
GameManager.start_timer(300.0)  # 300 seconds = 5 minutes

# Show countdown in HUD
get_node("CanvasLayer").show_countdown = true

# When timer reaches zero, this signal fires:
GameManager.time_over.connect(_on_game_time_over)

func _on_game_time_over() -> void:
	print("Time's up!")
	# End level, show game over screen, etc.
```

---

## **Option 3: Advanced Timer Node** 🎯 (CUSTOM IMPLEMENTATION)

For more control, use the GameTimer class.

### What was added:
- ✅ GameTimer.gd script (class_name: GameTimer)

### How to use:

**In your scene editor:**
1. Add a Timer node to your scene
2. Attach the `GameTimer.gd` script to it
3. In your script:

```gdscript
func _ready() -> void:
	# Find the timer node
	var timer: GameTimer = $GameTimer
	timer.set_display_label($HUD/TimerLabel)
	
	# Start elapsed time timer
	timer.start_elapsed_timer()
	
	# OR start a countdown
	# timer.start_countdown_timer(300.0)  # 5 minutes

func _process(delta: float) -> void:
	# You can check remaining time
	var time: float = timer.elapsed
```

---

## 📊 Quick Comparison

| Feature | Option 1 | Option 2 | Option 3 |
|---------|----------|----------|----------|
| **Complexity** | ⭐ Simple | ⭐⭐ Medium | ⭐⭐⭐ Advanced |
| **Elapsed Time** | ✅ Yes | ✅ Yes | ✅ Yes |
| **Countdown** | ❌ No | ✅ Yes | ✅ Yes |
| **Pause Support** | ❌ No | ❌ No | ✅ Yes |
| **Setup Time** | 5 min | 5 min | 10 min |
| **Recommended For** | All games | Time-based levels | Complex games |

---

## 🚀 Next Steps

### To use **Option 1** (Elapsed Time - Default):
Nothing! It's already working. Run the game and you'll see the timer in the top-left.

### To use **Option 2** (Countdown Timer):
1. Open your LevelManager.gd
2. In `_ready()`, add:
   ```gdscript
   GameManager.start_timer(300.0)  # 5 minutes
   var hud: CanvasLayer = get_node("CanvasLayer")
   hud.show_countdown = true
   ```

### To use **Option 3** (GameTimer Node):
1. Open Level1.tscn in the editor
2. Add a Timer node under the root
3. Rename it to "GameTimer"
4. Attach res://Scripts/GameTimer.gd to it
5. In your level script, call timer methods as shown above

---

## 📝 Files Modified/Created

- ✅ `res://Scripts/HUD.gd` - Updated with timer display
- ✅ `res://Scenes/HUD.tscn` - Added TimerLabel
- ✅ `res://Scripts/GameManager.gd` - Added countdown timer support
- ✅ `res://Scripts/GameTimer.gd` - New optional Timer class

---

## 💡 Tips & Tricks

### Freeze the timer during pause:
```gdscript
# In your pause logic
GameManager.stop_timer()
```

### Format the timer differently:
```gdscript
# Show milliseconds
var millis: int = int((elapsed * 1000) % 1000)
label.text = "%d:%02d.%03d" % [minutes, seconds, millis]
```

### Warn player when time is running low:
```gdscript
if GameManager.time_remaining < 60.0 and GameManager.time_remaining > 0.0:
	# Flash the timer label
	pass
```

---

That's it! Your timer is ready to use. Let me know if you need help customizing it! 🎮
