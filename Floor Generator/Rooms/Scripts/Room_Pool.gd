extends Resource
class_name RoomPool

var id: String = "null"
var conditions: Dictionary
var priority: int = 0
var rooms: Array = []

func _init(_id: String, _conditions: Dictionary, _priority: int, _rooms: Array) -> void:
	id = _id
	conditions = _conditions
	priority = _priority
	rooms = _rooms
	
func get_random_room() -> String:
	var random: RandomNumberGenerator = RandomNumberGenerator.new()
	return rooms[random.randi_range(0, rooms.size()-1)]
