extends CharacterBody2D
class_name base_enemy

@onready var nav_agent : NavigationAgent2D = $"NavigationAgent2D"
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@export var speed : float = 200 
@export var health : float = 50
@export var stop_distance : float = 120 # the distance (in pixels) of how far from the player the enemy should stop
@export var attack_speed : float = 2 # seconds per attack
@export var damage : float = 30
const NORMAL_SCALE_X := 0.2  # used for flipping. idk why we do it this way
var repath_cooldown : float = 0.0
var in_range : bool = false
var player : Node2D
var isFlipped : bool = false
var attack_cooldown : float = 0

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
	
	repath_cooldown -= delta
	if repath_cooldown <= 0:
		nav_agent.target_position = player.global_position
		repath_cooldown = 0.2
	
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

func attack(target: CharacterBody2D):
	push_warning("no attack func override")
