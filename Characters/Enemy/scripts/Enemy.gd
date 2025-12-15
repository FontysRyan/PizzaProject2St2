extends CharacterBody2D
class_name base_enemy

@onready var nav_agent : NavigationAgent2D = $"NavigationAgent2D"
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@export var speed : float = 200 
@export var health : float = 50
@export var stop_distance : float = 120 # the distance (in pixels) of how far from the player the enemy should stop
@export var attack_speed : float = 2 # seconds per attack
@export var damage : float = 30
@export var poison_damage_multiplier : float = 0.015
const NORMAL_SCALE_X := 0.2  # used for flipping. idk why we do it this way
var repath_cooldown : float = 0.0
var in_range : bool = false
var player : Node2D
var isFlipped : bool = false
var attack_cooldown : float = 0
var poison_active : bool = false
var poison_stacks : float = 0
var poison_cooldown : float = 1
var is_frozen : bool = false
var frozen_cooldown : float = 2
var frozen_stacks : float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("Enemy")
	nav_agent.target_desired_distance = 10000.0
	nav_agent.path_desired_distance = 5000.0
	
	await NavigationServer2D.map_changed
	
	var players = get_tree().get_nodes_in_group("Player")
	if players.size() > 0:
		player = players[0]
		nav_agent.target_position = player.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if not player:
		return
	
	attack_cooldown -= delta
	
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
		nav_agent.target_position = player.global_position
		repath_cooldown = 0.2
	
	if is_frozen:
		return
	
	if nav_agent.is_target_reachable():
		var next_pos = nav_agent.get_next_path_position()
		var dir = (next_pos - global_position).normalized()
		
		if dir.x < 0 and not isFlipped:
			scale.x = -NORMAL_SCALE_X
			isFlipped = true
		elif dir.x > 0 and isFlipped:
			scale.x = -NORMAL_SCALE_X ## Bruh, but works.
			isFlipped = false
		
		if global_position.distance_to(next_pos) < stop_distance:
			velocity = Vector2.ZERO
			if anim_player.current_animation != "RESET":
				anim_player.play("RESET")
			attack(player)
			return
		
		velocity = dir * speed
		move_and_slide()
		
		if dir != Vector2.ZERO:
			if anim_player.current_animation != "WALK":
				anim_player.play("WALK")

func take_damage(amount: float):
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
		

func attack(target: CharacterBody2D):
	push_warning("no attack func override")
