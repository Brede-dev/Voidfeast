class_name MainMenu
extends Control

@onready var play_button: Button = $VBoxContainer/PlayButton
@onready var settings_button: Button = $VBoxContainer/SettingsButton
@onready var quit_button: Button = $VBoxContainer/QuitButton
@onready var title_label: Label = $VBoxContainer/TitleLabel
@onready var settings_panel: Control = $SettingsPanel

func _ready() -> void:
	# Connect to settings panel close signal
	if settings_panel.has_method("set_on_close_callback"):
		settings_panel.set_on_close_callback(_on_settings_closed)
	
	# Focus on play button by default
	play_button.grab_focus()

func _on_play_button_pressed() -> void:
	$Click.play()
	FadeTransition.fade_to_scene("res://Scenes/Screens/LevelSelection.tscn")

func _on_settings_button_pressed() -> void:
	$Click.play()
	settings_panel.visible = true

func _on_quit_button_pressed() -> void:
	$Click.play()
	get_tree().quit()

func _on_settings_closed() -> void:
	$Click.play()
	settings_panel.visible = false
	settings_button.grab_focus()

func _on_tutorial_button_pressed() -> void:
	$Click.play()
	FadeTransition.fade_to_scene("res://Scenes/Game/TutorialLevel.tscn")
