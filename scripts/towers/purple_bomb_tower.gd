extends StaticBody2D


var Bomb = preload("res://scenes/towers/PurpleBomb.tscn")
var bombDamage = 10  # Enough to kill a basic marble (Health = 10)
var fireRate = 0.25
var timeSinceLastShot = 0.0

var damage_level = 1
var fire_rate_level = 1
var base_damage = 10
var base_fire_rate = 0.25

var pathName
var currTargets = []
var curr
var can_fire = true

func _ready():
	input_pickable = true
	if has_node("Timer"):
		get_node("Timer").stop()

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		GameState.emit_signal("tower_selected", self)

func upgrade_damage():
	damage_level += 1
	bombDamage = base_damage + (damage_level - 1) * 5

func upgrade_fire_rate():
	fire_rate_level += 1
	fireRate = base_fire_rate + (fire_rate_level - 1) * 0.1

func get_damage_upgrade_cost():
	return 25 + (damage_level * 25)

func get_fire_rate_upgrade_cost():
	return 25 + (fire_rate_level * 25)

func _process(delta):
	# Rotate the tower to face the current target, while it exists
	if is_instance_valid(curr):
		self.look_at(curr.global_position)
		
		timeSinceLastShot += delta
		if timeSinceLastShot >= 1.0 / fireRate and can_fire:
			fire_bomb()
			timeSinceLastShot = 0.0
	else:
		for child in get_node("BulletContainer").get_children():
			child.queue_free()

# Logic moved to _process
func _on_timer_timeout():
	pass

func fire_bomb():
	if curr == null:
		return

	# Spawn a bomb and set its damage and target path
	var tempBomb = Bomb.instantiate()
	tempBomb.pathName = pathName
	tempBomb.bombDamage = bombDamage

	# Add the bomb to the BulletContainer node and position it at the tower's aim point
	get_node("BulletContainer").add_child(tempBomb)
	tempBomb.global_position = $Aim.global_position

func _on_tower_body_entered(body):
	if "Marble" in body.name:
		var tempArray = []
		currTargets = get_node("Tower").get_overlapping_bodies()

		# Filter out only the objects with "Marble" in the name (enemies)
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

func _on_tower_body_exited(body):
	# Update the list of overlapping enemies when one leaves the detection zone
	currTargets = get_node("Tower").get_overlapping_bodies()
