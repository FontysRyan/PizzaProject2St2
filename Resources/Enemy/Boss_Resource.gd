class_name BossResource
extends MinibossResource

func check_level() -> void:
	match level:
		1:
			pass
		2: 
			current_max_health = max_health * 1.8
			current_damage = damage * 1.05
		3:
			current_max_health = max_health * 2.9
			current_damage = damage * 1.5
		4:
			current_max_health = max_health * 4.3
			current_damage = damage * 5
		5:
			current_max_health = max_health * 6
			current_damage = damage * 10
		_:
			pass
