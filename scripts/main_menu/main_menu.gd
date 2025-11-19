extends Control

@onready var hover_sfx : AudioStreamPlayer = get_node("HoverSFX")
@onready var click_sfx : AudioStreamPlayer = get_node("ClickSFX")
@onready var menu_buttons: VBoxContainer = $MenuButtons
@onready var start_button : Button = $MenuButtons/StartButton
@onready var options_button : Button = $MenuButtons/OptionsButton
@onready var quit_button  : Button = $MenuButtons/QuitButton
@onready var menu_music : AudioStreamPlayer = get_node("MainMenuMusic")
@onready var options_panel: Panel = $Options
@onready var options_title: Label = $Options/OptionsTitle
@onready var back_button: Button = $Options/BackButton

	

func _ready():
	print("Main Menu Script running on: ", get_path())
	print("Children: ", get_children())
	
	if not menu_music.playing:
		menu_music.play()
		menu_music.create_tween().tween_property(menu_music, "volume_db", -12, 1.5)
	
	menu_buttons.visible = true
	options_panel.visible = false 
	
	for n in menu_buttons.get_children():
		if n is Button:
			n.mouse_entered.connect(on_button_hover)
			n.mouse_exited.connect(on_button_hover_exit)
			n.pressed.connect(on_menu_button_pressed.bind(n))
			
	for n in options_panel.get_children():
		if n is Button:
			n.mouse_entered.connect(on_button_hover.bind())
			n.mouse_exited.connect(on_button_hover_exit)
			n.pressed.connect(on_options_button_pressed.bind(n))

func on_button_hover():
	if not hover_sfx.playing:
		hover_sfx.play()	
func on_button_hover_exit():
	if hover_sfx.playing:
		hover_sfx.stop()
		
func on_menu_button_pressed(btn: Button):
	if not click_sfx.playing:
		click_sfx.play()	
	match btn:
		start_button:
			await get_tree().create_timer(0.8).timeout
			get_tree().change_scene_to_file("res://scenes/levels/GreenFields.tscn")
			print("Play Pressed")
		options_button:
			menu_buttons.visible = false
			options_panel.visible = true
			print("Options Pressed")
		quit_button:
			await get_tree().create_timer(0.8).timeout
			get_tree().quit()
			print("Quit Pressed")
			

func on_options_button_pressed(btn: Button):
	if not click_sfx:
		click_sfx.play()
	match btn:
		back_button:
			_ready()
			
