extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Global.Main_character:
		on_player_registered()
	else:
		Global.Player_Registered.connect(on_player_registered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.Main_character:
		global_position.x = Global.Main_character.global_position.x - get_viewport_rect().size.x / 2


func on_player_registered() -> void:
	pass
	#global_position.y = Global.Main_character.global_position.y
