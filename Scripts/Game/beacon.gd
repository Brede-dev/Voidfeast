extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Area3D/CollisionShape3D.disabled = true
	hide()
	GameManager.all_food_collected.connect(update_beacon)

func update_beacon():
	$Area3D/CollisionShape3D.disabled = false
	show()
	$Beacon.play()
	# Respawn all food items with gold shader when beacon is activated
	respawn_all_food_with_gold_shader()
	GameManager.reset_food_collection()
	GameManager.reset_golden_food_collection()
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		# Go to win screen (food already respawned with gold shader when beacon was activated)
		FadeTransition.fade_to_scene("res://Scenes/Screens/WinScreen.tscn")

func respawn_all_food_with_gold_shader() -> void:
	"""Find all food items in the level and respawn them with gold shader"""
	print("=== BEACON: Starting food respawn ===")
	# Get the level node (parent of beacon)
	var level: Node = get_parent()
	print("Level node: ", level.name)
	
	# Recursively find all Food nodes and respawn them
	var food_items: Array = find_all_food_nodes(level)
	print("Found %d food items to respawn" % food_items.size())
	for food in food_items:
		print("Respawning food: ", food.name)
		food.respawn_with_gold_shader()
	print("=== BEACON: Food respawn complete ===")

func find_all_food_nodes(node: Node) -> Array:
	"""Recursively find all nodes with Food script (food.gd)"""
	var food_list: Array = []
	
	# Check if this node has the food.gd script
	if node.get_script():
		var script_path: String = node.get_script().resource_path
		print("Checking node: ", node.name, " - Script: ", script_path)
		# Check if node has the food.gd script (handle both path formats)
		if script_path.ends_with("food.gd") and node.has_method("respawn_with_gold_shader"):
			print("  FOUND FOOD NODE: ", node.name)
			food_list.append(node)
	
	for child in node.get_children():
		food_list += find_all_food_nodes(child)
	
	return food_list
