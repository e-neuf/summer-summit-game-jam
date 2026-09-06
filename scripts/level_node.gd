extends Button

const UNLOCKED_COLOR := Color(0.15, 0.45, 1.0)
const UNLOCKED_GLOW := Color(0.15, 0.45, 1.0, 0.4)
const LOCKED_COLOR := Color(0.16, 0.16, 0.2)
const LOCKED_BORDER := Color(0.28, 0.28, 0.34)

const NODE_SIZE := Vector2(110.0, 100.0)
const CENTER := Vector2(55.0, 35.0)
const GLOW_RADIUS := 46.0

@export var level_number: int = 1
@export var unlocked: bool = false
@export var target_scene: String = ""


func _ready() -> void:
	flat = true
	focus_mode = FOCUS_NONE
	custom_minimum_size = NODE_SIZE
	$NumberLabel.text = str(level_number)
	$NameLabel.text = ("LEVEL %d" % level_number) if unlocked else "LOCKED"
	$LockBadge.visible = not unlocked
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


func _on_pressed() -> void:
	get_tree().change_scene_to_file(target_scene)
