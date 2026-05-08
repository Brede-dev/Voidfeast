extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	GameManager.score_changed.connect(update_beacon)
	pass # Replace with function body.

func update_beacon():
	show()
# Called every frame. 'delta' is the elapsed time since the previous frame.

	
