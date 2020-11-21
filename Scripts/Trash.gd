extends RigidBody2D

signal clicked

var held = false
var original_pos : Vector2

func _on_Trash_body_entered(body : Node):
	if body.is_in_group("Moon"):
		queue_free()
		body.escalate()
	pass

func _on_Trash_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.is_pressed():
				emit_signal("clicked", self)

func pickup():
	original_pos = position
	held = true
	mode = MODE_STATIC
	z_index = 5
	collision_layer = 0

func drop():
	held = false
	collision_layer = 1

func shoot(impulse : Vector2):
	mode = MODE_RIGID
	apply_central_impulse(impulse)

func _physics_process(delta):
	if held:
		global_transform.origin = get_global_mouse_position()
