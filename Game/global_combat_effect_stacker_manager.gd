extends Node
class_name effectManager

# Tracks all active effects
var active_effects: Array = []

# How often the manager updates (seconds)
var tick_rate: float = 0.1
var timer: Timer

func _ready():
	# Create and start a timer to process effects automatically
	timer = Timer.new()
	timer.wait_time = tick_rate
	timer.one_shot = false
	timer.autostart = true
	add_child(timer)
	timer.connect("timeout", Callable(self, "_on_tick"))

func _on_tick():
	process(tick_rate)

# Add a new effect to a target
func add_effect(effect: SpecialMode, target, caster = null):
	if not effect:
		return
	# Check target is valid
	if not is_instance_valid(target):
		print("Cannot add effect", effect.name, "– target is invalid.")
		return
	if "health" in target and target.health <= 0:
		print("Cannot add effect", effect.name, "– target is dead.")
		return

	# Check for existing instance
	var existing = null
	for e in active_effects:
		if e.effect.id == effect.id and e.target == target:
			existing = e
			break
	
	if existing:
		if effect.max_stacks == 0 or existing.stacks < effect.max_stacks:
			existing.stacks += 1
			print(target.name, "stack of", effect.name, "increased to", existing.stacks)
		existing.remaining_duration = effect.duration
	else:
		var instance = {
			"effect": effect,
			"target": target,
			"caster": caster,
			"stacks": 1,
			"elapsed": 0.0,
			"remaining_duration": effect.duration
		}
		active_effects.append(instance)
		print(target.name, "gained effect", effect.name)
		# ADD THIS: If this is vampirism, try to apply bleeding to the caster (enemy)
# Check vampirism AFTER adding/stacking - 25% chance to apply bleeding
	if "vampire" in effect.tags and effect.secondary_effect:
		if randf() < effect.secondary_chance:  # 25% chance
			if is_instance_valid(caster) and caster.is_in_group("Enemy"):
				print("Vampirism applied bleeding to ", caster.name)
				add_effect(effect.secondary_effect, caster, target)
		else:
			print("Vampirism bleeding chance failed (25%)")

# Called internally by timer
func process(delta):
	for instance in active_effects.duplicate():
		if not is_instance_valid(instance.target):
			remove_effect(instance)
			continue

		var e = instance.effect
		instance.elapsed += delta

		if e.tick_interval > 0 and instance.elapsed >= e.tick_interval:
			apply_tick(instance)
			instance.elapsed = 0.0

		if e.duration > 0:
			instance.remaining_duration -= delta
			if instance.remaining_duration <= 0:
				remove_effect(instance)


# Apply effect to the target (prints only)
func apply_tick(instance):
	var e = instance.effect
	var t = instance.target
	if not is_instance_valid(t):
		remove_effect(instance)
		return
	
	var stacks = instance.stacks
	var power = stacks * e.base_stack_power
	
	var hp

	# Damage
	if e.flat_damage > 0 or e.percent_max_hp_damage > 0:
		if t.is_in_group("Player"):
			hp = t.stats.current_health
		elif t.is_in_group("Enemy"):
			hp = t.health
		var damage = e.flat_damage * power + hp * e.percent_max_hp_damage * power
		DamageNumberManager.show_damage(damage, t.global_position + Vector2(0, -90))
		t.take_damage(damage)
		print(t.name, " has taken ", damage, " damage from ", e.name)
		
		# ADD THIS: If this is bleeding, check if player has vampirism
		if "bleeding" in e.tags:
			var player = get_tree().get_first_node_in_group("Player")
			if is_instance_valid(player):
				# Check if player has vampirism
				for vamp_inst in active_effects:
					if vamp_inst.target == player and "vampire" in vamp_inst.effect.tags:
						var vamp = vamp_inst.effect
						# Heal player with flat healing
						if vamp.percent_max_hp_heal > 0:
							var heal_amount = player.stats.max_health * vamp.percent_max_hp_heal
							player.stats.current_health = min(player.stats.current_health + heal_amount, player.stats.max_health)
							DamageNumberManager.show_damage(heal_amount, player.global_position + Vector2(0, -90))
							print(player.name, " healed for ", heal_amount, " (", vamp.percent_max_hp_heal * 100, "% of max HP) from vampirism")
							Stats.current_health = player.stats.current_health
							print(player.stats.current_health)
						break
	# Healing
	if e.flat_heal > 0 or e.percent_max_hp_heal > 0:
		var heal_target = t
		if e.secondary_target == SpecialMode.TargetType.SELF and is_instance_valid(instance.caster):
			heal_target = instance.caster
		if not is_instance_valid(heal_target):
			return
		var heal_amount = e.flat_heal * power + heal_target.max_hp * e.percent_max_hp_heal * power
		print(heal_target.name, "has been healed for", heal_amount, "by", e.name)

	# Stun / Slow
	if e.stun_duration > 0:
		print(t.name, "is stunned for", e.stun_duration * power, "seconds by", e.name)
	if e.slow_multiplier != 1.0:
		print(t.name, "is slowed by multiplier", pow(e.slow_multiplier, power), "from", e.name)

	# Secondary effect
	print("Secondary chance: ", e.secondary_chance * power)
	if e.secondary_effect and randf() < e.secondary_chance * power:
		add_effect(e.secondary_effect, t, instance.caster)
		print(t.name, " has triggered secondary effect ", e.secondary_effect.name)


# Remove effect instance
func remove_effect(instance):
	var t = instance.target
	if is_instance_valid(t):
		print(t.name, "effect", instance.effect.name, "has ended")
	active_effects.erase(instance)
