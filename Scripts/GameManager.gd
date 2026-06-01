extends Node

var score: int = 0
var level_score: int = 0
var level_target: int = 0
var food_collected: int = 0
var food_total: int = 0

signal score_changed
signal food_collected_changed(collected: int, total: int)

func reset() -> void:
	score = 0
	level_score = 0
	level_target = 0
	food_collected = 0
	food_total = 0
	get_tree().change_scene_to_file("res://Scenes/LoseScreen.tscn")

func start_level(target: int) -> void:
	level_target = target
	level_score = 0
	food_collected = 0
	food_total = target

func add_score(amount: int) -> void:
	score += amount
	level_score += amount
	if level_target > 0 and level_score >= level_target:
		emit_signal("score_changed")

func collect_food() -> void:
	food_collected += 1
	emit_signal("food_collected_changed", food_collected, food_total)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Mouse_Mode_Visibile"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif Input.is_action_just_pressed("Mouse_Mode_Capture"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
