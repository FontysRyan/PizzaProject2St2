class_name EnemyResource
extends Resource

@export var name : String
@export var max_health : float = 50
@export var damage : float = 30
@export var attack_range : float = 5
@export var attack_speed : float = 1
@export var resistance : float = 50
@export var movement_speed : float = 200

var level : int = 1

func check_level() -> void:
	match level:
		1:
			pass
		2: 
			max_health *= 1.4
			damage *= 1.3
		3:
			max_health *= 2
			damage *= 1.9
		4:
			max_health *= 2.8
			damage *= 3
		5:
			max_health *= 3.5
			damage *= 4.4
		_:
			pass
