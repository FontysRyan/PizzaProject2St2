extends boss

@export var mini_slime : PackedScene
@export var mini_slimes_to_spawn : int = 3
@export var spawn_radius : float = 500.0
@export var max_mini_slimes : int = 12

var stored_balls : Array[Base_Ball] = []
var damage_absorbed : float

func _ready() -> void:
	scale = Vector2(0.5, 0.5)
	super._ready()
	add_to_group("Slime_Boss")

func use_ability():
	var current := get_tree().get_nodes_in_group("Mini_Slime").size()
	var allowed := max_mini_slimes - current
	if allowed <= 0:
		return
	
	for i in range(min(mini_slimes_to_spawn, allowed)):
		var slime := mini_slime.instantiate()
		slime.add_to_group("Mini_Slime")
		slime.scale = Vector2(0.2, 0.2)
		get_parent().add_child(slime)
		
		var angle := TAU * i / mini_slimes_to_spawn
		slime.global_position = to_global(Vector2(
			cos(angle),
			sin(angle)
		) * spawn_radius)
		
		if slime.has_method("retarget"):
			slime.retarget()

# uncomment if you feel like making this shit work. currently absorbing does not work and we wont fix it

#func take_damage(amount: float, _damage_source: Base_Ball = null):
	#if not _damage_source:
		#return
	#
	#damage_absorbed += amount
	#
	#stored_balls.append(_damage_source)
	#_damage_source.set_collision_mask_value(6, false)
	#_damage_source.global_position = global_position
	#_damage_source.velocity = 0

#func take_knockback(force: float, location_of_origin: Vector2, _type: knockback_source):
	#if _type == knockback_source.BALL:
		#return
	#elif _type == knockback_source.STICK:
		#super.take_knockback(force, location_of_origin, _type)
		#if stored_balls.size() > 0:
			#for i in range(stored_balls.size()):
				#var angle := TAU * i / stored_balls.size()
				#var ball = stored_balls[i]
				#ball.global_position = global_position + Vector2(
					#cos(angle),
					#sin(angle)
				#) * spawn_radius
				#ball.velocity = angle * 500
			#stored_balls.clear()
			#super.take_damage(damage_absorbed)

func attack(target: CharacterBody2D):
	if not target:
		return
	if attack_cooldown > 0 or is_attacking:
		return
	is_attacking = true
	attack_cooldown = attack_speed
	is_attacking = true
	if target.has_method("take_damage"):
		target.take_damage(damage)
		DamageNumberManager.show_damage(damage, target.global_position)
	else:
		print("target cannot take damage :(")
	is_attacking = false
