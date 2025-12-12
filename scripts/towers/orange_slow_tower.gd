extends StaticBody2D

var Bullet = preload("res://scenes/towers/OrangeSlowProjectile.tscn")
# var bulletDamage = 0 # Removed as this tower does not deal damage
var fireRate = 0.33 # Shoots every 3 seconds = 1/3 = 0.33 shots per second.
var timeSinceLastShot = 0.0

var duration_level = 1
var fire_rate_level = 1
var base_duration = 5.0
var base_fire_rate = 0.33 # 1/3

var pathName
var currTargets = []
var curr

func _ready():
	input_pickable = true

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		GameState.emit_signal("tower_selected", self)

func upgrade_damage():
	# For this tower, "Damage" upgrade is actually "Duration" upgrade based on prompt
	duration_level += 1
	# "increase each thing by 1 second"
	# Duration starts at 5.
	# Lvl 2 -> 6s.
	# Lvl 3 -> 7s.
	pass

func upgrade_fire_rate():
	fire_rate_level += 1
	# "increase each thing by 1 second" -> Cooldown decreases by 1 second.
	# Base CD = 3s.
	# Lvl 2 CD = 2s -> Rate = 0.5
	# Lvl 3 CD = 1s -> Rate = 1.0
	# Lvl 4 CD = 0.5s? Or capped?
	var new_cd = max(0.5, 3.0 - (fire_rate_level - 1))
	fireRate = 1.0 / new_cd

func get_damage_upgrade_cost():
	return 25 + (duration_level * 25)

func get_fire_rate_upgrade_cost():
	return 25 + (fire_rate_level * 25)

func _process(delta):
	if is_instance_valid(curr):
		self.look_at(curr.global_position)
		
		timeSinceLastShot += delta
		if timeSinceLastShot >= 1.0 / fireRate:
			_fire_projectile()
			timeSinceLastShot = 0.0
	else:
		for child in get_node("BulletContainer").get_children():
			child.queue_free()

func _fire_projectile():
	var tempBullet = Bullet.instantiate()
	tempBullet.pathName = pathName
	tempBullet.slowDuration = base_duration + (duration_level - 1)
	
	get_node("BulletContainer").add_child(tempBullet)
	
	if is_instance_valid(curr):
		if curr.has_method("get_child_count") and curr.get_child_count() > 0:
			tempBullet.target_node = curr.get_child(0)
		else:
			tempBullet.target_node = curr
			
	tempBullet.global_position = $Aim.global_position

func _on_tower_body_entered(body):
	if "Marble" in body.name:
		_update_target()

func _on_tower_body_exited(body):
	currTargets = get_node("Tower").get_overlapping_bodies()
	_update_target()

func _update_target():
	var tempArray = []
	currTargets = get_node("Tower").get_overlapping_bodies()
	
	for i in currTargets:
		if "Marble" in i.name:
			tempArray.append(i)
			
	var currTarget = null
	
	for i in tempArray:
		if currTarget == null:
			currTarget = i.get_node("../")
		else:
			if i.get_parent().get_progress() > currTarget.get_progress():
				currTarget = i.get_node("../")
	
	if currTarget != null:
		curr = currTarget
		pathName = currTarget.get_parent().name
