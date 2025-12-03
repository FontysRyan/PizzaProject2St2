extends RigidBody2D

@export var initial_impulse: float = 1200.0        # how hard you throw it
@export var drift_strength: float = 1200.0          # base strength of drift (tune this)
@export var drift_change_speed: float = 1.2        # how quickly wind direction changes
@export var drift_start_speed: float = 150.0       # drift only above this speed
@export var use_mass_scaling: bool = true          # scale drift by mass (helpful)

var noise := FastNoiseLite.new()
var t := 0.0

func _ready():
	noise.seed = randi()
	noise.frequency = 0.9
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX

	# initial throw to the right (change as needed)
	apply_central_impulse(Vector2.RIGHT * initial_impulse)


func _physics_process(delta: float) -> void:
	var speed = linear_velocity.length()

	# no drift if too slow
	if speed < drift_start_speed:
		return

	t += delta * drift_change_speed
	var n = noise.get_noise_1d(t)   # -1 .. 1

	# sideways direction relative to current movement
	var sideways = linear_velocity.rotated(PI * 0.5)
	if sideways.length() == 0:
		return
	sideways = sideways.normalized()

	# scale drift by speed so faster movement -> more drift (optional)
	var speed_factor = clamp(speed / 400.0, 0.2, 2.0)

	# compute impulse to apply this frame (force * delta -> impulse)
	var frame_impulse = sideways * (n * drift_strength * speed_factor * delta)

	# optionally scale by mass so big/heavy balls still feel the wind
	if use_mass_scaling:
		frame_impulse *= mass

	# apply as a central impulse so it's always effective
	apply_central_impulse(frame_impulse)


	# -- debug (uncomment to see values in the output) --
	# if Engine.is_editor_hint() == false:
	#     print("speed: ", speed, " n:", n, " impulse:", frame_impulse)
