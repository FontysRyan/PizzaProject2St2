# BaseBall.gd
extends RigidBody2D
class_name BaseBall

@export var physics_mode: PhysicsMode
@export var split_mode: SplitMode
@export var special_modes: Array[SpecialMode]

func _ready():
	if physics_mode:
		physics_mode.on_added(self)
	if split_mode:
		split_mode.on_added(self)
	for mode in special_modes:
		mode.on_added(self)

func on_hit(target):
	if physics_mode:
		physics_mode.on_hit(self, target)
	if split_mode:
		split_mode.on_hit(self, target)
	for mode in special_modes:
		mode.on_hit(self, target)
