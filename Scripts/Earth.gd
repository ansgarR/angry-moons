extends StaticBody2D

var trash = load("res://Scenes/Trash.tscn")
onready var trashGroup = get_node("TrashGroup")

onready var rubberband = $"Rubberband"

var held_trash = null

func _ready():
	randomize()
	
func _on_TrashSpawnTimer_timeout():
	if trashGroup.get_child_count() > 10:
		return
		#pass
	
	var trashInstance : RigidBody2D = trash.instance()
	trashInstance.position = Vector2(0, 200).rotated(deg2rad(randf() * 360.0))
	trashInstance.rotation = deg2rad(randf() * 360.0)
	trashInstance.connect("clicked", self, "_on_Trash_clicked")
	trashGroup.add_child(trashInstance)

func _process(delta):
	if held_trash:
		if held_trash.held:
			rubberband.visible = true
			rubberband.points[0] = held_trash.position
			rubberband.points[1] = held_trash.original_pos
		else:
			held_trash.global_transform.origin = rubberband.points[0]

func _on_Trash_clicked(trash):
	if !held_trash:
		held_trash = trash
		held_trash.pickup()

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if held_trash and !event.pressed:
			held_trash.drop()
			rubberband.shoot()

func _on_Rubberband_shot(rubber_pos : Vector2):
	var force = rubber_pos.distance_to(held_trash.position) * 5
	var direction = (held_trash.position - rubber_pos).normalized()
	held_trash.shoot(direction * min(1000, force))
	held_trash = null
