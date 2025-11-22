extends CharacterBody2D


var target
var Speed = 1000
var pathName = ""
var bulletDamage
var last_known_target_pos = null

func _physics_process(delta):
	var pathSpawnerNode = get_tree().get_root().get_node("Main/PathSpawner")
	var target_found = false
	
	# Loop through all child paths in PathSpawner to find the one matching the bullet's target path
	for i in pathSpawnerNode.get_child_count():
		if pathSpawnerNode.get_child(i).name == pathName:
			# Once the correct path is found, set the bullet's target position
			# to the first enemy's position on that path
			var path_follow = pathSpawnerNode.get_child(i).get_child(0)
			if path_follow.get_child_count() > 0:
				target = path_follow.get_child(0).global_position
				last_known_target_pos = target
				target_found = true
			
	if not target_found and last_known_target_pos != null:
		# If target lost, continue to last known position
		target = last_known_target_pos
	elif not target_found and last_known_target_pos == null:
		# If no target ever found, destroy bullet
		queue_free()
		return

	# Point the bullet's velocity vector toward the target, scaled by its speed
	if target:
		velocity = global_position.direction_to(target) * Speed
		look_at(target)
	
	# Move the projectile in the current direction, handling physics and collision
	move_and_slide()
	
	# Remove if it reached destination but found nothing (or just cleanup if off screen)
	if global_position.distance_to(target) < 10:
		queue_free()



func _on_area_2d_body_entered(body):
	
	if "Marble" in body.name:
		body.Health -= bulletDamage	# Reduce enemy's health by the projectile's damage
		queue_free()	# Remove bullet after hits target
