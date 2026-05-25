extends Control



func _on_restart_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Level1.tscn")



func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")


func _on_lobby_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Lobby.tscn")
