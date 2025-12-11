extends CharacterBody2D


@export var speed = 300
var baseSpeed = speed
var speedMultiplier := 1.0
@export var spawnCount := 3
@export var spawnScene:= preload("res://scenes/marbles/MarbleA.tscn")
var Health = 10

func set_speed_multiplier(mult):
	speedMultiplier = max(speedMultiplier, mult)

## Move the enemy forward along its PathFollow2D path each frame,
## increasing its progress based on movement speed and frame time.
func _process(delta):
	get_parent().set_progress(get_parent().get_progress() + baseSpeed * speedMultiplier * delta)
	
	# Reset after movement so boosters must reapply each frame
	speedMultiplier = 1.0
	
	# If enemies health reaches zero, spawn extra marbles and remove this enemy only.
	if Health <= 0:
		spawn_marbles()
		GameState.add_money(5)
		_cleanup()
		return
	
	# Despawns the enemy and removes a life from player if they reach the end of the path
	if get_parent().get_progress_ratio() >= 1:
		GameState.lose_life(1)
		_cleanup()


func spawn_marbles() -> void:
	var path_follow = get_parent()
	var path = path_follow.get_parent()
	
	for i in spawnCount:
		var new_pf =  PathFollow2D.new()
		new_pf.progress = path_follow.progress - (i * 100) # Spawn staggered on the path
		new_pf.loop = false # Spawned marble does not loop once it reaches the end
		
		var marble = spawnScene.instantiate()
		new_pf.add_child(marble)
		path.add_child(new_pf)

func _cleanup() -> void:
	# For the bag enemy, ONLY remove its own PathFollow2D.
	var path_follow := get_parent()
	path_follow.queue_free()
	#var parent = get_parent()
	#var grandparent = parent.get_parent()
	## In Desert Level, we only want to delete the PathFollow2D (parent)
	## In Stage 1, we want to delete the whole Path2D container (grandparent)
	#if grandparent.name == "LevelPath":
		#parent.queue_free()
	#else:
		#grandparent.queue_free()
