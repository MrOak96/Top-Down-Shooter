extends Node2D

signal weapon_triggered(bullet, position, direction)

const Bullet = preload("res://weapons/Bullet.tscn")

onready var gun = $Gun
onready var gunEnd = $GunEnd
onready var attack_cooldown = $AttackCooldown
onready var animation_player_shoot = $AnimationPlayer
var max_ammo = 50.0
var ammo = max_ammo
var damage = 20.0
var max_cooldown = 0.5
var cooldown = max_cooldown

func _process(delta):
	if(cooldown > 0):
		cooldown -= delta
	if(cooldown < 0):
		cooldown = 0

func shoot():
	if cooldown == 0 and Bullet != null and ammo > 0:
		$Sprite/shoot.play()
		ammo = ammo - 1
		var bullet_instance = Bullet.instance()
		var direction = (gunEnd.global_position - gun.global_position).normalized()
		emit_signal("weapon_triggered", bullet_instance, gun.global_position, direction)
		animation_player_shoot.play("muzzle_flash")
		cooldown = max_cooldown

func setCooldown(cooldown: float):
	max_cooldown = cooldown
	
func setDamage(damage: float):
	self.damage = damage
