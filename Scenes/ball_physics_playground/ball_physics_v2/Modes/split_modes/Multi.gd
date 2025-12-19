extends SplitMode
class_name MultiMode

func _init():
	split_count = 2
	angle_spread = 0.3
	leave_parent_alive = true

func on_hit(ball: BaseBall, target) -> void:
	if not ball.is_real:
		return
	# Split into 2, keeping 1 as real
	spawn_children(ball, split_count, true)
	if not leave_parent_alive:
		ball.queue_free()
