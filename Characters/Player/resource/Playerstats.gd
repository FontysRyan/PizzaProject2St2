extends Resource
class_name Playerstats

# --- Health ---
@export var max_health: float = 100
@export var start_health: float = 100
@export var invincibility_time: float = 0.3

# --- Movement ---
@export var move_speed: float = 200

# --- Combat ---
@export var damage: float = 25
@export var shoot_cooldown: float = 0.5
@export var charge_time: float = 1.5
@export var knockback_strength: float = 300

# --- Ammo ---
@export var amount_of_golf_balls: int = 1

# -- Signals ---
@export var has_ball: bool = true
