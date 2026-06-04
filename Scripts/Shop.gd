extends Control
class_name Shop

@export var sell_thing: PackedScene
@export var card_container: HBoxContainer

func _ready() -> void:
	for i in range(5):
		var sell_thing_instance = sell_thing.instantiate()
		sell_thing_instance.item_id = "shop_item_%d" % i  # Give each item a unique ID
		card_container.add_child(sell_thing_instance)



func _on_restart_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/LevelSelection.tscn")
