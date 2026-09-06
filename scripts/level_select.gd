extends Control

const MAIN_MENU = "res://main_menu.tscn"


func _ready() -> void:
	%BackButton.pressed.connect(go_back)


func go_back() -> void:
	get_tree().change_scene_to_file(MAIN_MENU)
