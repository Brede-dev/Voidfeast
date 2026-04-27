# Main Menu System - Quick Reference Cheat Sheet

## 📁 File Locations

```
Scenes/
├── MainMenu.tscn          ← Open this to edit the menu
├── SettingsMenu.tscn      ← Settings panel scene
└── game.tscn              ← Replace with your game

Scripts/
├── MainMenu.gd            ← Menu controller
└── SettingsMenu.gd        ← Settings controller
```

---

## ▶️ How to Run

1. **Right-click** `res://Scenes/MainMenu.tscn`
2. **Select** "Set as Main Scene"
3. **Press** F5 or click **Run** button
4. **Done!** Menu appears

---

## 🎯 What Each Button Does

| Button | File | Method | Action |
|--------|------|--------|--------|
| PLAY | MainMenu.gd | `_on_play_button_pressed()` | Loads `res://Scenes/game.tscn` |
| SETTINGS | MainMenu.gd | `_on_settings_button_pressed()` | Shows settings panel |
| QUIT | MainMenu.gd | `_on_quit_button_pressed()` | Exits game |
| BACK | SettingsMenu.gd | `_on_back_pressed()` | Closes settings panel |

---

## 🎨 Quick Customization

### Change Game Name
File: `MainMenu.tscn`  
Node: `VBoxContainer/TitleLabel`  
Property: `Text` = "YOUR GAME NAME"

### Change Button Text
File: `MainMenu.tscn`  
Nodes: `PlayButton`, `SettingsButton`, `QuitButton`  
Property: `Text`

### Change Colors
File: `MainMenu.tscn` or `SettingsMenu.tscn`  
Node: `ColorRect`  
Property: `Color`

### Change Button Size
File: `MainMenu.tscn`  
Nodes: Any button  
Property: `Custom Minimum Size`

### Change Volume Slider Ranges
File: `SettingsMenu.tscn`  
Nodes: Any HSlider  
Properties: `min_value`, `max_value`, `step`, `value`

---

## 🔍 Node Paths (for @onready references)

```gdscript
$VBoxContainer/TitleLabel
$VBoxContainer/PlayButton
$VBoxContainer/SettingsButton
$VBoxContainer/QuitButton
$SettingsPanel
$SettingsPanel/VBoxContainer/MasterVolumeSlider
$SettingsPanel/VBoxContainer/MusicVolumeSlider
$SettingsPanel/VBoxContainer/SFXVolumeSlider
$SettingsPanel/VBoxContainer/BackButton
```

---

## 📝 Code Snippets

### Add Click Sound
```gdscript
@onready var click_sound: AudioStreamPlayer = $ClickSound

func _on_play_button_pressed() -> void:
    click_sound.play()
    await get_tree().create_timer(0.2).timeout
    get_tree().change_scene_to_file("res://Scenes/game.tscn")
```

### Save Settings
```gdscript
func save_settings() -> void:
    var config: ConfigFile = ConfigFile.new()
    config.set_value("audio", "master", master_volume_slider.value)
    config.save("user://settings.cfg")
```

### Load Settings
```gdscript
func load_settings() -> void:
    var config: ConfigFile = ConfigFile.new()
    if config.load("user://settings.cfg") == OK:
        master_volume_slider.value = config.get_value("audio", "master", 80.0)
```

### Real Volume Control
```gdscript
func _on_master_volume_changed(value: float) -> void:
    var bus_idx: int = AudioServer.get_bus_index("Master")
    var db: float = linear2db(value / 100.0)
    AudioServer.set_bus_volume_db(bus_idx, db)
```

### Close Settings with ESC
```gdscript
func _input(event: InputEvent) -> void:
    if event is InputEventKey and event.pressed:
        if event.keycode == KEY_ESCAPE and settings_panel.visible:
            _on_settings_closed()
            get_tree().root.set_input_as_handled()
```

---

## ⌨️ Input Map

| Key | Action |
|-----|--------|
| Left Click | Click button |
| TAB | Next button |
| Shift+TAB | Previous button |
| ENTER/SPACE | Press button |

---

## 🧪 Testing Commands

```bash
# Start menu (F5 in editor)
# Test Play button → should load game scene
# Test Settings → should show panel
# Test sliders → should be movable
# Test Back button → should hide panel
# Test Quit → should exit game
# Test keyboard → TAB and ENTER should work
```

---

## 🔗 Signal Connections

**In MainMenu.tscn (bottom of file)**:
```
[connection signal="pressed" from="VBoxContainer/PlayButton" to="." method="_on_play_button_pressed"]
[connection signal="pressed" from="VBoxContainer/SettingsButton" to="." method="_on_settings_button_pressed"]
[connection signal="pressed" from="VBoxContainer/QuitButton" to="." method="_on_quit_button_pressed"]
```

