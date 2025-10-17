extends Control

const GRID_COLUMNS := 4
var grid: GridContainer
var locked_in_indices := {}

@onready var Grid = $TelescopeGrid

var telescopeSlot: PackedScene = preload("res://scenes/observatory_selection/telescope_slot.tscn")

func _ready():
	for telescope in Grid.telescopes as Array[Telescope]:
		var new_telescope = telescopeSlot.instantiate()
		new_telescope.observatory = telescope
		new_telescope.connect("pressed", select_telescope)
		Grid.add_child(new_telescope)
	for player in Global.PLAYERS:
		player.observatory = Grid.telescopes[0]


func select_telescope():
	print("Okay, we are somewhere")


func _process(_delta):
	var observatory_list_items = Grid.get_children().filter(func (c):return c is TelescopeSlot)
	for player in Global.PLAYERS:
		if Input.is_action_just_pressed("%s_select" % player.get_input_prefix()):
			player.selected = !player.selected

		if player.selected:
			continue

		if Input.is_action_just_pressed("%s_up" % player.get_input_prefix()):
			player.observatory_id -= GRID_COLUMNS % GRID_COLUMNS
		elif Input.is_action_just_pressed("%s_down" % player.get_input_prefix()):
			player.observatory_id += GRID_COLUMNS % GRID_COLUMNS
		elif Input.is_action_just_pressed("%s_left" % player.get_input_prefix()):
			player.observatory_id = (player.observatory_id - 1) % GRID_COLUMNS
		elif Input.is_action_just_pressed("%s_right" % player.get_input_prefix()):
			player.observatory_id = (player.observatory_id + 1) % GRID_COLUMNS

		player.observatory = Grid.telescopes[player.observatory_id]

		#if (len(observatory_list_items) > 0):
			#observatory_list_items[player.observatory_id].player_hover(player)

#func handle_input(player: Player):
