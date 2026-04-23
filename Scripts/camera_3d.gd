extends Camera3D

@export var target: Node3D
@export var offset := Vector3(0, 9, 1)
@export var speed := 10.0

func _process(delta):
	if target:
		var goal = target.global_position + offset
		global_position = global_position.lerp(goal, speed * delta)
		look_at(target.global_position, Vector3.UP)
