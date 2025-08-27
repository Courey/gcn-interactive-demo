class_name Player extends Node2D

@export var input_prefix := "p1"
@export var active = false
@export var player_color:Color
@export var start_position:Vector2 = Vector2.ZERO

# "Player Stats:
@export var slew_speed := 300.0
@export var sensitivity := 1 # Points drained from events per second of observation
@export var observation_area = Vector2.ZERO


@onready var target = $Target
@onready var light_cone = $LightCone
@onready var collision_shape = $Target/TargetFocus/CollisionShape2D
@onready var target_shader = $Target/TargetFocus/CollisionShape2D.material as ShaderMaterial
@onready var timer = $InactiveTimeout as Timer
@onready var sensitivity_timer = $SensitivityTimer as Timer


signal observe
signal abort

var is_observing = false

func _ready():
	position = start_position
	player_color = player_color if player_color else Color(randf(), randf(), randf(), .5)
	target_shader.set_shader_parameter('player_color', player_color)

	collision_shape.shape.size = observation_area

	light_cone.polygon = PackedVector2Array([
		Vector2.ZERO,
		Vector2.ZERO,
		Vector2.ZERO,
	])
	light_cone.color = player_color
	light_cone.color.a = .5

	sensitivity_timer.wait_time = sensitivity



func initialize_with_set_values(): # Do we need this?
	pass


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
			sensitivity_timer.start()
			#observe.emit(self)
		target_shader.set_shader_parameter('is_observing', is_observing)


	# Restart the timeout counter for inactive players
	timer.stop()
	timer.start()


func _process(delta):
	if (!active):
		light_cone.modulate.a = .2
		return

	if !is_observing:
		var move_input = Vector2(
			Input.get_action_strength(input_prefix + "_right")
			- Input.get_action_strength(input_prefix + "_left"),
			Input.get_action_strength(input_prefix + "_down")
			- Input.get_action_strength(input_prefix + "_up")
		)

		# Move target relative to player position
		var new_target_pos:Vector2 = target.position + move_input * slew_speed * delta
		target.position = new_target_pos

	light_cone.polygon = draw_arms()
	#light_cone.rotation = rotation



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
	var relative_vector:Vector2 = collision_shape.global_position
	relative_vector -= Global.ROTATION_AXIS
	relative_vector = relative_vector.rotated(rotation_speed)
	relative_vector += Global.ROTATION_AXIS
	collision_shape.global_position = relative_vector


func _on_inactive_timeout_timeout() -> void:
	active = false
	target.global_position = start_position
	light_cone.polygon = draw_arms()


func _on_sensitivity_timer_timeout() -> void:
	observe.emit(self)
