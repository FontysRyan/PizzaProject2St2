extends Resource
class_name Room_Data

var doors: Array[Vector2] = []:
	get: return doors
	set(_door): pass

func add_door(door_position: Vector2):
	if not doors.has(door_position) and door_position != Vector2.ZERO: 
		doors.append(door_position)
