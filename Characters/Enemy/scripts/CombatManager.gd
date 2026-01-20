extends Node2D
class_name CombatManager

signal lock_doors
signal unlock_doors

@export var enemy_scenes : Array[EnemyWeights]
@export var enemy_count : int = 5

var enemies_alive : int = 0
var cleared : bool = false
var active : bool = false

func activate(player: Node2D) -> void:
	if cleared or active:
		return
	
	active = true
	lock_doors.emit()
	_spawn_enemies(player)

func _spawn_enemies(player : Node2D) -> void:
	var nav_map : NavigationRegion2D = get_node("NavMesh2D")
	if nav_map == null:
		print("could not find nav map")
		return
	
	for i in enemy_count:
		var enemy = pick_weighted_enemy()
		print(enemy.name)
		
		var pos : Vector2 = _get_valid_nav_position(nav_map.get_navigation_map(), player)
		enemy.global_position = pos
		
		add_child(enemy)
		enemies_alive += 1
		enemy.connect("tree_exited", _on_enemy_removed)

func pick_weighted_enemy() -> PackedScene:
	var total_weight := 0.0
	for entry in enemy_scenes:
		total_weight += entry.weight

	var r := randf() * total_weight
	for entry in enemy_scenes:
		r -= entry.weight
		if r <= 0.0:
			return entry.scene

	return enemy_scenes[-1].scene

func _get_valid_nav_position(nav_map : RID, player : Node2D) -> Vector2:
	for i in range(20):
		var candidate : Vector2 =  get_viewport_rect().size/2 + Vector2(
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
		unlock_doors.emit()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		call_deferred("activate" ,body)
