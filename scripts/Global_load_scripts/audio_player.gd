extends AudioStreamPlayer

const level_music = preload("res://assets/music/xDeviruchi - Title Theme .wav")

func _play_music(music: AudioStream, volume = 0.0):
	#if current music is being play, do nothing
	if stream == music:
		return
	#otherwise, set current stream to play and the volume of music
	stream = music
	volume_db = volume
	play()

func play_music_level():
	_play_music(level_music)
