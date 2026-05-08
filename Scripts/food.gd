extends Area3D
const ROT_SPEED = 2



func _on_body_entered(body: Node3D) -> void:
	if body is not Player:
		return
	GameManager.add_score(1)
	queue_free()

func _process(delta: float) -> void:
	rotate_y(deg_to_rad(ROT_SPEED))
