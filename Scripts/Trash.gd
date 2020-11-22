extends RigidBody2D
class_name Trash
onready var animationSprite = $"AnimatedSprite"

export(PackedScene) var explosion_scene

signal clicked
signal hit_moon

var held = false
var original_pos : Vector2
var collisionCounter = 0

func _on_Trash_body_entered(body):
	collisionCounter += 1
	if body is Moon:
		emit_signal("hit_moon")
		explode()
		body.trash_hit()
	pass

func _on_Trash_body_exited(body):
	collisionCounter -= 1

func _on_MouseArea_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.is_pressed():
				emit_signal("clicked", self)

func pickup():
	happy(true)
	original_pos = position
	held = true
	mode = MODE_STATIC
	z_index = 5
	collision_layer = 0

func happy(happy : bool):
	if(happy): animationSprite.animation = "happy"
	else: animationSprite.animation = "default"
	animationSprite.play()

func drop():
	held = false
	collision_layer = 1

func shoot(impulse : Vector2):
	mode = MODE_RIGID
	apply_central_impulse(impulse)
	happy(true)

func _process(delta):
	happy(held || collisionCounter == 0)

func explode():
	queue_free()
	var explosion : AnimatedSprite = explosion_scene.instance()
	explosion.position = position
	explosion.rotation = rotation
	explosion.play()
	get_parent().add_child(explosion)
		
