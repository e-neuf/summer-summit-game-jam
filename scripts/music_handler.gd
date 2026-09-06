extends AudioStreamPlayer
enum MUSIC_TRACKS{
	Main_Menu_Music,
	Polarity_Postive_Music,
	Polarity_Negative_Music	
}
var music_tracks={
	MUSIC_TRACKS.Main_Menu_Music:preload("res://assets/music/Adding the Sun.mp3"),
	MUSIC_TRACKS.Polarity_Postive_Music:preload("res://assets/music/Somewhere Sunny.mp3"),
	MUSIC_TRACKS.Polarity_Negative_Music:preload("res://assets/music/Private Reflection.mp3"),
}
var volume =1: # must be a value between 0 to 1, 1 is full, 0 is mute
	set =set_volume
# Called when the node enters the scene tree for the first time.
func play_music_track_from_beg(music_track):
	stream=music_tracks[music_track]
	play()
#when has progress
func play_music_track(music_track, progress ):
	stream=music_tracks[music_track]
	print(progress)
	if progress && (progress is float):
		if(progress!=0):
			play(progress)
			print("playing")
		else:
			play()

func set_volume(new_volume):
	volume=new_volume
	volume_db=linear_to_db(volume)
func fade_volume(target_volume,time_in_seconds):
	var tween= create_tween()
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_method(set_volume,volume,target_volume,time_in_seconds)
	
#pause music and returns the progress made on track time
func pause():
	var progress=get_playback_position()
	var stream_length =stream.get_length() if stream else 0.0
	progress =clamp(progress, 0.0, stream_length)
	print("Song progress: %f | Total: %f" % [progress, stream_length])
	return progress;
	
