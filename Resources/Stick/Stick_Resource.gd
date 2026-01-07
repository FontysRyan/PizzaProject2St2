class_name Stick
extends Resource

@export var texture1 : Texture2D
@export var texture2 : Texture2D
@export var texture3 : Texture2D
@export var texture4 : Texture2D
@export var texture5 : Texture2D
@export var texture : Texture2D
#editable stats
@export var name: String
var level: int = 1
@export var power: float = 5
var current_power: float = 5
@export var charge: float = 10
var current_charge: float = 10
@export var cooldown: float = 5
@export var knockback: float = 10
@export var ability_cooldown: float = 0
@export var ability: Active_Ability = null

func _ready() -> void:
	texture = texture1

func check_level() -> void:
	match level:
		1:
			pass
		2: 
			current_power = power * 1.5
			current_charge = charge * 1.4
			texture = texture2
		3:
			current_power = power * 1.9
			current_charge = charge * 1.8
			texture = texture3
		4:
			current_power = power * 2.2
			current_charge = charge * 2.1
			texture = texture4
		5:
			current_power = power * 2.6
			current_charge = charge * 2.5
			texture = texture5
		_:
			pass
