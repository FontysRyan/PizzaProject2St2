extends Node2D

@export var object_scene: PackedScene
#@export var object_scene2: PackedScene
#@export var object_scene3: PackedScene
@export var shoot_angle_degrees: float = 120.0
@export var shoot_power: float = 1 #1 = 100% power

func _ready():
	#Engine.time_scale = clamp(0.1, 0.0, 10.0)
	spawn_and_shoot()
	#await get_tree().create_timer(1.0).timeout
	#spawn_and_shoot2()
	#await get_tree().create_timer(1.0).timeout
	#spawn_and_shoot3()

func spawn_and_shoot() -> void:
	var obj = object_scene.instantiate()
	obj.position = get_viewport_rect().size / 2
	add_child(obj)
	print(obj, obj.get_class())

	await get_tree().physics_frame

	var angle = deg_to_rad(shoot_angle_degrees)
	var dir = Vector2.RIGHT.rotated(angle)
	obj.hit_ball(dir, shoot_power)
	
#func spawn_and_shoot2() -> void:
	#var obj = object_scene2.instantiate()
	#obj.position = get_viewport_rect().size / 2
	#add_child(obj)
	#print(obj, obj.get_class())
#
	#await get_tree().physics_frame
#
	#var angle = deg_to_rad(shoot_angle_degrees)
	#var dir = Vector2.RIGHT.rotated(angle)
	#obj.hit_ball(dir, shoot_power)
#
#func spawn_and_shoot3() -> void:
	#var obj = object_scene3.instantiate()
	#obj.position = get_viewport_rect().size / 2
	#add_child(obj)
	#print(obj, obj.get_class())
#
	#await get_tree().physics_frame
#
	#var angle = deg_to_rad(shoot_angle_degrees)
	#var dir = Vector2.RIGHT.rotated(angle)
	#obj.hit_ball(dir, shoot_power)
