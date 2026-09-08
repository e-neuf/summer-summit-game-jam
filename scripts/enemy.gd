extends CharacterBody2D


const SPEED = 100.0 # slow, persistent pursuit - a background threat, not an instant resolve
const POSITIVE_COLOR := Color(0.2314, 0.4824, 1.0) # matches magnetic_pole.gd's positive color
const NEGATIVE_COLOR := Color(1.0, 0.2745, 0.2745) # matches magnetic_pole.gd's negative color
const BODY_COLOR := Color(0.16, 0.17, 0.20) # lighter graphite - readable against the near-black background (0.06,0.05,0.06), unlike floor.gd's FILL_BOTTOM
const BODY_HIGHLIGHT := Color(0.78, 0.81, 0.88, 0.95) # brighter outline for silhouette contrast in open air
const CORE_GLOW_ALPHA := 0.45
const CORE_RADIUS := 9.0
const CORE_GLOW_RADIUS := 18.0
const SPIN_SPEED := 3.2

# Irregular jagged silhouette, local space, centered on origin -
# a loose shard of unstable scrap rather than a smooth shape.
var BODY_POINTS := PackedVector2Array([
	Vector2(-8, -40), Vector2(18, -32), Vector2(38, -8),
	Vector2(30, 20), Vector2(10, 38), Vector2(-22, 34),
	Vector2(-40, 10), Vector2(-32, -18),
])

var polarity = -1
var target: MainCharacter
var type = "Em"
var start_position: Vector2
var furthest_x: float


func _ready() -> void:
	add_to_group("enemies")
	start_position = position
	furthest_x = position.x
	queue_redraw()


func _get_core_color() -> Color:
	return POSITIVE_COLOR if polarity > 0 else NEGATIVE_COLOR


func _physics_process(delta: float) -> void:
	rotation += SPIN_SPEED * delta
	if target:
		var direction = target.global_position - position
		var new_velocity: Vector2
		if target.polarity == 1:
			new_velocity = direction.normalized() * (SPEED / 2)
			## if positive, cut enemy speed in half
		else:
			new_velocity = direction.normalized() * SPEED

		velocity = new_velocity

	move_and_slide()

	if position.x < furthest_x:
		position.x = furthest_x # never retreat - hold ground until the player draws level again
	else:
		furthest_x = position.x


func _draw() -> void:
	draw_colored_polygon(BODY_POINTS, BODY_COLOR)
	var outline := BODY_POINTS.duplicate()
	outline.append(BODY_POINTS[0]) # close the loop so the whole silhouette is outlined, not just two edges
	draw_polyline(outline, BODY_HIGHLIGHT, 2.0, true)
	var core := _get_core_color()
	draw_circle(Vector2.ZERO, CORE_GLOW_RADIUS, Color(core.r, core.g, core.b, CORE_GLOW_ALPHA))
	draw_circle(Vector2.ZERO, CORE_RADIUS, core)


func _on_sense_player_body_entered(body: Node2D) -> void:
	if body is MainCharacter:
		target = body


func _on_sense_player_body_exited(body: Node2D) -> void:
	pass # sticky chase: once triggered, keep pursuing until reset_self() or Destruct()


func Destruct() -> void:
	target = null
	velocity = Vector2.ZERO
	visible = false
	set_physics_process(false)
	$HitBox.set_deferred("disabled", true)
	$Sense_Player/CollisionShape2D.set_deferred("disabled", true)


func reset_self() -> void:
	target = null
	velocity = Vector2.ZERO
	position = start_position
	furthest_x = start_position.x
	rotation = 0.0
	visible = true
	set_physics_process(true)
	$HitBox.set_deferred("disabled", false)
	$Sense_Player/CollisionShape2D.set_deferred("disabled", false)
	queue_redraw()
