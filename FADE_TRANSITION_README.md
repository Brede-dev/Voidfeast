# Fade Transition System - Usage Guide

## Overview
A reusable fade transition system for scene changes in your Godot game. The system smoothly fades the screen to black before changing scenes and fades back in afterwards.

## Files Created

1. **res://Scenes/FadeTransition.tscn** - Scene file with the fade transition UI
2. **res://Scripts/FadeTransition.gd** - GDScript with fade logic and scene management

## Node Structure

```
FadeTransition (CanvasLayer, layer=100) [FadeTransition.gd]
├── ColorRect (full-screen overlay, Color 0,0,0,0)
└── AnimationPlayer (manages fade animations)
```

### Node Details
- **FadeTransition (CanvasLayer)**
  - Layer: 100 (renders on top of everything)
  - Attached Script: FadeTransition.gd (fully typed GDScript)
  
- **ColorRect**
  - Covers entire viewport with anchors set to full screen
  - Initial color: fully transparent black (0,0,0,0)
  - Animates alpha from 0→1 (fade_out) and 1→0 (fade_in)

- **AnimationPlayer**
  - Manages fade_out and fade_in animations
  - Animations created dynamically in script's _ready() function

## Animations

### fade_out (1.0 second)
- ColorRect color: `(0,0,0,0)` → `(0,0,0,1)`
- Smoothly fades screen to black over 1 second
- Used before scene changes

### fade_in (1.0 second)
- ColorRect color: `(0,0,0,1)` → `(0,0,0,0)`
- Smoothly fades from black back to transparent over 1 second
- Used after scene loads

## API Functions

### Main Function: fade_to_scene()
```gdscript
await fade_transition.fade_to_scene("res://Scenes/YourScene.tscn")
```
- Plays fade_out → changes scene → plays fade_in
- Awaitable function (use `await` to wait for completion)
- Handles scene change automatically

### Helper Functions

#### fade_out()
```gdscript
await fade_transition.fade_out()
```
- Only plays fade_out animation
- Useful for custom transitions

#### fade_in()
```gdscript
await fade_transition.fade_in()
```
- Only plays fade_in animation
- Useful for custom transitions

#### set_fade_duration(duration: float)
```gdscript
fade_transition.set_fade_duration(0.5)  # 0.5 second fades
```
- Changes duration of both fade animations
- Call before any fade transitions
- Default: 1.0 second

#### get_color_rect()
```gdscript
var rect: ColorRect = fade_transition.get_color_rect()
```
- Returns the ColorRect node for advanced customization
- Allows changing fade color or custom alpha manipulation

## Setup Instructions

### 1. Add FadeTransition to Your Main Scene
In your main game scene or autoload, add an instance of FadeTransition:
```gdscript
# In your main scene script
@onready var fade_transition: FadeTransition = $FadeTransition
```

### 2. Use in Scene Changes
From any script, call the fade function:
```gdscript
# In player script, menu script, etc.
var fade_transition: FadeTransition = get_tree().root.get_node("FadeTransition")
await fade_transition.fade_to_scene("res://Scenes/GameScene.tscn")
```

### 3. Or Add as Autoload (Recommended)
Add to Project Settings → Autoload:
- **Path:** res://Scenes/FadeTransition.tscn
- **Node Name:** FadeTransition

Then use from anywhere:
```gdscript
await FadeTransition.fade_to_scene("res://Scenes/NextScene.tscn")
```

## Example Usage

### Basic Scene Transition (with fade)
```gdscript
# In menu button script
func _on_start_button_pressed() -> void:
	await FadeTransition.fade_to_scene("res://Scenes/GameScene.tscn")
```

### Custom Fade Duration
```gdscript
# Faster fade (0.5 seconds)
FadeTransition.set_fade_duration(0.5)
await FadeTransition.fade_to_scene("res://Scenes/NextScene.tscn")

# Reset to default
FadeTransition.set_fade_duration(1.0)
```

### Manual Fade Control
```gdscript
# Fade out, do something, fade in
await FadeTransition.fade_out()
do_something()
await FadeTransition.fade_in()
```

### Custom Fade Color
```gdscript
# Fade to red instead of black
var rect: ColorRect = FadeTransition.get_color_rect()
rect.color = Color.RED  # Or any color you want
await FadeTransition.fade_out()
```

## Technical Details

- **Type-Hinted GDScript:** All variables and functions fully typed
- **Animations Created Dynamically:** Uses AnimationLibrary created in _ready()
- **Async/Await Support:** Uses `await` for clean asynchronous transitions
- **Signal-Based:** Awaits `animation_finished` signal from AnimationPlayer
- **Memory Efficient:** Single ColorRect overlay reused for all transitions

## Customization Tips

1. **Change fade speed:** Use `set_fade_duration()`
2. **Change fade color:** Access via `get_color_rect().color`
3. **Different timing:** Create separate functions or customize in _ready()
4. **UI priority:** CanvasLayer layer 100 ensures it renders above game content

---

You're all set! The fade transition system is ready to use in your game.
