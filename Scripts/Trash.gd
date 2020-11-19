extends RigidBody2D

func _on_Trash_body_entered(body : Node):
	if body.is_in_group("Moons"):
		queue_free()
	pass
