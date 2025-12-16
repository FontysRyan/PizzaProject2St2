extends Node2D

func _process(delta: float) -> void:
	look_at(get_global_mouse_position())
	var player_position = get_parent().global_position
	var direction = (get_global_mouse_position() - player_position).normalized()
	var radius = 150
	global_position = player_position + direction * radius
