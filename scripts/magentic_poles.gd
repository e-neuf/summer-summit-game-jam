extends Area2D

const POSITIVE_COLOR := Color(0.15, 0.45, 1.0)
const NEGATIVE_COLOR := Color(1.0, 0.15, 0.15)

const BODY_RADIUS := 18.0 #solid visible body, always this size regardless of field radius
const RING_ALPHA := 0.45
const RING_WIDTH := 3.0
const DASH_LENGTH := 10.0
const GAP_LENGTH := 8.0

const attractive_field_radius: float = 200.0 # the radius the player must be in to be attracted to the magnet
var repellant_field_radius: float = 80.0 # the radius the player must be in to be repelled from the magnet

enum Kind {
	POST,
	HAZARD,
	ENEMY,
	GOAL,
}

@export var kind: Kind = Kind.POST
@export var polarity: int = 1 #this needs to be either 1 or -1 to be able to calculate the math
var current_field_radius: float = 80.0


func _get_color() -> Color:
	return POSITIVE_COLOR if polarity > 0 else NEGATIVE_COLOR


func _ready() -> void:
	add_to_group("magnets")
	$Label.text = "+" if polarity > 0 else "−"
	$Label.modulate = _get_color()
	self.input_event.connect(_on_self_clicked)
	Global.Player_Registered.connect(on_player_registered)


func _process(_delta: float) -> void:
	queue_redraw()


func _draw() -> void:
	var color := _get_color()
	draw_circle(Vector2.ZERO, BODY_RADIUS, color)
	_draw_dashed_ring(current_field_radius, Color(color.r, color.g, color.b, RING_ALPHA))


#to show mangetic field
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
		print("Magnet %s registering myself" % self.name)


func _on_body_exited(body: Node2D) -> void:
	if body.has_method("unregister_magnet"):
		body.unregister_magnet(self)
		print("Magnet %s UNregistering myself" % self.name)


func _on_mouse_entered() -> void:
	var is_attractive = polarity != Global.Main_character.polarity # add glow function, i lowkey dont know how to make glow effect
	##if is, glow?? or something


func _on_mouse_exited() -> void:
	pass # Replace with function body.


#func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
#if event.is_action_pressed("mouse_click"):
#print("help")
func _on_self_clicked(viewport: Node, event: InputEvent, shape_idx: int):
	if event.is_action_pressed("mouse_click"):
		print("help " + self.name)
		if (polarity != Global.Main_character.polarity && Global.MC_magnets_in_range.rfind(self) != -1):
			print("I am attractive")
			Global.Current_Attraction = self
		else:
			print(
				"I am unattractive | %s | %s | %s"
				% [
					polarity != Global.Main_character.polarity,
					Global.MC_magnets_in_range.rfind(self) != -1,
					$CollisionShape2D.shape.radius,
				]
			)
			Global.Current_Attraction = null


func on_player_registered() -> void:
	current_field_radius = attractive_field_radius if polarity != Global.Main_character.polarity else repellant_field_radius
	$CollisionShape2D.shape = $CollisionShape2D.shape.duplicate()
	$CollisionShape2D.shape.radius = current_field_radius
	queue_redraw()
	Global.Main_character.polarity_flip.connect(on_polarity_flip)


func on_polarity_flip(pol: int) -> void:
	current_field_radius = attractive_field_radius if polarity != pol else repellant_field_radius
	$CollisionShape2D.shape.radius = current_field_radius
	queue_redraw()
