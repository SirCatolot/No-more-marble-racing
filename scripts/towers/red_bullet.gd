extends CharacterBody2D


var target
var Speed = 1000
var pathName = ""
var bulletDamage
var last_known_target_pos = null

func _physics_process(delta):
	var pathSpawnerNode = get_tree().get_first_node_in_group("path_spawner")
	if pathSpawnerNode == null:
		# No spawner in the scene, bullet has nothing to track
		queue_free()
		return
	
	var target_found := false
	
	# Go through all child paths under the PathSpawner
	for child in pathSpawnerNode.get_children():
		if child.name == pathName:
			if child.get_child_count() == 0:
				continue
				
			var path_follow := child.get_child(0)
			if path_follow.get_child_count() > 0:
				var enemy = path_follow.get_child(0)
				target = enemy.global_position
				last_known_target_pos = target
				target_found = true
				break
				
	if not target_found:
		if last_known_target_pos != null:
			# No current enemy found, but we have a previous position, keep flying there
			target = last_known_target_pos
		else:
			# Never had a target, destroy bullet
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
