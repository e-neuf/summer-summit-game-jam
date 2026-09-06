extends Camera2D


func _process(_delta: float) -> void:
	if Global.Main_character:
		global_position.x = Global.Main_character.global_position.x - get_viewport_rect().size.x / 2
