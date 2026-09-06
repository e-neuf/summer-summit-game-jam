extends Control

const BLUE := Color(0.2314, 0.4824, 1.0)
const RED := Color(1.0, 0.2745, 0.2745)
const BORDER_COLOR := Color(0.1725, 0.1725, 0.2118)
const HALF_SIZE := Vector2(64.0, 64.0)
const BORDER_WIDTH := 2
const GLOW_SIZE := 10


func _ready() -> void:
	custom_minimum_size = HALF_SIZE * Vector2(2.0, 1.0)
	_style_label($PlusLabel)
	_style_label($MinusLabel)
	queue_redraw()


func _style_label(label: Label) -> void:
	label.add_theme_color_override("font_color", Color.WHITE)
	var base_font := label.get_theme_font("font")
	if base_font:
		var bold := FontVariation.new()
		bold.base_font = base_font
		bold.variation_embolden = 0.6
		label.add_theme_font_override("font", bold)


func _draw() -> void:
	var blue_rect := Rect2(Vector2.ZERO, HALF_SIZE)
	var red_rect := Rect2(Vector2(HALF_SIZE.x, 0.0), HALF_SIZE)
	draw_style_box(_make_stylebox(BLUE, true), blue_rect)
	draw_style_box(_make_stylebox(RED, false), red_rect)

func _make_stylebox(color: Color, rounded_left: bool) -> StyleBoxFlat:
	var sb := StyleBoxFlat.new()
	sb.bg_color = color
	sb.set_corner_radius_all(0)
	var cap_radius := int(HALF_SIZE.y / 2.0)
	if rounded_left:
		sb.corner_radius_top_left = cap_radius
		sb.corner_radius_bottom_left = cap_radius
	else:
		sb.corner_radius_top_right = cap_radius
		sb.corner_radius_bottom_right = cap_radius

	sb.border_width_top = BORDER_WIDTH
	sb.border_width_bottom = BORDER_WIDTH
	sb.border_width_left = BORDER_WIDTH if rounded_left else 0
	sb.border_width_right = 0.0 if rounded_left else BORDER_WIDTH
	sb.border_color = BORDER_COLOR

	sb.shadow_color = Color(color.r, color.g, color.b, 0.45)
	sb.shadow_size = GLOW_SIZE
	return sb
