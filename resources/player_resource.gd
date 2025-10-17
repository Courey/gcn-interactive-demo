class_name PlayerResource extends Resource

@export var id: int = 1
@export var player_color: Color

var input_prefix: String
var active: bool = false
var name: String


func _init():
	name = "Player%d" % id
	input_prefix = "p%d" % id
	active = true

func get_input_prefix():
	return "p%d" % id
