extends SplitMode
class_name ShotgunMode

func _init():
	split_count = 4
	angle_spread = 1.2
	leave_parent_alive = true

# Called when the ball is added to the scene
func on_added(ball: BaseBall) -> void:
	if not ball.is_real:
		return

	print("SHOTGUN TIME")
	# Add a tiny timer to defer spawning until parent is fully in the tree
	var timer = Timer.new()
	timer.wait_time = 0.05  # 50ms delay
	timer.one_shot = true
	timer.autostart = true
	timer.timeout.connect(func() -> void:
		_spawn_shotgun_children(ball)
	)
	ball.add_child(timer)

# Do nothing on hit; splitting is done on spawn
func on_hit(ball: BaseBall, target) -> void:
	pass

# Called by timer to actually spawn the fake balls
func _spawn_shotgun_children(ball: BaseBall) -> void:
	spawn_children(ball, split_count)

# Spawn fake balls using parent velocity + spread
func spawn_children(ball: BaseBall, count: int) -> void:
	var parent_velocity = ball.linear_velocity
	var speed = parent_velocity.length()  # exact parent speed

	# If parent is stationary, give some default
	if speed == 0:
		parent_velocity = Vector2.RIGHT
		speed = 400.0

	var direction = parent_velocity.normalized()

	for i in count:
		var spread = randf_range(-angle_spread, angle_spread)
		var velocity = direction.rotated(spread) * speed
		ball.spawn_split_child(velocity, false)
