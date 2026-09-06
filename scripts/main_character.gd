class_name MainCharacter
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
const LAUNCH_BOOST_WINDOW := 0.25 #brief grace period after flipping out of an active attraction, during which held input fully overrides the "must point away" anti-cheese filter below - this is what makes the deliberate flip-to-launch move work

const POSITIVE_COLOR := Color(0.5608, 0.7020, 1.0) # player positive, #8FB3FF - lighter than the magnet's #3B7BFF so the player always reads as visually distinct from a magnet
const NEGATIVE_COLOR := Color(1.0, 0.6078, 0.6078) # player negative, #FF9B9B - lighter than the magnet's #FF4646
const BODY_RADIUS := 20.0 #matches this node's CollisionShape2D circle radius

var polarity: int = 1
var flip_cooldown: float = 0.0
var launch_boost_timer: float = 0.0

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
	if polarity != start_polarity:
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
	$Label.text = "+" if polarity > 0 else "−"


func _update_visual() -> void:
	queue_redraw()


func _physics_process(delta: float) -> void:
	if flip_cooldown > 0.0:
		flip_cooldown -= delta
	if launch_boost_timer > 0.0:
		launch_boost_timer -= delta

	if Input.is_action_just_pressed("flip_polarity") and flip_cooldown <= 0.0:
		if Global.Current_Attraction != null:
			launch_boost_timer = LAUNCH_BOOST_WINDOW
		polarity *= -1
		flip_cooldown = FLIP_COOLDOWN
		_update_visual()
		Global.Current_Attraction = null
		polarity_flip.emit(polarity)

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
				var away = mag.global_position.direction_to(global_position)
				var direction: Vector2
				if launch_boost_timer > 0.0 and not input_dir.is_zero_approx():
					direction = input_dir
				elif not input_dir.is_zero_approx() and input_dir.dot(away) > 0.0:
					direction = input_dir
				else:
					direction = away
				target_velocity += direction * REPEL_SPEED

	if (Global.Current_Attraction != null):
		print("Being attracted by %s" % Global.Current_Attraction.name)
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
	if(!being_repelled && target_velocity==Vector2.ZERO):
		if input_dir.x != 0.0:
			velocity.x = move_toward(velocity.x, input_dir.x * MAX_SPEED, ACCEL * delta)
		else:
			velocity.x = move_toward(velocity.x, 0.0, ACCEL * delta)
	
	
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
