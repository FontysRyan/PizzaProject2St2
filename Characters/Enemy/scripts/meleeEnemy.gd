extends base_enemy
class_name melee_enemy

func _ready():
	scale = Vector2(0.2, 0.2)
	super._ready()

func attack(target: CharacterBody2D):
	if attack_cooldown > 0 or is_attacking:
		return
	is_attacking = true
	attack_cooldown = attack_speed
	if anim_player != null:
		anim_player.play("attack")
		await anim_player.animation_finished
	if not global_position.distance_to(target.global_position) <= stop_distance:
		is_attacking = false
		return
	if target.has_method("take_damage"):
		target.take_damage(damage)
		DamageNumberManager.show_damage(damage, target.global_position)
	else:
		print("target cannot take damage :(")
	is_attacking = false
