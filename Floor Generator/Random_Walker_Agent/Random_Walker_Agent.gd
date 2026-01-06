extends Resource
class_name WalkerAgent

"""
An agent must choose between one of four actions to perform: 
 - Go left
 - Go right
 - Go forward
 - End
These actions should have a bias/weight, so behaviour can be more closely controlled

Additionally, an agent has the chance to spawn a new agent at their position
These child-agents should have either a lower or no chance to spawn additional agents
The above might be implemented as a setting for the agent
"""

# SIGNALS
signal child_created(child: WalkerAgent)

# PRIVATE VARIABLES
var random: RandomNumberGenerator = RandomNumberGenerator.new()
var position: Vector2 = Vector2.ZERO
var rotation: float = 0.0

# BEHAVIOUR VARIABLES
var possible_actions: Dictionary[String, WalkerAction] = {
	"left": 	WalkerAction.new(3, move_left),
	"right": 	WalkerAction.new(3, move_right),
	"forward": 	WalkerAction.new(3, move_forward),
	"end": 		WalkerAction.new(0, end),
	}
var actions: WalkerActionContainer = WalkerActionContainer.new(possible_actions)

var child_spawn_chance: float = 0.1
var child_recurrsion_factor: float = 0.1
var end_weight_increase: float = 0.5

var start_position: Vector2 = Vector2.ZERO

func _init	(_weights: Dictionary = {}, 
			_child_spawn_chance: float = 0.1,
			_child_recurrsion_factor: float = 0.1,
			_end_weight_increase: float = 0.5,
			_start_position: Vector2 = Vector2.ZERO
			) -> void:
	
	self.child_spawn_chance = _child_spawn_chance
	self.child_recurrsion_factor = _child_recurrsion_factor
	self.end_weight_increase = _end_weight_increase
	self.start_position = _start_position
	self.position = _start_position
	
	self.rotation = random.randi_range(0, 3) * 0.5 * PI
	
	if _weights.is_empty() or _weights.size() < possible_actions.size(): return
	
	for key in possible_actions:
		possible_actions[key].weight = _weights[key]

func generate_next_action(_set_index: float = 0) -> Vector2:
	var index: float = _set_index
	if not index:
		index = random.randf_range(1.0, actions.WEIGHTS_TOTAL)
	
	var action: WalkerAction = actions.get_action_from_weight_index(index)
	if action: action.action.call()
		
	return self.position

func move_left() -> Vector2:
	self.rotation -= PI*0.5
	self.position += move_in_direction()
	return self.position
	
func move_right() -> Vector2:
	self.rotation += PI*0.5
	self.position += move_in_direction()
	return self.position
	
func move_forward() -> Vector2:
	self.position += move_in_direction()
	return self.position
	
func end() -> Vector2:
	return self.position
	
func raise_end_chance() -> void:
	var end_action: WalkerAction = self.actions.action_list["end"]
	if end_action:
		self.actions.modify_action_weight("end", end_action.weight + end_weight_increase)
	
func move_in_direction() -> Vector2:
	var direction = self.rotation
	var move_direction = Vector2(round(cos(direction)), round(sin(direction)))
	
	raise_end_chance()
	
	return move_direction

func create_child_agent() -> WalkerAgent:
	var child_child_spawn_chance: float = self.child_spawn_chance * self.child_recurrsion_factor
	var child: WalkerAgent = WalkerAgent.new({}, child_child_spawn_chance, 
											self.child_recurrsion_factor, self.end_weight_increase, 
											self.position)
	return child
	
func roll_child_agent() -> void:
	if random.randf() < self.child_spawn_chance:
		child_created.emit(create_child_agent())
