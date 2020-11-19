extends RigidBody2D

func _on_Moon_body_entered(body:Node):
	if(body.name == "Earth"):
		queue_free()
	pass
