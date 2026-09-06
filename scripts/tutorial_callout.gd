@tool
extends PanelContainer

enum Accent { NEUTRAL, POSITIVE, NEGATIVE }

const BG_COLOR := Color(0.03, 0.03, 0.04, 0.88)
const NEUTRAL_COLOR := Color(0.85, 0.55, 0.25) 
const POSITIVE_COLOR := Color(0.2314, 0.4824, 1.0) 
const NEGATIVE_COLOR := Color(1.0, 0.2745, 0.2745) 
const ACCENT_BORDER_WIDTH := 3
const EDGE_BORDER_WIDTH := 1
const CORNER_RADIUS := 10 
const GLOW_ALPHA := 0.45
const GLOW_SIZE := 10

@export_multiline var text: String = "":
	set(value):
		text = value
		_apply()

@export var icon: String = "":
	set(value):
		icon = value
		_apply()

@export var accent: Accent = Accent.NEUTRAL:
	set(value):
		accent = value
		_apply()


func _ready() -> void:
	_apply()


func _accent_color() -> Color:
	match accent:
		Accent.POSITIVE:
			return POSITIVE_COLOR
		Accent.NEGATIVE:
			return NEGATIVE_COLOR
		_:
			return NEUTRAL_COLOR


func _apply() -> void:
	if not is_node_ready():
		return

	var accent_color := _accent_color()

	var sb := StyleBoxFlat.new()
	sb.bg_color = BG_COLOR
	sb.border_color = accent_color
	sb.border_width_left = ACCENT_BORDER_WIDTH
	sb.border_width_top = EDGE_BORDER_WIDTH
	sb.border_width_right = EDGE_BORDER_WIDTH
	sb.border_width_bottom = EDGE_BORDER_WIDTH
	sb.set_corner_radius_all(CORNER_RADIUS)
	sb.content_margin_left = 14.0
	sb.content_margin_right = 12.0
	sb.content_margin_top = 8.0
	sb.content_margin_bottom = 8.0
	sb.shadow_color = Color(accent_color.r, accent_color.g, accent_color.b, GLOW_ALPHA)
	sb.shadow_size = GLOW_SIZE
	add_theme_stylebox_override("panel", sb)

	$HBox/Icon.text = icon
	$HBox/Icon.visible = icon != ""
	$HBox/Icon.modulate = accent_color
	$HBox/Text.text = text

	reset_size()
