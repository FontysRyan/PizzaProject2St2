extends melee_enemy

@export var stat_increments : float = 5.0
@export var stat_increment_cooldown : float = 1.1 # 1.1 = 10% increase. 1+(amount%/100)
var stat_increase_cooldown : float = stat_increment_cooldown

func _physics_process(delta: float) -> void:
	stat_increase_cooldown -= delta
	if stat_increase_cooldown <= 0:
		stat_increase_cooldown = stat_increment_cooldown
		damage *= stat_increments
		attack_speed *= (1-stat_increments)
		#speed *= stat_increments # idk if this is balanced so i comment it out for now
	super._physics_process(delta)
