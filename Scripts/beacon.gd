extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Area3D/CollisionShape3D.disabled = true
	hide()
	GameManager.score_changed.connect(update_beacon)
	pass # Replace with function body.

func update_beacon():
	$Area3D/CollisionShape3D.disabled = false
	show()
# Called every frame. 'delta' is the elapsed time since the previous frame.



func _on_area_3d_area_entered(area: Area3D) -> void:
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
