extends CharacterBody2D


var target
var Speed = 800  # Slightly slower than bullets for visual effect
var pathName = ""
var bombDamage
var explosionRadius = 150.0
var last_known_target_pos = null

func _physics_process(delta):
	var pathSpawnerNode = get_tree().get_root().get_node("Main/PathSpawner")
	var target_found = false

	# Loop through all child paths in PathSpawner to find the one matching the bomb's target path
	for i in pathSpawnerNode.get_child_count():
		if pathSpawnerNode.get_child(i).name == pathName:
			# Once the correct path is found, set the bomb's target position
			# to the first enemy's position on that path
			var path_follow = pathSpawnerNode.get_child(i).get_child(0)
			if path_follow.get_child_count() > 0:
				target = path_follow.get_child(0).global_position
				last_known_target_pos = target
				target_found = true
	
	if not target_found and last_known_target_pos != null:
		# If target lost, continue to last known position (explode on arrival)
		target = last_known_target_pos
	elif not target_found and last_known_target_pos == null:
		# If no target ever found, destroy
		queue_free()
		return

	# Point the bomb's velocity vector toward the target, scaled by its speed
	if target:
		velocity = global_position.direction_to(target) * Speed
		look_at(target)

	# Move the projectile in the current direction, handling physics and collision
	move_and_slide()
	
	# Force explode if reached destination without hitting anything (e.g. ground hit)
	if target and global_position.distance_to(target) < 10:
		explode()
		queue_free()



func _on_area_2d_body_entered(body):
	if "Marble" in body.name:
		# Create explosion effect - damage all marbles in radius
		explode()
		queue_free()  # Remove bomb after explosion

func explode():
	# Get all bodies in the explosion radius
	var explosion_area = $ExplosionArea
	var bodies = explosion_area.get_overlapping_bodies()

	# Damage all marbles caught in the blast
	for body in bodies:
		if "Marble" in body.name:
			body.Health -= bombDamage
