extends Control

func _ready():
	set_process_input(true)

func _input(event):
	if event.is_pressed():
		_start_game()

func _start_game():
	SceneManager.change_scene_with_transition(
		self,
		load("res://scenes/observatory_selection/telescope_select.tscn")
	)
