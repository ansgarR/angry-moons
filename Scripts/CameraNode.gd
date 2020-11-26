extends Node2D

const rot_speed = 150
var drag_camera
var wanted_degrees = rotation_degrees
var originalSize : Vector2

onready var rubberband = $"../Rubberband"
onready var camera = $"Camera2D"


func _ready():
	get_tree().get_root().connect("size_changed",self,"onResize")
	originalSize = Vector2(480, 720)
	onResize()

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
		if drag_camera and !rubberband.held_trash:
			var speed = event.relative.x
			wanted_degrees -= speed / 6
			
func _process(delta):
	if Input.is_action_pressed("left"):
		wanted_degrees -= rot_speed * delta
	elif Input.is_action_pressed("right"):
		wanted_degrees += rot_speed * delta
	
	rotation_degrees = move_toward(rotation_degrees, wanted_degrees, delta*400)

func onResize():
	var currentSize = get_viewport_rect().size
	var zoomX = originalSize.x / currentSize.x
	var zoomY = originalSize.y / currentSize.y
	var zoom = max(zoomX, zoomY)
	camera.set_zoom(Vector2(zoom,zoom))
	var cameraOffset = 400;
	camera.position.y = -cameraOffset*2 + zoom*cameraOffset
