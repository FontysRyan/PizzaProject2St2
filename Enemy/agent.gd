extends CharacterBody2D

@onready var nav_agent : NavigationAgent2D = $"NavigationAgent2D"
@export var speed : float = 200
@export var health : float = 50
var in_range : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	nav_agent.navigation_finished.connect(_on_nav_finished)
	nav_agent.velocity_computed.connect(_on_velocity_compute)
	
	var players = get_tree().get_nodes_in_group("Player")
	if players.size() > 0:
		var player : Node2D = players[0]
		make_path(player.global_position)
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not in_range:
		var next_path_pos = nav_agent.get_next_path_position()
		var direction = global_position.direction_to(next_path_pos)
		var new_velocity = direction * speed * delta
		nav_agent.velocity = new_velocity
	else:
		pass # hit logic
	
func _on_nav_finished():
	in_range = true
	
func _on_velocity_compute(safe_velocity):
	velocity = velocity.move_toward(safe_velocity, 100)
	move_and_slide()
	
func make_path(pos: Vector2):
	nav_agent.target_position = pos

func take_damage(amount: float):
	health -= amount
	if health < 0:
		queue_free()
