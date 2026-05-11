extends CharacterBody3D
class_name Enemy
var enemy_type: String = "mold"
const SPEED: float = 0.05
const ACCEL: float = 10.0
var player = null
func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")

func _physics_process(delta: float) -> void:
	global_position = global_position.move_toward(player.global_position , SPEED)
	move_and_slide()

func _on_target_reached() -> void:
	# Enemy reached the player!
	print("Enemy reached player!")
