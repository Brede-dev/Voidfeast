class_name HUD

extends CanvasLayer

# ═══════════════════════════════════════════════════════════════
@export var timer_duration: float = 180.0 #This is for Timer (Put this in Seconds)
@export var show_timer: bool = true

var elapsed_time: float = 0.0
var timer_running: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Count the actual number of peartos placed in the level (nodes in the
	# "Food" group) instead of a hardcoded default, so the golden-fruit
	# requirement matches what's really in the level.
	GameManager.start_level(get_tree().get_node_count_in_group("Food"))
	$CoinLabel.text = str(0)
	$SpeedUpgradeLabel.text = "Upgrades: 0/50"
	$DoubleJumpUpgradeLabel.text = "Upgrades: 0/30"
	$HighJumpUpgradeLabel.text = "Upgrades: 0/60"
	$LargeCollectionRangeUpgradeLabel.text = "Upgrades: 0/70"
	$Label4.text = "0 Golden Peartos Collected"
	$FruitProgressLabel.text = "0 Regular Fruit"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Update regular fruit counter (total_food_owned) - ONLY FOR UNLOCKING GOLDEN FRUIT
	$CoinLabel.text = str(GameManager.total_food_owned)
	
	# Update golden peartos collected display
	var golden_count: int = GameManager.golden_food_collected
	var golden_word: String = "Pearto" if golden_count == 1 else "Peartos"
	$Label4.text = "%d Golden %s Collected" % [golden_count, golden_word]
	
	# Update speed upgrade progress display (NOW USES GOLDEN FRUIT)

	update_speed_upgrade_display(GameManager.golden_food_collected)
	update_double_jump_upgrade_display(GameManager.golden_food_collected)
	update_high_jump_upgrade_display(GameManager.golden_food_collected)
	update_large_collection_range_upgrade_display(GameManager.golden_food_collected)
	
	# Update regular fruit progress display (shows progress until golden peartos spawn)
	update_fruit_progress_display()


func update_speed_upgrade_display(food_count: int) -> void:
	"""Update the upgrades display showing which upgrades are active and progress toward next - NOW USES GOLDEN FRUIT"""
	const UPGRADE_COST: int = 50
	const UPGRADE_NAME: String = "Speed Boost"
	var progress_text: String = ""
	
	if GameManager.is_item_purchased("speed_upgrade"):
		# Show purchased upgrade with checkmark
		progress_text = "✓ %s" % UPGRADE_NAME
	else:
		# No upgrade purchased yet - show progress toward purchase
		progress_text = "%s: %d/%d Golden Peartos" % [UPGRADE_NAME, GameManager.golden_food_collected, UPGRADE_COST]
	
	$SpeedUpgradeLabel.text = progress_text

func update_double_jump_upgrade_display(food_count: int) -> void:
	const UPGRADE_COST: int = 30
	const UPGRADE_NAME: String = "Double Jump"
	var progress_text: String = ""
	
	if GameManager.is_item_purchased("double_jump_upgrade"):
		progress_text = "✓ %s" % UPGRADE_NAME
	else:
		progress_text = "%s: %d/%d Golden Peartos" % [UPGRADE_NAME, GameManager.golden_food_collected, UPGRADE_COST]
	
	$DoubleJumpUpgradeLabel.text = progress_text

func update_high_jump_upgrade_display(food_count: int) -> void:
	const UPGRADE_COST: int = 60
	const UPGRADE_NAME: String = "High Jump"
	var progress_text: String = ""
	
	if GameManager.is_item_purchased("high_jump_upgrade"):
		progress_text = "✓ %s" % UPGRADE_NAME
	else:
		progress_text = "%s: %d/%d Golden Peartos" % [UPGRADE_NAME, GameManager.golden_food_collected, UPGRADE_COST]
	
	$HighJumpUpgradeLabel.text = progress_text

func update_large_collection_range_upgrade_display(food_count: int) -> void:
	const UPGRADE_COST: int = 70
	const UPGRADE_NAME: String = "Collection Range"
	var progress_text: String = ""
	
	if GameManager.is_item_purchased("higher_collection_range_upgrade"):
		progress_text = "✓ %s" % UPGRADE_NAME
	else:
		progress_text = "%s: %d/%d Golden Peartos" % [UPGRADE_NAME, GameManager.golden_food_collected, UPGRADE_COST]
	
	$LargeCollectionRangeUpgradeLabel.text = progress_text

func update_fruit_progress_display() -> void:
	"""Update the fruit progress display (shows regular fruit progress until golden peartos unlock)"""
	var regular_fruit_collected: int = GameManager.food_collected
	var regular_fruit_total: int = GameManager.food_total
	
	if regular_fruit_total > 0:
		var progress_text: String = "%d Regular Fruit (%d/%d until Golden)" % [
			GameManager.total_food_owned,
			regular_fruit_collected,
			regular_fruit_total
		]
		$FruitProgressLabel.text = progress_text
	else:
		# If no fruit target set, show simple count
		$FruitProgressLabel.text = "%d Regular Fruit" % GameManager.total_food_owned
