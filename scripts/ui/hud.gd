extends CanvasLayer

@onready var money_label: Label = $HUD/MoneyLabel
@onready var lives_label: Label = $HUD/LivesLabel
@onready var round_label: Label = $HUD/RoundLabel
@onready var game_over_layer: Control = $GameOver
@onready var play_button: Button = $Panel/NextRoundButton

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

func _on_money_changed(m: int) -> void:
	money_label.text = "Money: %d" % m

func _on_lives_changed(l: int) -> void:
	lives_label.text = "Lives: %d" % l

func _on_round_changed(r: int) -> void:
	round_label.text = "Round: %d" % r

func _on_game_over() -> void:
	game_over_layer.visible = true

func _on_play_button_pressed() -> void:
	if spawner != null:
		spawner.start_next_round()
	play_button.disabled = true

func _on_round_started(_r: int) -> void:
	play_button.disabled = true

func _on_round_finished(_r: int) -> void:
	play_button.disabled = false
