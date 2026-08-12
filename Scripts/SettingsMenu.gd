class_name SettingsMenu
extends Control

signal settings_closed()

@onready var back_button: Button = $VBoxContainer/BackButton
@onready var master_volume_slider: HSlider = $VBoxContainer/MasterVolumeContainer/MasterVolumeSlider
@onready var music_volume_slider: HSlider = $VBoxContainer/MusicVolumeContainer/MusicVolumeSlider
@onready var sfx_volume_slider: HSlider = $VBoxContainer/SFXVolumeContainer/SFXVolumeSlider

var on_close_callback: Callable = Callable()

func _ready() -> void:
	# Connect button signals
	back_button.pressed.connect(_on_back_pressed)
	
	# Connect slider signals
	master_volume_slider.value_changed.connect(_on_master_volume_changed)
	music_volume_slider.value_changed.connect(_on_music_volume_changed)
	sfx_volume_slider.value_changed.connect(_on_sfx_volume_changed)
	
	# Set initial slider values
	master_volume_slider.value = 80.0
	music_volume_slider.value = 70.0
	sfx_volume_slider.value = 80.0
	
	# Apply initial volume values to AudioServer
	_on_master_volume_changed(master_volume_slider.value)
	_on_music_volume_changed(music_volume_slider.value)
	_on_sfx_volume_changed(sfx_volume_slider.value)
	
	# Focus on back button by default
	back_button.grab_focus()
	
	print("Settings Menu loaded successfully")

func _convert_slider_to_db(slider_value: float) -> float:
	"""Convert slider value (0-100) to decibel value for AudioServer"""
	# If value is 0, return -80 dB (effectively silent)
	if slider_value <= 0:
		return -80.0
	# Otherwise convert linearly to range from -40 dB to 0 dB
	# 100 = 0 dB (max volume), 0 = -80 dB (silent)
	return linear_to_db(slider_value / 100.0)

func _on_master_volume_changed(value: float) -> void:
	"""Handle master volume slider change"""
	print("Master volume changed to: %.1f%%" % value)
	var db_value: float = _convert_slider_to_db(value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), db_value)

func _on_music_volume_changed(value: float) -> void:
	"""Handle music volume slider change"""
	print("Music volume changed to: %.1f%%" % value)
	var db_value: float = _convert_slider_to_db(value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), db_value)

func _on_sfx_volume_changed(value: float) -> void:
	"""Handle SFX volume slider change"""
	print("SFX volume changed to: %.1f%%" % value)
	var db_value: float = _convert_slider_to_db(value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), db_value)

func _on_back_pressed() -> void:
	"""Handle Back button press - hide settings panel"""
	print("Back button pressed - Closing settings...")
	visible = false
	settings_closed.emit()
	if on_close_callback.is_valid():
		on_close_callback.call()

func set_on_close_callback(callback: Callable) -> void:
	"""Set a callback to be called when settings are closed"""
	on_close_callback = callback
