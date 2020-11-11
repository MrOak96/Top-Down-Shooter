extends KinematicBody2D

signal player_shooted(bullet, position, direction)

export (PackedScene) var Bullet
export (int) var speed = 100

var health: int = 100

onready var gun = $Gun
onready var gunEnd = $GunEnd
onready var attack_cooldown = $AttackCooldown
onready var animation_player_shoot = $AnimationPlayer

func _ready():
	pass # Replace with function body.
	
func _process(delta):
	var direction := Vector2.ZERO
	
	if(Input.is_action_pressed("up")):
		direction.y = -1
	if(Input.is_action_pressed("down")):
		direction.y = 1
	if(Input.is_action_pressed("right")):
		direction.x = 1
	if(Input.is_action_pressed("left")):
		direction.x = -1
		
	direction = direction.normalized()
	move_and_slide(direction * speed)
	look_at(get_global_mouse_position())

func _unhandled_input(event):
	if event.is_action_released("shoot"):
		shoot()
		
func shoot():
	if attack_cooldown.is_stopped():
		var bullet_instance = Bullet.instance()
		var direction = (gunEnd.global_position - gun.global_position).normalized()
		emit_signal("player_shooted", bullet_instance, gun.global_position, direction)
		attack_cooldown.start()
		animation_player_shoot.play("muzzle_flash")
