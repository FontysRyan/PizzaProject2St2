class_name Player
extends CharacterBody2D

# --- State ---
var facing := 1 # 1 = right, -1 = left (for flipping) (Had issues with it, me being silly willy (Ryan))
var was_mouse_down := false
var can_shoot := true

enum ShotState { IDLE, CHARGING, SHOT }
var shot_state := ShotState.IDLE

# --- Components ---
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var trajectory: Line2D = $Trajectory
@onready var charge_bar := $ChargeBar
@onready var pivot: Node2D = $PivotPoint

# --- Config ---
@export var AmountOfTrajectoryBounces := 10
@export var max_length := 500.0
@export var golf_ball_asset: PackedScene
@export var ball_spawn_offset: Vector2 = Vector2(24, 0)
@export var stats: Playerstats

const NORMAL_SCALE_X := 0.2
var is_charging_anim_playing := false   
const LAYER_BALLS := 1 << 1 # Layer 2 = Ball, ignore this layer when casting trajectory
# --- Stats ---
var start_health: float
var move_speed: float


func _ready():
	if stats == null:
		push_error("Playerstats not assigned!!")
		return
	start_health = stats.start_health
	Stats.max_health = start_health
	move_speed = stats.move_speed
	#stats.amount_of_golf_balls
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

	var charge_percent: float = float(charge_bar.get_charge_percent())
	var remaining_length: float = lerp(0.0, max_length, charge_percent)

	var space := get_world_2d().direct_space_state
	var current_pos: Vector2 = global_position

	trajectory.clear_points()
	trajectory.add_point(Vector2.ZERO)

	for i in range(AmountOfTrajectoryBounces):
		var end_pos: Vector2 = current_pos + dir * remaining_length

		var query := PhysicsRayQueryParameters2D.create(current_pos, end_pos)
		query.exclude = [self]
		query.collision_mask = ~LAYER_BALLS # Ignore balls


		var result: Dictionary = space.intersect_ray(query)

		if not result.is_empty():
			var hit_pos: Vector2 = result["position"]
			var normal: Vector2 = result["normal"]

			trajectory.add_point(to_local(hit_pos))
			remaining_length -= current_pos.distance_to(hit_pos)

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

	# Disable movement while shooting
	if shot_state == ShotState.IDLE:
		if Input.is_action_pressed("right"):
			direction.x += 1
		if Input.is_action_pressed("left"):
			direction.x -= 1
		if Input.is_action_pressed("down"):
			direction.y += 1
		if Input.is_action_pressed("up"):
			direction.y -= 1

	velocity = direction.normalized() * move_speed
	move_and_slide()

	# --- Flip Character ---
	if shot_state == ShotState.IDLE:
		# Flip by movement
		if direction.x < 0:
			pivot.scale.x = -1
			facing = -1
		elif direction.x > 0:
			pivot.scale.x = 1
			facing = 1
	else:
		# Flip by aim while shooting
		var aim_x := get_aim_direction().x
		if aim_x < 0:
			pivot.scale.x = -1
			facing = -1
		elif aim_x > 0:
			pivot.scale.x = 1
			facing = 1

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

	# --- Animation for Movement ---
	if direction != Vector2.ZERO and shot_state == ShotState.IDLE:
		if anim_player.current_animation != "WALK":
			anim_player.play("WALK")
	elif shot_state == ShotState.IDLE:
		anim_player.play("RESET")


# ---------------------------------------------------
# BALL LOGIC
# ---------------------------------------------------
func can_spawn_ball() -> bool:
	return stats.amount_of_golf_balls > 0


func spawn_ball(force: float) -> void:
	if golf_ball_asset == null:
		push_error("golf_ball_asset is not assigned")
		return

	var dir: Vector2 = get_aim_direction()

	var ball := golf_ball_asset.instantiate()
	get_tree().current_scene.add_child(ball)

	stats.amount_of_golf_balls -= 1
	stats.has_ball = stats.amount_of_golf_balls > 0
	GameController.has_ball = stats.has_ball
	ball.global_position = global_position + dir * 60.0

	await get_tree().physics_frame
	ball.hit_ball(dir, force)



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
	Stats.current_health = start_health
	if start_health <= 0:
		queue_free()


func pickup_golf_ball(amount: int = 1):
	print("Player pickup_golf_ball CALLED")
	print("Before:", stats.amount_of_golf_balls)

	stats.amount_of_golf_balls += amount
	stats.has_ball = true
	GameController.has_ball = true
