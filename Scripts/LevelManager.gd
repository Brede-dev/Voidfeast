extends Node

class_name LevelManager

# Platform deletion settings
var map_pieces: Node
var platform_deletion_active: bool = false
var platform_deletion_delay: float = 0.5  # Delay between deleting each platform (seconds)
var beacon_instance: Node3D

func _ready() -> void:
	var food_count: int = get_tree().get_node_count_in_group("Food")
	GameManager.start_level(food_count)
	
	# Get the map pieces node
	map_pieces = get_node("Map Pieces")
	
	# Connect to beacon activation signal
	GameManager.all_food_collected.connect(_on_beacon_activated)



func _on_beacon_activated() -> void:
	"""Called when beacon is activated (all food collected)"""
	print("Beacon activated! Starting platform deletion from map edge...")
	start_platform_deletion()

func start_platform_deletion() -> void:
	"""Delete all map pieces one by one from edges inward (by distance from center)"""
	if not map_pieces:
		print("ERROR: Map Pieces node not found!")
		return
	
	# Get all child platforms
	var all_platforms: Array = map_pieces.get_children()
	
	# Sort platforms by distance from center (0, 0) - furthest first
	var sorted_platforms: Array = _sort_platforms_by_distance(all_platforms)
	
	print("=== PLATFORM DELETION STARTED ===")
	print("Total platforms to delete: %d" % sorted_platforms.size())
	print("Deletion delay between each: %.2f seconds" % platform_deletion_delay)
	print("Deleting from edges inward...")
	
	# Delete each platform with a delay
	var delay: float = 0.0
	for i in range(sorted_platforms.size()):
		var platform: Node = sorted_platforms[i]
		if platform == null:
			continue
		
		# Wait before deleting this platform
		await get_tree().create_timer(delay).timeout
		var distance: float = sqrt(platform.global_position.x ** 2 + platform.global_position.z ** 2)
		print("Deleting platform %d/%d: %s (distance: %.1f)" % [i + 1, sorted_platforms.size(), platform.name, distance])
		platform.queue_free()
		delay += platform_deletion_delay
	
	print("All platforms queued for deletion!")

func _sort_platforms_by_distance(platforms: Array) -> Array:
	"""Sort platforms by distance from center (0, 0) - furthest first"""
	var platform_distances: Array = []
	
	# Create array of [distance, platform] pairs
	for platform in platforms:
		if platform == null:
			continue
		var distance: float = sqrt(platform.global_position.x ** 2 + platform.global_position.z ** 2)
		platform_distances.append([distance, platform])
	
	# Sort by distance (descending - furthest first)
	platform_distances.sort_custom(func(a, b): return a[0] > b[0])
	
	# Extract just the platforms in sorted order
	var sorted_platforms: Array = []
	for item in platform_distances:
		sorted_platforms.append(item[1])
	
	return sorted_platforms
