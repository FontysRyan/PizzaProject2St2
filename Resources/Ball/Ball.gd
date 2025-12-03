extends RigidBody2D

@export var max_force: float = 3000.0

func hit_ball(direction: Vector2, power: float):
	power = clamp(power, 0.0, 1.0)
	sleeping = false
	var impulse = direction.normalized() * (power * max_force)
	apply_impulse(Vector2.ZERO, impulse)
