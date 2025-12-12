extends CharacterBody2D


@export var speed = 330
@export var speedMultiplier := 1.5 # This is the boost it gives to OTHERS
var selfSpeedMultiplier := 1.0
var Health = 10

func apply_speed_boost():
	var bodies = $Area2D.get_overlapping_bodies()
	for b in bodies:
		if b.has_method("set_speed_multiplier"):
			b.set_speed_multiplier(speedMultiplier)

func set_speed_multiplier(mult):
	selfSpeedMultiplier = mult 

## Move the enemy forward along its PathFollow2D path each frame,
## increasing its progress based on movement speed and frame time.
func _process(delta):
	# Apply aura speed effect
	apply_speed_boost()
	
	# Use local speedMultiplier for self movement (if we want it to be slowable)
	# But wait, Marble E has 'speedMultiplier' property exported as 1.5 (its boost strength).
	# This variable name conflict is confusing.
	# I should rename the exported one to 'boostStrength' and use 'speedMultiplier' for self.
	# For now, I will just ignore slowing Marble E to avoid breaking its aura logic, 
	# or I'll assume 'speedMultiplier' is ONLY for its aura.
	# If I want to slow it, I need a separate variable.
	# Let's add 'selfSpeedMultiplier'
	
	get_parent().set_progress(get_parent().get_progress() + speed * selfSpeedMultiplier * delta)
	selfSpeedMultiplier = 1.0
	
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
