class_name TelescopeSlot extends Panel

@export var observatory:Telescope

@onready var PlayerOutline1 = $PlayerOutline1 as Line2D
@onready var PlayerOutline2 = $PlayerOutline2 as Line2D
@onready var PlayerOutline3 = $PlayerOutline3 as Line2D
@onready var PlayerOutline4 = $PlayerOutline4 as Line2D
@onready var ObservatoryButton = $ObservatoryButton as TextureButton
@onready var P1_Label = $Player1
@onready var P2_Label = $Player2
@onready var P3_Label = $Player3
@onready var P4_Label = $Player4

var player_labels:Array[Label] = []
var player_outlines:Array[Line2D] = []

signal pressed

func _ready():
	ObservatoryButton.texture_normal = observatory.image
	player_labels.append_array([P1_Label, P2_Label, P3_Label, P4_Label])
	player_outlines.append_array([PlayerOutline1,PlayerOutline2,PlayerOutline3,PlayerOutline4])
	for player in Global.PLAYERS:
		player_labels[player.id - 1].add_theme_color_override("font_color", player.player_color)
		player_outlines[player.id - 1].default_color = player.player_color
		player_outlines[player.id - 1].default_color.a = .25


func _process(_delta: float) -> void:
	for player in Global.PLAYERS:
		if player.observatory == observatory:
			player_outlines[player.id-1].show()
			player_labels[player.id -1].show()
		else:
			player_outlines[player.id-1].hide()
			player_labels[player.id -1].hide()

func _button_pressed() -> void:
	pressed.emit()
