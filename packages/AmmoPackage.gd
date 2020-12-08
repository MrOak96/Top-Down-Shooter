extends Area2D
class_name AmmoPackage
	
func _on_package_body_entered(body):
	if body.has_method("handle_ammo_package"):
		body.handle_ammo_package(self)

func _physics_process(delta):
	rotation += delta * 0.75
