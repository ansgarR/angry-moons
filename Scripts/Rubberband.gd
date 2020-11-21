extends Line2D

signal shot(pos) 

var move_back = false
var deformed_pos : Vector2

func shoot():
	deformed_pos = points[0]
	move_back = true

func _process(delta):
	if move_back:
		var point1 : Vector2 = points[0]
		var point2 : Vector2 = points[1]
		points[0] = point1.move_toward(point2, delta * 3000)
		if points[0].distance_to(point2) <= 0:
			emit_signal("shot", deformed_pos)
			visible = false
			move_back = false
