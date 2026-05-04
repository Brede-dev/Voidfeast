extends CharacterBody3D
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D

const SPEED: float = 5.0
const ACCEL: float = 10.0

"""func _ready() -> void:
	target = get_tree().get_first_node_in_group("Player")"""

func _on_killzone_body_entered(body: Node3D) -> void:
	if body is Player:
		var tree = get_tree()
		if tree:
			tree.call_deferred("reload_current_scene")

"""func _physics_process(delta: float) -> void:
	nav.target_position = target.global_position
	
	var next_position = nav.get_next_path_position()
	var direction = global_position.direction_to(next_position)
	
	velocity = velocity_lerp(direction * SPEED , ACCEL * delta)
	move_and_slide()"""
