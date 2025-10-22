extends Button

@export var character_id: String
@export var character_image: Texture2D

func _ready():
	icon = character_image
