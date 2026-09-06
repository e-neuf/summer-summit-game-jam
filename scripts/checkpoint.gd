extends Area2D

const BEACON_COLOR := Color(0.35, 0.95, 0.65) # teal/green - deliberately not blue/red so it never reads as tied to polarity
const GLOW_ALPHA := 0.45 # matches hero_logo.gd/magnetic_pole.gd's glow alpha
const GLOW_WIDTH := 10.0
const LINE_WIDTH := 3.0
const HEIGHT := 600.0 # tall enough to trigger regardless of how high the player is when passing through


func _ready() -> void:
	queue_redraw()


func _draw() -> void:
	var top := Vector2(0, -HEIGHT / 2.0)
	var bottom := Vector2(0, HEIGHT / 2.0)
	draw_line(top, bottom, Color(BEACON_COLOR.r, BEACON_COLOR.g, BEACON_COLOR.b, GLOW_ALPHA), GLOW_WIDTH)
	draw_line(top, bottom, BEACON_COLOR, LINE_WIDTH)


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("set_checkpoint"):
		body.set_checkpoint(global_position, body.polarity)
