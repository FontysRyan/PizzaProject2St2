extends CharacterBody2D
class_name base_enemy

# special values like constants, onready, and export values
@onready var nav_agent : NavigationAgent2D = $NavigationAgent2D
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@export var stats : EnemyResource
var NORMAL_SCALE_X := 0.2  # used for flipping. idk why we do it this way

# stat specific values. get pulled from the EnemyResource
var health : float
var attack_speed : float
var stop_distance : float
var damage : float
var resistance : float
var speed : float

# values that you shouldnt worry about
var repath_cooldown : float = 0.0
var in_range : bool = false
var player : Node2D
var isFlipped : bool = false
var attack_cooldown : float = 1
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
	damage = stats.damage
	resistance = stats.resistance
	speed = stats.movement_speed


func _physics_process(delta: float) -> void:
	if not player:
		return
	
	repath_cooldown -= delta
	if repath_cooldown <= 0:
		retarget()
		repath_cooldown = 0.2
	
	var dir := Vector2.ZERO
	
	if nav_agent.is_target_reachable():
		var next_pos = nav_agent.get_next_path_position()
		dir = (next_pos - global_position).normalized()
		
		if dir.x < 0 and not isFlipped:
			scale.x = -NORMAL_SCALE_X
			isFlipped = true
		elif dir.x > 0 and isFlipped:
			scale.x = -NORMAL_SCALE_X
			isFlipped = false
		
	if not is_attacking:
		attack_cooldown -= delta
	
	if not is_attacking and global_position.distance_to(player.global_position) < stop_distance:
		attack(player)
	
	if kb_velocity.length_squared() > 1.6:
		velocity = kb_velocity
		kb_velocity *= 0.9
	elif is_attacking:
		velocity = Vector2.ZERO
	else:
		velocity = dir * speed
	
	move_and_slide()
	
	if is_attacking:
		return
	
	if velocity.length_squared() > 1.0:
		if anim_player.current_animation != "attack" and anim_player.current_animation != "WALK":
			anim_player.play("WALK")
	else:
		if anim_player.current_animation != "RESET":
			anim_player.play("RESET")


func take_damage(amount: float, _damage_source: Base_Ball = null):
	health -= amount
	if health <= 0:
		queue_free()

func attack(target: CharacterBody2D):
	DamageNumberManager.show_damage("how does this work".to_int(), target.position, "crit")
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
