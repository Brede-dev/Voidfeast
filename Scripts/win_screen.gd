extends Control

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _process(_delta: float) -> void:
	# Keep the mouse unlocked the entire time we are on this screen
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_restart_button_pressed() -> void:
	FadeTransition.fade_to_scene("res://Scenes/LevelSelection.tscn")

func _on_menu_button_pressed() -> void:
	FadeTransition.fade_to_scene("res://Scenes/main_menu.tscn")

func _on_lobby_pressed() -> void:
	FadeTransition.fade_to_scene("res://Scenes/Shop.tscn")
