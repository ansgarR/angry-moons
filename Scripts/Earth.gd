extends StaticBody2D

var trash = load("res://Scenes/Trash.tscn")
onready var trashGroup = get_node("TrashGroup")


func _on_TrashSpawnTimer_timeout():
	if trashGroup.get_child_count() > 10:
		return
		#pass
	
	var pos = Vector2(0,300).rotated(deg2rad(randf() * 360.0))
	
	var trashInstance : RigidBody2D = trash.instance()
	trashInstance.position = pos
	trashGroup.add_child(trashInstance)
