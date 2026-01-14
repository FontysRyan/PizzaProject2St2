extends Resource
class_name RoomPoolManager

var room_pools: Dictionary[String, RoomPool]
var ordered_pools: Array[RoomPool] = []

func _init(pools_json_location: String) -> void:
	var json: JSON = JSON.new()
	var pools_json: String = FileAccess.open(pools_json_location, FileAccess.READ).get_as_text()
	var pools: Dictionary = json.parse_string(pools_json)

	for pool in pools.room_pools:
		var new_pool := RoomPool.new(pool.id, pool.conditions, pool.priority, pool.rooms)
		room_pools[new_pool.id] = new_pool
		ordered_pools.append(new_pool)

	ordered_pools.sort_custom(
		func(a: RoomPool, b: RoomPool) -> bool:
			return a.priority > b.priority)

func build_context(data: Room_Data) -> Dictionary:
	return {
		"grid_position": data.grid_position,
		"doors": data.doors,
		"door_count": data.doors.size(),
		"random_roll": RandomNumberGenerator.new().randi_range(0, 100)
	}

func check_condition(key: String, value, ctx: Dictionary) -> bool:
	# Missing some keys, will give warnings
	match key:
		"position_equals":
			return ctx.grid_position == Vector2(value[0], value[1])

		"door_count_gte":
			return ctx.door_count >= int(value)
			
		"door_count_lte":
			return ctx.door_count <= int(value)
			
		"roll_chance":
			return ctx.random_roll <= int(value)

		_:
			push_warning("Unknown condition: %s" % key)
			return false

func pool_matches(pool: RoomPool, ctx: Dictionary) -> bool:
	for key in pool.conditions.keys():
		if not check_condition(key, pool.conditions[key], ctx):
			return false
	return true
	
func generate_room_from_data(room_data: Room_Data, room_counts: Dictionary[String, int]) -> Array[String]:
	var ctx := build_context(room_data)

	for pool in ordered_pools:
		if pool_matches(pool, ctx):
			return [pool.get_random_room(), pool.id]

	push_error("No valid room pool found")
	return [""]
