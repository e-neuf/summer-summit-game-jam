extends Node2D

const MAIN_MENU = "res://main_menu.tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%MainMenuButton.pressed.connect(return_to_menu)
	%RestartButton.pressed.connect(restart_level)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func return_to_menu() -> void:
	get_tree().change_scene_to_file(MAIN_MENU)
	
func restart_level() -> void:
	#todo
	print("Restart button pressed")
