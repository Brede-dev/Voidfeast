extends CharacterBody3D
class_name Enemy
#global_position = global_position.move_toward({thing you use for player}, {speed of enemy})
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
var enemy_type: String = "mold"
var player: Player
const SPEED: float = 5.0
const ACCEL: float = 10.0

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player") as Player
	navigation_agent_3d.target_reached.connect(_on_target_reached)


func _on_killzone_body_entered(body: Node3D) -> void:
	if body is Player:
		var tree = get_tree()
		if tree:
			tree.call_deferred("reload_current_scene")

func _physics_process(delta: float) -> void:
	if player:
		# Set the target for the navigation agent
		navigation_agent_3d.target_position = player.global_position
		
		# Get the next waypoint position along the path
		var next_position: Vector3 = navigation_agent_3d.get_next_path_position()
		
		# Calculate direction to move
		var direction: Vector3 = (next_position - global_position).normalized()
		
		# Apply movement
		velocity = velocity.lerp(direction * SPEED, ACCEL * delta)
		
		#player.global_position = global_position.move_toward(Player, 5)
		move_and_slide()
	
func _on_target_reached() -> void:
	# Enemy reached the player!
	print("Enemy reached player!")
	
