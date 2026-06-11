extends Node

func _ready() -> void:
	var food_count: int = get_tree().get_node_count_in_group("Food")
	GameManager.start_level(food_count)#goldenfo	odcount
