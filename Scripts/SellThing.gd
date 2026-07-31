extends Control

@export var card_frame: TextureRect
@export var item_texture: Texture2D
@export var cost: int = 10
@export var item_id: String = ""  # Unique identifier for this shop item
@export var title_label: Label  # Optional label to show item title
@export var description_label: Label  # Optional label to show item description
var hovering: bool

@onready var card_panel: Panel = $CardPanel

func _ready() -> void:
	# Check if this item has already been purchased
	if has_been_purchased():
		queue_free()
	
	# Apply the item's texture onto the card frame, resized to fit the card
	if item_texture:
		var img: Image = item_texture.get_image()
		if img:
			# Resize to a nice 96x96 icon that fits inside the card
			img.resize(96, 96, Image.INTERPOLATE_LANCZOS)
			card_frame.texture = ImageTexture.create_from_image(img)
			print("✅ Set card_frame texture: ", item_id)
		else:
			card_frame.texture = item_texture
	else:
		print("❌ No item_texture set for ", item_id)
	
	# Set title for speed upgrade
	if item_id == "speed_upgrade" and title_label:
		title_label.text = "Speed Boost"

	if item_id == "double_jump_upgrade" and title_label:
		title_label.text = "Double Jump"

	if item_id == "high_jump_upgrade" and title_label:
		title_label.text = "High Jump"

	if item_id == "higher_collection_range_upgrade" and title_label:
		title_label.text = "Larger Collection Range"

func _process(delta: float) -> void:
	if is_mouse_over_card() and can_interact():
		hovering = true
		card_panel.scale = Vector2(1.05, 1.05)
	else:
		hovering = false
		card_panel.scale = Vector2(1, 1)

func is_mouse_over_card() -> bool:
	var mouse_pos: Vector2 = get_global_mouse_position()
	var card_rect: Rect2 = Rect2(card_panel.global_position, card_panel.size)
	return card_rect.has_point(mouse_pos)

func can_interact() -> bool:
	# Only allow interaction if player has enough GOLDEN FRUIT for this item's cost
	# Golden fruit (golden_food_collected) is now the currency for upgrades
	return GameManager.golden_food_collected >= cost

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and hovering and can_interact():
			# Deduct the cost from GOLDEN FRUIT (golden_food_collected)
			GameManager.golden_food_collected -= cost
			GameManager.save_total_food()  # Save immediately
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
	print("🛒 Purchasing item: ", item_id)
	GameManager.add_purchased_item(item_id)
