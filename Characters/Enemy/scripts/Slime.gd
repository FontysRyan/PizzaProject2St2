extends base_enemy

@onready var timer : Timer = Timer.new()
@export var mini_slime : PackedScene
var mini_slimes_to_spawn : int = 3

func _ready() -> void:
	super._ready()
	timer.one_shot = false
	add_child(timer)
	if not is_instance_of(stats, MinibossResource):
		push_warning("Wrong resource inserted for miniboss")
		return
	timer.wait_time = stats.ability_cooldown
	timer.autostart = true
	timer.timeout.connect(use_ability)
	if timer: print("ability should work")
	timer.start()

func use_ability():
	var radius := 5.0
	
	for i in range(mini_slimes_to_spawn):
		var slime := mini_slime.instantiate()
		slime.scale = Vector2(0.2, 0.2)
		get_parent().add_child(slime)
		
		var angle := TAU * i / mini_slimes_to_spawn
		slime.position = position + Vector2(
			cos(angle),
			sin(angle)
		) * radius
		if slime.has_method("retarget"):
			slime.retarget()
