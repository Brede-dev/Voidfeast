extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Area3D/CollisionShape3D.disabled = true
	hide()
	GameManager.all_food_collected.connect(update_beacon)

func update_beacon():
	$Area3D/CollisionShape3D.disabled = false
	show()
	# Respawn all food items with gold shader when beacon is activated
	respawn_all_food_with_gold_shader()
	GameManager.reset_food_collection()
	GameManager.reset_golden_food_collection()
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		# Go to win screen (food already respawned with gold shader when beacon was activated)
		get_tree().change_scene_to_file("res://Scenes/WinScreen.tscn")

func respawn_all_food_with_gold_shader() -> void:
	"""Find all food items in the level and respawn them with gold shader"""
	# Get the root level node
	var level: Node = get_tree().root.get_child(0)
	
	# Recursively find all Food nodes and respawn them
	var food_items: Array = find_all_food_nodes(level)
	for food in food_items:
		if food.has_method("respawn_with_gold_shader"):
			food.respawn_with_gold_shader()

func find_all_food_nodes(node: Node) -> Array:
	"""Recursively find all nodes with Food script (food.gd)"""
	var food_list: Array = []
	
	if node.get_script() and node.get_script().resource_path == "res://Scripts/food.gd":
		food_list.append(node)
	
	for child in node.get_children():
		food_list += find_all_food_nodes(child)
	
	return food_list
