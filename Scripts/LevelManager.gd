extends Node

class_name LevelManager

# Platform deletion settings
var map_pieces: Node
var platform_deletion_active: bool = false
var beacon_instance: Node3D

# --- New Zone Shrinking Variables ---
var current_zone_radius: float = 0.0
var zone_shrink_speed: float = 1.0 # Units per second the zone closes in
var initial_max_radius: float = 0.0

func _ready() -> void:
	var food_count: int = get_tree().get_node_count_in_group("Food")
	GameManager.start_level(food_count)
	
	# Get the map pieces node
	map_pieces = get_node("Map Pieces")
	
	# Connect to beacon activation signal
	GameManager.all_food_collected.connect(_on_beacon_activated)

func _process(delta: float) -> void:
	# If the deletion zone is active, shrink it and check platforms
	if platform_deletion_active:
		_process_zone_shrink(delta)

func _on_beacon_activated() -> void:
	"""Called when beacon is activated (all food collected)"""
	print("Beacon activated! Starting zone closure...")
	start_platform_deletion()

func start_platform_deletion() -> void:
	"""Find the furthest platform to set the initial zone size, then activate shrinking"""
	if not map_pieces:
		print("ERROR: Map Pieces node not found!")
		return
	
	var all_platforms: Array = map_pieces.get_children()
	if all_platforms.is_empty():
		return
		
	# Find the maximum distance to start the zone boundary perfectly at the edge
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
	# Shrink the safe zone radius over time
	current_zone_radius -= zone_shrink_speed * delta
	
	# If the zone shrinks completely to the center, stop processing
	if current_zone_radius <= 0:
		current_zone_radius = 0
		platform_deletion_active = false
		print("Zone fully closed!")
	
	# Check all remaining platforms
	var all_platforms: Array = map_pieces.get_children()
	
	for platform in all_platforms:
		if platform == null or platform.is_queued_for_deletion():
			continue
			
		if platform.is_in_group("Safe"):
			continue
		# Calculate distance from center (0,0)
		var distance: float = sqrt(platform.global_position.x ** 2 + platform.global_position.z ** 2)
		
		# If the platform is outside the current safe zone radius, delete it
		if distance > current_zone_radius:
			print("Zone swallowed: %s (distance: %.1f, zone radius: %.1f)" % [platform.name, distance, current_zone_radius])
			platform.queue_free()
