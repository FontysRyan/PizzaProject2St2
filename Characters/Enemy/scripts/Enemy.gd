extends CharacterBody2D
class_name base_enemy

# special values like constants, onready, and export values
@onready var nav_agent : NavigationAgent2D = $NavigationAgent2D
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@export var speed : float = 150 
@export var poison_damage_multiplier : float = 0.015
@export var stats : EnemyResource
var NORMAL_SCALE_X := 0.2  # used for flipping. idk why we do it this way

# stat specific values. get pulled from the EnemyResource
var health : float
var attack_speed : float
var stop_distance : float
var damage : float
var resistance : float
# var speed : float

# values that you shouldnt worry about
var repath_cooldown : float = 0.0
var in_range : bool = false
var player : Node2D
var isFlipped : bool = false
var attack_cooldown : float = 1
var poison_active : bool = false
var poison_stacks : float = 0
var poison_cooldown : float = 1
var is_frozen : bool = false
var frozen_cooldown : float = 2
var frozen_stacks : float = 0
var is_attacking : bool = false
var kb_velocity : Vector2


func _ready() -> void:
	NORMAL_SCALE_X = scale.x
	add_to_group("Enemy")
	nav_agent.target_desired_distance = 10000.0
	nav_agent.path_desired_distance = 5000.0
	
	await NavigationServer2D.map_changed
	
	var players = get_tree().get_nodes_in_group("Player")
	if players.size() > 0:
		player = players[0]
		nav_agent.target_position = player.position
	stats.level = roll_value(Stats.current_floor)
	set_stats()

func roll_value(floor_number: int) -> int:
	if floor_number >= 10:
		return 5
	
	var weights := {}
	
	# Base weights
	weights[1] = max(0, 10 - floor_number * 2)
	weights[2] = max(0, floor_number - 1)
	weights[3] = max(0, floor_number - 3)
	weights[4] = max(0, floor_number - 6)
	weights[5] = max(0, floor_number - 8)
	
	return weighted_random(weights)

func weighted_random(weights: Dictionary) -> int:
	var total := 0
	for w in weights.values():
		total += w
	
	var roll := randi_range(1, total)
	var running := 0
	
	for key in weights.keys():
		running += weights[key]
		if roll <= running:
			return key
	
	return weights.keys()[0] # fallback

func set_stats() -> void:
	stats.check_level()
	health = stats.current_max_health
	
	if stats.attack_speed == 0:
		attack_speed = 0
	else:
		attack_speed = 1/stats.attack_speed
	
	stop_distance = stats.attack_range * 20
	damage = stats.current_damage
	resistance = stats.resistance
	#speed = stats.movement_speed


func _physics_process(delta: float) -> void:
	if not player:
		return
	
	frozen_cooldown -= delta
	if frozen_cooldown == 0:
		is_frozen = false
	
	if poison_active:
		poison_cooldown -= delta
		if poison_cooldown <= 0:
			poison_cooldown = 1
			take_damage(health * poison_damage_multiplier * poison_stacks)
	
	repath_cooldown -= delta
	if repath_cooldown <= 0:
		retarget()
		repath_cooldown = 0.2
	
	if is_frozen:
		return
	
	if is_attacking:
		return
	
	attack_cooldown -= delta
	
	if nav_agent.is_target_reachable():
		var next_pos = nav_agent.get_next_path_position()
		var dir = (next_pos - global_position).normalized()
		
		if dir.x < 0 and not isFlipped:
			scale.x = -NORMAL_SCALE_X
			isFlipped = true
		elif dir.x > 0 and isFlipped:
			scale.x = -NORMAL_SCALE_X ## Bruh, but works.
			isFlipped = false
		
		if global_position.distance_to(player.global_position) < stop_distance:
			velocity = Vector2.ZERO
			dir = Vector2.ZERO
			if anim_player:
				if anim_player.current_animation != "RESET":
					anim_player.play("RESET")
				attack(player)
			return
		
		velocity = dir * speed
		if kb_velocity != Vector2.ZERO:
			velocity = kb_velocity
			kb_velocity *= 0.9
			if kb_velocity < Vector2(1.6, 1.6):
				kb_velocity = Vector2.ZERO
				velocity = dir * speed
		move_and_slide()
		
		if dir != Vector2.ZERO:
			if anim_player:
				if anim_player.current_animation != "WALK":
					anim_player.play("WALK")


func take_damage(amount: float, _damage_source: Base_Ball = null):
	health -= amount
	if health <= 0:
		queue_free()

func apply_effect(effect: float):
	match effect:
		1:
			poison_active = true
			if not poison_stacks >= 10:
				poison_stacks += 1
			else:
				poison_stacks = 10
		2:
			is_frozen = true
			frozen_stacks += 1
			if frozen_stacks <= 5:
				frozen_cooldown = 2

func attack(_target: CharacterBody2D):
	push_warning("no attack func override")

func take_knockback(force: float, location_of_origin: Vector2, _type: knockback_source):
	var dir := global_position - location_of_origin
	if dir == Vector2.ZERO:
		return
	
	dir = dir.normalized()
	
	var resistance_factor : float = 1.0 - clamp(resistance, 0, 100) / 100.0
	if resistance_factor <= 0.0:
		return
	
	kb_velocity = dir * force * resistance_factor

func retarget():
	var players = get_tree().get_nodes_in_group("Player")
	if players.size() > 0:
		player = players[0]
		nav_agent.target_position = player.position



enum knockback_source {
	BALL,
	STICK,
}
