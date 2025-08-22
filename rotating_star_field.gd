extends Node2D

# Figure something out with this
const OFFSET_MAP = [
	Vector2(960,540),
	Vector2(0,0)
]

@export_enum ("CENTER:0","CORNER:1") var OFFSET_OPTIONS = 0

@export var SPEED = 0.05

func _ready() -> void:
	$RotationNode.position = OFFSET_MAP[$".".OFFSET_OPTIONS]


func _process(delta: float) -> void:
	$RotationNode.rotate(SPEED * delta)
