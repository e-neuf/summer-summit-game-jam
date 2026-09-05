extends Control

const LEVEL_ONE = "res://levels/Level0.tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%PlayButton.pressed.connect(play)
	%QuitButton.pressed.connect(quit)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func play() -> void:
	get_tree().change_scene_to_file(LEVEL_ONE)
	
func quit() -> void:
	get_tree().quit()
