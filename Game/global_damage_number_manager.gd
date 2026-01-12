extends Node


const DAMAGE_NUMBER_SCENE := preload("res://Scenes/Damage_number_label.tscn")

func show_damage(
	amount: int,
	world_position: Vector2,
	damage_type: String = "normal"
) -> void:
	var dmg = DAMAGE_NUMBER_SCENE.instantiate()
	get_tree().current_scene.add_child(dmg)
	dmg.global_position = world_position
	dmg.setup(amount, damage_type)
