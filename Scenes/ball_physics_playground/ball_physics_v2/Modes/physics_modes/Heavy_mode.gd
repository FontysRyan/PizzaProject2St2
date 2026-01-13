# HeavyMode.gd
extends PhysicsMode
class_name HeavyMode

@export var mode_name := "Heavy_mode"
@export var radius := 50.0
@export var mass_multiplier := 10.0

func on_added(ball):
	if not ball.is_real:
		return  # Skip resizing child balls
	var new_mass = ball.mass * mass_multiplier
	ball.Set_size(radius, new_mass)
func on_hit(ball: BaseBall, target):
	print("HEAVY PHYSICS")
