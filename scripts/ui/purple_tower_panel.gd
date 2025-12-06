extends Panel


@onready var tower = preload("res://scenes/towers/PurpleBombTower.tscn")
@onready var name_label: Label = %NameLabel
@onready var cost_label: Label = %CostLabel

@export var tower_display_name := "Bomb Tower"

var currTile
const TOWER_COST := 50
const DRAG_PREVIEW_SCALE := Vector2.ONE

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

	elif event is InputEventMouseButton and event.button_mask == 0:
		# Left Click Up
		if event.global_position.x >= 2944:	# Handle canceling tower drop
			if get_child_count() > 1:
				get_child(1).queue_free()
		else:
			if get_child_count() > 1:
				get_child(1).queue_free()
			
			var path_node = get_tree().get_root().get_node("Main/MarblePath")
			var is_on_path = false
			
			# Check Stage 1 Path (Line2D/Segments)
			if path_node:
				var local_pos = path_node.to_local(event.global_position)
				var points = path_node.points
				for i in range(points.size() - 1):
					var p1 = points[i]
					var p2 = points[i+1]
					var closest_point = Geometry2D.get_closest_point_to_segment(local_pos, p1, p2)
					if local_pos.distance_to(closest_point) < 40:
						is_on_path = true
						break
			
			# Check Desert Map Path (Path2D/Curve2D)
			if not is_on_path:
				var level_path_node = get_tree().get_root().get_node_or_null("Main/LevelPath")
				if level_path_node:
					var local_pos = level_path_node.to_local(event.global_position)
					var closest_point = level_path_node.curve.get_closest_point(local_pos)
					if local_pos.distance_to(closest_point) < 50: # Slightly larger radius for the wider desert path
						is_on_path = true
			
			if not is_on_path and GameState.try_spend(TOWER_COST):
				var path = get_tree().get_root().get_node("Main/Towers")
				path.add_child(tempTower)
				tempTower.global_position = event.global_position
				tempTower.get_node("Area").hide()

	else:
		if get_child_count() > 1:
			get_child(1).queue_free()
