extends Area3D
const ROT_SPEED = 5

var is_golden: bool = false
var original_position: Vector3
var is_collected: bool = false

func _ready() -> void:
	original_position = global_position

func _on_body_entered(body: Node3D) -> void:
	if body is not Player:
		return
	
	if is_collected:
		return
	is_collected = true
	
	if is_golden:
		GameManager.add_score(1, is_golden)
	else:
		GameManager.collect_food()
	await get_tree().create_timer(0.1).timeout
	hide()



func _process(delta: float) -> void:
	rotate_y(deg_to_rad(ROT_SPEED))
