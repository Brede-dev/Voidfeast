class_name FadeTransition
extends CanvasLayer

static var _instance: FadeTransition

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var color_rect: ColorRect = $ColorRect

func _ready() -> void:
	_instance = self
	
	# Create the fade animations dynamically
	var lib: AnimationLibrary = AnimationLibrary.new()
	
	var fade_out: Animation = Animation.new()
	fade_out.length = 1.0
	fade_out.add_track(Animation.TYPE_VALUE)
	fade_out.track_set_path(0, "ColorRect:color")
	fade_out.track_set_interpolation_type(0, Animation.INTERPOLATION_LINEAR)
	fade_out.track_insert_key(0, 0.0, Color(0, 0, 0, 0))
	fade_out.track_insert_key(0, 1.0, Color(0, 0, 0, 1))
	
	var fade_in: Animation = Animation.new()
	fade_in.length = 1.0
	fade_in.add_track(Animation.TYPE_VALUE)
	fade_in.track_set_path(0, "ColorRect:color")
	fade_in.track_set_interpolation_type(0, Animation.INTERPOLATION_LINEAR)
	fade_in.track_insert_key(0, 0.0, Color(0, 0, 0, 1))
	fade_in.track_insert_key(0, 1.0, Color(0, 0, 0, 0))
	
	lib.add_animation("fade_out", fade_out)
	lib.add_animation("fade_in", fade_in)
	animation_player.add_animation_library("", lib)

static func fade_to_scene(scene_path: String) -> void:
	if not _instance:
		# Fallback: no instance available, just change scene directly
		var main_loop: MainLoop = Engine.get_main_loop()
		if main_loop is SceneTree:
			main_loop.change_scene_to_file(scene_path)
		return
	
	# --- Fade out ---
	_instance.animation_player.play("fade_out")
	await _instance.animation_player.animation_finished
	
	# --- Change scene ---
	var tree: SceneTree = _instance.get_tree() as SceneTree
	if tree:
		tree.change_scene_to_file(scene_path)
	
	# --- Fade in ---
	await _instance.get_tree().process_frame
	_instance.animation_player.play("fade_in")
	await _instance.animation_player.animation_finished
