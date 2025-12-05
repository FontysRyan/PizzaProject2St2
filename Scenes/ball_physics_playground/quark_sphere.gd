extends Base_Ball

@export var base_speed: float = 500.0
@export var direction_change_speed: float = 1.5   # how fast direction wiggles
@export var direction_noise_strength: float = 0.8 # how curved the path is

var noise := FastNoiseLite.new()
var t := 0.0

func _ready():
	noise.seed = randi()
	noise.frequency = 0.8
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	
	# give initial random direction
	linear_velocity = Vector2.RIGHT.rotated(randf() * TAU) * base_speed

func _physics_process(delta: float):
	t += delta * direction_change_speed

	# Get a noise value between -1 and +1
	var n = noise.get_noise_1d(t)

	# Turn that into a small rotation angle
	var angle_change = n * direction_noise_strength

	# Rotate current velocity by that angle
	linear_velocity = linear_velocity.rotated(angle_change)

	# Keep speed constant
	linear_velocity = linear_velocity.normalized() * base_speed
