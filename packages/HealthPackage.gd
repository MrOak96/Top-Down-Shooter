extends Area2D
class_name HealthPackage
	
func _on_package_body_entered(body):
	if body.has_method("handle_health_package"):
		body.handle_health_package(self)
		
func _physics_process(delta):
	rotation += delta * 0.75
