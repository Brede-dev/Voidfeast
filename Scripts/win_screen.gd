extends Control



func _on_restart_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Level1.tscn")



func _on_menu_button_pressed() -> void:
	GameManager.food_collected = 0
	GameManager.golden_food_collected = 0
	GameManager.level_score = 0
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")


func _on_lobby_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Shop.tscn")
