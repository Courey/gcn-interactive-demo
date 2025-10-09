extends Control

#var next_scene:PackedScene = preload("res://scenes/observation/main.tscn")

func _ready():
	# Capture input immediately
	set_process_input(true)

func _input(event):
	if event.is_pressed():
		_start_game()

func _start_game():
	SceneManager.change_scene_with_transition(
		self,
		load("res://scenes/observation/main.tscn")
	)
