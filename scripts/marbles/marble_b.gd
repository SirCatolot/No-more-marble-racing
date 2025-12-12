extends CharacterBody2D


@export var speed = 300
var baseSpeed = speed
var speedMultiplier := 1.0
var Health = 15

func set_speed_multiplier(mult):
	speedMultiplier = mult

## Move the enemy forward along its PathFollow2D path each frame,
## increasing its progress based on movement speed and frame time.
func _process(delta):
	get_parent().set_progress(get_parent().get_progress() + baseSpeed * speedMultiplier * delta)
	
	# Reset after movement so boosters must reapply each frame
	speedMultiplier = 1.0
	
	# Despawns the enemy and removes a life from player if they reach the end of the path
	if get_parent().get_progress_ratio() >= 1:
		GameState.lose_life(1)
		_cleanup()
	# If enemies health reaches zero, the player gains money and the enemy is deleted.
	if Health <= 0:
		GameState.add_money(5)
		_cleanup()

func _cleanup():
	var parent = get_parent()
	var grandparent = parent.get_parent()
	# In Desert Level, we only want to delete the PathFollow2D (parent)
	# In Stage 1, we want to delete the whole Path2D container (grandparent)
	if grandparent.name == "LevelPath":
		parent.queue_free()
	else:
		grandparent.queue_free()
