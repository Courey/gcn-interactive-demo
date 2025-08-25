extends Node2D

@export var ROTATION_NODE_POSITION = Vector2.ZERO
@export var SPEED = 0.05

@onready var RotationNode = $RotationNode


func _ready() -> void:
	pass
	
func initialize_with_set_values():
	RotationNode.position = ROTATION_NODE_POSITION 


func _process(delta: float) -> void:
	RotationNode.rotate(SPEED * delta)
