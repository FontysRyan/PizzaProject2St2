extends Node2D

@export var object_scene: PackedScene
@export var shoot_angle_degrees: float = 90.0
@export var shoot_speed: float = 1200.0

func _ready():
	if object_scene:
		var obj = object_scene.instantiate()
		obj.position = get_viewport_rect().size / 2
		add_child(obj)

		# convert angle (+speed) into a movement vector
		var angle_radians = deg_to_rad(shoot_angle_degrees)
		var dir = Vector2.RIGHT.rotated(angle_radians)

		obj.linear_velocity = dir * shoot_speed
