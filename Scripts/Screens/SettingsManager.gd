extends Node
## Handles general (non-audio) settings such as mouse sensitivity.
## Loads saved settings at startup and persists changes to disk.
const SETTINGS_PATH := "user://game_settings.cfg"
## The maximum mouse sensitivity multiplier the slider can reach.
## Current default sensitivity (0.002) maps to a slider value of 50.
const MAX_SENSITIVITY := 0.004
var mouse_sensitivity: float = 0.002

var silent_scenes: Array = [
	"res://Scenes/Game/Level1.tscn",
	"res://Scenes/Game/Level2.tscn",
	"res://Scenes/Game/Level3.tscn",
	"res://Scenes/Game/Level Extreme.tscn",
	"res://Scenes/Game/TutorialLevel.tscn"]

func should_play_music() -> bool:
	var current_scene = get_tree().current_scene.scene_file_path
	return current_scene not in silent_scenes

func _ready() -> void:
	load_settings()
	# Connect to scene changes
	get_tree().scene_changed.connect(_on_scene_changed)

func _on_scene_changed() -> void:
	"""Called when scene changes - toggle music based on scene"""
	if should_play_music():
		start_music()
	else:
		stop_music()

func stop_music() -> void:
	"""Stop the background music"""
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), true)

func start_music() -> void:
	"""Resume the background music"""
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), false)

## Slider range is 0-100. Maps to a sensitivity multiplier of 0..MAX_SENSITIVITY.
func set_mouse_sensitivity_slider(value: float) -> void:
	mouse_sensitivity = clampf(value, 0.0, 100.0) / 100.0 * MAX_SENSITIVITY
	save_settings()

func get_mouse_sensitivity_slider() -> float:
	return mouse_sensitivity / MAX_SENSITIVITY * 100.0

func get_mouse_sensitivity() -> float:
	return mouse_sensitivity

func load_settings() -> void:
	var config := ConfigFile.new()
	if config.load(SETTINGS_PATH) != OK:
		return
	var slider_value: float = config.get_value("settings", "mouse_sensitivity", 50.0)
	mouse_sensitivity = clampf(slider_value, 0.0, 100.0) / 100.0 * MAX_SENSITIVITY

func save_settings() -> void:
	var config := ConfigFile.new()
	config.set_value("settings", "mouse_sensitivity", get_mouse_sensitivity_slider())
	config.save(SETTINGS_PATH)
