class_name Player extends Node2D

@export var input_prefix := "p1"
@export var active: bool = false
@export var player_color: Color
@export var start_position: Vector2 = Vector2.ZERO

## Selected Obeservatory
@export var observatory_index:int
@export var selected: bool = false

# Player Stats, these will be determined by Observatory selection screen
@export var slew_speed := 300.0
@export var sensitivity := 1 # Should scale inversely with observation_area
@export var observation_area = Vector2.ZERO
@export var wavelength = 500 # This may be better as a type (ex: UV, Radio, etc)
# that can be used to check group collaboration

@onready var target = $Target as CharacterBody2D
@onready var light_cone = $LightCone as Polygon2D
@onready var collision_shape = $Target/CollisionShape2D as CollisionShape2D
@onready var sprite = $Target/Sprite as Sprite2D
@onready var target_shader = $Target/Sprite.material as ShaderMaterial
@onready var timer = $InactiveTimeout as Timer
@onready var sensitivity_timer = $SensitivityTimer as Timer


signal observe
signal abort

var is_observing = false
var id:int

func _init(player_id: int, color: Color):
	id = player_id
	input_prefix = 'p%d' % player_id
	player_color = color

func _ready():
	position = start_position
	player_color = player_color if player_color else Color(randf(), randf(), randf(), .5)
	target_shader.set_shader_parameter('player_color', player_color)

	collision_shape.shape.size = observation_area
	sprite.scale.x = observation_area.x / sprite.texture.get_width() # 480.0
	sprite.scale.y = observation_area.y / sprite.texture.get_height()

	light_cone.color = player_color
	light_cone.color.a = .5

	sensitivity_timer.wait_time = sensitivity


func _input(event):
	if (event.is_action_pressed(input_prefix + "_select")):
		# Enable player
		if (!active):
			active = true
			light_cone.modulate.a = .5
		elif is_observing:
			is_observing = false
			sensitivity_timer.stop()
			abort.emit(self)
		else:
			is_observing = true
			observe.emit(self)
			sensitivity_timer.start()
		target_shader.set_shader_parameter('is_observing', is_observing)

	# Restart the timeout counter for inactive players
	timer.stop()
	timer.start()


func _process(_delta):
	light_cone.polygon = draw_arms()


func _physics_process(_delta: float) -> void:
	if (!active):
		return
	# Move target relative to player position
	if !is_observing:
		target.velocity = Vector2(
			Input.get_action_strength(input_prefix + "_right")
			- Input.get_action_strength(input_prefix + "_left"),
			Input.get_action_strength(input_prefix + "_down")
			- Input.get_action_strength(input_prefix + "_up")
		) * slew_speed
	else:
		target.velocity = Vector2.ZERO
	target.move_and_slide()


func draw_arms_circular() -> PackedVector2Array:
	var shape = collision_shape.shape as CircleShape2D

	var target_position = collision_shape.global_position - global_position
	var target_angle = target_position.angle() - collision_shape.global_rotation
	var T = target_position.length()
	var angle_offset = asin(shape.radius/T)

	var phi_1 = target_angle + angle_offset
	var phi_2 = target_angle - angle_offset

	var l = sqrt(T**2 - (shape.radius)**2)

	return PackedVector2Array([
		Vector2.ZERO,
		Vector2(cos(phi_1) * l, sin(phi_1)*l),
		Vector2(cos(phi_2) * l, sin(phi_2)*l)
	])


func draw_arms() -> PackedVector2Array:
	var shape = collision_shape.shape as RectangleShape2D
	var target_position:Vector2 = Vector2(
		collision_shape.global_position - global_position
	).rotated(-rotation)

	return PackedVector2Array([
		# Point at the players origin
		Vector2.ZERO,
		# Bottom left corner:
		target_position + Vector2(-shape.size.x/2, shape.size.y/2),
		# Bottom right corner
		target_position + Vector2(shape.size.x/2, shape.size.y/2),
	])


func rotate_relative_to_background(rotation_speed) -> void:
	var relative_vector:Vector2 = target.global_position
	relative_vector -= Global.ROTATION_AXIS
	relative_vector = relative_vector.rotated(rotation_speed)
	relative_vector += Global.ROTATION_AXIS
	target.global_position = relative_vector


func _on_inactive_timeout_timeout() -> void:
	active = false
	is_observing = false
	target.position = Vector2.ZERO
	light_cone.polygon = draw_arms()


func _on_sensitivity_timer_timeout() -> void:
	observe.emit(self)