**In SettingsMenu.gd**:
```gdscript
back_button.pressed.connect(_on_back_pressed)
master_volume_slider.value_changed.connect(_on_master_volume_changed)
music_volume_slider.value_changed.connect(_on_music_volume_changed)
sfx_volume_slider.value_changed.connect(_on_sfx_volume_changed)
```

---

## 📊 Color Values (RGBA, 0-1 scale)

```
Black:      Color(0.0, 0.0, 0.0, 1)
White:      Color(1.0, 1.0, 1.0, 1)
Dark Blue:  Color(0.1, 0.1, 0.2, 1)
Dark Green: Color(0.1, 0.15, 0.1, 1)
Dark Gray:  Color(0.1, 0.1, 0.1, 1)
Current:    Color(0.1, 0.1, 0.15, 1)  ← Menu uses this
```

---

## 📐 Default Sizes

```
Game Window:      1280x720
Menu Title:       300x60
Menu Buttons:     300x50
Settings Panel:   400x400
Volume Sliders:   0-100 range
```

---

## 🐛 Common Issues & Fixes

| Issue | Solution |
|-------|----------|
| Settings panel invisible | Check `visible = false` is set |
| Buttons don't work | Check signal connections at bottom of .tscn |
| Game doesn't load | Verify path: `res://Scenes/game.tscn` exists |
| Sliders unresponsive | Check value_changed signals are connected |
| No console output | Enable Output panel: View → Output |

---

## 📖 Related Files

- `README_MENU.md` - Complete documentation
- `QUICKSTART.md` - 30-second setup guide
- `MENU_DOCUMENTATION.md` - Technical reference
- `MENU_EXTENSIONS.gd` - Code snippets

---

## 🎮 Scene Tree Structure

```
MainMenu (Control) [MainMenu.gd]
├── ColorRect ← Background
├── VBoxContainer ← Layout
│   ├── TitleLabel
│   ├── Spacer1
│   ├── PlayButton
│   ├── SettingsButton
│   ├── QuitButton
│   └── Spacer2
└── SettingsPanel (SettingsMenu instance) [HIDDEN]
    ├── ColorRect ← Overlay
    └── VBoxContainer ← Layout
        ├── TitleLabel
        ├── Spacer1
        ├── MasterVolumeContainer
        │   ├── Label
        │   └── HSlider
        ├── MusicVolumeContainer
        │   ├── Label
        │   └── HSlider
        ├── SFXVolumeContainer
        │   ├── Label
        │   └── HSlider
        ├── Spacer2
        └── BackButton
```

---

## 🚀 Setup in 3 Steps

```gdscript
# Step 1: Open MainMenu.tscn
# Step 2: Right-click → "Set as Main Scene"
# Step 3: Press F5 to run

# Done! All buttons work out of the box.
```

---

## 💡 Pro Tips

1. **Always save before running** - Prevents lost work
2. **Use Inspector to find nodes** - Easier than reading .tscn
3. **Print console messages** - Helps debug button presses
4. **Test both mouse and keyboard** - Both should work
5. **Keep node names consistent** - Easier to find things
6. **Use clear function names** - `_on_button_pressed()` is clear
7. **Document your changes** - Future you will thank you
8. **Version your menu code** - Easy to rollback if issues

---

## 📞 Quick Help

**Button not working?**
→ Check Output panel for errors (View → Output)

**Settings panel stuck?**
→ Check if `visible = true` is accidentally set

**Game won't load?**
→ Verify `res://Scenes/game.tscn` path is correct

**Sliders not moving?**
→ Check signal connections in SettingsMenu.tscn

---

## ✅ Verification Checklist

- [ ] MainMenu.tscn opens without errors
- [ ] SettingsMenu.tscn opens without errors
- [ ] Play button works (transitions to game)
- [ ] Settings button works (opens panel)
- [ ] Settings panel has overlay
- [ ] Sliders are movable
- [ ] Back button closes panel
- [ ] Quit button exits game
- [ ] TAB navigation works
- [ ] ENTER activation works
- [ ] Console logs show button presses
- [ ] No red error messages in Output

---

## 🎯 Next Actions

1. **Set MainMenu as Main Scene** (right-click in FileSystem)
2. **Press F5** to see it in action
3. **Test all buttons** to verify functionality
4. **Customize colors/text** to match your game
5. **Replace game.tscn** with your actual game
6. **Add sounds** (see MENU_EXTENSIONS.gd)
7. **Save settings** (see MENU_EXTENSIONS.gd)
8. **Deploy!** 🚀

---

**Last Updated**: 2024  
**Godot Version**: 4.2+  
**Status**: ✅ Complete & Working
