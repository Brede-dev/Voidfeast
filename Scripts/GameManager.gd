extends Node

var score : int = 0
var level_target : int = 0

signal score_changed

func reset():
	score = 0
	get_tree().reload_current_scene()
	
func add_score(amount):
	score+=amount
	if score >= level_target:
		print("boo")
		emit_signal("score_changed")

func _process(delta: float) -> void:
		# Toggle mouse capture
	if Input.is_action_just_pressed("Mouse_Mode_Visibile"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif Input.is_action_just_pressed("Mouse_Mode_Capture"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
