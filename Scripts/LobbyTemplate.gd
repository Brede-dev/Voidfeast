class_name LobbyTemplate
extends Node

# Signals
signal player_joined(player_name: String)
signal player_left(player_name: String)
signal lobby_ready_changed(is_ready: bool)
signal game_started

# Lobby properties
var lobby_name: String = ""
var max_players: int = 4
var current_players: Array[String] = []
var is_ready: bool = false

func _ready() -> void:
	pass

## Create a new lobby with specified name and player count
func create_lobby(name: String, max_count: int) -> void:
	lobby_name = name
	max_players = max_count
	current_players.clear()
	is_ready = false
	print("Lobby created: %s (Max: %d)" % [lobby_name, max_players])

## Join the lobby with a player name
func join_lobby(player_name: String) -> bool:
	if current_players.size() >= max_players:
		print("Lobby is full!")
		return false
	
	if player_name in current_players:
		print("Player already in lobby!")
		return false
	
	current_players.append(player_name)
	player_joined.emit(player_name)
	print("%s joined the lobby" % player_name)
	return true

## Remove a player from the lobby
func leave_lobby(player_name: String) -> bool:
	if player_name not in current_players:
		print("Player not in lobby!")
		return false
	
	current_players.erase(player_name)
	player_left.emit(player_name)
	print("%s left the lobby" % player_name)
	return true

## Get current lobby information
func get_lobby_info() -> Dictionary:
	return {
		"name": lobby_name,
		"players": current_players.duplicate(),
		"player_count": current_players.size(),
		"max_players": max_players,
		"is_ready": is_ready,
		"slots_available": max_players - current_players.size()
	}

## Check if lobby is full
func is_full() -> bool:
	return current_players.size() >= max_players

## Check if lobby is empty
func is_empty() -> bool:
	return current_players.size() == 0

## Set lobby ready status
func set_ready(ready: bool) -> void:
	is_ready = ready
	lobby_ready_changed.emit(is_ready)
	print("Lobby ready: %s" % is_ready)

## Start the game
func start_game() -> void:
	if current_players.size() < 2:
		print("Need at least 2 players to start!")
		return
	
	game_started.emit()
	print("Game starting with players: %s" % ", ".join(current_players))

## Get list of all players
func get_players() -> Array[String]:
	return current_players.duplicate()

## Get player count
func get_player_count() -> int:
	return current_players.size()

# ============================================
# TODO: Features you can add:
# ============================================
# [ ] Assign players to teams
# [ ] Player ready status (individual players)
# [ ] Lobby settings (difficulty, map selection, etc)
# [ ] Chat system for lobby
# [ ] Ban/kick player functionality
# [ ] Spectator mode
# [ ] Player loadout selection
# [ ] Lobby password protection
# [ ] Auto-start when all players ready
# [ ] Disconnect handling
# [ ] Save/load lobby state
# [ ] Lobby history/statistics
