class_name SelectedTelescopeDisplay extends PanelContainer

@export var controlling_player:PlayerResource

@onready var MainControlBox = $MainControlBox
@onready var MainLabel = $MainControlBox/MainLabel as Label
@onready var ObservatoryLabel = $MainControlBox/HBoxContainer/ObservatoryLabel as Label
@onready var PositionLabel = $MainControlBox/HBoxContainer/PositionLabel as Label
@onready var SelectedObsImage = $MainControlBox/SelectedObservatoryImage as TextureRect
@onready var ReadyUpLabel = $ReadyUpLabel


func _process(_delta: float) -> void:
	if controlling_player.observatory:
		ObservatoryLabel.text = controlling_player.observatory.telescope_name
		PositionLabel.text = controlling_player.observatory.get_location_string()
		SelectedObsImage.texture = controlling_player.observatory.image
	MainLabel.text = "Ready!" if controlling_player.ready else "Select Your Observatory"

func toggle_ready_display():
	MainControlBox.visible = !MainControlBox.visible
	ReadyUpLabel.visible = !ReadyUpLabel.visible
