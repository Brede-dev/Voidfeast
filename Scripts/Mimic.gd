extends CharacterBody3D

@export var player_path: NodePath
@export var delay := 1.0

var player: Node
#@onready var anim_player: AnimationPlayer = $AnimationPlayer

func _ready():
	player = get_node(player_path)

func _physics_process(delta):
	var target_time = Time.get_ticks_msec() / 1000.0 - delay
	var state = get_state_at_time(target_time)
	
	if state == null:
		return
	
	global_position = state["position"]
	global_rotation = state["rotation"]
	
	#if state.has("animation") and anim_player.current_animation != state["animation"]:
		#anim_player.play(state["animation"])

func get_state_at_time(target_time: float):
	if player.history.is_empty():
		return null
	
	var history = player.history
	
	# Not enough history yet — clamp to oldest sample
	if target_time <= history[0]["time"]:
		return history[0]
	
	# Walk through history to find the two samples surrounding target_time
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
				#"animation": b["animation"]
			}
	
	# Fallback: use most recent sample
	return history[history.size() - 1]
