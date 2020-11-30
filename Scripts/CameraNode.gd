extends Node2D
class_name CameraNode

const rot_speed = 150
var drag_camera
var wanted_degrees = rotation_degrees
var wanted_y
var originalSize : Vector2
var focus_earth = false

onready var rubberband = $"../Rubberband"
onready var camera = $"Camera2D"
onready var earth_animated_sprite : AnimatedSprite = $"../Earth/EarthAnimatedSprite"

func _ready():
	get_tree().get_root().connect("size_changed",self,"onResize")
	originalSize = Vector2(480, 720)
	focusMoon()

func _input(event):
	if focus_earth:
		return
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
	
	var currentSize = get_viewport_rect().size
	var zoomX = originalSize.x / currentSize.x
	var zoomY = originalSize.y / currentSize.y
	var zoom = max(zoomX, zoomY)
	camera.set_zoom(Vector2(zoom,zoom))
	
	rotation_degrees = move_toward(rotation_degrees, wanted_degrees, delta*400)
	var calc_wanted_y = -wanted_y*2 + zoom*wanted_y
	var curr_y = camera.position.y
	camera.position.y = move_toward(curr_y, calc_wanted_y, max(abs(calc_wanted_y-curr_y),10)*delta*10)
	
func focusEarth(moon : Moon):
	focus_earth = true
	drag_camera = false
	wanted_y = 200
	wanted_degrees = moon.rotation_degrees + 90
	
	earth_animated_sprite.visible = true
	earth_animated_sprite.rotation_degrees = moon.rotation_degrees + 90
	earth_animated_sprite.play()
	
func focusMoon():
	focus_earth = false
	wanted_y = 400
	
	earth_animated_sprite.visible = false
	
