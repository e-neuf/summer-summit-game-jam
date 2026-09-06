extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Global.Level:
		on_level_registered()
	else:
		Global.Level_Registered.connect(on_level_registered)


func on_level_registered() -> void:
	%MainMenuButton.pressed.connect(Global.Level.return_to_menu)
	%ReplayButton.pressed.connect(Global.Level.restart_level.bind(true))
