extends base_enemy


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func attack(target: CharacterBody2D):
	if attack_cooldown <= 0:
		attack_cooldown = attack_speed
		if target.has_method("take_damage"):
			target.take_damage(damage)
		else:
			print("target cannot take damage :(")
