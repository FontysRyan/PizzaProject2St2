extends CharacterBody2D

@onready var nav_agent : NavigationAgent2D = $"NavigationAgent2D"
@export var speed : float = 200
@export var health : float = 50
var in_range : bool = false
var player : Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Nav map:", NavigationServer2D.get_maps().size())
	nav_agent.navigation_finished.connect(_on_nav_finished)
	
	await NavigationServer2D.map_changed
	
	var players = get_tree().get_nodes_in_group("Player")
	if players.size() > 0:
		player = players[0]
		make_path(player.global_position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if not player:
		print("no player")
		return
	
	print("Reachable:", nav_agent.is_target_reachable())
	print("Distance:", nav_agent.distance_to_target())
	
	nav_agent.target_position = player.global_position

	if nav_agent.is_target_reachable():
		var next_pos = nav_agent.get_next_path_position()
		var dir = (next_pos - global_position).normalized()
		velocity = dir * speed
		move_and_slide()

func _on_nav_finished():
	in_range = true

func make_path(pos: Vector2):
	nav_agent.target_position = pos

func take_damage(amount: float):
	health -= amount
	if health <= 0:
		queue_free()
