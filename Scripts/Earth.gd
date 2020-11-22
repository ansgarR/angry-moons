extends StaticBody2D

var trash = load("res://Scenes/Trash.tscn")
onready var trashGroup = get_node("TrashGroup")

onready var rubberband = $"Rubberband"

var held_trash : Trash = null

const TRASH_LIMIT = 15

func _ready():
	randomize()
	for i in range(TRASH_LIMIT):
		spawnTrash()
	
func _on_TrashSpawnTimer_timeout():
	spawnTrash()
	
func spawnTrash():
	if trashGroup.get_child_count() > TRASH_LIMIT:
		return
	
	var trashInstance : RigidBody2D = trash.instance()
	trashInstance.position = Vector2(0, 200).rotated(deg2rad(randf() * 360.0))
	trashInstance.rotation = deg2rad(randf() * 360.0)
	trashInstance.connect("clicked", self, "_on_Trash_clicked")
	trashGroup.add_child(trashInstance)

func _physics_process(delta):
	if held_trash:
		if held_trash.held:
			var mousePos = get_global_mouse_position()
			var pullForce = min(mousePos.distance_to(held_trash.original_pos), 100)
			var pullDirection = (mousePos - held_trash.original_pos).normalized()
			var trashPos = pullDirection * pullForce + held_trash.original_pos
			
			held_trash.global_transform.origin = trashPos
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
