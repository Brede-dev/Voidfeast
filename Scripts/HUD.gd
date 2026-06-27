class_name HUD

extends CanvasLayer

# ═══════════════════════════════════════════════════════════════
# ⏱️ TIMER DURATION - EASY TO EDIT!
# Change this value to adjust how long the timer lasts (in seconds)
# Examples: 60 = 1 minute, 120 = 2 minutes, 300 = 5 minutes
# ═══════════════════════════════════════════════════════════════
@export var timer_duration: float = 120.0  # EDIT THIS! (seconds)
@export var show_timer: bool = true

# Quick reference for common durations:
# 30 seconds = 30.0
# 1 minute = 60.0
# 2 minutes = 120.0
# 3 minutes = 180.0
# 5 minutes = 300.0
# 10 minutes = 600.0

var elapsed_time: float = 0.0
var timer_running: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CoinLabel.text = str(0)
	$SpeedUpgradeLabel.text = "Speed Upgrade: 0/10"  # Initialize speed upgrade display
	
	# Setup timer signals
	$Label3/Timer.timeout.connect(_on_timer_timeout)
	
	# Initialize timer display
	update_timer_display()
	
	# Start the timer
	if show_timer:
		start_timer()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var food_count: int = GameManager.golden_food_collected
	$CoinLabel.text = str(GameManager.golden_food_collected)
	
	# Update speed upgrade progress display
	update_speed_upgrade_display(food_count)
	
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
	get_tree().change_scene_to_file("res://Scenes/LoseScreen.tscn")

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
	"""Called when timer duration is reached"""
	print("Timer completed!")
	# Add your logic here for what happens when timer ends
	# For example: pause game, show game over screen, etc.

func update_speed_upgrade_display(food_count: int) -> void:
	"""Update the speed upgrade progress display"""
	const SPEED_UPGRADE_COST: int = 10
	var progress_text: String = ""
	
	if GameManager.speed_multiplier > 1.0:
		# Already purchased the upgrade
		progress_text = "Speed Upgrade: ✓ ACTIVE (2.0x faster)"
	else:
		# Show progress toward purchase
		var items_needed: int = SPEED_UPGRADE_COST - food_count
		if items_needed <= 0:
			progress_text = "Speed Upgrade: Ready to Buy!"
		else:
			progress_text = "Speed Upgrade: %d/%d items" % [food_count, SPEED_UPGRADE_COST]
	
	$SpeedUpgradeLabel.text = progress_text
