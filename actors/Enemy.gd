extends KinematicBody2D

export (int) var speed = 100

var health: int = 100

func handle_hit(damage: int):
	health -= damage
	if(health <= 0):
		queue_free()
	
