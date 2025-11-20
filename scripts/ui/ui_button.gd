extends Button

func _ready():
	mouse_entered.connect(UI_Buttons_SFX.play_hover)
	pressed.connect(UI_Buttons_SFX.play_click)
	mouse_exited.connect(UI_Buttons_SFX.stop_play_hover)
	
