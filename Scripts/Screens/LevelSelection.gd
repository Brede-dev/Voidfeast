extends Control

func _on_level_1_pressed() -> void:
	$Click.play()
	FadeTransition.fade_to_scene("res://Scenes/Game/Level1.tscn")

func _on_level_2_pressed() -> void:
	$Click.play()
	FadeTransition.fade_to_scene("res://Scenes/Game/Level2.tscn")

func _on_level_3_pressed() -> void:
	$Click.play()
	FadeTransition.fade_to_scene("res://Scenes/Game/Level3.tscn")

func _on_main_menu_pressed() -> void:
	$Click.play()
	FadeTransition.fade_to_scene("res://Scenes/Screens/MainMenu.tscn")

func _on_chaos_button_pressed() -> void:
	$Click.play()
	FadeTransition.fade_to_scene("res://Scenes/Screens/WARNING.tscn")
