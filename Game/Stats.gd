extends Node


var current_floor : int = 0
var damage_dealt : float = 0
var damage_taken : float = 0
var damage_healed : float = 0
var hits_dealt : int = 0
var hits_taken : int = 0
var bosses_killed : int = 0
var enemies_killed : int = 0
var rooms_explored : int = 0

func clear_all() -> void:
	current_floor = 0
	damage_dealt = 0
	damage_taken = 0
	damage_healed = 0
	hits_dealt = 0
	hits_taken = 0
	bosses_killed = 0
	enemies_killed = 0
	rooms_explored = 0

func increase_floor() -> void:
	current_floor += 1

func increase_damage_dealt(damage: float) -> void:
	damage_dealt += damage

func increase_damage_taken(damage: float) -> void:
	damage_taken += damage

func increase_damage_healed(damage: float) -> void:
	damage_healed += damage

func increase_hits_dealt() -> void:
	hits_dealt += 1

func increase_hits_taken() -> void:
	hits_taken += 1

func increase_bosses_killed() -> void:
	bosses_killed += 1

func increase_enemies_killed() -> void:
	enemies_killed += 1

func increase_rooms_explored() -> void:
	rooms_explored += 1
