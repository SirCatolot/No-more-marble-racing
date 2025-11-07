extends Panel
@onready var tower = preload("res://Assets/Towers/PurpleBombTower.tscn")
@onready var name_label: Label = %NameLabel
@onready var cost_label: Label = %CostLabel
@export var tower_display_name := "Bomb Tower"
var currTile
const TOWER_COST := 50
const DRAG_PREVIEW_SCALE := Vector2.ONE
const TRACK_BUFFER_DISTANCE := 50.0  # Minimum distance from path

func _ready():
	name_label.text = tower_display_name
	cost_label.text = "$%d" % TOWER_COST

func _on_gui_input(event):
	var tempTower = tower.instantiate()
	if event is InputEventMouseButton and event.button_mask == 1:
		# Left Click Down
		add_child(tempTower)
		tempTower.process_mode = Node.PROCESS_MODE_DISABLED
		tempTower.scale = DRAG_PREVIEW_SCALE
		
	elif event is InputEventMouseMotion and event.button_mask == 1:
		# Left Click Down Drag
		if get_child_count() > 1:
			get_child(1).global_position = event.global_position
			
			# Visual feedback: red if on track, white if valid
			if _is_too_close_to_path(get_child(1).global_position):
				get_child(1).modulate = Color(1, 0.3, 0.3)  # Red tint
			else:
				get_child(1).modulate = Color(1, 1, 1)  # Normal color
				
	elif event is InputEventMouseButton and event.button_mask == 0:
		# Left Click Up
		if event.global_position.x >= 2944:	# Handle canceling tower drop
			if get_child_count() > 1:
				get_child(1).queue_free()
		else:
			if get_child_count() > 1:
				# Check if placement is valid (not too close to path)
				if _is_too_close_to_path(get_child(1).global_position):
					get_child(1).queue_free()
					return
				get_child(1).queue_free()
			
			var path = get_tree().get_root().get_node("Main/Towers")
			if GameState.try_spend(TOWER_COST):
				path.add_child(tempTower)
				tempTower.global_position = event.global_position
				tempTower.get_node("Area").hide()
	else:
		if get_child_count() > 1:
			get_child(1).queue_free()

func _is_too_close_to_path(position: Vector2) -> bool:
	var main = get_tree().get_root().get_node("Main")
	var paths = _find_all_paths(main)
	
	for path in paths:
		if path is Path2D and path.curve:
			var curve = path.curve
			var num_samples = 50
			
			for i in range(num_samples):
				var t = float(i) / float(num_samples - 1)
				var point_on_path = curve.sample_baked(t * curve.get_baked_length())
				var global_point = path.global_position + point_on_path
				
				if position.distance_to(global_point) < TRACK_BUFFER_DISTANCE:
					return true
	
	return false

func _find_all_paths(node: Node) -> Array:
	var paths = []
	if node is Path2D:
		paths.append(node)
	for child in node.get_children():
		paths.append_array(_find_all_paths(child))
	return paths
