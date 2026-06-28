extends CharacterBody3D
class_name Player

const BASE_SPEED: float = 5.0
const JUMP_VELOCITY: float = 4.5

var times_jumped = 0

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
		rotate_y(-event.relative.x * mouse_sensitivity)
		
		# Rotate spring arm for vertical look (Pitch)
		spring_arm.rotate_x(-event.relative.y * mouse_sensitivity)
		spring_arm.rotation.x = clamp(spring_arm.rotation.x, deg_to_rad(min_vertical_angle), deg_to_rad(max_vertical_angle))


func _physics_process(delta: float) -> void:
	
	if is_on_floor():
		times_jumped = 0
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		if times_jumped == 0:
			velocity.y = JUMP_VELOCITY
			times_jumped = 1
		
	if Input.is_action_just_pressed("Jump") and not is_on_floor():
		if times_jumped == 1 and GameManager.is_item_purchased("double_jump_upgrade"):
			velocity.y = JUMP_VELOCITY
			times_jumped = 2

	# Get the input direction
	var input_dir := Input.get_vector("Left", "Right", "Forward", "Backward")
	
	# Direction is relative to the player's basis (which is rotated by Mouse X)
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# Calculate current speed with multiplier from GameManager
	var current_speed: float = BASE_SPEED * GameManager.speed_multiplier
	#print("🎮 Current Speed: ", current_speed, " (BASE: ", BASE_SPEED, " × Multiplier: ", GameManager.speed_multiplier, ") | GameManager.speed_multiplier in memory: ", GameManager.speed_multiplier)
	
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)

	move_and_slide()
