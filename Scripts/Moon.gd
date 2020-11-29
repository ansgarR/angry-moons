extends RigidBody2D
class_name Moon

onready var gui = $"../../GUI"
onready var animationSprite = $"AnimatedSprite"
onready var moon_sound_fx = $"../../LunarSoundFx"
onready var trash_group = $"../../TrashGroup"
onready var retry_button = $"../../GUI/RetryButton"
var earth_crash_sound = load("res://Assets/SoundFx/mond auf erde.wav")
var trash_hit_sound = load("res://Assets/SoundFx/treffer mond 3.wav")
var is_chill = true
var distance_to_earth
var angle
signal crashed_earth
var hit_counter = 0

func _on_Moon_body_entered(body:Node):
	if(body.name == "Earth"):
		print("emmiting crashed earth")
		emit_signal("crashed_earth")
		if gui.soundfx_on:
			moon_sound_fx.set_stream(earth_crash_sound)
			moon_sound_fx.play()
		var trash_children = trash_group.get_children()
		for trash in trash_children:
			add_collision_exception_with(trash)

func _ready():
	retry_button.connect("pressed", self, "_on_retry_button_pressed")
	distance_to_earth = position.distance_to(Vector2(0, 0))
	
	angle = position.angle()
	
func trash_hit():
	if gui.soundfx_on:
		moon_sound_fx.set_stream(trash_hit_sound)
		moon_sound_fx.play()
	if is_chill:
		is_chill = false
		
	hit_counter+=1
	if hit_counter > 30:
		animationSprite.animation = "hit9"
	elif hit_counter > 26:
		animationSprite.animation = "hit8"
	elif hit_counter > 23:
		animationSprite.animation = "hit7"
	elif hit_counter > 17:
		animationSprite.animation = "hit6"
	elif hit_counter > 12:
		animationSprite.animation = "hit5"
	elif hit_counter > 8:
		animationSprite.animation = "hit4"
	elif hit_counter > 6:
		animationSprite.animation = "hit3"
	elif hit_counter > 3:
		animationSprite.animation = "hit2"
	elif hit_counter > 1:
		animationSprite.animation = "hit1"
	else:
		animationSprite.animation = "hit0" 
	
	animationSprite.frame = 0
	animationSprite.play()

func _physics_process(delta):
	if is_chill:
		angle += delta / 10.0
		var vector = Vector2(distance_to_earth, 0).rotated(angle)
		global_transform.origin = vector
		linear_velocity = Vector2(0,0)
	else:
		mass += delta * 0.01
		gravity_scale += delta * 0.01
	rotation = global_transform.origin.angle()

func _on_retry_button_pressed():
	retry_button.set_visible(false)
	queue_free()
