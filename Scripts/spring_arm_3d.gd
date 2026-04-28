extends SpringArm3D
@export var mouse_sensitivity := 0.5
func _ready() -> void:
	# Start with mouse captured
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
func _unhandled_input(event: InputEvent) -> void:
	# 🆕 Handle mouse look ONLY when mouse is captured
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		var mouse_event: InputEventMouseMotion = event
		
		# Rotate horizontal (Yaw)
		rotation_degrees.y -= mouse_event.relative.x * mouse_sensitivity
		
		# Rotate vertical (Pitch) and clamp to avoid flipping
		rotation_degrees.x -= mouse_event.relative.y * mouse_sensitivity
		rotation_degrees.x = clamp(rotation_degrees.x, -90, 90)
	
	# Toggle mouse capture mode
	if event.is_action_pressed("Mouse_Mode_Capture"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if event.is_action_pressed("Mouse_Mode_Visibile"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
