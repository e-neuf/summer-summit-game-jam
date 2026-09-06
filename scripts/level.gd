extends Node2D

const MAIN_MENU = "res://main_menu.tscn"

#var positive_song = preload("res://assets/music/Somewhere Sunny.mp3")
#var negative_song = preload("res://assets/music/Private Reflection.mp3")

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
	
	
func game_over() -> void:
	Global.Level_Over = true
	%GameOverPanel.show()
	
	
func on_player_registered() -> void:
	Global.Main_character.polarity_flip.connect(on_polarity_flip)


func on_polarity_flip(pol: int) -> void:
	# Save previous song progress
	if (pol < 0):
		positive_song_progress =MusicHandler.pause()
		 #$AudioStreamPlayer.get_playback_position()
		#var stream_length = $AudioStreamPlayer.stream.get_length() if $AudioStreamPlayer.stream else 0.0
		#positive_song_progress = clamp(positive_song_progress, 0.0, stream_length)
		#print("Positive song progress: %f | Total: %f" % [positive_song_progress, stream_length])
	else:
		negative_song_progress = MusicHandler.pause()
		#$AudioStreamPlayer.get_playback_position()
		#var stream_length = $AudioStreamPlayer.stream.get_length() if $AudioStreamPlayer.stream else 0.0
		#negative_song_progress = clamp(negative_song_progress, 0.0, stream_length)
		#print("Negative song progress: %f | Total: %f" % [negative_song_progress, stream_length])
	MusicHandler.stop()
	if(pol<0 && negative_song_progress!=0):
		print("neh music from prev progress")
		MusicHandler.play_music_track(MusicHandler.MUSIC_TRACKS.Polarity_Negative_Music,negative_song_progress)
	elif(pol<0 && negative_song_progress==0):
		print("neg music from beg");
		MusicHandler.play_music_track_from_beg(MusicHandler.MUSIC_TRACKS.Polarity_Negative_Music)
	elif(pol>0 && positive_song_progress!=0):
		print("Pos from not beg")
		MusicHandler.play_music_track(MusicHandler.MUSIC_TRACKS.Polarity_Postive_Music,positive_song_progress)
	elif(pol>0):
		print("Pos from beg")
		MusicHandler.play_music_track_from_beg(MusicHandler.MUSIC_TRACKS.Polarity_Postive_Music)
		positive_song_progress = $AudioStreamPlayer.get_playback_position()
		#print("Negative song progress: %f | Total: %f" % [negative_song_progress, stream_length])
	
	
	
			#$AudioStreamPlayer.stop()
	#$AudioStreamPlayer.stream = negative_song if pol < 0 else positive_song
	#$AudioStreamPlayer.play(negative_song_progress if pol < 0 else positive_song_progress)
	#
