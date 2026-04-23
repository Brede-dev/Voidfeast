extends Camera3D

@export var target: Node3D
@export var offset := Vector3(3, 7, 3)
@export var speed := 10.0

func _process(delta):
	if target:
		var goal = target.global_position + offset
		global_position = global_position.lerp(goal, speed * delta)
		
		# Only look at target if camera is not at the same position
		if global_position.distance_to(target.global_position) > 0.1:
			look_at(target.global_position, Vector3.UP)
