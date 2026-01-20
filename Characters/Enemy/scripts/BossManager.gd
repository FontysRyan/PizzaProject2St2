extends CombatManager

@onready var spawn_location : Marker2D = $Marker2D

func _spawn_enemies(_player: Node2D) -> void:
	var enemy = pick_weighted_enemy()
	enemy.global_position = spawn_location

	add_child(enemy)
	enemies_alive = 1
	enemy.connect("tree_exited", _on_enemy_removed)
