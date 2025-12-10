extends Node2D

signal round_started(round)
signal round_finished(round)

# Preload different enemy path scenes
@onready var MarbleA = preload("res://scenes/marbles/Stage1MarbleA.tscn")
@onready var MarbleB = preload("res://scenes/marbles/Stage1MarbleB.tscn")
@onready var MarbleC = preload("res://scenes/marbles/Stage1MarbleC.tscn")
@onready var MarbleD = preload("res://scenes/marbles/Stage1MarbleD.tscn")
@onready var MarbleE = preload("res://scenes/marbles/Stage1MarbleE.tscn")

# Track current round and how many enemies have spawned
var currentRound = 1
var enemiesSpawned = 0
var enemiesPerRound = 10  # Round 1 now spawns 10 marbles total
var is_round_active = false
var has_started = false

func _ready():
	add_to_group("path_spawner")
	# Ahows the initial round value in UI
	GameState.set_round(currentRound)
	$Timer.stop()

## Spawns a new enemy path instance each time the timer triggers
func _on_timer_timeout():
	var tempPath

	#Pick which enemy type to spawn based on the round
	if currentRound == 1:
		tempPath = MarbleA.instantiate()
	elif currentRound == 2:
		tempPath = MarbleB.instantiate()
	elif currentRound == 3:
		tempPath = MarbleC.instantiate()
	elif currentRound == 4:
		tempPath = MarbleD.instantiate()
	elif currentRound == 5:
		var r = randf()
		if r < 0.7:
			tempPath = MarbleA.instantiate()
		else:
			tempPath = MarbleE.instantiate()
		
	else:
		# After round 3, mix them randomly
		var r = randf()
		if r < 0.5:
			tempPath = MarbleA.instantiate()
		elif r < 0.6:
			tempPath = MarbleB.instantiate()
		elif r < 0.8:
			tempPath = MarbleC.instantiate()
		elif r < 0.9:
			tempPath = MarbleD.instantiate()
		else:
			tempPath = MarbleE.instantiate()

	add_child(tempPath)
	enemiesSpawned += 1

	# Round 1: After first 5 marbles, slow down spawn rate
	if currentRound == 1 and enemiesSpawned == 5:
		$Timer.stop()
		$Timer.start(.5)  # Slower spawn rate for remaining marbles

	# When enough enemies have spawned allow starting next round
	if enemiesSpawned >= enemiesPerRound:
		$Timer.stop()
		is_round_active = false
		GameState.add_money(100 + (currentRound * 10)) # new round bonus
		emit_signal("round_finished", currentRound)
	
func start_next_round():
	# Guard against double start
	if is_round_active:
		return

	# First time starting: do not increment round
	if not has_started:
		has_started = true
		enemiesSpawned = 0
		is_round_active = true
		emit_signal("round_started", currentRound)
		# Round 1: spawn first 5 marbles quickly (0.3 second intervals)
		if currentRound == 1:
			$Timer.start(0.3)
		else:
			$Timer.start()
		return

	# Subsequent rounds: advance and increase difficulty
	currentRound += 1
	GameState.set_round(currentRound)
	enemiesSpawned = 0
	enemiesPerRound += 2
	is_round_active = true
	emit_signal("round_started", currentRound)
	$Timer.start()
