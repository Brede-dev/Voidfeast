extends Area3D
const ROT_SPEED = 5

var is_golden: bool = false  # Tracks if this food has the gold shader applied
var original_position: Vector3  # Store original position for respawning
var is_collected: bool = false  # Track if food has been collected

func _ready() -> void:
	original_position = global_position  # Store the starting position

func _on_body_entered(body: Node3D) -> void:
	if body is not Player:
		return
	
	is_collected = true
	
	# Only add to score if the food is golden (after beacon activation)
	if is_golden:
		GameManager.add_score(1, is_golden)
	else:
		GameManager.collect_food()  # Only count normal food collection, not golden
	
	hide()  # Hide instead of deleting, so it can respawn later

func _process(delta: float) -> void:
	rotate_y(deg_to_rad(ROT_SPEED))

func apply_gold_shader() -> void:
	"""Apply gold tint shader to this food item"""
	is_golden = true
	# Load and apply the gold shader
	var shader: Shader = preload("res://Shaders/gold_tint.gdshader")
	var material: ShaderMaterial = ShaderMaterial.new()
	material.shader = shader
	material.set_shader_parameter("tint_color", Vector3(1.0, 0.843, 0.0))
	material.set_shader_parameter("tint_strength", 0.8)
	
	# Recursively apply material to all MeshInstance3D children
	apply_material_recursive(self, material)

func apply_material_recursive(node: Node, material: Material) -> void:
	"""Recursively apply material to all MeshInstance3D nodes"""
	if node is MeshInstance3D:
		node.set_surface_override_material(0, material)
	
	for child in node.get_children():
		apply_material_recursive(child, material)

func respawn_with_gold_shader() -> void:
	"""Respawn this food item at its original position with gold shader"""
	is_collected = false
	global_position = original_position
	show()
	apply_gold_shader()
