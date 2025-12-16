extends CharacterBody2D

@export var lifetime : float = 10.0
var damage : float
var direction : Vector2
var speed : float

func _physics_process(delta: float) -> void:
	lifetime -= delta
	if lifetime <= 0:
		queue_free()
	var collision = move_and_collide(velocity * delta)
	if collision:
		if collision.get_collider().has_method("take_damage"):
			collision.get_collider().take_damage(10)
		queue_free()
