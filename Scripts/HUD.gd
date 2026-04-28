class_name HUD
extends CanvasLayer

# ============================================================
#  HUD Manager  |  Displays player stats on screen
# ============================================================

# GameManager reference (type-hinted for editor recognition)
var game_manager: GameManager

# UI Node References
@onready var health_label: Label = $VBoxContainer/HealthLabel
@onready var score_label: Label = $VBoxContainer/ScoreLabel
@onready var lives_label: Label = $VBoxContainer/LivesLabel

# Interactive UI elements
@onready var pause_button: Button = $PauseButton
@onready var pause_panel: Panel = $PausePanel
@onready var resume_button: Button = $PausePanel/VBoxContainer2/ResumeButton
@onready var settings_button: Button = $PausePanel/VBoxContainer2/SettingsButton
@onready var quit_button: Button = $PausePanel/VBoxContainer2/QuitButton

var is_paused: bool = false


func _ready() -> void:
	"""Initialize HUD and connect to GameManager signals."""
	# Wait for GameManager to be ready
	await get_tree().process_frame
	
	# Get reference to GameManager (it's a global autoload)
	game_manager = get_node("/root/GameManager")
	if not game_manager:
		push_error("GameManager not found! Make sure it's loaded as an autoload.")
		return
	
	# Connect all signals
	game_manager.health_changed.connect(_on_health_changed)
	game_manager.score_changed.connect(_on_score_changed)
	game_manager.lives_changed.connect(_on_lives_changed)
	
	# Update display with current values
	_update_all_displays()
	
	# Connect button signals
	pause_button.pressed.connect(_on_pause_pressed)
	resume_button.pressed.connect(_on_resume_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	quit_button.pressed.connect(_on_quit_pressed)


func _update_all_displays() -> void:
	"""Refresh all UI displays with current GameManager values."""
	if not game_manager:
		return
	_on_health_changed(game_manager.current_health, game_manager.max_health)
	_on_score_changed(game_manager.score)
	_on_lives_changed(game_manager.lives)


# ─────────────────────────────────────────
#  SIGNAL HANDLERS
# ─────────────────────────────────────────

func _on_health_changed(current: float, maximum: float) -> void:
	"""Update health display."""
	var percent: float = (current / maximum) * 100.0
	health_label.text = "Health: %.0f / %.0f (%.0f%%)" % [current, maximum, percent]


func _on_score_changed(new_score: int) -> void:
	"""Update score display."""
	score_label.text = "Score: %d" % new_score


func _on_lives_changed(new_lives: int) -> void:
	"""Update lives display."""
	lives_label.text = "Lives: %d" % new_lives


# ─────────────────────────────────────────
#  INPUT HANDLING & BUTTON CALLBACKS
# ─────────────────────────────────────────

## Handle keyboard input (ESC key to pause/resume)
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			if is_paused:
				_on_resume_pressed()
			else:
				_on_pause_pressed()
			get_tree().root.set_input_as_handled()


## Called when pause button is pressed
func _on_pause_pressed() -> void:
	is_paused = true
	pause_panel.visible = true
	get_tree().paused = true
	print("Game paused!")


## Called when resume button is pressed
func _on_resume_pressed() -> void:
	is_paused = false
	pause_panel.visible = false
	get_tree().paused = false
	print("Game resumed!")


## Called when settings button is pressed
func _on_settings_pressed() -> void:
	print("Settings menu opened! (Not yet implemented)")
	# TODO: Implement settings menu


## Called when quit button is pressed
func _on_quit_pressed() -> void:
	print("Quitting to menu...")
	get_tree().paused = false  # Unpause before quitting
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
