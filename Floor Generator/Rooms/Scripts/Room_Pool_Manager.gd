extends Resource
class_name RoomPoolManager

var room_pools: Dictionary[String, RoomPool]

func _init(pools_json_location: String) -> void:
	var json: JSON = JSON.new()
	var pools_json: String = FileAccess.open(pools_json_location, FileAccess.READ).get_as_text()
	var pools: Dictionary = json.parse_string(pools_json)

	for pool in pools.room_pools:
		var new_pool: RoomPool = RoomPool.new(pool.id, pool.conditions, pool.priority, pool.rooms)
		room_pools.get_or_add(new_pool.id, new_pool)
		
		room_pools.sort()

func generate_room_from_data(room_data: Room_Data) -> String:
	# This is all fucked, it needs to be redone from the ground up
	# So I am just hardcoding this shit I guess
	# Will fix later
	
	if room_data.grid_position == Vector2.ZERO:
		return room_pools["spawn"].get_random_room()
	return room_pools["default"].get_random_room()
