extends CharacterBody2D

var target
var Speed = 1000
var pathName = ""
var slowDuration = 5.0
var target_node: Node2D = null
var SlowEffect = preload("res://scripts/effects/slow_effect.gd")

func _physics_process(delta):
	if is_instance_valid(target_node):
		target = target_node.global_position
	else:
		queue_free()
		return

	if target:
		velocity = global_position.direction_to(target) * Speed
		look_at(target)
	
	move_and_slide()
	
	if global_position.distance_to(target) < 10:
		queue_free()

func _on_area_2d_body_entered(body):
	if "Marble" in body.name:
		# Apply slow effect
		var slow_effect = SlowEffect.new()
		slow_effect.duration = slowDuration
		body.add_child(slow_effect)
		
		queue_free()
