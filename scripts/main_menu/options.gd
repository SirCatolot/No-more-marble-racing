extends Panel

signal back_button_pressed

@export var show_quit_button: bool = false

@onready var options_buttons: HBoxContainer = $OptionsButtons
@onready var back_button: Button = $OptionsButtons/BackButton
@onready var quit_button: Button = $OptionsButtons/QuitButton


func _ready() -> void:
	_update_buttons()
	for n in options_buttons.get_children():
		if n is Button:
			n.pressed.connect(on_options_button_pressed.bind(n))

func _update_buttons():
	back_button.visible = true
	quit_button.visible = show_quit_button
	
	
func on_options_button_pressed(btn: Button):
	match btn:
		back_button:
			self.visible = false
			back_button_pressed.emit()
		quit_button:
			await get_tree().create_timer(0.8).timeout
			get_tree().change_scene_to_file("res://scenes/main_menu/MainMenu.tscn")

			
			
	
