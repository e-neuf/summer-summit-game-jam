extends PanelContainer

const POSITIVE_COLOR := Color(0.5608, 0.7020, 1.0)
const NEGATIVE_COLOR := Color(1.0, 0.6078, 0.6078)
const BG_COLOR := Color(0.078, 0.078, 0.106, 0.95) 
const BORDER_COLOR := Color(0.243, 0.243, 0.298, 1.0)
const ACCENT_WIDTH := 3
const CORNER_RADIUS := 10
const DOT_SIZE := 18

var polarity: int = 1


func _ready() -> void:
	_update_visual()
	if Global.Main_character:
		_on_player_registered()
	else:
		Global.Player_Registered.connect(_on_player_registered)


func _process(_delta: float) -> void:
	if not Global.Main_character:
		return
	var ratio := 1.0
	if MainCharacter.FLIP_COOLDOWN > 0.0:
		ratio = 1.0 - clamp(Global.Main_character.flip_cooldown / MainCharacter.FLIP_COOLDOWN, 0.0, 1.0)
	$Margin/VBox/CooldownBar.value = ratio


func _on_player_registered() -> void:
	polarity = Global.Main_character.polarity
	Global.Main_character.polarity_flip.connect(_on_polarity_flip)
	_update_visual()

func _on_polarity_flip(pol: int) -> void:
	polarity = pol
	_update_visual()


func _get_color() -> Color:
	return POSITIVE_COLOR if polarity > 0 else NEGATIVE_COLOR


func _update_visual() -> void:
	var color := _get_color()

	var panel_sb := StyleBoxFlat.new()
	panel_sb.bg_color = BG_COLOR
	panel_sb.set_border_width_all(0)
	panel_sb.border_width_left = ACCENT_WIDTH
	panel_sb.border_color = color
	panel_sb.set_corner_radius_all(CORNER_RADIUS)
	panel_sb.content_margin_left = 12.0
	panel_sb.content_margin_right = 12.0
	panel_sb.content_margin_top = 8.0
	panel_sb.content_margin_bottom = 8.0
	add_theme_stylebox_override("panel", panel_sb)

	var dot_sb := StyleBoxFlat.new()
	dot_sb.bg_color = color
	dot_sb.set_corner_radius_all(DOT_SIZE / 2)
	$Margin/VBox/SymbolRow/SymbolDot.add_theme_stylebox_override("panel", dot_sb)

	$Margin/VBox/SymbolRow/SymbolLabel.text = "+" if polarity > 0 else "−"
	$Margin/VBox/SymbolRow/SymbolLabel.add_theme_color_override("font_color", color)

	var fill_sb := StyleBoxFlat.new()
	fill_sb.bg_color = color
	fill_sb.set_corner_radius_all(3)
	$Margin/VBox/CooldownBar.add_theme_stylebox_override("fill", fill_sb)

	var bar_bg := StyleBoxFlat.new()
	bar_bg.bg_color = Color(0.05, 0.05, 0.07, 1.0)
	bar_bg.set_corner_radius_all(3)
	$Margin/VBox/CooldownBar.add_theme_stylebox_override("background", bar_bg)

	reset_size()
