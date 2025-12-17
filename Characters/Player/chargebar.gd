extends TextureProgressBar

signal charge_released(force: float)

# --- CONFIG ---
@export var max_charge: float = 100.0
@export var charge_speed: float = 120.0  # units per second
@export_range(0, 1) var yellow_threshold: float = 0.5
@export_range(0, 1) var red_threshold: float = 0.8
@export var scale_factor: float = 2.0  # 1 = normal, 2 = double size

@export var green_texture: Texture2D
@export var yellow_texture: Texture2D
@export var red_texture: Texture2D
@export var background_texture: Texture2D

# --- STATE ---
var charging: bool = false
var releasing: bool = false
var charge_value: float = 0.0
var direction: float = 1.0  # 1 = increasing, -1 = decreasing

# --- GODOT CALLBACKS ---
func _ready():
	# Set up the bar
	min_value = 0
	max_value = max_charge
	value = 0
	fill_mode = TextureProgressBar.FILL_LEFT_TO_RIGHT
	texture_under = background_texture
	texture_progress = green_texture

	# Center pivot for proper scaling
	pivot_offset = size / 2
	position += pivot_offset  # Optional: adjust position to keep center in place

	# Apply node scaling
	scale = Vector2(scale_factor, scale_factor)

	visible = false
	modulate.a = 1.0


func _process(delta: float) -> void:
	if not charging:
		return

	# Update charge value
	charge_value += charge_speed * direction * delta

	# Reverse direction at min/max
	if charge_value >= max_charge:
		charge_value = max_charge
		direction = -1
	elif charge_value <= 0:
		charge_value = 0
		direction = 1

	value = charge_value
	_update_color()

# --- COLOR LOGIC ---
func _update_color() -> void:
	var percent := charge_value / max_charge

	if percent >= red_threshold:
		texture_progress = red_texture
	elif percent >= yellow_threshold:
		texture_progress = yellow_texture
	else:
		texture_progress = green_texture

# --- CHARGE CONTROL ---
func start_charging() -> void:
	if charging:
		return

	charging = true
	releasing = false
	charge_value = 0
	direction = 1

	value = 0
	visible = true
	modulate.a = 1.0
	texture_progress = green_texture
	texture_under = background_texture

func release_charge() -> void:
	if releasing:
		return

	charging = false
	releasing = true

	# Snap to prevent float noise
	var final_force: float = snapped(charge_value, 0.1)
	emit_signal("charge_released", final_force)

	await _blink()
	await _fade_out()
	_reset()

# --- EFFECTS ---
func _blink() -> void:
	for i in range(3):
		visible = false
		await get_tree().create_timer(0.08).timeout
		visible = true
		await get_tree().create_timer(0.08).timeout

func _fade_out() -> void:
	var t := 0.0
	while t < 0.25:
		t += get_process_delta_time()
		modulate.a = lerp(1.0, 0.0, t / 0.25)
		await get_tree().process_frame

# --- RESET ---
func _reset() -> void:
	charge_value = 0
	value = 0
	direction = 1
	releasing = false
	visible = false
	modulate.a = 1.0
	texture_progress = green_texture

# --- OPTIONAL: Resize method for precise control ---
func _update_size(original_size: Vector2) -> void:
	# Set exact size for bar, e.g., original 100x20 pixels
	size = original_size * scale_factor
