class_name HUD

extends CanvasLayer

# ═══════════════════════════════════════════════════════════════
@export var timer_duration: float = 180.0 #This is for Timer (Put this in Seconds)
@export var show_timer: bool = true

var elapsed_time: float = 0.0
var timer_running: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CoinLabel.text = str(0)
	$SpeedUpgradeLabel.text = "Upgrades: 0/10"
	$Label4.text = "0 Golden Peartos Collected"
	$FruitProgressLabel.text = "0 Regular Fruit"
	
	# Setup timer signals
	$Label3/Timer.timeout.connect(_on_timer_timeout)
	
	# Initialize timer display
	update_timer_display()
	
	# Start the timer
	if show_timer:
		start_timer()

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
	
	# Update regular fruit progress display (shows progress until golden peartos spawn)
	update_fruit_progress_display()
	
	# Update timer if it's running
	if timer_running:
		elapsed_time += delta
		update_timer_display()
		
		# Check if timer has reached duration
		if elapsed_time >= timer_duration:
			stop_timer()
			_on_timer_complete()

func start_timer() -> void:
	"""Start the timer countdown"""
	timer_running = true
	elapsed_time = 0.0
	$Label3/Timer.start()

func stop_timer() -> void:
	"""Stop the timer"""
	timer_running = false
	$Label3/Timer.stop()
	FadeTransition.fade_to_scene("res://Scenes/LoseScreen.tscn")

func reset_timer() -> void:
	"""Reset the timer to the beginning"""
	elapsed_time = 0.0
	update_timer_display()

func update_timer_display() -> void:
	"""Update the timer label display"""
	var remaining_time: float = max(0.0, timer_duration - elapsed_time)
	var minutes: int = int(remaining_time) / 60
	var seconds: int = int(remaining_time) % 60
	
	$Label3.text = "%02d:%02d" % [minutes, seconds]

func _on_timer_timeout() -> void:
	"""Called when the timer emits timeout signal"""
	pass

func _on_timer_complete() -> void:
	FadeTransition.fade_to_scene("res://Scenes/DeathScreenTimer.tscn")

func update_speed_upgrade_display(food_count: int) -> void:
	"""Update the upgrades display showing which upgrades are active and progress toward next - NOW USES GOLDEN FRUIT"""
	const UPGRADE_COST: int = 10
	var progress_text: String = ""
	var active_upgrades: Array = []
	
	# Check which upgrades are active
	if GameManager.is_item_purchased("speed_upgrade"):
		active_upgrades.append("Speed Boost")
	
	if GameManager.is_item_purchased("double_jump_upgrade"):
		active_upgrades.append("Double Jump")
	
	# Build the display text - NOW USES GOLDEN FRUIT (golden_food_collected)
	if active_upgrades.size() > 0:
		# Show active upgrades
		var upgrades_str: String = " ✓ ".join(active_upgrades)
		progress_text = "Upgrades: ✓ %s" % upgrades_str
		
		# Add progress toward next upgrade if we have some golden fruit
		if GameManager.golden_food_collected > 0:
			progress_text += " (%d/%d for next)" % [GameManager.golden_food_collected, UPGRADE_COST]
	else:
		# No upgrades purchased yet - show progress with GOLDEN FRUIT
		progress_text = "Upgrades: %d/%d" % [GameManager.golden_food_collected, UPGRADE_COST]
	
	$SpeedUpgradeLabel.text = progress_text

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
