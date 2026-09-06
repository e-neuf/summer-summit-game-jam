extends HBoxContainer

const LINE_COLOR := Color(0.5, 0.5, 0.58, 0.5)
const DASH_LENGTH := 8.0
const GAP_LENGTH := 6.0
const LINE_WIDTH := 2.0
const LINE_Y := 35.0 

func _ready() -> void:
	queue_redraw()


func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		queue_redraw()


func _draw() -> void:
	var x := 0.0
	while x < size.x:
		var x_end: float = min(x + DASH_LENGTH, size.x)
		draw_line(Vector2(x, LINE_Y), Vector2(x_end, LINE_Y), LINE_COLOR, LINE_WIDTH)
		x += DASH_LENGTH + GAP_LENGTH
