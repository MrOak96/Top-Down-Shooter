extends KinematicBody2D
class_name Player

signal player_shooted(bullet, position, direction)

export (int) var speed = 150

onready var experience = 0
onready var level = 1
onready var weapon = $Weapon
onready var max_health = 100.0
onready var health = 100.0
onready var health_bar = $GUI/HealthBar
onready var ammo_bar = $GUI/AmmoBar
onready var step_sounds = []
onready var hit_sounds = []
onready var sound_timer = 0
onready var bleeding_timer: Timer = $BleedingTimer
onready var bleed_timer = 0
onready var blood: CPUParticles2D = $Blood

func _ready():
	get_viewport().audio_listener_enable_2d = true
	weapon.connect("weapon_triggered", self, "shoot")
	step_sounds.append($Body/Sprite/step1)
	step_sounds.append($Body/Sprite/step2)
	step_sounds.append($Body/Sprite/step3)
	step_sounds.append($Body/Sprite/step4)
	step_sounds.append($Body/Sprite/step5)
	step_sounds.append($Body/Sprite/step6)
	hit_sounds.append($Body/Sprite/hit1)
	hit_sounds.append($Body/Sprite/hit2)
	hit_sounds.append($Body/Sprite/hit3)
	
func _process(delta):
	if!($BleedingTimer.is_stopped()):
		bleed_timer += delta
		if(bleed_timer > 1):
			take_damage(5)
			bleed_timer = 0
	else:
		bleed_timer = 0
	
func _physics_process(delta):
	var direction := Vector2.ZERO
	
	if(Input.is_action_pressed("up")):
		direction.y = -1
	if(Input.is_action_pressed("down")):
		direction.y = 1
	if(Input.is_action_pressed("right")):
		direction.x = 1
	if(Input.is_action_pressed("left")):
		direction.x = -1
	if(Input.is_action_pressed("esc")):
		get_tree().quit()
		
	direction = direction.normalized()
	move_and_slide(direction * speed)
	look_at(get_global_mouse_position())
	if(direction != Vector2.ZERO):
		$Ground.emitting = true
		$Ground.gravity.x = direction.x * -150
		$Ground.gravity.y = direction.y * -150
		$Ground.rotation_degrees = self.rotation_degrees * -1
	
	sound_timer += delta
	if (sound_timer > 0.2 and direction != Vector2.ZERO):
		step_sounds[randi()%5].play()
		sound_timer = 0

func _unhandled_input(event):
	if event.is_action_released("shoot"):
		weapon.shoot()
		
func shoot(bullet_instance, location: Vector2, direction: Vector2):
	emit_signal("player_shooted", bullet_instance, location, direction)
	updateUI()
	
func take_damage(count):
	blood.emitting = true
	health = health - count
	if health <= 0:
		get_tree().change_scene("res://menus/GameOver.tscn")
	$AnimationPlayer.play("take_hit")
	hit_sounds[randi()%2].play()
	updateUI()
	
func updateUI():
	health_bar.value = (health/max_health*100)
	ammo_bar.value = weapon.ammo/weapon.max_ammo*100
	$GUI/LevelBar.value = (experience/(100 * (level * 0.5))) * 100
	$GUI/Level.text = String(level)
	print(experience)
	
func handle_ammo_package(var package):
	if(weapon.ammo != weapon.max_ammo):
		package.queue_free()
		weapon.ammo = weapon.max_ammo
		updateUI()

func handle_health_package(var package):
	if(health != max_health):
		package.queue_free()
		health = max_health
		updateUI()

func handle_exp_package(var package):
	gain_exp(15)

func gain_exp(var ex):
	experience += ex
	if(experience >= (100 * (level * 0.5))):
		experience -= (100 * (level * 0.5))
		levelup()
	else:
		$Body/Sprite/exp.play()
	updateUI()

func levelup():
	$Body/Sprite/level_up.play()
	level += 1
	weapon.max_cooldown *= 0.90
	weapon.max_ammo += 10
	weapon.damage *= 1.075
	speed *= 1.05
	get_parent().spawn_rate *= 0.90
	get_parent().zombie_speed *= 1.05

func initBleeding():
	bleeding_timer.wait_time = 5
	bleeding_timer.start()
