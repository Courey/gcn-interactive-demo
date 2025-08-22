extends Node2D

var score = 0
var Event = preload("res://event.tscn")

@export var EVENTS_LIMIT = 10

@onready var ScoreLabel = $Score
@onready var Events = $Events
@onready var Players = $Players

var target_map:Dictionary = {}


func _ready():
	for player in Players.get_children():
		player.connect("observe",_on_player_observe)
		target_map[player.name] = []
	for i in range(EVENTS_LIMIT):
		create_new_event()
	
	
func _process(_delta: float) -> void:
	ScoreLabel.text = "Score: " + str(score)
	if (len(Events.get_children()) < EVENTS_LIMIT):
		create_new_event()
	
	
func create_new_event():
	var newEvent = Event.instantiate()
	newEvent.set("location", 
		Vector2(randi_range(500,1000), randi_range(500,1000))
	)	
	Events.add_child(newEvent)
	newEvent.connect('player_over', _on_event_player_over)
	newEvent.connect('player_exited', _on_player_exited)


func _on_event_player_over(event:Node2D, player:Node2D) -> void:
	target_map[player.name].append(event)


func _on_player_exited(event:Node2D, player:Node2D) -> void:
	target_map[player.name].remove_at(target_map[player.name].find(event))
	

func _on_player_observe(player:Node2D) -> void:
	for event in target_map[player.name]:
		event.queue_free()
