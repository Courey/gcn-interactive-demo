extends Node2D

signal player_over
signal player_exited

@export var location: Vector2
@export var points: int = 10


func _ready() -> void:
	global_position = location
	

func _process(delta: float) -> void:
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
