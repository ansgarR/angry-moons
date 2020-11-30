extends AudioStreamPlayer2D

onready var gui = $"../GUI"
onready var intro_group = $"../GUI/IntroGroup"
var intro_music = load("res://Assets/Music/Music Intro gebrabbel.ogg")
var game_music = load("res://Assets/Music/Music Gameplay.ogg")

func _ready():
	intro_group.connect("intro_ended", self, "on_intro_ended")
	set_stream(intro_music)
	play()

func on_intro_ended():
	if game_music != get_stream():
		set_stream(game_music)
		play()
