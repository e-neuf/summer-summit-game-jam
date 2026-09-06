extends Control

const LINE_COLOR := Color(0.2314, 0.4824, 1.0, 0.035)
const SPACING := 140.0
const LINE_WIDTH := 1.0


func _ready() -> void:
	mouse_filter = MOUSE_FILTER_IGNORE
	queue_redraw()


func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		queue_redraw()


func _draw() -> void:
	var x := 0.0
	while x < size.x:
		draw_line(Vector2(x, 0.0), Vector2(x, size.y), LINE_COLOR, LINE_WIDTH)
		x += SPACING

	var y := 0.0
	while y < size.y:
		draw_line(Vector2(0.0, y), Vector2(size.x, y), LINE_COLOR, LINE_WIDTH)
		y += SPACING
