extends CharacterBody2D


var target
var Speed = 800  # Slightly slower than bullets for visual effect
var pathName = ""
var bombDamage
var explosionRadius = 150.0

func _physics_process(delta):
	var pathSpawnerNode = get_tree().get_root().get_node("Main/PathSpawner")

	# Loop through all child paths in PathSpawner to find the one matching the bomb's target path
	for i in pathSpawnerNode.get_child_count():
		if pathSpawnerNode.get_child(i).name == pathName:
			# Once the correct path is found, set the bomb's target position
			# to the first enemy's position on that path
			target = pathSpawnerNode.get_child(i).get_child(0).get_child(0).global_position

	# Point the bomb's velocity vector toward the target, scaled by its speed
	velocity = global_position.direction_to(target) * Speed

	# Rotate the projectile so it visually faces the direction it's moving
	look_at(target)

	# Move the projectile in the current direction, handling physics and collision
	move_and_slide()


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
