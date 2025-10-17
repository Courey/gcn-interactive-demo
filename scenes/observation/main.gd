extends Node2D

var score = 0
var Event = preload("res://scenes/event/event.tscn")

const OFFSET_MAP = [
	Vector2(960,540), #This should be dynamic
	Vector2.ZERO
]

@export_enum ("CENTER:0","CORNER:1") var SELECTED_OFFSET = 0

@export var SPEED = 0.05
@export var EVENTS_LIMIT = 10

@onready var ScoreLabel = $Score as Label
@onready var Events = $Events as Node2D
@onready var PlayerObservers = $PlayerObservers as Node2D
@onready var RotatingStarField = $RotatingStarField

var target_map: Dictionary = {}
var scores: Dictionary = {}


func _ready():
	randomize()

	# Initialize target map and score tracking?
	for player_data in Global.PLAYERS:
		target_map[player_data.name] = []
		scores[player_data.name] = 0

	for playerObserver in PlayerObservers.get_children().filter(func(child): return child is PlayerObserver):
		playerObserver.connect("observe", _on_player_observe)

	Global.ROTATION_AXIS = OFFSET_MAP[SELECTED_OFFSET]
	RotatingStarField.initialize_with_set_values()

	Events.position = Global.ROTATION_AXIS


func _process(delta: float) -> void:
	var rotation_speed = SPEED * delta
	Events.rotate(rotation_speed)
	rotate_observing_players(rotation_speed)
	ScoreLabel.text = "Score: " + str(score)
	if (len(Events.get_children()) < EVENTS_LIMIT):
		create_new_event()
	score = scores.values().reduce(sum, 0)


func sum(accum, number):
	return accum + number


func create_new_event():
	var newEvent = Event.instantiate()
	newEvent.set("location", get_random_point())
	newEvent.set("points", randi_range(10,20))
	Events.add_child(newEvent)
	newEvent.connect('player_over', _on_event_player_over)
	newEvent.connect('player_exited', _on_player_exited)


func get_random_point() -> Vector2:
	var center_vector = get_viewport_rect().size / 2. # Center of screen
	var angle = randf_range(0, TAU)
	var radius = center_vector.y
	var distance = randf() * radius
	return center_vector + Vector2.from_angle(angle) * distance


func _on_event_player_over(event:Node2D, playerObserver:PlayerObserver) -> void:
	target_map[playerObserver.controlling_player.name].append(event)


func _on_player_exited(event:Node2D, playerObserver:PlayerObserver) -> void:
	target_map[playerObserver.controlling_player.name].remove_at(target_map[playerObserver.controlling_player.name].find(event))


func _on_player_observe(playerObserver:PlayerObserver):
	for event in target_map[playerObserver.controlling_player.name]:
		scores[playerObserver.controlling_player.name] += playerObserver.sensitivity * event.decay_rate
	playerObserver.sensitivity_timer.start()

func rotate_observing_players(rotation_speed):
	for playerObserver in PlayerObservers.get_children().filter(func(child):return child is PlayerObserver):
		if playerObserver.is_observing:
			playerObserver.rotate_relative_to_background(rotation_speed)
