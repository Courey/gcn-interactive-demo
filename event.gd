extends Node2D

signal player_over
signal player_exited

@export var location: Vector2
@export var points: int = 10

@onready var decay_timer = $DecayTimer
@onready var sprite = $Sprite2D as Sprite2D


func _ready() -> void:
	global_position = location
	decay_timer.wait_time = 1
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0, decay_timer.wait_time * points)
	decay_timer.start()
	sprite.scale *= float(points / 20.0) #?


func _process(_delta: float) -> void:
	if global_position.x < 0:
		queue_free()
	if points == 0:
		queue_free()


func _on_event_area_area_entered(area: Area2D) -> void:
	var player = area.get_parent().get_parent()
	player_over.emit(self, player)


func _on_event_area_area_exited(area: Area2D) -> void:
	var player = area.get_parent().get_parent()
	player_exited.emit(self, player)


func _on_decay_timer_timeout() -> void:
	points -= 1
	decay_timer.start()
