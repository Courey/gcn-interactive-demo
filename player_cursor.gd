extends Control

class_name PlayerCursor

@export var player_id: int
var current_index := 0
var selected := false

signal character_selected(index: int, player_id: int)

func move(delta_index: int, grid_size: int, total_items: int):
	if selected:
		return
	var new_index = (current_index + delta_index) % total_items
	current_index = new_index
	update_cursor_position()

func update_cursor_position():
	var grid = get_node("/root/TelescopeSelect/TelescopeGrid")
	var item = grid.get_child(current_index)
	if item:
		position = item.global_position + Vector2(0, -20)  # hover above
