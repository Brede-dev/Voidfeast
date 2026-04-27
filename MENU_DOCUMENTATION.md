# Main Menu System Documentation

## Overview
A complete, functional main menu system for Godot 4.2+ with a main menu, settings panel, and smooth transitions. The menu is built entirely in GDScript and uses Godot's native UI nodes.

## File Structure
```
res://
├── Scenes/
│   ├── MainMenu.tscn          # Main menu scene
│   ├── SettingsMenu.tscn      # Settings panel scene
│   └── game.tscn              # Game scene (loaded when Play is pressed)
├── Scripts/
│   ├── MainMenu.gd            # Main menu controller
│   └── SettingsMenu.gd        # Settings panel controller
└── MENU_DOCUMENTATION.md      # This file
```

## Features

### Main Menu (MainMenu.tscn & MainMenu.gd)
- **Title Label**: Displays "VOIDFEAST" at the top
- **Play Button**: Transitions to `res://Scenes/game.tscn`
- **Settings Button**: Opens the settings panel as a modal overlay
- **Quit Button**: Exits the game immediately
- **Responsive Layout**: Uses VBoxContainer for clean, centered layout
- **Button Focus**: Play button is focused by default for keyboard navigation

### Settings Menu (SettingsMenu.tscn & SettingsMenu.gd)
- **Dark Overlay**: Semi-transparent background that dims the main menu
- **Master Volume Slider**: 0-100 scale (default: 80)
- **Music Volume Slider**: 0-100 scale (default: 70)
- **SFX Volume Slider**: 0-100 scale (default: 80)
- **Back Button**: Closes the settings panel and returns to main menu
- **Signal System**: Emits `settings_closed` signal when closed
- **Callback System**: Supports callback functions for close events

## How to Use

### Running the Menu
1. **Set Main Menu as Startup Scene**:
   - In Godot editor, select `res://Scenes/MainMenu.tscn`
   - Click "Scene > Set As Main Scene" from the menu bar
   - Or in the FileSystem, right-click MainMenu.tscn → "Set as Main Scene"

2. **Run the Scene**:
   - Press F5 or click "Run" button to start the game
   - The main menu will appear

### Navigation
- **Mouse**: Click buttons directly
- **Keyboard**: 
  - TAB/Shift+TAB to navigate between buttons
  - ENTER to press focused button
  - ESC to close settings panel (not implemented yet, but can be added)

### Button Behaviors

#### Play Button
```gdscript
# Loads the game scene
get_tree().change_scene_to_file("res://Scenes/game.tscn")
```

#### Settings Button
```gdscript
# Shows the settings panel
settings_panel.visible = true
```

#### Quit Button
```gdscript
# Exits the game
get_tree().quit()
```

#### Settings Back Button
```gdscript
# Hides the settings panel and returns to main menu
visible = false
settings_closed.emit()
```

## Customization

### Changing the Game Name
Edit `res://Scenes/MainMenu.tscn` and modify the TitleLabel text:
```
[node name="TitleLabel" type="Label" parent="VBoxContainer"]
text = "YOUR_GAME_NAME"
```

### Changing Button Text
Edit the text properties in `MainMenu.tscn`:
```
[node name="PlayButton" type="Button" parent="VBoxContainer"]
text = "START_GAME"

[node name="SettingsButton" type="Button" parent="VBoxContainer"]
text = "OPTIONS"
```

### Styling & Colors
Edit the ColorRect background colors in the .tscn files:
```
[node name="ColorRect" type="ColorRect" parent="."]
color = Color(0.1, 0.1, 0.15, 1)  # RGBA (0-1 scale)
```

### Volume Slider Ranges
Edit slider properties in `SettingsMenu.tscn`:
```
[node name="MasterVolumeSlider" type="HSlider" parent="VBoxContainer/MasterVolumeContainer"]
min_value = 0.0
max_value = 100.0
step = 1.0
value = 80.0
```

### Button Size & Layout
Edit custom_minimum_size in the .tscn files:
```
[node name="PlayButton" type="Button" parent="VBoxContainer"]
custom_minimum_size = Vector2(300, 50)  # Width x Height
```

## Script Details

### MainMenu.gd

**Nodes**:
- `play_button`: VBoxContainer/PlayButton
- `settings_button`: VBoxContainer/SettingsButton
- `quit_button`: VBoxContainer/QuitButton
- `title_label`: VBoxContainer/TitleLabel
- `settings_panel`: SettingsPanel (child of MainMenu)

**Methods**:
- `_ready()`: Initializes button signals and sets focus
- `_on_play_button_pressed()`: Loads the game scene
- `_on_settings_button_pressed()`: Shows the settings panel
- `_on_quit_button_pressed()`: Exits the game
- `_on_settings_closed()`: Callback when settings panel closes

