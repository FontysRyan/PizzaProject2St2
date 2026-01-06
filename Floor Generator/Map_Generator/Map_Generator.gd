extends Node2D
class_name MapGenerator

var walker_manager: WalkerManager = WalkerManager.new()
var paths: Dictionary[WalkerAgent, Array] = {}
	
func generate_walker_map(initial_agents: int = 3, agent_data: Dictionary[String, Variant] = {}) -> Dictionary[WalkerAgent, Array]:
	paths = walker_manager.generate_paths(initial_agents, agent_data)
	var data: Dictionary[String, Variant] = walker_manager.get_map_data(paths)
	return paths

func generate_rooms(paths_data: Dictionary[WalkerAgent, Array]) -> Dictionary[Vector2, Room_Data]:
	var rooms = Path_Walker.place_rooms(paths_data)
	return rooms

func generate_floor() -> void:
	var old_rooms = get_tree().get_nodes_in_group("Rooms")
	#print("Removing ", old_rooms.size(), " Rooms") 
	for room in old_rooms:
		room.name = "Room_Delete" # Not doing this blocks new names because of duplicates
		room.queue_free()
	
	var new_rooms: Dictionary[Vector2, Room_Data] = generate_rooms(generate_walker_map())
	#print("Building ", rooms.size(), " Rooms")
	
	var room_index: int = 0
	for room in new_rooms:
		var room_data: Room_Data = new_rooms[room]
		var new_room = RoomObject.new(room_data, room, get_viewport_rect().size)
		new_room.name = "Room_" + str(room_index)
		add_child(new_room)
		
		room_index += 1
