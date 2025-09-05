extends ColorRect

@export var next_scene_path = ""

@onready var _anim_player = $AnimationPlayer as AnimationPlayer

func _ready() -> void:
	_anim_player.play_backwards()


func transition_to() -> void:
	# Plays the Fade animation and wait until it finishes
	_anim_player.play("Fade")
	await _anim_player.animation_finished
	# Changes the scene
	get_tree().change_scene_to_file(next_scene_path)
