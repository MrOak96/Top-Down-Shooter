extends Area2D
class_name Exp

var direction: Vector2 = Vector2.ZERO	
	
onready var player: Player = get_node("/root/Main/Player")

func _physics_process(delta):
	rotation += delta * 0.75
	direction = (player.global_position - self.global_position)
	$Effect.emission_sphere_radius = direction.length()/15
	position = position + (direction.normalized() * 10)

func _on_Exp_body_entered(body):
	if body.has_method("handle_exp_package"):
		body.handle_exp_package(self)
		queue_free()
