extends CanvasLayer

var elapsed_time: float = 0.0
var show_countdown: bool = false  # Set to true to show countdown timer instead of elapsed time

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CoinLabel.text = str(0)
	if $TimerLabel:
		$TimerLabel.text = "0:00"
	
	# Connect to GameManager signals
	GameManager.time_over.connect(_on_time_over)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$CoinLabel.text = str(GameManager.score)
	
	# Update timer display
	if show_countdown:
		# Show countdown timer
		var minutes: int = int(GameManager.time_remaining) / 60
		var seconds: int = int(GameManager.time_remaining) % 60
		if $TimerLabel:
			$TimerLabel.text = "%d:%02d" % [minutes, seconds]
	else:
		# Show elapsed time
		elapsed_time += delta
		var minutes: int = int(elapsed_time) / 60
		var seconds: int = int(elapsed_time) % 60
		if $TimerLabel:
			$TimerLabel.text = "%d:%02d" % [minutes, seconds]

func _on_time_over() -> void:
	"""Called when the countdown timer reaches zero"""
	print("Time's up!")
	# You can add game over logic here
