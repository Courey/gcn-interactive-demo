extends Control

const GRID_COLUMNS := 4
var grid: GridContainer
var locked_in_indices := {}

@onready var Grid = $TelescopeGrid
@onready var SelectedDisplay1 = $SelectedTelescopeDisplayP1
@onready var SelectedDisplay2 = $SelectedTelescopeDisplayP2
@onready var SelectedDisplay3 = $SelectedTelescopeDisplayP3
@onready var SelectedDisplay4 = $SelectedTelescopeDisplayP4
@onready var StartTimer = $StartTimer as Timer
@onready var CountdownLabel = $StartCountdownLabel as Label

var telescopeSlot: PackedScene = preload("res://scenes/observatory_selection/telescope_slot.tscn")
var displays:Array[SelectedTelescopeDisplay] = []

func _ready():
	displays.append_array([SelectedDisplay1,SelectedDisplay2,SelectedDisplay3,SelectedDisplay4])

	for telescope in Grid.telescopes as Array[Telescope]:
		var new_telescope = telescopeSlot.instantiate()
		new_telescope.observatory = telescope
		Grid.add_child(new_telescope)


# Event based input. Ex: Ready up, join game,
func _input(_event: InputEvent) -> void:
	for player in Global.PLAYERS:
		# Player join session
		if Input.is_action_just_pressed("%s_primary" % player.get_input_prefix()) && !player.active:
			player.toggle_active()
			displays[player.id - 1].toggle_ready_display()
		# Player ready state checks
		elif Input.is_action_just_pressed("%s_primary" % player.get_input_prefix()) && player.active:
			player.toggle_ready()

			# Start countdown clock to the Observation scene when all players are ready
			var activePlayerCount = len(Utils.get_active_players())
			if activePlayerCount > 0:
				if len(Utils.get_active_players().filter(func (p): return p.ready)) == activePlayerCount:
					StartTimer.start()
					CountdownLabel.visible = true
				else:
					StartTimer.stop()
					CountdownLabel.visible = false


func _process(_delta):
	for player in Utils.get_active_players():
		if player.active && player.ready:
			continue
		var playerPrefix = player.get_input_prefix()
		if Input.is_action_just_pressed("%s_up" % playerPrefix):
			player.observatory_id -= GRID_COLUMNS % GRID_COLUMNS
		elif Input.is_action_just_pressed("%s_down" % playerPrefix):
			player.observatory_id += GRID_COLUMNS % GRID_COLUMNS
		elif Input.is_action_just_pressed("%s_left" % playerPrefix):
			player.observatory_id = (player.observatory_id - 1) % GRID_COLUMNS
		elif Input.is_action_just_pressed("%s_right" % playerPrefix):
			player.observatory_id = (player.observatory_id + 1) % GRID_COLUMNS

		player.observatory = Grid.telescopes[player.observatory_id]

	if CountdownLabel.visible:
		CountdownLabel.text = "Starting in %s..." % str(int(StartTimer.time_left))

func _on_start_timer_timeout() -> void:
	SceneManager.change_scene_with_transition(
		self,
		load("res://scenes/observation/main.tscn")
	)
