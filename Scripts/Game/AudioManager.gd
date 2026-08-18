extends Node

## Handles the Master, Music, and SFX audio buses.
## Loads saved volumes at startup and applies them to the audio buses.

const SETTINGS_PATH := "user://audio_settings.cfg"
const MASTER_BUS := "Master"
const MUSIC_BUS := "Music"
const SFX_BUS := "SFX"

var master_volume: float = 80.0
var music_volume: float = 70.0
var sfx_volume: float = 80.0


func _ready() -> void:
	load_settings()
	apply_all()


## Apply all stored volumes to their buses.
func apply_all() -> void:
	set_bus_volume(MASTER_BUS, master_volume)
	set_bus_volume(MUSIC_BUS, music_volume)
	set_bus_volume(SFX_BUS, sfx_volume)


func set_master_volume(value: float) -> void:
	master_volume = value
	set_bus_volume(MASTER_BUS, value)
	save_settings()


func set_music_volume(value: float) -> void:
	music_volume = value
	set_bus_volume(MUSIC_BUS, value)
	save_settings()


func set_sfx_volume(value: float) -> void:
	sfx_volume = value
	set_bus_volume(SFX_BUS, value)
	save_settings()


func get_master_volume() -> float:
	return master_volume


func get_music_volume() -> float:
	return music_volume


func get_sfx_volume() -> float:
	return sfx_volume


## Set a bus's volume (0-100) and mute it when at zero.
func set_bus_volume(bus_name: String, value: float) -> void:
	var idx: int = AudioServer.get_bus_index(bus_name)
	if idx == -1:
		return
	var clamped: float = clampf(value, 0.0, 100.0)
	AudioServer.set_bus_volume_db(idx, linear_to_db(clamped / 100.0))
	AudioServer.set_bus_mute(idx, clamped <= 0.0)


func load_settings() -> void:
	var config := ConfigFile.new()
	if config.load(SETTINGS_PATH) != OK:
		return
	master_volume = config.get_value("audio", "master_volume", 80.0)
	music_volume = config.get_value("audio", "music_volume", 70.0)
	sfx_volume = config.get_value("audio", "sfx_volume", 80.0)


func save_settings() -> void:
	var config := ConfigFile.new()
	config.set_value("audio", "master_volume", master_volume)
	config.set_value("audio", "music_volume", music_volume)
	config.set_value("audio", "sfx_volume", sfx_volume)
	config.save(SETTINGS_PATH)
