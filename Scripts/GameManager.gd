extends Node

var score: int = 0
var level_score: int = 0
var level_target: int = 0
var food_collected: int = 0
var food_total: int = 0
var golden_food_collected: int = 0  # Tracks golden food collected
var golden_food_total: int = 0  # Total golden food available
var total_food_owned: int = 0  # Persistent food count across all levels
var purchased_items: Array = []  # Stores IDs of items that have been bought

signal score_changed
signal food_collected_changed(collected: int, total: int)
signal golden_food_collected_changed(collected: int, total: int)
signal total_food_changed(amount: int)
signal all_food_collected  # Emitted when all NORMAL food in the current round is collected
signal all_golden_food_collected  # Emitted when all GOLDEN food is collected
signal food_respawned_with_gold  # Emitted when food respawns with gold shader

var counting_food_score: bool = false  # Only count score after gold food appears

func reset() -> void:
	score = 0
	level_score = 0
	level_target = 0
	food_collected = 0
	food_total = 0
	golden_food_collected = 0
	golden_food_total = 0
	get_tree().change_scene_to_file("res://Scenes/LoseScreen.tscn")

func start_level(target: int) -> void:
	level_target = target
	level_score = 0
	food_collected = 0
	food_total = target
	golden_food_collected = 0
	golden_food_total = target  # Golden food total will be same as normal food total

func add_score(amount: int, is_golden: bool = false) -> void:
	score += amount
	level_score += amount
	
	if is_golden:
		golden_food_collected += amount
		emit_signal("golden_food_collected_changed", golden_food_collected, golden_food_total)
		
		# Check if all golden food has been collected
		if golden_food_collected >= golden_food_total and golden_food_total > 0:
			emit_signal("all_golden_food_collected")
	
	if level_target > 0 and level_score >= level_target:
		emit_signal("score_changed")

func collect_food() -> void:
	food_collected += 1
	total_food_owned += 1
	emit_signal("food_collected_changed", food_collected, food_total)
	emit_signal("total_food_changed", total_food_owned)
	
	# Check if all food in this round has been collected
	if food_collected >= food_total and food_total > 0:
		emit_signal("all_food_collected")

func reset_food_collection() -> void:
	"""Reset food collection counter when beacon respawns food with gold shader"""
	food_collected = 0
	emit_signal("food_collected_changed", food_collected, food_total)

func reset_golden_food_collection() -> void:
	"""Reset golden food collection counter when beacon respawns food"""
	golden_food_collected = 0
	emit_signal("golden_food_collected_changed", golden_food_collected, golden_food_total)

func purchase_item(item_id: String) -> void:
	if item_id not in purchased_items:
		purchased_items.append(item_id)
		save_purchased_items()

func is_item_purchased(item_id: String) -> bool:
	return item_id in purchased_items

func save_purchased_items() -> void:
	var save_file: FileAccess = FileAccess.open("user://purchased_items.save", FileAccess.WRITE)
	save_file.store_var(purchased_items)

func load_purchased_items() -> void:
	if FileAccess.file_exists("user://purchased_items.save"):
		var save_file: FileAccess = FileAccess.open("user://purchased_items.save", FileAccess.READ)
		purchased_items = save_file.get_var()

func get_purchased_items() -> Array:
	return purchased_items

func add_purchased_item(item_id: String) -> void:
	if item_id not in purchased_items:
		purchased_items.append(item_id)
		save_purchased_items()

func _ready() -> void:
	load_purchased_items()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Mouse_Mode_Visibile"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif Input.is_action_just_pressed("Mouse_Mode_Capture"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
