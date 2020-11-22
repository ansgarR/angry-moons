extends Node

export(PackedScene) var moon_scene
onready var main_scene = $".."

func _process(delta):
	if get_child_count() == 0:
		var moon : RigidBody2D = moon_scene.instance()
		moon.position = Vector2(0, -600)
		add_child(moon)
