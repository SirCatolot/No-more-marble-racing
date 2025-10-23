extends Control

func _ready():
	$VBoxContainer/PlayButton.pressed.connect(_on_play_pressed)
	$VBoxContainer/QuitButton.pressed.connect(_on_quit_pressed)
	
func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/game/main.tscn")
	print("Play Pressed")

func _on_quit_pressed():
	get_tree().quit()
