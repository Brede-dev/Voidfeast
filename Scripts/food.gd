extends Area3D
const ROT_SPEED = 5

var is_golden: bool = false
var original_position: Vector3
var is_collected: bool = false
var collection_range_multiplier: float = 1.0
var _original_radius: float = 0.0
var _original_height: float = 0.0

func _ready() -> void:
	original_position = global_position
	# Store original shape values so upgrades don't compound
	var shape: CapsuleShape3D = $CollisionShape3D.shape
	if shape:
		_original_radius = shape.radius
		_original_height = shape.height
	# Apply any collection range upgrade that was already purchased
	set_collection_range(GameManager.collection_range_multiplier)

# Scale the collection range (always based on original values, so it won't compound)
func set_collection_range(multiplier: float) -> void:
	collection_range_multiplier = multiplier
	
	var shape: CapsuleShape3D = $CollisionShape3D.shape
	if shape:
		shape.radius = _original_radius * multiplier
		shape.height = _original_height * multiplier
		print("Food collection range set to %.1fx (radius: %.2f, height: %.2f)" % [multiplier, shape.radius, shape.height])

func _on_body_entered(body: Node3D) -> void:
	if body is not Player:
		return
	
	if is_collected:
		return
	
	is_collected = true
	
	if is_golden:
		GameManager.add_score(1, is_golden)
	else:
		GameManager.collect_food()
	
	await get_tree().create_timer(0.1).timeout
	hide()

func _process(delta: float) -> void:
	rotate_y(deg_to_rad(ROT_SPEED))

func apply_gold_shader() -> void:
	"""Apply gold tint shader to this food item"""
	is_golden = true
	# Load and apply the gold shader
	var shader: Shader = preload("res://Scripts/Shaders/gold_tint.gdshader")
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
	print("Respawning food with gold shader: ", name)
	is_collected = false
	global_position = original_position
	show()
	print("Food shown: ", name, " at position: ", global_position)
	$CollisionShape3D.disabled = false  # Re-enable collision for respawned food
	print("Collision re-enabled for: ", name)
	apply_gold_shader()
	print("Gold shader applied to: ", name)
