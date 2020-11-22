extends StaticBody2D

var trash = load("res://Scenes/Trash.tscn")
onready var trashGroup = get_node("TrashGroup")

onready var rubberband = $"Rubberband"

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

func _on_Trash_clicked(trash):
	rubberband.pickup(trash)
