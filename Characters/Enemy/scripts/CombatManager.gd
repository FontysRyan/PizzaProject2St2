extends Node2D
class_name CombatManager

signal lock_doors
signal unlock_doors

@export var enemy_scenes : Array[PackedScene]
@export var enemy_count : int = 5

var enemies_alive : int = 0
var cleared : bool = false
var active : bool = false

# replace this with actual logic for when the player enters the room. need to wait with this
#func activate(player: Node2D) -> void:
	#if cleared or active:
		#return
	#
	#active = true
	#emit_signal("lock_doors")
	#_spawn_enemies(player)

func _spawn_enemies(player : Node2D) -> void:
	var nav_map : NavigationRegion2D = get_node("NavMesh2D")
	if not nav_map:
		print("could not find nav map")
		return
	
	for i in enemy_count:
		var enemy = enemy_scenes.pick_random().instantiate()
		
		var pos : Vector2 = _get_valid_nav_position(nav_map, player)
		enemy.global_position = pos
		
		add_child(enemy)
		enemies_alive += 1
		enemy.connect("tree_exited", _on_enemy_removed)

func _get_valid_nav_position(nav_map : RID, player : Node2D) -> Vector2:
	for _1 in 20:
		var candidate : Vector2 = global_position + Vector2(
			randf_range(-200, 200),
			randf_range(-200, 200)
		)
		
		var nav_point : Vector2 = NavigationServer2D.map_get_closest_point(
			nav_map,
			candidate
		)
		
		if nav_point.distance_to(candidate) > 32:
			continue
		
		if nav_point.distance_to(player.global_position) < 96:
			continue
		
		return candidate
	return global_position

func _on_enemy_removed() -> void:
	enemies_alive -= 1
	if enemies_alive <= 0:
		cleared = true
		active = false
		emit_signal("unlock_doors")
