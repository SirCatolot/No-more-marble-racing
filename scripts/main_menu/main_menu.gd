extends Control

@onready var hover_sfx : AudioStreamPlayer = get_node("HoverSFX")
@onready var click_sfx : AudioStreamPlayer = get_node("ClickSFX")
@onready var menu_buttons: VBoxContainer = $MenuButtons
@onready var start_button : Button = $MenuButtons/StartButton
@onready var options_button : Button = $MenuButtons/OptionsButton
@onready var quit_button  : Button = $MenuButtons/QuitButton
@onready var menu_music : AudioStreamPlayer = get_node("MainMenuMusic")
@onready var options_panel: Panel = $Options

	

func _ready():
	print("Main Menu Script running on: ", get_path())
	print("Children: ", get_children())
	
	if not menu_music.playing:
		menu_music.play()
		menu_music.create_tween().tween_property(menu_music, "volume_db", -12, 1.5)
	
	menu_buttons.visible = true
	options_panel.visible = false
	options_panel.show_quit_button = false
	options_panel._update_buttons()
	options_panel.back_button_pressed.connect(on_options_back_from_main)
	 
	
	for n in menu_buttons.get_children():
		if n is Button:
			n.pressed.connect(on_menu_button_pressed.bind(n))
			
			
func on_menu_button_pressed(btn: Button):
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

func on_options_back_from_main():
	menu_buttons.visible = true
			
