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

func build_context(data: Room_Data, room_counts: Dictionary[String, int], total_rooms: int) -> Dictionary:
	return {
		"grid_position": data.grid_position,
		"doors": data.doors,
		"door_count": data.doors.size(),
		"random_roll": RandomNumberGenerator.new().randi_range(1, 100),
		"room_counts": room_counts,
		"total_rooms": total_rooms
	}


func check_condition(key: String, value, ctx: Dictionary, pool_id: String) -> bool:
	var count: int = ctx.room_counts.get(pool_id, 0)
	var current_rooms: int = 0
	for room in ctx.room_counts:
		current_rooms += ctx.room_counts[room]

	match key:
		"position_equals":
			return ctx.grid_position == Vector2(value[0], value[1])

		"door_count_gte":
			return ctx.door_count >= int(value)

		"door_count_lte":
			return ctx.door_count <= int(value)

		"guaranteed_roll_chance":
			var exp: float = 5.0 # How far back do we push the special rooms
			var special_rooms: int = 2
			var treshold: float = pow((float(current_rooms) + special_rooms)/ctx.total_rooms, exp) * 100
			print(pool_id + " chance: " + str(treshold))
			return ctx.random_roll <= treshold

		"roll_chance":
			return ctx.random_roll <= int(value)

		"min_instances":
			return count < int(value)

		"max_instances":
			return count < int(value)

		_:
			push_warning("Unknown condition: %s" % key)
			return false


func pool_matches(pool: RoomPool, ctx: Dictionary) -> bool:
	for key in pool.conditions.keys():
		if not check_condition(key, pool.conditions[key], ctx, pool.id):
			return false
	return true

	
func generate_room_from_data(room_data: Room_Data, room_counts: Dictionary[String, int], total_rooms: int) -> Array[String]:
	var ctx := build_context(room_data, room_counts, total_rooms)

	for pool in ordered_pools:
		if pool_matches(pool, ctx):
			return [pool.get_random_room(), pool.id]

	push_error("No valid room pool found")
	return [""]
