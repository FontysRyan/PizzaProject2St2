extends CharacterBody2D

@export var speed := 200
var isFlipped := false
var was_mouse_down := false

@export var AmountOfTrajectoryBounces := 10
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var trajectory: Line2D = $Trajectory

const NORMAL_SCALE_X := 0.2
@export var max_length := 2000.0
@onready var charge_bar := $ChargeBar  # path to your TextureProgressBar

func _ready():
	charge_bar.charge_released.connect(_on_charge_released)


func get_aim_direction() -> Vector2:
	return (get_global_mouse_position() - global_position).normalized()


func update_trajectory():
	var dir = get_aim_direction()
	var remaining_length = max_length

	var space = get_world_2d().direct_space_state
	var current_pos = global_position

	trajectory.clear_points()
	trajectory.add_point(Vector2.ZERO)

	for i in range(AmountOfTrajectoryBounces):
		var end_pos = current_pos + dir * remaining_length

		var query = PhysicsRayQueryParameters2D.create(current_pos, end_pos)
		query.exclude = [self]

		var result = space.intersect_ray(query)

		if result:
			var hit_pos = result.position
			var normal = result.normal

			trajectory.add_point(to_local(hit_pos))

			remaining_length -= current_pos.distance_to(hit_pos)
			dir = dir.bounce(normal)
			current_pos = hit_pos
		else:
			trajectory.add_point(to_local(end_pos))
			break



func _process(_delta):
	update_trajectory()



func _physics_process(_delta):
	var direction = Vector2.ZERO

	# --- Movement input ---
	if Input.is_action_pressed("right"):
		direction.x = 1
	if Input.is_action_pressed("left"):
		direction.x = -1
	if Input.is_action_pressed("down"):
		direction.y = 1
	if Input.is_action_pressed("up"):
		direction.y = -1

	# --- Charge bar with mouse hold / release ---
	var mouse_down := Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)

	if mouse_down and not was_mouse_down:
		charge_bar.start_charging()

	elif not mouse_down and was_mouse_down:
		charge_bar.release_charge()

	was_mouse_down = mouse_down  # update state for next frame

	# --- Movement ---
	direction = direction.normalized()
	velocity = direction * speed
	move_and_slide()

	# Flip visuals
	if direction.x < 0 and not isFlipped:
		scale.x = -NORMAL_SCALE_X
		isFlipped = true
	elif direction.x > 0 and isFlipped:
		scale.x = -NORMAL_SCALE_X
		isFlipped = false

	# Animation
	if direction != Vector2.ZERO:
		if anim_player.current_animation != "WALK":
			anim_player.play("WALK")
	else:
		anim_player.play("RESET")


func _on_charge_released(force: float):
	# Calculate direction from player to mouse
	var direction = (get_global_mouse_position() - global_position).normalized()
	
	# Call your existing ball hit function (replace with your code)
	hit_ball(direction, force)
func hit_ball(direction: Vector2, force: float):
	# Placeholder function to demonstrate hitting the ball
	print("Hitting ball in direction: ", direction, " with force: ", force)
