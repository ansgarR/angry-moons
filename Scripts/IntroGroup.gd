extends Control

onready var animation : AnimatedSprite = $"Animation"
onready var timer : Timer = $"Timer"
onready var skip_button = $"../SkipButton"
onready var startDelay : Timer = $"StartDelay"
var introData : Dictionary
var fade = false

signal intro_started
signal intro_ended

func _ready():
	skip_button.connect("pressed", self, "_on_skip_button_pressed")
	var file = File.new()
	file.open("res://Assets/Intro.json", file.READ)
	var text = file.get_as_text()
	file.close()
	introData = JSON.parse(text).result
	
	startDelay.start()


func _on_Timer_timeout():
	if(animation.frame == 135):
		_on_skip_button_pressed()
	animation.frame += 1
	var frameData = introData["frames"]["Intro " + str(animation.frame) + ".aseprite"]
	timer.wait_time = frameData["duration"] / 1100.0
	timer.start()

func _process(delta):
	if fade:
		modulate.a -= delta

func _on_skip_button_pressed():
	if !fade:
		fade = true
		emit_signal("intro_ended")
		skip_button.queue_free()

func _on_StartDelay_timeout():
	if !fade:
		timer.start()
		emit_signal("intro_started")
