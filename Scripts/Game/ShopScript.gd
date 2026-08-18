extends Control

@export var sell_thing: PackedScene
@export var card_container: HBoxContainer

func _ready() -> void:
	# Create regular shop items
	var speed_upgrade_card: Control = sell_thing.instantiate()
	speed_upgrade_card.item_id = "speed_upgrade"
	speed_upgrade_card.cost = 10
	speed_upgrade_card.item_texture = preload("res://Assets/SportShoes (1).png")
	if speed_upgrade_card.title_label:
		speed_upgrade_card.title_label.text = "Speed Boost"
	card_container.add_child(speed_upgrade_card)
	if speed_upgrade_card.description_label:
		speed_upgrade_card.description_label.text = "Increases\nmovement speed"
	
	var double_jump_upgrade_card: Control = sell_thing.instantiate()
	double_jump_upgrade_card.item_id = "double_jump_upgrade"
	double_jump_upgrade_card.cost = 10
	double_jump_upgrade_card.item_texture = preload("res://Assets/DoubleJump (1).png")
	if double_jump_upgrade_card.title_label:
		double_jump_upgrade_card.title_label.text = "Double Jump"
	card_container.add_child(double_jump_upgrade_card)
	if double_jump_upgrade_card.description_label:
		double_jump_upgrade_card.description_label.text = "Adds Extra Jump"
	
	var high_jump_upgrade_card: Control = sell_thing.instantiate()
	high_jump_upgrade_card.item_id = "high_jump_upgrade"
	high_jump_upgrade_card.cost = 10
	high_jump_upgrade_card.item_texture = preload("res://Assets/NinjaBelt (1).png")
	if high_jump_upgrade_card.title_label:
		high_jump_upgrade_card.title_label.text = "High Jump"
	card_container.add_child(high_jump_upgrade_card)
	if high_jump_upgrade_card.description_label:
		high_jump_upgrade_card.description_label.text = "Increases Jump Height"
	
	var high_collecting_range_upgrade_card: Control = sell_thing.instantiate()
	high_collecting_range_upgrade_card.item_id = "higher_collection_range_upgrade"
	high_collecting_range_upgrade_card.cost = 10
	high_collecting_range_upgrade_card.item_texture = preload("res://Assets/GiftMagnet (1).png")
	if high_collecting_range_upgrade_card.title_label:
		high_collecting_range_upgrade_card.title_label.text = "Larger\nCollection Range"
	card_container.add_child(high_collecting_range_upgrade_card)
	if high_collecting_range_upgrade_card.description_label:
		high_collecting_range_upgrade_card.description_label.text = "Increases Collection\nRange"

func _on_level_selection_pressed() -> void:
	GameManager.save_purchased_items()
	GameManager.save_speed_multiplier()  # Also save the reset
	
	# Delete the save files
	if FileAccess.file_exists("user://purchased_items.save"):
		var dir: DirAccess = DirAccess.open("user://")
		dir.remove("user://purchased_items.save")
	
	if FileAccess.file_exists("user://session_speed.save"):
		var dir: DirAccess = DirAccess.open("user://")
		dir.remove("user://session_speed.save")
	
	FadeTransition.fade_to_scene("res://Scenes/Screens/LevelSelection.tscn")
