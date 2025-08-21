extends Node2D

@export var input_prefix := "p1"
@export var active = false
@export var target_speed := 300.0
@export var observation_radius = 100
@export var player_color:Color

@onready var target = $Target
@onready var light_cone = $LightCone
@onready var collision_shape = $Target/TargetFocus/CollisionShape2D
@onready var coneShader = $Target/TargetFocus/CollisionShape2D.material as ShaderMaterial
@onready var timer = $InactiveTimeout


func _ready():
	player_color = player_color if player_color else Color(randf(), randf(), randf(), .5)
	collision_shape.shape.radius = observation_radius
	coneShader.set_shader_parameter('circle_color',player_color) 
	
	light_cone.polygon = PackedVector2Array([
		Vector2.ZERO,
		Vector2(collision_shape.shape.radius, collision_shape.position.y),
		Vector2(-collision_shape.shape.radius, collision_shape.position.y),
	])
	light_cone.color = player_color

func _input(event):	
	if (event.is_action_pressed(input_prefix + "_select")):
		# Enable player
		if (!active):
			active = true
			light_cone.modulate.a = .5
		
	
	# Restart the timeout counter for inactive players
	timer.stop()
	timer.start()

func _process(delta):
	if (!active):
		light_cone.modulate.a = .2
		return
	
	
	var move_input = Vector2(
		Input.get_action_strength(input_prefix + "_right") 
		- Input.get_action_strength(input_prefix + "_left"),
		Input.get_action_strength(input_prefix + "_down") 
		- Input.get_action_strength(input_prefix + "_up")
	)

	# Move target relative to player position
	var new_target_pos:Vector2 = target.position + move_input * target_speed * delta
	target.position = new_target_pos

	new_target_pos.length()
	light_cone.polygon = draw_arms()
	

func draw_arms() -> PackedVector2Array:
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



func _on_inactive_timeout_timeout() -> void:
	active = false
