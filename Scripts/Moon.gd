extends RigidBody2D

var is_chill = true
var distance_to_earth
var angle

func _on_Moon_body_entered(body:Node):
	if(body.name == "Earth"):
		queue_free()
	pass
	
func _ready():
	distance_to_earth = position.distance_to(Vector2(0, 0))
	angle = position.angle()
	
func escalate():
	is_chill = false

func _physics_process(delta):
	if is_chill:
		angle += delta/10.0
		var vector = Vector2(distance_to_earth, 0).rotated(angle)
		global_transform.origin = vector	
		rotation = global_transform.origin.angle()	
