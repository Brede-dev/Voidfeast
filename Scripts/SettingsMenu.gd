class_name SettingsMenu
extends Control

signal settings_closed()

@onready var back_button: Button = $VBoxContainer/BackButton
@onready var master_volume_slider: HSlider = $VBoxContainer/MasterVolumeContainer/MasterVolumeSlider
@onready var music_volume_slider: HSlider = $VBoxContainer/MusicVolumeContainer/MusicVolumeSlider
@onready var sfx_volume_slider: HSlider = $VBoxContainer/SFXVolumeContainer/SFXVolumeSlider
@onready var mouse_sensitivity_slider: HSlider = $VBoxContainer/MouseSensitivityContainer/MouseSensitivitySlider

var on_close_callback: Callable = Callable()

func _ready() -> void:
	# Connect button signals
	back_button.pressed.connect(_on_back_pressed)
	
	# Connect slider signals
	master_volume_slider.value_changed.connect(_on_master_volume_changed)
	music_volume_slider.value_changed.connect(_on_music_volume_changed)
	sfx_volume_slider.value_changed.connect(_on_sfx_volume_changed)
	mouse_sensitivity_slider.value_changed.connect(_on_mouse_sensitivity_changed)
	
	# Set initial slider values from the AudioManager's saved settings
	master_volume_slider.value = AudioManager.get_master_volume()
	music_volume_slider.value = AudioManager.get_music_volume()
	sfx_volume_slider.value = AudioManager.get_sfx_volume()
	mouse_sensitivity_slider.value = SettingsManager.get_mouse_sensitivity_slider()
	
	# Focus on back button by default
	back_button.grab_focus()
	
	print("Settings Menu loaded successfully")

func _on_master_volume_changed(value: float) -> void:
	"""Handle master volume slider change - apply to the Master audio bus"""
	AudioManager.set_master_volume(value)

func _on_music_volume_changed(value: float) -> void:
	"""Handle music volume slider change - apply to the Music audio bus"""
	AudioManager.set_music_volume(value)

func _on_sfx_volume_changed(value: float) -> void:
	"""Handle SFX volume slider change - apply to the SFX audio bus"""
	AudioManager.set_sfx_volume(value)

func _on_mouse_sensitivity_changed(value: float) -> void:
	"""Handle mouse sensitivity slider change - apply and persist the new sensitivity"""
	SettingsManager.set_mouse_sensitivity_slider(value)

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
