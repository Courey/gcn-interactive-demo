extends Control

@export var min_value: float = 0.0
@export var max_value: float = 100.0
@export var value_start: float
@export var value_end: float
@export var stat_name: String

@export_color_no_alpha var background_color: Color = Color.DARK_GRAY
@export_color_no_alpha var highlight_color: Color = Color.GREEN

@onready var background = $Background as ColorRect
@onready var highlight = $Highlight as ColorRect
@onready var label = $Label as Label

func _ready():
	label.text = stat_name
	background.color = background_color
	highlight.color = highlight_color
	set_value_start(value_start)
	set_value_end(value_end)

func set_value_start(val: float) -> void:
	value_start = clamp(val, min_value, max_value)
	update_bar()

func set_value_end(val: float) -> void:
	value_end = clamp(val, min_value, max_value)
	update_bar()

func update_bar() -> void:
	# Convert stat range to local bar width
	var total_range = max_value - min_value
	if total_range == 0:
		return

	var start_ratio = (value_start - min_value) / total_range
	var end_ratio = (value_end - min_value) / total_range
	var bar_width = size.x

	# Ensure left-to-right fill
	var left = min(start_ratio, end_ratio) * bar_width
	var right = max(start_ratio, end_ratio) * bar_width
	var width = right - left

	highlight.position.x = left
	highlight.size.x = width
	background.size = size

func _on_resized() -> void:
	update_bar()
