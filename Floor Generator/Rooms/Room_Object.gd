extends Node2D
class_name RoomObject

# TO BE REPLACED WITH ROOM RANDOMISER CLASS / RESOURCE
var room: PackedScene = preload("res://Floor Generator/Rooms/Room_Default.tscn")

func _init(_data: Room_Data, _position: Vector2 = Vector2.ZERO, screen_size: Vector2 = Vector2(1920,1080)) -> void:
	var spacer: Vector2 = Vector2(200, 200)
	
	self.add_to_group("Rooms")
	var room_instance: Node2D = room.instantiate()
	room_instance.position = _position * (screen_size + spacer)
	add_child(room_instance)
	
	for door:Vector2 in _data.doors:
		var new_door: DoorObject = DoorObject.new(door, screen_size)
		room_instance.add_child(new_door)
