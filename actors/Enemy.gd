extends KinematicBody2D
class_name Enemy

var speed = 1
var direction: Vector2 = Vector2.ZERO
var path: = PoolVector2Array()

onready var nav_2d: Navigation2D = get_node("/root/Main/Map/Navigation2D")
onready var main = get_node("/root/Main")
onready var health = 100
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
onready var bleeding_timer: Timer = $BleedingTimer
onready var bleed_timer = 0

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
	take_damage(player.weapon.damage)
	initBleeding()

func take_damage(var damage):
	health -= damage
	animation_damage.play("DamageAnimation")
	hurt_sounds[randi()%1].play()
	$Blood.emitting = true
	if(health <= 0):
		on_death()

func on_death():
	visible = false
	var pos = Vector2.ZERO
	pos.x = global_position.x
	pos.y = global_position.y
	get_parent().spawn_exp(pos)
	if(randi()%10 == 0):
		if(randi()%10 > 3):
			get_parent().spawn_ammo_package(pos)
		else:
			get_parent().spawn_health_package(pos)
	queue_free()

func _process(delta):
	if!($BleedingTimer.is_stopped()):
		bleed_timer += delta
		if(bleed_timer > 1):
			take_damage(5)
			bleed_timer = 0
	else:
		bleed_timer = 0

func _physics_process(delta):
	if(get_parent().pathfinding_demo):
		get_parent().line.points = path
	if!(player in body.get_overlapping_bodies()):
		path_timer += delta
		if(path_timer > 1):
			path = nav_2d.get_simple_path(self.global_position, player.global_position, false)
			path_timer = 0
		if(path.size() > 0):
			direction = (path[1] - self.global_position).normalized()
			if((path[1] - self.global_position).length() < speed):
				position = path[1]
				path = nav_2d.get_simple_path(self.global_position, player.global_position, false)
			else:
				move_and_slide(direction * speed * 50)
			$Ground.emitting = true
			$Ground.gravity.x = direction.x * -150
			$Ground.gravity.y = direction.y * -150
			$Ground.rotation_degrees = self.rotation_degrees * -1
	else:
		if(cooldown.is_stopped()):
			player.take_damage(5)
			player.initBleeding()
			cooldown.start()
				
	rotation = (player.global_position - self.global_position).angle()
		
	timer += delta
	if timer > time:
		step_sounds[randi()%4].play()
		timer = 0
		time = randf()*1.0+0.5

func initBleeding():
	bleeding_timer.wait_time = 5
	bleeding_timer.start()
