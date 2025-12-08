# Base_Ball.gd
extends RigidBody2D
class_name Base_Ball

# Collision layer indices for readability and maintainability
const LAYER_PLAYER = 0
const LAYER_BALL = 1
const LAYER_WALLS = 2
const LAYER_OBSTACLES = 3
const LAYER_TRAPS = 4
const LAYER_ENEMIES = 5

# Maximum impulse strength applied when the ball is hit.
# Higher values = ball travels farther / faster.
@export var total_push_power: float = 1000.0

func _ready() -> void:
	# Ball is on layer 2
	collision_layer = 1 << LAYER_BALL

	# Ball collides with Player, Walls, Obstacles, Traps, Enemies
	collision_mask = (1 << LAYER_PLAYER) | (1 << LAYER_WALLS) | (1 << LAYER_OBSTACLES) | (1 << LAYER_TRAPS) | (1 << LAYER_ENEMIES)

func hit_ball(direction: Vector2, power: float) -> void:
	gravity_scale = 0 # optional
	set_sleeping(false)
	print("eeeee")
	power = clamp(power, 0.0, 1.0)
	var impulse = direction.normalized() * (power * total_push_power)
	apply_central_impulse(impulse)
