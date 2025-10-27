extends Node2D

@onready var path = preload("res://Assets/Enemies/Stage 1.tscn")

## Spawns a new enemy path instance each time the timer triggers
func _on_timer_timeout():
	var tempPath = path.instantiate()
	add_child(tempPath)
