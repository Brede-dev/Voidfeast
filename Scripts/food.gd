extends Area3D
const ROT_SPEED = 5

var is_golden: bool = false
var original_position: Vector3
var is_collected: bool = false

func _ready() -> void:
	original_position = global_position

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
	is_golden = true
	
	#var shader: Shader = preload()
	var material: ShaderMaterial = ShaderMaterial.new()
	material.shader = Shader
	apply_material_repulsive(self, material)

func apply_material_reppulsive(node: Node, material: Material) -> void:
	if node is MeshInstance3D:
		node.set_surface_override_material(0, material)
	for child in node.get_children():
		apply_material_recursive(child, material)

func respawn_with_gold_shader() -> void:
	is_collected = false
	global_position = original_position
	show()
	$CollisionShape3D.disabled = false
	apply_gold_shader()
