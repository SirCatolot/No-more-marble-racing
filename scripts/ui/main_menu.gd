extends Control

@onready var hover_sfx : AudioStreamPlayer = get_node("HoverSFX")
@onready var click_sfx : AudioStreamPlayer = get_node("ClickSFX")
@onready var start_button : Button = $MenuButtons/StartButton
@onready var quit_button  : Button = $MenuButtons/QuitButton
@onready var menu_music : AudioStreamPlayer = get_node("MainMenuMusic")

func _ready():
	menu_music.volume_db = -30
	menu_music.play()
	menu_music.create_tween().tween_property(menu_music, "volume_db", -12, 1.5)
	
	start_button.pressed.connect(_on_play_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	
	start_button.mouse_entered.connect(on_hover)
	quit_button.mouse_entered.connect(on_hover)
	
	start_button.mouse_exited.connect(on_hover_exit)
	quit_button.mouse_exited.connect(on_hover_exit)

func on_hover():
	await get_tree().create_timer(0.4).timeout
	if hover_sfx:
		hover_sfx.play()	
		
func on_hover_exit():
	if hover_sfx:
		hover_sfx.stop()

func _on_play_pressed():
	if hover_sfx:
		hover_sfx.stop()
	if click_sfx:
		click_sfx.play()
	await get_tree().create_timer(0.8).timeout
	get_tree().change_scene_to_file("res://scenes/game/GreenFields.tscn")
	print("Play Pressed")

func _on_quit_pressed():
	if hover_sfx:
		hover_sfx.stop()
	if click_sfx:
		click_sfx.play()
	await get_tree().create_timer(0.8).timeout
	get_tree().quit()
	print("Quit Pressed")
	
