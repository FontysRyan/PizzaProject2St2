# HeavyMode.gd
extends PhysicsMode
class_name DefaultMode

@export var mode_name := "Default_mode"
@export var radius := 10.0
@export var mass_multiplier := 1.0

func on_added(ball):
	# Use Set_size() from the ball
	var new_mass = ball.mass * mass_multiplier
	ball.Set_size(radius, new_mass)
