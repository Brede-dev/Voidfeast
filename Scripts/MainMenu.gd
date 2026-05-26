class_name MainMenu
extends Node3D

@onready var play_button: Button = $UI/VBoxContainer/PlayButton
@onready var settings_button: Button = $UI/VBoxContainer/SettingsButton
@onready var quit_button: Button = $UI/VBoxContainer/QuitButton
@onready var title_label: Label = $UI/VBoxContainer/TitleLabel
@onready var settings_panel: CanvasLayer = $SettingsPanel

func _ready() -> void:
	# Connect button signals
	play_button.pressed.connect(_on_play_button_pressed)
	settings_button.pressed.connect(_on_settings_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)
	settings_panel.get_node("Panel/VBoxContainer/BackButton").pressed.connect(_on_settings_closed)
	
	# Focus on play button by default
	play_button.grab_focus()
<<<<<<< Updated upstream

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/LevelSelection.tscn")
=======
	
	# Optional: Log that menu is ready
	print("Main Menu (3D) loaded successfully")

func _on_play_button_pressed() -> void:
	"""Handle Play button press - load the game scene"""
	print("Play button pressed - Loading game scene...")
	get_tree().change_scene_to_file("res://Scenes/Level.tscn")
>>>>>>> Stashed changes

func _on_settings_button_pressed() -> void:
	settings_panel.visible = true

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_settings_closed() -> void:
	settings_panel.visible = false
	settings_button.grab_focus()
