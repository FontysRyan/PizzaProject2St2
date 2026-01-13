extends Resource
class_name SplitMode

@export var split_count := 2
@export var leave_parent_alive := false
@export var angle_spread := 0.5

# Called when ball is added
func on_added(ball: BaseBall) -> void:
	pass

# Called on hit; base does nothing
func on_hit(ball: BaseBall, target) -> void:
	pass

# Utility to spawn children; derived modes can call this
func spawn_children(ball: BaseBall, count: int) -> void:
	var base_velocity = ball.linear_velocity
	for i in count:
		var velocity = base_velocity.rotated(randf_range(-angle_spread, angle_spread))
		# All children are fake
		ball.spawn_split_child(velocity, false)
