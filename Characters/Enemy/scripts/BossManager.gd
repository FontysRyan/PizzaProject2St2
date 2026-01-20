extends CombatManager

@onready var spawn_location : Marker2D = $Marker2D

func _spawn_enemies(_player: Node2D) -> void:
	print(
		"Room:", self,
		"Marker parent:", spawn_location.get_parent()
	)

	var enemy = pick_weighted_enemy().instantiate()
	print(enemy.name)
	enemy.position = spawn_location.position

	add_child(enemy)
	enemies_alive = 1
	enemy.connect("tree_exited", _on_enemy_removed)
