extends RigidBody2D

onready var animationSprite = $"AnimatedSprite"
var is_chill = true
var distance_to_earth
var angle
signal crashed_earth
var hit_counter = 0

func _on_Moon_body_entered(body:Node):
	if(body.name == "Earth"):
		emit_signal("crashed_earth")
		queue_free()
	pass
	
func _ready():
	distance_to_earth = position.distance_to(Vector2(0, 0))
	angle = position.angle()
	
func trash_hit():
	is_chill = false
	hit_counter+=1
	if hit_counter > 9:
		animationSprite.animation = "hit9"
	elif hit_counter > 8:
		animationSprite.animation = "hit8"
	elif hit_counter > 7:
		animationSprite.animation = "hit7"
	elif hit_counter > 6:
		animationSprite.animation = "hit6"
	elif hit_counter > 5:
		animationSprite.animation = "hit5"
	elif hit_counter > 4:
		animationSprite.animation = "hit4"
	elif hit_counter > 3:
		animationSprite.animation = "hit3"
	elif hit_counter > 2:
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
	rotation = global_transform.origin.angle()
