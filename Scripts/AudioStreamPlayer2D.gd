extends AudioStreamPlayer2D

onready var settings_menu_button = $"../GUI/SettingsMenuButton"

func _ready():
	settings_menu_button.connect("setting_change", self , "on_setting_change")

func on_setting_change(id, value):
	if id == 0:
		if value == true and !playing:
			play()
		if value == false and playing:
			stop()
