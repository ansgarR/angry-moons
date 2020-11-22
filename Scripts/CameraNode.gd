extends Node2D

const rot_speed = 100
var drag_camera

onready var earth = $"../Earth"

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			drag_camera = event.is_pressed()
	if event is InputEventMouseMotion:
		if drag_camera and !earth.held_trash:
			var speed = event.relative.x
			rotation_degrees -= speed / 4
			
func _process(delta):
	if Input.is_action_pressed("left"):
		rotation_degrees -= rot_speed * delta
	elif Input.is_action_pressed("right"):
		rotation_degrees += rot_speed * delta
	pass
