extends CharacterBody2D


@export var speed = 330
@export var speedMultiplier := 1.5 # This is the boost it gives to OTHERS
var selfSpeedMultiplier := 1.0
var Health = 10
var maxHealth = 10

# UI Elements
var health_bar: ProgressBar
var speed_label: Label
var ui_container: Control

func _ready():
	_setup_ui()

func _setup_ui():
	# Create a container for UI elements positioned above the marble
	ui_container = Control.new()
	ui_container.position = Vector2(-10, -25)  # Centered above marble
	ui_container.scale = Vector2(0.5, 0.5)  # Scale down to counteract parent's 2x scale
	ui_container.z_index = 10
	add_child(ui_container)
	
	# Health bar
	health_bar = ProgressBar.new()
	health_bar.size = Vector2(40, 2)
	health_bar.position = Vector2(0, 0)
	health_bar.min_value = 0
	health_bar.max_value = maxHealth
	health_bar.value = Health
	health_bar.show_percentage = false
	
	# Style the health bar
	var stylebox = StyleBoxFlat.new()
	stylebox.bg_color = Color(0.2, 0.8, 0.2, 0.9)  # Green
	health_bar.add_theme_stylebox_override("fill", stylebox)
	
	var bg_stylebox = StyleBoxFlat.new()
	bg_stylebox.bg_color = Color(0.2, 0.2, 0.2, 0.7)  # Dark gray background
	health_bar.add_theme_stylebox_override("background", bg_stylebox)
	
	ui_container.add_child(health_bar)
	
	# Speed indicator (small label)
	speed_label = Label.new()
	speed_label.position = Vector2(0, -10)
	speed_label.add_theme_font_size_override("font_size", 8)
	speed_label.add_theme_color_override("font_color", Color(1, 1, 1, 0.8))
	speed_label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 1))
	speed_label.add_theme_constant_override("outline_size", 2)
	speed_label.text = "100%"
	ui_container.add_child(speed_label)

func _update_ui():
	if health_bar:
		health_bar.value = Health
		# Update health bar color based on health percentage
		var health_percent = float(Health) / float(maxHealth)
		var fill_style = health_bar.get_theme_stylebox("fill")
		if fill_style is StyleBoxFlat:
			if health_percent > 0.6:
				fill_style.bg_color = Color(0.2, 0.8, 0.2, 0.9)  # Green
			elif health_percent > 0.3:
				fill_style.bg_color = Color(0.9, 0.9, 0.2, 0.9)  # Yellow
			else:
				fill_style.bg_color = Color(0.9, 0.2, 0.2, 0.9)  # Red
	
	if speed_label:
		var speed_percent = int(selfSpeedMultiplier * 100)
		speed_label.text = str(speed_percent) + "%"
		# Change color based on speed
		if selfSpeedMultiplier < 0.7:
			speed_label.add_theme_color_override("font_color", Color(0.7, 0.7, 1, 0.8))  # Blue for slow
		elif selfSpeedMultiplier > 1.3:
			speed_label.add_theme_color_override("font_color", Color(1, 0.5, 0.5, 0.8))  # Red for fast
		else:
			speed_label.add_theme_color_override("font_color", Color(1, 1, 1, 0.8))  # White for normal

func apply_speed_boost():
	var bodies = $Area2D.get_overlapping_bodies()
	for b in bodies:
		if b.has_method("set_speed_multiplier"):
			b.set_speed_multiplier(speedMultiplier)

func set_speed_multiplier(mult):
	selfSpeedMultiplier = mult 

## Move the enemy forward along its PathFollow2D path each frame,
## increasing its progress based on movement speed and frame time.
func _process(delta):
	# Apply aura speed effect
	apply_speed_boost()
	
	# Use local speedMultiplier for self movement (if we want it to be slowable)
	# But wait, Marble E has 'speedMultiplier' property exported as 1.5 (its boost strength).
	# This variable name conflict is confusing.
	# I should rename the exported one to 'boostStrength' and use 'speedMultiplier' for self.
	# For now, I will just ignore slowing Marble E to avoid breaking its aura logic, 
	# or I'll assume 'speedMultiplier' is ONLY for its aura.
	# If I want to slow it, I need a separate variable.
	# Let's add 'selfSpeedMultiplier'
	
	get_parent().set_progress(get_parent().get_progress() + speed * selfSpeedMultiplier * delta)
	
	# Update UI before resetting speed
	_update_ui()
	
	selfSpeedMultiplier = 1.0
	
	# Despawns the enemy and removes a life from player if they reach the end of the path
	if get_parent().get_progress_ratio() >= 1:
		GameState.lose_life(1)
		_cleanup()
	# If enemies health reaches zero, the player gains money and the enemy is deleted.
	if Health <= 0:
		GameState.add_money(5)
		_cleanup()

func _cleanup():
	var parent = get_parent()
	var grandparent = parent.get_parent()
	# In Desert Level, we only want to delete the PathFollow2D (parent)
	# In Stage 1, we want to delete the whole Path2D container (grandparent)
	if grandparent.name == "LevelPath":
		parent.queue_free()
	else:
		grandparent.queue_free()
