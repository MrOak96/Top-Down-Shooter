extends Node2D
class_name Main

onready var nav_2d: Navigation2D = $Navigation2D
onready var bullet_manager = $BulletManager
onready var player: Player = $Player
onready var timer = 0
onready var spawn_rate = 5.0
onready var zombie_speed = 1

onready var enemies = []
onready var spawn_locations = []

const Enemy = preload("res://actors/Enemy.tscn")
const HealthPackage = preload("res://packages/HealthPackage.tscn")
const AmmoPackage = preload("res://packages/AmmoPackage.tscn")

func _ready():
	player.connect("player_shooted", bullet_manager, "handle_bullet_spawned")
	spawn_locations.append($spawns/spawn1)
	spawn_locations.append($spawns/spawn2)
	spawn_locations.append($spawns/spawn3)
	spawn_locations.append($spawns/spawn4)
	
func spawn_enemy(enemy: Enemy):
	add_child(enemy)
	enemy.global_position = spawn_locations[randi()%3].global_position
	enemies.append(enemy)

func _process(delta):
	timer += delta
	if timer >= spawn_rate:
		var enemy_instance = Enemy.instance()
		enemy_instance.speed = zombie_speed
		spawn_enemy(enemy_instance)
		timer = 0
	
func spawn_health_package(pos: Vector2):
		var package = HealthPackage.instance()
		add_child(package)
		package.global_position.x = pos.x
		package.global_position.y = pos.y
		
func spawn_ammo_package(pos: Vector2):
		var package = AmmoPackage.instance()
		add_child(package)
		package.global_position.x = pos.x
		package.global_position.y = pos.y
