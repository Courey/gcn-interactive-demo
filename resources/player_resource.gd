class_name PlayerResource extends Resource

@export var id: int = 1
@export var player_color: Color

var input_prefix: String
var active: bool = false
var name: String

var observatory_id: int
var observatory: Telescope
var ready:bool = false

## Observations:
# {
	# obsStart: beginning time in seconds,
	# obsEnd: end time
	# wavelength: some representation of the band observed
	# eventId: id to track which event the observation is part of
# }
var observations = []

func _init():
	name = "Player%d" % id
	input_prefix = "p%d" % id

func get_input_prefix():
	return "p%d" % id

func toggle_active():
	active = !active

func toggle_ready():
	ready = !ready

func add_observation(observation):
	observations.push(observation)
