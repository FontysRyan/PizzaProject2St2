extends boss

@export var ability_range : float = 100
@export var special_modes : Array[SpecialMode]

func _ready():
	scale = Vector2(0.5, 0.5)
	super._ready()

func attack(target: CharacterBody2D):
	if not target:
		return
	if attack_cooldown > 0 or is_attacking:
		return
	is_attacking = true
	attack_cooldown = attack_speed
	anim_player.play("attack")
	await anim_player.animation_finished
	if not global_position.distance_to(target.global_position) <= stop_distance:
		is_attacking = false
		return
	if target.has_method("take_damage"):
		target.take_damage(damage)
		DamageNumberManager.show_damage(damage, target.global_position)
		CombatEffectStackerManager.add_effect(special_modes[0], target, self)
	else:
		print("target cannot take damage :(")
	is_attacking = false

func use_ability():
	is_attacking = true
	anim_player.play("attack")
	anim_player.speed_scale = 0.6
	await anim_player.animation_finished
	anim_player.speed_scale = 1
	if global_position.distance_to(player.global_position) <= ability_range*10:
		player.take_damage(damage/2)
		DamageNumberManager.show_damage(damage, player.global_position, "crit")
		CombatEffectStackerManager.add_effect(special_modes[0], player, self)
		CombatEffectStackerManager.add_effect(special_modes[1], player, self)
		print("apply bleed effect!!!!!!!!!!!!!!!!!!!!!")
	attack_cooldown = attack_speed
	is_attacking = false
