extends melee_enemy

@export var stat_increments : float = 1.1 # 1.1 = 10% increase. 1+(amount%/100)
@export var stat_increment_cooldown : float = 5.0
var stat_increase_cooldown : float = stat_increment_cooldown

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	stat_increase_cooldown -= delta
	if stat_increase_cooldown <= 0:
		stat_increase_cooldown = stat_increment_cooldown
		damage *= stat_increments
		attack_speed /= stat_increments
		attack_speed = max(attack_speed, 0.1)
		#speed *= stat_increments # idk if this is balanced
