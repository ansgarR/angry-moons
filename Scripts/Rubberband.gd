extends Line2D

const MAX_FORCE = 150.0

onready var gui = $"../GUI"
var rubberband_sound = load("res://Assets/SoundFx/ziehen1.wav")
var shoot_trash_sound = load("res://Assets/SoundFx/sack stimme beim abflug.wav")
var shoot_trash_sound_2 = load("res://Assets/SoundFx/sack stimme beim abflug 2.wav") # yet unused
onready var rubberband_sound_fx = $"../RubberbandSoundFX"
onready var trash_sound_fx = $"../TrashSoundFx" #lol xXx

var deformed_pos : Vector2
var held_trash : Trash = null
var rubber_width = 0

func pickup(trash:Trash):
	if !held_trash:
		if gui.soundfx_on:
			rubberband_sound_fx.set_stream(rubberband_sound)
			rubberband_sound_fx.play()
		position = trash.position
		held_trash = trash
		rubber_width = 0
		held_trash.pickup()

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if held_trash and !event.pressed:
			if gui.soundfx_on:
				trash_sound_fx.set_stream(shoot_trash_sound)
				trash_sound_fx.play()
			held_trash.drop()
			deformed_pos = points[1]

func _physics_process(delta):
	rubber_width = move_toward(rubber_width, 30, delta * 200)
	if held_trash:
		if held_trash.held:
			var mousePos = get_global_mouse_position()
			var pullForce = min(mousePos.distance_to(position), MAX_FORCE)
			var pullDirection = (mousePos - position).normalized()
			var trashPos = pullDirection * pullForce
			default_color = Color(pullForce / MAX_FORCE / 2, 0.1, 0.1, 0.8)
	
			rotation = pullDirection.angle()
			held_trash.global_transform.origin = trashPos + held_trash.original_pos
			visible = true
			points[0] = Vector2(0, -rubber_width)
			points[1] = Vector2(pullForce + 8, 0)
			points[2] = Vector2(0, +rubber_width)
		else:
			points[1] = points[1].move_toward(Vector2.ZERO, delta*1000)
			if points[1].distance_to(Vector2.ZERO) <= 0:
				var force = deformed_pos.distance_to(Vector2.ZERO) * 5
				var direction = deformed_pos.rotated(rotation - PI).normalized()
				held_trash.shoot(direction * min(1000, force))
				held_trash = null
			else:
				held_trash.global_transform.origin = position + points[1].rotated(rotation)
	else:
		visible = false
