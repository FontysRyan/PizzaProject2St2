class_name MinibossResource
extends EnemyResource

@export var ability_cooldown : float = 20
@export var ability_name : String
@export var passive_ability_name : String

func check_level() -> void:
	match level:
		1:
			pass
		2: 
			max_health *= 1.5
			damage *= 1.4
		3:
			max_health *= 2.1
			damage *= 1.8
		4:
			max_health *= 3
			damage *= 2.4
		5:
			max_health *= 3.7
			damage *= 3
		_:
			pass
