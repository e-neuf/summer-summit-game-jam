extends Control

const LEVEL_SELECT = "res://level_select.tscn"


func _ready() -> void:
	%LevelSelectButton.pressed.connect(open_level_select)
	%QuitLink.pressed.connect(quit)


func open_level_select() -> void:
	get_tree().change_scene_to_file(LEVEL_SELECT)


func quit() -> void:
	get_tree().quit()
