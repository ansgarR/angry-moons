extends CanvasLayer

onready var score_label = $"Score"
onready var high_score_label = $"HighScore"

onready var moon_group_node = $"../MoonGroup"
onready var trash_group = $"../TrashGroup"

onready var retry_button = $"./RetryButton"

onready var earth_animated_sprite : AnimatedSprite = $"../Earth/EarthAnimatedSprite"

onready var camera2d : Camera2D = $"../CameraNode/Camera2D"

var score = 0
var high_score = 0
var music_on = true
var soundfx_on = true

var savegame = File.new()
var save_path = "user://angrymoons.save"
var save_data

onready var settings_menu_button = $"SettingsMenuButton"
onready var settings_menu_animation : AnimatedSprite = $"SettingsMenuButton/SettingsButtonAnimatedSprite"
var popup : Popup
onready var audio_stream_player = $"../AudioStreamPlayer2D"

func _ready():
	connectEarthAnimationSpriteSignals()
	connectSettingsMenuButtonSignals()
	savegame.open(save_path, File.READ)
	save_data = savegame.get_var()
	savegame.close()
	if save_data:
		high_score = save_data["highscore"]
		music_on = save_data["music_on"]
		soundfx_on = save_data["soundfx_on"]
	else:
		save_data = {"highscore": 0, "music_on": true, "soundfx_on": true}
	set_high_score(high_score)
	change_setting(0, music_on)
	change_setting(1, soundfx_on)
	
func _process(delta):
	var trash_children = trash_group.get_children()
	for trash in trash_children:
		if trash.get_signal_connection_list("hit_moon").size() == 0:
			trash.connect("hit_moon", self, "_on_hit_moon")
	var moon_group_children = moon_group_node.get_children()
	for moon in moon_group_children:
		if moon.get_signal_connection_list("crashed_earth").size() == 0:
			moon.connect("crashed_earth", self, "_on_crashed_earth")

func _on_crashed_earth():
	set_high_score(max(score, high_score))
	var camera_position : Vector2 = Vector2(0, -200)
	camera2d.set_enable_follow_smoothing(true)
	camera2d.set_position(camera_position)
	camera2d.reset_smoothing()
	earth_animated_sprite.play()
	save_data["highscore"] = high_score
	savegame.open(save_path, File.WRITE)
	savegame.store_var(save_data)
	savegame.close()
	score_label.set_text(str(high_score))
	set_score(0)

func _on_hit_moon():
	set_score(score + 1)
	
func set_score(new : int):
	score = new
	score_label.set_text(str(new))
	
func set_high_score(new : int):
	high_score = new
	high_score_label.set_text("Highscore     " + str(new))

func change_setting(id, checked):
	if id == 0:
		if checked and !audio_stream_player.playing:
			audio_stream_player.play()
		if !checked and audio_stream_player.playing:
			audio_stream_player.stop()
		save_data["music_on"] = checked
		music_on = checked
	if id == 1:
		soundfx_on = checked
		save_data["soundfx_on"] = checked
	savegame.open(save_path, File.WRITE)
	savegame.store_var(save_data)
	savegame.close()
	popup.set_item_checked(id, checked)

func _on_item_pressed(ID):
	var item_checked = popup.is_item_checked(ID)
	change_setting(ID, !item_checked)

func connectSettingsMenuButtonSignals():
	settings_menu_button.connect("about_to_show", self, "_on_settings_button_about_to_show")
	settings_menu_button.set_button_icon(settings_menu_animation)
	popup = settings_menu_button.get_popup()
	popup.connect("popup_hide", self, "_on_popup_hide")
	popup.connect("id_pressed", self, "_on_item_pressed")

func _on_popup_hide():
	settings_menu_animation.play("0" ,true)

func _on_settings_button_about_to_show():
	settings_menu_animation.play()

func connectEarthAnimationSpriteSignals():
	earth_animated_sprite.connect("animation_finished", self, "_on_earth_animation_finished")

func _on_earth_animation_finished():
	retry_button.set_visible(true)
