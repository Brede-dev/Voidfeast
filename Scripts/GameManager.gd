extends Node

var score: int = 0
var level_target: int = 0
var food_collected: int = 0
var food_total: int = 8

# Timer variables
var time_limit: float = 300.0  # 5 minutes in seconds (0.0 = no limit)
var time_remaining: float = 300.0

signal score_changed
signal food_collected_changed(collected: int, total: int)
signal time_over

func reset() -> void:
	score = 0
	food_collected = 0
	time_remaining = time_limit
	get_tree().change_scene_to_file("res://Scenes/LoseScreen.tscn")

func start_timer(duration: float) -> void:
	"""Start a countdown timer with the specified duration (in seconds)"""
	time_limit = duration
	time_remaining = duration

func stop_timer() -> void:
	"""Stop the timer"""
	time_limit = 0.0

func add_score(amount: int) -> void:
	score += amount
	if score >= level_target:
		emit_signal("score_changed")

func collect_food() -> void:
	food_collected += 1
	emit_signal("food_collected_changed", food_collected, food_total)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Mouse_Mode_Visibile"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif Input.is_action_just_pressed("Mouse_Mode_Capture"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	# Update countdown timer
	if time_limit > 0.0:
		time_remaining -= delta
		if time_remaining <= 0.0:
			time_remaining = 0.0
			emit_signal("time_over")
			stop_timer()
