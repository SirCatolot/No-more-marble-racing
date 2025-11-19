extends Node

signal money_changed(money)
signal lives_changed(lives)
signal round_changed
signal game_over

var money: int = 0
var lives: int = 0
var current_round: int = 1

const START_MONEY := 100
const START_LIVES := 20

func _ready() -> void:
	reset()

func reset() -> void:
	money = START_MONEY
	lives = START_LIVES
	emit_signal("money_changed", money)
	emit_signal("lives_changed", lives)
	emit_signal("round_changed", current_round)
	get_tree().paused = false

func add_money(amount: int) -> void:
	money += amount
	emit_signal("money_changed", money)

func can_afford(cost: int) -> bool:
	return money >= cost

func try_spend(cost: int) -> bool:
	if money >= cost:
		money -= cost
		emit_signal("money_changed", money)
		return true
	return false

func lose_life(amount: int = 1) -> void:
	lives -= amount
	emit_signal("lives_changed", lives)
	if lives <= 0:
		emit_signal("game_over")
		get_tree().paused = true
		
func set_round(r: int) -> void:
	current_round = r
	emit_signal("round_changed", r)
