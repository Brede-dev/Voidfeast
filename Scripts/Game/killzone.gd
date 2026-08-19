extends Area3D
class_name Killzone

func _on_killzone_body_entered(body: Node3D) -> void:
	if body is Player:
		# Check if this killzone is a child of an Enemy
		if get_parent() is Enemy:
			FadeTransition.fade_to_scene("res://Scenes/Screens/DeathScreenOpponent.tscn")
		else:
			GameManager.reset()
