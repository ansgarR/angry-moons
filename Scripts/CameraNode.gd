extends Node2D
class_name CameraNode

const rot_speed = 150
var want_drag = false
var camera_drag = 0.0
var wanted_degrees = rotation_degrees
var wanted_y
var originalSize : Vector2
var focus_earth = false

onready var rubberband = $"../Rubberband"
onready var camera = $"Camera2D"
onready var earth_animated_sprite : AnimatedSprite = $"../Earth/EarthAnimatedSprite"

func _ready():
	get_tree().get_root().connect("size_changed", self, "onResize")
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
			want_drag = event.is_pressed()
	if event is InputEventMouseMotion:
		if camera_drag > 0.05 and !rubberband.held_trash:
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
	
	var w = normDegree(wanted_degrees)
	var c = normDegree(rotation_degrees)
	if (w - c) > 180:
		#print("a ",c, ", ", w)
		w -= 360.0
	elif (w - c) < -180:
		#print("b ", c, ", ", w)
		c -= 360.0
	
	rotation_degrees = normDegree(move_toward(c, w, delta * 400))
	#if(move_toward(normDegree(rotation_degrees), w, delta * 400) - rotation_degrees > 0.000000001):
	#	print(rotation_degrees, ", ",w)
	
	var calc_wanted_y = -wanted_y*2 + zoom*wanted_y
	var curr_y = camera.position.y
	camera.position.y = move_toward(curr_y, calc_wanted_y, max(abs(calc_wanted_y-curr_y),10)*delta*10)
	
	if want_drag:
		camera_drag += delta
	else:
		camera_drag = 0
	
func normDegree(angle : float) -> float:
	var normalized = fmod(angle, 360.0);
	if normalized < 0:
		normalized += 360;
	return normalized;

func focusEarth(moon : Moon):
	focus_earth = true
	want_drag = false
	wanted_y = 200
	wanted_degrees = moon.rotation_degrees + 90
	
	earth_animated_sprite.visible = true
	earth_animated_sprite.rotation_degrees = moon.rotation_degrees + 90
	earth_animated_sprite.play()
	
func focusMoon():
	focus_earth = false
	wanted_y = 400
	
	earth_animated_sprite.visible = false
	
