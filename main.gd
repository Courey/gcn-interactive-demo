extends Node2D

var score = 0
var Event = preload("res://event.tscn")

const OFFSET_MAP = [
	Vector2(960,540), #This should be dynamic
	Vector2.ZERO
]

@export_enum ("CENTER:0","CORNER:1") var SELECTED_OFFSET = 0

@export var SPEED = 0.05
@export var EVENTS_LIMIT = 10

@onready var ScoreLabel = $Score
@onready var Events = $Events
@onready var Players = $Players
@onready var RotatingStarField = $RotatingStarField

var target_map:Dictionary = {}


func _ready():
	randomize() 

	for player in Players.get_children():
		player.connect("observe",_on_player_observe)
		target_map[player.name] = []
		
	RotatingStarField.ROTATION_NODE_POSITION = OFFSET_MAP[SELECTED_OFFSET]
	RotatingStarField.initialize_with_set_values()

	Events.position = OFFSET_MAP[SELECTED_OFFSET]

	for i in range(EVENTS_LIMIT):
		create_new_event()
	
	
func _process(delta: float) -> void:
	Events.rotate(SPEED * delta)
	ScoreLabel.text = "Score: " + str(score)
	if (len(Events.get_children()) < EVENTS_LIMIT):
		create_new_event()
	
	
func create_new_event():
	var newEvent = Event.instantiate()
	newEvent.set(
		"location", 
		get_random_point_in_circle() if SELECTED_OFFSET == 0 else get_random_point_in_disk()
	)
	Events.add_child(newEvent)
	newEvent.connect('player_over', _on_event_player_over)
	newEvent.connect('player_exited', _on_player_exited)


func get_random_point_in_disk() -> Vector2:
	var center_vector = get_viewport_rect().size / 2.
	var scaled_unit_vector = center_vector.normalized() * (center_vector.y)
	var inner_radius = center_vector - scaled_unit_vector
	var outer_radius = center_vector + scaled_unit_vector
	var angle = randf_range(0, TAU)
	var distance = randf_range(inner_radius.length(), outer_radius.length())
	return Vector2.ZERO + Vector2.from_angle(angle) * distance


func get_random_point_in_circle() -> Vector2:
	var center_vector = get_viewport_rect().size / 2
	var radius = center_vector.y
	var angle = randf_range(0, TAU)
	var distance = randf() * radius 
	return center_vector + (Vector2.from_angle(angle) * distance)


func _on_event_player_over(event:Node2D, player:Node2D) -> void:
	target_map[player.name].append(event)


func _on_player_exited(event:Node2D, player:Node2D) -> void:
	target_map[player.name].remove_at(target_map[player.name].find(event))
	

func _on_player_observe(player:Node2D) -> void:
	for event in target_map[player.name]:
		score += event.points
		event.queue_free()
