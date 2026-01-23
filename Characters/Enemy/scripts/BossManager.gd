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

func _on_enemy_removed() -> void:
	enemies_alive -= 1
	if enemies_alive <= 0:
		if get_tree():
			for enemy in get_tree().get_nodes_in_group("Mini_Slime"):
				enemy.queue_free()
			cleared = true
			active = false
			unlock_doors.emit()
