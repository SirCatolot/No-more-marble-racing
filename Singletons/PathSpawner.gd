extends Node2D

# Preload different enemy path scenes
@onready var MarbleA = preload("res://Assets/Enemies/Stage 1 Marble A.tscn")
@onready var MarbleB = preload("res://Assets/Enemies/Stage 1 Marble B.tscn")
@onready var MarbleC = preload("res://Assets/Enemies/Stage 1 Marble C.tscn")

# Track current round and how many enemies have spawned
var currentRound = 1
var enemiesSpawned = 0
var enemiesPerRound = 5

func _ready():
	# Notify HUD of starting round
	GameState.set_round(currentRound)
	# Start timer to begin spawning enemies
	$Timer.start()

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

	# When enough enemies have spawned, stop timer and start next round
	if enemiesSpawned >= enemiesPerRound:
		$Timer.stop()
		# Delay between rounds
		await get_tree().create_timer(3.0).timeout
		start_next_round()
	
func start_next_round():
	currentRound += 1
	GameState.set_round(currentRound)
	enemiesSpawned = 0
	
	# Increase difficulty each rpund
	enemiesPerRound += 2
	$Timer.start()
