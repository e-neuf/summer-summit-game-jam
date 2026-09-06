extends Control

const LEVEL_SELECT = "res://level_select.tscn"


func _ready() -> void:
	if not MusicHandler.playing:
		print("Tonight i sing")
		MusicHandler.play_music_track_from_beg(MusicHandler.MUSIC_TRACKS.Main_Menu_Music)
	%LevelSelectButton.pressed.connect(open_level_select)
	%QuitLink.pressed.connect(quit)


func open_level_select() -> void:
	#MusicHandler.stop()
	get_tree().change_scene_to_file(LEVEL_SELECT)


func quit() -> void:
	get_tree().quit()
