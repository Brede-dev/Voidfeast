extends Control
class_name SellThing

@export var card_frame: TextureRect
var hovering: bool

func _process(delta: float) -> void:
	if is_mouse_over_card() and can_interact():
		hovering = true
		card_frame.scale = Vector2(1.2,1.2)
	else:
		hovering = false
		card_frame.scale = Vector2(1,1)

func is_mouse_over_card() -> bool:
	var mouse_pos: Vector2 = get_global_mouse_position()
	var sprite_rect: Rect2 = Rect2(card_frame.global_position , card_frame.texture.get_size())
	return sprite_rect.has_point(mouse_pos)

func can_interact() -> bool:
	# Only allow interaction if food_collected is 10 or more
	return GameManager.food_collected >= 10

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and hovering and can_interact():
			self.queue_free()
