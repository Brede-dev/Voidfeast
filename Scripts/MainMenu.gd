class_name MainMenu
extends Control

@onready var play_button: Button = $VBoxContainer/PlayButton
@onready var settings_button: Button = $VBoxContainer/SettingsButton
@onready var quit_button: Button = $VBoxContainer/QuitButton
@onready var title_label: Label = $VBoxContainer/TitleLabel
@onready var settings_panel: Control = $SettingsPanel

func _ready() -> void:
	# Connect button signals
	play_button.pressed.connect(_on_play_button_pressed)
	settings_button.pressed.connect(_on_settings_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)
	
	# Connect to settings panel close signal
	if settings_panel.has_method("set_on_close_callback"):
		settings_panel.set_on_close_callback(_on_settings_closed)
	
	# Focus on play button by default
	play_button.grab_focus()

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Level.tscn")

func _on_settings_button_pressed() -> void:
	settings_panel.visible = true

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_settings_closed() -> void:
	settings_panel.visible = false
	settings_button.grab_focus()
