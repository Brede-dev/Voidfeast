extends Node

var score: int = 0
var level_score: int = 0
var level_target: int = 0
var food_collected: int = 0
var food_total: int = 0
var total_food_owned: int = 0  # Persistent food count across all levels - CARRIES OVER BETWEEN LEVELS!
var purchased_items: Array = []  # Stores IDs of items that have been bought
var speed_multiplier: float = 1.0  # Track speed upgrade multiplier (1.0 = no upgrade, 2.0 = 2x speed)

signal score_changed
signal food_collected_changed(collected: int, total: int)
signal total_food_changed(amount: int)
signal speed_upgraded(new_multiplier: float)

func reset() -> void:
	score = 0
	level_score = 0
	level_target = 0
	food_collected = 0
	food_total = 0
	get_tree().change_scene_to_file("res://Scenes/LoseScreen.tscn")

func apply_speed_upgrade() -> void:
	speed_multiplier = 2.0
	save_speed_multiplier()  # Save it so it persists through scene changes
	print("⚡ SPEED UPGRADE APPLIED! speed_multiplier = ", speed_multiplier)
	emit_signal("speed_upgraded", speed_multiplier)

func start_level(target: int) -> void:
	level_target = 1#target
	level_score = 0
	food_collected = 0
	food_total = 1#target

func add_score(amount: int) -> void:
	score += amount
	level_score += amount
	if level_target > 0 and level_score >= level_target:
		emit_signal("score_changed")

func collect_food() -> void:
	food_collected += 1
	total_food_owned += 1
	emit_signal("food_collected_changed", food_collected, food_total)
	emit_signal("total_food_changed", total_food_owned)
	save_total_food()  # Save immediately so items persist between levels

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
		# Apply speed upgrade if this is the speed upgrade item
		if item_id == "speed_upgrade":
			apply_speed_upgrade()

func can_afford_speed_upgrade() -> bool:
	"""Check if player has 10 items to spend on speed upgrade"""
	return total_food_owned >= 10

func purchase_speed_upgrade() -> bool:
	"""Spend 10 items to purchase permanent speed upgrade. Returns true if successful."""
	if can_afford_speed_upgrade() and speed_multiplier == 1.0:
		total_food_owned -= 10  # Spend the items
		apply_speed_upgrade()  # Apply 2.0x multiplier
		add_purchased_item("speed_upgrade")  # Mark as purchased
		save_total_food()  # Save the spent items
		return true
	return false

func save_total_food() -> void:
	"""Save the persistent food count across levels"""
	var save_file: FileAccess = FileAccess.open("user://total_food.save", FileAccess.WRITE)
	save_file.store_var(total_food_owned)

func load_total_food() -> void:
	"""Load the persistent food count from previous sessions"""
	if FileAccess.file_exists("user://total_food.save"):
		var save_file: FileAccess = FileAccess.open("user://total_food.save", FileAccess.READ)
		total_food_owned = save_file.get_var()
	else:
		total_food_owned = 0

# Speed upgrades no longer persist - resets each game session

# Speed upgrades no longer persist - resets each game session

func save_speed_multiplier() -> void:
	var config: ConfigFile = ConfigFile.new()
	config.set_value("session", "speed_multiplier", speed_multiplier)
	var error: int = config.save("user://session_speed.save")
	if error == OK:
		print("💾 Saved speed_multiplier: ", speed_multiplier, " (to file: user://session_speed.save)")
	else:
		print("❌ ERROR saving speed_multiplier! Error code: ", error)

func load_speed_multiplier() -> void:
	var config: ConfigFile = ConfigFile.new()
	var error: int = config.load("user://session_speed.save")
	if error == OK:
		speed_multiplier = config.get_value("session", "speed_multiplier", 1.0)
		print("📂 Loaded speed_multiplier FROM FILE: ", speed_multiplier)
	else:
		speed_multiplier = 1.0
		print("📂 No session speed file - defaulting to 1.0")
	print("📂 Current speed_multiplier in memory: ", speed_multiplier)

func _enter_tree() -> void:
	# Load immediately when this node enters the scene tree
	load_speed_multiplier()

func _ready() -> void:
	load_purchased_items()
	# Speed multiplier already loaded in _enter_tree()
	load_total_food()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Mouse_Mode_Visibile"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif Input.is_action_just_pressed("Mouse_Mode_Capture"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
