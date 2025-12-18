extends base_enemy

@onready var timer : Timer = Timer.new() 

func _ready() -> void:
	super._ready()
	timer.one_shot = false
	if not is_instance_of(stats, MinibossResource):
		push_warning("Wrong resource inserted for miniboss")
		return
	timer.wait_time = stats.ability_cooldown
	timer.autostart = true
	timer.timeout.connect(use_ability)

func use_ability():
	pass
