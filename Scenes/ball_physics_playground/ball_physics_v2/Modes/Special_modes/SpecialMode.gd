extends Resource
class_name SpecialMode

## ----------------------
## Identity
## ----------------------
@export var id: String
@export var name: String
@export var description: String
@export var tags: Array[String] = []

## ----------------------
## Application
## ----------------------
@export_range(0.0, 1.0, 0.01)
var apply_chance: float = 1.0   # 1.0 = always applied

@export var duration: float = 0.0        # 0 = instant or permanent
@export var tick_interval: float = 0.0   # 0 = apply once

## ----------------------
## Targeting
## ----------------------
enum TargetType { SELF, ALLY, ENEMY }
@export var primary_target: TargetType = TargetType.ENEMY
@export var secondary_target: TargetType = TargetType.SELF

## ----------------------
## Stacking
## ----------------------
@export var max_stacks: int = 1           # hard cap
@export var base_stack_power: float = 1.0 # power at 1 stack

## ----------------------
## Damage / Healing
## ----------------------
@export var flat_damage: float = 0.0
@export var percent_max_hp_damage: float = 0.0

@export var flat_heal: float = 0.0
@export var percent_max_hp_heal: float = 0.0

## ----------------------
## Control Effects
## ----------------------
@export var stun_duration: float = 0.0    # seconds
@export var slow_multiplier: float = 1.0  # 1.0 = no slow

## ----------------------
## Secondary Effect
## ----------------------
@export var secondary_effect: SpecialMode

@export_range(0.0, 1.0, 0.01)
var secondary_chance: float = 0.0

## ----------------------
## Conditional Modifiers
## ----------------------
@export var required_target_tags: Array[String] = []
@export var conditional_multiplier: float = 1.0
