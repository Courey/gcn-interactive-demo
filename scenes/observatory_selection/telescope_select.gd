extends Control

const GRID_COLUMNS := 4
var grid: GridContainer
var player_cursors = []
var locked_in_indices := {}

#@onready var PlayerCursors = $PlayerCursors
@onready var Grid = $TelescopeGrid

var TelescopeSlot: PackedScene = preload("res://scenes/observatory_selection/telescope_slot.tscn")

func _ready():
	for telescope in Grid.telescopes as Array[Telescope]:
		var new_telescope = TelescopeSlot.instantiate()
		new_telescope.observatory = telescope
		new_telescope.connect("pressed", select_telescope)
		Grid.add_child(new_telescope)


func select_telescope():
	print("Okay, we are somewhere")


func _process(_delta):
	var observatory_list_items = Grid.get_children()
	for player in Global.PLAYERS:
		if player.selected:
			continue
		#handle_input(player)
		if Input.is_action_just_pressed("%s_up" % player.input_prefix):
			player.observatory_index -= GRID_COLUMNS % GRID_COLUMNS
		elif Input.is_action_just_pressed("%s_down" % player.input_prefix):
			player.observatory_index += GRID_COLUMNS % GRID_COLUMNS
		elif Input.is_action_just_pressed("%s_left" % player.input_prefix):
			player.observatory_index = (player.observatory_index - 1) % GRID_COLUMNS
		elif Input.is_action_just_pressed("%s_right" % player.input_prefix):
			player.observatory_index = (player.observatory_index + 1) % GRID_COLUMNS
		if (len(observatory_list_items) > 0):
			observatory_list_items[player.observatory_index].player_hover(player)

#func handle_input(player: Player):
