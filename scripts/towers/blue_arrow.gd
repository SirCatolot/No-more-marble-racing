extends CharacterBody2D

var Speed = 1000
var pathName = ""
var bulletDamage
# this exists to track marbles already hit, this way it wont hit twice.
var hit_marbles = []
# this needs to be changed when tower upgraded so it can pierce more marbles
var arrowHealth = 3

var direction: Vector2 = Vector2.RIGHT  # Store the direction permanently, default to right
var is_tracking = true  # Track target until first hit
var target_marble = null  # Reference to the marble we're tracking
var processing_collision = false  # Prevent multiple hits in same frame

func _ready():
	# Find the first marble to track
	var pathSpawnerNode = get_tree().get_root().get_node("Main/PathSpawner")

	for i in pathSpawnerNode.get_child_count():
		if pathSpawnerNode.get_child(i).name == pathName:
			# Check if path has children before accessing
			if pathSpawnerNode.get_child(i).get_child_count() > 0:
				var path_follow = pathSpawnerNode.get_child(i).get_child(0)
				if path_follow.get_child_count() > 0:
					target_marble = path_follow.get_child(0)
					var target_pos = target_marble.global_position
					direction = global_position.direction_to(target_pos)
					look_at(target_pos)  # Point arrow sprite at target
			break

func _physics_process(delta):
	if is_tracking:
		# Check if target marble still exists and is valid
		if is_instance_valid(target_marble) and not target_marble.is_queued_for_deletion():
			# Home in on the first marble until we hit it
			direction = global_position.direction_to(target_marble.global_position)
			look_at(target_marble.global_position)
		else:
			# Target died, stop tracking and continue straight
			is_tracking = false

	# Move in current direction
	velocity = direction * Speed
	move_and_slide()

	# Destroy if arrow goes too far off-screen
	if global_position.length() > 5000:
		queue_free()


func _on_area_2d_body_entered(body):
	if "Marble" in body.name:
		# Prevent multiple collisions in same frame
		if processing_collision:
			return

		# Check if we already hit this marble
		if body in hit_marbles:
			return

		# Verify the body is still valid (not being destroyed)
		if not is_instance_valid(body):
			return

		# Set flag to prevent re-entry
		processing_collision = true

		# Immediately add to hit list to prevent double-hits
		hit_marbles.append(body)

		# Deal damage only if marble still exists
		if is_instance_valid(body) and "Health" in body:
			var old_health = body.Health
			body.Health -= bulletDamage
			print("Arrow hit marble. Health: ", old_health, " -> ", body.Health)

		arrowHealth -= 1
		print("Arrow pierce count: ", arrowHealth, " pierces remaining")

		# After first hit, stop tracking and lock direction
		if is_tracking:
			is_tracking = false
			# Direction is already set from last frame, arrow will continue straight

		# Only destroy arrow after all pierces used
		if arrowHealth <= 0:
			queue_free()
			return  # Exit immediately after destroying

		# Reset flag on next frame (use call_deferred to avoid await issues)
		call_deferred("_reset_collision_flag")

func _reset_collision_flag():
	processing_collision = false
