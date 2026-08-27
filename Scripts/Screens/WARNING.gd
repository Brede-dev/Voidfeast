extends Control

func _on_yes_pressed() -> void:
	$Click.play()
	FadeTransition.fade_to_scene("res://Scenes/Game/Level Extreme.tscn")

func _on_no_pressed() -> void:
	$Click.play()
	FadeTransition.fade_to_scene("res://Scenes/Screens/MainMenu.tscn")
