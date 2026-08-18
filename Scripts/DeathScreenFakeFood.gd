class_name DeathScreenFakeFood
extends Control

func _on_restart_button_pressed() -> void:
	GameManager.food_collected = 0
	GameManager.total_food_owned = 0
	GameManager.level_score = 0
	$Click.play()
	FadeTransition.fade_to_scene("res://Scenes/LevelSelection.tscn")

func _on_menu_button_pressed() -> void:
	$Click.play()
	FadeTransition.fade_to_scene("res://Scenes/MainMenu.tscn")
