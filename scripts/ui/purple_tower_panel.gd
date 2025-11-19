extends Panel


@onready var tower = preload("res://assets/towers/PurpleBombTower.tscn")
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
			var path = get_tree().get_root().get_node("Main/Towers")
			if GameState.try_spend(TOWER_COST):
				path.add_child(tempTower)
				tempTower.global_position = event.global_position
				tempTower.get_node("Area").hide()

	else:
		if get_child_count() > 1:
			get_child(1).queue_free()
