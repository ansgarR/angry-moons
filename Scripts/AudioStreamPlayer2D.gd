extends AudioStreamPlayer2D

onready var intro_group = $"../GUI/IntroGroup"
var intro_music = load("res://Assets/Music/Music Intro.wav")
var game_music = load("res://Assets/Music/Music Gameplay.wav")

func _ready():
	connect("intro_ended", self, "on_intro_ended")
	set_stream(intro_music)

func on_intro_ended():
	print("caught intro end signal")
	set_stream(game_music)
	play()
