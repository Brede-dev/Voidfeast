# Main Menu Quick Start Guide

## 🚀 Getting Started in 30 Seconds

### 1. Set Main Menu as Startup Scene
- Open `res://Scenes/MainMenu.tscn` in the Godot editor
- Go to **Scene → Set As Main Scene** (or right-click the file in FileSystem)
- This makes the main menu the first scene that loads when you run the game

### 2. Run the Game
- Press **F5** or click the **Run** button (▶ icon) in the top toolbar
- The main menu will appear!

### 3. Test the Buttons
- **PLAY Button**: Transitions to the game scene (res://Scenes/game.tscn)
- **SETTINGS Button**: Opens a settings panel with volume sliders
- **QUIT Button**: Exits the game
- **BACK Button** (in settings): Closes settings and returns to main menu

---

## 📋 What's Included

| File | Purpose |
|------|---------|
| `MainMenu.tscn` | Main menu scene with title, buttons, and settings panel |
| `MainMenu.gd` | Script that handles button clicks and transitions |
| `SettingsMenu.tscn` | Settings panel with volume sliders |
| `SettingsMenu.gd` | Script that manages settings and sliders |
| `game.tscn` | Placeholder game scene (you can replace this) |
| `MENU_DOCUMENTATION.md` | Complete documentation |

---

## 🎮 Controls

| Input | Action |
|-------|--------|
| **Mouse Click** | Click any button |
| **TAB** | Move to next button |
| **Shift + TAB** | Move to previous button |
| **ENTER** | Press focused button |

---

## ✨ Features

✅ **Fully Functional** - All buttons work and do what they should  
✅ **Clean Design** - Dark professional theme  
✅ **Settings Panel** - Master, Music, and SFX volume sliders  
✅ **Modal Overlay** - Settings appear on top with dark background  
✅ **Keyboard Navigation** - Full keyboard support with focus system  
✅ **Proper Typing** - All variables and methods are type-hinted  
✅ **Documented** - Complete inline comments and external docs  
✅ **Extensible** - Easy to add more options and features  

---

## 🔧 Customization Examples

### Change Game Name
Edit `res://Scenes/MainMenu.tscn`:
```
In the Inspector, find TitleLabel and change "text" from "VOIDFEAST" to your game name
```

### Change Button Text
Same location - find each button and modify the "text" property:
- PlayButton → "text" = "START"
- SettingsButton → "text" = "OPTIONS"
- QuitButton → "text" = "EXIT"

### Change Colors
In `MainMenu.tscn`, find the ColorRect at the top:
```
color = Color(0.1, 0.1, 0.15, 1)  → Change these numbers (0-1 scale)
```

### Change Button Size
Find any button and modify:
```
custom_minimum_size = Vector2(300, 50)  → Change 300 (width) and 50 (height)
```

---

## 🐛 Troubleshooting

**"Settings panel doesn't appear"**
→ Check that SettingsPanel is visible as a child in the Scene tree  
→ Make sure `visible = false` is set in MainMenu.tscn  

**"Buttons don't respond to clicks"**
→ Check the Output panel (View → Output) for errors  
→ Verify node names match the @onready statements  

**"Can't find game.tscn"**
→ Make sure res://Scenes/game.tscn exists  
→ Check the exact path in MainMenu.gd  

**"Volume sliders aren't connected"**
→ Look at the Output panel for error messages  
→ Verify signal connections at bottom of SettingsMenu.tscn  

---

## 📚 Next Steps

1. **Replace the Game Scene**: Replace `res://Scenes/game.tscn` with your actual game
2. **Add Sound Effects**: Play audio on button clicks (see documentation)
3. **Save Settings**: Persist volume settings to a config file (see documentation)
4. **Add Animations**: Fade transitions between menu states
5. **Custom Theme**: Create a custom Godot Theme resource for consistent styling

---

## 📖 Full Documentation

For more details, features, customization, and code examples, see **MENU_DOCUMENTATION.md**

---

## ❓ Questions?

Check the documentation files:
- **MENU_DOCUMENTATION.md** - Complete technical reference
- Inline code comments in MainMenu.gd and SettingsMenu.gd
- Godot official documentation: https://docs.godotengine.org

---

**Ready to build your game menu!** 🎮✨
