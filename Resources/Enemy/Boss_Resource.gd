class_name BossResource
extends MinibossResource

func check_level() -> void:
	match level:
		1:
			pass
		2: 
			max_health *= 1.8
			damage *= 1.05
		3:
			max_health *= 2.9
			damage *= 1.5
		4:
			max_health *= 4.3
			damage *= 5
		5:
			max_health *= 6
			damage *= 10
		_:
			pass
