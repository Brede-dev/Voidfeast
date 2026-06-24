extends Area3D
class_name Killzone

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		# Check if this killzone is a child of an Enemy
		if get_parent() is Enemy:
			get_tree().change_scene_to_file("res://Scenes/DeathScreenOpponent.tscn")
		else:
			GameManager.reset()
