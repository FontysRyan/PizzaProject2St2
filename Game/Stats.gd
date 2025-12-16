extends Node


var current_floor : int
var damage_dealt : float
var damage_taken : float
var damage_healed : float
var hits_dealt : int
var hits_taken : int
var bosses_killed : int
var enemies_killed : int
var rooms_explored : int

func increase_floor() -> void:
	current_floor += 1

func increase_damage_dealt(damage: float) -> void:
	damage_dealt += damage

func increase_damage_taken(damage: float) -> void:
	damage_taken += damage

func increase_damage_healed(damage: float) -> void:
	damage_healed += damage
