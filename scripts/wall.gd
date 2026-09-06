extends StaticBody2D

# Same dark-metallic gradient technique as floor.gd, oriented horizontally instead of
# vertically, so walls and ground read as the same material.
const FILL_LEFT := Color(0.1020, 0.1098, 0.1333) # #1a1c22
const FILL_RIGHT := Color(0.0471, 0.0510, 0.0627) # #0c0d10
const EDGE_HIGHLIGHT := Color(0.55, 0.58, 0.65, 0.9) # matches floor.gd's metallic sheen
const EDGE_WIDTH := 2.0
const GRADIENT_STEPS := 8

# Matches CollisionShape2D's shape size exactly, so the drawn wall always lines up with
# where the player actually collides.
const SIZE := Vector2(40.0, 320.0)


func _ready() -> void:
	queue_redraw()


func _draw() -> void:
	var top_left := -SIZE / 2.0

	for i in range(GRADIENT_STEPS):
		var t0 := float(i) / GRADIENT_STEPS
		var t1 := float(i + 1) / GRADIENT_STEPS
		var x0 := top_left.x + SIZE.x * t0
		var x1 := top_left.x + SIZE.x * t1
		var color := FILL_LEFT.lerp(FILL_RIGHT, (t0 + t1) / 2.0)
		draw_rect(Rect2(Vector2(x0, top_left.y), Vector2(x1 - x0 + 0.5, SIZE.y)), color)

	draw_rect(Rect2(top_left, Vector2(EDGE_WIDTH, SIZE.y)), EDGE_HIGHLIGHT)
	draw_rect(Rect2(Vector2(top_left.x + SIZE.x - EDGE_WIDTH, top_left.y), Vector2(EDGE_WIDTH, SIZE.y)), EDGE_HIGHLIGHT)
