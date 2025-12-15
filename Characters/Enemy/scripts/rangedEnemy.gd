extends base_enemy

@export var projectile : PackedScene
@export var attack_amount : float = 1
@export var projectile_speed : float = 500
@onready var marker : Marker2D = $Marker2D

func attack(target: CharacterBody2D):
	var i = 0
	while i < attack_amount:
		anim_player.play("attack")
		await anim_player.animation_finished
		
		var fired_projectile = projectile.instantiate()
		
		fired_projectile.position = marker.position
		fired_projectile.direction = (target.global_position - fired_projectile.position).normalized()
		fired_projectile.set_script("res://Characters/Enemy/scripts/projectile.gd")
		
		get_parent().add_child(fired_projectile)
		
		fired_projectile.velocity = fired_projectile.direction * projectile_speed
		
		await get_tree().create_timer(0.1).timeout
		i+=1
