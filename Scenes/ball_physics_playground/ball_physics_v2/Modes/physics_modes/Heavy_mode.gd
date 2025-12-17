# HeavyMode.gd
extends PhysicsMode
class_name HeavyMode

@export var mode_name := "Heavy_mode"
@export var radius := 50.0
@export var mass_multiplier := 1000.0

func on_added(ball):
	# Use Set_size() from the ball
	var new_mass = ball.mass * mass_multiplier
	ball.Set_size(radius, new_mass)
