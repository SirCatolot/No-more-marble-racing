extends Node2D

signal round_started(round)
signal round_finished(round)

# Preload different enemy path scenes
@onready var MarbleA = preload("res://Assets/Enemies/Stage 1 Marble A.tscn")
@onready var MarbleB = preload("res://Assets/Enemies/Stage 1 Marble B.tscn")
@onready var MarbleC = preload("res://Assets/Enemies/Stage 1 Marble C.tscn")

# Track current round and how many enemies have spawned
var currentRound = 1
var enemiesSpawned = 0
var enemiesPerRound = 5
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
	else:
		# After round 3, mix them randomly
		var r = randf()
		if r < 0.5:
			tempPath = MarbleA.instantiate()
		elif r < 0.8:
			tempPath = MarbleB.instantiate()
		else:
			tempPath = MarbleC.instantiate()
			
	add_child(tempPath)
	enemiesSpawned += 1

	# When enough enemies have spawned allow starting next round
	if enemiesSpawned >= enemiesPerRound:
		$Timer.stop()
		is_round_active = false
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
