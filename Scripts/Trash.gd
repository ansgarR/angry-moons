extends RigidBody2D

func _on_Trash_body_entered(body : Node):
	if body.is_in_group("Moons"):
		queue_free()
	pass

#func _input(event):
#	print(event.as_text())

func _on_Trash_input_event(viewport, event, shape_idx):
	print("Houston we have an event")
	if event is InputEventMouseButton:
		print("hitting the müll")
		var force = Vector2(randf() * 100, randf() * 100)
		apply_central_impulse(force)


func _on_Trash_mouse_entered():
	print("mouse entered")
	pass # Replace with function body.
