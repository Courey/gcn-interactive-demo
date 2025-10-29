extends Node2D


@onready var MaskArea = $MaskArea
#@onready var Polygon = $MaskArea/Polygon2D as Polygon2D
@onready var SourceEvent = $Event
@onready var PolyTexture = preload("res://art/grey_square.png")

var Polygon:Polygon2D = Polygon2D.new()


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
	if LocalizationType == 0:
		Polygon = generate_circular_polygon(100, Vector2.ZERO)
	elif LocalizationType == 1:
		Polygon = generate_circular_polygon(500, Vector2.ZERO)
	else:

		var poly1 = generate_circular_polygon(500, Vector2.ZERO)
		var poly2 = generate_circular_polygon(400, Vector2(0,500))
		var clipped_array = Geometry2D.clip_polygons(poly2.polygon, poly1.polygon)
		#Polygon.polygon
		Polygon.polygon = clipped_array
		Polygon.uv = clipped_array
		MaskArea.add_child(Polygon)
		#Polygon.uv = clipped_array

	image = Image.create_empty(1920, 1080, false, Image.FORMAT_RGBA8)
	image.fill(Polygon.color)
	mask_tex = ImageTexture.create_from_image(image)

	Polygon.texture = mask_tex
	print(Geometry2D.is_point_in_polygon(SourceEvent.position, Polygon.polygon))

	#var greater_polygon = generate_circular_polygon(100)
	#var smaller_polygon = generate_circular_polygon(80)



func _input(event: InputEvent) -> void:
	# TODO: Update this to handle player inputs
	if event is InputEventMouseButton and event.is_pressed():
		print("Mouse Click/Unclick at: ", event.position)
		interact_at(event.position)


func interact_at(pos:Vector2):
	var targetRect = Rect2(pos-(reveal_size/2), reveal_size)
	if SourceEvent!= null && targetRect.has_point(SourceEvent.position):
		SourceEvent.visible = true
	for x in range(-reveal_size.x/2, reveal_size.x/2):
		for y in range(-reveal_size.y/2, reveal_size.y/2):
			var p = pos + Vector2(x, y)
			if p.x >= 0 and p.x < image.get_width() and p.y >= 0 and p.y < image.get_height():
				image.set_pixelv(p, Color.TRANSPARENT)
	mask_tex.update(image)


func generate_circular_polygon(radius:int, offset_vector:Vector2) -> Polygon2D:
	var points = 24
	var polygon = Polygon2D.new()
	MaskArea.add_child(polygon)
	polygon.color = Color(randf(),randf(),randf(),.5)
	polygon.texture = PolyTexture
	#polygon.texture.resource_local_to_scene = true
	var rotation_angle = (2 * PI) / points # Radians
	var vect = Vector2(radius,0)
	var vect_array:PackedVector2Array = []
	for _i in points:
		vect_array.append(vect+offset_vector)
		vect = vect.rotated(rotation_angle)
	polygon.polygon= vect_array
	polygon.uv = vect_array
	return polygon
