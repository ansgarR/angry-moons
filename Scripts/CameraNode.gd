extends Node2D

const rot_speed = 100


func _process(delta):
	if Input.is_action_pressed("left"):
		rotation_degrees -= rot_speed * delta
	elif Input.is_action_pressed("right"):
		rotation_degrees += rot_speed * delta
	pass
