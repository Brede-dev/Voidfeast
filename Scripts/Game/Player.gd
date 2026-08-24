extends CharacterBody3D
class_name Player

const BASE_SPEED: float = 5.5
const JUMP_VELOCITY: float = 5
const FALL_DEATH_HEIGHT: float = -50.0  # Y position below which player dies
const DASH_SPEED: float = 18.0
const DASH_COOLDOWN_TIME: float = 0.8
var is_dashing: bool = false
var dash_cooldown_timer: float = 0.0
var times_jumped = 0
var history: Array = []
var record_duration := 2.0

#@onready var anim_player: AnimationPlayer = $AnimationPlayer  # adjust path if your AnimationPlayer is nested differently
@export var mouse_sensitivity: float = 0.002
@export var max_vertical_angle: float = 85.0
@export var min_vertical_angle: float = -85.0
@export var collect_food: Area3D
@onready var spring_arm: SpringArm3D = $SpringArm3D
@onready var camera: Camera3D = $SpringArm3D/Camera3D

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	# Handle mouse rotation
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		# Rotate player for horizontal look (Yaw)
		rotate_y(-event.relative.x * SettingsManager.get_mouse_sensitivity())
		
		# Rotate spring arm for vertical look (Pitch)
		spring_arm.rotate_x(-event.relative.y * SettingsManager.get_mouse_sensitivity())
		spring_arm.rotation.x = clamp(spring_arm.rotation.x, deg_to_rad(min_vertical_angle), deg_to_rad(max_vertical_angle))


func _physics_process(delta: float) -> void:
	# Check if player fell below the death height
	if global_position.y < FALL_DEATH_HEIGHT:
		$Death.play()
		FadeTransition.fade_to_scene("res://Scenes/Screens/DeathScreenFall.tscn")
		return
	
	if is_on_floor():
		times_jumped = 0
		is_dashing = false
	# Add the gravity.
	if not is_on_floor():
		if is_dashing:
			velocity.y = -DASH_SPEED
		else:
			velocity += get_gravity() * delta
	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		if times_jumped == 0:
			velocity.y = JUMP_VELOCITY * GameManager.jump_upgrade
			times_jumped = 1
			get_node("Box/AnimationPlayer").play("Armature|Jump_001")
		
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY * GameManager.jump_upgrade
		get_node("Box/AnimationPlayer").play("Armature|Jump_001")
		
	if Input.is_action_just_pressed("Jump") and not is_on_floor():
		if times_jumped == 1 and GameManager.is_item_purchased("double_jump_upgrade"):
			velocity.y = JUMP_VELOCITY
			times_jumped = 2
			get_node("Box/AnimationPlayer").play("Armature|Jump_001")
	# Get the input direction
	var input_dir := Input.get_vector("Left", "Right", "Forward", "Backward")
	
	
	# Direction is relative to the player's basis (which is rotated by Mouse X)
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# Calculate current speed with multiplier from GameManager
	var current_speed: float = BASE_SPEED * GameManager.speed_multiplier
	
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
		get_node("Box/AnimationPlayer").play("Armature|Walk")
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)
	move_and_slide()
	
	if dash_cooldown_timer > 0.0:
		dash_cooldown_timer -= delta

	if Input.is_action_just_pressed("Dash") and not is_on_floor() and dash_cooldown_timer <= 0.0:
		is_dashing = true
		dash_cooldown_timer = DASH_COOLDOWN_TIME
		velocity.y = -DASH_SPEED
		velocity.x = 0.0
		velocity.z = 0.0
		get_node("Box/AnimationPlayer").play("Armature|Jump_001") # swap for a dash anim if you have one

	# --- Opponent mimicry recording ---
	var current_time := Time.get_ticks_msec() / 1000.0
	history.append({
		"time": current_time,
		"position": global_position,
		"rotation": global_rotation,
		#"animation": anim_player.current_animation if anim_player else ""
	})
	while history.size() > 0 and history[0]["time"] < current_time - record_duration:
		history.pop_front()
