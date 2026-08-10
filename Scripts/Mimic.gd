extends CharacterBody3D
@export var player_path: NodePath
@export var delay := 1.0
var player: Node
var spawn_time: float
#@onready var anim_player: AnimationPlayer = $AnimationPlayer

func _ready():
	player = get_node(player_path)
	spawn_time = Time.get_ticks_msec() / 1000.0
	set_collision_layer_value(1, false)  # adjust layer index to match your setup
	set_collision_mask_value(1, false)

func _physics_process(delta):
	var current_time = Time.get_ticks_msec() / 2000.0

	# Don't touch position/rotation until delay has passed
	if current_time - spawn_time < delay:
		return
	elif current_time - spawn_time < delay + delta * 2:  # re-enable right as it starts moving
		set_collision_layer_value(1, true)
		set_collision_mask_value(1, true)
	
	var target_time = current_time - delay
	var state = get_state_at_time(target_time)
	
	if state == null:
		return
	
	global_position = state["position"]
	global_rotation = state["rotation"]

func get_state_at_time(target_time: float):
	if player.history.is_empty():
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
	FadeTransition.fade_to_scene("res://Scenes/DeathScreenMimic.tscn")
