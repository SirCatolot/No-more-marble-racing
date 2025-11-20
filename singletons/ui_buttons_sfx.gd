extends Node

@onready var hover_sfx: AudioStreamPlayer = AudioStreamPlayer.new()
@onready var click_sfx: AudioStreamPlayer = AudioStreamPlayer.new()

func _ready():
	add_child(hover_sfx)
	add_child(click_sfx)
	hover_sfx.stream = preload("res://assets/audio/ball-in-hole-99750.mp3")
	click_sfx.stream = preload("res://assets/audio/marble-83124.mp3")

func play_hover():
	if not hover_sfx.playing:
		hover_sfx.play()
		
func stop_play_hover():
	if hover_sfx.playing:
		hover_sfx.stop()

func play_click():
	if not click_sfx.playing:
		click_sfx.play()
