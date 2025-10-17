extends Panel

#@export var observatory_image: Texture2D
@export var observatory:Telescope

@onready var PlayerOutline = $PlayerOutline
@onready var ObservatoryButton = $ObservatoryButton as TextureButton
@onready var P1_Label = $Player1
@onready var P2_Label = $Player2
@onready var P3_Label = $Player3
@onready var P4_Label = $Player4

var player_labels:Array[Label] = []

signal pressed

func _ready():
	PlayerOutline.hide()
	update_image(observatory)
	player_labels.append_array([P1_Label, P2_Label, P3_Label, P4_Label])

func _button_pressed() -> void:
	pressed.emit()

func deselect():
	PlayerOutline.hide()

func player_hover(player:PlayerResource):
	if is_node_ready():
		PlayerOutline.default_color = player.player_color
		player_labels[player.id -1].label_settings.font_color = player.player_color
		player_labels[player.id -1].show()
		PlayerOutline.show()

func update_image(telescope: Telescope):
	#var loadedImage = load(image)
	ObservatoryButton.texture_normal = telescope.image
