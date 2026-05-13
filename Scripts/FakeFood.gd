extends Area3D
const ROT_SPEED = 2

func _process(delta: float) -> void:
	rotate_y(deg_to_rad(ROT_SPEED))

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		get_tree().change_scene_to_file("res://Scenes/DeathScreen.tscn")
