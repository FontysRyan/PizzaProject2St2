extends Resource
class_name RoomObject

var default_room_path: String = "res://Floor Generator/Rooms/Presets/Room_Default.tscn"

func _init(_data: Room_Data, _room_scene_path: String = default_room_path, screen_size: Vector2 = Vector2(1920,1080)) -> void:
	# TEMP...?
	var spacer: Vector2 = Vector2(200, 200)
	
	var room_instance: Node2D = load(_room_scene_path).instantiate()
	room_instance.add_to_group("Rooms")
	room_instance.position = _data.grid_position * (screen_size + spacer)
	room_instance.name = "(" + str(floori(_data.grid_position.x)) + "," + str(floori(_data.grid_position.y)) + ")"
	_data.parent_node.add_child(room_instance)
	
	for door:Vector2i in _data.doors:
		var door_position: Vector2i = room_instance.get_meta("DoorPositions")[door]
		var new_door: DoorObject = DoorObject.new(door, door_position, _data.grid_position, spacer)
		room_instance.add_child(new_door)
