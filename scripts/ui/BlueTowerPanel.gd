extends Panel


@onready var tower = preload("res://Assets/Towers/BlueArrowTower.tscn")
var currTile
const TOWER_COST := 50

func _on_gui_input(event):
	var tempTower = tower.instantiate()
	if event is InputEventMouseButton and event.button_mask == 1:
		# Left Click Down
		add_child(tempTower)

		tempTower.process_mode = Node.PROCESS_MODE_DISABLED
		
		tempTower.scale = Vector2(0.32,0.32)
		
		
	elif event is InputEventMouseMotion and event.button_mask == 1:
		# Left Click Down Drag
		if get_child_count() > 1:
			get_child(1).global_position = event. global_position
		
	elif event is InputEventMouseButton and event.button_mask == 0:
		# Left Click Up
		if event.global_position.x >= 2944:	# Handle canceling tower drop
			if get_child_count() > 1:
				get_child(1).queue_free()
		else:
			if get_child_count() > 1:
				get_child(1).queue_free()
			var path = get_tree().get_root().get_node("Main/Towers")
			if GameState.try_spend(TOWER_COST):
				path.add_child(tempTower)
				tempTower.global_position = event.global_position
				tempTower.get_node("Area").hide()
		
	else:
		if get_child_count() > 1:
			get_child(1).queue_free()
