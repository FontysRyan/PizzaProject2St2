extends base_enemy
class_name boss

@onready var timer : Timer = Timer.new()

func _ready() -> void:
	super._ready()
	timer.one_shot = false
	add_child(timer)
	timer.wait_time = stats.ability_cooldown
	timer.autostart = true
	timer.timeout.connect(use_ability)
	timer.start()

func use_ability():
	print("no ability implemented")
