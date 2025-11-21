extends Panel

signal back_button_pressed

@onready var back_button: Button = $BackButton
@onready var green_fields_button: Button = $LevelsBox/GreenFieldsLevelBox/GreenFieldsStartButton
@onready var nostalgia_button: Button = $LevelsBox/NostalgiaLevelBox/NostalgiaStartButton
@onready var levels_box: HBoxContainer = $LevelsBox
@onready var third_level_button: Button = $LevelsBox/ThirdLevelBox/ThirdLevelStartButton 

func _ready() -> void:
	green_fields_button.pressed.connect(on_level_select_button_pressed.bind(green_fields_button))
	back_button.pressed.connect(on_level_select_button_pressed.bind(back_button))
	nostalgia_button.pressed.connect(on_level_select_button_pressed.bind(nostalgia_button))
	third_level_button.pressed.connect(on_level_select_button_pressed.bind(third_level_button))
	
	
func on_level_select_button_pressed(btn: Button):
	match btn:
		back_button:
			self.visible = false
			print("Back to Main Menu Pressed")
			back_button_pressed.emit()
		green_fields_button:
			await get_tree().create_timer(0.8).timeout
			print("Green Fields Selected")
			get_tree().change_scene_to_file("res://scenes/levels/GreenFields.tscn")
		nostalgia_button:
			await get_tree().create_timer(0.8).timeout
			print("Nostalgia Selected")
			get_tree().change_scene_to_file("res://scenes/levels/Nostalgia.tscn")
		third_level_button:
			await get_tree().create_timer(0.8).timeout
			print("Third Level Selected")
