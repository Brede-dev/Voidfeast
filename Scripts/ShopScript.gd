extends Control

@export var sell_thing: PackedScene
@export var card_container: HBoxContainer

func _ready() -> void:
	# Create regular shop items
	"""for i in range(5):
		var sell_thing_instance: Control = sell_thing.instantiate()
		sell_thing_instance.item_id = "shop_item_%d" % i
		card_container.add_child(sell_thing_instance)"""
	
	var speed_upgrade_card: Control = sell_thing.instantiate()
	speed_upgrade_card.item_id = "speed_upgrade"
	speed_upgrade_card.cost = 10
	if speed_upgrade_card.title_label:
		speed_upgrade_card.title_label.text = "Speed Boost"
	card_container.add_child(speed_upgrade_card)
	
	var double_jump_upgrade_card: Control = sell_thing.instantiate()
	double_jump_upgrade_card.item_id = "double_jump_upgrade"
	double_jump_upgrade_card.cost = 10
	if double_jump_upgrade_card.title_label:
		double_jump_upgrade_card.title_label.text = "Double Jump"
	card_container.add_child(double_jump_upgrade_card)


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
	
	get_tree().change_scene_to_file("res://Scenes/LevelSelection.tscn")
