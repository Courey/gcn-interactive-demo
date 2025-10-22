extends Node2D

@onready var poly = $Polygon2D
var mask_img : Image
@export var mask_tex : ImageTexture:
	set(value):
		mask_tex = value
		queue_redraw()

#@export var texture : Texture2D:


func _draw():
	draw_texture(mask_tex, Vector2())


func _ready():

	var size = Vector2(1920, 1080)
	mask_img = Image.create_empty(size.x, size.y, false, Image.FORMAT_RF)
	mask_img.fill(Color.WHITE)
	mask_tex = ImageTexture.create_from_image(mask_img)
	poly.material.set_shader_parameter("mask_tex", mask_tex)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		#draw_circle(event.position, 20.0, Color.WHITE)
		print("Mouse Click/Unclick at: ", event.position)
		interact_at(event.position)

func interact_at(local_pos: Vector2):
	#mask_img.lock()
	for x in range(-1, 1):
		for y in range(-1, 1):
			var p = local_pos + Vector2(x, y)
			if p.x >= 0 and p.x < mask_img.get_width() and p.y >= 0 and p.y < mask_img.get_height():
				mask_img.set_pixelv(p, Color.BLUE) # reveal
	#mask_img.unlock()
	mask_tex.update(mask_img)
