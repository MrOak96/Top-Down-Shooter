extends Node2D
class_name Main

var pathfinding_demo = false

onready var nav_2d: Navigation2D = $Navigation2D
onready var bullet_manager = $BulletManager
onready var player: Player = $Player
onready var timer = 0
onready var spawn_rate = 3.0
onready var zombie_speed = 2
onready var line: Line2D = $Line2D
onready var zombie_spawns = []
onready var package_spawns = []
onready var packages = []

const Enemy = preload("res://actors/Enemy.tscn")
const HealthPackage = preload("res://packages/HealthPackage.tscn")
const AmmoPackage = preload("res://packages/AmmoPackage.tscn")
const Exp = preload("res://packages/Exp.tscn")

func _ready():
	player.connect("player_shooted", bullet_manager, "handle_bullet_spawned")
	zombie_spawns.append($zombie_spawns/spawn1)
	zombie_spawns.append($zombie_spawns/spawn2)
	zombie_spawns.append($zombie_spawns/spawn3)
	zombie_spawns.append($zombie_spawns/spawn4)
	zombie_spawns.append($zombie_spawns/spawn5)
	zombie_spawns.append($zombie_spawns/spawn6)
	zombie_spawns.append($zombie_spawns/spawn7)
	zombie_spawns.append($zombie_spawns/spawn8)
	package_spawns.append($package_spawns/spawn1)
	package_spawns.append($package_spawns/spawn2)
	package_spawns.append($package_spawns/spawn3)
	package_spawns.append($package_spawns/spawn4)
	if(pathfinding_demo):
		var enemy_instance = Enemy.instance()
		enemy_instance.speed = zombie_speed
		spawn_enemy(enemy_instance)
	
func spawn_enemy(enemy: Enemy):
	add_child(enemy)
	var pos
	var ran = randi()%8
	for i in range(8):
		var index = i + ran
		if(index > 7):
			index -= 8
		var distance = (zombie_spawns[index].global_position - player.global_position).length()
		if(distance > 1000):
			pos = zombie_spawns[index].global_position
			break
	enemy.global_position = pos

func _process(delta):
	if(!pathfinding_demo):
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

func spawn_exp(pos: Vector2):
		var package = Exp.instance()
		add_child(package)
		package.global_position.x = pos.x
		package.global_position.y = pos.y
