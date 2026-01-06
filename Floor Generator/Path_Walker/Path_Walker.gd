extends Resource
class_name Path_Walker

static func place_rooms(paths : Dictionary[WalkerAgent, Array]) -> Dictionary[Vector2, Room_Data]: 
	var room_list: Dictionary[Vector2, Room_Data] = {
		Vector2.ZERO: Room_Data.new()
	}
	
	for agent: WalkerAgent in paths:
		var path: Array = paths[agent]
		var prev_position: Vector2 = agent.start_position
		
		for position in path:
			var door_exit: Vector2 = position - prev_position
			var door_entrance: Vector2 = -door_exit
			
			var prev_room: Room_Data = room_list.get_or_add(prev_position, Room_Data.new())
			var current_room: Room_Data = room_list.get_or_add(position, Room_Data.new())
			prev_room.add_door(door_exit)
			current_room.add_door(door_entrance)
				
			prev_position = position
			
	return room_list
