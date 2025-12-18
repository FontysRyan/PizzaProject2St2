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
var original_radius: float

func _ready() -> void:
	original_radius = $CollisionShape2D.shape.radius
	#angular_velocity = 5.0  # initial spin
	# Ball is on layer 2
	collision_layer = 1 << LAYER_BALL
	
	Set_size(15,10)
	# Ball collides with Player, Walls, Obstacles, Traps, Enemies
	collision_mask = (1 << LAYER_PLAYER) | (1 << LAYER_WALLS) | (1 << LAYER_OBSTACLES) | (1 << LAYER_TRAPS) | (1 << LAYER_ENEMIES)

func hit_ball(direction: Vector2, power: float) -> void:
	gravity_scale = 0 # optional
	set_sleeping(false)
	print("eeeee")
	power = clamp(power, 0.0, 1.0)
	var impulse = direction.normalized() * (power * total_push_power)
	apply_central_impulse(impulse)

func Set_size(radius: float, new_mass: float):
	mass = new_mass
	var desired_radius = radius

	var shape = $CollisionShape2D.shape.duplicate()
	$CollisionShape2D.shape = shape

	if shape is CircleShape2D:
		shape.radius = desired_radius

	# Scale whole node (collision included)
	if original_radius > 0:
		var factor = desired_radius / original_radius
		scale = Vector2.ONE * factor     # parent scaling (affects collision)

		# Apply a separate scale for the sprite only
		var sprite_factor = factor / 10.0
		$AnimatedSprite2D.scale = Vector2.ONE * sprite_factor
