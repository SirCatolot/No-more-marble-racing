extends CharacterBody2D


@export var speed = 300
var Health = 10

## Move the enemy forward along its PathFollow2D path each frame,
## increasing its progress based on movement speed and frame time.
func _process(delta):
	get_parent().set_progress(get_parent().get_progress() + speed*delta)
	
	# Despawns the enemy and removes a life from player if they reach the end of the path
	if get_parent().get_progress_ratio() == 1:
		GameState.lose_life(1)
		queue_free()
	# If enemies health reaches zero, the player gains money and the enemy is deleted.
	if Health <= 0:
		GameState.add_money(5)
		get_parent().get_parent().queue_free()
