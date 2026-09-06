extends StaticBody2D

const FILL_TOP := Color(0.1020, 0.1098, 0.1333)
const FILL_BOTTOM := Color(0.0471, 0.0510, 0.0627) 
const DEEP_FILL := Color(0.03, 0.032, 0.038) 
const HIGHLIGHT_COLOR := Color(0.55, 0.58, 0.65, 0.9)
const HIGHLIGHT_HEIGHT := 2.0
const GRADIENT_STEPS := 8
const DEPTH_STEPS := 6

const SIZE := Vector2(86.0, 18.0)
const LOCAL_OFFSET := Vector2(0.0, 1.5)


const DEPTH_EXTENSION := 150.0

const SEAM_BLEED := 3.0

const TRACE_COLOR := Color(0.2314, 0.4824, 1.0, 0.35) 
const TRACE_WIDTH := 1.5
const TRACE_CHANCE := 0.45
const TRACE_NODE_RADIUS := 2.0


func _ready() -> void:
	queue_redraw()


func _draw() -> void:
	var top_left := LOCAL_OFFSET - SIZE / 2.0
	var draw_x := top_left.x - SEAM_BLEED
	var draw_width := SIZE.x + SEAM_BLEED * 2.0

	_draw_gradient(draw_x, draw_width, top_left.y, SIZE.y, FILL_TOP, FILL_BOTTOM, GRADIENT_STEPS)
	draw_rect(Rect2(Vector2(draw_x, top_left.y), Vector2(draw_width, HIGHLIGHT_HEIGHT)), HIGHLIGHT_COLOR)

	var depth_top := top_left.y + SIZE.y
	_draw_gradient(draw_x, draw_width, depth_top, DEPTH_EXTENSION, FILL_BOTTOM, DEEP_FILL, DEPTH_STEPS)

	_draw_circuit_trace(top_left)


func _draw_gradient(x: float, width: float, y_start: float, height: float, top_color: Color, bottom_color: Color, steps: int) -> void:
	for i in range(steps):
		var t0 := float(i) / steps
		var t1 := float(i + 1) / steps
		var y0 := y_start + height * t0
		var y1 := y_start + height * t1
		var color := top_color.lerp(bottom_color, (t0 + t1) / 2.0)
		draw_rect(Rect2(Vector2(x, y0), Vector2(width, y1 - y0 + 0.5)), color)

func _draw_circuit_trace(top_left: Vector2) -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = get_instance_id()
	if rng.randf() > TRACE_CHANCE:
		return

	var y1 := top_left.y + rng.randf_range(2.0, SIZE.y - 2.0)
	var y2 := top_left.y + rng.randf_range(2.0, SIZE.y - 2.0)
	var x_start := top_left.x + rng.randf_range(4.0, SIZE.x * 0.35)
	var x_bend := top_left.x + rng.randf_range(SIZE.x * 0.4, SIZE.x * 0.65)
	var x_end := top_left.x + rng.randf_range(SIZE.x * 0.7, SIZE.x - 4.0)

	draw_line(Vector2(x_start, y1), Vector2(x_bend, y1), TRACE_COLOR, TRACE_WIDTH)
	draw_line(Vector2(x_bend, y1), Vector2(x_bend, y2), TRACE_COLOR, TRACE_WIDTH)
	draw_line(Vector2(x_bend, y2), Vector2(x_end, y2), TRACE_COLOR, TRACE_WIDTH)
	draw_circle(Vector2(x_bend, y1), TRACE_NODE_RADIUS, TRACE_COLOR)
	draw_circle(Vector2(x_bend, y2), TRACE_NODE_RADIUS, TRACE_COLOR)
