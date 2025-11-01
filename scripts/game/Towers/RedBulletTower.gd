extends StaticBody2D


var Bullet = preload("res://Assets/Towers/RedBullet.tscn")	# Preload bullet scene so new bullets can be spawned quickly
var bulletDamage = 5
var pathName
var currTargets = []
var curr

func _process(delta):
	# Rotate the tower to face the current target, while it exists
	if is_instance_valid(curr):
		self.look_at(curr.global_position)
	else:
		# If there's no valid target, clear all remaining projectiles
		for i in get_node("BulletContainer").get_child_count():
			get_node("BulletContainer").get_child(i).queue_free()

func _on_tower_body_entered(body):
	if "Marble" in body.name:
		var tempArray = []
		currTargets = get_node("Tower").get_overlapping_bodies()
		
		# Filters out only the objects with "Soldier in the name (enemies)
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
		curr = currTarget
		pathName = currTarget.get_parent().name
		
		#Spawn a bullet and set its damage and target path
		var tempBullet = Bullet.instantiate()
		tempBullet.pathName = pathName
		tempBullet.bulletDamage = bulletDamage
		
		# Add the bullet to the BulletContainer node and position it at the tower's aim point
		get_node("BulletContainer").add_child(tempBullet)
		tempBullet.global_position = $Aim.global_position
				
func _on_tower_body_exited(body):
	# Update the list of overlapping enemies when one leaves the detection zone
	currTargets = get_node("Tower").get_overlapping_bodies()
