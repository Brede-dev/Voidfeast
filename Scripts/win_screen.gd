extends Control



func _on_restart_button_pressed() -> void:
	FadeTransition.fade_to_scene("res://Scenes/LevelSelection.tscn")

func _on_menu_button_pressed() -> void:
	FadeTransition.fade_to_scene("res://Scenes/main_menu.tscn")

func _on_lobby_pressed() -> void:
	FadeTransition.fade_to_scene("res://Scenes/Shop.tscn")
