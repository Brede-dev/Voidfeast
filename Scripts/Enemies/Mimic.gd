extends Node3D
@export var player_path: NodePath
@export var delay := 5.0
var player: Node
var spawn_time: float
var collision_node: Area3D

func _ready():
	player = _resolve_player()
	spawn_time = Time.get_ticks_msec() / 1000.0
	
	# Find and store the Area3D child
	for child in get_children():
		if child is Area3D:
			collision_node = child
			collision_node.collision_layer = 0
			collision_node.collision_mask = 0
			print("✓ Found collision node: ", collision_node.name)
			print("✓ Disabled collision")
			
			# IMPORTANT: Connect the signal
			if not collision_node.area_entered.is_connected(_on_killzone_area_entered):
				collision_node.area_entered.connect(_on_killzone_area_entered)
				print("✓ Connected area_entered signal")
			break

func _physics_process(_delta):
	var current_time = Time.get_ticks_msec() / 1000.0
	var elapsed = current_time - spawn_time
	
	# Re-enable collision after delay
	if collision_node and elapsed >= delay and collision_node.collision_layer == 0:
		collision_node.collision_layer = 1
		collision_node.collision_mask = 1
		print("✓ Enabled collision after delay")
	
	# Don't touch position/rotation until delay has passed
	if elapsed < delay:
		return
	
	var target_time = current_time - delay
	var state = get_state_at_time(target_time)
	
	if state == null:
		return
	
	global_position = state["position"]
	global_rotation = state["rotation"]

func _resolve_player() -> Node:
	if player_path != NodePath() and has_node(player_path):
		var candidate := get_node(player_path)
		if "history" in candidate:
			return candidate
	return get_tree().get_first_node_in_group("Player")

func get_state_at_time(target_time: float):
	if player == null or player.history.is_empty():
		return null
	
	var history = player.history
	
	if target_time <= history[0]["time"]:
		return history[0]
	
	for i in range(history.size() - 1):
		var a = history[i]
		var b = history[i + 1]
		if a["time"] <= target_time and b["time"] >= target_time:
			var t = inverse_lerp(a["time"], b["time"], target_time)
			return {
				"position": a["position"].lerp(b["position"], t),
				"rotation": Vector3(
					lerp_angle(a["rotation"].x, b["rotation"].x, t),
					lerp_angle(a["rotation"].y, b["rotation"].y, t),
					lerp_angle(a["rotation"].z, b["rotation"].z, t)
				),
			}
	
	return history[history.size() - 1]

func _on_killzone_area_entered(area: Area3D) -> void:
	FadeTransition.fade_to_scene("res://Scenes/Screens/DeathScreenMimic.tscn")
