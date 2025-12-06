extends CharacterBody2D


var target_position: Vector2
var Speed = 800  # Slightly slower than bullets for visual effect
var bombDamage
var explosionRadius = 150.0

func _ready():
	if target_position:
		velocity = global_position.direction_to(target_position) * Speed
		look_at(target_position)

func _physics_process(delta):
	if target_position:
		var distance_to_target = global_position.distance_to(target_position)
		var move_amount = Speed * delta
		
		# If we are close enough to reach the target this frame, move there and explode
		if distance_to_target <= move_amount:
			global_position = target_position
			explode()
			queue_free()
		else:
			# Otherwise, move towards the target
			velocity = global_position.direction_to(target_position) * Speed
			move_and_slide()



func explode():
	# Get all bodies in the explosion radius
	var explosion_area = $ExplosionArea
	var bodies = explosion_area.get_overlapping_bodies()

	# Damage all marbles caught in the blast
	for body in bodies:
		if "Marble" in body.name:
			body.Health -= bombDamage
