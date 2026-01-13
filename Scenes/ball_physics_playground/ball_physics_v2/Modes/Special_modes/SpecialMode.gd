# SpecialMode.gd
extends Resource
class_name SpecialMode

## Identity
@export var effect_name: String
@export var description: String

## Lifetime
@export var is_permanent: bool = false
@export var duration: float = 0.0

## Stacking / Replacement
@export var is_stackable: bool = false
@export var max_stacks: int = 1
@export var stack_behavior: StackBehavior = StackBehavior.ADD

@export var can_replace_others: bool = false
@export var can_be_replaced: bool = true
@export var priority: int = 0
@export var replace_tags: Array[String] = []

enum StackBehavior {
	ADD,
	REFRESH,
	REPLACE,
	IGNORE
}

## Tick-based behavior
@export var uses_ticks: bool = false
@export var tick_interval: float = 1.0

## Damage / Healing
@export var deals_damage: bool = false
@export var damage_per_tick: float = 0.0

@export var heals: bool = false
@export var heal_per_tick: float = 0.0

## Control effects
@export var can_stun: bool = false
@export var stun_duration: float = 0.0

@export var can_slow: bool = false
@export var slow_percent: float = 0.0

## Stat modifiers
@export var modifies_speed: bool = false
@export var speed_multiplier: float = 1.0

@export var modifies_attack: bool = false
@export var attack_multiplier: float = 1.0

## Flags
@export var is_buff: bool = false
@export var is_debuff: bool = false
