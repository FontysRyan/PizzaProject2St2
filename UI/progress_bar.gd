extends ProgressBar


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	value = Stats.current_health
	max_value = Stats.max_health


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	value = Stats.current_health
	$CurrentHpLabel.text = str(Stats.current_health)
	$MaxHpLabel.text = str(Stats.max_health)
