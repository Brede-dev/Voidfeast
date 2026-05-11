extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		GameManager.reset()
		


"""func _on_area_entered(area: Area3D) -> void:
	if body is Player:
		get_tree()change_scene_to_file("res://Scenes/DeathScreen.tscn")"""
