extends Resource
class_name Room_Data

var doors: Array[Vector2i] = []:
	get: return doors
	set(_door): pass
	
var parent_node: Node2D
var grid_position: Vector2 = Vector2.ZERO

func _init(_parent_node: Node2D, _grid_position: Vector2 = Vector2.ZERO) -> void:
	parent_node = _parent_node
	grid_position = _grid_position

func add_door(door_position: Vector2i):
	if not doors.has(door_position) and door_position != Vector2i.ZERO && door_position.length_squared() <= 1: 
		doors.append(door_position)
