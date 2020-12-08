extends Node2D

var audio_player

func _ready():
	audio_player = AudioStreamPlayer.new()
	
func play(sound: String):
	audio_player.stream = load(sound)
	audio_player.play()
