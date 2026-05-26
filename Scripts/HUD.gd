extends CanvasLayer

var elapsed_time: float = 0.0
var show_countdown: bool = false  # Set to true to show countdown timer instead of elapsed time

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CoinLabel.text = str(0)
	if $TimerLabel:
		$TimerLabel.text = "0:00"
	
	# Connect to GameManager signals
	GameManager.time_over.connect(_on_time_over)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$CoinLabel.text = str(GameManager.score)
	
	# Update timer display
	if show_countdown:
		# Show countdown timer
		var minutes: int = int(GameManager.time_remaining) / 60
		var seconds: int = int(GameManager.time_remaining) % 60
		if $TimerLabel:
			$TimerLabel.text = "%d:%02d" % [minutes, seconds]
	else:
		# Show elapsed time
		elapsed_time += delta
		var minutes: int = int(elapsed_time) / 60
		var seconds: int = int(elapsed_time) % 60
		if $TimerLabel:
			$TimerLabel.text = "%d:%02d" % [minutes, seconds]

<<<<<<< Updated upstream
func _on_time_over() -> void:
	"""Called when the countdown timer reaches zero"""
	print("Time's up!")
	# You can add game over logic here
=======

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
	get_tree().change_scene_to_file("res://Scenes/MainMenu_3D.tscn")
>>>>>>> Stashed changes
