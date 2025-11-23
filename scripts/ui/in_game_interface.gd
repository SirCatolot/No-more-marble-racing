extends CanvasLayer

@onready var money_label: Label = $TopPanel/HUD/MoneyPanel/MoneyContainer/MoneyLabel
@onready var lives_label: Label = $TopPanel/HUD/LivesPanel/LivesContainer/LivesLabel
@onready var round_label: Label = $TopPanel/HUD/RoundPanel/RoundLabel
@onready var game_over_layer: Control = $GameOver
@onready var play_button: Button = $RightPanel/NextRoundButton
@onready var options_button: Button = $TopPanel/HUD/OptionsButton
@onready var options_panel: Panel = $Options

var spawner: Node = null

func _ready() -> void:
	GameState.money_changed.connect(_on_money_changed)
	GameState.lives_changed.connect(_on_lives_changed)
	GameState.round_changed.connect(_on_round_changed)
	GameState.game_over.connect(_on_game_over)
	
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
	play_button.disabled = false
