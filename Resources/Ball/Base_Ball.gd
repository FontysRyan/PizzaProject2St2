# Base_Ball.gd
extends RigidBody2D
class_name Base_Ball
# Maximum impulse strength applied when the ball is hit.
# Higher values = ball travels farther / faster.
@export var total_push_power: float = 1000.0

func _ready() -> void:
	# Ball is on layer 2
	collision_layer = 1 << 1

	# Ball collides with Player (1), Walls (3), Obstacles (4), Traps (5), Enemies (6)
	collision_mask = (1 << 0) | (1 << 2) | (1 << 3) | (1 << 4) | (1 << 5)

func hit_ball(direction: Vector2, power: float) -> void:
	gravity_scale = 0 # optional
	sleeping = false
	set_sleeping(false)
	print("eeeee")
	power = clamp(power, 0.0, 1.0)
	var impulse = direction.normalized() * (power * total_push_power)
	apply_central_impulse(impulse)
