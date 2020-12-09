extends Node2D
class_name PackageSpawner

onready var ammo_package = preload("res://packages/AmmoPackage.tscn")
onready var health_package = preload("res://packages/HealthPackage.tscn")
onready var timer = 0
onready var pos = $position
var package

func _process(delta):
	if(package == null):
		if(timer <= 0):
			spawnPackage()
			timer = randi()%30 + 30
		else:
			timer -= delta

func _ready():
	pass

func spawnPackage():
	var instance
	if(randi()%9 > 3):
		instance = ammo_package.instance()
	else:
		instance = health_package.instance()
	package = instance
	instance.global_position = pos.global_position
	get_parent().add_child(instance)
	
