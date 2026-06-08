extends Control
class_name Shop

@export var sell_thing: PackedScene
@export var card_container: HBoxContainer

func _ready() -> void:
	# Create the speed boost item
	var speed_boost_instance: SellThing = sell_thing.instantiate()
	speed_boost_instance.item_id = "speed_boost"
	speed_boost_instance.cost = 15
	card_container.add_child(speed_boost_instance)
	
	# Create regular shop items
	for i in range(5):
		var sell_thing_instance: SellThing = sell_thing.instantiate()
		sell_thing_instance.item_id = "shop_item_%d" % i  # Give each item a unique ID
		card_container.add_child(sell_thing_instance)



func _on_restart_button_pressed() -> void:
	# Reset all persistent data
	GameManager.total_food_owned = 0
	GameManager.purchased_items = []
	GameManager.save_purchased_items()
	
	# Delete the save file
	if FileAccess.file_exists("user://purchased_items.save"):
		var dir: DirAccess = DirAccess.open("user://")
		dir.remove("user://purchased_items.save")
	
	get_tree().change_scene_to_file("res://Scenes/LevelSelection.tscn")
