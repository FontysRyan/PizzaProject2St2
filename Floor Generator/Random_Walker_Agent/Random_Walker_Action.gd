extends Resource
class_name WalkerAction

var WEIGHT: float = 0
var weight: float = self.WEIGHT:
	get: return self.WEIGHT
	set(_weight): set_weight(_weight)

var ACTION: Callable
var action: Callable = self.ACTION:
		get: return self.ACTION
		set(_action): set_action(_action)

func _init(_weight: float, _action: Callable):
	if _weight >= 0:
		self.WEIGHT = _weight
	else:
		self.WEIGHT = 1
	self.ACTION = _action

func set_weight(_weight: float) -> void:
	if _weight >= 0:
		self.WEIGHT = _weight
	
func set_action(_action: Callable) -> void:
	self.ACTION = _action
