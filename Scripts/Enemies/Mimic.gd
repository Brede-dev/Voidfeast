extends Node3D
@export var player_path: NodePath
@export var delay := 5.0
var player: Node
var spawn_time: float
var player_anim_player: AnimationPlayer
var mimic_anim_player: AnimationPlayer

func _ready():
	player = _resolve_player()
	spawn_time = Time.get_ticks_msec() / 1000.0
	
	if player:
		player_anim_player = player.get_node("Box/AnimationPlayer")
		print("✓ Found player AnimationPlayer")
	
	# Get the mimic's AnimationPlayer
	mimic_anim_player = get_node("Box/AnimationPlayer")
	print("✓ Found mimic AnimationPlayer")
	
	# Make the walk animation loop, then start playing it so the .glb model is animated.
	var walk_anim: Animation = mimic_anim_player.get_animation("Armature|Walk")
	walk_anim.loop_mode = Animation.LOOP_LINEAR
	mimic_anim_player.play("Armature|Walk")

func _resolve_player() -> Node:
	# Use the exported player_path if it points at a node that actually records history.
	if player_path != NodePath() and has_node(player_path):
		var candidate := get_node(player_path)
		if "history" in candidate:
			return candidate
	# Fall back to the globally-tagged Player node.
	return get_tree().get_first_node_in_group("Player")

func _physics_process(_delta):
	var current_time = Time.get_ticks_msec() / 1000.0
	# Don't touch position/rotation until delay has passed
	if current_time - spawn_time < delay:
		return
	
	var target_time = current_time - delay
	var state = get_state_at_time(target_time)
	
	if state == null:
		return
	
	global_position = state["position"]
	global_rotation = state["rotation"]
	
	if state.has("animation") and state["animation"] != "":
		if mimic_anim_player.current_animation != state["animation"]:
			mimic_anim_player.play(state["animation"])
	
	
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
				"animation": a["animation"],
			}
	
	return history[history.size() - 1]

func _on_killzone_area_entered(area: Area3D) -> void:
	FadeTransition.fade_to_scene("res://Scenes/Screens/DeathScreenMimic.tscn")
