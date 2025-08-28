extends Node2D

@export var SPEED = 0.05

@onready var RotationNode = $RotationNode
@onready var shader_material = $RotationNode/ColorRect.material as ShaderMaterial


func _ready() -> void:
	RotationNode.position = Global.ROTATION_AXIS
	var noise_texture = shader_material.get_shader_parameter("noise_texture")
	var noise = noise_texture.noise as FastNoiseLite
	noise.seed = randi()


func initialize_with_set_values():
	RotationNode.position = Global.ROTATION_AXIS


func _process(delta: float) -> void:
	RotationNode.rotate(SPEED * delta)
