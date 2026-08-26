class_name HUD

extends CanvasLayer

# ═══════════════════════════════════════════════════════════════
@export var timer_duration: float = 180.0 #This is for Timer (Put this in Seconds)
@export var show_timer: bool = true

var elapsed_time: float = 0.0
var timer_running: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.start_level(10)
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
	var progress_text: String = ""
	var active_upgrades: Array = []
	if GameManager.is_item_purchased("speed_upgrade"):
		active_upgrades.append("Speed Boost")
		
	if active_upgrades.size() > 0:
		# Show active upgrades
		var upgrades_str: String = " ✓ ".join(active_upgrades)
		if active_upgrades.size() > 2:
			upgrades_str = " ✓ ".join(active_upgrades.slice(0, 2)) + "\n" + " ✓ ".join(active_upgrades.slice(2))
		progress_text = "Upgrades: ✓ %s" % upgrades_str
		
		# Add progress toward next upgrade if we have some golden fruit
		if GameManager.golden_food_collected > 0:
			progress_text += " (%d/%d for next)" % [GameManager.golden_food_collected, UPGRADE_COST]
	else:
		# No upgrades purchased yet - show progress with GOLDEN FRUIT
		progress_text = "Upgrades: %d/%d" % [GameManager.golden_food_collected, UPGRADE_COST]
	
	$SpeedUpgradeLabel.text = progress_text

func update_double_jump_upgrade_display(food_count: int) -> void:
	const UPGRADE_COST: int = 30
	var progress_text: String = ""
	var active_upgrades: Array = []
	if GameManager.is_item_purchased("double_jump_upgrade"):
		active_upgrades.append("Double Jump")
		
	if active_upgrades.size() > 0:
		# Show active upgrades
		var upgrades_str: String = " ✓ ".join(active_upgrades)
		if active_upgrades.size() > 2:
			upgrades_str = " ✓ ".join(active_upgrades.slice(0, 2)) + "\n" + " ✓ ".join(active_upgrades.slice(2))
		progress_text = "Upgrades: ✓ %s" % upgrades_str
		
		# Add progress toward next upgrade if we have some golden fruit
		if GameManager.golden_food_collected > 0:
			progress_text += " (%d/%d for next)" % [GameManager.golden_food_collected, UPGRADE_COST]
	else:
		# No upgrades purchased yet - show progress with GOLDEN FRUIT
		progress_text = "Upgrades: %d/%d" % [GameManager.golden_food_collected, UPGRADE_COST]
	
	$DoubleJumpUpgradeLabel.text = progress_text

func update_high_jump_upgrade_display(food_count: int) -> void:
	const UPGRADE_COST: int = 60
	var progress_text: String = ""
	var active_upgrades: Array = []
	if GameManager.is_item_purchased("high_jump_upgrade"):
		active_upgrades.append("High Jump")
		
	if active_upgrades.size() > 0:
		# Show active upgrades
		var upgrades_str: String = " ✓ ".join(active_upgrades)
		if active_upgrades.size() > 2:
			upgrades_str = " ✓ ".join(active_upgrades.slice(0, 2)) + "\n" + " ✓ ".join(active_upgrades.slice(2))
		progress_text = "Upgrades: ✓ %s" % upgrades_str
		
		# Add progress toward next upgrade if we have some golden fruit
		if GameManager.golden_food_collected > 0:
			progress_text += " (%d/%d for next)" % [GameManager.golden_food_collected, UPGRADE_COST]
	else:
		# No upgrades purchased yet - show progress with GOLDEN FRUIT
		progress_text = "Upgrades: %d/%d" % [GameManager.golden_food_collected, UPGRADE_COST]
	
	$HighJumpUpgradeLabel.text = progress_text

func update_large_collection_range_upgrade_display(food_count: int) -> void:
	const UPGRADE_COST: int = 70
	var progress_text: String = ""
	var active_upgrades: Array = []
	if GameManager.is_item_purchased("higher_collection_range_upgrade"):
		active_upgrades.append("Collection Range")
		
	if active_upgrades.size() > 0:
		# Show active upgrades
		var upgrades_str: String = " ✓ ".join(active_upgrades)
		if active_upgrades.size() > 2:
			upgrades_str = " ✓ ".join(active_upgrades.slice(0, 2)) + "\n" + " ✓ ".join(active_upgrades.slice(2))
		progress_text = "Upgrades: ✓ %s" % upgrades_str
		
		# Add progress toward next upgrade if we have some golden fruit
		if GameManager.golden_food_collected > 0:
			progress_text += " (%d/%d for next)" % [GameManager.golden_food_collected, UPGRADE_COST]
	else:
		# No upgrades purchased yet - show progress with GOLDEN FRUIT
		progress_text = "Upgrades: %d/%d" % [GameManager.golden_food_collected, UPGRADE_COST]
	
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
