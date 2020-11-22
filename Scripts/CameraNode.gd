extends Node2D

const rot_speed = 150
var drag_camera
var wanted_degrees = rotation_degrees

onready var earth = $"../Earth"

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP:
				wanted_degrees -= rot_speed * 0.1 * event.factor
			if event.button_index == BUTTON_WHEEL_DOWN:
				wanted_degrees += rot_speed * 0.1 * event.factor
				
		if event.button_index == BUTTON_LEFT:
			drag_camera = event.is_pressed()
	if event is InputEventMouseMotion:
		if drag_camera and !earth.held_trash:
			var speed = event.relative.x
			wanted_degrees -= speed / 4
			
func _process(delta):
	if Input.is_action_pressed("left"):
		wanted_degrees -= rot_speed * delta
	elif Input.is_action_pressed("right"):
		wanted_degrees += rot_speed * delta
	
	rotation_degrees = move_toward(rotation_degrees, wanted_degrees, delta*400)
