extends Node2D

const OFFSET_MAP = [
	Vector2(960,540),
	Vector2(0,0)
]

@export_enum ("CENTER:0","CORNER:1") var OFFSET_OPTIONS = 0
@export var SPEED = 0.05

var event = preload("res://event.tscn")

@onready var Events = $Events

func _ready() -> void:
	$RotationNode.position = OFFSET_MAP[$".".OFFSET_OPTIONS]
	for i in range(4):
		create_new_event()

func _process(delta: float) -> void:
	$RotationNode.rotate(SPEED * delta)

func create_new_event():
	var newEvent = event.instantiate()
	newEvent.set("location",Vector2(randi_range(500,1000), randi_range(500,1000)))
	Events.add_child(newEvent)
