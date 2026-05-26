class_name Level
extends Node3D

# ============================================================
#  LEVEL MANAGER - Sets up the level and game state
# ============================================================

@onready var player: CharacterBody3D = $Player
@onready var hud: HUD = $HUD

var game_manager: GameManager

func _ready() -> void:
	"""Initialize the level."""
	# Get the GameManager autoload
	game_manager = GameManager
	
	# Register the player with the game manager
	if player:
		game_manager.register_player(player)
		print("[Level] Player registered")
	else:
		push_error("[Level] Player not found in scene!")
		return
	
	# Reset game state for a fresh level
	game_manager.reset_game()
	game_manager.start_level(1, 0)  # Level 1, 0 items required
	game_manager.set_checkpoint(player.global_position)
	
	# Set up the player position if needed
	player.global_position = Vector3(0, 2, 0)
	
	# Connect to game over signal
	game_manager.game_over.connect(_on_game_over)
	
	print("[Level] Level initialized successfully")
