extends Node2D

@export var float_distance := 10.0
@export var duration: float = 5.0

@onready var label: Label = $Label

func setup(amount: float, damage_type: String) -> void:
	label.text = str(amount)

	match damage_type:
		"crit":
			label.modulate = Color.RED
		"heal":
			label.modulate = Color.GREEN
		_:
			label.modulate = Color.WHITE

	animate()

func animate() -> void:
	var tween := create_tween()
	tween.tween_property(
		self,
		"position:y",
		position.y - float_distance,
		duration
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	tween.parallel().tween_property(
		self,
		"modulate:a",
		0.0,
		duration
	)

	tween.finished.connect(queue_free)
