extends Sprite

var timer = 0;
var time = randf()*1.0+0.5;
onready var step_sounds = []

func _ready():
	get_viewport().audio_listener_enable_2d = true
	step_sounds.append($step1)
	step_sounds.append($step2)
	step_sounds.append($step3)
	step_sounds.append($step4)
	step_sounds.append($step5)

func _process(delta):
	timer += delta
	if timer > time:
		step_sounds[randi()%4].play()
		timer = 0
		time = randf()*1.0+0.5
