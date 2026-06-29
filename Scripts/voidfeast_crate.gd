extends Node3D
const ROTY_SPEED = 0.2
const ROTX_SPEED = 0.1
const ROTZ_SPEED = 0.4

func _process(delta: float) -> void:
	rotate_y(deg_to_rad(ROTY_SPEED))
	rotate_x(deg_to_rad(ROTX_SPEED))
	rotate_z(deg_to_rad(ROTZ_SPEED))
