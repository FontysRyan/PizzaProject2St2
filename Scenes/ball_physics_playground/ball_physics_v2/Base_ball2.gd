# BaseBall.gd
extends RigidBody2D
class_name BaseBall

@export var ball_stats: Ball
@export var physics_mode: PhysicsMode
@export var split_mode: SplitMode
@export var special_modes: Array[SpecialMode] = []
@export var total_push_power: float = 1000.0
@export var is_real: bool = true   # track original ball
@export var Can_Damage: bool = true #track damaga capabilities
@export var original_radius: float = 20.0
var base_knockback: float = 1

@export var pickup_delay: float = 1
var can_be_picked_up: bool = true
@onready var enable_mask_timer := get_tree().create_timer(2.0)

func _ready():

	add_to_group("Golf_Balls")
	$AnimatedSprite2D.sprite_frames = ball_stats.sprite_frames
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
	await enable_mask_timer.timeout
	set_collision_mask_value(1, true)

func _on_body_entered(body):

	#if body is CharacterBody2D:
		#apply_central_impulse(
			#(global_position - body.global_position).normalized() * 200.0
		#)
	on_hit(body)

var last_enemy_hit_time: float = 0.0

func on_hit(target):
	# Physics modes always apply
	if physics_mode:
		physics_mode.on_hit(self, target)

	# Special modes always apply
	for mode in special_modes:
		mode.on_hit(self, target)

	# Player pickup (real balls only)
	if target.is_in_group("Player") and is_real:
		if target.has_method("pickup_golf_ball"):
			target.pickup_golf_ball()
			is_real = false
		vanish_now()
		return

	# Real ball hits anything except player → split
	if is_real and not target.is_in_group("Player") and split_mode:
		split_mode.on_hit(self, target)

	# Enemy hit → damage (real or fake)
	if target.is_in_group("Enemy"):
		var now = Time.get_ticks_msec() / 1000.0
		if now - last_enemy_hit_time >= 0.1:
			last_enemy_hit_time = now
			trigger_enemy_hit(target)

	# Fake balls vanish on any collision
	if not is_real:
		vanish_now()
		return

func trigger_enemy_hit(target):
	print("Hit accepted (0.1s passed)")
	if target.has_method("take_damage"):
			target.take_damage(ball_stats.damage)
			DamageNumberManager.show_damage(ball_stats.damage, target.global_position + Vector2(0, -90))
	if target.has_method("take_knockback"):
			target.take_knockback(200.0 * base_knockback, self.global_position, base_enemy.knockback_source.BALL)



		
func vanish_now():
	print("VANISH")
	collision_layer = 0
	collision_mask = 0
	visible = false
	sleeping = true
	call_deferred("queue_free")


func hit_ball(direction: Vector2, power: float) -> void:
	gravity_scale = 0
	set_sleeping(false)

	can_be_picked_up = false
	get_tree().create_timer(pickup_delay).timeout.connect(
		func(): can_be_picked_up = true
	)

	power /= 100.0
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
	
	var sprite = child.get_node("AnimatedSprite2D")
	if sprite:
		if not child.is_real:
			sprite.modulate = Color(0.37, 0.37, 0.37, 1.0)  # darker white
		else:
			sprite.modulate = Color(1, 1, 1)        # normal white
	get_parent().add_child(child)
	return child
