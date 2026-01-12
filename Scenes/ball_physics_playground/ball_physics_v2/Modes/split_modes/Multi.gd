extends SplitMode
class_name MultiMode

func _init():
	split_count = 2
	angle_spread = 0.3
	leave_parent_alive = true

func on_hit(ball: BaseBall, target) -> void:
	if not ball.is_real:
		return

	# Split into children (all fake)
	spawn_children(ball, split_count)

	# Optionally remove parent if needed
	if not leave_parent_alive:
		ball.queue_free()
