extends CharacterBody2D

const GRAVITY := 600.0
const JUMP_VELOCITY := -460.0
const ACCEL := 950.0 #how fast horizontal speed goes up and down
const MAX_SPEED := 230.0
const HOMING_SPEED := 260.0 #top speed while being pulled toward an attracting magnet
const HOMING_RESPONSE := 0.12 #how quickly velocity blends towards the pull (lower makes it flaotier and higher would make it snappier)
const HOMING_LEAD := 70.0
const REPEL_SPEED := 260.0 #symmetric with HOMING_SPEED by default; tune independently if repel should feel different
const FLIP_COOLDOWN := 0.35
const PASSED_MARGIN := 20.0 #how far past a POST/GOAL magnet (in +x) before it stops being homed to

const POSITIVE_COLOR := Color(0.15, 0.45, 1.0)
const NEGATIVE_COLOR := Color(1.0, 0.15, 0.15)
const BODY_RADIUS := 20.0 #matches this node's CollisionShape2D circle radius

var polarity: int = 1
var flip_cooldown: float = 0.0
var magnets_in_range: Array = []

func register_magnet(m) -> void:
	magnets_in_range.append(m)

func unregister_magnet(m) -> void:
	magnets_in_range.erase(m)

func _get_color() -> Color:
	return POSITIVE_COLOR if polarity > 0 else NEGATIVE_COLOR

func _ready() -> void:
	_update_visual()

func _draw() -> void:
	draw_circle(Vector2.ZERO, BODY_RADIUS, _get_color())

func _update_visual() -> void:
	$Label.text = "+" if polarity > 0 else "−"
	$Label.modulate = _get_color()
	queue_redraw()

func _physics_process(delta: float) -> void:
	if flip_cooldown > 0.0:
		flip_cooldown -= delta

	if Input.is_action_just_pressed("flip_polarity") and flip_cooldown <= 0.0:
		polarity *= -1
		flip_cooldown = FLIP_COOLDOWN
		_update_visual()

	var nearest = null
	var nearest_dist = INF
	for m in magnets_in_range:
		if not is_instance_valid(m):
			continue
		var d = global_position.distance_to(m.global_position)
		if d < nearest_dist:
			nearest = m
			nearest_dist = d

	var interaction = 0
	if nearest:
		interaction = -(nearest.polarity * polarity)  #+1 attract, -1 repel
		var passed: bool = (nearest.kind == nearest.Kind.POST or nearest.kind == nearest.Kind.GOAL) and global_position.x > nearest.global_position.x + PASSED_MARGIN
		if interaction == 1 and passed:
			interaction = 0

	var input_dir := Input.get_axis("move_left", "move_right")
	if input_dir != 0.0:
		velocity.x = move_toward(velocity.x, input_dir * MAX_SPEED, ACCEL * delta)
	elif is_on_floor():
		velocity.x = move_toward(velocity.x, 0.0, ACCEL * delta)

	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_VELOCITY

	if nearest and interaction == 1:
		var target = nearest.global_position + Vector2(HOMING_LEAD, 0)
		var to_target = target - global_position
		var dist = max(to_target.length(), 1.0)
		var target_vel = (to_target / dist) * HOMING_SPEED
		velocity = velocity.lerp(target_vel, HOMING_RESPONSE)
	elif nearest and interaction == -1:
		var away = global_position - nearest.global_position
		var d = max(away.length(), 1.0)
		var target_vel = (away / d) * REPEL_SPEED
		velocity = velocity.lerp(target_vel, HOMING_RESPONSE)
	else:
		velocity.y += GRAVITY * delta

	move_and_slide()

	if nearest and nearest_dist < 25:
		if (nearest.kind == nearest.Kind.HAZARD or nearest.kind == nearest.Kind.ENEMY) and polarity != nearest.polarity:
			get_tree().reload_current_scene()
		elif nearest.kind == nearest.Kind.GOAL and polarity != nearest.polarity:
			print("LEVEL COMPLETE")
