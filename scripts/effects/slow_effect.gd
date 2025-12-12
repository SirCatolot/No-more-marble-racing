extends Node

var duration = 5.0
var time_elapsed = 0.0

func _process(delta):
	time_elapsed += delta
	if time_elapsed >= duration:
		queue_free()
		return
		
	var parent = get_parent()
	if parent.has_method("set_speed_multiplier"):
		parent.set_speed_multiplier(0.5)
