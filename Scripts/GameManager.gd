# ============================================================
#  VoidFeast — GameManager.gd
#  Autoload Singleton  |  attach to: res://autoload/GameManager.gd
# ============================================================
class_name GameManager
extends Node

# ─────────────────────────────────────────
#  SIGNALS
# ─────────────────────────────────────────
signal health_changed(current: float, maximum: float)
signal score_changed(new_score: int)
signal lives_changed(new_lives: int)
signal item_collected(item_id: String)
signal inventory_updated(inventory: Array)
signal checkpoint_reached(position: Vector3)
signal level_changed(new_level: int)
signal enemy_died(remaining: int)
signal all_enemies_cleared
signal game_over
signal game_saved
signal game_loaded

# ─────────────────────────────────────────
#  PLAYER STATS
# ─────────────────────────────────────────
var max_health:       float = 100.0
var current_health:   float = 100.0

# ─────────────────────────────────────────
#  SCORE / LIVES / LEVEL
# ─────────────────────────────────────────
var score:         int = 0
var lives:         int = 3
var current_level: int = 1

# ─────────────────────────────────────────
#  INVENTORY
# ─────────────────────────────────────────
var inventory: Array = []          # Array of item_id Strings
var max_inventory_size: int = 20

# ─────────────────────────────────────────
#  WORLD STATE
# ─────────────────────────────────────────
var player: CharacterBody3D = null
var current_checkpoint: Vector3 = Vector3.ZERO
var enemies_alive: int = 0
var is_game_paused: bool = false
var items_collected_this_level: int = 0
var total_items_this_level: int = 0

# ─────────────────────────────────────────
#  SAVE DATA PATH
# ─────────────────────────────────────────
const SAVE_PATH = "user://voidfeast_save.json"


# ════════════════════════════════════════════
#  BUILT-IN
# ════════════════════════════════════════════
func _ready() -> void:
	print("[VoidFeast] GameManager online.")


func _process(delta: float) -> void:
	pass


# ════════════════════════════════════════════
#  PLAYER REGISTRATION
# ════════════════════════════════════════════
func register_player(p: CharacterBody3D) -> void:
	player = p
	print("[VoidFeast] Player registered: ", p.name)


func get_player_position() -> Vector3:
	if player:
		return player.global_position
	return Vector3.ZERO


# ════════════════════════════════════════════
#  HEALTH
# ════════════════════════════════════════════
func take_damage(amount: float) -> void:
	current_health = clamp(current_health - amount, 0.0, max_health)
	emit_signal("health_changed", current_health, max_health)
	if current_health <= 0.0:
		_on_player_death()


func heal(amount: float) -> void:
	current_health = clamp(current_health + amount, 0.0, max_health)
	emit_signal("health_changed", current_health, max_health)


func _on_player_death() -> void:
	lives -= 1
	emit_signal("lives_changed", lives)
	if lives <= 0:
		emit_signal("game_over")
		get_tree().change_scene_to_file("res://scenes/GameOver.tscn")
	else:
		respawn_player()





# ════════════════════════════════════════════
#  SCORE
# ════════════════════════════════════════════
func add_score(points: int) -> void:
	score += points
	emit_signal("score_changed", score)


# ════════════════════════════════════════════
#  INVENTORY
# ════════════════════════════════════════════
func collect_item(item_id: String) -> bool:
	if inventory.size() >= max_inventory_size:
		print("[VoidFeast] Inventory full!")
		return false
	inventory.append(item_id)
	items_collected_this_level += 1
	emit_signal("item_collected", item_id)
	emit_signal("inventory_updated", inventory)
	_check_level_completion()
	return true


func remove_item(item_id: String) -> bool:
	var idx = inventory.find(item_id)
	if idx == -1:
		return false
	inventory.remove_at(idx)
	emit_signal("inventory_updated", inventory)
	return true


func has_item(item_id: String) -> bool:
	return inventory.has(item_id)


func clear_inventory() -> void:
	inventory.clear()
	emit_signal("inventory_updated", inventory)


# ════════════════════════════════════════════
#  ENEMIES
# ════════════════════════════════════════════
func register_enemy() -> void:
	enemies_alive += 1


func on_enemy_died() -> void:
	enemies_alive = max(enemies_alive - 1, 0)
	emit_signal("enemy_died", enemies_alive)
	if enemies_alive <= 0:
		emit_signal("all_enemies_cleared")


