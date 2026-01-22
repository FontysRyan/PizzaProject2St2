extends base_enemy
class_name boss

@onready var timer : Timer = Timer.new()

func _ready() -> void:
	add_to_group("Boss")
	super._ready()
	timer.one_shot = false
	add_child(timer)
	timer.wait_time = stats.ability_cooldown
	timer.autostart = true
	timer.timeout.connect(use_ability)
	timer.start()

func use_ability():
	print("no ability implemented")

func take_damage(amount: float, _damage_source: Base_Ball = null):
	health -= amount
	if health <= 0:
		queue_free()
		on_death()

func on_death():
	GameController.boss_killed = true
	Stats.bosses_killed += 1
	var room = get_parent()
	var chest = Chest.new()
	chest.set_type(Chest.ChestType.STICK)
	chest.position = self.position
	room.add_child(chest)
	self.queue_free()
