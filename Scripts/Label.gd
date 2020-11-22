extends Label

onready var moon_group_node = get_tree().get_root().find_node("****Moon*****", true, false)
onready var trash_group = get_tree().get_root().find_node("****Trash*****", true, false)

func _ready():
	pass

func _process(delta):
	var trash_children = trash_group.get_children()
	for trash in trash_children:
		if trash.get_signal_connection_list("hit_moon").size() == 0:
			trash.connect("hit_moon", self, "_on_hit_moon")
	if moon_group_node.get_child_count() > 0:
		var child_moon = moon_group_node.get_child(0)	
		if child_moon.get_signal_connection_list("crashed_earth").size() == 0:
			child_moon.connect("crashed_earth", self, "_on_crashed_earth")

func _on_crashed_earth():
	self.set_text(str(0))

func _on_hit_moon():
	var val=int(self.get_text())
	self.set_text(str(val+1))
