# BaseBall.gd
extends RigidBody2D
class_name BaseBall

@export var physics_mode: PhysicsMode
@export var split_mode: SplitMode
@export var special_modes: Array[SpecialMode] = []
@export var total_push_power: float = 1000.0
@export var is_real: bool = true   # track original ball
@export var Can_Damage: bool = true #track damaga capabilities
@export var original_radius: float = 20.0

func _ready():
	contact_monitor = true
	max_contacts_reported = 1
	connect("body_entered", Callable(self, "_on_body_entered"))
	#original_radius = $CollisionShape2D.shape.radius
	if physics_mode:
		physics_mode.on_added(self)
		print(physics_mode.mode_name)  # prints "HeavyMode"
	if split_mode:
		split_mode.on_added(self)
	for mode in special_modes:
		mode.on_added(self)
func _on_body_entered(body):

	#if body is CharacterBody2D:
		#apply_central_impulse(
			#(global_position - body.global_position).normalized() * 200.0
		#)
	on_hit(body)

func on_hit(target):
	#print("ddd")
	#print(target.get_groups())
	if target.is_in_group("Player") and is_real:
		if target.has_method("pickup_golf_ball"):
			target.pickup_golf_ball()

		is_real = false
		Can_Damage = false
		can_sleep = true
		#freeze_mode = RigidBody2D.FREEZE_MODE_STATIC
		physics_material_override.friction = 10000
		#vanish_now()
		return
	if physics_mode:
		physics_mode.on_hit(self, target)
	if split_mode:
		split_mode.on_hit(self, target)
	for mode in special_modes:
		mode.on_hit(self, target)
		
#func vanish_now():
	#linear_velocity = Vector2(0,0)
	#angular_velocity = 0
	#linear_damp = 100
	#angular_damp = 100
	#
	#collision_layer = 0
	#collision_mask = 0
	#visible = false
	#sleeping = true
	#queue_free()
	##call_deferred("queue_free")

func hit_ball(direction: Vector2, power: float) -> void:
	gravity_scale = 0 # optional
	set_sleeping(false)
	power /= 100.0
	print("eeeee: " , power)
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

func spawn_split_child(velocity: Vector2, is_real_child := false) -> BaseBall:
	var child := duplicate() as BaseBall
	#child.Set_size(10,mass)
	child.is_real = is_real_child
	child.linear_velocity = velocity
	child.global_position = global_position
	get_parent().add_child(child)
	return child
