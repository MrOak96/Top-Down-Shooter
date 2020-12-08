extends KinematicBody2D
class_name Enemy

var speed = 1
var direction: Vector2 = Vector2.ZERO
var path: = PoolVector2Array()

onready var nav_2d: Navigation2D = get_node("/root/Main/Navigation2D")
onready var main = get_node("/root/Main")
onready var death = false
onready var health = $Health
onready var animation_damage = $AnimationPlayer
onready var player: Player = get_node("/root/Main/Player")
onready var cooldown: Timer = $AttackCooldown
onready var blood: CPUParticles2D = $Blood
onready var hurt_sounds = []
onready var step_sounds = []
onready var death_sound
onready var timer = 0
onready var path_timer = 0
onready var time = randf()*1.0+0.5;
onready var body: Area2D = $Body

func _ready():
	get_viewport().audio_listener_enable_2d = true
	hurt_sounds.append($Body/Sprite/hurt1)
	hurt_sounds.append($Body/Sprite/hurt2)
	step_sounds.append($Body/Sprite/step1)
	step_sounds.append($Body/Sprite/step2)
	step_sounds.append($Body/Sprite/step3)
	step_sounds.append($Body/Sprite/step4)
	step_sounds.append($Body/Sprite/step5)
	death_sound = $Body/Sprite/death

func handle_hit():
	if(death != true):
		health.health -= player.weapon.damage
		animation_damage.play("DamageAnimation")
		hurt_sounds[randi()%1].play()
		if(health.health <= 0):
			on_death()

func on_death():
	visible = false
	player.gain_exp(10)
	var pos = Vector2.ZERO
	pos.x = global_position.x
	pos.y = global_position.y
	if(randi()%4 == 0):
		get_parent().spawn_health_package(pos)
	else:
		if(randi()%4 == 0):
			get_parent().spawn_ammo_package(pos)
	death_sound.play()
	death = true

func _process(delta):
	if(!death_sound.is_playing() and death == true):
		queue_free()

func _physics_process(delta):
	if(death != true):
		if!(player in body.get_overlapping_bodies()):
			path_timer += delta
			if(path_timer > 0.5):
				path = nav_2d.get_simple_path(self.global_position, player.global_position)
				path_timer = 0
			if(path.size() > 0):
				direction = (path[1] - self.global_position).normalized()
				if((path[1] - self.global_position).length() < speed):
					position = path[1]
				else:
					position = position + (direction * speed)
		else:
			if(cooldown.is_stopped()):
				player.take_damage(5)
				cooldown.start()
				
		rotation = (player.global_position - self.global_position).angle()
		
		timer += delta
		if timer > time:
			step_sounds[randi()%4].play()
			timer = 0
			time = randf()*1.0+0.5
