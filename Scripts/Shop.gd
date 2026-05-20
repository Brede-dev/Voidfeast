extends Control
class_name Shop

@export var sell_thing: PackedScene
@export var card_container: HBoxContainer

func _ready() -> void:
	for i in range(5):
		var sell_thing_instance = sell_thing.instantiate()
		card_container.add_child(sell_thing_instance)
