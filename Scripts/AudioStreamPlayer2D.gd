extends AudioStreamPlayer2D

onready var intro_group = $"../GUI/IntroGroup"
var intro_music = load("res://Assets/Music/Music Intro.wav")
var game_music = load("res://Assets/Music/Music Gameplay.wav")

func _ready():
	intro_group.connect("intro_ended", self, "on_intro_ended")
	set_stream(intro_music)

func on_intro_ended():
	print("caught intro end signal") #this control needs to be optimized
	if game_music != get_stream():
		set_stream(game_music)
		play()
