extends Panel

@export var controlling_player:PlayerResource

@onready var ObservatoryLabel = $ObservatoryLabel as Label
@onready var PositionLabel = $PositionLabel as Label
@onready var SelectedObsImage = $SelectedObservatoryImage as TextureRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	ObservatoryLabel.text = controlling_player.observatory.telescope_name
	PositionLabel.text = controlling_player.observatory.get_location_string()
	SelectedObsImage.texture = controlling_player.observatory.image
