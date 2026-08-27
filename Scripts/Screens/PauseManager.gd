class_name PauseManager
extends Control

var is_paused: bool = false

func _ready() -> void:
	# Initialize pause menu components to be hidden
	var color_rect: ColorRect = get_node_or_null("ColorRect") as ColorRect
	var vbox: VBoxContainer = get_node_or_null("VBoxContainer") as VBoxContainer
	
	if color_rect:
		color_rect.visible = false
	if vbox:
		vbox.visible = false
	
	# Connect button signals if they exist
	var resume_button: Button = get_node_or_null("VBoxContainer/ContinueButton") as Button
	var menu_button: Button = get_node_or_null("VBoxContainer/BackButton") as Button
	
	if resume_button and not resume_button.pressed.is_connected(_on_resume_pressed):
		resume_button.pressed.connect(_on_resume_pressed)
	if menu_button and not menu_button.pressed.is_connected(_on_menu_pressed):
		menu_button.pressed.connect(_on_menu_pressed)

# Poll the Pause action (P and Escape) each frame. process_mode is PROCESS_MODE_ALWAYS,
# so this keeps running even while the tree is paused, allowing the key to unpause too.
# This is more robust than _input because it relies on the InputMap action state, which
# is updated for every real key press regardless of event propagation or node focus.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Pause"):
		toggle_pause()

func toggle_pause() -> void:
	is_paused = !is_paused
	get_tree().paused = is_paused
	
	var color_rect: ColorRect = get_node_or_null("ColorRect") as ColorRect
	var vbox: VBoxContainer = get_node_or_null("VBoxContainer") as VBoxContainer
	
	if is_paused:
		if color_rect:
			color_rect.visible = true
		if vbox:
			vbox.visible = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		if color_rect:
			color_rect.visible = false
		if vbox:
			vbox.visible = false
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func resume() -> void:
	toggle_pause()

func to_menu() -> void:
	get_tree().paused = false
	is_paused = false
	if FadeTransition:
		FadeTransition.fade_to_scene("res://Scenes/Screens/MainMenu.tscn")
	else:
		get_tree().change_scene_to_file("res://Scenes/Screens/MainMenu.tscn")

func _on_resume_pressed() -> void:
	$"../../Click".play()
	resume()

func _on_menu_pressed() -> void:
	$"../../Click".play()
	to_menu()
