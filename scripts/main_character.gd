extends CharacterBody2D

const GRAVITY := 600.0
const JUMP_VELOCITY := -460.0
const ACCEL := 950.0 #how fast horizontal speed goes up and down
const DECCELERATION_RATE := 0.06
const MAX_SPEED := 230.0
const HOMING_SPEED := 280.0 #top speed while being pulled toward an attracting magnet
const HOMING_RESPONSE := 0.12 #how quickly velocity blends towards the pull (lower makes it floatier and higher would make it snappier)
const HOMING_LEAD := 70.0
const REPEL_SPEED := 280.0 #symmetric with HOMING_SPEED by default; tune independently if repel should feel different
const FLIP_COOLDOWN := 0.35
const PASSED_MARGIN := 20.0 #how far past a POST/GOAL magnet (in +x) before it stops being homed to

const POSITIVE_COLOR := Color(0.15, 0.45, 1.0)
const NEGATIVE_COLOR := Color(1.0, 0.15, 0.15)
const BODY_RADIUS := 20.0 #matches this node's CollisionShape2D circle radius

var polarity: int = 1
var flip_cooldown: float = 0.0

@onready var start_pos = global_position
@onready var start_polarity = polarity

signal polarity_flip(pol: int)


func register_magnet(m) -> void:
	Global.MC_magnets_in_range.append(m)


func unregister_magnet(m) -> void:
	Global.MC_magnets_in_range.erase(m)


# Reset to starting position, polarity, and velocity
func reset_self() -> void:
	velocity = Vector2.ZERO
	global_position = start_pos
	polarity = start_polarity
	_update_visual()
	polarity_flip.emit(polarity)


func _get_color() -> Color:
	return POSITIVE_COLOR if polarity > 0 else NEGATIVE_COLOR


func _ready() -> void:
	Global.Main_character = self
	Global.Player_Registered.emit()
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
		polarity_flip.emit(polarity)

	#if Input.is_action_just_pressed("jump") and is_on_floor():
		#velocity.y=-JUMP_FORCE

	# Order of arguments: Negative X, Positive X, Negative Y, Positive Y
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	var target_velocity = Vector2.ZERO

	var nearest = null
	var nearest_dist = INF
	var being_repelled = false
	# program that if they are all in range, and they repell you, otherwise you can click on them to attract to them.
	for mag in Global.MC_magnets_in_range:
		if not is_instance_valid(mag):
			continue
		else:
			if (mag.polarity == polarity):
				print("Being repelled by %s" % mag.name)
				being_repelled = true
				var direction = mag.global_position.direction_to(global_position) if input_dir.is_zero_approx() else input_dir
				target_velocity += direction * REPEL_SPEED

	if (Global.Current_Attraction != null):
		print("Being attracted by %s" % Global.Current_Attraction.name)
		# If the player is no longer in range of the magnet, stop attraction
		if (Global.MC_magnets_in_range.rfind(Global.Current_Attraction) == -1):
			print("No longer attracted to it")
			Global.Current_Attraction = null
		else:
			var direction = global_position.direction_to(Global.Current_Attraction.global_position)
			target_velocity += direction * HOMING_SPEED

	velocity = velocity.lerp(target_velocity, HOMING_RESPONSE if target_velocity != Vector2.ZERO else DECCELERATION_RATE)

	if (not is_on_floor() && !being_repelled):
		velocity.y += Global.Gravity
		if velocity.y > 1000:
			velocity.y = 1000
	elif Input.is_action_just_pressed("jump"):
		velocity.y += JUMP_VELOCITY

	move_and_slide()

	if nearest and nearest_dist < 25:
		if (
			(nearest.kind == nearest.Kind.HAZARD or nearest.kind == nearest.Kind.ENEMY)
			and polarity != nearest.polarity
		):
			get_tree().reload_current_scene()
		elif nearest.kind == nearest.Kind.GOAL and polarity != nearest.polarity:
			print("LEVEL COMPLETE")


func _exit_tree() -> void:
	Global.Main_character = null
