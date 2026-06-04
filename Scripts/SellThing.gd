extends Control
class_name SellThing

@export var card_frame: TextureRect
@export var cost: int = 10
@export var item_id: String = ""  # Unique identifier for this shop item
var hovering: bool

func _ready() -> void:
	# Check if this item has already been purchased
	if has_been_purchased():
		queue_free()

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
	# Only allow interaction if player has enough collectables for this item's cost
	return GameManager.total_food_owned >= cost

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and hovering and can_interact():
			# Deduct the cost from collectables
			GameManager.total_food_owned -= cost
			# Mark this item as purchased
			mark_as_purchased()
			# Remove the purchased item from the shop
			self.queue_free()

func has_been_purchased() -> bool:
	# Check if this item is in the purchased items list
	var purchased_items: Array = GameManager.get_purchased_items()
	return item_id in purchased_items

func mark_as_purchased() -> void:
	# Add this item to the purchased items list
	GameManager.add_purchased_item(item_id)
