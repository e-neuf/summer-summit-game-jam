extends Node2D

const MAIN_MENU = "res://main_menu.tscn"

var positive_song = preload("res://assets/music/Somewhere Sunny.mp3")
var negative_song = preload("res://assets/music/Private Reflection.mp3")

var positive_song_progress = 0.0
var negative_song_progress = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.Level = self
	
	%MainMenuButton.pressed.connect(return_to_menu)
	%RestartButton.pressed.connect(restart_level)
	
	if Global.Main_character:
		on_player_registered()
	else:
		Global.Player_Registered.connect(on_player_registered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func return_to_menu() -> void:
	get_tree().change_scene_to_file(MAIN_MENU)


# Resets the player's position and polarity
func restart_level() -> void:
	Global.Current_Attraction = null
	Global.Main_character.reset_self()
	
	
func game_over() -> void:
	%GameOverPanel.show()
	
	
func on_player_registered() -> void:
	Global.Main_character.polarity_flip.connect(on_polarity_flip)


func on_polarity_flip(pol: int) -> void:
	if (pol > 0):
		negative_song_progress = $AudioStreamPlayer2D.get_playback_position()
	else:
		positive_song_progress = $AudioStreamPlayer2D.get_playback_position()
	$AudioStreamPlayer2D.stop()
	$AudioStreamPlayer2D.stream = negative_song if pol < 0 else positive_song
	$AudioStreamPlayer2D.play(positive_song_progress if pol > 0 else negative_song_progress)
	
