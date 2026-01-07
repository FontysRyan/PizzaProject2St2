extends Resource
class_name RoomObject

var default_room_path: String = "res://Floor Generator/Rooms/Presets/Room_Default.tscn"

func _init(_data: Room_Data, _room_scene_path: String = default_room_path, screen_size: Vector2 = Vector2(1920,1080)) -> void:
	# TEMP
	var spacer: Vector2 = Vector2(200, 200)
	
	var room_instance: Node2D = load(_room_scene_path).instantiate()
	room_instance.add_to_group("Rooms")
	room_instance.position = _data.grid_position * (screen_size + spacer)
	_data.parent_node.add_child(room_instance)
	
	for door:Vector2 in _data.doors:
		var new_door: DoorObject = DoorObject.new(door, screen_size)
		room_instance.add_child(new_door)
