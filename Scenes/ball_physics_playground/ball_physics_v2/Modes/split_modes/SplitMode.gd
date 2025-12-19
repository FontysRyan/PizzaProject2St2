# SplitMode.gd
extends Resource
class_name SplitMode

@export var split_count := 2
@export var leave_parent_alive := false
@export var angle_spread := 0.5

func on_added(ball: BaseBall) -> void:
	pass

func on_hit(ball: BaseBall, target) -> void:
	# Fake balls disappear immediately
	if not ball.is_real:
		ball.queue_free()
		return

	do_split(ball)

	if not leave_parent_alive:
		ball.queue_free()

func do_split(ball: BaseBall) -> void:
	var base_velocity := ball.linear_velocity
	for i in split_count:
		var angle := randf_range(-angle_spread, angle_spread)
		var new_velocity := base_velocity.rotated(angle)
		ball.spawn_split_child(new_velocity, false)
