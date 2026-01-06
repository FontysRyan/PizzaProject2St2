extends base_enemy

@export var projectile : PackedScene
@export var attack_amount : float = 1 # only if we ever want to use this, we dont plan on it for now
@export var projectile_speed : float = 500

func attack(target: CharacterBody2D):
	if attack_cooldown <= 0:
		attack_cooldown = attack_speed
		var i = 0
		while i < attack_amount:
			#anim_player.play("attack")
			#await anim_player.animation_finished
			
			var fired_projectile = projectile.instantiate()
			
			fired_projectile.position = global_position + Vector2(0, 5)
			fired_projectile.scale = Vector2(0.2, 0.2)
			var direction = (target.global_position - fired_projectile.position).normalized()
			fired_projectile.damage = damage
			
			get_parent().add_child(fired_projectile)
			
			fired_projectile.velocity = direction * projectile_speed
			fired_projectile.rotation = direction.angle()
			
			await get_tree().create_timer(0.1).timeout
			i+=1
