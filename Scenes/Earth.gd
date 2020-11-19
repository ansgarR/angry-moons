extends StaticBody2D

var trash = load("res://Scenes/Müll.tscn")
onready var trashGroup = get_node("TrashGroup")


func _on_TrashSpawnTimer_timeout():
	print("yolo")
	if trashGroup.get_child_count() < 10:
		print("yolo")
		var trashInstance = trash.instance()
		#var trashSpawnVector = Vector2(0, -600)
		trashInstance.x = 0
		trashInstance.x = -600
		#trashInstance.set_pos(trashSpawnVector)
		add_child(trashInstance)
