extends Control

@export var ring_color: Color = Color(0.2314, 0.4824, 1.0, 0.18)
@export var radius: float = 210.0
@export var dash_length: float = 14.0
@export var gap_length: float = 10.0
@export var ring_width: float = 2.0
@export var pulse: bool = true
@export var pulse_duration: float = 6.0


func _ready() -> void:
	mouse_filter = MOUSE_FILTER_IGNORE
	queue_redraw()
	if pulse:
		_start_pulse()


func _draw() -> void:
	var segment_angle := dash_length / radius
	var gap_angle := gap_length / radius
	var angle := 0.0
	while angle < TAU:
		draw_arc(Vector2.ZERO, radius, angle, angle + segment_angle, 8, ring_color, ring_width)
		angle += segment_angle + gap_angle


func _start_pulse() -> void:
	modulate.a = 0.7
	var tween := create_tween().set_loops().set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "scale", Vector2(1.05, 1.05), pulse_duration / 2.0)
	tween.parallel().tween_property(self, "modulate:a", 1.0, pulse_duration / 2.0)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), pulse_duration / 2.0)
	tween.parallel().tween_property(self, "modulate:a", 0.7, pulse_duration / 2.0)
