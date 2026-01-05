extends CharacterBody2D

# --- State ---
var isFlipped := false
var was_mouse_down := false
var can_shoot := true

enum ShotState { IDLE, CHARGING, SHOT }
var shot_state := ShotState.IDLE

# --- Components ---
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var trajectory: Line2D = $Trajectory
@onready var charge_bar := $ChargeBar

# --- Config ---
@export var AmountOfTrajectoryBounces := 10
@export var max_length := 500.0
@export var golf_ball_asset: PackedScene
@export var ball_spawn_offset: Vector2 = Vector2(24, 0)
@export var stats: Playerstats

const NORMAL_SCALE_X := 0.2
var is_charging_anim_playing := false   

# --- Stats ---
var start_health: float
var move_speed: float



func _ready():
	if stats == null:
		push_error("Playerstats not assigned!")
		return

	start_health = stats.start_health
	move_speed = stats.move_speed

	charge_bar.charge_released.connect(_on_charge_released)


# ---------------------------------------------------
# AIM & TRAJECTORY
# ---------------------------------------------------
func get_aim_direction() -> Vector2:
	return (get_global_mouse_position() - global_position).normalized()


func update_trajectory():
	if not can_spawn_ball() or shot_state == ShotState.IDLE:
		trajectory.clear_points()
		return

	var dir: Vector2 = get_aim_direction()
	var charge_percent: float = charge_bar.get_charge_percent()
	var remaining_length: float = lerp(0.0, max_length, charge_percent)



	var space := get_world_2d().direct_space_state
	var current_pos := global_position

	trajectory.clear_points()
	trajectory.add_point(Vector2.ZERO)

	for i in range(AmountOfTrajectoryBounces):
		var end_pos: Vector2 = current_pos + dir * remaining_length


		var query := PhysicsRayQueryParameters2D.create(current_pos, end_pos)
		query.exclude = [self]

		var result := space.intersect_ray(query)

		if result:
			var hit_pos: Vector2 = result.position
			var normal: Vector2 = result.normal

			trajectory.add_point(to_local(hit_pos))
			remaining_length -= current_pos.distance_to(hit_pos)

			# SAFETY CHECK BOUNCE
			if normal.length_squared() < 0.0001:
				break

			dir = dir.bounce(normal.normalized())
			current_pos = hit_pos
		else:
			trajectory.add_point(to_local(end_pos))
			break


# ---------------------------------------------------
# SHOOT FEEDBACK
# ---------------------------------------------------
func play_shot_trajectory_feedback():
	trajectory.default_color = Color.RED

	var tween := create_tween()
	tween.tween_property(trajectory, "modulate:a", 0.0, 0.25)
	tween.finished.connect(reset_trajectory)


func reset_trajectory():
	trajectory.clear_points()
	trajectory.modulate.a = 1.0
	trajectory.default_color = Color.WHITE
	shot_state = ShotState.IDLE


func start_shoot_cooldown():
	can_shoot = false
	await get_tree().create_timer(stats.shoot_cooldown).timeout
	can_shoot = true


# ---------------------------------------------------
# PROCESS
# ---------------------------------------------------
func _process(_delta):
	update_trajectory()


func _physics_process(_delta):
	var direction := Vector2.ZERO

	# --- Movement Input ---
	if Input.is_action_pressed("right"):
		direction.x += 1
	if Input.is_action_pressed("left"):
		direction.x -= 1
	if Input.is_action_pressed("down"):
		direction.y += 1
	if Input.is_action_pressed("up"):
		direction.y -= 1

	# --- Charging & Shooting ---
	var mouse_down := Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)

	if mouse_down and not was_mouse_down:
		if can_shoot and can_spawn_ball():
			shot_state = ShotState.CHARGING
			charge_bar.start_charging()
			anim_player.play("CHARGING_SHOT")
			is_charging_anim_playing = true

	elif mouse_down and was_mouse_down:
		if shot_state == ShotState.CHARGING and is_charging_anim_playing:
			anim_player.play("CHARGING_HOLDING")

	elif not mouse_down and was_mouse_down:
		if shot_state == ShotState.CHARGING:
			shot_state = ShotState.SHOT
			charge_bar.release_charge()
			anim_player.play("SHOOT")
			is_charging_anim_playing = false

	was_mouse_down = mouse_down

	# --- Apply Movement ---
	velocity = direction.normalized() * move_speed
	move_and_slide()

	# --- Flip Character ---
	if direction.x < 0 and not isFlipped:
		scale.x = -NORMAL_SCALE_X
		isFlipped = true
	elif direction.x > 0 and isFlipped:
		scale.x = NORMAL_SCALE_X
		isFlipped = false

	# --- Animation for Movement ---
	if direction != Vector2.ZERO:
		if shot_state == ShotState.IDLE:
			if anim_player.current_animation != "WALK":
				anim_player.play("WALK")
	else:
		if shot_state == ShotState.IDLE:
			anim_player.play("RESET")



# ---------------------------------------------------
# BALL LOGIC
# ---------------------------------------------------
func can_spawn_ball() -> bool:
	return stats.amount_of_golf_balls > 0


func spawn_ball(force: float):
	stats.amount_of_golf_balls -= 1

	var ball := golf_ball_asset.instantiate()
	get_tree().current_scene.add_child(ball)

	var direction := get_aim_direction()
	ball.global_position = global_position + direction * ball_spawn_offset.length()

	if ball.has_method("setup"):
		ball.setup(direction, force)

	print("Ball spawned | force:", force, "dir:", direction)


func _on_charge_released(force: float):
	if not can_spawn_ball():
		shot_state = ShotState.IDLE
		return

	spawn_ball(force)
	play_shot_trajectory_feedback()
	start_shoot_cooldown()


# ---------------------------------------------------
# DAMAGE & PICKUPS
# ---------------------------------------------------
func take_damage(amount: float):
	start_health = clamp(start_health - amount, 0, stats.max_health)
	if start_health <= 0:
		queue_free()


func pickup_golf_ball(amount: int = 1):
	stats.amount_of_golf_balls += amount
	print("Picked up balls:", stats.amount_of_golf_balls)
