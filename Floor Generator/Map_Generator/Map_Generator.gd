extends Node2D
class_name MapGenerator

var walker_manager: WalkerManager = WalkerManager.new()
var paths: Dictionary[WalkerAgent, Array] = {}

var room_pool_manager: RoomPoolManager = RoomPoolManager.new("res://Floor Generator/Rooms/Data/Room_Pools_Data.json")
	
func generate_walker_map(initial_agents: int = 3, agent_data: Dictionary[String, Variant] = {}) -> Dictionary[WalkerAgent, Array]:
	paths = walker_manager.generate_paths(initial_agents, agent_data)
	var data: Dictionary[String, Variant] = walker_manager.get_map_data(paths)
	return paths

func generate_rooms(paths_data: Dictionary[WalkerAgent, Array]) -> Dictionary[Vector2, Room_Data]:
	var rooms = Path_Walker.place_rooms(paths_data, self)
	return rooms

func generate_floor() -> void:
	var old_rooms = get_tree().get_nodes_in_group("Rooms")
	for room in old_rooms:
		room.name = "Room_Delete" # Not doing this blocks new names because of duplicates
		room.queue_free()
	
	var new_rooms: Dictionary[Vector2, Room_Data] = generate_rooms(generate_walker_map())
	
	for room in new_rooms:
		var room_data: Room_Data = new_rooms[room]
		var room_location_string: String = room_pool_manager.generate_room_from_data(room_data)
		RoomObject.new(room_data, room_location_string, get_viewport_rect().size)
