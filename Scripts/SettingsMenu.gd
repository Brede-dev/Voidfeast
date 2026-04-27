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
	
	# Focus on back button by default
	back_button.grab_focus()
	
	print("Settings Menu loaded successfully")

func _on_master_volume_changed(value: float) -> void:
	"""Handle master volume slider change"""
	print("Master volume changed to: %.1f" % value)
	# TODO: Apply master volume to AudioServer if needed
	# AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)

func _on_music_volume_changed(value: float) -> void:
	"""Handle music volume slider change"""
	print("Music volume changed to: %.1f" % value)
	# TODO: Apply music volume to AudioServer if needed

func _on_sfx_volume_changed(value: float) -> void:
	"""Handle SFX volume slider change"""
	print("SFX volume changed to: %.1f" % value)
	# TODO: Apply SFX volume to AudioServer if needed

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