# ════════════════════════════════════════════
#  CHECKPOINTS & RESPAWN
# ════════════════════════════════════════════
func set_checkpoint(pos: Vector3) -> void:
	current_checkpoint = pos
	emit_signal("checkpoint_reached", pos)
	print("[VoidFeast] Checkpoint set at: ", pos)


func respawn_player() -> void:
	if player:
		player.global_position = current_checkpoint
		current_health = max_health * 0.5   # respawn at 50% health
		emit_signal("health_changed", current_health, max_health)
		print("[VoidFeast] Player respawned at checkpoint.")


# ════════════════════════════════════════════
#  LEVEL MANAGEMENT
# ════════════════════════════════════════════
func start_level(level_number: int, item_count: int) -> void:
	current_level = level_number
	total_items_this_level = item_count
	items_collected_this_level = 0
	enemies_alive = 0
	emit_signal("level_changed", current_level)
	print("[VoidFeast] Level %d started. Items to collect: %d" % [current_level, item_count])


func _check_level_completion() -> void:
	if total_items_this_level > 0 and items_collected_this_level >= total_items_this_level:
		print("[VoidFeast] All items collected! Level complete.")
		_advance_level()


func _advance_level() -> void:
	current_level += 1
	add_score(100 * current_level)   # bonus score per level
	emit_signal("level_changed", current_level)
	# Load next level scene — adjust path to your scene naming convention
	get_tree().change_scene_to_file("res://scenes/Level%d.tscn" % current_level)


# ════════════════════════════════════════════
#  PAUSE
# ════════════════════════════════════════════
func toggle_pause() -> void:
	is_game_paused = !is_game_paused
	get_tree().paused = is_game_paused
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if !is_game_paused else Input.MOUSE_MODE_VISIBLE


# ════════════════════════════════════════════
#  CAMERA SHAKE  (call shake() on your Camera3D)
# ════════════════════════════════════════════
func shake_camera(intensity: float = 0.5, duration: float = 0.3) -> void:
	var cam = get_viewport().get_camera_3d()
	if cam and cam.has_method("shake"):
		cam.shake(intensity, duration)


# ════════════════════════════════════════════
#  SAVE & LOAD
# ════════════════════════════════════════════
func save_game() -> void:
	var data = {
		"score":               score,
		"lives":               lives,
		"current_level":       current_level,
		"current_health":      current_health,
		"max_health":          max_health,
		"inventory":           inventory,
		"checkpoint_x":        current_checkpoint.x,
		"checkpoint_y":        current_checkpoint.y,
		"checkpoint_z":        current_checkpoint.z,
	}
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data))
		file.close()
		emit_signal("game_saved")
		print("[VoidFeast] Game saved.")
	else:
		push_error("[VoidFeast] Failed to open save file for writing.")


func load_game() -> bool:
	if not FileAccess.file_exists(SAVE_PATH):
		print("[VoidFeast] No save file found.")
		return false
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not file:
		push_error("[VoidFeast] Failed to open save file for reading.")
		return false
	var data = JSON.parse_string(file.get_as_text())
	file.close()
	if typeof(data) != TYPE_DICTIONARY:
		push_error("[VoidFeast] Save file is corrupt.")
		return false

	score               = data.get("score", 0)
	lives               = data.get("lives", 3)
	current_level       = data.get("current_level", 1)
	current_health      = data.get("current_health", max_health)
	max_health          = data.get("max_health", 100.0)
	inventory           = data.get("inventory", [])
	current_checkpoint  = Vector3(
		data.get("checkpoint_x", 0.0),
		data.get("checkpoint_y", 0.0),
		data.get("checkpoint_z", 0.0)
	)

	emit_signal("health_changed",      current_health,      max_health)
	emit_signal("score_changed",       score)
	emit_signal("lives_changed",       lives)
	emit_signal("inventory_updated",   inventory)
	emit_signal("game_loaded")
	print("[VoidFeast] Game loaded. Level: %d, Score: %d" % [current_level, score])
	return true


func delete_save() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(SAVE_PATH)
		print("[VoidFeast] Save file deleted.")


# ════════════════════════════════════════════
#  FULL RESET  (new run)
# ════════════════════════════════════════════
func reset_game() -> void:
	score               = 0
	lives               = 3
	current_level       = 1
	current_health      = max_health
	inventory.clear()
	enemies_alive       = 0
	items_collected_this_level = 0
	total_items_this_level     = 0
	current_checkpoint  = Vector3.ZERO
	emit_signal("health_changed",      current_health,      max_health)
	emit_signal("score_changed",       score)
	emit_signal("lives_changed",       lives)
	emit_signal("inventory_updated",   inventory)
	print("[VoidFeast] Game reset.")