**Example Extension**:
```gdscript
# Add sound effects to button presses
func _on_play_button_pressed() -> void:
    audio_player.play_sfx("click")
    await get_tree().create_timer(0.2).timeout
    get_tree().change_scene_to_file("res://Scenes/game.tscn")
```

### SettingsMenu.gd

**Nodes**:
- `back_button`: VBoxContainer/BackButton
- `master_volume_slider`: VBoxContainer/MasterVolumeContainer/MasterVolumeSlider
- `music_volume_slider`: VBoxContainer/MusicVolumeContainer/MusicVolumeSlider
- `sfx_volume_slider`: VBoxContainer/SFXVolumeContainer/SFXVolumeSlider

**Signals**:
- `settings_closed`: Emitted when settings panel closes

**Methods**:
- `_ready()`: Initializes sliders and button
- `_on_master_volume_changed(value)`: Handles master volume changes
- `_on_music_volume_changed(value)`: Handles music volume changes
- `_on_sfx_volume_changed(value)`: Handles SFX volume changes
- `_on_back_pressed()`: Closes the settings panel
- `set_on_close_callback(callback)`: Sets a callback for close events

**Example Extension**:
```gdscript
# Implement actual audio volume control
func _on_master_volume_changed(value: float) -> void:
    var bus_index = AudioServer.get_bus_index("Master")
    AudioServer.set_bus_volume_db(bus_index, linear2db(value / 100.0))
```

## AudioServer Integration (Optional)

To make the volume sliders actually control audio, add this to `SettingsMenu.gd`:

```gdscript
func _on_master_volume_changed(value: float) -> void:
    """Handle master volume slider change"""
    var bus_index: int = AudioServer.get_bus_index("Master")
    var db: float = linear2db(value / 100.0)
    AudioServer.set_bus_volume_db(bus_index, db)

func _on_music_volume_changed(value: float) -> void:
    """Handle music volume slider change"""
    var bus_index: int = AudioServer.get_bus_index("Music")
    var db: float = linear2db(value / 100.0)
    AudioServer.set_bus_volume_db(bus_index, db)

func _on_sfx_volume_changed(value: float) -> void:
    """Handle SFX volume slider change"""
    var bus_index: int = AudioServer.get_bus_index("SFX")
    var db: float = linear2db(value / 100.0)
    AudioServer.set_bus_volume_db(bus_index, db)
```

First, create the audio buses in your AudioBusLayout:
1. Go to AudioBusLayout in the bottom panel
2. Create buses named: "Master", "Music", "SFX"
3. Assign your audio nodes to these buses

## Pressing Escape to Close Settings (Optional)

Add this to `MainMenu.gd` to close settings with ESC:

```gdscript
func _input(event: InputEvent) -> void:
    if event is InputEventKey and event.pressed:
        if event.keycode == KEY_ESCAPE and settings_panel.visible:
            _on_settings_closed()
```

## Testing Checklist

- [ ] Main menu appears when game starts
- [ ] Play button transitions to game scene
- [ ] Settings button opens settings panel
- [ ] Settings panel has semi-transparent overlay
- [ ] Volume sliders are interactive
- [ ] Back button closes settings panel
- [ ] Focus returns to Settings button after closing
- [ ] Quit button exits the game
- [ ] Keyboard navigation works (TAB/Enter)
- [ ] All button text is visible and readable

## Troubleshooting

### Settings Panel Not Showing
- Verify `SettingsPanel` node exists as child of MainMenu in the tscn
- Check that `settings_panel` property is correctly set in script: `$SettingsPanel`
- Ensure `visible = false` is set in the tscn file

### Buttons Not Responding
- Check that signal connections are present at bottom of .tscn files
- Verify button node names match the `@onready` declarations in scripts
- Look for errors in the Output tab (F4)

### Game Scene Not Loading
- Verify `res://Scenes/game.tscn` exists
- Check project file explorer to confirm path is correct
- Look at the Output panel for error messages

### Settings Slider Values Not Updating
- Verify slider `value_changed` signals are connected in the .tscn
- Check that slider step values aren't set too high
- Monitor the Output panel to see if slider change callbacks are firing

## Future Enhancements

1. **Save/Load Settings**: Persist volume settings to ConfigFile
2. **Resolution Settings**: Add dropdown for screen resolution
3. **Graphics Settings**: Add toggles for quality levels
4. **Key Bindings**: Allow rebinding control keys
5. **Audio Feedback**: Add click sounds to buttons
6. **Animations**: Fade transitions between menu states
7. **Theme System**: Implement custom theme for styling
8. **Localization**: Support multiple languages
9. **Main Menu Music**: Background music track
10. **Particle Effects**: Visual polish with particle systems

## License
This menu system is provided as-is for your Godot project.

---

**Created for Godot 4.2+**
Last Updated: 2024
