extends Node2D


@onready var Polygon = $MaskArea/Polygon2D as Polygon2D
@onready var SourceEvent = $Event


## (Global?) location of event, around which the masking area will be drawn
@export var EventLocation:Vector2
@export_enum (
	"Swift_BAT:", # Arcmin localization
	"FERMI_GBM:1", # Larger circle
	"LVK:2" # Banana shape
) var LocalizationType = 0

var reveal_size:Vector2 = Vector2(150,50)

var image: Image
var mask_tex : ImageTexture:
	set(value):
		mask_tex = value
		queue_redraw()


func _ready() -> void:
	image = Image.create_empty(1920, 1080, false, Image.FORMAT_RGBA8)
	image.fill(Polygon.color)
	mask_tex = ImageTexture.create_from_image(image)

	Polygon.texture = mask_tex
	print(Geometry2D.is_point_in_polygon(SourceEvent.position, Polygon.polygon))




func _input(event: InputEvent) -> void:
	# TODO: Update this to handle player inputs
	if event is InputEventMouseButton and event.is_pressed():
		print("Mouse Click/Unclick at: ", event.position)
		interact_at(event.position)


func interact_at(pos:Vector2):
	#var mid_size = reveal_size/2
	var targetRect = Rect2(pos-(reveal_size/2), reveal_size)
	if SourceEvent!= null && targetRect.has_point(SourceEvent.position):
		SourceEvent.visible = true
	for x in range(-reveal_size.x/2, reveal_size.x/2):
		for y in range(-reveal_size.y/2, reveal_size.y/2):
			var p = pos + Vector2(x, y)
			if p.x >= 0 and p.x < image.get_width() and p.y >= 0 and p.y < image.get_height():
				image.set_pixelv(p, Color.TRANSPARENT)
	mask_tex.update(image)
