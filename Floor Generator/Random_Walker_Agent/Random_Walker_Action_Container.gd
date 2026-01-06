extends Resource
class_name WalkerActionContainer

var action_list: Dictionary[String, WalkerAction] = {}

var ACTIONS: Dictionary[Array, WalkerAction] = {}
var actions: Dictionary[Array, WalkerAction] = self.ACTIONS:
	get: return self.ACTIONS
	set(_actions): self.ACTIONS = _actions 
	
var WEIGHTS_TOTAL: float = 0:
	get: return WEIGHTS_TOTAL

func _init(_actions: Dictionary[String, WalkerAction]) -> void:
	set_actions(_actions)
	
func set_actions(_action_list: Dictionary[String, WalkerAction]) -> void:
	self.action_list = _action_list
	assign_weights()

func add_action(_key: String, _action: WalkerAction) -> void:
	if not self.action_list.has(_key):
		self.action_list[_key] = _action
	assign_weights()
	
func remove_action(key: String) -> void:
	if self.action_list.has(key):
		self.action_list.erase(key)
		assign_weights()
		
func replace_action(key: String, _new_action: WalkerAction) -> void:
	if self.action_list.has(key):
		self.action_list[key] = _new_action
		
func modify_action_weight(key: String, _weight: float) -> void:
	if self.action_list.has(key):
		self.action_list[key].weight = _weight
		assign_weights()
		
func modify_action_call(key: String, _call: Callable) -> void:
	if self.action_list.has(key):
		self.action_list[key].action = _call
	
func get_action(_key: String) -> WalkerAction:
	if self.action_list.has(_key):
		return self.action_list[_key]
	else:
		return null
		
func assign_weights() -> void:
	var new_actions: Dictionary[Array, WalkerAction] = {}
	self.WEIGHTS_TOTAL = 0
	
	for key in self.action_list:
		var action: WalkerAction = self.action_list[key]
		if action.weight > 0:
			var weight_range: Array[float] = [self.WEIGHTS_TOTAL, self.WEIGHTS_TOTAL + action.weight]
			
			new_actions[weight_range] = action
			self.WEIGHTS_TOTAL += action.weight
			
	self.actions = new_actions
	
func get_action_from_weight_index(_index: float):
	for index_range in ACTIONS:
		if _index >= index_range.min() and _index < index_range.max():
			return ACTIONS[index_range]
	return null	
