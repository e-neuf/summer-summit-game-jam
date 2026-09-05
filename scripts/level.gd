extends Node2D

const MAIN_MENU = "res://main_menu.tscn"

@onready var player = get_node("Main Character")
@onready var player_start_pos = player.global_position
@onready var player_start_polarity = player.polarity

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%MainMenuButton.pressed.connect(return_to_menu)
	%RestartButton.pressed.connect(restart_level)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func return_to_menu() -> void:
	get_tree().change_scene_to_file(MAIN_MENU)
	
# Resets the player's position and polarity
func restart_level() -> void:
	Global.Current_Attraction = null;
	player.velocity = Vector2.ZERO
	player.global_position = player_start_pos
	player.set_polarity(player_start_polarity)
