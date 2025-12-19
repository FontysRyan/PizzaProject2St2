extends base_enemy

func attack(target: CharacterBody2D):
	if attack_cooldown <= 0:
		attack_cooldown = attack_speed
		#anim_player.play("attack")
		#await anim_player.animation_finished
		if target.has_method("take_damage"):
			target.take_damage(damage)
		else:
			print("target cannot take damage :(")
