extends Node

var score: int = 0
var level_score: int = 0
var level_target: int = 0
var food_collected: int = 0
var food_total: int = 0
var golden_food_collected: int = 0
var golden_food_total: int = 0
var total_food_owned: int = 0  # Persistent food count across all levels - CARRIES OVER BETWEEN LEVELS!
var purchased_items: Array = []  # Stores IDs of items that have been bought
var speed_multiplier: float = 1.0  # Track speed upgrade multiplier (1.0 = no upgrade, 2.0 = 2x speed)
var jump_upgrade: float = 1.0
var counting_food_score: bool = false

signal score_changed
signal food_collected_changed(collected: int, total: int)
signal golden_food_collected_changed(collected: int, total: int)
signal total_food_changed(amount: int)
signal all_food_collected
signal all_golden_food_collected
signal food_respawned_with_gold
signal speed_upgraded(new_multiplier: float)
signal jump_boosted(new_multiplier: float)



func reset() -> void:
	score = 0
	level_score = 0
	level_target = 0
	food_collected = 0
	food_total = 0
	golden_food_collected = 0
	golden_food_total = 0
	get_tree().change_scene_to_file("res://Scenes/LoseScreen.tscn")

func apply_speed_upgrade() -> void:
	speed_multiplier = 2.0
	save_speed_multiplier()  # Save it so it persists through scene changes
	print(" SPEED UPGRADE APPLIED! speed_multiplier = ", speed_multiplier)
	emit_signal("speed_upgraded", speed_multiplier)

func apply_jump_upgrade() -> void:
	jump_upgrade = 2.0
	save_jump_boost()  # Save it so it persists through scene changes
	print(" JUMP BOOST UPGRADE APPLIED! jump_upgrade = ", jump_upgrade)
	emit_signal("jump_boosted", jump_upgrade)

func apply_double_jump_upgrade() -> void:
	print(" DOUBLE JUMP UPGRADE APPLIED!")

func start_level(target: int) -> void:
	level_target = target
	level_score = 0
	food_collected = 0
	food_total = target
	golden_food_collected = 0
	golden_food_total = target

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
		# Apply speed upgrade if this is the speed upgrade item
		if item_id == "speed_upgrade":
			apply_speed_upgrade()
		# Apply double jump upgrade if this is the double jump upgrade item
		elif item_id == "double_jump_upgrade":
			apply_double_jump_upgrade()
		elif item_id == "high_jump_upgrade":
			apply_jump_upgrade()  # FIXED: was calling apply_double_jump_upgrade()

func can_afford_speed_upgrade() -> bool:
	"""Check if player has 10 GOLDEN FRUIT to spend on speed upgrade"""
	return golden_food_collected >= 10

func can_afford_jump_boost() -> bool:
	"""Check if player has 10 GOLDEN FRUIT to spend on jump boost"""
	return golden_food_collected >= 10

func purchase_speed_upgrade() -> bool:
	"""Spend 10 GOLDEN FRUIT to purchase permanent speed upgrade. Returns true if successful."""
	if can_afford_speed_upgrade() and speed_multiplier == 1.0:
		golden_food_collected -= 10  # Spend the golden fruit
		apply_speed_upgrade()  # Apply 2.0x multiplier
		add_purchased_item("speed_upgrade")  # Mark as purchased
		save_total_food()  # Save the spent items
		return true
	return false

func purchase_jump_boost() -> bool:
	"""Spend 10 GOLDEN FRUIT to purchase permanent jump boost. Returns true if successful."""
	if can_afford_jump_boost() and jump_upgrade == 1.0:
		golden_food_collected -= 10  # Spend the golden fruit
		apply_jump_upgrade()  # Apply 2.0x multiplier
		add_purchased_item("jump_upgrade")  # Mark as purchased
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

# Speed/jump upgrades share one session config file, so we always load-then-set-then-save
# to avoid one upgrade's save wiping out the other's value.

func save_speed_multiplier() -> void:
	var config: ConfigFile = ConfigFile.new()
	config.load("user://session_speed.save")  # FIXED: load existing values first
	config.set_value("session", "speed_multiplier", speed_multiplier)
	var error: int = config.save("user://session_speed.save")
	if error == OK:
		print("💾 Saved speed_multiplier: ", speed_multiplier, " (to file: user://session_speed.save)")
	else:
		print("❌ ERROR saving speed_multiplier! Error code: ", error)

func save_jump_boost() -> void:
	var config: ConfigFile = ConfigFile.new()
	config.load("user://session_speed.save")  # FIXED: load existing values first
	config.set_value("session", "jump_upgrade", jump_upgrade)
	var error: int = config.save("user://session_speed.save")
	if error == OK:
		print("💾 Saved jump_upgrade: ", jump_upgrade, " (to file: user://session_speed.save)")
	else:
		print("❌ ERROR saving jump_upgrade! Error code: ", error)

func load_speed_multiplier() -> void:
	var config: ConfigFile = ConfigFile.new()
	var error: int = config.load("user://session_speed.save")
	if error == OK:
		speed_multiplier = config.get_value("session", "speed_multiplier", 1.0)
		print("📂 Loaded speed_multiplier FROM FILE: ", speed_multiplier)
	else:
		speed_multiplier = 1.0
		print("📂 No session speed file - defaulting to 1.0")

func load_jump_boost() -> void:
	# FIXED: this loader didn't exist before, so jump_upgrade was never restored
	var config: ConfigFile = ConfigFile.new()
	var error: int = config.load("user://session_speed.save")
	if error == OK:
		jump_upgrade = config.get_value("session", "jump_upgrade", 1.0)
		print("📂 Loaded jump_upgrade FROM FILE: ", jump_upgrade)
	else:
		jump_upgrade = 1.0
		print("📂 No session jump file - defaulting to 1.0")

func _enter_tree() -> void:
	# Load immediately when this node enters the scene tree
	load_speed_multiplier()
	load_jump_boost()  # FIXED: was never being loaded before

func _ready() -> void:
	load_purchased_items()
	# Speed multiplier and jump upgrade already loaded in _enter_tree()
	load_total_food()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Mouse_Mode_Visibile"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif Input.is_action_just_pressed("Mouse_Mode_Capture"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
