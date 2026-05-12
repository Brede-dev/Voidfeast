extends Node

func _ready():
	var food_count = get_tree().get_node_count_in_group("Food")
	GameManager.level_target = food_count
	GameManager.score = 0
