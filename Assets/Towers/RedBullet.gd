extends CharacterBody2D


var target
var Speed = 1000
var pathName = ""
var bulletDamage

func _physics_process(delta):
	var pathSpawnerNode = get_tree().get_root().get_node("Main/PathSpawner")
	
	# Loop through all child paths in PathSpawner to find the one matching the bullet's target path
	for i in pathSpawnerNode.get_child_count():
		if pathSpawnerNode.get_child(i).name == pathName:
			# Once the correct path is found, set the bullet's target position
			# to the first enemy's position on that path
			target = pathSpawnerNode.get_child(i).get_child(0).get_child(0).global_position
			
	# Point the bullet's velocity vector toward the target, scaled by its speed
	velocity = global_position.direction_to(target) *Speed
	
	# Rotate the projectile so it visually faces the direction it's moving
	look_at(target)
	
	# Move the projectile in the current direction, handling physics and collision
	move_and_slide()


func _on_area_2d_body_entered(body):
	
	if "Soldier A" in body.name:
		body.Health -= bulletDamage	# Reduce enemy's health by the projectile's damage
		queue_free()	# Remove bullet after hits target
