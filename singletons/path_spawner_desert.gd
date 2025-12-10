extends Node2D

signal round_started(round)
signal round_finished(round)

# Preload different enemy path scenes
@onready var MarbleA = preload("res://scenes/marbles/MarbleA.tscn")
@onready var MarbleB = preload("res://scenes/marbles/MarbleB.tscn")
@onready var MarbleC = preload("res://scenes/marbles/MarbleC.tscn")
@onready var MarbleD = preload("res://scenes/marbles/MarbleD.tscn")
@onready var MarbleE = preload("res://scenes/marbles/MarbleE.tscn")


# Track current round and how many enemies have spawned
var currentRound = 1
var enemiesSpawned = 0
var enemiesPerRound = 15  # Starts harder than Stage 1 (was 10)
var is_round_active = false
var has_started = false

@onready var level_path = get_parent().get_node("LevelPath")

func _ready():
	add_to_group("path_spawner")
	# Shows the initial round value in UI
	GameState.set_round(currentRound)
	$Timer.stop()

## Spawns a new enemy path instance each time the timer triggers
func _on_timer_timeout():
	var marble_instance
	var path_follow = PathFollow2D.new()
	path_follow.loop = false
	path_follow.rotates = true

	# Pick which enemy type to spawn based on the round
	if currentRound == 1:
		marble_instance = MarbleA.instantiate()
	elif currentRound == 2:
		marble_instance = MarbleB.instantiate()
	elif currentRound == 3:
		marble_instance = MarbleC.instantiate()
	elif currentRound == 4:
		marble_instance = MarbleD.instantiate()
	elif currentRound == 5:
		var r = randf()
		if r < 0.7:
			marble_instance = MarbleA.instantiate()
		else:
			marble_instance = MarbleE.instantiate()

	else:
		# After round 3, mix them randomly with higher chance for harder marbles
		var r = randf()
		if r < 0.3:
			marble_instance = MarbleA.instantiate()
		elif r < 0.6:
			marble_instance = MarbleB.instantiate()
		elif r < 0.8:
			marble_instance = MarbleC.instantiate()
		elif r < 0.9:
			marble_instance = MarbleD.instantiate()
		else:
			marble_instance = MarbleE.instantiate()


	path_follow.add_child(marble_instance)
	level_path.add_child(path_follow)
	enemiesSpawned += 1

	# Round 1: No slow down for Desert, keep the pressure up
	
	# When enough enemies have spawned allow starting next round
	if enemiesSpawned >= enemiesPerRound:
		$Timer.stop()
		is_round_active = false
		GameState.add_money(150 + (currentRound * 15)) # Higher bonus for harder map
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
		# Fast start
		$Timer.start(0.8) 
		return

	# Subsequent rounds: advance and increase difficulty
	currentRound += 1
	GameState.set_round(currentRound)
	enemiesSpawned = 0
	enemiesPerRound += 4 # Scale up faster (was +2)
	is_round_active = true
	emit_signal("round_started", currentRound)
	
	# Decrease spawn time as rounds progress to increase intensity
	var spawn_time = max(0.2, 0.8 - (currentRound * 0.1))
	$Timer.start(spawn_time)
