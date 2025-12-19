extends TextureProgressBar

signal charge_released(force: float)

@export_category("Charge")
@export var max_charge: float = 100.0
@export var charge_speed: float = 120.0

@export_category("Thresholds")
@export_range(0, 1) var yellow_threshold: float = 0.5
@export_range(0, 1) var red_threshold: float = 0.8

@export_category("Textures")
@export var green_texture: Texture2D
@export var yellow_texture: Texture2D
@export var red_texture: Texture2D

var charging: bool = false
var charge_value: float = 0.0
var direction: float = 1.0
var fade_tween: Tween = null


func _ready() -> void:
	min_value = 0
	max_value = max_charge
	value = 0
	hide()


func _process(delta: float) -> void:
	if not charging:
		return

	charge_value += charge_speed * direction * delta

	if charge_value >= max_charge:
		charge_value = max_charge
		direction = -1.0
	elif charge_value <= 0.0:
		charge_value = 0.0
		direction = 1.0

	value = charge_value
	_update_color()


func start_charging() -> void:
	if charging:
		return

	charging = true
	charge_value = 0.0
	direction = 1.0
	value = 0.0
	modulate.a = 1.0
	show()
	_update_color()


func release_charge() -> void:
	if not charging:
		return

	charging = false

	var final_force: float = snapped(charge_value, 0.1)
	emit_signal("charge_released", final_force)

	_play_fade_out()


func _update_color() -> void:
	var percent: float = charge_value / max_charge

	if percent >= red_threshold:
		texture_progress = red_texture
	elif percent >= yellow_threshold:
		texture_progress = yellow_texture
	else:
		texture_progress = green_texture


func _play_fade_out() -> void:
	if fade_tween != null:
		fade_tween.kill()

	fade_tween = create_tween()
	fade_tween.tween_property(self, "modulate:a", 0.0, 0.25)
	fade_tween.finished.connect(_reset)


func _reset() -> void:
	charge_value = 0.0
	value = 0.0
	direction = 1.0
	hide()
	modulate.a = 1.0

func get_charge_percent() -> float:
	if max_charge <= 0:
		return 0.0
	return charge_value / max_charge
