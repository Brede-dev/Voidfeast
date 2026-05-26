class_name GameTimer
extends Timer

# Timer properties
var display_label: Label
var is_countdown: bool = false
var elapsed: float = 0.0

func _ready() -> void:
	timeout.connect(_on_timeout)
	timeout.connect(_update_display)

func start_elapsed_timer() -> void:
	"""Start an elapsed time timer"""
	is_countdown = false
	elapsed = 0.0
	start()

func start_countdown_timer(duration: float) -> void:
	"""Start a countdown timer with specified duration (in seconds)"""
	is_countdown = true
	elapsed = duration
	wait_time = 0.1  # Update every 0.1 seconds for smooth display
	start()

func stop_timer() -> void:
	"""Stop the timer"""
	stop()

func reset_timer() -> void:
	"""Reset the timer"""
	elapsed = 0.0
	_update_display()

func set_display_label(label: Label) -> void:
	"""Set the label to display the timer"""
	display_label = label

func _on_timeout() -> void:
	"""Handle timer timeout"""
	if is_countdown:
		elapsed -= wait_time
		if elapsed <= 0.0:
			elapsed = 0.0
			stop()
			print("Countdown timer finished!")

func _update_display() -> void:
	"""Update the display label with current time"""
	if not display_label:
		return
	
	var minutes: int = int(elapsed) / 60
	var seconds: int = int(elapsed) % 60
	display_label.text = "%d:%02d" % [minutes, seconds]
