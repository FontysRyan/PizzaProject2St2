# ShotgunMode.gd
extends SplitMode
class_name NoSPlit

func _init():
	split_count = 0
	angle_spread = 0.3
	leave_parent_alive = true

func on_hit(ball: BaseBall, target) -> void:
	pass
