extends Node
class_name LevelManager

var map_pieces: Node
var platform_deletion_active: bool = false
var beacon_instance: Node3D

var current_zone_radius: float = 0.0
var zone_shrink_speed: float = 1.0
var initial_max_radius: float = 0.0

# --- Warning settings ---
var warning_margin: float = 4.0   # start warning when this close to being swallowed
var warned_platforms: Dictionary = {} # tracks platforms currently warning

func _ready() -> void:
	var food_count: int = get_tree().get_node_count_in_group("Food")
	GameManager.start_level(food_count)
	map_pieces = get_node("Map Pieces")
	GameManager.all_food_collected.connect(_on_beacon_activated)

func _process(delta: float) -> void:
	if platform_deletion_active:
		_process_zone_shrink(delta)

func _on_beacon_activated() -> void:
	print("Beacon activated! Starting zone closure...")
	start_platform_deletion()

func start_platform_deletion() -> void:
	if not map_pieces:
		print("ERROR: Map Pieces node not found!")
		return
	
	var all_platforms: Array = map_pieces.get_children()
	if all_platforms.is_empty():
		return
	
	await get_tree().create_timer(0.8).timeout   # wait once, not per-platform
	
	for platform in all_platforms:
		if platform:
			var distance: float = sqrt(platform.global_position.x ** 2 + platform.global_position.z ** 2)
			if distance > initial_max_radius:
				initial_max_radius = distance
	
	current_zone_radius = initial_max_radius
	platform_deletion_active = true
	
	print("=== ZONE DELETION STARTED ===")
	print("Starting Radius: %.2f | Shrink Speed: %.2f units/sec" % [current_zone_radius, zone_shrink_speed])

func _process_zone_shrink(delta: float) -> void:
	current_zone_radius -= zone_shrink_speed * delta

	if current_zone_radius <= 0:
		current_zone_radius = 0
		platform_deletion_active = false
		print("Zone fully closed!")

	var all_platforms: Array = map_pieces.get_children()

	for platform in all_platforms:
		if platform == null or platform.is_queued_for_deletion():
			continue
		if platform.is_in_group("Safe"):
			continue

		var distance: float = sqrt(platform.global_position.x ** 2 + platform.global_position.z ** 2)

		if distance > current_zone_radius:
			# Actually swallowed — stop any warning tween and delete
			if warned_platforms.has(platform):
				var tw: Tween = warned_platforms[platform]
				if tw and tw.is_valid():
					tw.kill()
				warned_platforms.erase(platform)
			print("Zone swallowed: %s" % platform.name)
			platform.queue_free()

		elif distance > current_zone_radius - warning_margin:
			# Getting close — start the warning if not already warning
			if not warned_platforms.has(platform):
				_start_platform_warning(platform)

func _start_platform_warning(platform: Node3D) -> void:
	var meshes: Array = _find_mesh_instances(platform)
	var tween: Tween = create_tween()
	tween.set_loops()

	if meshes.is_empty():
		# Fallback: no mesh found, just bob the whole platform
		var start_pos: Vector3 = platform.position
		tween.tween_property(platform, "position:y", start_pos.y - 0.1, 0.15)
		tween.tween_property(platform, "position:y", start_pos.y, 0.15)
	else:
		# Animate every mesh found under this platform, in parallel
		for mesh in meshes:
			var original_scale: Vector3 = mesh.scale
			tween.set_parallel(true)
			tween.tween_property(mesh, "scale", original_scale * 0.9, 0.3)
		tween.set_parallel(false)
		tween.chain().set_parallel(true)
		for mesh in meshes:
			tween.tween_property(mesh, "scale", mesh.scale, 0.3) # scale is already original after tween sets it back... see note below

	warned_platforms[platform] = tween

func _find_mesh_instances(node: Node) -> Array:
	"""Recursively find all MeshInstance3D nodes under a given node"""
	var result: Array = []
	for child in node.get_children():
		if child is MeshInstance3D:
			result.append(child)
		result.append_array(_find_mesh_instances(child))
	return result
