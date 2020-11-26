extends RigidBody2D
class_name Trash
onready var animationSprite = $"AnimatedSprite"

signal clicked
signal hit_moon

var held = false
var dead = false

var original_pos : Vector2
var collisionCounter = 0

export(PackedScene) var trash_content_scene

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
	if !dead:
		happy(held || collisionCounter == 0)

func explode():
	dead = true
	animationSprite.animation = "explode"
	animationSprite.play()
	collision_mask = 0
	collision_layer = 0
	var force = linear_velocity.length() / 3
	linear_velocity /= 2
	angular_velocity = 0
	animationSprite.connect("animation_finished", self, "on_exploded")
	randomize()
	for i in randi() % 5 + 5:
		var explosion : RigidBody2D = trash_content_scene.instance()
		explosion.position = position
		explosion.rotation = rotation
		explosion.apply_central_impulse(Vector2(
			randf() * force*2 - force, 
			randf() * force*2 - force
		))
		explosion.angular_velocity = randf() * 100 - 50
		get_tree().get_root().call_deferred("add_child", explosion)
	
func on_exploded():
	queue_free()
