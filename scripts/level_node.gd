extends Button

const UNLOCKED_COLOR := Color(0.15, 0.45, 1.0)
const UNLOCKED_GLOW := Color(0.15, 0.45, 1.0, 0.4)
const LOCKED_COLOR := Color(0.16, 0.16, 0.2)
const LOCKED_BORDER := Color(0.28, 0.28, 0.34)

const NODE_SIZE := Vector2(110.0, 100.0)
const CENTER := Vector2(55.0, 35.0) # keep in sync with dashed_connector.gd's LINE_Y
const RADIUS := 35.0
const GLOW_RADIUS := 46.0

const LOCK_BADGE_CENTER := Vector2(84.0, 64.0)
const LOCK_BADGE_RADIUS := 10.0
const LOCK_BADGE_COLOR := Color(0.03, 0.03, 0.05, 0.92)
const LOCK_ICON_COLOR := Color(0.82, 0.82, 0.86, 1)
const LOCK_SHACKLE_RADIUS := 3.2
const LOCK_SHACKLE_WIDTH := 1.4
const LOCK_SHACKLE_OFFSET_Y := -2.0
const LOCK_BODY_SIZE := Vector2(9.0, 6.0)
const LOCK_BODY_OFFSET_Y := 2.3
const LOCK_BODY_CORNER := 1.5

@export var level_number: int = 1
@export var unlocked: bool = false
@export var target_scene: String = ""


func _ready() -> void:
	flat = true
	focus_mode = FOCUS_NONE
	custom_minimum_size = NODE_SIZE
	$NumberLabel.text = str(level_number)
	$NameLabel.text = ("LEVEL %d" % level_number) if unlocked else "LOCKED"
	_bold($NumberLabel)
	disabled = not unlocked
	if unlocked and target_scene != "":
		pressed.connect(_on_pressed)
	queue_redraw()


func _bold(label: Label) -> void:
	var base_font := label.get_theme_font("font")
	if base_font:
		var bold := FontVariation.new()
		bold.base_font = base_font
		bold.variation_embolden = 0.6
		label.add_theme_font_override("font", bold)


func _draw() -> void:
	if unlocked:
		draw_circle(CENTER, GLOW_RADIUS, UNLOCKED_GLOW)
		draw_circle(CENTER, RADIUS, UNLOCKED_COLOR)
	else:
		draw_circle(CENTER, RADIUS, LOCKED_COLOR)
		draw_arc(CENTER, RADIUS, 0, TAU, 32, LOCKED_BORDER, 2.0)
		_draw_lock_icon()


func _draw_lock_icon() -> void:
	draw_circle(LOCK_BADGE_CENTER, LOCK_BADGE_RADIUS, LOCK_BADGE_COLOR)

	var shackle_center := LOCK_BADGE_CENTER + Vector2(0, LOCK_SHACKLE_OFFSET_Y)
	draw_arc(shackle_center, LOCK_SHACKLE_RADIUS, PI, TAU, 16, LOCK_ICON_COLOR, LOCK_SHACKLE_WIDTH, true)

	var body_center := LOCK_BADGE_CENTER + Vector2(0, LOCK_BODY_OFFSET_Y)
	var body_rect := Rect2(body_center - LOCK_BODY_SIZE / 2.0, LOCK_BODY_SIZE)
	var body_style := StyleBoxFlat.new()
	body_style.bg_color = LOCK_ICON_COLOR
	body_style.set_corner_radius_all(int(LOCK_BODY_CORNER))
	draw_style_box(body_style, body_rect)


func _on_pressed() -> void:
	get_tree().change_scene_to_file(target_scene)
