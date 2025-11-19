extends StaticBody2D


var Bullet = preload("res://scenes/towers/BlueArrow.tscn")	# Preload bullet scene so new bullets can be spawned quickly
var bulletDamage = 5
var pierceCount = 3  # How many marbles each arrow can pierce
var fireRate = 1.0  # Shots per second
var timeSinceLastShot = 0.0

var pathName
var currTargets = []
var curr

func _process(delta):
	# Rotate the tower to face the current target, while it exists
	if is_instance_valid(curr):
		self.look_at(curr.global_position)

		# Fire rate logic
		timeSinceLastShot += delta
		if timeSinceLastShot >= 1.0 / fireRate:
			_fire_arrow()
			timeSinceLastShot = 0.0
	# Note: Don't delete arrows when target is lost - let them continue flying

func _fire_arrow():
	# Spawn an arrow and set its properties
	var tempBullet = Bullet.instantiate()
	tempBullet.pathName = pathName
	tempBullet.bulletDamage = bulletDamage
	tempBullet.arrowHealth = pierceCount  # Pass pierce count to arrow

	# Set position BEFORE adding to tree so _ready() calculates direction correctly
	tempBullet.global_position = $Aim.global_position

	# Add the bullet to the BulletContainer node
	get_node("BulletContainer").add_child(tempBullet)

func _on_tower_body_entered(body):
	if "Marble" in body.name:
		_update_target()

func _update_target():
	var tempArray = []
	currTargets = get_node("Tower").get_overlapping_bodies()

	# Filters out only the objects with "Marble" in the name (enemies)
	for i in currTargets:
		if "Marble" in i.name:
			tempArray.append(i)

	var currTarget = null

	# Find the enemy furthest along the path (closest to exit)
	for i in tempArray:
		if currTarget == null:
			currTarget = i.get_node("../")
		else:
			if i.get_parent().get_progress() > currTarget.get_progress():
				currTarget = i.get_node("../")

	# Set the chosen target as the current enemy
	if currTarget != null:
		curr = currTarget
		pathName = currTarget.get_parent().name
				
func _on_tower_body_exited(body):
	# Update the list of overlapping enemies when one leaves the detection zone
	currTargets = get_node("Tower").get_overlapping_bodies()
	_update_target()  # Find new target when one leaves
