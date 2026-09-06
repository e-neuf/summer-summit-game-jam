extends Area2D

const POSITIVE_COLOR := Color(0.2314, 0.4824, 1.0) # magnet positive, #3B7BFF (precise hex - was previously a rough Color(0.15,0.45,1.0) approximation)
const NEGATIVE_COLOR := Color(1.0, 0.2745, 0.2745) # magnet negative, #FF4646 (precise hex - was previously a rough Color(1.0,0.15,0.15) approximation)

const BODY_RADIUS := 18.0 # solid visible body, always this size regardless of field radius
const GLOW_RADIUS := 28.0 # soft halo behind the body - draw_circle has no stylebox/shadow to reuse directly like hero_logo.gd's StyleBoxFlat shadow, so this is the same concept (a soft, low-alpha halo tinted to the element's own color) adapted for a circle
const GLOW_ALPHA := 0.45 # matches hero_logo.gd's shadow_color alpha
const RING_ALPHA := 0.45
const RING_WIDTH := 3.0
const DASH_LENGTH := 10.0
const GAP_LENGTH := 8.0

const attractive_field_radius: float = 200.0 # the radius the player must be in to be attracted to the magnet
var repellant_field_radius: float = 80.0 # the radius the player must be in to be repelled from the magnet

const FIELD_TOP_MARGIN := 1000.0 # how far above the magnet the vertical field extends when grounded; generously covers the playable vertical space without hardcoding camera/viewport bounds
const GROUND_RAY_LENGTH := 4000.0

enum Kind {
	POST,
	HAZARD,
	ENEMY,
	GOAL,
}

@export var kind: Kind = Kind.POST
@export var polarity: int = 1 # this needs to be either 1 or -1 to be able to calculate the math
var current_field_radius: float = 80.0
var _ground_offset_y = null # local y-offset of the ground below this magnet, or null if there's none in range (e.g. it sits over a pit) - the field stays circular in that case


func _get_color() -> Color:
	return POSITIVE_COLOR if polarity > 0 else NEGATIVE_COLOR


func _ready() -> void:
	add_to_group("magnets")
	$Label.text = "+" if polarity > 0 else "−"
	#self.input_event.connect(_on_self_clicked)
	# Global.Player_Registered fires once, from the player's own _ready() - if this magnet's
	# _ready() runs after that (e.g. it's declared later in the scene file than the player
	# node, as every Zone 2 magnet is), connecting alone would miss it forever. Same guard
	# level.gd/polarity_hud.gd/horizontal_camera.gd already use for the same signal.
	if Global.Main_character:
		on_player_registered()
	else:
		Global.Player_Registered.connect(on_player_registered)


func _process(_delta: float) -> void:
	queue_redraw()


func _draw() -> void:
	var color := _get_color()
	draw_circle(Vector2.ZERO, GLOW_RADIUS, Color(color.r, color.g, color.b, GLOW_ALPHA))
	draw_circle(Vector2.ZERO, BODY_RADIUS, color)
	_draw_dashed_ring(current_field_radius, Color(color.r, color.g, color.b, RING_ALPHA))


# To show the mangetic field - always a circle, regardless of the actual (possibly rectangular) collision shape
func _draw_dashed_ring(radius: float, color: Color) -> void:
	var segment_angle := DASH_LENGTH / radius
	var gap_angle := GAP_LENGTH / radius
	var angle := 0.0
	while angle < TAU:
		draw_arc(Vector2.ZERO, radius, angle, angle + segment_angle, 6, color, RING_WIDTH)
		angle += segment_angle + gap_angle


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("register_magnet"):
		body.register_magnet(self)


func _on_body_exited(body: Node2D) -> void:
	if body.has_method("unregister_magnet"):
		body.unregister_magnet(self)


func _on_mouse_entered() -> void:
	var is_attractive = polarity != Global.Main_character.polarity # add glow function, i lowkey dont know how to make glow effect
	##if is, glow?? or something


func _on_mouse_exited() -> void:
	pass # Replace with function body.


#func _on_self_clicked(viewport: Node, event: InputEvent, shape_idx: int):
	#if event.is_action_pressed("mouse_click"):
		#print("help " + self.name)
		#if (polarity != Global.Main_character.polarity && Global.MC_magnets_in_range.rfind(self) != -1):
			#print("I am attractive")
			#Global.Current_Attraction = self
		#else:
			#print("I am unattractive")
			#Global.Current_Attraction = null


func on_player_registered() -> void:
	# Confirm current field radius
	current_field_radius = attractive_field_radius if polarity != Global.Main_character.polarity else repellant_field_radius

	# Wait a physics frame before raycasting - direct_space_state isn't reliably populated
	# yet during the same frame nodes enter the tree.
	await get_tree().physics_frame
	_find_ground()
	_update_field_shape()
	queue_redraw()

	# Listen for player polarity flip signal
	Global.Main_character.polarity_flip.connect(on_polarity_flip)


# When the player flips their polarity, update the current field radius
func on_polarity_flip(pol: int) -> void:
	current_field_radius = attractive_field_radius if polarity != pol else repellant_field_radius
	_update_field_shape()
	queue_redraw()


# Casts a ray straight down from the magnet to find the ground beneath it, if any.
func _find_ground() -> void:
	var space_state := get_world_2d().direct_space_state
	var query := PhysicsRayQueryParameters2D.create(global_position, global_position + Vector2(0, GROUND_RAY_LENGTH))
	var result := space_state.intersect_ray(query)
	_ground_offset_y = (result.position.y - global_position.y) if result else null

# Deferred because this can be triggered mid-physics-query-flush (e.g. dead_zone.gd's
# body_entered -> restart_level() -> reset_self() -> polarity_flip, all within one physics
# step) - Godot disallows changing an Area2D's collision shape synchronously in that window.
func _update_field_shape() -> void:
	_apply_field_shape.call_deferred()


func _apply_field_shape() -> void:
	if _ground_offset_y == null:
		var shape := CircleShape2D.new()
		shape.radius = current_field_radius
		$CollisionShape2D.shape = shape
		$CollisionShape2D.position = Vector2.ZERO
	else:
		var shape := RectangleShape2D.new()
		shape.size = Vector2(current_field_radius * 2.0, _ground_offset_y + FIELD_TOP_MARGIN)
		$CollisionShape2D.shape = shape
		$CollisionShape2D.position = Vector2(0, (_ground_offset_y - FIELD_TOP_MARGIN) / 2.0)
