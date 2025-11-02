extends CanvasLayer

@onready var money_label: Label = $HUD/MoneyLabel
@onready var lives_label: Label = $HUD/LivesLabel
@onready var round_label: Label = $HUD/RoundLabel
@onready var game_over_layer: Control = $GameOver

func _ready() -> void:
	GameState.money_changed.connect(_on_money_changed)
	GameState.lives_changed.connect(_on_lives_changed)
	GameState.round_changed.connect(_on_round_changed)
	GameState.game_over.connect(_on_game_over)
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
