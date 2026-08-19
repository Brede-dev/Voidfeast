extends CharacterBody3D
## "Baby" enemy - inspired by Nullscape.
## Behavior: sits idle -> locks onto nearest player -> telegraphs a straight-line
## dash with a visible path indicator + sound cue -> dashes fast in that fixed
## direction -> short cooldown -> repeats. Instakill on contact during the dash
## (and optionally always, matching the wiki's "instantly kills on contact").

# --- Tuning ---
@export_group("Detection")
@export var detection_range: float = 40000.0          # how far Baby can "see" players to lock onto
@export var players_group: String = "Player"       # group name your player nodes belong to

@export_group("Attack Timing")
@export var windup_time: float = 0.9                # time telegraphing before dash (tweak to taste)
@export var dash_speed: float = 28.0
@export var dash_duration: float = 0.5              # how long the dash lasts
@export var dash_max_distance: float = 999.0        # cap the straight-line travel if you want a fixed length
@export var cooldown_time: float = 1.2              # pause after a dash before it can lock on again
@export var extreme_mode: bool = false               # if true, dashes a second time immediately after the first

@export_group("Curses (optional)")
@export var pacifier_curse: bool = false             # muffles sound + hides indicator more
@export var problem_child_curse: bool = false        # random chance to redirect mid-telegraph
@export var problem_child_redirect_chance: float = 0.35

@export_group("Visuals")
@export var telegraph_color: Color = Color(1, 0, 0, 0.85)
@export var telegraph_width: float = 0.15

# --- Internal state ---
enum State { IDLE, WINDUP, DASHING, COOLDOWN }
var state: State = State.IDLE

var target: Node3D = null
var dash_direction: Vector3 = Vector3.ZERO
var dash_timer: float = 0.0
var state_timer: float = 0.0
var pending_second_dash: bool = false

@onready var telegraph_line: MeshInstance3D = $TelegraphLine
@onready var hitbox: Area3D = $HitArea
@onready var windup_sound: AudioStreamPlayer3D = $WindupSound
@onready var laugh_sound: AudioStreamPlayer3D = $LaughSound # for Problem Child redirects
@onready var anim: AnimationPlayer = get_node_or_null("AnimationPlayer")

func _ready() -> void:
	telegraph_line.visible = false
	hitbox.body_entered.connect(_on_hitbox_body_entered)
	if pacifier_curse and windup_sound:
		windup_sound.volume_db -= 12.0

func _physics_process(delta: float) -> void:
	match state:
		State.IDLE:
			_process_idle()
		State.WINDUP:
			_process_windup(delta)
		State.DASHING:
			_process_dashing(delta)
		State.COOLDOWN:
			_process_cooldown(delta)

	move_and_slide()


func _process_idle() -> void:
	velocity = Vector3.ZERO
	var found := _find_nearest_player()
	if found:
		target = found
		_enter_windup()


func _enter_windup() -> void:
	state = State.WINDUP
	state_timer = 0.0
	dash_direction = _get_direction_to_target()
	telegraph_line.visible = true
	_update_telegraph_transform()
	if windup_sound:
		windup_sound.play()
	if anim:
		anim.play("lock_on")


func _process_windup(delta: float) -> void:
	state_timer += delta
	velocity = Vector3.ZERO # Baby cannot move while charging up

	# Problem Child: random chance to change trajectory mid-telegraph
	if problem_child_curse and target and randf() < problem_child_redirect_chance * delta:
		dash_direction = _get_direction_to_target()
		_update_telegraph_transform()
		if laugh_sound:
			laugh_sound.play()

	if state_timer >= windup_time:
		_enter_dash()


func _enter_dash() -> void:
	state = State.DASHING
	state_timer = 0.0
	telegraph_line.visible = false
	if anim:
		anim.play("dash")


func _process_dashing(delta: float) -> void:
	state_timer += delta
	velocity = dash_direction * dash_speed

	if state_timer >= dash_duration:
		if extreme_mode and not pending_second_dash:
			# Immediately re-telegraph and dash again once, per Extreme-mode behavior
			pending_second_dash = true
			_enter_windup()
			# Shorten the second windup a bit so it reads as "immediate" - optional
			state_timer = 0.0
		else:
			pending_second_dash = false
			_enter_cooldown()


func _enter_cooldown() -> void:
	state = State.COOLDOWN
	state_timer = 0.0
	velocity = Vector3.ZERO
	if anim:
		anim.play("idle")


func _process_cooldown(delta: float) -> void:
	state_timer += delta
	velocity = Vector3.ZERO
	if state_timer >= cooldown_time:
		state = State.IDLE
		target = null


func _find_nearest_player() -> Node3D:
	var players := get_tree().get_nodes_in_group(players_group)
	var nearest: Node3D = null
	var nearest_dist: float = detection_range
	for p in players:
		if p is Node3D:
			var d := global_position.distance_to(p.global_position)
			if d < nearest_dist:
				nearest_dist = d
				nearest = p
	return nearest


func _get_direction_to_target() -> Vector3:
	if target == null:
		return Vector3.FORWARD
	var dir := (target.global_position - global_position)
	dir.y = 0.0 # keep the dash horizontal; remove this line if you want full 3D dashes
	if dir.length() < 0.001:
		return Vector3.FORWARD
	return dir.normalized()


func _update_telegraph_transform() -> void:
	# Stretches a thin box/line mesh along dash_direction to show the path.
	var length := dash_max_distance
	telegraph_line.scale = Vector3(telegraph_width, telegraph_width, length)
	telegraph_line.position = dash_direction * (length / 2.0)
	telegraph_line.look_at(global_position + dash_direction, Vector3.UP)


func _on_hitbox_body_entered(body: Node3D) -> void:
	if body.is_in_group(players_group):
		if body.has_method("die"):
			body.die()
		elif body.has_method("take_damage"):
			body.take_damage(9999)
		else:
			push_warning("Baby hit a player but they have no die()/take_damage() method.")
