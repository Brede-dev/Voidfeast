# Main Menu System Guide

## Overview
This is a complete, functional main menu system for Godot 4.2+ featuring a clean, professional UI with the following capabilities:

- **Main Menu Screen** with game title
- **Play Button** - Transitions to the game scene
- **Settings Button** - Opens an interactive settings panel
- **Quit Button** - Exits the application
- **Settings Panel** with volume control and back button

## File Structure

```
res://
├── Scenes/
│   ├── MainMenu.tscn          # Main menu scene
│   ├── SettingsMenu.tscn      # Settings panel scene
│   └── game.tscn              # Game scene (placeholder)
├── Scripts/
│   ├── MainMenu.gd            # Main menu script
│   └── SettingsMenu.gd        # Settings menu script
└── MENU_SYSTEM_GUIDE.md       # This file
```

## Scene Structure

### MainMenu.tscn
```
MainMenu (Control)
├── ColorRect (Background)
├── VBoxContainer
│   ├── TitleLabel ("VOIDFEAST")
│   ├── Spacer1 (Control)
│   ├── PlayButton (Button)
│   ├── SettingsButton (Button)
│   ├── QuitButton (Button)
│   └── Spacer2 (Control)
└── SettingsMenu (SettingsMenu.tscn - instanced)
```

### SettingsMenu.tscn
```
SettingsMenu (Control)
├── PanelContainer (Settings Panel Background)
│   └── VBoxContainer
│       ├── TitleLabel
│       ├── VolumeLabel
│       ├── VolumeSlider (HSlider)
│       ├── BackButton (Button)
│       └── (Spacers)
```

## Script Details

### MainMenu.gd

**Signals:**
- `settings_opened` - Emitted when settings panel is opened
- `game_started` - Emitted when play button is clicked

**Methods:**
- `_on_play_button_pressed()` - Loads and transitions to game scene
- `_on_settings_button_pressed()` - Shows the settings menu
- `_on_quit_button_pressed()` - Exits the application
- `_on_settings_closed()` - Hides the settings menu when back button is pressed

**Key Features:**
- Uses `get_tree().change_scene_to_file()` for smooth scene transitions
- Properly connects signals to button pressed events
- Handles settings menu visibility toggling

### SettingsMenu.gd

**Signals:**
- `settings_closed` - Emitted when back button is pressed

**Properties:**
- `master_volume: float` - Stores the current volume level (0.0 to 1.0)

**Methods:**
- `_on_back_button_pressed()` - Closes the settings menu
- `_on_volume_slider_changed(value: float)` - Updates AudioServer volume

**Key Features:**
- Controls master audio bus volume
- Updates in real-time as slider moves
- Emits signal when closing to notify main menu

## How to Use

### 1. **Set as Main Scene**
In your project settings:
- Go to **Project → Project Settings → Application → Run**
- Set the **Main Scene** to `res://Scenes/MainMenu.tscn`

### 2. **Running the Menu**
- Press **F5** or click **Play** to run the project
- The main menu will load with three buttons visible

### 3. **Button Interactions**
- **PLAY** - Transitions to `res://Scenes/game.tscn`
- **SETTINGS** - Opens/closes the settings panel with volume control
- **QUIT** - Closes the application immediately
- **Back (in Settings)** - Returns to main menu

## Customization

### Change the Game Title
In **MainMenu.tscn**, select the **TitleLabel** node and edit the **Text** property.

### Modify Button Text
Select each button node and edit their **Text** properties in the Inspector.

### Change Game Scene Path
Edit **MainMenu.gd** and modify this line:
```gdscript
get_tree().change_scene_to_file("res://Scenes/game.tscn")
```
Replace with your actual game scene path.

### Styling
- **Background Color**: Select ColorRect and adjust the **Color** property
- **Button Colors**: Select each button and adjust **Theme Overrides → Colors**
- **Text Colors/Fonts**: Adjust in the Inspector for each label or button
- **Button Size**: Modify **Custom Minimum Size** on button nodes

## Audio System Integration

The settings menu integrates with Godot's built-in AudioServer:
- Controls the **Master** audio bus
- Volume ranges from 0.0 (silent) to 1.0 (full volume)
- Changes are applied in real-time

### Using Other Audio Buses
To control a different audio bus, edit **SettingsMenu.gd**:
```gdscript
AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)
```
Change `"Master"` to your bus name.

## Transitions

### Scene Transitions
The menu uses `change_scene_to_file()` which provides a smooth fade transition. To customize the transition animation, you can add a scene transition effect:

```gdscript
# In MainMenu.gd, replace the transition code:
var tween: Tween = create_tween()
tween.tween_property(ColorRect, "modulate:a", 0.0, 0.5)
await tween.finished
get_tree().change_scene_to_file("res://Scenes/game.tscn")
```

## Testing Checklist

- [ ] Main menu displays with title and three buttons
- [ ] Play button transitions to game scene
- [ ] Settings button opens settings panel
- [ ] Settings button toggles on second click
- [ ] Volume slider works in settings
- [ ] Back button closes settings panel
- [ ] Quit button closes the application
- [ ] All text is readable on the background
- [ ] Buttons are responsive to clicks
- [ ] No console errors appear

## Troubleshooting

### "res://Scenes/game.tscn not found"
Make sure you have a game scene at that path, or update the path in MainMenu.gd.

### Settings panel doesn't appear
Check that SettingsMenu.tscn is properly instanced in MainMenu.tscn and the path is correct.

### Buttons don't respond
Ensure that signal connections in the scene file are intact. Check the Inspector for each button's "Node" tab.

### Volume slider doesn't work
Verify that the "Master" audio bus exists. You can create it in the Audio dock.

## Next Steps

1. **Add Audio**: Create a background music track and add it to the main menu
2. **Add Animations**: Use Tweens to animate button hover states
3. **Add Themes**: Create a Theme resource for consistent styling across the UI
4. **Add Input Handling**: Add keyboard shortcuts (e.g., ESC to open/close settings)
5. **Enhance Visuals**: Add background images, logos, or particle effects
6. **Add More Settings**: Extend the settings menu with brightness, difficulty, etc.

---

**Version**: 1.0  
**Godot Version**: 4.2+  
**Last Updated**: 2024
