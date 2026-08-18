class_name DeathScreenFastMart
extends Control

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _process(_delta: float) -> void:
	# Keep the mouse unlocked the entire time we are on this screen
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_restart_button_pressed() -> void:
	GameManager.food_collected = 0
	GameManager.total_food_owned = 0
	GameManager.level_score = 0
	$Click.play()
	FadeTransition.fade_to_scene("res://Scenes/Screens/LevelSelection.tscn")

func _on_menu_button_pressed() -> void:
	$Click.play()
	FadeTransition.fade_to_scene("res://Scenes/Screens/MainMenu.tscn")
