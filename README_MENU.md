# 🎮 Complete Godot 4 Main Menu System

A **fully functional, production-ready main menu** for Godot 4.2+ with a professional design, settings panel, and smooth navigation.

![Godot 4.6+](https://img.shields.io/badge/Godot-4.2%2B-blue)
![GDScript](https://img.shields.io/badge/Language-GDScript-green)
![License](https://img.shields.io/badge/License-MIT-yellow)

---

## ✨ Features

✅ **Complete Menu System**
- Professional dark theme with centered layout
- Responsive button design with proper spacing
- Title label with game name ("VOIDFEAST")
- Smooth transitions between states

✅ **Fully Functional Buttons**
- **PLAY** → Transitions to game scene
- **SETTINGS** → Opens modal settings panel
- **QUIT** → Exits the application
- **BACK** → Closes settings and returns to menu

✅ **Settings Panel**
- Master Volume slider (0-100, default: 80)
- Music Volume slider (0-100, default: 70)
- SFX Volume slider (0-100, default: 80)
- Semi-transparent dark overlay
- Dedicated back button

✅ **User Experience**
- Keyboard navigation (TAB/Shift+TAB, ENTER)
- Mouse click support
- Automatic focus management
- Button focus states
- Clean, intuitive UI

✅ **Code Quality**
- Fully type-hinted GDScript (no `var x` without types)
- Proper `class_name` declarations
- Comprehensive inline documentation
- Modular, extensible architecture
- Signal-based communication
- Error handling and logging

---

## 📦 What's Included

```
res://
├── Scenes/
│   ├── MainMenu.tscn              # Main menu scene
│   ├── SettingsMenu.tscn          # Settings panel (reusable)
│   └── game.tscn                  # Placeholder game scene
│
├── Scripts/
│   ├── MainMenu.gd                # Main menu controller
│   └── SettingsMenu.gd            # Settings controller
│
├── Documentation/
│   ├── README_MENU.md             # This file
│   ├── QUICKSTART.md              # 30-second setup guide
│   ├── MENU_DOCUMENTATION.md      # Complete technical reference
│   └── MENU_EXTENSIONS.gd         # Ready-to-use code snippets
```

---

## 🚀 Quick Start (30 Seconds)

### 1. Set as Main Scene
```
Right-click res://Scenes/MainMenu.tscn → "Set as Main Scene"
```

### 2. Run the Game
```
Press F5 or click the Run button (▶)
```

### 3. Done! 🎉
The menu appears and all buttons work immediately.

---

## 📋 File Structure & Dependencies

### MainMenu.tscn (The Main Menu Scene)
```
MainMenu (Control) [MainMenu.gd]
├── ColorRect (background)
├── VBoxContainer (layout)
│   ├── TitleLabel ("VOIDFEAST")
│   ├── Spacer1
│   ├── PlayButton
│   ├── SettingsButton
│   ├── QuitButton
│   └── Spacer2
└── SettingsPanel (instance of SettingsMenu.tscn) [hidden by default]
```

### SettingsMenu.tscn (The Settings Panel)
```
SettingsPanel (Control) [SettingsMenu.gd]
├── ColorRect (semi-transparent overlay)
└── VBoxContainer (layout)
    ├── TitleLabel ("SETTINGS")
    ├── Spacer1
    ├── MasterVolumeContainer
    │   ├── MasterVolumeLabel
    │   └── MasterVolumeSlider
    ├── MusicVolumeContainer
    │   ├── MusicVolumeLabel
    │   └── MusicVolumeSlider
    ├── SFXVolumeContainer
    │   ├── SFXVolumeLabel
    │   └── SFXVolumeSlider
    ├── Spacer2
    └── BackButton
```

---

## 🎯 Button Behaviors

### Play Button
**Location**: MainMenu.tscn → VBoxContainer/PlayButton  
**Script**: MainMenu.gd → `_on_play_button_pressed()`  
**Action**: Loads `res://Scenes/game.tscn` with console logging  
**Customizable**: Yes - change the path in the method

### Settings Button
**Location**: MainMenu.tscn → VBoxContainer/SettingsButton  
**Script**: MainMenu.gd → `_on_settings_button_pressed()`  
**Action**: Shows the SettingsPanel (toggles visibility)  
**Customizable**: Yes - can add animations or transitions

### Quit Button
**Location**: MainMenu.tscn → VBoxContainer/QuitButton  
**Script**: MainMenu.gd → `_on_quit_button_pressed()`  
**Action**: Exits the game using `get_tree().quit()`  
**Customizable**: Yes - can add confirmation dialog

### Back Button (Settings)
**Location**: SettingsMenu.tscn → VBoxContainer/BackButton  
**Script**: SettingsMenu.gd → `_on_back_pressed()`  
**Action**: Hides settings panel and emits signal  
**Customizable**: Yes - can save settings before closing

---

## 🎨 Customization Guide

### Change Game Name
1. Open `res://Scenes/MainMenu.tscn`
2. Select `VBoxContainer/TitleLabel` in the Scene tree
3. In the Inspector, change `Text` from "VOIDFEAST" to your game name

### Change Button Colors
1. Open `res://Scenes/MainMenu.tscn`
2. Select `ColorRect` (the background)
3. In the Inspector, click `Color` and choose your color
4. Repeat for `SettingsMenu.tscn`

Example colors:
- Dark Blue: `Color(0.1, 0.1, 0.2, 1)`
- Dark Green: `Color(0.1, 0.15, 0.1, 1)`
- Dark Purple: `Color(0.15, 0.1, 0.15, 1)`

### Change Button Size
1. Select any button in the Scene tree
2. In the Inspector, find `Custom Minimum Size`
3. Modify Width and Height values

Current: `Vector2(300, 50)` (300px wide, 50px tall)

### Change Button Text
1. Select any button in the Scene tree
2. In the Inspector, find `Text` property
3. Change the text

Example:
- "PLAY" → "START GAME"
- "SETTINGS" → "OPTIONS"
- "QUIT" → "EXIT"

### Adjust Spacing
1. Select `VBoxContainer` in MainMenu
2. In the Inspector, adjust `Separation` property
3. Current default is suitable for most displays

---

## 🔧 Advanced Customization

### Add Button Sounds
See **MENU_EXTENSIONS.gd** → "EXTENSION 1: Button Click Sound Effects"

```gdscript
# Example: Play sound on button press
func _on_play_button_pressed() -> void:
    sfx_player.play()
    await get_tree().create_timer(0.2).timeout
    get_tree().change_scene_to_file("res://Scenes/game.tscn")
```

### Save Settings to File
See **MENU_EXTENSIONS.gd** → "EXTENSION 2: Save and Load Settings"

```gdscript
# Example: Save volume settings
func save_settings() -> void:
    var config: ConfigFile = ConfigFile.new()
    config.set_value("audio", "master_volume", master_volume_slider.value)
    config.save("user://game_settings.cfg")
```

### Real Audio Control
See **MENU_EXTENSIONS.gd** → "EXTENSION 3: Real AudioServer Volume Control"

```gdscript
# Example: Control actual audio buses
func _on_master_volume_changed(value: float) -> void:
    var bus_index: int = AudioServer.get_bus_index("Master")
    var db: float = linear2db(value / 100.0)
    AudioServer.set_bus_volume_db(bus_index, db)
```

### Close Settings with ESC Key
See **MENU_EXTENSIONS.gd** → "EXTENSION 4: Close Settings with ESC Key"

```gdscript
# Example: Handle escape key
func _input(event: InputEvent) -> void:
    if event is InputEventKey and event.pressed:
        if event.keycode == KEY_ESCAPE and settings_panel.visible:
            _on_settings_closed()
```

### Add Animations
See **MENU_EXTENSIONS.gd** → "EXTENSION 5: Fade Animations on Scene Transitions"

---

## 📖 Script Documentation

### MainMenu.gd

**Class Name**: `MainMenu`  
**Extends**: `Control`

**Properties**:
- `play_button: Button` - Reference to Play button
- `settings_button: Button` - Reference to Settings button
- `quit_button: Button` - Reference to Quit button
- `title_label: Label` - Reference to Title label
- `settings_panel: Control` - Reference to Settings panel

**Methods**:
```gdscript
func _ready() -> void
    # Initializes button connections and focus
    # Called when scene enters the tree

func _on_play_button_pressed() -> void
    # Handles Play button click
    # Loads game scene: res://Scenes/game.tscn

func _on_settings_button_pressed() -> void
    # Handles Settings button click
    # Shows settings panel

func _on_quit_button_pressed() -> void
    # Handles Quit button click
    # Exits the application

func _on_settings_closed() -> void
    # Callback when settings panel closes
    # Restores focus to Settings button
```

### SettingsMenu.gd

**Class Name**: `SettingsMenu`  
**Extends**: `Control`

**Signals**:
```gdscript
signal settings_closed()
    # Emitted when settings panel closes
```

**Properties**:
- `back_button: Button` - Reference to Back button
- `master_volume_slider: HSlider` - Master Volume slider
- `music_volume_slider: HSlider` - Music Volume slider
- `sfx_volume_slider: HSlider` - SFX Volume slider
- `on_close_callback: Callable` - Optional close callback

**Methods**:
```gdscript
func _ready() -> void
    # Initializes sliders and button
    # Sets initial values

func _on_master_volume_changed(value: float) -> void
    # Called when master volume slider changes
    # Currently logs to console (see extensions for real implementation)

func _on_music_volume_changed(value: float) -> void
    # Called when music volume slider changes

func _on_sfx_volume_changed(value: float) -> void
    # Called when SFX volume slider changes

func _on_back_pressed() -> void
    # Called when Back button is clicked
    # Hides panel and emits signal

func set_on_close_callback(callback: Callable) -> void
    # Sets a callback to be called when settings close
    # Used by MainMenu for focus restoration
```

---

## ⌨️ Input Controls

| Input | Action |
|-------|--------|
| **Left Mouse Click** | Activate focused button or click any button |
| **TAB** | Move focus to next button |
| **Shift + TAB** | Move focus to previous button |
| **ENTER/SPACE** | Activate focused button |
| **ESC** | (Optional - see extensions) Close settings panel |

---

## 🧪 Testing Checklist

- [ ] Main menu appears on game start
- [ ] Title "VOIDFEAST" is visible
- [ ] All three buttons (PLAY, SETTINGS, QUIT) are visible
- [ ] PLAY button transitions to game scene
- [ ] SETTINGS button opens settings panel
- [ ] Settings panel has dark overlay
- [ ] All three volume sliders are visible and movable
- [ ] BACK button closes settings panel
- [ ] Focus returns to SETTINGS button after close
- [ ] QUIT button exits the game
- [ ] Keyboard navigation works (TAB/ENTER)
- [ ] Mouse clicks work on all buttons
- [ ] No console errors or warnings

---

## 🐛 Troubleshooting

### "Settings panel doesn't appear"
**Solution**: 
1. Check that SettingsPanel exists in MainMenu scene tree
2. Verify it's set to `visible = false` in the Inspector
3. Look for errors in Output panel (View → Output)

### "Buttons don't respond"
**Solution**:
1. Check Output panel for error messages
2. Verify button signal connections at bottom of MainMenu.tscn
3. Ensure @onready names match node names

### "Game scene won't load"
**Solution**:
1. Verify `res://Scenes/game.tscn` exists
2. Check the exact path in MainMenu.gd line 29
3. Look at Output panel for error messages

### "Settings menu appears off-center"
**Solution**:
1. Check SettingsPanel anchors and offsets
2. Verify VBoxContainer alignment settings
3. Adjust offset values if needed

### "Volume sliders are unresponsive"
**Solution**:
1. Check that slider signal connections exist in SettingsMenu.tscn
2. Verify slider step values aren't too high
3. Look at Output panel for error messages

---

## 🚀 Next Steps

### Beginner Level
1. ✅ Get menu working (you're done!)
2. Replace "VOIDFEAST" with your game name
3. Change button colors to match your brand
4. Test all button functionality

### Intermediate Level
5. Add button click sounds (see MENU_EXTENSIONS.gd)
6. Implement settings save/load (see MENU_EXTENSIONS.gd)
7. Replace placeholder game scene with real game
8. Add background music to menu

### Advanced Level
9. Create custom theme for consistent styling
10. Add animations and transitions
11. Implement real AudioServer volume control
12. Add more settings (resolution, quality, bindings)
13. Implement main menu music
14. Add particle effects or visual polish

---

## 📚 Additional Resources

- **Quick Start**: See `QUICKSTART.md`
- **Full Documentation**: See `MENU_DOCUMENTATION.md`
- **Code Snippets**: See `MENU_EXTENSIONS.gd`
- **Godot Docs**: https://docs.godotengine.org
- **GDScript Guide**: https://docs.godotengine.org/en/stable/getting_started/scripting/gdscript/index.html

---

## 🎓 Learning from This Project

This menu system demonstrates:
- ✅ Proper scene hierarchy and layout
- ✅ Button signal connections in GDScript
- ✅ Modal panels and visibility toggling
- ✅ Scene transitions with `get_tree().change_scene_to_file()`
- ✅ Focus management for keyboard navigation
- ✅ Type hints for all variables and functions
- ✅ `@onready` node references
- ✅ Proper signal usage and callbacks
- ✅ Code organization and documentation

---

## 💡 Pro Tips

1. **Always type-hint variables** - Makes code clearer and prevents bugs
2. **Use @onready for node references** - Automatic null checking
3. **Connect signals in _ready()** - Standard practice in Godot
4. **Use descriptive function names** - `_on_play_button_pressed()` is clear
5. **Add console logging** - Helps debug button presses
6. **Group related nodes** - Use containers for layout control
7. **Test keyboard + mouse** - Both input methods matter
8. **Document customization points** - Others may modify your menu

---

## 📝 License

This menu system is provided as-is for your Godot 4 projects.

---

## 🎉 Summary

You now have a **complete, production-ready main menu system** with:
- 3 functional buttons (Play, Settings, Quit)
- Settings panel with volume sliders
- Professional design
- Full keyboard support
- Comprehensive documentation
- Ready-to-use code extensions

**Next**: Customize it for your game and start building! 🚀

---

**Created for Godot 4.2+**  
**Last Updated**: 2024  
**Version**: 1.0.0
