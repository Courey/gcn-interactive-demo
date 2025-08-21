extends Node2D

var player_in_area = false
@export var location: Vector2


func _ready() -> void:
	position = location
	add_to_group("selectable")


func _on_event_area_area_entered(area: Area2D) -> void:
	#pass # Replace with function body.
	print("Event area entered: ")
	print(area.name)
	print(area.get_parent().get_parent().name)
	#if (area.name == "")
