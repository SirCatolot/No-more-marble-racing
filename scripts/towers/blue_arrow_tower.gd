extends StaticBody2D


var Bullet = preload("res://scenes/towers/BlueArrow.tscn")	# Preload bullet scene so new bullets can be spawned quickly
var bulletDamage = 5
var pierceCount = 3  # How many marbles each arrow can pierce
var fireRate = 1.0  # Shots per second
var timeSinceLastShot = 0.0

var damage_level = 1
var fire_rate_level = 1
var base_damage = 5
var base_fire_rate = 1.0

var pathName
var currTargets = []
var curr

func _ready():
	input_pickable = true

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		GameState.emit_signal("tower_selected", self)

func upgrade_damage():
	damage_level += 1
	bulletDamage = base_damage + (damage_level - 1) * 2

func upgrade_fire_rate():
	fire_rate_level += 1
	fireRate = base_fire_rate + (fire_rate_level - 1) * 0.5

func get_damage_upgrade_cost():
	return 25 + (damage_level * 25)

func get_fire_rate_upgrade_cost():
	return 25 + (fire_rate_level * 25)

func _process(delta):
	# Rotate the tower to face the current target, while it exists
	if is_instance_valid(curr):
		self.look_at(curr.global_position)

		# Fire rate logic
		timeSinceLastShot += delta
		if timeSinceLastShot >= 1.0 / fireRate:
			_fire_arrow()
			timeSinceLastShot = 0.0
	else:
		for child in get_node("BulletContainer").get_children():
			child.queue_free()

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
	
	if is_instance_valid(curr):
		if curr.has_method("get_child_count") and curr.get_child_count() > 0:
			tempBullet.target_marble = curr.get_child(0)
		else:
			tempBullet.target_marble = curr

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
