extends CanvasLayer

@onready var money_label: Label = $TopPanel/HUD/MoneyPanel/MoneyContainer/MoneyLabel
@onready var lives_label: Label = $TopPanel/HUD/LivesPanel/LivesContainer/LivesLabel
@onready var round_label: Label = $TopPanel/HUD/RoundPanel/RoundLabel
@onready var game_over_layer: Control = $GameOver
@onready var play_button: Button = $RightPanel/NextRoundButton
@onready var options_button: Button = $TopPanel/HUD/OptionsButton
@onready var options_panel: Panel = $Options

@onready var victory_panel: Panel = $VictoryPanel
@onready var main_menu_button: Button = $VictoryPanel/VBoxContainer/HBoxContainer/MainMenuButton
@onready var continue_button: Button = $VictoryPanel/VBoxContainer/HBoxContainer/ContinueButton

var UpgradePanelScene = preload("res://scenes/ui/UpgradePanel.tscn")
var upgrade_panel

var spawner: Node = null

func _ready() -> void:
	GameState.money_changed.connect(_on_money_changed)
	GameState.lives_changed.connect(_on_lives_changed)
	GameState.round_changed.connect(_on_round_changed)
	GameState.game_over.connect(_on_game_over)
	GameState.tower_selected.connect(_on_tower_selected)
	
	upgrade_panel = UpgradePanelScene.instantiate()
	add_child(upgrade_panel)
	
	# Hook up round signals
	spawner = get_tree().get_first_node_in_group("path_spawner")
	if spawner != null:
		spawner.round_started.connect(_on_round_started)
		spawner.round_finished.connect(_on_round_finished)
	
	# Wire Play button
	play_button.pressed.connect(_on_play_button_pressed)
	play_button.disabled = false
	_on_money_changed(GameState.money)
	_on_lives_changed(GameState.lives)
	_on_round_changed(GameState.current_round)
	
	options_panel.visible = false
	options_panel.show_quit_button = true
	options_panel._update_buttons()
	options_button.pressed.connect(_on_options_button_pressed)
	
	# Wire Victory buttons
	main_menu_button.pressed.connect(_on_main_menu_pressed)
	continue_button.pressed.connect(_on_continue_pressed)

func _on_money_changed(m: int) -> void:
	money_label.text = "%d" % m

func _on_lives_changed(l: int) -> void:
	lives_label.text = "%d" % l

func _on_round_changed(r: int) -> void:
	round_label.text = "Round: %d" % r

func _on_game_over() -> void:
	game_over_layer.visible = true

func _on_play_button_pressed() -> void:
	if spawner != null:
		spawner.start_next_round()
	play_button.disabled = true
	
func _on_options_button_pressed():
	options_panel.visible = true
	

func _on_round_started(_r: int) -> void:
	play_button.disabled = true

func _on_round_finished(_r: int) -> void:
	if _r == 4:
		victory_panel.visible = true
		# Keep play button disabled while victory screen is up
	else:
		play_button.disabled = false

func _on_tower_selected(tower):
	upgrade_panel.set_tower(tower)

func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/ui/MainMenu.tscn")

func _on_continue_pressed():
	victory_panel.visible = false
	play_button.disabled = false
