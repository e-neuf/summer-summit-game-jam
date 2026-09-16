extends Node2D

const MAIN_MENU = "res://main_menu.tscn"

var positive_song_progress = 0.0
var negative_song_progress = 0.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not MusicHandler.playing:
		MusicHandler.play_music_track_from_beg(MusicHandler.MUSIC_TRACKS.Polarity_Postive_Music)
	Global.Level = self
	Global.Level_Registered.emit()

	%MainMenuButton.pressed.connect(return_to_menu)
	%RestartButton.pressed.connect(restart_level.bind(true))

	if Global.Main_character:
		on_player_registered()
	else:
		Global.Player_Registered.connect(on_player_registered)


func return_to_menu() -> void:
	MusicHandler.stop()
	get_tree().change_scene_to_file(MAIN_MENU)


# Resets the player's position and polarity
func restart_level(from_start: bool = false) -> void:
	%GameOverPanel.hide()
	Global.Level_Over = false
	Global.Current_Attraction = null
	Global.Main_character.reset_self(from_start)
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.reset_self()


func game_over() -> void:
	Global.Level_Over = true
	%GameOverPanel.show()


func on_player_registered() -> void:
	Global.Main_character.polarity_flip.connect(on_polarity_flip)


func on_polarity_flip(pol: int) -> void:
	# Save previous song progress
	if (pol < 0):
		positive_song_progress = MusicHandler.pause()
	else:
		negative_song_progress = MusicHandler.pause()

	MusicHandler.stop()
	if (pol < 0):
		if (negative_song_progress != 0.0):
			print("neg music from prev progress")
			MusicHandler.play_music_track(
				MusicHandler.MUSIC_TRACKS.Polarity_Negative_Music,
				negative_song_progress,
			)
		else:
			print("neg music from beg")
			MusicHandler.play_music_track_from_beg(
				MusicHandler.MUSIC_TRACKS.Polarity_Negative_Music
			)
	else:
		if (positive_song_progress != 0.0):
			print("Pos from not beg")
			MusicHandler.play_music_track(
				MusicHandler.MUSIC_TRACKS.Polarity_Postive_Music,
				positive_song_progress,
			)
		else:
			print("Pos from beg")
			MusicHandler.play_music_track_from_beg(MusicHandler.MUSIC_TRACKS.Polarity_Postive_Music)
