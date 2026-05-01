extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_killzone_body_entered(body: Node3D) -> void:
	if body is Player:
		var tree = get_tree()
		if tree:
			tree.call_deferred("reload_current_scene")
